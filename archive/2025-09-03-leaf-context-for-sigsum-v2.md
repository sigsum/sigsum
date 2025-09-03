# Should we have an additional context hash in Sigsum leaves?

## How would a context work?

We add another field, that protocol-wise is very similar to the
checksum, but is intended to be used differently. In add-leaf,
submitter includes a 32-byte context (which could be the hash of some
meaningful string). The log server hashes this (for poisoning
reasons), and publishes the context hash. The leaf signature would be
over the data `sigsum.org/v2/tree-leaf`, a single NUL character,
followed by the context hash (32 octets) and the checksum (also 32
octets), for a total of 88 octets that are signed directly with
Ed25519 by the submitter.

The intention would be that if we look at the set of leaves signed by
the same submitter key, the checksum will be unique per leaf,
representing some data distributed to users. While each context hash
will be occur multiple times, with only a small set of different
values, and relevant values being known in advance by verifiers and
monitors.

## Use cases

The context string could be used to identify a type of claim made
about the artifact represented by the checksum. E.g., signing
artifacts intended for both test and release using the same key.

A software maintainer working on several independent project could use
a single release key for all projects, and use the context to say
which project a released artifact belongs to.

One could be used to software distribution using non-crypto identities
(similar to what github/sigstore are doing). E.g., a service providing
build machinery for a large number of projects, like github and
gitlab, could use a well known key to sign and log artifacts, and
they could use the context to identify the user or project reponsible
for the artifact.

In all these cases, the main benefit is for monitoring; a monitor can
tail the log and extract entries signed with a particular key and a
specific context hash. E.g., in the github case, extract all releases
made by github actions associated with a particular project.

With sigsum/v1, one would need to have a separate signing key for each
use, which is possible but may be more cumbersome, in particular if
the private keys are backed by hardware.

For verifiers to get any benefit from that kind of monitoring, it's
essential that they have the right context configured and accept only
logged items with the right context. In essence, everywhere a sigsum
submitter public key is specified or distributed, a pair (pubkey,
context) must be distributed instead.

## To consider

Pro:

* Submitter convenience in being able to use the same key for multiple
  purposes, monitored *independently*. In particular, with hardware
  keys.

Cons:

* Slightly increased protocol complexity in the core Sigsum protocols.

* Users need a to distribute pairs (submitter pubkey, context) instead
  of just the submitter pubkey, more or less everywhere. This adds
  complexity for both distribution and for understanding the system.
