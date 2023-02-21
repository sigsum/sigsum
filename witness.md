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

A co-signature consists of three fields, separated by a single space character:

1. The hex-encoded hash of the witness public key
  * A key hash, rather than the full public key, is used to motivate monitors
    and end-users to locate the appropriate key and make an explicit trust decision.
2. The time at which the co-signature was generated,
   ASCII-encoded as a decimal number
3. The hex-encoded signature from the witness key of a `cosigned_tree_head` with
   namespace `cosigned-tree-head:v0@sigsum.org`.

```
struct cosigned_tree_head {
	u64 size;
	u8 root_hash[32];
	u8 key_hash[32];
	u64 timestamp;
}
```

Note that this structure has two additional fields compared to a
`signed_tree_head`, which is signed by the log's public key:

* the log's `key_hash`, to [bind the co-signature to the
  log](https://git.sigsum.org/sigsum/tree/archive/2021-08-10-witnessing-broader-discuss#n95),
* the co-signature `timestamp`, a trusted observed time for the tree head, which
  can be useful in establishing freshness or a logging timespan for a leaf.

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

Output:
- `size`: log size, ASCII-encoded decimal number

A log with strict latency goals may choose to issue a `get-tree-size` request
before or in parallel with creating a tree head, so that it will be immediately
ready to issue a `add-tree-head` request. A log that is frequently producing
tree heads may choose to keep track of the latest `add-tree-head` request it
issued, and only issue a `get-tree-size` on `bad_old_size` errors.

Caching this response is discouraged as it is likely to lead to `bad_old_size`
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
  a consistency proof, hex-encoded. List is empty if and only if
  old_size is zero. The order of node hashes follow from the hash
  strategy, see RFC 6962.

HTTP error codes on failure:
- 400 Bad request if `size` is not higher than `old_size`
- 409 Conflict if the `old_size` does not match the latest tree head known by the
  witness (this should be resolved by making a `get-tree-size` request and retrying)
- 403 Forbidden if the `key_hash` is not known or if the `signature` doesn't verify
- 422 Unprocessable entity if the `node_hash` list does not prove consistency
  from the old tree head known to the witness to the new one

Output on success:
- `cosignature`: witness co-signature for the submitted tree head

The witness must persist the new tree head before returning the cosignature.

If the `key_hash` is known, and the `signature` is valid, the witness may choose
to log the request if it might suggest log misbehavior.

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
  with namespace `roster:v0@sigsum.org`

Witnesses must commit to the period at which they update the roster, and make
sure that any caching system won't interfere with the roster URL response
visibly updating at least every period.

This endpoint is provided for the benefit of monitors. By obtaining a recent
roster from a quorum of witnesses and comparing the timestamp in the roster with
that on the most recent co-signature, a monitor can ensure the "freshness" of
the tree head it is inspecting. Otherwise, a log could hide entries from a
monitor by pretending it has stopped issuing tree heads.
