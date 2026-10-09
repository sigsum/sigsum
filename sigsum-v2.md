# Sigsum v2 [DRAFT]

Main substantial changes to the current version 1 are in section 2
and 3. Open questions and discussion are in section 5.

## 1.  Introduction

A Sigsum log publishes signed checksums.  Together with other parties in the
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

## 2.  Algorithms and Formats

### 2.1.  Cryptography

A log uses the Merkle tree hash strategy defined in [RFC 6962, Section
2][].  Any mentions of hash functions refer
to [SHA256][].

Ed25519 public keys and signatures are encoded as in [RFC 8032, section 5.1.2][].

MLDSA-44 public keys and signatures are defined in [NIST FIPS 204][].

Hybrid Ed25519-MLDSA-44 public keys and signatures are defined in
[draft-ietf-lamps-pq-composite-sigs-19][] instantiated with paramers
compatible with SSH usage as in
[draft-miller-sshm-composite-sigs-01][]. In particular, the prehash
function is SHA512, the "label" is "COMPSIG-MLDSA44-Ed25519-SHA512",
and the context is always empty. This means that the message passed to
the component signature algorithms is

```
M' = "CompositeAlgorithmSignatures2025" | "COMPSIG-MLDSA44-Ed25519-SHA512" | NUL | SHA512(msg)
```

When signing using the MLDSA component, the label string is also used
as the MLDSA signing context.

[RFC 6962, Section 2]: https://tools.ietf.org/html/rfc6962#section-2
[SHA256]: https://csrc.nist.gov/csrc/media/publications/fips/180/4/final/documents/fips180-4-draft-aug2014.pdf
[RFC 8032, section 5.1.2]: https://tools.ietf.org/html/rfc8032#section-5.1.2
[Ed25519]: https://tools.ietf.org/html/rfc8032
[checkpoint format]: https://github.com/transparency-dev/formats/blob/main/log/README.md#checkpoint-format
[NIST FIPS 204]: https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.204.pdf
[
[draft-miller-sshm-composite-sigs-01]: https://datatracker.ietf.org/doc/html/draft-miller-sshm-composite-sigs-01
[draft-ietf-lamps-pq-composite-sigs-19]: https://datatracker.ietf.org/doc/html/draft-ietf-lamps-pq-composite-sigs-19

A _namespace_ string is attached as a prefix to all messages signed in
the sigsum system (to provide domain separation). For sigsum-specific
items namespace string is defined as `sigsum.org/v2/<object-type>`,
`c2sp.org/...` may occur for items not specific to sigsum. The
namespace is particularly important for leaf signatures: a sigsum log
should only publish signatures that were intended for the sigsum
system. In other words, it should not be possible to take any valid
signature, regardless of the purpose for which it was made, and submit
it to a sigsum log.

In objects using binary serialization, the namespace is separated from
the body of the message with a NUL character.

### 2.2.  Checkpoints

Sigsum publishes the log's state in the form of checkpoints. A
[tlog-checkpoint][] is composed of a size (i.e., the number of leaves) and
an associated root hash, followed by the log's signature and zero or
more witness cosignatures.

[tlog-checkpoint]: https://c2sp.org/tlog-checkpoint@v1.1.0

### 2.3.  Merkle Tree Leaf

The leaf format is intended to be compatible with the in-progress
[tlog-identity][] format. In [Trunnel-serialization][]:

    struct tree_leaf {
        u8 version; // 1
        u8 key_hash[32];
        u8 checksum[32];
        u8 context_name[32]; // H(H("sigsum.org/v2/signing-context"))
        u8 context_hash[32];
        u8 signature_hash[32];
    }

The version is always one. The `key_hash` is the hash of the
submitter's public key. The key hash is the hash of the raw public key blob,
with no algorithm id or namespace attached. E.g., for Ed25519, it's
hash of 32 bytes, and for MLDSA-44, it's a hash of 1312 bytes.

The `checksum` is the hash of a 32-byte message submitted to the log.
This message is meant to represent some data. It is recommended that
the submitter uses `H(data)` as the message, in which case `checksum`
is `H(H(data))`.

The double hashing that is applied to the `checksum` and below fields
is intended to protect the log from poisoning (log doesn't publish
any user data verbatim) and submitte privacy (the log doesn't get to
see underlying data).

The `context_name` and `context_hash` form a name/value pair. The
`context_name` is the double hash of a fixed string (with double
hashing to support other logs that accept arbitrary name/value pairs),
and the `context_hash` is the hash of a a 32-byte context provided
together with the message. Like for the message, it is expected that
the submitter's context is the hash of some meaningful identifier, and
then the `context_hash` will be the double hash of that identifier.

In the submission process, the handling of the `checksum` and the
`context_hash` are identical. Intended usage is different, though. The
expectation is that the `context_hash` represents a closed set of
values, e.g., the set of projects maintained by the same organization
or individual (as represented by the `key_hash`). While the `checksum`
represents an open set of data items, e.g., all software artifacts
that might be produced within any of those projects.

The `signature_hash` is the hash of a valid signature that can be
verified by the public key identified by the `key_hash`. The data
being signed is a namespace prefix, followed by a NUL byte, followed
by the preceding bytes of the leaf starting from the version byte.
Namespace could be `sigsum.org/v2/tree-leaf`, or something common
within c2sp.

It is the log's responsibility to verify signatures before adding an
entry to the log, and to archive and serve the corresponding
signatures.

TODO: Note that in this format there's no identifier for the signature
algorithm used. Adding such an explicit id is under consideration, but
without it the expectation is that anyone interested in verifying the
signature already knows the public key underlying the `key_hash`, and
that implies knowledge of which algorithm to use.

[tlog-identity]: https://github.com/C2SP/C2SP/pull/244
[Trunnel-serialization]: https://gitweb.torproject.org/trunnel.git

### 2.4.  Sigsum proofs

Sigsum profs of logging are represented using [tlog-proof][]. The
`extra` line is used to convey additional Sigsum-specific information
that is needed to reconstruct the leaf, verify the inclusion proof,
and verify the submitter's signature. The extra line is the
base64-encoding of

    struct tree_leaf {
        u8 key_hash[32];
        u8 signature[];
    }

To verify a Sigsum proof, in addition to a [tlog-policy][], the
verifier must be configured with a list of authorized submitter keys,
and the expected context.

Recall the general procedure for verifying a tlog-proof:

1. Compute the leaf hash. This step is application specific.

2. Check that the checkpoint origin line is acceptable, and that the
   checkpoint is signed by a log public key configured for that origin
   line.

3. Verify all cosignatures for witnesses known to the verifier. Which
   subsets of witnesses are considered strong enough, is determined by
   application policy. One possible policy is to require k valid
   cosignatures out of n known witnesses; more complex policies are
   possible but out of scope for this document.

4. Check that the inclusion proof is valid, to bind the leaf hash
   computed in step 1 to the the root hash of the signed checkpoint.

For a Sigsum proof, step 1 decomposes as follows:

1.1. Extract `key_hash` and `signature` from the `extra` line.

1.2. Check that the `key_hash` matches one of the authorized submitter
     keys. This is the key to be used in Step 1.5 below.

1.3. Compute `checksum = H(message)`, where in turn `message`
     typically is the hash of the artifact with which the proof s
     associated. Also compute the `context_hash` from the configured
     expected context, typically this is a double hash of some
     meaningful identifier.

1.4. Construct the leaf-sans-signature, starting from the `version` byte
     and ending with the `context_hash`.

1.5. Verify the submitter's signature. The message signed is the
     leaf-sans-signature with appropriate namespace prepended, and the
     public key is the one identified by the `key_hash`.

1.6. Construct the full leaf, including the `signature_hash`, and
     compute the Merkle tree leaf hash by prepending a single zero
     byte and hashing.

Then pass the leaf hash on to the remaining verification steps.

[tlog-proof]: https://c2sp.org/tlog-proof

## 3.  HTTP Endpoints

A log must have at least one fixed and unique URL.  A few examples:

  - `https://sigsum.org/`
  - `https://logs.sigsum.org:8443/prod/`
  - `http://er3n3jnvoyj2t37yngvzr35b6f4ch5mgzl3i6qlkvyhzmaxo62nlqmqd.onion/`

This URL is henceforth referred to as a log's _prefix URL_.  To form a
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

### Tile api

TODO: Improve consistency with tlog-tiles conventions and terminology.
In particular, tlog-tiles uses a `<prefix>` with no trailing slash,
and it consistently talks about log entries rather than tree leaves.

A Sigsum log must support the [tlog-tiles][] api, including the
endpoints `checkpoint`, `tile/...`, `tile/entries/...`.

### Serving the signatures

The way the signatures are served is analoguous to how leaf data is
served. More precisely, signatures are served as "signature bundles" at
```
signatures/<N>[.p/<W>]
```
Signature bundles are sequences of big-endian uint16 length-prefixed
signatures. Each signature MUST match the `signature_hash` in the
corresponding leaf.

TODO: Would be desirable to serve signatures in a way that can be
understood by [tlog-addenda][]?

[tlog-tiles]: https://c2sp.org/tlog-tiles@v1.0.0
[tlog-addenda]: https://github.com/C2SP/C2SP/pull/353

### Submitting entries

New log entries are submitted using
```
POST <prefix>/sigsum-submit
```
The input is a file of this form:
```
message <message>
context <context>
public_key <type> <key>
signature <signature>
```
The fields are separated by a single space character, and each line
terminated by a single newline character.

The `message` and `context` values are 32 bytes each,
base64-encoded into 43 "digits" and a single trailing `=` character
for padding. These are hashed by the log and used to populate the
`checksum` and `context` values in the leaf.

The `type` is a literal string identifying the signature algorithm.
Supported values are `ed25519`, `mldsa44` and
`compsig-mldsa44-ed25519`. The `key` and `signature` are
base64-encoded values, size determined by the signature algorithm.

The details of what is signed is described above under Merkle Tree
Leaf. A submission MUST NOT be accepted if the `signature` is invalid.

HTTP status 202 Accepted indicates partial success: the log has accepted
the request, but it is not yet committed to publishing it, e.g, the leaf
may not be permanently stored and replicated yet.  A submitter should
(re)send their sigsum-submit request until observing HTTP status 200 OK.

Status 200 OK means that the log is committed to publishing the leaf,
and it will be included in the next signed tree head. The response
body MUST contain a single line with the entry's index in decimal.

Processing of the sigsum-submit request may be subject to rate
limiting. When a public log is configured to allow submissions from
anyone, it is expected to require an authentication token in HTTP
headers as defined in Section 4. A submission may be refused if the
submitter has exceeded its rate limit. Submitting a log entry
typically involves multiple sigsum-submit requests, described above.
The rate limit is not applied to the number of requests, but rather to
the number of unique entries added.

Status code 429 Too Many Requests is returned if the submitter is
exceeding the log's configured rate limits.

# 4.  Rate limiting

TODO: Intended to be structurally unchanged since sigsum v1, but may
need to be extended beyond Ed25519. Could possibly be synchronized
with ongoing work on authentication for the witness protocol.

# 5.  Open questions

## Do we want strong deduplication?

We need weak deduplication to support the submission process where
submitter repeats the same sigsum-submit call as long as response
status is 202.

Strong deduplication implies that a Sigsum proof for an item with
index N (including a cosigned checkpoint for size > N) and an
additional cosigned checkpoint for size <= N, proves that the entry
was added into the log between the timestamps on the cosignatures of
those two checkpoints. This may be a useful property, however, it
clearly can't exclude that the item was present elsewhere at an
earlier time.

To get an indication of the cost of the large index needed for strict
deduplication, consider this implementation strategy (suggested by Per
Zetterlund):

On disk, maintain one or more files representing all "old" leaf hashes
in lexicographic order. In RAM, maintain a coarse index, e.g., the
first entry of each file on disk, as well as the set of all "new" leaf
hashes that are not yet committed to disk. To look up a leaf hash,
first consult the map of new leaf hashes. If not found, do binary
search in the coarse index to identify the section of disk storage
where the leaf hash may be, and then do a linear or binary search of
that section of disk storage. When the size of the mapping in RAM
exceeds some threshold, do a linear merge operation rewriting some or
all of the files on disk.

A large log (say, 2^40 entries) will need about 160 TB storage for
leaves, and 32 TB each for the level 0 tiles and the deduplication
index. The index is not precious; it can always be recreated by
sorting the data in the level 0 tiles.

## How to define key hashes?

Should the hash be a hash of the raw keyblob, or include an algorithm
id? Can this be sigsum-specific, or should it be part of the shared
leaf spec?

It appears to be good hygiene to somehow bind the signature algorithm
used into the Merkle tree leaf, but this can be done either with an
explicit id field, or by including it in the key hash.

## Use cases with many valid contexts?

E.g., consider distribution of binary packages, with the context
defined as a a serialization of the pair `{package name,
architecture}`. If a verifier is configured to accept any package for
a given archtecture, or any architecture for a given package name, or
some other kind of subset of the package/arch space, then the context
would have to be conveyed in part or in full together with the proof.

For the such a "structured" context to make sense, it must still be a
closed set in the sense that a monitor for key usage transparency
ought to be configured with the complete set of package names and
architectures and construct an inverse map from `context_hash` to
`{package name, architecture}`. If the monitor observes an unknown
`context_hash`, that results in an alert that either the monitor's
configuration is outdated, or a signature with an unauthorized context
has been made.

The benefits of using such a structured context compared to the
alternatives are a bit unclear; it can be seens as a middle way
between these two alternatives:

1. Use two name/value pairs in the leaf, one for package name, one for
   arch.

2. Don't use the context (i.e., this is the sigsum/v1-compatible
   alternative), and don't log the artifact itself, instead log a
   "manifest" that is the serialization of the triple `{package name,
   arch, H(artifact)}`. The submitter archive service must serve the
   manifests indexed by checksum, and a monitor would use this
   service. If a manifest can't be looked up, the monitor's situation
   is in some ways similar to a monitor seeing an unknown
   `context_hash`. The crucial difference is that when seeing a leaf
   with an unknown `context_hash`, one can infer that verifiers that
   also don't recognize that `context_hash` will reject any tlog-proof
   referring to this leaf in the log.

## Replication

For reliability, a Sigsum log should replicate all data before
publishing a checkpoint; if a log goes down and data is lost, it is
possible that a proof of logging with a valid cosigned checkpoint is
produced and distributed, without monitors getting a chance to observe
corresponding log contents.

The replication is not directly visible to log users, but important
for system properties.

There is always one primary node for a log; this is the server to
which new entries can be submitted. There should be at least one
secondary node, mirroring the primary.

The core part of replication, or mirroring, is that the secondary node
copies all entries _accepted_ by the primary node. The accepted
entries include entries for which the log has replied 202 Accepted,
but since they are not yet replicated, the log has not yet published a
checkpoint that includes them, and they are not accessible using the
standard tiles api.

There are a few options on how to do this. The [tlog-mirror][]
protocol is closely related, but it deals only with the log entries;
for Sigsum, it would need an extension to also replicate the signature
tiles.

Another option would be to have a parallel tiles api including a
"local" checkpoint, signed by a different key than the main log
signing key. Semantics of that signature would then be that entries
are accepted, persisted to local storage, but with no commitment on
reliability. Mirrors could then copy the data using the tiles api
(inclusing the signature tiles), and publish their own "local"
checkpoints. See
https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-general@lists.sigsum.org/thread/FTCY5L7X6FY2J4RSTZOXWPPXU3QYPCF4/
for earlier ideas related to this approach.

Another open question is if replication should be viewed as internal
operational detail of the log operator, or if the published
checkpoints should include cosignatures from mirrors, to make the
replication state explicit and visible to users? That would also
enable mirroring by others than the log operator.

[tlog-mirror]: https://c2sp.org/tlog-mirror@v0.1.0
