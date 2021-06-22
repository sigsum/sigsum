# System Transparency Logging: Design v0
We propose System Transparency logging.  It is similar to Certificate
Transparency, except that cryptographically signed checksums are logged as
opposed to X.509 certificates.  Publicly logging signed checksums allow anyone
to discover which keys produced what signatures.  As such, malicious and
unintended key-usage can be _detected_.  We present our design and conclude by
providing two use-cases: binary transparency and reproducible builds.

**Target audience.**
You are most likely interested in transparency logs or supply-chain security.

**Preliminaries.**
You have basic understanding of cryptographic primitives like digital
signatures, hash functions, and Merkle trees.  You roughly know what problem
Certificate Transparency solves and how.

**Warning.**
This is a work-in-progress document that may be moved or modified.  A future
revision of this document will bump the version number to v1.  Please let us
know if you have any feedback.

## Introduction
Transparency logs make it possible to detect unwanted events.  For example,
	are there any (mis-)issued TLS certificates [\[CT\]](https://tools.ietf.org/html/rfc6962),
	did you get a different Go module than everyone else [\[ChecksumDB\]](https://go.googlesource.com/proposal/+/master/design/25530-sumdb.md),
	or is someone running unexpected commands on your server [\[AuditLog\]](https://transparency.dev/application/reliably-log-all-actions-performed-on-your-servers/).
A System Transparency log makes signed checksums transparent.  The overall goal
is to facilitate detection of unwanted key-usage.

## Threat model and (non-)goals
We consider a powerful attacker that gained control of a target's signing and
release infrastructure.  This covers a weaker form of attacker that is able to
sign data and distribute it to a subset of isolated users.  For example, this is
essentially what the FBI requested from Apple in the San Bernardino case [\[FBI-Apple\]](https://www.eff.org/cases/apple-challenges-fbi-all-writs-act-order).
The fact that signing keys and related infrastructure components get
compromised should not be controversial these days [\[SolarWinds\]](https://www.zdnet.com/article/third-malware-strain-discovered-in-solarwinds-supply-chain-attack/).

The attacker can also gain control of the transparency log's signing key and
infrastructure.  This covers a weaker form of attacker that is able to sign log
data and distribute it to a subset of isolated users.  For example, this could
have been the case when a remote code execution was found for a Certificate
Transparency Log [\[DigiCert\]](https://groups.google.com/a/chromium.org/g/ct-policy/c/aKNbZuJzwfM).

Any attacker that is able to position itself to control these components will
likely be _risk-averse_.  This is at minimum due to two factors.  First,
detection would result in a significant loss of capability that is by no means
trivial to come by.  Second, detection means that some part of the attacker's
malicious behavior will be disclosed publicly.

Our goal is to facilitate _detection_ of compromised signing keys.  We consider
a signing key compromised if an end-user accepts an unwanted signature as valid.
The solution that we propose is that signed checksums are transparency logged.
For security we need a collision resistant hash function and an unforgeable
signature scheme.  We also assume that at most a threshold of seemingly
independent parties are adversarial.

It is a non-goal to disclose the data that a checksum represents.  For example,
the log cannot distinguish between a checksum that represents a tax declaration,
an ISO image, or a Debian package.  This means that the type of detection we
support is more _coarse-grained_ when compared to Certificate Transparency.

## Design
We consider a data publisher that wants to digitally sign their data.  The data
is of opaque type.  We assume that end-users have a mechanism to locate the
relevant public verification keys.  Data and signatures can also be retrieved
(in)directly from the data publisher.  We make little assumptions about the
signature tooling.  The ecosystem at large can continue to use `gpg`, `openssl`,
`ssh-keygen -Y`, `signify`, or something else.

We _have to assume_ that additional tooling can be installed by end-users that
wish to enforce transparency logging.  For example, none of the existing
signature tooling supports verification of Merkle tree proofs.  A side-effect of
our design is that this additional tooling makes no outbound connections.  The
above data flows are thus preserved.

### A bird's view
A central part of any transparency log is the data stored by the log.  The data is stored by the
leaves of an append-only Merkle tree.  Our leaf structure contains four fields:
- **shard_hint**: a number that binds the leaf to a particular _shard interval_.
Sharding means that the log has a predefined time during which logging requests
are accepted.  Once elapsed, the log can be shut down.
- **checksum**: a cryptographic hash of some opaque data.  The log never
sees the opaque data; just the hash made by the data publisher.
- **signature**: a digital signature that is computed by the data publisher over
the leaf's shard hint and checksum.
- **key_hash**: a cryptographic hash of the data publisher's public verification key that can be
used to verify the signature.

#### Step 1 - preparing a logging request
The data publisher selects a shard hint and a checksum that should be logged.
For example, the shard hint could be "logs that are active during 2021".  The
checksum might be the hash of a release file.

The data publisher signs the selected shard hint and checksum using a secret
signing key.  Both the signed message and the signature is stored
in the leaf for anyone to verify.  Including a shard hint in the signed message
ensures that a good Samaritan cannot change it to log all leaves from an
earlier shard into a newer one.

A hash of the public verification key is also stored in the leaf.  This makes it
possible to attribute the leaf to the data publisher.  For example, a data publisher
that monitors the log can look for leaves that match their own key hash(es).

A hash, rather than the full public verification key, is used to motivate the
verifier to locate the key and make an explicit trust decision.  Not disclosing the public
verification key in the leaf makes it more unlikely that someone would use an untrusted key _by
mistake_.

#### Step 2 - submitting a logging request
The log implements an HTTP(S) API.  Input and output is human-readable and uses
a simple key-value format.  A more complex parser like JSON is not needed
because the exchanged data structures are primitive enough.

The data publisher submits their shard hint, checksum, signature, and public
verification key as key-value pairs.  The log will use the public verification
key to check that the signature is valid, then hash it to construct the `key_hash` part of the leaf.

The data publisher also submits a _domain hint_.  The log will download a DNS
TXT resource record based on the provided domain name.  The downloaded result
must match the public verification key hash.  By verifying that the submitter
controls a domain that is aware of the public verification key, rate limits can
be applied per second-level domain.  As a result, you would need a large number
of domain names to spam the log in any significant way.

Using DNS to combat spam is convenient because many data publishers already have
a domain name.  A single domain name is also relatively cheap.  Another
benefit is that the same anti-spam mechanism can be used across several
independent logs without coordination.  This is important because a healthy log
ecosystem needs more than one log in order to be reliable.  DNS also has built-in
caching which data publishers can influence by setting TTLs accordingly.

The submitter's domain hint is not part of the leaf because key management is
more complex than that.  A separate project should focus on transparent key
management.  The scope of our work is transparent _key-usage_.

The log will _try_ to incorporate a leaf into the Merkle tree if a logging
request is accepted.  There are no _promises of public logging_ as in
Certificate Transparency.  Therefore, the submitter needs to wait for an
inclusion proof to appear before concluding that the logging request succeeded.  Not having
inclusion promises makes the log less complex.

#### Step 3 - distributing proofs of public logging
The data publisher is responsible for collecting all cryptographic proofs that
their end-users will need to enforce public logging.  The collection below
should be downloadable from the same place that published data is normally hosted.
1. **Opaque data**: the data publisher's opaque data.
2. **Shard hint**: the data publisher's selected shard hint.
3. **Signature**: the data publisher's leaf signature.
4. **Cosigned tree head**: the log's tree head and a _list of signatures_ that
state it is consistent with prior history.
5. **Inclusion proof**: a proof of inclusion based on the logged leaf and tree
head in question.

The data publisher's public verification key is known.  Therefore, the first three fields are
sufficient to reconstruct the logged leaf.  The leaf's signature can be
verified.  The final two fields then prove that the leaf is in the log.  If the
leaf is included in the log, any monitor can detect that there is a new
signature made by a given data publisher, 's public verification key.

The catch is that the proof of logging is only as convincing as the tree head
that the inclusion proof leads up to.  To bypass public logging, the attacker
needs to control a threshold of independent _witnesses_ that cosign the log.  A
benign witness will only sign the log's tree head if it is consistent with prior
history.

#### Summary
The log is sharded and will shut down at a predefined time.  The log can shut
down _safely_ because end-user verification is not interactive.  The difficulty
of bypassing public logging is based on the difficulty of controlling a
threshold of independent witnesses.  Witnesses cosign tree heads to make them
trustworthy.

Submitters, monitors, and witnesses interact with the log using an HTTP(S) API.
Submitters must prove that they own a domain name as an anti-spam mechanism.
End-users interact with the log _indirectly_ via a data publisher.  It is the
data publisher's job to log signed checksums, distribute necessary proofs of
logging, and monitor the log.

### A peek into the details
Our bird's view introduction skipped many details that matter in practise.  Some
of these details are presented here using a question-answer format.  A
question-answer format is helpful because it is easily modified and extended.

#### What cryptographic primitives are supported?
The only supported hash algorithm is SHA256.  The only supported signature
scheme is Ed25519.  Not having any cryptographic agility makes the protocol less
complex and more secure.

We can be cryptographically opinionated because of a key insight.  Existing
signature tools like `gpg`, `ssh-keygen -Y`, and `signify` cannot verify proofs
of public logging.  Therefore, _additional tooling must already be installed by
end-users_.  That tooling should verify hashes using the log's hash function.
That tooling should also verify signatures using the log's signature scheme.
Both tree heads and tree leaves are being signed.

#### Why not let the data publisher pick their own signature scheme and format?
Agility introduces complexity and difficult policy questions.  For example,
which algorithms and formats should (not) be supported and why?  Picking Ed25519
is a current best practise that should be encouraged if possible.

There is not much we can do if a data publisher _refuses_ to rely on the log's
hash function or signature scheme.

#### What if the data publisher must use a specific signature scheme or format?
They may _cross-sign_ the data as follows.
1. Sign the data as they're used to.
2. Hash the data and use the result as the leaf's checksum to be logged.
3. Sign the leaf using the log's signature scheme.

For verification, the end-user first verifies that the usual signature from step 1 is valid.  Then the
end-user uses the additional tooling (which is already required) to verify the rest.
Cross-signing should be a relatively comfortable upgrade path that is backwards
compatible.  The downside is that the data publisher may need to manage an
additional key-pair.

#### What (de)serialization parsers are needed?
#### What policy should be used?
#### Why witness cosigning?
#### Why sharding?
Unlike X.509 certificates which already have validity ranges, a
checksum does not carry any such information.  Therefore, we require
that the submitter selects a _shard hint_.  The selected shard hint
must be in the log's _shard interval_.  A shard interval is defined by
a start time and an end time.  Both ends of the shard interval are
inclusive and expressed as the number of seconds since the UNIX epoch
(January 1, 1970 00:00 UTC).

Sharding simplifies log operations because it becomes explicit when a
log can be shutdown.  A log must only accept logging requests that
have valid shard hints.  A log should only accept logging requests
during the predefined shard interval.  Note that _the submitter's
shard hint is not a verified timestamp_.  The submitter should set the
shard hint as large as possible.  If a roughly verified timestamp is
needed, a cosigned tree head can be used.

Without a shard hint, the good Samaritan could log all leaves from an
earlier shard into a newer one.  Not only would that defeat the
purpose of sharding, but it would also become a potential
denial-of-service vector.

#### TODO
Add more key questions and answers.
- Log spamming
- Log poisoning
- Why we removed identifier field from the leaf
- Explain `latest`, `stable` and `cosigned` tree head.
- Privacy aspects
- How does this whole thing work with more than one log?

## Concluding remarks
Example of binary transparency and reproducible builds.
