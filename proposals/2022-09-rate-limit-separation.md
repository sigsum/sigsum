Proposal to eliminate the "shard hint", and make rate limiting an
optional feature based on a authentication of the submitter.

# Background

The purpose of the `shard_hint` is to prevent replay of old log
messages, e.g., copying all leafs from an old log to a newly started
log. The reason that such replay is a problem (and easier for a bad
actor than filling a log with fresh leaves) is the way rate limiting
is done, since it is tied to the same signature that is used by the
submitter to sign the leaf and published by the log. There are two
problems with this:

* The "shard hint" is rather difficult to explain.
* It's a bit ugly to have state needed only for the rate limiting
  mechanism included in the merkle tree.

# Proposal

There are two parts of this proposal:

1. Delete all mention of the `shard_hint`: Delete in the `tree_leaf`
   struct, in the ssh signature name space, in the get-leaves and
   add-leaf methods, and delete the shard interval start and end from
   all log metadata (this may need to be replaced by other metadata
   specifying the planned life-time of the log, i.e., when it is
   planned to stop accepting new entries and switch to read-only mode,
   and when it is planned to also turn down read-only access).

2. Introduce an submission authentication, to which the
   rate-limit is applied. We need to specify the domain-based
   rate-limiting, while leaving open for extensions using other means
   of authentication. The changes for domain based rate limiting is
   specified below.

## Domain-based rate-limit

As before, the submitter will need to generate a key pair, let's call
it the rate-limit key pair, and publish the public key (or possibly the
hash thereof) as a DNS TXT record on a DNS name the submitter
controls, and the left-most label of the name must be '_sigsum_v0'.
However, it is strongly recommended that this keypair is different
from the one used for the leaf signatures to be published by the log,
and it may be stored on a separete machine with looser security
requirements. There is also no need for this key to be long-lived; it
can be rotated as frequently as desired by just adding and removing
corresponding TXT records, in accordance with the DNS ttl settings.

From this key, the submitter creates an authentication token by simply
signing the target log's key hash. The namespace for this signature is
"submit_token:v0@sigsum.org". (Possible extension: Also include a
random nonce/salt, to make it possible to replace token without
replacing the key).

## Custom HTTP header

When rate-limiting is required by the log, the submitter adds a custom
HTTP header to the request, "sigsum-submitter:", followed by the
domain name where the key is registered, a space, and the hex-encoded
token/signature. The log can then lookup the public key in DNS, and
verify the signature (if there are multiple keys in DNS, the log will
try them all up to a limit of, e.g., 10 keys. If the signature is
valid for any of those keys it is accepted, and rate limit is applied
on the domain, e.g., using https://publicsuffix.org/list/ to identify
the appropriate "registered domain".

Possible variants: Include the public key in the header, and store key
hash only in DNS. I see no clear benefit of doing that (but there
would be a size issue if we were using other types of signatures than
ed25519, with larger public keys). A salt/nonce could be added to the
generated token, and published in DNS together with the key. That
would make it possible to revoke a token without also rotating the
rate-limit key pair.

## Modification to tree_leaf

The `tree_leaf`, when the `shard_hint` is deleted, consists of the
following fields:
```
struct tree_leaf_data {
    u8 checksum[32];
    u8 signature[64];
    u8 key_hash[32];
}
```

The signature is based on the `message` which is submitted to, but
not published by, the log. It is signed using ssh format, using sha256
as the hash function, empty reserved string, and namespace
"tree_leaf:v0@sigsum.org". The ssh signature format internally
computes `SHA256(message)`, as part of formatting the data to be signed,
and it is this value that is stored in the leaf's checksum field.

# Security considerations

First, recall that rate limit isn't intended to protect the log server
from arbitrary denial of service attacks to overload the log's
capacity in terms of computational resources or network bandwidth. It
is only intended to enable limiting, per domain, of the rate at which
leaves are added to the merkle tree.

The fixed token imples that there are no way to prevent replay
attacks. There are a couple of reasons that appears fine for this
application.

* The tokens are visible only to submitter and log (and to ensure
  that, submit must use an encrypted channel, e.g., https rather than
  http).

* Including the target log's key hash in the token means that it will
  be rejected if sent anywhere else. So the log can't use it for
  submission to other logs on the submitter's behalf.

If the token is leaked, the remedy is to create a new rate-limit key
pair and token, and delete the DNS record for the old key.

Using a signature that also binds to the particular message has been
considered, and alternative is discussed in more detail below. Current
conclusion is that a fixed token is good enough in this context, since
the value of the token is rather small.

It seems undesirable to add in a nonce provided by the log (which
would be the most solid way to prevent replay attacks), since that
makes the protocol more stateful or interactive. One could add a
timestamp to the token/envelope, so that old tokens expire.

# Appendices (misc notes from related discussions and earlier drafts)

## Digression on the checksum field

The specification of the checksum is a bit convoluted in the current
version of the api document. My current understanding is that the
submitter starts with its `message`. This is signed with ssh format by
the submitter. Message, signature and public key are submitted to the
log, which can then verify the signature. The ssh signature procedure
includes computation of the sha256 hash value `H(message)`, and it's
this value that is stored in the `checksum` field. One implication is
that it is possible to verify the signature given only the leaf and
the public key, but it can't be done easily with the `ssh-keygen`
tool, since that tool really wants the `message` as input.

The sigsum verifier, which has both `message` and the public key at
hand, doesn't really need the `checksum` published by the log. It is
needed by monitors, though: A monitor with interest in a particular
public extracts all logged leafs containing signatures with that key.
If it finds an unexpected entry on the log, it verifies the signature,
and since it doesn't get `message`, it has to verify the signature
based on the published `checksum`. If the signature is valid, that
indicates unauthorized usage of the private key. On the other hand, if
the signature is not valid, that indicates that the log itself is
misbehaving.

## Doing rate-limiting on the HTTP layer

Another options that was considered was to use the HTTP authorization
header. This section documents the alternative proposal, which was
rejected because (i) it's not quite a general sigsum-agnostic
rate-limit anyway, (ii) there are lots of additional details to get
right, to fit well in the HTTP protocol, (iii) generalization implies
a much broader scope.

```
Authorization: sigsum-rate-limit domain=... public_key=...
  signature=...
```

In that case, the signature should be over the log's key hash + body
of the HTTP request (taking transfer encoding into account). If we can
do rate-limiting on the HTTP level like this, it makes things rather
flexible:

* Logs can use other means of HTTP authentication if they so desire,
  e.g,., basic or digest authentication, client tls certificates,
  secret cookie values, ...

* Rate limit can be applied to other requests than add-leaf, if needed.

* Rate-limiting could be implemented in an HTTP proxy or frontend,
  which wouldn't need to know any details of the sigsnum request api
  (it would need to know the log's key hash, though, to verify the
  signature).

### HTTP-header envelope

To be able to apply rate limiting at the HTTP-level, it should be
possible to do most of the enforcement at the HTTP-level, with minimal
awareness of the sigsum application details. It then seems more
reasonable to form the signature over the request body, rather than
over a serialized `envelope_data` struct like above. But we need the
key_hash to be included in the signed data. We could add the following
custom HTTP header, carrying key-value pairs separated by semicolon:

```
sigsum-envelope: log-key-hash=HEX; domain=_sigsum_v0.example.com;
  public-key=HEX; signature=HEX
```

The signed data should be a all-lowercase string
"log-key-hash=HEX\r\n" concatenated with the literal request body
(after decoding of any transfer-encoding).

The verification including DNS check and signature verification could
be done as part of HTTP processing. The log-key-hash must be compared
to the log's proper key hash, either by the log application, or by
configuring http processing with this value. I think it is possible to
also do rate limiting in the HTTP layer, provided that the client adds
this header only on requests where they are required. Then all that
remains to do for the log application is to check that the header was
present on the add-leaf request.

HTTP-level rate limiting would also need to distinguish between
add-leaf requests actually adding a new leaf, and requests polling for
a request to be completed.

### HTTP considerations

The HTTP authorization framework is defined in RFC 7235. We need to
review that carefully before attempting to use the HTTP Authorization
header, or itnroducing custom headers. In particular, presence of the
Authorzation header seems to have implications for caching, and it's
not obvious how to best deal with requests such as
get-inclusion-proof, where the result should be cached aggressively,
but we may want to rate limit those requests that don't hit the cache.

The HTTP layer, processing the Authorization header, and the
application layer, are tied together via the log's key_hash, which
must be included in the signed envelope data. Making that connection
fit in a good way in the HTTP authorization framework seems to be a
key issue, to be able to perform the rate limiting in the HTTP layer.

Using the Authorization header also has the drawback that it will be
in the way if an organization wants to add HTTP authorization on top
of the sigsum protocols, e.g, in a reverse proxy with additional
access control.

## Per-message envelope alternative

When submitting a new leaf to the log, the submitter first signs the
checksum with the main submission key, and packages the information
needed for the add-leaf request (which would then be just message,
public key, and signature).

In case the log doesn't enforce any rate limits, the submitter emits
the add-leaf request. If the log wants to enforce rate-limits, such a
request will fail with HTTP status code 403 (Forbidden). (Note that
the status code 401, Authorization Required, should be used only for
authorization on the HTTP level).

To pass rate-limit requirements, the submitter now has to prepare a
submission envelope. The envelope should include the domain where the
key hash can be found, the corresponding public key, and a signature
by that key.

Exactly how the envelope should look like, and exactly what should be
signed, is sketched below. The simplest thing would be that the
signature is over the same checksum as the main submit signature (but
with a different namespace), but that would enable the log to submit
leaf and envelope to other logs on the submitter's behalf, exhausting
the submitter's rate limit there. For that reason, the log's key hash
should be included in the signed data.

### Envelope details

The submitter formats the following struct

```
struct envelope_data {
  u8 message[32]
  u8 log_key_hash[32]
}
```

This is serialized and signed with the submitters envelope key, using
ssh format, and namespace "submit_envelope:v0@sigsum.org".

In the add-leaf request, the `shard_hint` is deleted, and
`domain_hint` is renamed to `envelope_domain`. There are two
additional key-value pairs, `envelope_public_key` and
`envelope_signature`. The envelope fields are optional (not needed if
access the log service is controlled by other means), but for a log
enforcing domain-based rate limiting, it will check that the public
key hash is published in DNS, form the same `envelope_data` struct,
and verify the envelope signature. There's also a possibility to
configure a rate-limit, or lack thereof, specifically for certain
keys, in which case the `envelope_domain` field and the DNS lookup
can be omitted.
