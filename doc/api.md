# Sigsum Logging API v0
This document outlines the sigsum logging API, version 0.  The broader picture
is not explained here.  We assume that you are already familiar with the sigsum
logging [design document](https://git.sigsum.org/sigsum/tree/doc/design.md).

**Warning.**
This is a work-in-progress document that may be moved or modified.

## 1 - Overview
A log implements an HTTP(S) API for accepting requests and sending responses.

- Requests that retrieve data from the log uses the HTTP GET method.
- Requests that add data to the log uses the HTTP POST method.
- Input data in get-requests are expressed as ASCII values that are
slash-delimited at the end of the respective endpoint URLs.
- Input data in add-requests and output data in responses are expressed as
ASCII-encoded key/value pairs.
- Binary data is hex-encoded before being transmitted.

The motivation for using text-based formats for request and response data is
that it is simple to parse and understand for humans.  These formats are not
used for the serialization of signed and/or logged data, where a more well
defined and storage efficient format is desirable.

A _signer_ should distribute log responses to their verifiers in any format that
suits them.  The (de)serialization required for _verifiers_ is a small subset of
Trunnel.  Trunnel is an "idiot-proof" wire-format in use by the Tor project.

Figure 1 of our design document gives an intuition of all involved parties.

## 2 - Primitives
### 2.1 - Cryptography
Logs use the same Merkle tree hash strategy as
[RFC 6962,§2](https://tools.ietf.org/html/rfc6962#section-2).
The hash functions must be
[SHA256](https://csrc.nist.gov/csrc/media/publications/fips/180/4/final/documents/fips180-4-draft-aug2014.pdf).
Logs and witnesses must sign tree heads using
[Ed25519](https://tools.ietf.org/html/rfc8032).

All other parts that are not Merkle tree related should use SHA256 as
the hash function.  Using more than one hash function would increases
the overall attack surface: two hash functions must be collision
resistant instead of one.

### 2.2 - Serialization
Log requests and responses are transmitted using simple ASCII encodings, for a
smaller dependency than alternative parsers like JSON or percent-encoded URLs.
Some input and output data is binary: cryptographic hashes and signatures.
Binary data must be lower-case base16-encoded, also known as lower-case hex
encoding.  Using hex as opposed to base64 is motivated by it being simpler,
favoring ease of decoding and encoding over efficiency on the wire.

We use the [Trunnel](https://gitweb.torproject.org/trunnel.git)
[description language](https://www.seul.org/~nickm/trunnel-manual.html)
to define (de)serialization of data structures that need to be signed or
inserted into the Merkle tree.  It is about as expressive as the
[TLS presentation language](https://tools.ietf.org/html/rfc8446#section-3).
However, it is readable by humans _and_ machines.
"Obviously correct code" can be generated in C, Go, etc.

A fair summary of our Trunnel usage is as follows.

All integers are 64-bit, unsigned, and in network byte order.
Fixed-size byte arrays are put into the serialization buffer in-order,
starting from the first byte.  These basic types are concatenated to form a
collection.  You should not need a general-purpose Trunnel
(de)serialization parser to work with this format.  If you have one,
you may use it though.  The main point of using Trunnel is that it
makes a simple format explicit and unambiguous.

### 2.3 - Merkle tree
#### 2.3.1 - Tree head
A tree head contains a timestamp, a tree size, a root hash, and a key hash.

```
struct tree_head {
	u64 timestamp;
	u64 tree_size;
	u8 root_hash[32];
	u8 key_hash[32];
};
```
`timestamp` is the time since the UNIX epoch (January 1, 1970 00:00 UTC) in
seconds.  It is included so that monitors can be convinced of _freshness_ if
enough witnesses added their cosignatures.  A signer can also use timestamps
to prove to a verifier that public logging happened within some interval
	[\[TS\]](https://git.sigsum.org/sigsum/commit/?id=fef460586e847e378a197381ef1ae3a64e6ea38b).

`tree_size` is the number of leaves in a log.

`root_hash` is a Merkle tree root hash that fixes a log's structure and content.

`key_hash` is a log's hashed public key.  The key is encoded as defined in
[RFC 8032, section 5.1.2](https://tools.ietf.org/html/rfc8032#section-5.1.2)
before hashing it.  The result is used as a unique log identifier that prevents
an [attack](https://git.sigsum.org/sigsum/tree/archive/2021-08-10-witnessing-broader-discuss#n95)
in multi-log ecosystems.

#### 2.3.2 - (Co)signed tree head
A signed tree head is composed of a tree head and a signature.  This structure
does not have a Trunnel definition because it is neither signed nor logged.

Logs and witnesses sign the same `tree_head` structure, see Section 2.3.1.

Note that tree heads are scoped to a specific log to ensure that a witness
signature for log X cannot be confused with a witness signature for log Y.

A witness must not cosign a tree head if it is inconsistent with prior history
or if the timestamp is older than 5 minutes.  A witness can be viewed as two
abstract roles: Verifier("append-only") and Verifier("freshness")
	[\[WR\]](https://git.sigsum.org/sigsum/tree/archive/2021-08-31-checkpoint-timestamp-continued#n84).

#### 2.3.3 - Tree leaf
Logs support a single leaf type.  It contains a signer's statement,
signature, and key hash.

```
struct statement {
    u64 shard_hint;
    u8 checksum[32];
}

struct tree_leaf {
    struct statement statement;
    u8 signature[64];
    u8 key_hash[32];
}
```

`shard_hint` must match a log's shard interval and is determined by the signer.

`checksum` is a hashed preimage.  The signer selects a 32-byte preimage which
represents some data.  It is recommended to set this preimage to `H(data)`, in
which case the checksum will be `H(H(data))`.

`signature` is a signature over a serialized `statement`.  It must be possible
to verify this signature using the signer's public verification key.

`key_hash` is a hash of the signer's public verification key.  It is included
in `tree_leaf` so that each leaf can be attributed to a signer.  A hash,
rather than the full public key, is used to motivate monitors and verifiers to
locate the appropriate key and make an explicit trust decision.

## 3 - Public endpoints
A log must have a fixed unique base URL that can have the following suffix
appended: `/sigsum/v0/<endpoint>`.  Example of a valid base URL:
```
https://log.example.com:4711/opossum/2021`.
```

Input data in `get-*` requests are added at the end of an endpoint's
URL.  Values are delimited by a `/`.  The order of values is defined by
the respective endpoints.  For an example, see Section 3.4.

Input data in `add-*` requests is POST:ed in the HTTP message body as
line-terminated ASCII key/value pairs.  The key-value format is `Key=Value\n`.
Everything before the first equal-sign is considered a key.
Everything after the first equal sign and before the next new line character is
considered a value.  Different keys may appear in any order.  A key may be
repeated, in which case the relative order must be preserved.  Example:
```
blue=first value for blue key
red=some value for red key
blue=second value for blue key
```

Output data (in replies) is sent in the HTTP message body using the same
key-value format as for `add-*` input data.

The HTTP status code is 200 OK to indicate success.  A different HTTP
status code is used to indicate failure.  A log must respond with a
human-readable string describing what went wrong using the key `error`.
Example:
```
error=Invalid signature
```

### 3.1 - get-tree-head-latest
Returns the latest signed tree head.  Used for debugging purposes.

```
GET <base url>/sigsum/v0/get-tree-head-latest
```

Input:
- None

Output:
- `timestamp`: `tree_head.timestamp`, ASCII-encoded decimal number.
- `tree_size`: `tree_head.tree_size`, ASCII-encoded decimal number.
- `root_hash`: `tree_head.root_hash`, hex-encoded.
- `signature`: log signature over a serialized `tree_head`, hex-encoded.

Note that `tree_head.key_hash` is known by the querying party.  Therefore, it is
not returned in Sections 3.1-3.3.

### 3.2 - get-tree-head-to-sign
Returns the latest signed tree head to be cosigned.  Used by witnesses.

```
GET <base url>/sigsum/v0/get-tree-head-to-sign
```

Input:
- None

Output on success:
- `timestamp`: `tree_head.timestamp`, ASCII-encoded decimal number.
- `tree_size`: `tree_head.tree_size`, ASCII-encoded decimal number.
- `root_hash`: `tree_head.root_hash`, hex-encoded.
- `signature`: log signature over a serialized `tree_head`, hex-encoded.

### 3.3 - get-tree-head-cosigned
Returns the latest cosigned tree head. Used together with `get-inclusion-proof`
and `get-consistency-proof`.  Ensures that monitors see the same statements as
verifiers.  Can be used to convince a verifier when public logging happened.

```
GET <base url>/sigsum/v0/get-tree-head-cosigned
```

Input:
- None

Output on success:
- `timestamp`: `tree_head.timestamp`, ASCII-encoded decimal number.
- `tree_size`: `tree_head.tree_size`, ASCII-encoded decimal number.
- `root_hash`: `tree_head.root_hash`, hex-encoded.
- `signature`: log signature over a serialized `tree_head`, hex-encoded.
- `cosignature`: witness signature over the same serialized `tree_head`,
  hex-encoded.
- `key_hash`: hashed witness verification key that can be used to verify the
  above cosignature.  The key is encoded as defined in [RFC 8032, section 5.1.2](https://tools.ietf.org/html/rfc8032#section-5.1.2)
  before hashing.  The resulting hash value is hex-encoded.

The `cosignature` and `key_hash` fields may repeat. The first witness signature
corresponds to the first key hash, the second witness signature corresponds to
the second key hash, etc.  At least one witness signature must be returned on
success.  The number of witness signatures and key hashes must match.

### 3.4 - get-inclusion-proof
```
GET <base url>/sigsum/v0/get-inclusion-proof/<tree_size>/<leaf_hash>
```

Input:
- `tree_size`: tree size of the tree head that the proof should be
  based on, ASCII-encoded decimal number.
- `leaf_hash`: leaf hash identifying which `tree_leaf` the log should prove
  inclusion of, hex-encoded.

Output on success:
- `leaf_index`: zero-based index of the leaf that the proof is based on,
  ASCII-encoded decimal number.
- `inclusion_path`: node hash, hex-encoded.

The leaf hash is computed using the RFC 6962 hashing strategy.  In
other words, `H(0x00 | tree_leaf)`.

`inclusion_path` must contain one or more hashes.  The order of node hashes
follow from the hash strategy, see RFC 6962.

Example:
```
$ curl <base url>/sigsum/v0/get-inclusion-proof/4711/241fd4538d0a35c2d0394e4710ea9e6916854d08f62602fb03b55221dcdac90f
```

### 3.5 - get-consistency-proof
```
GET <base url>/sigsum/v0/get-consistency-proof/<old_size>/<new_size>
```

Input:
- `old_size`: tree size of an older tree head that the log should prove is
  consistent with a newer tree head, ASCII-encoded decimal number.
- `new_size`: tree size of a newer tree head, ASCII-encoded decimal number.

Output on success:
- `consistency_path`: node hash, hex-encoded.

`consistency_path` must contain one or more hashes.  The order of node
hashes follow from the hash strategy, see RFC 6962.

Example:
```
$ curl <base url>/sigsum/v0/get-consistency-proof/42/4711
```

### 3.6 - get-leaves
```
GET <base url>/sigsum/v0/get-leaves/<start_size>/<end_size>
```

Input:
- `start_size`: index of the first leaf to retrieve, ASCII-encoded decimal
  number.
- `end_size`: index of the last leaf to retrieve, ASCII-encoded decimal number.

Output on success:
- `shard_hint`: `tree_leaf.statement.shard_hint`, ASCII-encoded decimal number.
- `checksum`: `tree_leaf.statement.checksum`, hex-encoded.
- `signature`: `tree_leaf.signature`, hex-encoded.
- `key_hash`: `tree_leaf.key_hash`, hex-encoded.

All fields may be repeated to return more than one leaf.  The first
value in each list refers to the first leaf, the second value in each
list refers to the second leaf, etc.  The size of each list must match.

A log may return fewer leaves than requested.  At least one leaf
must be returned on success.

Example:
```
$ curl <base url>/sigsum/v0/get-leaves/42/4711
```

### 3.7 - add-leaf
```
POST <base url>/sigsum/v0/add-leaf
```

Input:
- `shard_hint`: `tree_leaf.statement.shard_hint`, ASCII-encoded decimal number.
- `preimage`: the preimage used to compute `tree_leaf.statement.checksum`, hex-encoded.
- `signature`: `tree_leaf.signature`, hex-encoded.
- `verification_key`: public verification key that can be used to verify the
  above signature.  The key is encoded as defined in [RFC 8032, section 5.1.2](https://tools.ietf.org/html/rfc8032#section-5.1.2),
  then hex-encoded.
- `domain_hint`: domain name indicating where `tree_leaf.key_hash` can be found
  as a DNS TXT resource record with hex-encoding.  The left-most label must be
  set to `_sigsum_v0`.

Output on success:
- None

A submission will not be accepted if `signature` is invalid or if the retrieved
key hash does not match the specified verification key.  A submission may also
not be accepted if the second-level domain name exceeded its rate limit.
A rate limit should only be charged for the specified domain hint on success.

HTTP status 200 OK must not be returned unless the log has sequenced its Merkle
tree so that the next signed tree head merged the added leaf.  A submitter
should (re)send their add-leaf request until observing HTTP status 200 OK.

Example:
```
$ echo "shard_hint=1633039200
preimage=315f5bdb76d078c43b8ac0064e4a0164612b1fce77c869345bfc94c75894edd3
signature=0b849ed46b71b550d47ae320a8a37401129d71888edcc387b6a604b2fe1579e25479adb0edd1769f9b525d44b843ac0b3527ea12b8d9574676464b2ec6077401
verification_key=46a6aaceb6feee9cb50c258123e573cc5a8aa09e5e51d1a56cace9bfd7c5569c
domain_hint=_sigsum_v0.example.com" | curl --data-binary @- <base url>/sigsum/v0/add-leaf
```

### 3.8 - add-cosignature
```
POST <base url>/sigsum/v0/add-cosignature
```

Input:
- `cosignature`: witness signature over `tree_head`, hex-encoded.
- `key_hash`: hashed witness verification key that can be used to verify the
  above cosignature.  The key is encoded as defined in [RFC 8032, section 5.1.2](https://tools.ietf.org/html/rfc8032#section-5.1.2)
  prior to hashing.  The resulting hash value is hex-encoded.

Output on success:
- None

`key_hash` can be used to identify which witness cosigned a tree head.  A
key-hash, rather than the full verification key, is used to motivate monitors
and verifiers to locate the appropriate key and make an explicit trust decision.

Note that logs must be configured with relevant public keys for witnesses.

Example:
```
$ echo "cosignature=d1b15061d0f287847d066630339beaa0915a6bbb77332c3e839a32f66f1831b69c678e8ca63afd24e436525554dbc6daa3b1201cc0c93721de24b778027d41af
key_hash=662ce093682280f8fbea9939abe02fdba1f0dc39594c832b411ddafcffb75b1d" | curl --data-binary @- <base url>/sigsum/v0/add-cosignature
```

## 4 - Parameter summary
Ed25519 as signature scheme. SHA256 as hash function.

### 4.1 - Log
- **Public key**: public verification key that is used to verify tree head
  signatures.
- **Base URL**: Where the log can be reached over HTTP(S).  It is the
  prefix to be used to construct a version 0 specific endpoint.
- **Shard interval start**: the earliest time at which logging
  requests are accepted as the number of seconds since the UNIX epoch.
- **Shard interval end**: determined by policy.  A log that is active should
  use the number of seconds since the UNIX epoch as a dynamic shard end.

### 4.2 - Witness
- **Public key**: public verification key that is used to verify tree head
  cosignatures.
