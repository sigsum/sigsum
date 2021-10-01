# Sigsum Logging Design v0
We propose sigsum logging.  It is similar to Certificate Transparency, except
that cryptographically **sig**ned check**sum**s are logged instead of TLS
certificates.  Publicly logging signed checksums allow anyone to discover which
keys produced what checksum signatures.  For example, malicious and unintended
key-usage can be _detected_.  This document motivates and presents our design.

**Preliminaries.**
You have basic understanding of cryptographic primitives, e.g., digital
signatures, hash functions, and Merkle trees.  You roughly know what problem
Certificate Transparency solves and how.

**Warning.**
This is a work-in-progress document that may be moved or modified.  A future
revision of this document will bump the version number to v1.

Please let us know if you have any feedback.

## 1 - Introduction
Transparent logs make it possible to detect unwanted events.  For example,
	are there any (mis-)issued TLS certificates [\[CT\]](https://tools.ietf.org/html/rfc6962),
	did you get a different Go module than everyone else [\[ChecksumDB\]](https://go.googlesource.com/proposal/+/master/design/25530-sumdb.md),
	or is someone running unexpected commands on your server [\[AuditLog\]](https://transparency.dev/application/reliably-log-all-actions-performed-on-your-servers/).
A sigsum log brings transparency to **sig**ned check**sum**s.

### 1.1 - Problem description
Suppose you are an entity that distributes some opaque data.  For example,
the opaque data might be
	a provenance file,
	an executable binary,
	an automatic software update, or
	a TPM quote.
You claim to distribute the right opaque data to everyone.
However, past incidents taught us that word is cheap and sometimes things go
wrong.  Trusted parties get compromised and lie about it [\[DigiNotar\]](), or
they might not even realize it until later on because the break-in was stealthy
[\[SolarWinds\]](https://www.zdnet.com/article/third-malware-strain-discovered-in-solarwinds-supply-chain-attack/).

The goal of sigsum logging is to make your claims verifiable by you and
others.  To keep the design simple and general, we want to achieve this goal
with few assumptions about the opaque data or the involved claims.  You can
think of this as some sort of bottom-line for what it takes to apply a
transparent logging pattern.  Past use-cases that wanted to piggy-back on an
existing reliable log ecosystem fit well into our scope [\[BinTrans\]](https://wiki.mozilla.org/Security/Binary_Transparency).

We also want the design to be easy from many different perspectives, for example log operations and
verification in constrained environments.  This includes considerations such as
simple parsing, protection against log spam and poisoning, and a
well-defined gossip protocol without any complex auditing logic.

### 1.2 - Abstract setting
You would like users of the opaque data to _believe_ your claims.  Therefore,
we refer to you as a _claimant_ and your users as _believers_.  Belief is going
to be reasonable because each claim is expressed as a _signed statement_ that is
transparency logged.  The opaque data and relevant proofs of public logging are
then distributed through a _repository_.  Note that repository is an abstract
construct.  For example, it may be a website or something else.

A believer can now be convinced that public logging actually happened, so that
a _verifier_ can discover any statement that you as a claimant produced.  If it
turns out that a statement contains a false claim, an _arbiter_ is notified that
can act on it.  An overview of these _roles_ and how they interact are shown in
Figure 1.  A party may play multiple roles.  A role may also be fulfilled by
multiple parties. Refer to the [claimant model](https://github.com/google/trillian/blob/master/docs/claimantmodel/CoreModel.md)
for additional detail.

```
          statement +----------+
         +----------| Claimant |----------+
         |          +----------+          |Data
         |                                |Proof
         v                                v
    +---------+                     +------------+
    |   Log   |                     | Repository |
    +---------+                     +------------+
        |                              |   |
        |                              |   |Data
        |statements +----------+  Data |   |Proof
        +---------->| Verifier |<------+   |
                    +----------+           v
    +---------+          |          +------------+
    | Arbiter | <--------+          |  Believer  |
    +---------+     false claim     +------------+

            Figure 1: abstract setting
```

A claimant's statement encodes the following claim: _the right opaque data has
a certain cryptographic hash_.  It is stored in a sigsum log for discoverability.  A
claimant may add additional claims that are _implicit_ for each statement.  An
implicit claim is not stored by the log and therefore communicated through
policy.  Examples of implicit claims:
- The opaque data can be located in repository Y using X as an identifier.
- The opaque data is a `.buildinfo` file that facilitates a reproducible build
[\[R-B\]](https://wiki.debian.org/ReproducibleBuilds/BuildinfoFiles).

Detailed examples of use-case specific claimant models are defined in a separate
document [\[CM-Examples\]](https://git.sigsum.org/sigsum/blob/main/doc/claimant.md).

### 1.3 - Design considerations
Our main contribution is in the details that surround the log role in practise.
Below is a brief summary.
- **Preserved data flows:** a believer can enforce sigsum logging without making
additional outbound network connections.  Proofs of public logging are provided
using the same distribution mechanism as is used for distributing the opaque data.
- **Sharding to simplify log life cycles:** starting to operate a log is easier
than closing it down in a reliable way.  We have a predefined sharding interval
that determines the time during which the log will be active.
- **Defenses against log spam and poisoning:** to maximize a log's utility it
should be open for anyone to use.  However, accepting logging requests from
anyone at arbitrary rates can lead to abusive usage patterns.  We store as
little metadata as possible to combat log poisoning.  We piggyback on DNS to
combat log spam.
- **Built-in mechanisms that ensure a globally consistent log:** transparent
logs rely on gossip protocols to detect forks.  We built a proactive gossip
protocol directly into the log.  It is a variant of [witness cosigning]().
- **No cryptographic agility**: the only supported signature scheme is Ed25519.
The only supported hash function is SHA256.  Not having any cryptographic
agility makes protocols and data formats simpler and more secure.
- **Simple (de)serialization parsers:** complex (de)serialization parsers
increase attack surfaces and make the system more difficult to use in
constrained environments.  A sigsum statement can be (de)serialized using
[Trunnel](https://gitlab.torproject.org/tpo/core/trunnel/-/blob/main/doc/trunnel.md),
or "by hand" in many modern programming languages.  This is the only parsing
that a believer is required to support.  Claimants and verifiers additionally
need to interact with a sigsum log's HTTP(S) API with line-terminated ASCII.

### 1.4 - Roadmap
First we describe our threat model.  Then we give a bird's view of the design.
Finally, we go into greater detail using a question-answer format that is easy
to extend and/or modify.  The last part contains documentation TODOs.

## 2 - Threat model and (non-)goals
We consider a powerful attacker that gained control of a claimant's signing and
release infrastructure.  This covers a weaker form of attacker that is able to
sign data and distribute it to a subset of isolated users.  For example, this is
essentially what the FBI requested from Apple in the San Bernardino case [\[FBI-Apple\]](https://www.eff.org/cases/apple-challenges-fbi-all-writs-act-order).
The fact that signing keys and related infrastructure components get
compromised should not be controversial these days [\[SolarWinds\]](https://www.zdnet.com/article/third-malware-strain-discovered-in-solarwinds-supply-chain-attack/).

The attacker can also gain control of the transparent log's signing key and
infrastructure.  This covers a weaker form of attacker that is able to sign log
data and distribute it to a subset of isolated users.  For example, this could
have been the case when a remote code execution was found for a Certificate
Transparency Log [\[DigiCert\]](https://groups.google.com/a/chromium.org/g/ct-policy/c/aKNbZuJzwfM).

Any attacker that is able to position itself to control these components will
likely be _risk-averse_.  This is at minimum due to two factors.  First,
detection would result in a significant loss of capability that is by no means
trivial to come by.  Second, detection means that some part of the attacker's
malicious behavior will be disclosed publicly.

Following from our introductory goal we want to facilitate _disocvery_ of sigsum
statements.  Such discovery makes it possible to detect attacks on a claimant's
signing and release infrastructure.  For example, a claimant can detect an
unwanted sigsum by inspecting the log.  It could be the result of a compromised
signing key.  The opposite direction is also possible.  Anyone may detect that a
repository is not serving data and/or proofs of public logging.

It is a non-goal to disclose the data that a cryptographic checksum represents
_in the log_.  It is also a non-goal to allow richer metadata that is
use-case specific.  The type of detection that a sigsum log supports is
therefore more _coarse-grained_ when compared to Certificate Transparency.  A
significant benefit is that the resulting design becomes simpler, general, and
less costly to bootstrap into a reliable log ecosystem.

For security we need a collision resistant hash function and an unforgeable
signature scheme.  We also assume that at most a threshold of seemingly
independent parties are adversarial to protect against split-views
[\[Gossip\]]().

## 3 - Design
We consider a _claimant_ that claims to distribute the _right_ opaque data with
cryptographic hash X.  A claimant may add additional falsifiable claims.
However, all claims must be digitally signed to ensure non-repudiation [\[CM\]](https://github.com/google/trillian/blob/master/docs/claimantmodel/CoreModel.md).

A user should only use the opaque data if there is reason to _believe_ the
claimant's claims.  Therefore, users are called _believers_.  A good first step
is to verify that the opaque data is accompanied by a valid digital signature.
This corresponds to current practises where, say, a software developer signs new
releases with `gpg` or `minisign -H`.

The problem is that it is difficult to verify whether the opaque data is
actually _the right opaque data_.  For example, what if the claimant was coerced
or compromised?  Something malicious could be signed as a result.

A sigsum log adds _discoverability_ into a claimant's signed statements, see
Figure 1.  Such discoverability facilitates _verification of claims_.
Verifiability is a significant improvement when compared to the blind trust that
we had before.

### 3.1 - How it works
A sigsum log maintains a public append-only Merkle tree.  Independent witnesses
verify that this tree is fresh and append-only before cosigning it to achieve a
distributed form of trust.  A tree leaf contains four fields:
- **shard_hint**: a number that binds the leaf to a particular _shard interval_.
Sharding means that the log has a predefined time during which logging requests
are accepted.  Once elapsed, the log can be shut down.
- **checksum**: a cryptographic hash of some opaque data.  The log never
sees the opaque data; just the hash.
- **signature**: a digital signature that is computed by a claimant over the
leaf's shard hint and checksum.
- **key_hash**: a cryptographic hash of the claimant's verification key that can
be used to verify the signature.

The signed statement encodes the following claim: "the right opaque data has
cryptographic hash X".  The claimant may also communicate additional implicit
claims through policy.  For example, "the opaque data can be located in
repository Y" and "the opaque data facilitates a reproducible build".

A verifier that monitors the log ecosystem can discover new statements and
contact an arbiter if any claim turns out to be false.  Examples of verifies in
a reproducible builds system include third-party rebuilders.  Ideally, a
believer should only use a (supposedly) reproducible build artifact if it is
accompanied by proofs of public logging.

Verifiers use the key hash field to determine which claimant produced a new
statement.  A hash, rather than the full verification key, is used to motivate
verifiers to locate the key and make an explicit trust decision.  Not disclosing
verification keys in the log makes it less likely that someone would use an
untrusted key _by mistake_.

#### 3.1.1 - Preparing a logging request (step 1)
A claimant selects a shard hint and a checksum that should be logged.  The
selected shard hint represents an abstract statement like "sigsum logs that are
active during 2021".  The selected checksum is the output of a cryptographic
hash function.  It could be the hash of an executable binary, a reproducible
build recipe, etc.

The selected shard hint and checksum are signed by the claimant.  A shard hint
is incorporated into the signed statement to ensure that old log leaves cannot
be replayed in a newer shard by a good Samaritan.

The claimant will also have to do a one-time DNS setup.  As outlined below, the
log will check that _some domain_ is aware of the claimant's verification key.
This is part of a defense mechanism that combats log spam.

#### 3.1.2 - Submitting a logging request (step 2)
Sigsum logs implement an HTTP(S) API.  Input and output is human-readable and
uses a simple ASCII format.  A more complex parser like JSON is not needed
because the exchanged data structures are primitive enough.

A claimant submits their shard hint, checksum, signature, and public
verification key as key-value pairs.  The log uses the public verification key
to check that the signature is valid, then hashes it to construct the leaf's key
hash.

The claimant also submits a _domain hint_.  The log will download a DNS TXT
resource record based on the provided domain name.  The downloaded result must
match the public verification key hash.  By verifying that all claimants
control a domain that is aware of their verification key, rate limits can be
applied per second-level domain.  As a result, you would need a large number of
domain names to spam the log in any significant way.

Using DNS to combat spam is convenient because many claimants already have a
domain name.  A single domain name is also relatively cheap.  Another benefit is
that the same anti-spam mechanism can be used across several independent logs
without coordination.  This is important because a healthy log ecosystem needs
more than one log to be reliable.  DNS also has built-in caching which
claimants can influence by setting their TTLs accordingly.

A claimant's domain hint is not part of the leaf because key management is
more complex than that.  A separate project should focus on transparent key
management.  Our work is related to transparent _key-usage_.

A sigsum log will _try_ to incorporate a leaf into its Merkle tree if a logging
request is accepted.  There are no _promises of public logging_ as in
Certificate Transparency.  Therefore, a claimant needs to wait for an inclusion
proof before concluding that the logging request succeeded.  Not having
inclusion promises makes the entire log ecosystem less complex.  The downside is
that the resulting log ecosystem cannot guarantee low latency.

#### 3.1.3 - Proofs of public logging (step 3)
Claimants are responsible for collecting all cryptographic proofs that their
believers will need to enforce public logging.  These proofs are distributed
using the same mechanism as the opaque data.   A believer receives:
1. **Opaque data**: a claimant's opaque data.
2. **Shard hint**: a claimant's selected shard hint.
3. **Signature**: a claimant's signed statement.
4. **(Co)signed tree head**: a log's signed tree head and a list of cosignatures
from so-called _witnesses_.
5. **Inclusion proof**: a proof of inclusion that is based on the logged leaf
and the above tree head.

Ideally, a believer should only accept the opaque data if these criteria hold:
- The claimant's signed statement verifies.
- The log's tree head can be reconstructed from the logged leaf and the provided
inclusion proof.
- The log's tree head has enough valid (co)signatures.

Notice that there are no new outbound network connections for a believer.
Therefore, a proof of public logging is only as convincing as the tree head that
an inclusion proof leads up to.  Sigsum logs have trustworthy tree heads due
to using a variant of witness cosigning.  A believer can not be tricked into
accepting some opaque data that have yet to be publicly logged unless the
attacker controls more than a threshold of witnesses.  In other words, witnesses
are trust anchors that ensure verifiers see the same sigsum statements as
believers.

Sigsum logging can facilitate detection of attacks even if a believer fails open
or enforces the above criteria partially.  For example, the fact that a
repository mirror does not serve proofs of public logging could indicate that
there is an ongoing attack against a claimant's distributed infrastructure.
Interested parties can look for that.

_Monitoring_ -- as in inspecting the log for sigsums that interest you -- can be
viewed as a separate 4th step.  A monitor implements the verifier role and is
necessarily ecosystem specific.  For example, it requires knowledge of public
verification keys, what the opaque data is, and where the opaque data is
located.

### 3.2 - Summary
Sigsum logs are sharded and shut down at predefined times.  A sigsum log can
shut down _safely_ because verification on the believer-side is not interactive.
The difficulty of bypassing public logging is based on the difficulty of
controlling enough independent witnesses.  A witness verifies that a log's
tree head is correct before cosigning.

Claimants, verifiers, and witnesses interact with the log using an HTTP(S) API.
A claimant must prove that they own a domain name as an anti-spam mechanism.
Believers interact with the log _indirectly_ through their claimant's existing
distribution mechanism.  It is the claimant's job to log sigsums and distribute
necessary proofs of public logging.  It is the verifier's job to look for new
statements in the log and alert an arbiter if any claim is false.

An overview of the entire system is provided in Figure 2.
```
TODO: add complete system overview.  See drafty figure in archive.
- Make terminology consistent with Figure 1
- E.g., s/Monitor/Verifier
- E.g., s/leaves/statements
- Add arbiter
```

### 4 - A peek into the details
Our bird's view introduction skipped many details that matter in practise.  Some
of these details are presented here using a question-answer format.  A
question-answer format is helpful because it is easily modified and extended.

#### 4.1 - What is the point of having a shard hint?
Unlike X.509 certificates which already have validity ranges, a checksum does
not carry any such information.  Therefore, we require that a claimant selects a
_shard hint_.  The selected shard hint must be in the log's _shard interval_.  A
shard interval is defined by a start time and an end time.  Both ends of the
shard interval are inclusive and expressed as the number of seconds since the
UNIX epoch (January 1, 1970 00:00 UTC).

Without sharding, a good Samaritan can add all leaves from an old log into a
newer one that just started its operations.  This makes log operations
unsustainable in the long run because log sizes will grow indefinitely.

Such re-logging also comes at the risk of activating someone else's rate limits.

Note that _the claimant's shard hint is not a verified timestamp_.  The
submitter should set the shard hint as large as possible.  If a roughly verified
timestamp is needed, a cosigned tree head can be used instead.

#### How is the threat of log spam and poisoning reduced?
- Relates to: "why not log richer metadata and why not store the opaque data"
- Relates to: "why we removed identifier field from the leaf"
- Relates to: domain hint (maybe better as a separate heading)

#### What are the details for witness cosigning?
- Relates to: explain `tree-head-latest`, `tree-head-to-sign` and
`tree-head-cosigned`

#### What cryptographic primitives are supported?
#### What (de)serialization parsers are needed?
#### Are there any privacy concerns?

#### Other
- How does it work with more than one log?
- What policy should a believer use?
- Coarse-grained vs fine-grained detectability properties
- \<insert more topics here\>

## Concluding remarks
