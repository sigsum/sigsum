# Sigsum Logging API v0
This document outlines the sigsum logging API, version 0.  The broader picture
is not explained here.  We assume that you are already familiar with the sigsum
logging [design document](https://github.com/sigsum/sigsum/blob/main/doc/design.md).

**Warning.**
This is a work-in-progress document that may be moved or modified.

## Overview
A log implements an HTTP(S) API for accepting requests and sending responses.

- Requests without any input data use the HTTP GET method.
- Requests with input data use the HTTP POST method.
- Input data in requests and output data in responses are expressed as
ASCII-encoded key/value pairs.
- Binary data is hex-encoded before being transmitted.

The motivation for using a text based key/value format for request and
response data is that it is simple to parse.  Note that this format is
not being used for the serialization of signed or logged data, where a
more well defined and storage efficient format is desirable.  A
submitter should distribute log responses to their end-users in any
format that suits them.  The (de)serialization required for
_end-users_ is a small subset of Trunnel.  Trunnel is an "idiot-proof"
wire-format in use by the Tor project.

## Primitives
### Cryptography
Logs use the same Merkle tree hash strategy as
[RFC 6962,§2](https://tools.ietf.org/html/rfc6962#section-2).
The hash functions must be
[SHA256](https://csrc.nist.gov/csrc/media/publications/fips/180/4/final/documents/fips180-4-draft-aug2014.pdf).
Logs must sign tree heads using
[Ed25519](https://tools.ietf.org/html/rfc8032).  Log witnesses
must cosign signed tree heads using Ed25519.

All other parts that are not Merkle tree related should use SHA256 as
the hash function.  Using more than one hash function would increases
the overall attack surface: two hash functions must be collision
resistant instead of one.

### Serialization
Log requests and responses are transmitted as ASCII-encoded key/value
pairs, for a smaller dependency than an alternative parser like JSON.
Some input and output data is binary: cryptographic hashes and
signatures.  Binary data must be Base16-encoded, also known as hex
encoding.  Using hex as opposed to base64 is motivated by it being
simpler, favoring ease of decoding and encoding over efficiency on the
wire.

We use the
[Trunnel](https://gitweb.torproject.org/trunnel.git) [description language](https://www.seul.org/~nickm/trunnel-manual.html)
to define (de)serialization of data structures that need to be signed or
inserted into the Merkle tree.  Trunnel is more expressive than the
[SSH wire format](https://tools.ietf.org/html/rfc4251#section-5).
It is about as expressive as the
[TLS presentation language](https://tools.ietf.org/html/rfc8446#section-3).
A notable difference is that Trunnel supports integer constraints.
The Trunnel language is also readable by humans _and_ machines.
"Obviously correct code" can be generated in C and Go.

A fair summary of our Trunnel usage is as follows.

All integers are 64-bit, unsigned, and in network byte order.
Fixed-size byte arrays are put into the serialization buffer in-order,
starting from the first byte.  These basic types are concatenated to form a
collection.  You should not need a general-purpose Trunnel
(de)serialization parser to work with this format.  If you have one,
you may use it though.  The main point of using Trunnel is that it
makes a simple format explicit and unambiguous.

#### Merkle tree head
A tree head contains a timestamp, a tree size, and a root hash.  The timestamp
is included so that monitors can ensure _liveliness_.  It is the time since the
UNIX epoch (January 1, 1970 00:00 UTC) in seconds.  The tree size specifies the
current number of leaves.  The root hash fixes the structure and content of the
Merkle tree.

```
struct tree_head {
	u64 timestamp;
	u64 tree_size;
	u8 root_hash[32];
};
```

#### (Co)signed Merkle tree head
A log signs the serialized tree head using Ed25519.  A witness cosigns the
serialized _signed tree head_ using Ed25519.  This means that a witness
signature can not be mistaken for a log signature and vice versa.

```
struct signed_tree_head {
	struct tree_head tree_head;
	u8 signature[64];
};
```

A witness must not cosign a signed tree head if it is inconsistent with prior
history or if the timestamp is backdated or future-dated more than 12 hours.

#### Merkle tree leaf
Logs support a single leaf type.  It contains a shard hint, a
checksum, a signature, and a key hash.

```
struct tree_leaf {
    u64 shard_hint;
    u8 checksum[32];
    u8 signature[64];
    u8 key_hash[32];
}
```

`shard_hint` is chosen by the submitter to match the log's shard interval, see
design document.

`checksum` is computed by the submitter and represents some opaque data.

`signature` is a signature over the serialized `shard_hint` and `checksum`.
It must be possible to verify the signature using the submitter's public
verification key.

`key_hash` is a hash of the submitter's public verification key.  It is included
in `tree_leaf` so that the leaf can be attributed to the submitter.  A hash,
rather than the full public key, is used to motivate verifiers to locate the
appropriate key and make an explicit trust decision.

## Public endpoints
Every log has a base URL that identifies it uniquely.  The only
constraint is that it must be a valid HTTP(S) URL that can have the
`/sigsum/v0/<endpoint>` suffix appended.  For example, a complete endpoint
URL could be `https://log.example.com/2021/sigsum/v0/get-tree-head-cosigned`.

Input data (in requests) is POST:ed in the HTTP message body as ASCII
key/value pairs.

Output data (in replies) is sent in the HTTP message body in the same
format as the input data, i.e. as ASCII key/value pairs on the format
`Key=Value`

The HTTP status code is 200 OK to indicate success.  A different HTTP
status code is used to indicate failure, in which case a log should
respond with a human-readable string describing what went wrong using
the key `error`. Example: `error=Invalid signature`.

### get-tree-head-cosigned
Returns the latest cosigned tree head. Used together with
`get-proof-by-hash` and `get-consistency-proof` for verifying the tree.

```
GET <base url>/sigsum/v0/get-tree-head-cosigned
```

Input:
- None

Output on success:
- `timestamp`: `tree_head.timestamp` ASCII-encoded decimal number,
  seconds since the UNIX epoch.
- `tree_size`: `tree_head.tree_size` ASCII-encoded decimal number.
- `root_hash`: `tree_head.root_hash` hex-encoded.
- `signature`: hex-encoded Ed25519 log signature over `timestamp`,
  `tree_size` and `root_hash` serialized into a `tree_head` as
  described in section `Merkle tree head`.
- `cosignature`: hex-encoded Ed25519 witness signature over `timestamp`,
  `tree_size`, `root_hash`, and `signature` serialized into a `signed_tree_head`
  as described in section `(Co)signed Merkle tree head`.
- `key_hash`: a hash of the witness verification key that can be used to
  verify the above `cosignature`.  The key is encoded as defined
  in [RFC 8032, section 5.1.2](https://tools.ietf.org/html/rfc8032#section-5.1.2), 
  and then hashed using SHA256.  The hash value is hex-encoded.

The `cosignature` and `key_hash` fields may repeat. The first witness signature
corresponds to the first key hash, the second witness signature corresponds to
the second key hash, etc.  At least one witness signature must be returned on
success.  The number of witness signatures and key hashes must match.

### get-tree-head-to-sign
Returns the latest signed tree head to be cosigned.  Used by witnesses.

```
GET <base url>/sigsum/v0/get-tree-head-to-sign
```

Input:
- None

Output on success:
- `timestamp`: `tree_head.timestamp` ASCII-encoded decimal number,
  seconds since the UNIX epoch.
- `tree_size`: `tree_head.tree_size` ASCII-encoded decimal number.
- `root_hash`: `tree_head.root_hash` hex-encoded.
- `signature`: hex-encoded Ed25519 log signature over `timestamp`,
  `tree_size` and `root_hash` serialized into a `tree_head` as
  described in section `Merkle tree head`.

### get-tree-head-latest
Returns the latest signed tree head.  Used for debugging purposes.

```
GET <base url>/sigsum/v0/get-tree-head-latest
```

Input an output follows the same formatting as `get-tree-head-to-sign`.

### get-proof-by-hash
```
POST <base url>/sigsum/v0/get-proof-by-hash
```

Input:
- `leaf_hash`: leaf identifying which `tree_leaf` the log should prove
  inclusion of, hex-encoded.
- `tree_size`: tree size of the tree head that the proof should be
  based on, as an ASCII-encoded decimal number.

Output on success:
- `tree_size`: tree size that the proof is based on, as an
  ASCII-encoded decimal number.
- `leaf_index`: zero-based index of the leaf that the proof is based
  on, as an ASCII-encoded decimal number.
- `inclusion_path`: node hash, hex-encoded.

The leaf hash is computed using the RFC 6962 hashing strategy.  In
other words, `SHA256(0x00 | tree_leaf)`.

`inclusion_path` may be omitted or repeated to represent an inclusion
proof of zero or more node hashes.  The order of node hashes follow
from the hash strategy, see RFC 6962.

Example: `echo "leaf_hash=241fd4538d0a35c2d0394e4710ea9e6916854d08f62602fb03b55221dcdac90f
tree_size=4711" | curl --data-binary @- localhost/sigsum/v0/get-proof-by-hash`

### get-consistency-proof
```
POST <base url>/sigsum/v0/get-consistency-proof
```

Input:
- `new_size`: tree size of a newer tree head, as an ASCII-encoded
  decimal number.
- `old_size`: tree size of an older tree head that the log should
  prove is consistent with the newer tree head, as an ASCII-encoded
  decimal number.

Output on success:
- `new_size`: tree size of the newer tree head that the proof is based
  on, as an ASCII-encoded decimal number.
- `old_size`: tree size of the older tree head that the proof is based
  on, as an ASCII-encoded decimal number.
- `consistency_path`: node hash, hex-encoded.

`consistency_path` may be omitted or repeated to represent a
consistency proof of zero or more node hashes.  The order of node
hashes follow from the hash strategy, see RFC 6962.

Example: `echo "new_size=4711
old_size=42" | curl --data-binary @- localhost/sigsum/v0/get-consistency-proof`

### get-leaves
```
POST <base url>/sigsum/v0/get-leaves
```

Input:
- `start_size`: index of the first leaf to retrieve, as an
  ASCII-encoded decimal number.
- `end_size`: index of the last leaf to retrieve, as an ASCII-encoded
  decimal number.

Output on success:
- `shard_hint`: `tree_leaf.message.shard_hint` as an ASCII-encoded
  decimal number.
- `checksum`: `tree_leaf.message.checksum`, hex-encoded.
- `signature`: `tree_leaf.signature_over_message`, hex-encoded.
- `key_hash`: `tree_leaf.key_hash`, hex-encoded.

All fields may be repeated to return more than one leaf.  The first
value in each list refers to the first leaf, the second value in each
list refers to the second leaf, etc.  The size of each list must
match.

A log may return fewer leaves than requested.  At least one leaf
must be returned on HTTP status code 200 OK.

Example: `echo "start_size=42
end_size=4711" | curl --data-binary @- localhost/sigsum/v0/get-leaves`

### add-leaf
```
POST <base url>/sigsum/v0/add-leaf
```

Input:
- `shard_hint`: number within the log's shard interval as an
  ASCII-encoded decimal number.
- `checksum`: the cryptographic checksum that the submitter wants to
  log, hex-encoded.
- `signature`: the submitter's signature over `tree_leaf.shard_hint` and
  `tree_leaf.checksum`, see section `Merkle tree leaf`.  The resulting signature
  is hex-encoded.
- `verification_key`: the submitter's public verification key.  The
  key is encoded as defined in
  [RFC 8032, section 5.1.2](https://tools.ietf.org/html/rfc8032#section-5.1.2)
  and then hex-encoded.
- `domain_hint`: domain name indicating where `tree_leaf.key_hash`
  can be found as a DNS TXT resource record with hex-encoding.

Output on success:
- None

The submission will not be accepted if `signature` is
invalid or if the key hash retrieved using `domain_hint` does not
match a hash over `verification_key`.

The submission may also not be accepted if the second-level domain
name exceeded its rate limit.  By coupling every add-leaf request to
a second-level domain, it becomes more difficult to spam logs.  You
would need an excessive number of domain names.  This becomes costly
if free domain names are rejected.

Logs don't publish domain-name to key bindings because key
management is more complex than that.

Public logging should not be assumed to have happened until an
inclusion proof is available.  An inclusion proof should not be relied
upon unless it leads up to a trustworthy signed tree head.  Witness
cosigning can make a tree head trustworthy.

Example: `echo "shard_hint=1640995200
checksum=cfa2d8e78bf273ab85d3cef7bde62716261d1e42626d776f9b4e6aae7b6ff953
signature=c026687411dea494539516ee0c4e790c24450f1a4440c2eb74df311ca9a7adf2847b99273af78b0bda65dfe9c4f7d23a5d319b596a8881d3bc2964749ae9ece3
verification_key=c9a674888e905db1761ba3f10f3ad09586dddfe8581964b55787b44f318cbcdf
domain_hint=example.com" | curl --data-binary @- localhost/sigsum/v0/add-leaf`

### add-cosignature
```
POST <base url>/sigsum/v0/add-cosignature
```

Input:
- `cosignature`: Ed25519 witness signature over `signed_tree_head`, hex-encoded.
- `key_hash`: hash of the witness' public verification key that can be
  used to verify `cosignature`.  The key is encoded as defined in
  [RFC 8032, section 5.1.2](https://tools.ietf.org/html/rfc8032#section-5.1.2),
  and then hashed using SHA256. The hash value is hex-encoded.

Output on success:
- None

`key_hash` can be used to identify which witness cosigned a signed tree
head.  A key-hash, rather than the full verification key, is used to
motivate verifiers to locate the appropriate key and make an explicit
trust decision.

Example: `echo "cosignature=d1b15061d0f287847d066630339beaa0915a6bbb77332c3e839a32f66f1831b69c678e8ca63afd24e436525554dbc6daa3b1201cc0c93721de24b778027d41af
key_hash=662ce093682280f8fbea9939abe02fdba1f0dc39594c832b411ddafcffb75b1d" | curl --data-binary @- localhost/sigsum/v0/add-cosignature`

## Summary of log parameters
- **Public key**: The Ed25519 verification key to be used for
  verifying tree head signatures.
- **Shard interval start**: The earliest time at which logging
  requests are accepted as the number of seconds since the UNIX epoch.
- **Shard interval end**: The latest time at which logging
  requests are accepted as the number of seconds since the UNIX epoch.
- **Base URL**: Where the log can be reached over HTTP(S).  It is the
  prefix to be used to construct a version 0 specific endpoint.
