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
- Integers are unsigned and represented in decimal.  More precisely, an integer
  is represented as a sequence of one or more ASCII decimal digits. Integer
  values exceeding 63 bits in size are not allowed. This range (rather than the
  full range of an unsigned 64-bit integer) lets implementations represent
  values using either a signed or an unsigned 64-bit integer type. E.g, POSIX
  64-bit `time_t` and java `long` are signed types, with no convenient unsigned
  counterpart.

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
Logs use the same Merkle tree hash strategy as [RFC 6962, Section 2][]. Any
mentions of hash functions or digital signature schemes refer to [SHA256][] and
[Ed25519][]. Ed25519 public keys are always encoded according to [RFC 8032,
section 5.1.2][]. The [signature format][] is defined by OpenSSH, with hash
algorithm string `sha256`, and empty reserved string.

[RFC 6962, Section 2]: https://tools.ietf.org/html/rfc6962#section-2
[SHA256]: https://csrc.nist.gov/csrc/media/publications/fips/180/4/final/documents/fips180-4-draft-aug2014.pdf
[RFC 8032, section 5.1.2]: https://tools.ietf.org/html/rfc8032#section-5.1.2
[Ed25519]: https://tools.ietf.org/html/rfc8032
[signature format]: https://github.com/openssh/openssh-portable/blob/master/PROTOCOL.sshsig

### 2.2 - Serialization
Log requests and responses are transmitted using simple ASCII encodings, for a
smaller dependency than alternative parsers like JSON or percent-encoded URLs.
Some input and output data is binary: cryptographic hashes and signatures.
Binary data must be base16-encoded, also known as hex encoding. Using hex as
opposed to base64 is motivated by it being simpler, favoring ease of decoding
and encoding over efficiency on the wire. Hex decoding is case-insensitive.

We use the [Trunnel](https://gitweb.torproject.org/trunnel.git)
[description language](https://www.seul.org/~nickm/trunnel-manual.html)
to define data structures that need to be (de)serialized in the log.  Data
structures that need to be signed have additional SSH-specific metadata.  For
example, metadata includes a magic preamble string and a signing context.  An
implementer can easily express the SSH signing format using Trunnel.

### 2.3 - Merkle tree
#### 2.3.1 - Signed tree head

Logs perform signing operations by treating a serialized `signed_tree_head` as
the message and using `signed-tree-head:v0@sigsum.org` as the namespace.

A `signed_tree_head` contains a tree size (the number of leaves in the log) and
a Merkle tree root hash. The same log key must never be used to sign tree heads
from other trees.

```
struct signed_tree_head {
	u64 size;
	u8 root_hash[32];
}
```

#### 2.3.2 - Tree leaf
Logs support a single leaf type.  It contains a signer's statement,
signature, and key hash.

```
struct tree_leaf {
    u8 checksum[32];
    u8 signature[64];
    u8 key_hash[32];
}
```

`checksum` is a hash of the 32-byte `message` submitted by the signer.
The message is meant to represent some data and it is recommended that
the signer uses `H(data)` as the message, in which case `checksum`
will be `H(H(data))`.

`signature` is computed over the above `message` with namespace
`tree-leaf:v0@sigsum.org`.

`key_hash` is a hash of the signer's public key.  It is included in `tree_leaf`
so that each leaf can be attributed to a signer.  A hash, rather than the full
public key, is used to motivate monitors and end-users to locate the appropriate
key and make an explicit trust decision.

## 3 - Public endpoints
A log must have a fixed and unique log URL.  Example:
```
https://log.example.com:4711/opossum/2021/sigsum`.
```

Input data in `get-*` requests are added at the end of an endpoint's
URL.  Values are delimited by a `/`.  The order of values is defined by
the respective endpoints.  For an example, see Section 3.3.

Input data in `add-*` requests is POST:ed in the HTTP message body as
line-terminated ASCII key/value pairs.  The key-value format is `Key=Value\n`.
Everything before the first equal-sign is considered a key.
Everything after the first equal sign and before the next new line character is
considered a value.  Keys must appear in the order specified below.  In some
requests, the last key may be repeated 0 or more times, e.g., to represent a
list of cosignatures.  Except for these repeated keys, each key must occur exactly
once.

Output data (in replies) is sent in the HTTP message body using the same
key-value format as for `add-*` input data.
[Example](#32-get-tree-head)

The HTTP status code is 200 OK to indicate success.  A different HTTP status
code is used to indicate partial success or failure.  Note that other HTTP
components, e.g., a caching frontend, can generate errors before the requests
gets to the sigsum server, and for this reason, clients must be prepared to
encounter arbitrary status codes. This specification only documents the status
codes that should be generated by an implementation of the sigsum endpoints.

Status codes common to all endpoints:

- 200 Success
- 400 Bad Request (bad encoding, out of range parameters, missing parameters)
- 403 Forbidden (invalid signature)
- 404 Not Found (endpoint doesn't exist, or requested data doesn't exist)
- 405 Method Not Allowed (GET request to POST-only endpoint, or vice versa)
- 500 Internal Server Error (backend failure, or implementation bug)

The specification for each endpoint documents any additional status codes that
may be returned for that end point.

On failure, the log's response body must contain a human-readable string describing
what went wrong, e.g., "Invalid signature".

### 3.1 - get-tree-head
Returns a tree head and any associated co-signatures.  The log should wait to
update the published tree head until it has collected a satisfactory number of
co-signatures. The list of co-signatures may change over time.

```
GET <log URL>/get-tree-head
```

Input:
- None

Output on success:
- `size`: log size, ASCII-encoded decimal number.
- `root_hash`: Merkle tree root hash, hex-encoded.
- `signature`: log signature for the above tree head, hex-encoded.
- `cosignature`: repeated key, as described in Section 2 of [the witness API
document](./witness.md).

Example request:
```
$ curl <log URL>/get-tree-head
```
Example response:
```
size=10037
root_hash=e0797361b952f44c4ea73a93ba3ac7b13b809bafd5fd81ab3a0bf5e7a273c90b
signature=73ca29e903a81e750434ccd76d5c37dbd6219d2e0df162f48a8a0e52cc2066a4ec8bf5f8a57724e7fb3e009cbbc5a063bf0e70ebe01bcc422d727a363b6ef4f7
cosignature=a82e590febc6b84385b0f20c3cf33636441609c16bd5539624cb930838e083e4 1666856001 3c7061b10982d8180b08e63cd87d78df97074dbc867f08f23925a9f4525281bd999cbd5aa55356783c08aec72bf13c20806583389e63fb63fad43b3e57c4251e
cosignature=7c5725cdea3514e2b29a98b3f3b48541538d5561f10ae7261b730ee43bce54ef 1666856002 1efd1ae64eb8f198712597dc9fe0e4bd01e584590b24e321155513f698699c1bc0d6df470da55c78c808d0a30bd68b26a5e9f9d6e45c5c4ef746dc48a4da5c7a
```

TODO: update the above with valid input and also provide corresponding keys so
signatures can be verified.

### 3.2 - get-inclusion-proof
```
GET <log URL>/get-inclusion-proof/<size>/<leaf_hash>
```

Input:
- `size`: tree size of the tree head that the proof should be
  based on, ASCII-encoded decimal number, must be at least 2.
- `leaf_hash`: leaf hash identifying which `tree_leaf` the log should prove
  inclusion of, hex-encoded.

Output on success:
- `leaf_index`: zero-based index of the leaf that the proof is based on,
  ASCII-encoded decimal number.
- `node_hash`: node hash, hex-encoded.

The leaf hash is computed using the RFC 6962 hashing strategy.  In
other words, `H(0x00 | tree_leaf)`.

`node_hash` is a repeated key, listing one or more hashes.  The order of node hashes
follow from the hash strategy, see RFC 6962.

If the leaf hash isn't present in the tree, the log responds with status code
404 Not Found.

Note that to check inclusion in a tree of size 1, a client can and
should check inclusion locally: A given leaf is included if and only
if the `leaf_hash` and the tree's `root_hash` are equal.

Example:
```
$ curl <log URL>/get-inclusion-proof/4711/241fd4538d0a35c2d0394e4710ea9e6916854d08f62602fb03b55221dcdac90f
```

### 3.3 - get-consistency-proof
```
GET <log URL>/get-consistency-proof/<old_size>/<new_size>
```

Input:
- `old_size`: tree size of an older tree head that the log should prove is
  consistent with a newer tree head, ASCII-encoded decimal number.
- `new_size`: tree size of a newer tree head, ASCII-encoded decimal number.

Output on success:
- `node_hash`: node hash, hex-encoded.

`node_hash` is a repeated key, listing one or more hashes. The
order of node hashes follow from the hash strategy, see RFC 6962.

It's required that `new_size` > `old_size`> 0. In the case of the old
tree being empty, consistency is trivial, and for trees of the same
size, a client can and should do a local comparison of respective
tree's `root_hash`.

Example:
```
$ curl <log URL>/get-consistency-proof/42/4711
```

### 3.4 - get-leaves
```
GET <log URL>/get-leaves/<start_index>/<end_index>
```

Input:
- `start_index`: index of the first leaf to retrieve, ASCII-encoded decimal
  number.
- `end_index`: index just after the last leaf to retrieve, ASCII-encoded decimal number.

Output on success:
- `leaf`: Repeated key, see below.

The leaf indices are zero-based, and specify a half-open interval, i.e.,
the request asks for the leaves with indices `i`, `start_index` <= `i`
< `end_index`. It is required that `end_index` > `start_index`.

The value for the `leaf` represents the `tree_leaf` struct, and it consists of
three hex-encoded fields, with a single space character as separator. The first
field is the checksum, second is hash of the key used to sign the checksum, and
the third and last field is the signature.

The log returns a sequence of consecutive leaves, starting from
`start_index`. A log may return fewer leaves than requested. At least
one leaf must be returned on success.

Example:
```
$ curl <log URL>/get-leaves/42/4711
```

### 3.5 - add-leaf
```
POST <log URL>/add-leaf
```

Input:
- `message`: the message used to compute `tree_leaf.statement.checksum`, hex-encoded.
- `signature`: `tree_leaf.signature`, hex-encoded.
- `public_key`: public key that can be used to verify the
  above signature.  The key is encoded as defined in [RFC 8032, section 5.1.2](https://tools.ietf.org/html/rfc8032#section-5.1.2),
  then hex-encoded.

Output on success:
- None

A submission will not be accepted if `signature` is invalid.

Processing of the add-leaf request may be subject to rate limiting.
When a public log is configured to allows submissions from anyone, it
is expected to require an [authentication token](#5-rate-limiting)
passed in HTTP headers. A submission may be refused if the submitter
has exceeded its rate limit. By above, adding a leaf typically
involves multiple add-leaf requests. The rate limit is not applied to
the number of requests, but rather to the number of unique leaves
added.

Status code 202 Accepted indicates partial success: the log has accepted the
request, but the log is not yet committed to publishing it, e.g, the leaf may not
yet be permanently stored and replicated.  A submitter should (re)send their
add-leaf request until observing HTTP status 200 OK.

Status 200 OK means that the log is committed to publishing the leaf, and it
will be included in the next signed tree head.

Status code 429 Too Many Requests is returned if the submitter is exceeding the
log's configured rate limits.

Example:
```
$ echo "message=315f5bdb76d078c43b8ac0064e4a0164612b1fce77c869345bfc94c75894edd3
signature=0b849ed46b71b550d47ae320a8a37401129d71888edcc387b6a604b2fe1579e25479adb0edd1769f9b525d44b843ac0b3527ea12b8d9574676464b2ec6077401
public_key=46a6aaceb6feee9cb50c258123e573cc5a8aa09e5e51d1a56cace9bfd7c5569c" | curl --data-binary @- <log URL>/add-leaf
```

TODO: update the above with valid input.  Link
	[proposal](./proposals/2021-11-ssh-signature-format.md)
on how one could produce it "byte-for-byte" using Python and ssh-keygen -Y.

## 4 - Parameter summary
Ed25519 as signature scheme. SHA256 as hash function.

### 4.1 - Log
- **Public key**: public key that is used to verify tree head
  signatures.
- **Base URL**: Where the log can be reached over HTTP(S).  It is the
  prefix to be used to construct a version 0 specific endpoint.

## 5 - Rate limiting

Domain-based rate limiting is an optional feature of the protocol, but
it is expected that a public logs that allows submissions from anyone
will require it. Using this mechanism is required only for the
`add-leaf` request, and it is intended to limit the rate at which
leaves are added to the Merkle tree, by submitter domain.

### 5.1 Setup

To be allowed to post add-leaf requests to a public log, the submitter
must do a one-time setup, with these three steps.

1. Create a new ed25519 key pair, which we refer to as the rate limit
   key pair.

2. Publish the public key in DNS, as a TXT record under a domain that
   the submitter controls. The left most label must be `_sigsum_v0`,
   e.g., `_sigsum_v0.foocorp.example.com`. The contents of the TXT
   record is the hex-encoded public key.
   
3. Use the private key to sign the target log's public key. More
   precisely, use the log's public ed25519 key (formatted according to
   [RFC 8032, section
   5.1.2](https://tools.ietf.org/html/rfc8032#section-5.1.2)), and use
   as message `M` in SSH's signing format. The hash algorithm string
   must be "sha256". The reserved string must be empty. The namespace
   field must be set to `submit-token:v0@sigsum.org`.

The signature will act as the submit token. Since it's a signature on
the log's key hash, it is not valid for submission to any other log.

It is strongly recommended that this key pair is different from the
one used for the leaf signatures to be published by the log, and it
may be stored on a separate machine with looser security requirements.
There is also no need for this key to be long-lived; it can be rotated
as frequently as desired by just adding and removing corresponding TXT
records, in accordance with the DNS TTL settings. One could even
discard the private key as soon as the needed token has been created.

### 5.2 Request header

When the submitter is ready to submit an `add-leaf` request to the
log, it adds a custom HTTP header `sigsum-token` to the request. The
header value is the domain on which the rate limit key was registered
(without the left-most `_sigsum_v0` label, which is implicit),
and the hex-encoded signature created as above, separated by spaces.
E.g.,
```
sigsum-token: foocorp.example.com 0b849ed46b71b550d47ae320a8a37401129d71888edcc387b6a604b2fe1579e25479adb0edd1769f9b525d44b843ac0b3527ea12b8d9574676464b2ec6077401
```
The log will validate this by retrieving the public key by a dns query
on the given domain, and check that the token is a valid signature on
the log's key hash. 

If there are multiple TXT records with public keys in DNS, the log
should try them all up to an implementation-dependent limit. We
tentatively recommend that implementations should support at least 10
keys, to support key rotation and some flexibility in key management.
If the signature is valid for any of those keys it is accepted, and
rate limit is applied on the domain, e.g., using
https://publicsuffix.org/list/ to identify the appropriate "registered
domain".

### 5.3 Security considerations

First, recall that rate limit isn't intended to protect the log server
from arbitrary denial of service attacks to overload the log's
capacity in terms of computational resources or network bandwidth. It
is only intended to enable limiting, per domain, of the rate at which
leaves are added to the Merkle tree.

Similarly to HTTP authorization using basic auth or cookies, the
submitter must use an encrypted channel for the requests that include
sigsum's submit token. E.g., use HTTPS rather than plain HTTP.

The fixed token implies that there is no way to prevent replay
attacks. There are a couple of reasons that this is ok for this
application.

* The tokens are visible only to submitter and log (assuming a
  properly encrypted channel).

* Including the target log's key hash in the token means that it will
  be rejected if sent anywhere else. So the log can't use it for
  submission to other logs on the submitter's behalf.

If the token is leaked, the remedy is to create a new rate limit key
pair and token, and delete the DNS record for the old key.