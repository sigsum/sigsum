# Witness API v0

**Warning.**
This is a work-in-progress document that may be moved or modified.

## 1 — Overview

Logs produce self-contained proofs that can be verified offline by clients. To
do this they need to obtain and include in the proof co-signatures on the tree
head produced by a quorum of witnesses trusted by the client. When producing a
new tree head, the log reaches out to witnesses to request co-signatures over
it, providing a consistency proof. Witnesses verify that the tree head is
consistent with the previous state of the tree, and return a timestamped
signature.

A witness is an entity exposing an HTTP service identified by its public key.
Each witness is configured with a list of supported tree public keys. For each
tree, the witness keeps only track of the latest tree head it observed and
verified, and the timestamp of its latest co-signature.

Clients are not expected to communicate directly with the witnesses, logs and
(sometimes) monitors are, but there is no authentication beyond the validation
of the signature on the tree head.

Witnesses need to be operated by trusted, reliable entities with minimal churn.
Log deployments pick a witness trust policy that gets deployed into clients and
might be difficult or impossible to change. Developing a healthy ecosystem of
witnesses might be the biggest hurdle to widespread tlog success. It’s
impractical to build a separate witness ecosystem for each application, so it’s
important that witnesses be public, interoperable, and scalable. As for
quantity, there should be more than a few, but once reached a critical mass each
additional witness has sharply diminishing marginal value. Additional log
deployments, on the other hand, don’t have diminishing returns and are a
desirable goal. Because of this, witnesses are designed to scale well with a
large number of rarely active logs, and to support diverse log designs,
including low-latency and "offline" logs.

## 2 — Primitives

This documents uses the same textual encodings, binary encoding, key encoding,
HTTP API description language, hash, and signature scheme as the [log API
document](https://git.sigsum.org/sigsum/tree/doc/log.md). All timestamps are
expressed in seconds since the UNIX epoch (January 1, 1970 00:00 UTC).

A co-signature consists of four fields, separated by a single space character:

```
v1 1a450ecf1f49a4e4580c35e4d83316a74deda949dbb7d338e89d4315764d88de 1687170591 cacc54d315609b796f72ac1d71d1bbc15667853ed980bd3e0f957de7a875b84bd2dcde6489fc3ed66428190ce588ac1061b0d5748e73cfb887ebf38d0b53060a
```

1. The fixed "v1" string
2. The hex-encoded hash of the witness public key
  * A key hash, rather than the full public key, is used to motivate monitors
    and end-users to locate the appropriate key and make an explicit trust decision.
3. The time at which the co-signature was generated,
   ASCII-encoded as a decimal number
4. The hex-encoded signature from the witness key of a message composed of one
   line spelling `cosignature/v1`, one line representing the current timestamp
   in seconds since the UNIX epoch encoded as an ASCII decimal with no leading
   zeroes and prefixed with the string `time` and a space (0x20), followed by
   the first three lines of the tree head encoded as a checkpoint (including the
   final newline).

```
cosignature/v1
time 1679315147
sigsum.org/v1/tree/3620c0d515f87e60959d29a4682fd1f0db984704981fda39b3e9ba0a44f57e2f
15368405
31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=
```

Semantically, a v1 co-signature is a statement that, as of the current time, the
*consistent* tree head *with the largest size* the witness has observed for
the log identified by that key has the specified hash.

## 3 — Public endpoints

This section specifies the public HTTP(S) endpoints exposed by a witness.

Witnesses might choose to implement request rate-limits per source IPv4 or IPv6
prefix. Implementing rate-limits based on log key hashes is discouraged as the
resources required to properly attribute a request to a log (checking the
signature, and whether the tree head is novel) are equivalent to those required
to service it. Witnesses may choose to exempt or partition successful
`add-tree-head` requests from the rate-limit, to avoid affecting high frequency
logs.

Witnesses should support keep-alive HTTP connections to reduce latency and load
due to connection establishment.

If exposing the machine holding the witness key material to the Internet is
undesirable, operators may choose to operate a "bastion" host that is exposed to
the Internet, and proxies the requests to a reverse connection established from
the actual witness to the bastion.

### 3.1 — get-tree-size

Returns the tree size of the latest tree head known to the witness for a given
tree. This is used to prepare the correct consistency proof for an
`add-tree-head` request. No other details of the tree head or co-signature are
returned, to discourage the use of this endpoint by clients other than logs or
in place of the cacheable roster.

```
GET <witness URL>/get-tree-size/<key_hash>
```

Input:
- `key_hash`: hash of the log's public key, hex-encoded

HTTP error codes on failure:
- 400 Bad request if `key_hash` is invalidly encoded.
- 404 Not Found if the `key_hash` is not known.

Output:
- `size`: log size, ASCII-encoded decimal number

A log with strict latency goals may choose to issue a `get-tree-size` request
before or in parallel with creating a tree head, so that it will be immediately
ready to issue a `add-tree-head` request. A log that is frequently producing
tree heads may choose to keep track of the latest `add-tree-head` request it
issued, and only issue a `get-tree-size` on 409 Conflict errors.

Caching this response is discouraged as it is likely to lead to 409 Conflict
error responses to `add-tree-head` requests.

### 3.2 — add-tree-head

Provides a new signed tree head for the witness to cosign, along with a
consistency proof from the latest tree head known to the witness (retrieved with
`get-tree-size`).

```
POST <witness URL>/add-tree-head
```

Input:
- `key_hash`: hash of the log's public key, hex-encoded
- `size`: log size, ASCII-encoded decimal number
- `root_hash`: Merkle tree root hash, hex-encoded
- `signature`: log signature for the above tree head, hex-encoded
- `old_size`: the size of the previous tree head the consistency proof is
  built from, ASCII-encoded decimal number
- `node_hash`: repeated key, listing zero or more hashes representing
  a consistency proof, hex-encoded. List is empty (this key not
  present at all) if and only if `old_size == 0` or `old_size ==
  size`. The order of node hashes follow from the hash strategy, see
  RFC 6962.

HTTP error codes on failure:
- 400 Bad request if `old_size` is higher than `size`.
- 409 Conflict if the `old_size` does not match the latest tree head known by the
  witness (this should be resolved by making a `get-tree-size` request and retrying).
- 403 Forbidden if the `signature` doesn't verify.
- 404 Not Found if the `key_hash` is not known.
- 422 Unprocessable entity if the `node_hash` list does not prove consistency
  from the old tree head known to the witness to the new one.

Output on success:
- `cosignature`: witness co-signature for the submitted tree head, can be
  repeated multiple times (but must not be missing).

  Different cosignatures can have different versions, key hashes, and
  timestamps, but there may be at most one v1 cosignature for each key hash.
  Clients must ignore cosignatures of unknown version (that is, where the first
  field is not `v1`) or bearing an unexpected witness key hash. The timestamps
  can be expected to all be recent and in the same range.

The witness must persist the new tree head before returning the cosignature.
Note that checking the `old_size` against the previous tree head and persisting
the new tree head must be performed atomically: otherwise the following race can
occur.

1. Request A with `size` N is checked for consistency.
2. Request B with `size` N+K is checked for consistency.
3. The stored size is updated to N+K for request B.
4. A cosignature for N+K is returned to request B.
5. The stored size is updated to N for request A, **rolling back K leaves**.
6. A cosignature for N is returned to request A.

If the `key_hash` is known, and the `signature` is valid, the witness should log
the request even if the consistency proof doesn't verify (but must not co-sign
it) as it might suggest log misbehavior.

Note that the client can't request an `old_size` lower than the latest known to
the log. This means witnesses are expected not to ever sign a tree head with
size N+K at T and N at T+D (with K and D > 0) for the same log.

A log with strict latency goals may choose to issue `add-tree-head` requests to
all witnesses in parallel, and to start serving the co-signed tree head once a
threshold of co-signatures are obtained, without waiting for the slowest
witnesses.

### 3.3 — Roster

Returns a list of supported tree public keys, and the timestamps of the latest
co-signature produced by this witness for each of them.

Note that this endpoint may be served from a different base URL than the tree
head endpoints, to reflect the fact that this endpoint serves a different set of
clients with potentially different rate limits, and to facilitate delegating it
to a static hosting service.

```
GET <roster URL>
```

Input: none

Output:
- hex-encoded key hash 1: co-signature 1 timestamp,
  ASCII-encoded as a decimal number
- hex-encoded key hash 2: co-signature 2 timestamp,
  ASCII-encoded as a decimal number
- hex-encoded key hash 3: co-signature 3 timestamp,
  ASCII-encoded as a decimal number
- ...
- `key_hash`: the witness public key hash, hex-encoded
- `timestamp`: the time at which this roster was generated, ASCII-encoded as a
  decimal number
- `signature`: a signature from the witness public key over all other keys in
  this response, in the order in which they appear, including the trailing `\n`,
  with a prefix of `sigsum.org/v1/witness-roster\n`

Witnesses must commit to the period at which they update the roster, and make
sure that any caching system won't interfere with the roster URL response
visibly updating at least every period.

This endpoint is provided for the benefit of monitors. By obtaining a recent
roster from a quorum of witnesses and comparing the timestamp in the roster with
that on the most recent co-signature, a monitor can ensure the "freshness" of
the tree head it is inspecting. Otherwise, a log could hide entries from a
monitor by pretending it has stopped issuing tree heads.

**Note**: should a roster list timestamps or tree sizes? How should a monitor
handle a very recent timestamp?
