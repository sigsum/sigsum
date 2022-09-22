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
  mechanism inclded in the merkle tree.

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
signed, needs further discussion. The simplest thing would be that the
signature is over the same checksum as the main submit signature (but
with a different namespace?), but that would enable the log to submit
leaf and envelope to other logs on the submitter's behalf, exhausting
the submitter's rate limit there. For that reason, the log's keyhash
should be included in the signature.

The envelope could be represented as
additional key value pairs, like `envelope_domain_hint`,
`envelope_public_key`, `envelope_signature`, added in the request
body.

Another options mey be to use the HTTP authorization header, something
like

```
Authorization: sigsum-rate-limit domain=... public_key=...
  signature=...
```

In that case, the signature should be over the log's key hash + body
of the HTTP request (taking transfer encoding into account). If we can
do rate-limiting on the HTTP level like this, it makes things rather
flexible:

* Logs can use other means of HTTP
  authentication if they so desire, e.g,., basic or digest
  authentication, client tls certificates, secret cookie values, ...

* Rate limit can be applied to other requests than add-leaf, if needed.

* Rate-lmiting could be implemented in an HTTP proxy or frontend,
  which wouldn't need to know any details of the sigsnum request api
  (it would need to know the log's key hash, though, to varify the signature).

# Security considerations

The envelope signatures don't include any means to prevent replay
attacks. This may be acceptable, because the envelope signatures
aren't published anywhere, they are accessible exclusively to
submitter and log. Also, the requests that are authenticated in this
way should represent either pure data retrieavel, or idempotent
changes to the log's state.

As mentioned, the the envelope has to be bound to the target log, to
rule out replay attacks performed by the target log on other logs.

It seems undesirable to add in a nonce provided by the log, since that
makes the protocol more stateful or interactive, but one could add a
timestamp to the envelope, and then the log could accept requests
timestamped only in a small time window, on the order of a few minutes.

# HTTP considerations

The HTTP auth framework is defined in RFC 7235. We need to review that
carefully before attempting to use the HTTP Authorization header. In
particular, presence of that header seems to have implications for
caching, and it's not obvious how to best deal with requests such as
get-inclusion-proof, where the result should be cached aggressively,
but we may want to rate limit those requests that don't hit the cache.

The log's key hash, to be included in the signature, doesn't fit that
naturally as an extra parameter in the Authorization header. Maybe it
would make sense to instead use the realm parameter for that?
