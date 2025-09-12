# Should we have an additional context hash for Sigsum leaves?

author: nisse
written: 2025-09-03
updated: 2025-09-12

## How would a context work?

When submitting a leaf to the log, the submitter includes one more
value, a 32-byte context (which could be the hash of some meaningful
string). The context is included (with or without additional hashing)
in the signed data.

Verifiers and monitors are expected to know (and agree on) both
submitter public key and the context used for entries of interest. So
everywhere a trusted submitter public key is specified, the context
needs to be attached to that key.

The intention is to enable the same signing key to be used for
multiple purposes, with *independent* monitoring for each purpose.

## Publishing the context

I see two main options:

1. The context hash (additional hashing for poisoning
   reasons) is stored and published by the log. The leaf (both the
   binary representation in the merkle tree, and the representation
   served to log users) is extended with a `context_hash` field, and
   signature would cover this context hash.

2. The context is *not* stored or published directly by the log,
   instead, the published key hash is replaced with a hash of both
   public key and context, and the signature would cover the context
   (with no need for additional hashing). This option could be
   backwards compatible, with just an extension of the log api to
   optionally include a context when submitting a new leaf. Then some
   key hashes would be like the current key hashes with no context,
   and some key hashes would include context. Only the parties
   interested in a particular submitter key need to know how that key
   is used and the corresponding context(s), if any.

## Use cases

The context string could be used to identify a type of claim made
about the artifact represented by the checksum. E.g., signing
artifacts intended for both test and release using the same key.

A software maintainer working on several independent project could use
a single release key for all projects, and use the context to say
which project a released artifact belongs to.

Another use case is software distribution using non-crypto identities
(similar to what github/sigstore are doing). E.g., a service providing
build machinery for a large number of projects, like github and
gitlab, could use a well known key to sign and log artifacts +
metadata, and use the context to identify the user or project
reponsible for the artifact.

In all these cases, the main benefit is for monitoring; a monitor can
tail the log and extract entries signed with a particular key and a
specific context hash. E.g., in the github case, extract all releases
made by github actions associated with a particular project, and
verify claims specific to that project.

With sigsum/v1, one would need to have a separate signing key for each
use, which is possible but a hassle to manage. It may be particularly
cumbersome if the private keys are backed by hardware.

For verifiers to get any benefit from that kind of monitoring, it's
essential that they agree with monitors both on the submitter key and
the context, and reject items that are signed by the right key but
with an unexpected context. In particular, the context should be part
if the verifier's configuration, and not distributed with the proof
files.

## To consider

Pro:

* Submitter convenience in being able to use the same key for multiple
  purposes, monitored *independently*.

* By putting the context into the key hash, it is possible to add this
  feature in a backwards compatible manner.

Cons:

* Slightly increased protocol complexity in the core Sigsum protocols.

* Users need a to distribute pairs (submitter pubkey, context) instead
  of just the submitter pubkey, more or less everywhere. This adds
  complexity for both distribution and for understanding the system.

* Need for additional tooling support. E.g., we could attach the
  context as an attribute in the submitter pubkey file, and propagate
  it everywhere it is needed. But we might need a different path for
  sigsum-submit, since the submitter supposedly has several different
  contexts in use for the same private key, and may need help from
  tooling to avoid mistakes.
