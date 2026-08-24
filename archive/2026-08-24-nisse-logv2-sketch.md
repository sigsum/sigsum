# An attempt to flesh out a Sigsum v2 protocol

author: nisse

Aim:

* Adopt c2sp tlog conventions where they make sense.

* Some level of cryptographic agility for signatures, to support PQ
  signatures, in particular ML-DSA-44. Still fixed sha256 for all
  hashing not with signature internals.

* Extend leaf data with a context hash.

* Using a log "origin line" which is not a self-authenticating
  cryptograhic id. This is a major change, where implications are not
  yet clear to me. It's not a problem for the log itself, but it
  affects everyone else referring to the log. Main benefit is that log
  can sign using two keys (although it would be possible, e.g., to use
  a log id based on the hash of the concatenation of the two keys).

  I don't know if we foresee sigsum log lifetimes large enough that
  periodic key rotation really matters.

* Suggested encodings in this document are just suggestions; subject
  to change depending on various tradoffs in
  size/complexity/compatibility.

## A cosigned tree head

Consists of log id aka "origin line", tree size, merkle tree root
hash, log signature + witness cosignature. Signatures made according
to c2sp specs. Wire representation can use checkpoint format
(*without* extension lines), and be served using a get-checkpoint API
endpoint.

## A leaf

A leaf consists of a key hash (who?), checksum (what?), context (what
for?) and a signature or signature hash. If a general key/value format
for leaves is adopted, representation for an Ed25519 signature could
be something like

    struct tree_leaf {
        u8 submitter_magic[32]; // H("sigsum.org/v2/struct/submitter")
        u8 submitter[32]; // H(pubkey)
        u8 context_magic[32]; // H("sigsum.org/v2/struct/context")
        u8 context[32]; // H(context), typically H(H(readable or structured id))
        u8 checksum_magic[32]; // H("sigsum.org/v2/struct/checksum")
        u8 checksum[32]; // H(message), typically H(H(data))
        u8 signature_magic[32]; // H("sigsum.org/v2/struct/signature/plain/ed25519")
        u8 signature[64]; // Ed25519 over "sigsum.org/v2/leaf\0" + context + checksum
    }

while the representation for an ML-DSA-44 leaf would be the same
except for the last two entries being

        u8 signature_magic[32]; // H("sigsum.org/v2/struct/signature/hash/ml-dsa-44")
        u8 signature[32]; // hash of the ML-DSA-44 signature

The log is responsible for storing and serving the corresponding
ML-DSA-44 signatures, but not necessarily forever (see below).

This can be extended to other signature algorithms, say, SLH-DSA. Note
that there can be only a single signature on each leaf, corresponding
to the key identified by the submitter field. To, e.g., get both an
Ed25519 signature and an ML-DSA-44 signature into the log, the data
must be entered twice.

Using separate `signature_magic` for plain and hashed signatures lets
outsiders investigate if the log provides underlying data for its
hashed signatures or not. Also identifying the signature algorithm
nails the size of the underlying signature.

The idea is that whoever knows the publik key behind the submitter key
hash knows which signature_magic to expect in corresponding leaves.
While the outsider that wants to check log's behavior regarding
signature retention would need to know all support signature magic
values.

TODO: Any use for an algorithm prefix when hashing submitter keys?

TODO: Details of compatibility with leaf format worked on in
https://github.com/C2SP/C2SP/pull/244.

## Leaf retrieval

Leaves are served using the tiles api. TODO: Nail down parameters such
as tile height?

No way to look query for inclusion or consistency proofs directly,
clients have to fetch needed tiles and do that themselves.

No way to lookup a leaf by leaf hash. We still want to reject
duplicate leaves. TODO: Should duplicate detection be a best-effort
thing, or something the log must guarantee? The possibility of
duplicates may weaken reasoning about when an entry was added, but not
entirely clear if that matters.

## Signature retrieval

To get the data underlying a hashed signature, there's a get-signature
endpoint. TODO: Unclear if the input here should be the signature hash
(like content-addressed storage), or the leaf index?

## Adding a leaf

The add-leaf API takes as input

  * 32-octet "context preimage", the hash of which makes it into the
    leaf.
  * 32-octet message, the hash of which becomes the leaf's checksum
  * A signature algorithm identifier, e.g., "ed25519" or "ml-dsa-44"
    (a log is expected to only support a small set)
  * A public key and a signature.

Only if the signature is valid for the given data, a leaf is added to
the log. Almost all of the inputs are hashed before put into the leaf,
the only exception is the signature, for the case of a small ed25519
signature.

The response to a successful add-leaf must return the leaf index, so
that the client can fetch appropriate tiles and construct an inclusion
proof.

## Discarding old signatures

A log could commit to storing large PQ signatures only for a limited
time, e.g., 3 months. This could also depend on the submitter key,
maybe some submitters get extra retention.

But to not just have to trust the log about this, it must be possibly
for outsiders to verify that the log upholds its commitments,
preferably without having to continuously monitor the log. One
potential way could be for the log to not only publish it's latest
tree head, but also publish some tree head that is at least three
months old (according to the witness cosignatures). Then it can purge
older signatures, and use that treehead to prove that they indeed are
so old that deletion is appropriate.
