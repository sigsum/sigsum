# Sigsum Log Server Protocol

**Status:** Stable version v1 (see [README](./README.md) for how
releases are identified and published).

**Abstract:** A sigsum log implements five HTTP endpoints to make a
submitter's signed checksums transparent in an append-only Merkle tree.
The main security property is that any checksum that is signed will
either be rejected by an offline sigsum verifier or detected by a party
monitoring the public log, thus providing key-usage transparency.  For
security, a quorum of witnesses (configurable trust policy in the
offline verifier) need to follow a cosigning protocol.  This document
specifies formats and interactions related to the sigsum log server.
A separate document specifies the witness cosigning protocol.

**Table of contents:**

<!-- toc -->
- [1.  Introduction](#1--introduction)
  - [1.1.  Objective and Threat Model](#11--objective-and-threat-model)
  - [1.2.  System Overview](#12--system-overview)
  - [1.3.  Companion Specifications](#13--companion-specifications)
- [2.  Algorithms and Formats](#2--algorithms-and-formats)
  - [2.1.  Cryptography](#21--cryptography)
  - [2.2.  Serialization](#22--serialization)
  - [2.2.1.  Request-Response Format](#221--request-response-format)
  - [2.2.2.  Merkle Tree Head](#222--merkle-tree-head)
  - [2.2.3. Cosignatures](#223-cosignatures)
  - [2.2.4.  Merkle Tree Leaf](#224--merkle-tree-leaf)
- [3.  HTTP Endpoints](#3--http-endpoints)
  - [3.1.  get-tree-head](#31--get-tree-head)
  - [3.2.  get-inclusion-proof](#32--get-inclusion-proof)
  - [3.3.  get-consistency-proof](#33--get-consistency-proof)
  - [3.4.  get-leaves](#34--get-leaves)
  - [3.5.  add-leaf](#35--add-leaf)
- [4.  Rate limiting](#4--rate-limiting)
  - [4.1.  Setup](#41--setup)
  - [4.2.  Request header](#42--request-header)
  - [4.3.  Security considerations](#43--security-considerations)
<!-- /toc -->

**Cite:**

    @misc{sigsum-log-protocol,
      author       = {{Sigsum Project}},
      title        = {Sigsum Log Server Protocol},
      howpublished = {\url{https://git.glasklar.is/sigsum/project/documentation/-/blob/main/log.md}, accessed YYYY-MM-DD},
    }

## 1.  Introduction

A sigsum log publishes signed checksums.  Together with other parties in the
sigsum system (so called witnesses and monitors), this makes it difficult for
attackers to perform undetected signature operations.

### 1.1.  Objective and Threat Model

The objective is as follows: if an unauthorized signature is made, then
that signature will either be refused by an offline verifier or it will
be detected after the fact by a monitor that takes an interest in the
associated public key.  "Offline" refers to the verifier not making any
additional outbound connections, neither while verifying nor later.

The threat model includes compromise of the submitter's signing key and
distribution system, compromise of the log itself, and compromise of
some (but not too many, subject to configured policy) of the witnesses.
In this setting, the attacker can sign a data item and produce a valid
_proof of logging_ accepted by the verifier.  However, as long as a
sufficient number of witnesses are not compromised, the unauthorized
signature stays in the public record and is thus detectable by monitors.

General denial-of-service attacks against log servers are out of scope.
In other words, attacks against the sigsum system need to go unnoticed
for the class of risk-averse attackers that we consider in scope.

### 1.2.  System Overview

There are several parties to the sigsum system:

  1. **Log**.  A log maintains an append-only Merkle-tree where each
     leaf in the tree is signed by the leaf's submitter.  The log signs
     its tree heads, and it also collects cosignatures from witnesses.
  2. **Witness**.  A witness observes tree heads from one or several
     logs, checking that they are consistent.  In other words, witnesses
     certify that each later tree head that they cosign includes
     everything that was contained by the tree heads signed previously.
  3. **Submitter**.  A submitter signs and submits a leaf to a log,
     collecting a cosigned tree head and an inclusion proof that ties
     the submitted leaf to that tree head.  This data (leaf, cosigned
     tree head, and inclusion proof) can be used as a proof of logging.
  4. **Verifier**.  A verifier receives a data item together with a
     proof of logging (using the same distribution mechanism already in
     place for the data item) and verifies, offline, that the proof is
     valid and complies with the verifier's policy.  This policy defines
     known logs and which witnesses to be depended on for security.
  5. **Monitor**.  A monitor periodically requests the latest tree head
     and corresponding leaves from one or more logs.  It ensures that
     the tree heads carry recent cosignatures by trusted witnesses, and
     that the monitor gets all leaves that make up the published tree
     heads.  A monitor usually takes particular interest in certain
     submission keys, and will output all leaves that they produced to
     enable detection of unexpected or unauthorized signatures.  Some
     monitors may additionally obtain the associated data out-of-band.

Below is a visual overview of the sigsum system and its interactions.

                        +-----------+
             +----------| Submitter |----------+
             | signed   +-----------+          | data
             | checksum       ^                | proof of logging
             v                |                v
        +---------+     proof |               ///
        |   Log   |-----------+           Distribution
        +---------+                           ///
            ^ |                               | |
            | | leaves                        | |
            | | proofs   +---------+    data  | | data
            | +--------->| Monitor |<---------+ | proof of logging
            |            +---------+            |
            |cosign           |                 v
        +---------+           |           +----------+
        | Witness |           v           | Verifier |
        +---------+         alarm         +----------+
    
    Figure 1: An overview of the sigsum system.  Depending on the
    use-case, monitors may perform additional verification of claims
    associated with the downloaded data (or not download it at all).


### 1.3.  Companion Specifications

The purpose of this document is to specify the protocol and formats used
by the log.  There are several companion specifications for other parts:

  - [A sigsum proof format][] that further details what a proof of
    logging needs to contain and how to (optionally) format it.
  - [A sigsum policy format][] that further details how a trust policy
    for logs and witnesses can be expressed and (optionally) formatted.
  - [A witness protocol][] that describes how logs collect cosignatures
    from witnesses to convince verifiers that they see the same logs.
  - [A bastion protocol][] that can proxy requests to an HTTPS server,
    such as a witness.

[A sigsum proof format]: https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/sigsum-proof.md
[A sigsum policy format]: https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/policy.md
[A witness protocol]: https://git.glasklar.is/sigsum/project/documentation/-/blob/main/witness.md
[A bastion protocol]: https://git.glasklar.is/sigsum/project/documentation/-/blob/main/bastion.md

## 2.  Algorithms and Formats

### 2.1.  Cryptography

A log uses the Merkle tree hash strategy defined in [RFC 6962, Section
2][].  Any mentions of hash functions or digital signature schemes refer
to [SHA256][] and [Ed25519][].  Ed25519 public keys are encoded as in
[RFC 8032, section 5.1.2][].  No cryptographic agility is supported,
any changes in algorithms would be handled with a whole version revision.

A _namespace_ string is attached as a prefix to all messages signed in
the sigsum system (to provide domain separation).  The namespace string
is defined as `sigsum.org/v1/<object-type>`.  This is particularly
important for leaf signatures: a sigsum log should only publish
signatures that were intended for the sigsum system.  In other words, it
should not be possible to take any valid Ed25519 signature, regardless
of the purpose for which it was made, and submit it to a sigsum log.

In objects using binary serialization, the namespace is separated from
the body of the message with a NUL character.  For Merkle tree heads,
the signed data is formatted to be compatible with the [checkpoint
format][], and in this case the namespace is new-line terminated.

[RFC 6962, Section 2]: https://tools.ietf.org/html/rfc6962#section-2
[SHA256]: https://csrc.nist.gov/csrc/media/publications/fips/180/4/final/documents/fips180-4-draft-aug2014.pdf
[RFC 8032, section 5.1.2]: https://tools.ietf.org/html/rfc8032#section-5.1.2
[Ed25519]: https://tools.ietf.org/html/rfc8032
[checkpoint format]: https://github.com/transparency-dev/formats/blob/main/log/README.md#checkpoint-format

### 2.2.  Serialization

### 2.2.1.  Request-Response Format

A log implements HTTP endpoints for accepting requests and sending
responses.  Requests that retrieve data from the log use the HTTP GET
method.  Requests that add data to the log use the HTTP POST method.

Input data in HTTP GET requests are expressed as ASCII values that are
slash-delimited (`/`) at the end of the respective endpoint URLs.  For
example, to retrieve the first two leaves `[0,2)` a client may HTTP GET
a log using a URL similar to `https://example.org/get-leaves/0/2`.  The
order of values is defined by the respective endpoints, see Section 3.

Input data in HTTP POST requests and output data in responses are
expressed as ASCII-encoded key-value pairs, formatted as `Key=Value\n`.
Everything before the first equal-sign is considered a key.  Everything
after the first equal sign and before the next new line character is
considered a value.  Keys must appear in the order specified by the
respective endpoints.  Some endpoints support keys that are repeated
zero or more times.  Only the final key may be a repeated key.

Example output from the `get-inclusion-proof` endpoint:

    leaf_index=2
    node_hash=35fd6eb70d46d60679775c346225688e6e84c02c3c7978e5c51daf8decc22d2f
    node_hash=11a2b46fb34efed4abbd144f8666bda8b83ee2ee6f7685062ed5cd68d616412a

Binary input (such as cryptographic hashes) must be in [base16][], also
known as hex-encoding.  Hex-encoding is not case-sensitive on the wire.

Data that represents integers (such as leaf indices and timestamps)
must be a sequence of one or more ASCII decimal digits, regex
`0|[1-9][0-9]*`.  Integer values exceeding 2^63 - 1 are not allowed.
This range, rather than the full range of an unsigned 64-bit integer,
lets implementations represent values using a signed or an unsigned
64-bit integer type.

[base16]: https://datatracker.ietf.org/doc/html/rfc4648#section-8

### 2.2.2.  Merkle Tree Head

A tree head is composed of a size (i.e., the number of leaves) and an
associated root hash.  It is serialized before signing as three lines:

  1. `sigsum.org/v1/tree/` followed by the _lowercase hex encoding_ of
     the log's key hash.
  2. The number of leaves in decimal with no leading zero or signs,
     regex `0|[1-9][0-9]*`.
  3. The [base64-encoding][] of the Merkle tree root hash.

A log signs the serialized tree head directly using Ed25519.  The same
public key must never be used to sign tree heads from other logs.

Example serialization:

    sigsum.org/v1/tree/d99ec0951097ff7b46d6e333ab0f7a68f443846bc81c44b97a7888b6aec31040
    15368405
    31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=

Note that each line is terminated by a new-line (`0x0a`), and that this
format happens to be compatible with the existing [checkpoint format][].

[base64-encoding]: https://datatracker.ietf.org/doc/html/rfc4648#section-4

### 2.2.3. Cosignatures

When a witness cosigns a tree head, two additional lines are
prepended to the above serialization of the tree head,
for a total of 5 lines.

The first line is the fixed string "cosignature/v1", to provide domain
separation. The convention of using a "sigsum.org" namespace is not
applied here, since we aim for interoperability with witnesses
otherwise unrelated to the Sigsum project. The second line consists of
the string "time", a single space, and a decimal timestamp
representing the number of seconds since the UNIX epoch (January 1, 1970
00:00 UTC). The next three lines are the serialized tree head, i.e.,
the same data that is signed by the log itself.

Example serialization:

    cosignature/v1
    time 1679315147
    sigsum.org/v1/tree/3620c0d515f87e60959d29a4682fd1f0db984704981fda39b3e9ba0a44f57e2f
    15368405
    31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=

To cosign a tree head, a witness signs this serialization directly
using Ed25519. Semantically, a v1 cosignature is a statement that, as
of the given time, the *consistent* tree head *with the largest size*
the witness has observed for the log identified by that key has the
specified hash.

See [A witness protocol][] for more details on the witness protocol.

### 2.2.4.  Merkle Tree Leaf

A tree leaf contains a (SHA256) checksum, a signature, and a key hash.
It is serialized by concatenating these three binary values in-order,
resulting in exactly 128 bytes.  No other leaf types are supported.

This happens to be the following struct with [Trunnel-serialization][]:

    struct tree_leaf {
        u8 checksum[32];
        u8 signature[64];
        u8 key_hash[32];
    }

`checksum` is the hash of a `message` submitted to the log.  This
message is meant to represent some data.  It is recommended that the
submitter uses `H(data)` as the message, in which case `checksum` is
`H(H(data))`.  Logs must reject messages that are not exactly 32 bytes,
making it unlikely that any personally identifiable data is observed.

`signature` is computed over the concatenation of the namespace string
`sigsum.org/v1/tree-leaf`, a single NUL character, and the `checksum`.
In total, 56 octets are signed directly with Ed25519 by the submitter.

`key_hash` is a hash of the submitter's public key.  It is included in
`tree_leaf` so that each leaf can be attributed to its own submitter.

[Trunnel-serialization]: https://gitweb.torproject.org/trunnel.git

## 3.  HTTP Endpoints

A log must have at least one fixed and unique URL.  A few examples:

  - `https://sigsum.org/`
  - `https://logs.sigsum.org:8443/prod/`
  - `http://er3n3jnvoyj2t37yngvzr35b6f4ch5mgzl3i6qlkvyhzmaxo62nlqmqd.onion/`

This URL is henceforth referred to as a log's _base URL_.  To form a
complete URL, an endpoint's name and parameters (if any) are appended.

The HTTP status code is 200 OK to indicate success.  A different HTTP
status code is used to indicate partial success or failure.  Note that
other HTTP components, e.g., a caching frontend, can generate errors
before requests reach the log server.  For this reason, clients must be
prepared to encounter arbitrary status codes.

This specification documents the status codes that should be generated
by an implementation of the sigsum log endpoints.  See Table 1 for a
short summary.  Some status codes are documented further for each
endpoint.  Unless the status code is 2XX, the response-body must contain
a human-readable string describing the error, e.g., "Invalid signature".

  **Table 1:** Overview of HTTP status codes used by log servers.

  | Status code               | Description                                       |
  | ------------------------- | ------------------------------------------------- |
  | 200 Success               | Successful request                                |
  | 202 Accepted              | Partially successful request, see Section 3.5     |
  | 400 Bad Request           | Invalid encoding or missing/invalid parameters    |
  | 403 Forbidden             | Invalid signature                                 |
  | 404 Not Found             | Endpoint or requested data does not exist         |
  | 405 Method Not Allowed    | GET request to POST-only endpoint (or vice versa) |
  | 429 Too Many Requests     | Some rate-limit kicked-in, see, e.g., Section 3.5 |
  | 500 Internal Server Error | Backend failure or implementation bug             |

### 3.1.  get-tree-head

Returns a tree head and any associated cosignatures.  The log should
wait to update the published tree head until it collected a satisfactory
number of cosignatures. The list of cosignatures may change over time.

    GET <base URL>/get-tree-head

**Input:**

  - None

**Output on success:**

  - `size`: log size, ASCII-encoded decimal number.
  - `root_hash`: Merkle tree root hash, hex-encoded.
  - `signature`: log signature for the above tree head, hex-encoded.
  - `cosignature`: repeated zero or more times. The value on each line
    consists of 3 fields, separated by single space characters. The
    first field is the hash of the witness' public key, in hex, the
    second field is the cosignature timestamp, in decimal, and the
    third field is the witness' cosignature, in hex.

**Example:**

    $ curl <base URL>/get-tree-head
    size=1285
    root_hash=8100f29c0e9017a7512dab0911bf06a4b5b99cd77d8c710635307b5d217af1f6
    signature=e327fe13e5c3d2043cbf69fe1b778f77cb10a8e14fc09309dd375c9af25903f9ec35906cfb2c36ab2d210329eb538a6673487d2d101800370c978634b6f9f70d
    cosignature=1a450ecf1f49a4e4580c35e4d83316a74deda949dbb7d338e89d4315764d88de 1687170591 cacc54d315609b796f72ac1d71d1bbc15667853ed980bd3e0f957de7a875b84bd2dcde6489fc3ed66428190ce588ac1061b0d5748e73cfb887ebf38d0b53060a
    cosignature=73b6cbe5e3c8e679fb5967b78c59e95db2969a5c13b3423b5e69523e3d52f531 1687170591 7f568da17c57ea322a9c2668ae9fc2c1d6ab5556d9a997e7bfa1cbc4dc5cf7b94e0cead42d481bf0d3d90ad2ee0d272e9e687f8f82fddf76d37d722c6815fe0f

### 3.2.  get-inclusion-proof

    GET <base URL>/get-inclusion-proof/<size>/<leaf_hash>

**Input:**

  - `size`: tree size of the tree head that the proof should be based
    on.  ASCII-encoded decimal number, must be at least 2.
  - `leaf_hash`: leaf hash identifying which `tree_leaf` the log should
    prove inclusion of, hex-encoded.

**Output on success:**

  - `leaf_index`: zero-based index of the leaf that the proof is based
    on, ASCII-encoded decimal number.
  - `node_hash`: node hash, hex-encoded.  Repeated one or more times.

The leaf hash is computed using the RFC 6962 hashing strategy: `H(0x00 |
tree_leaf)`.  The order of the repeated `node_hash` key is also defined
in RFC 6962, i.e., the first node hash is the leaf's sibling hash.

If a leaf is not included in the tree, the log responds with status code
404 Not Found.  Note that to check inclusion in a tree of size 1, a
client can and should check inclusion locally: a given leaf is included
if and only if the `leaf_hash` and the tree's `root_hash` are equal.

**Example:**

    $ curl <base URL>/get-inclusion-proof/4/241fd4538d0a35c2d0394e4710ea9e6916854d08f62602fb03b55221dcdac90f
    leaf_index=2
    node_hash=35fd6eb70d46d60679775c346225688e6e84c02c3c7978e5c51daf8decc22d2f
    node_hash=11a2b46fb34efed4abbd144f8666bda8b83ee2ee6f7685062ed5cd68d616412a

### 3.3.  get-consistency-proof

    GET <base URL>/get-consistency-proof/<old_size>/<new_size>

**Input:**

  - `old_size`: size of an older tree head that the log should prove
    consistent with a newer tree head, ASCII-encoded decimal number.
  - `new_size`: size of a newer tree head, ASCII-encoded decimal number.

**Output on success:**

  - `node_hash`: node hash, hex-encoded.  Repeated one or more times.

For a request to be valid, `new_size > old_size > 0`.

The order of the repeated `node_hash` key is defined in RFC 6962, i.e.,
the sibling hash closest to the leaves is listed first.  Note that in
the case of the old tree being empty (size zero), consistency is per
definition trivial.  Further, for trees of the same size, a client can
and should simply do a local comparison of the respective root hashes.

**Example:**

    $ curl <base URL>/get-consistency-proof/2/5
    node_hash=3f94ccfa9482768b2ab42805df9c7612773bcb35c286a91d5aec5fbf42f50fec
    node_hash=b4e2ff9fb485b20e63b3406ee5a17ddfe6287dd7614549debdca34fefb7334e7

### 3.4.  get-leaves

    GET <base URL>/get-leaves/<start_index>/<end_index>

**Input:**

  - `start_index`: index of the first leaf to retrieve, ASCII-encoded
    decimal number.
  - `end_index`: index immediately after the last leaf to retrieve,
    ASCII-encoded decimal number.

**Output on success:**

  - `leaf`: repeated one or more times.  Each value represents the
    `tree_leaf` struct as three hex-encoded fields with a single space
    character as separator.  The first field is the leaf's checksum.
    The second field is the leaf's hashed public key.  The third field
    is the leaf's signature.

Leaf indices are zero-based, specifying a half-open interval.  In other
words, a request asks for the leaves with indices `i` for `i in
[start_index, end_index)` where `end_index > start_index`.

A sequence of consecutive leaves must be returned, starting from
`start_index`.  A log may return fewer leaves than requested, but no
fewer than one leaf for a request to be considered successful.

**Example:**

    $ curl <base URL>/get-leaves/2/5
    leaf=9c30df06dd583ec46902b9313401ce172ff119d75c438aec2f33e439f467ce83 40160c833571c121bfdc6a02006053a80d3e91a8b73abb4dd0e07cc3098d8e58a41921d8f5649e9fb81c9b7c6b458747c4c3b49cc08c869867100a7f7be78902 5aa7e6233f9f4d2efbeb9eeef766dce8ba2aa5e8cdd3f53da94b5d59e67d92fc
    leaf=a2eefef4abcafd5cb2d36fe4f30c624cab048466b73eda3100e72f8fab2d3442 aa5bd628d88be12d4f09feefe4bf65290b03bdeba8523fa38e396218140d79e0850132082914b08876cdc4a6041be8217402a57bfb8328310ad5407bc440060e 5aa7e6233f9f4d2efbeb9eeef766dce8ba2aa5e8cdd3f53da94b5d59e67d92fc
    leaf=3ad4741a750a30f08f351d8f681b8bd404c53be1ef7c61d867bd6d1786ef4317 e5ad99f22ff85c3fae259017cbbf5b0ebc7f2880aa4f234ea65d0319a88891baae4e60b7f776e867861c8744f50360b002cfaef43916745c3e18fadea1724e0a 49fee94050634ea537ffac3300a5af2d25b9b3f76836df37c2029b5c9469b007

### 3.5.  add-leaf

    POST <base URL>/add-leaf

**Input:**

  - `message`: the message used to compute `tree_leaf.checksum`,
    hex-encoded.  Must be exactly 64 hex-characters (32 bytes).
  - `signature`: `tree_leaf.signature`, hex-encoded.
  - `public_key`: public key that can be used to verify the above
    signature, hex-encoded.

**Output on success:**

  - None

A submission must not be accepted if `signature` is invalid.

Processing of the add-leaf request may be subject to rate limiting.
When a public log is configured to allow submissions from anyone, it is
expected to require an authentication token in HTTP headers as defined
in Section 4.  A submission may be refused if the submitter has exceeded
its rate limit.  Adding a leaf typically involves multiple add-leaf
requests, described further below.  The rate limit is not applied to the
number of requests, but rather to the number of unique leaves added.

HTTP status 202 Accepted indicates partial success: the log has accepted
the request, but it is not yet committed to publishing it, e.g, the leaf
may not be permanently stored and replicated yet.  A submitter should
(re)send their add-leaf request until observing HTTP status 200 OK.

Status 200 OK means that the log is committed to publishing the leaf,
and it will be included in the next signed tree head.

Status code 429 Too Many Requests is returned if the submitter is
exceeding the log's configured rate limits.

**Example:**

    $ echo "message=50d858e0985ecc7f60418aaf0cc5ab587f42c2570a884095a9e8ccacd0f6545c
    signature=510567c6349bb92984b480c43dd6e818d46578e9f4d6a69d8bac7b209463cc965129ff4776d1dc882e9963087de0d2bc57568a76b7bfe4569fac80512e70bb09
    public_key=a9e92dedad449c12e59ef2a1fb272efd3e8a9d69e8c632d29f50dff603687925" | curl --data-binary @- <base URL>/add-leaf

## 4.  Rate limiting

Domain-based rate limiting is an optional feature of the protocol, but
it is expected that a public log that allows submissions from anyone
will require it.  Using this mechanism is required only for the
`add-leaf` request, and it is intended to limit the rate at which leaves
are added to the Merkle tree, by submitter domain.

### 4.1.  Setup

To be allowed to post add-leaf requests to a public log, the submitter
must do a one-time setup, with these three steps.

  1. Create a new Ed25519 key pair, which we refer to as the rate limit
     key pair.
  2. Publish the public key in DNS, as a TXT record under a domain that
     the submitter controls.  The left most label must be `_sigsum_v1`,
     e.g., `_sigsum_v1.foo.example.com`.  The contents of the TXT record
     is the hex-encoded public key.
  3. Use the private key to sign the target log's public key.  More
     precisely, the data signed are the 59 octets formed by
     concatenating the namespace string `sigsum.org/v1/submit-token`, a
     single NUL character, and the log's public Ed25519 key.

The signature will act as the submit token. Since it's a signature on
the log's key hash, it is not valid for submission to any other log.

It is strongly recommended that this key pair is different from the one
used for the leaf signatures to be published by the log, and it may be
stored on a separate machine with looser security requirements.  There
is also no need for this key to be long-lived; it can be rotated as
frequently as desired by just adding and removing corresponding TXT
records, in accordance with the DNS TTL settings.  One could even
discard the private key as soon as the needed token has been created.

### 4.2.  Request header

When the submitter is ready to submit an `add-leaf` request to the log,
it adds a custom HTTP header `sigsum-token` to the request.  The header
value is the domain on which the rate limit key was registered (without
the left-most `_sigsum_v1` label, which is implicit), and the
hex-encoded signature created as above, separated by spaces.  Example:

    sigsum-token: foo.example.com 0b849ed46b71b550d47ae320a8a37401129d71888edcc387b6a604b2fe1579e25479adb0edd1769f9b525d44b843ac0b3527ea12b8d9574676464b2ec6077401

The log will validate this by retrieving the public key by a DNS query
on the given domain, and check that the token is a valid signature on
the log's key hash. 

If there are multiple TXT records with public keys in DNS, the log
should try them all up to an implementation-dependent limit.  We
recommend that implementations should support at least 10 keys, to
support key rotation and some flexibility in key management.  If the
signature is valid for any of those keys it is accepted, and rate limit
is applied on the domain, e.g., using [the public suffix list][] to
identify the appropriate "registered domain".

[the public suffix list]: https://publicsuffix.org/list/

### 4.3.  Security considerations

Rate limiting is not intended to protect the log server from arbitrary
denial of service attacks that overload the log's capacity in terms of
computational resources or network bandwidth.  It is only intended to
enable limiting, per domain, of the rate at which leaves are added to
the append-only Merkle tree.

Similarly to HTTP authorization using basic auth or cookies, the
submitter must use an encrypted channel for the requests that include
sigsum's submit token.  E.g., use HTTPS rather than plain HTTP.

The fixed token implies that there is no way to prevent replay attacks.
There are a couple of reasons that makes this acceptable here:

  * The tokens are visible only to submitter and log, assuming a
    properly encrypted channel.
  * Including the target log's key hash in the token means that it will
    be rejected if sent anywhere else.  So, the log cannot use it for
    submission to other logs on the submitter's behalf.

If a token is leaked, the remedy is to create a new rate limit key pair
and token and then delete the DNS record for the old compromised key.
