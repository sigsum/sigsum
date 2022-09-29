Proposal to eliminate the "shard hint", and make rate limiting an
optional feature applied on the submit envelope.

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

2. Introduce a submission envelope, to which the rate-limit is
   applied. We need to specify the domain-based rate-limiting, while
   leaving open for extensions using other means of authentication.
   The changes for domain based rate limiting is specified below.

## Domain-based rate-limit.

As before, the submitter will need to generate a key pair, and publish
the hash of the public key as a DNS TXT record on a DNS name the
submitter controls, and the left-most label of the name must be
'_sigsum_v0'. However, it is strongly recommended that this keypair is
different from the one used for the leaf signatures to be published by
the log, and it may be stored on a separete machine with looser
security requirements. There is also no need for this key to be
long-lived; it can be rotated as frequently as desired by just adding
and removing corresponding TXT records, in accordance with the DNS ttl
settings.

When submitting a new leaf to the log, the submitter first signs the
checksum with the main submission key, and packages the information
needed for the add-leaf request (which would then be just message,
public key, and signature).

In case the log doesn't enforce any rate limits, the submitter emits
the add-leaf request. If the log wants to enforce rate-limits, such a
request will fail with some HTTP error, possibly 401 (Unauthorized).

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
should be included in the signature.

Another options may be to use the HTTP authorization header, something
like

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

The signature is based on the submitted `message` submitted to, but
not published by, the log. It is signed using ssh format, using sha256
as the hash function, empty reserved string, and namespace
"tree_leaf:v0@sigsum.org". The ssh signature format internally
computes `H(message)`, as part of formatting the data to be signed,
and it is this value that is stored in the leaf's checksum field.

## Envelope details

For discussion, this proposal sketches two ways if representing the
envelope.

### In-body envelope

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
`domain_hint` is renamed to `envelope_domain_hint`. There are two
additional key-value pairs, `envelope_public_key` and
`envelope_signature`. The envelope fields are optional (not needed if
access the log service is controlled by other means), but for a log
enforcing domain-based rate limiting, it will check that the public
key hash is published in DNS, form the same `envelope_data` struct,
and verify the envelope signature.

### HTTP-header envelope

To be able to apply rate limiting at the HTTP-level, it should be
possible to do most of the enforcement at the HTTP-level, with minimal
awareness of the sigsum application details. It then seems more
reasonable to form the signature over the request body, rather than
over a serialized `envelope_data` struct like above. But we need the
key_hash to be included in the signed data. We could add the following
custom HTTP headers:

* sigsum-v0-submit-to: Value should be the hex-encoded hash of the
  log's public key.

* sigsum-v0-submit-from: Value should be hex-encoded public key and
  domain hint, space separated (could alternatively, could use param
  syntax).

* sigsum-v0-submit-signature: Hex encoded signature.
  ssh-format-signature, namespace
  "submit-http-envelope:v0@sigsum.org".

The signed data should be a "sigsum-v0-submit-to" pseudo header
followed by the literal request body (after decoding of any
transfer-encoding). Or more precisely, the concatenation of the string
"sigsum-v0-submit-to: " (lowercase), the hex-encoded hash of the log's
public key (also lower-case), the four characters "\r\n\r\n", and the
complete HTTP request body.

The verification including DNS check and signature verification could
be done as part of HTTP processing. The sigsum-v0-submit-to must be
compared to the log's proper key hash, either by the log application,
or by configuring http processing with this value. I think it is
possible to also do rate limiting in the HTTP layer, provided that the
clients add these headers only on requests where they are required.
Then all that remains to do for the log application is to check that
these headers were present on the addl-leaf request.

# Security considerations

First, recall that rate limit isn't intended to protect the log server
from arbitrary denial of service attacks to overload the log's
capacity in terms of computational resources or network bandwidth. It
is only intended to enable limiting, per domain, of the rate at which
leaves are added to the merkle tree.

The envelope signatures don't include any means to prevent replay
attacks. There are a couple of reasons that appears fine for this
application.

* The envelope signatures aren't published anywhere, they are
  accessible exclusively to submitter and log.

* Replays to the same log are harmless, because all requests represent
  either pure data retrieval, or idempotent changes to the log's
  state.

* Including the target log's key hash in the envelope signature means
  that the envelope will be rejected if sent anywhere else.

It seems undesirable to add in a nonce provided by the log, since that
makes the protocol more stateful or interactive, but one could add a
timestamp to the envelope, and then the log could accept requests
timestamped only in a small time window, on the order of a few
minutes. However, for the reasons above, that appears unnecessary.

# HTTP considerations

The HTTP authorization framework is defined in RFC 7235. We need to review that
carefully before attempting to use the HTTP Authorization header. In
particular, presence of that header seems to have implications for
caching, and it's not obvious how to best deal with requests such as
get-inclusion-proof, where the result should be cached aggressively,
but we may want to rate limit those requests that don't hit the cache.

The HTTP layer, processing the Authorization header, and the
application layer, are tied together via the log's key_hash, which
must be included in the signed envelope data. Making that connection
fit in a good way in the HTTP authorization framework seems to be a
key issue, to be able to perform the rate limiting in the HTTP layer.

One could also consider additional HTTP headers.

# Digression on the checksum field

The specification of the checksum is a bit convoluted in the current
version of the api document. My current understanding is that the
submitter starts with its `message`. This is signed with ssh format by
the submitter. Message, signature and public key are submitted to the
log, which can then verify the signature. The ssh signature procedure
includes computation of the sha256 hash value `H(message)`, and it's
this value that is stored in the `checksum` field. One implication is
that it is possible in principle to verify the signature given only
the leaf and the public key, but it can't be done easily with the
`ssh-keygen` tool, since it really wants the `message` as input.

It's not clear to which parties have an interest in verifying this
signatures, but I think the most natural verifiers would be provided
with both the message and the public key out of band.

It's also not clear to me if it matters if the checksum stored in the
leaf actually is the same as is used internally in the ssh signature.
What we really want to secure (in broad meaning) is `message`. Say
that the submitter signs `message` using some arbitrary but secure
signature algorithm, using some arbitrary hash function H1 internally.
We verify the signature, and then compute H2(message) using some
secure but totally unrelated hash function H2. The value H2(message) +
submiters signature is then published via the merkle-tree machinery.

It seems that would be good enough for sigsum usecases? A sigsum
verifier that has the message, and the submitters public key, the tree
leaf and related inclusion proofs, can both verify the signature and
recompute the H2(message) value that is in the leaf.

Actually, do we even need to publish the checksum at all?
