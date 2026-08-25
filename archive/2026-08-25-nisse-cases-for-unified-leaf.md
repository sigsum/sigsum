# Use cases related to a "unified" leaf format

Related to https://github.com/C2SP/C2SP/pull/244

At low-level, a leaf is an arbitrary blob, prepended with a magic byte
to form a leaf hash that goes into the merkle tree.

## Submission

Completely independent of leaf format, e.g., Sigsum add-leaf API
doesn't use or refer to the actual leaf blob in any way.

## Verifying profs

Indifferent to leaf serialization details. All that is needed is a
procedure for mapping the values with meaning to the application
(e.g., checksum, keyhash and and signature in the Sigsum case) into a
leaf-hash, in order to validate its inclusion proof. Actual leaf data
is never parsed or deserialized. I expect this mapping to always be
somewhat application specific.

## Monitoring

Monitoring process can be divided into three steps.

1. Retrieve all leaves, verifying inclusion in the process.

2. Filtering the leaves, to identify leaves of interest to this
   monitor.

3. Further processing to verify claims corresponding to the
   interesting leaves.

First step only handles opaque blobs. Second stage could in principle
use some kind of packet filter machine for classification, with
primitive rules like "byte at index 17 must be 0xAA" combined by
logical operations. I think the third step can be assumed to know the
particular structure used by the application of interest.

A common part of step 3 will be to verify a signature, for which one
needs to extract from the leaf the identity of the key used, the
signature, and identify the part of the leaf that is convered by the
signature. However, since this doesn't happen until step three, it
doesn't strictly have to be the same rules for all leaves; it could
also depend on the packet-filter style classification.

So I think we have one hard requirement for monitoring:

* Leaves used for different purposes must correspond to disjoint sets
  of blobs, where identification via simple packet filter-style rules
  is easy.

And one more "nice to have":

* A common rule to locate the leaf signature (if any), as well as the
  key identifier and the portion of the leaf being signed (which would
  typically be everything else in the leaf).

## Mirroring

There are two kinds if mirroring: Log mirroring, which has to mirror
the leaves as well as the leaf signatures (which it is the log's
responsibility to store) when those are identified as hashes only in
the leaf itself. So here there's one hard requirement:

* There must be a common rule to identify the portion of the leaf, if
  any, that holds the leaf signature hash.

There must also be common standard protocol for retrieving the
signatures. The mirror will be configured with a maximum size of
signatures it is willing to deal with, but it would be nice if it
there was also some common rule for how to derive the signature size
from the leaf.

The other kind of mirror that could benefit from a unified leaf format
is a mirror that wants to mirror underying data for multiple types of
logs, i.e., data that other parties than the log itself is responsible
for. Such a mirror would want to identify hashes to look up in an
appropriate content-addressable storage, and to verify retrieved data
it may need a way to distinguish between direct hashes and double
hashes (like the Sigsum checksum). Addenda draft
https://hackmd.io/JPrF0yOHRZOzu5MowXKLWQ explores related questions.

## Conclusions

Structure helps independently developed applications to not collide.
So far, monitoring and mirroring (I'm considering only log mirroring
at the moment; I don't grasp the complications for a "generic" data
mirror).

For monitoring, I think the minimal viable structure is something like
first 32 bytes being H(schema-less url), with further differentiation
defined by the owner of the domain in that url.

For mirroring, I think the minimal viable structure would be something
like a flag at the start of the leaf saying if it includes a signature
hash or not, and a rule saying that if it is present, the signature
hash is the last 32 bytes.

Using name/value pairs, where both name and value are stored as
hashes, and names are schema-less urls, makes for more structure and
also allows for some application-independent keys (e.g., to identify
signature hashes). Enforcing this format for all of the leaf rules out
storing an inline Ed25519 signature, though.

Note that unlike other items one might consider storing inline in the
leaf, the sigsum leaf signature shares anti-poison properties with
double hashes (since the log only accepts valid signatures, it's
costly for the submitter to control what bits get inserted).

One could argue that an inline leaf signature could be treated as a
kind of hash, but one then needs to generalize what's allowed for the
value hashes, in particular, since size differs from a sha256 hash.
One could shoe-horn an ed25519 signature into a strict 32-byte
name/value structure by using two name/value pairs to represent the
signature, but that's a bit ugly. I think a structure that allows for
arbitrary inline data (possible preceded by its own name hash after
the name/value pairs) would be preferable.
