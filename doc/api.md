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

A _signer_ should distribute log responses to their end-users in any format that
suits them.  The (de)serialization required for _end-users_ is a small subset of
Trunnel.  Trunnel is an "idiot-proof" wire-format in use by the Tor project.

Figure 1 of our design document gives an intuition of all involved parties.

## 2 - Primitives
### 2.1 - Cryptography
Logs use the same Merkle tree hash strategy as
	[RFC 6962,§2](https://tools.ietf.org/html/rfc6962#section-2).
Any mentions of hash functions or digital signature schemes refer to
	[SHA256](https://csrc.nist.gov/csrc/media/publications/fips/180/4/final/documents/fips180-4-draft-aug2014.pdf)
and
	[Ed25519](https://tools.ietf.org/html/rfc8032).
The exact
	[signature format](https://github.com/openssh/openssh-portable/blob/master/PROTOCOL.sshsig)
is defined by OpenSSH.

### 2.2 - Serialization
Log requests and responses are transmitted using simple ASCII encodings, for a
smaller dependency than alternative parsers like JSON or percent-encoded URLs.
Some input and output data is binary: cryptographic hashes and signatures.
Binary data must be lower-case base16-encoded, also known as lower-case hex
encoding.  Using hex as opposed to base64 is motivated by it being simpler,
favoring ease of decoding and encoding over efficiency on the wire.

We use the [Trunnel](https://gitweb.torproject.org/trunnel.git)
[description language](https://www.seul.org/~nickm/trunnel-manual.html)
to define data structures that need to be (de)serialized in the log.  Data
structures that need to be signed have additional SSH-specific metadata.  For
example, metadata includes a magic preamble string and a signing context.  An
implementer can easily express the SSH signing format using Trunnel.

### 2.3 - Merkle tree
#### 2.3.1 - Tree head
A tree head contains a timestamp, a tree size, a root hash, and a key hash.

```
struct tree_head {
	u64 timestamp;
	u64 tree_size;
	u8 root_hash[32];
};
```
`timestamp` is the time since the UNIX epoch (January 1, 1970 00:00 UTC) in
seconds.  It is included so that monitors can be convinced of _freshness_ if
enough witnesses added their cosignatures.  A signer can also use timestamps
to prove to an end-user that public logging happened within some interval
	[\[TS\]](https://git.sigsum.org/sigsum/commit/?id=fef460586e847e378a197381ef1ae3a64e6ea38b).

`tree_size` is the number of leaves in a log.

`root_hash` is a Merkle tree root hash that fixes a log's structure and content.

#### 2.3.2 - (Co)signed tree head
Logs and witnesses perform (co)signing operations by treating the serialized
tree head as the message `M` in SSH's
	[signing format](https://github.com/openssh/openssh-portable/blob/master/PROTOCOL.sshsig).
The hash algorithm string must be "SHA256".  The reserved string must be empty.
The namespace field must be set to `tree_head:v0:<key-hash>@sigsum.org`, where
`<key hash>` is substituted with the log's hashed public key.  The public key is
encoded as defined in
	[RFC 8032, section 5.1.2](https://tools.ietf.org/html/rfc8032#section-5.1.2)
before hashing it.  This ensures a _sigsum log specific tree head context_ that
prevents a possible
	[attack](https://git.sigsum.org/sigsum/tree/archive/2021-08-10-witnessing-broader-discuss#n95)
in multi-log ecosystems.

A witness must not cosign a tree head if it is inconsistent with prior history
or if the timestamp is older than five (5) minutes.  This means that a witness plays
	[two abstract roles](https://git.sigsum.org/sigsum/tree/archive/2021-08-31-checkpoint-timestamp-continued#n84):
Verifier("append-only") and Verifier("freshness").

#### 2.3.3 - Tree leaf
Logs support a single leaf type.  It contains a signer's statement,
signature, and key hash.

```
struct tree_leaf {
    u64 shard_hint;
    u8 checksum_hash[32];
    u8 signature[64];
    u8 key_hash[32];
}
```

`shard_hint` is a shard hint that matches the log's shard interval.

`checksum_hash` is a hash of a preimage.  The signer submits a 32-byte preimage
representing some data.  It is recommended to set this preimage to `H(data)`, in
which case the checksum hash will be `H(H(data))`.

`signature` is computed by treating the above preimage as the message `M`
in SSH's
	[signing format](https://github.com/openssh/openssh-portable/blob/master/PROTOCOL.sshsig).
The hash algorithm string must be "SHA256".  The reserved string must be empty.
The namespace field must be set to `tree_leaf:v0:<shard_hint>@sigsum.org`, where
`<shard_hint>` is replaced with the shortest decimal ASCII representation of `shard_hint`.
This ensures a _sigsum shard-specific tree leaf context_.

`key_hash` is a hash of the signer's public verification key using the same
format as Section 2.3.2.  It is included
in `tree_leaf` so that each leaf can be attributed to a signer.  A hash,
rather than the full public key, is used to motivate monitors and end-users to
locate the appropriate key and make an explicit trust decision.

## 3 - Public endpoints
A log must have a fixed and unique log URL.  A valid log URL is any valid
HTTP(S) URL that ends with "/sigsum/v0".  Example:
```
https://log.example.com:4711/opossum/2021/sigsum/v0`.
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

### 3.1 - get-tree-head-to-cosign
Returns a tree head that witnesses should cosign.

```
GET <log URL>/get-tree-head-to-cosign
```

Input:
- None

Output on success:
- `timestamp`: `tree_head.timestamp`, ASCII-encoded decimal number.
- `tree_size`: `tree_head.tree_size`, ASCII-encoded decimal number.
- `root_hash`: `tree_head.root_hash`, hex-encoded.
- `signature`: log signature for the above tree head, hex-encoded.

### 3.2 - get-tree-head-cosigned
Returns a tree head that has been cosigned by at least one witness.  The list of
cosignatures is updated every time a new cosignature gets added.  This
endpoint is used by Signers that want _enough cosignatures as fast as possible_.

```
GET <log URL>/get-tree-head-cosigned
```

Input:
- None

Output on success:
- `timestamp`: `tree_head.timestamp`, ASCII-encoded decimal number.
- `tree_size`: `tree_head.tree_size`, ASCII-encoded decimal number.
- `root_hash`: `tree_head.root_hash`, hex-encoded.
- `signature`: log signature for the above tree head, hex-encoded.
- `cosignature`: witness signature for the above tree head, hex-encoded.
- `key_hash`: hashed witness verification key that can be used to verify the
  above cosignature.  The key is encoded as defined in [RFC 8032, section 5.1.2](https://tools.ietf.org/html/rfc8032#section-5.1.2)
  before hashing.  The resulting hash value is hex-encoded.

The `cosignature` and `key_hash` fields may repeat. The first witness signature
corresponds to the first key hash, the second witness signature corresponds to
the second key hash, etc.  At least one witness signature must be returned on
success.  The number of witness signatures and key hashes must match.

### 3.3 - get-inclusion-proof
```
GET <log URL>/get-inclusion-proof/<tree_size>/<leaf_hash>
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
$ curl <log URL>/get-inclusion-proof/4711/241fd4538d0a35c2d0394e4710ea9e6916854d08f62602fb03b55221dcdac90f
```

### 3.4 - get-consistency-proof
```
GET <log URL>/get-consistency-proof/<old_size>/<new_size>
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
$ curl <log URL>/get-consistency-proof/42/4711
```

### 3.5 - get-leaves
```
GET <log URL>/get-leaves/<start_size>/<end_size>
```

Input:
- `start_size`: index of the first leaf to retrieve, ASCII-encoded decimal
  number.
- `end_size`: index of the last leaf to retrieve, ASCII-encoded decimal number.

Output on success:
- `shard_hint`: shard hint to use as tree leaf context, ASCII-encoded decimal
  number.
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
$ curl <log URL>/get-leaves/42/4711
```

### 3.6 - add-leaf
```
POST <log URL>/add-leaf
```

Input:
- `shard_hint`: shard hint to use as tree leaf context, ASCII-encoded decimal
  number.
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

A submission will not be accepted if `signature` or `shard_hint` is invalid.
The retrieved key hash must also match the specified verification key.

A submission may not be accepted if the second-level domain name has exceeded its
rate limit.  A rate limit should only be charged for the specified domain hint
on success.

HTTP status 200 OK must not be returned unless the log has sequenced its Merkle
tree so that the next signed tree head merged the added leaf.  A submitter
should (re)send their add-leaf request until observing HTTP status 200 OK.

Example:
```
$ echo "shard_hint=1633039200
preimage=315f5bdb76d078c43b8ac0064e4a0164612b1fce77c869345bfc94c75894edd3
signature=0b849ed46b71b550d47ae320a8a37401129d71888edcc387b6a604b2fe1579e25479adb0edd1769f9b525d44b843ac0b3527ea12b8d9574676464b2ec6077401
verification_key=46a6aaceb6feee9cb50c258123e573cc5a8aa09e5e51d1a56cace9bfd7c5569c
domain_hint=_sigsum_v0.example.com" | curl --data-binary @- <log URL>/add-leaf
```

TODO: update the above with valid input.  Link
	[proposal](https://git.sigsum.org/sigsum/tree/doc/proposals/2021-11-ssh-signature-format.md)
on how one could produce it "byte-for-byte" using Python and ssh-keygen -Y.

### 3.7 - add-cosignature
=======
```
POST <log URL>/add-cosignature
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
and end-users to locate the appropriate key and make an explicit trust decision.

Note that logs must be configured with relevant public keys for witnesses.

Example:
```
$ echo "cosignature=d1b15061d0f287847d066630339beaa0915a6bbb77332c3e839a32f66f1831b69c678e8ca63afd24e436525554dbc6daa3b1201cc0c93721de24b778027d41af
key_hash=662ce093682280f8fbea9939abe02fdba1f0dc39594c832b411ddafcffb75b1d" | curl --data-binary @- <log URL>/add-cosignature
```

TODO: update the above with valid input.  Link
	[proposal](https://git.sigsum.org/sigsum/tree/doc/proposals/2021-11-ssh-signature-format.md)
on how one could produce it "byte-for-byte" using Python and ssh-keygen -Y.

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
