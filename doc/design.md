# Sigsum Logging Design v0
We propose sigsum logging.  It is similar to Certificate Transparency and Go's
checksum database, except that cryptographically **sig**ned check**sum**s are
logged in order to make signature operations transparent.  For example,
malicious and unintended key-usage can be detected using a sigsum log.  This is
a building block that can be used for a variety of use-cases.  Transparent
management of executable binaries and provenance are two examples.  Our
architecture evolves around centralized log operations, distributed trust, and
minimalism that simplifies usage.

**Preliminaries.**
You have basic understanding of cryptographic primitives, e.g., digital
signatures, hash functions, and Merkle trees.  You roughly know what problem
Certificate Transparency solves and how.

**Warning.**
This is a work-in-progress document that may be moved or modified.  A future
revision of this document will bump the version number to v1.

Please let us know if you have any feedback.

## 1 - Introduction
Transparency logs make it possible to detect unwanted events.  For example,
are there any (mis-)issued TLS certificates
	[\[CT\]](https://tools.ietf.org/html/rfc6962),
did you get a different Go module than everyone else
	[\[ChecksumDB\]](https://go.googlesource.com/proposal/+/master/design/25530-sumdb.md),
or is someone running unexpected commands on your server
	[\[AuditLog\]](https://transparency.dev/application/reliably-log-all-actions-performed-on-your-servers/).

A sigsum log brings transparency to **sig**ned check**sum**s.  You can think of
sigsum logging as pre-hashed digital signing with transparency.
The signing party is called a _signer_.
The user of the signed data is called a _verifier_.

The problem with _digital signing on its own_ is that it is difficult to
determine whether the signed data is _actually the data that should have been
signed_.  How would we detect if a secret signing key got compromised?  How
would we detect if something was signed by mistake, or even worse, if the
signing party was forced to sign malicious data against their will?

Sigsum logs make it possible to answers these types of questions.  The basic
idea is to make a signer's _key-usage_ transparent.  This is a powerful building
block that can be used to facilitate verification of falsifiable claims.

Examples include:
- Everyone gets the same executable binaries
	[\[BT\]](https://wiki.mozilla.org/Security/Binary_Transparency)
- A web server does not serve malicious javascript
	[\[SRI\]](https://developer.mozilla.org/en-US/docs/Web/Security/Subresource_Integrity)
- A list of key-value pairs is maintained with a certain policy.

There are many other use-cases that sigsum logging can help with.  We intend to
document them based on what people are working on in a
        [separate document](https://git.sigsum.org/sigsum/tree/doc/claimant.md)
using the
        [claimant model](https://github.com/google/trillian/blob/master/docs/claimantmodel/CoreModel.md).
This document is about our log design.

### 1.1 - Goals and non-scope
The goal of sigsum logging is to make a signer's key-usage transparent in
general.  Therefore, sigsum logs allow logging of signed checksums and some
minimally required metadata.  Storing data and rich metadata is a non-goal.

We want the resulting design to be easy from many different perspectives, for
example log operations and verification in constrained environments.  This
includes considerations such as simple parsing, protection against log spam and
poisoning, and a well-defined gossip protocol without complex auditing logic.

This is in contrast to Certificate Transparency, which requires ASN.1 parsing,
storage of arbitrary certificate fields, reactive auditing of complicated log
promises, and deployment of a gossip protocol that suits the web
	[\[G1,](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=7346853)
	[G2\]](https://datatracker.ietf.org/doc/html/draft-ietf-trans-gossip-05).

### 1.2 - Log properties
It is fair to say that much though went into _removing_ unwanted usage-patterns
of sigsum logs, ultimately leaving us with a design that has the below
properties.  It does not mean that the sigsum log design is set in stone yet,
but it is mature enough to capture what type of ecosystem we want to bootstrap.
- **Preserved data flows:** a verifier can enforce sigsum logging without making
additional outbound network connections.  Proofs of public logging are provided
using the same distribution mechanism as is used for distributing the actual data.
In other words, the signer talks to the log on behalf of the verifying party.
- **Sharding to simplify log life cycles:** starting to operate a log is easier
than closing it down in a reliable way.  We have a predefined sharding interval
that determines the time during which the log will be active.  Submissions to
an older log shard cannot be replayed in another non-overlapping log shard.
- **Defenses against log spam and poisoning:** to keep logs as useful as
possible they should be open for everyone.  However, accepting logging requests
from anyone at arbitrary rates can lead to abusive usage patterns.  We store as
little metadata as possible to combat log poisoning.  We piggyback on DNS to
combat log spam.  Sharding is also helpful to combat log spam in the long run.
- **Built-in mechanisms that ensure a globally consistent log:** transparency
logs rely on gossip protocols to detect forks.  We built a proactive gossip
protocol directly into the log.  It is a variant of
	[witness cosigning](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=7546521).
- **No cryptographic agility**: the only supported signature schemes and hash
functions are Ed25519 and SHA256.  Not having any cryptographic agility makes
protocols and data formats simpler and more secure.
- **Simple (de)serialization parsers:** complex (de)serialization parsers
increase attack surfaces and make the system more difficult to use in
constrained environments.  Signed and logged data can be (de)serialized using
	[Trunnel](https://gitlab.torproject.org/tpo/core/trunnel/-/blob/main/doc/trunnel.md),
or "by hand" in many modern programming languages.  This is the only parsing
that a verifier is required to support.  Signers, monitors, and witnesses
additionally need to interact with a sigsum log's line-terminated ASCII HTTP(S)
        [API](https://git.sigsum.org/sigsum/tree/doc/api.md).

## 2 - Threat model
We consider a powerful attacker that gained control of a signer's signing and
release infrastructure.  This covers a weaker form of attacker that is able to
sign data and distribute it to a subset of isolated verifiers.  For example,
this is essentially what the FBI requested from Apple in the San Bernardino case
	[\[FBI-Apple\]](https://www.eff.org/cases/apple-challenges-fbi-all-writs-act-order).
The fact that signing keys and related infrastructure components get
compromised should not be controversial these days
	[\[SolarWinds\]](https://www.zdnet.com/article/third-malware-strain-discovered-in-solarwinds-supply-chain-attack/).

The same attacker also gained control of the signing key and infrastructure of a
sigsum log that is used for transparency.  This covers a weaker form of attacker
that is able to sign log data and distribute it to a subset of isolated
verifiers.  For example, this could have been the case when a remote code
execution was found for a Certificate Transparency Log
	[\[DigiCert\]](https://groups.google.com/a/chromium.org/g/ct-policy/c/aKNbZuJzwfM).

The overall system is said to be secure if a log monitor can discover every
signed checksum that a verifier would accept.
A log can misbehave by not presenting the same append-only Merkle tree to
everyone because it is attacker-controlled.
The attacker would only do that if it is likely to go unnoticed, however.

For security we need a collision resistant hash function and an unforgeable
signature scheme.  We also assume that at most a threshold of independent
witnesses stop following protocol to protect against a malicious log that
attempts
	[split-view](https://datatracker.ietf.org/doc/html/draft-ietf-trans-gossip-05)
and
	[slow-down](https://git.sigsum.org/sigsum/tree/archive/2021-08-24-checkpoint-timestamp)
attacks.   An attacker can at best deny service with these assumptions.

## 3 - Design
An overview of sigsum logging is shown in Figure 1.  Before going into detail
we give a brief primer below.
```
                               +----------+
           checksum +----------|  Signer  |-----------+ data
           metadata |          +----------+           | metadata
                    |                ^                | proof
                    v                |                v
  +-----+ H(vk) +---------+   proof  |          +--------------+
  | DNS |------>|   Log   |----------+          | Distribution |
  +-----+       +---------+                     +--------------+
                 ^  | checksum                     |  |
                 |  | metadata                     |  |data
                 |  | proof     +---------+   data |  |metadata
                 |  +---------->| Monitor |<-------+  |proof
                 v              +---------+           v
               +---------+           |             +----------+
               | Witness |           | false       | Verifier |
               +---------+           | claim       +----------+
                                     v
                                investigate
           
                       Figure 1: system overview
```

A signer wants to make their key-usage transparent.  Therefore, they sign a
statement that sigsum logs accept.  That statement encodes a checksum of some
data.  Minimal metadata must also be logged, such as the checksum's signature
and a hash of the public verification key.  A hash of the public verification
key is configured in DNS as a TXT record to help log operators combat spam.

The signing party waits for their submission to be included in the log.  When an
inclusion proof is available that leads up to a trustworthy Merkle tree head,
the signed checksum's data is ready for distribution with proofs of public
logging.  A sigsum log does not help the signer with any data distribution.

Verifiers use the signer's data if it is accompanied by proofs of public
logging.  Monitors look for signed checksums and data that correspond to public
keys that they are aware of.  Any falsifiable claim that a signer makes about
their key-usage can now be verified because no signing operation goes unnoticed.

Verifiers and monitors can be convinced that public logging happened without
additional outbound network connections if a threshold of witnesses followed a
cosigning protocol.  More detail is provided in Section 3.2.3.

### 3.1 - Merkle tree
A sigsum log maintains a public append-only Merkle tree.  Independent witnesses
verify that this tree is fresh and append-only before cosigning it to achieve a
distributed form of trust.  A tree leaf contains four fields:
- **shard_hint**: a number that binds the leaf to a particular _shard interval_.
Sharding means that the log has a predefined time during which logging requests
are accepted.  Once elapsed, the log can be shut down or be made read-only.
- **checksum**: most likely a hash of some data.  The log is not aware of data;
just checksums.
- **signature**: a digital signature that is computed by a signer over the
selected shard hint and checksum.
- **key_hash**: a cryptographic hash of the signer's verification key that can
be used to verify the signature.

Any additional metadata that is use-case specific can be stored as part of the
data that a checksum represents.  Where data is located is use-case specific.

Note that a key hash is logged rather than the public key itself.  This reduces
the likelihood that an untrusted key is discovered and used by mistake.  In
other words, verifiers and monitors must locate signer verification keys
independently of logs, and trust them explicitly.

### 3.2 - Usage pattern
#### 3.2.1 - Prepare a request
A signer selects a checksum that should be logged.  For example, it could be the
hash of an executable binary or something else.

The signer also selects a shard hint representing an abstract statement like
"sigsum logs that are active during 2021".  Shard hints ensure that a log's
leaves cannot be replayed in a non-overlapping shard.

The signer signs the selected shard hint and checksum.

The signer also has to do a one-time DNS setup.  As outlined below, logs will
check that _some domain_ is aware of the signer's verification key.  This is
part of a defense mechanism that helps log operators to deal with log spam.
Once present in DNS, a verification key can be used in subsequent log requests.

#### 3.2.2 - Submit request
Sigsum logs implement an HTTP(S) API.  Input and output is human-readable and
use a simple ASCII format.  A more complex parser like JSON is not needed
since the data structures being exchanged are primitive enough.

The signer submits their shard hint, checksum, signature, public verification
key and domain hint as ASCII key-value pairs.  The log verifies that the public
verification key is present in DNS and uses it to check that the signature is
valid, then hashes it to construct the Merkle tree leaf as described in
Section 3.1.

When a submitted logging request is accepted, the log _tries_ to incorporate the
submitted leaf into its Merkle tree.  There are however no _promises of public
logging_ as in Certificate Transparency.  Therefore, sigsum logs do not provide
low latency---the signer has to wait for an inclusion proof and a cosigned tree
head.

#### 3.2.3 - Wait for witness cosigning
Sigsum logs periodically freeze the most current tree head, typically every five
minutes.  Cosigning witnesses poll logs for so-called _to-sign_ tree heads and
verify that they are fresh and append-only before doing a cosignature operation.
Cosignatures are posted back to logs so that signers can easily fetch finalized
cosigned tree heads.

It thus takes five to ten minutes before a signer's distribution phase can start.
The added latency is a trade-off that simplifies sigsum logging by removing the
need for reactive gossip-audit protocols
	[\[G1,](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=7346853)
	[G2,](https://datatracker.ietf.org/doc/html/draft-ietf-trans-gossip-05)
	[G3,](https://petsymposium.org/2021/files/papers/issue2/popets-2021-0024.pdf)
	[G4\]](https://docs.google.com/document/d/16G-Q7iN3kB46GSW5b-sfH5MO3nKSYyEb77YsM7TMZGE/edit).

Use-cases like instant certificate issuance are not supported by design.

#### 3.2.4 - Distribution
Once a signer has collected proofs of public logging the distribution phase can
start.  Distribution happens using the same mechanism that is normally used for
the data.  For example, on a website, in a git repository, etc.
Signers distribute at least the following pieces:

**Data:**
the signer's data, for example an executable binary.  It can be used to
reproduce a logged checksum.

**Metadata:**
the shard hint, the signature over shard hint and checksum, and the verification
key hash used in the log request.  Note that the combination of data and
metadata can be used to reconstruct the logged leaf.

**Proof:**
an inclusion proof that leads up to a cosigned tree head.  Note that _proof_
refers to the collection of an inclusion proof and a cosigned tree head.

#### 3.2.5 - Verification
A verifier should only accept the distributed data if the following criteria hold:
1. The data's checksum and shard hint are signed using the specified public key.
2. The provided tree head can be reconstructed from the logged leaf and
its inclusion proof.
3. The provided tree head is from a known log with enough valid cosignatures.

Notice that there are no new outbound network connections for a verifier.
Therefore, a verifier will not be affected by future log downtime since the
signer already collected relevant proofs of public logging.  Log downtime may be
caused by temporary operational issues or simply because a shard is done.

The lack of external communication means that a proof of public logging cannot
be more convincing than the tree head an inclusion proof leads up to.  Sigsum
logs have trustworthy tree heads thanks to using a variant of witness cosigning.
A verifier cannot be tricked into accepting data whose checksum have not been
publicly logged unless the attacker controls more than a threshold of witnesses.

#### 3.2.6 - Monitoring
An often overlooked step is that transparency logging falls short if no-one
keeps track of what appears in the public logs.  Monitoring is necessarily
use-case specific in sigsum.  At a minimum, monitors need to locate relevant
public keys.  They may also need to be aware of how to locate the data that
logged checksums represent.

### 3.3 - Summary
Sigsum logs are sharded and shut down at predefined times.  A sigsum log can
shut down _safely_ because verification on the verifier-side is not interactive.

The difficulty of bypassing public logging is based on the difficulty of
controlling enough independent witnesses.  A witness checks that a log's tree
head is correct before cosigning.  Correctness includes freshness and the
append-only property.

Signers, monitors, and witnesses interact with the logs using an ASCII HTTP(S)
API.  A signer must prove that they control a DNS domain name as an anti-spam
mechanism.  No data or rich metadata is being logged, to protect the log
operator from poisoning.  This also keeps log operations simpler because there
are less data to manage.

Verifiers interact with logs indirectly through their signer's existing
distribution mechanism.  Signers are responsible for logging signed checksums
and distributing necessary proofs of public logging.  Monitors discover signed
checksums in the logs and generate alerts if any key-usage is inappropriate.

### 4 - Frequently Asked Questions
#### 4.1 - What parts of the design are up for debate?
A brief summary appeared in our archive on
	[2021-10-05](https://git.sigsum.org/sigsum/tree/archive/2021-10-05-open-design-thoughts?id=5c02770b5bd7d43b9327623d3de9adeda2468e84).
It may be incomplete, but covers some details that are worth thinking more
about.  We are still open to remove, add, or change things.

#### 4.2 - What is the point of having a domain hint?
Domain hints help log operators combat spam.  By verifying that every signer
controls a domain name that is aware of their public key, rate limits can be
applied per second-level domain.  You would need a large number of domain names
to spam a log in any significant way if rate limits are not set too loose.

Notice that the effect of spam is not only about storage.  It is also about
merge latencies.  Too many submissions from a single party may render a log
unusable for others.  This kind of incident happened in the real world already
	[\[Aviator\]](https://groups.google.com/a/chromium.org/g/ct-policy/c/ZZf3iryLgCo/m/rdTAHWcdBgAJ).

Using DNS as an anti-spam mechanism is not a perfect solution.  It is however
better than not having any anti-spam mechanism at all.  We picked DNS because
many signers have a domain.  A single domain name is also relatively cheap.

A signer's domain hint is not part of the logged leaf because key management is
more complex than that.  A separate project should focus on transparent key
management.  Our work is about transparent _key-usage_.

We are considering if additional anti-spam mechanisms should be supported.

#### 4.3 - What is the point of having a shard hint?
Unlike TLS certificates which already have validity ranges, a checksum does not
carry any such information.  Therefore, we require that the signer selects a
shard hint.  The selected shard hint must be within a log's shard interval.
That shard interval is open-ended, meaning there is a fixed start time and a
_policy-defined_ end time that the operator may increase but not decrease
	[\[OESI\]](https://git.sigsum.org/sigsum/tree/doc/proposals/2021-11-open-ended-shard-interval.md).
A log's shard start is inclusive and expressed as the number of seconds since
the UNIX epoch (January 1, 1970 00:00 UTC).  A log that is still active should
use the number of seconds since the UNIX epoch as its shard end.

Without sharding, a good Samaritan can add all leaves from an old log into a
newer one that just started its operations.  This makes log operations
unsustainable in the long run because log sizes grow indefinitely.  Such
re-logging also comes at the risk of activating someone else's rate limits.

Note that a signer's shard hint is not a verified timestamp.  We recommend to
set it to the maximum value that all active logs accept as valid
	[\[OESI\]](https://git.sigsum.org/sigsum/tree/doc/proposals/2021-11-open-ended-shard-interval.md).
If a verified timestamp is needed to reason about the time of logging, you may
use a cosigned tree head instead
	[\[TS\]](https://git.sigsum.org/sigsum/commit/?id=fef460586e847e378a197381ef1ae3a64e6ea38b).

A log operator that shuts down a completed shard will not affect verifiers.  In
other words, a signer can continue to distribute proofs that were once
collected.  This is important because a checksum does not necessarily expire.

#### 4.4 - What parts of witness cosigning are not done?
There are interesting policy aspects that relate to witness cosigning.  For
example, what witnessing policy should a verifier use and how are trustworthy
witnesses discovered.  This is somewhat analogous to a related policy question
that all log ecosystems must address.  Which logs should be considered known?

We do however think that witness cosigning could be done _from the perspective
of a log and its operator_.  The
	[sigsum/v0 API](https://git.sigsum.org/sigsum/tree/doc/api.md)
supports witness cosigning.  Policy aspects for a log operator are easy because
it is relatively cheap to allow a witness to be a cosigner.  It is not a log
operator's job to determine if any real-world entity is trustworthy.  It is not
even a log operator's job to help signers and verifiers discover witness keys.

Given a permissive policy for which witnesses are allowed to cosign, a signer
may not care for all retrieved cosignatures.  Unwanted ones can simply be
removed before distribution to a verifier takes place.  This is in contrast to
the original proposal by
	[Syta et al.](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=7546521),
which puts an authority right in the middle of a slowly evolving witnessing policy.

#### 4.5 - More questions
- What are the privacy concerns?
- Add more questions here!
