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
The party that uses the signed data in the end is called an _end-user_.

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
- **Preserved data flows:** an end-user can enforce sigsum logging without making
additional outbound network connections.  Proofs of public logging are provided
using the same distribution mechanism as is used for distributing the actual data.
In other words, the signer talks to the log on behalf of the end-user.
- **Defenses against log spam and poisoning:** to keep logs as useful as
possible they should be open for everyone.  However, accepting logging requests
from anyone at arbitrary rates can lead to abusive usage patterns.  We store as
little metadata as possible to combat log poisoning.  We piggyback on DNS to
combat log spam.
- **Built-in mechanisms that ensure a globally consistent log:** transparency
logs rely on gossip protocols to detect split-views.  We built a proactive
gossip protocol directly into the log.  It is a variant of
	[witness cosigning](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=7546521).
- **No cryptographic agility**: the only supported signature schemes and hash
functions are Ed25519 and SHA256.  Not having any cryptographic agility makes
protocols and data formats simpler and more secure.  The used signing format is
compatible with OpenSSH and can easily be modelled with the below parsers.
- **Simple (de)serialization parsers:** complex (de)serialization parsers
increase attack surfaces and make the system more difficult to use in
constrained environments.  Signed and logged data can be (de)serialized using
	[Trunnel](https://gitlab.torproject.org/tpo/core/trunnel/-/blob/main/doc/trunnel.md),
or "by hand" in many modern programming languages.  This is the only parsing
that an end-user is required to support.  Signers, monitors, and witnesses
additionally need to interact with a sigsum log's ASCII HTTP(S)
        [API](https://git.sigsum.org/sigsum/tree/doc/api.md).

## 2 - Threat model
We consider a powerful attacker that gained control of a signer's signing and
release infrastructure.  This covers a weaker form of attacker that is able to
sign data and distribute it to a subset of isolated end-users.  For example,
this is essentially what the FBI requested from Apple in the San Bernardino case
	[\[FBI-Apple\]](https://www.eff.org/cases/apple-challenges-fbi-all-writs-act-order).
The fact that signing keys and related infrastructure components get
compromised should not be controversial these days
	[\[SolarWinds\]](https://www.zdnet.com/article/third-malware-strain-discovered-in-solarwinds-supply-chain-attack/).

The same attacker also gained control of the signing key and infrastructure of a
sigsum log that is used for transparency.  This covers a weaker form of attacker
that is able to sign log data and distribute it to a subset of isolated
end-users.  For example, this could have been the case when a remote code
execution was found for a Certificate Transparency Log
	[\[DigiCert\]](https://groups.google.com/a/chromium.org/g/ct-policy/c/aKNbZuJzwfM).

The overall system is said to be secure if a log monitor can discover every
signed checksum that an end-user would accept.
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
               | Witness |           | false       | End-user |
               +---------+           | claim       +----------+
                                     v
                                investigate
           
                       Figure 1: system overview
```

A signer wants to make their key-usage transparent.  Therefore, they sign a
statement that sigsum logs accept.  That statement encodes a checksum for some
data.  Minimal metadata must also be logged, such as the checksum's signature
and a hash of the public key.  A hash of the public
key is configured in DNS as a TXT record to help log operators combat spam.

The signing party waits for their submission to be included in the log.  When an
inclusion proof is available that leads up to a trustworthy Merkle tree head,
the signed checksum's data is ready for distribution with proofs of public
logging.  A sigsum log does not help the signer with any data distribution.

End-users use the signer's data if it is accompanied by proofs of public
logging.  Monitors look for signed checksums and data that correspond to public
keys that they are aware of.  Any falsifiable claim that a signer makes about
their key-usage can now be verified because no signing operation goes unnoticed.

End-users and monitors can be convinced that public logging happened without
additional outbound network connections if a threshold of witnesses followed a
cosigning protocol.  More detail is provided in Section 3.2.3.

### 3.1 - Merkle tree
A sigsum log maintains a public append-only Merkle tree.  Independent witnesses
verify that this tree is fresh and append-only before cosigning it to achieve a
distributed form of trust.  A tree leaf contains three fields:
- **checksum**: a cryptographic hash that commits to some data.
- **signature**: a digital signature that is computed by a signer for the
selected shard hint and checksum.
- **key_hash**: a cryptographic hash of the signer's public key that can
be used to verify the signature.

Any additional metadata that is use-case specific can be stored as part of the
data that a checksum represents.  Where data is located is use-case specific.

Note that a key hash is logged rather than the public key itself.  This reduces
the likelihood that an untrusted key is discovered and used by mistake.  In
other words, end-users and monitors must locate signer public keys
independently of logs, and trust them explicitly.

### 3.2 - Usage pattern
#### 3.2.1 - Prepare a request
A signer prepares the message, for which the checksum is to be logged.
For example, it could be a hash that commits to an executable binary.

The signer signs the checksum. The exact signing format is compatible with
`ssh-keygen -Y sign` when using Ed25519 and SHA256.

The signer also has to do a one-time DNS setup. The signer needs to
create a secondary rate limit keypair and use the private key to
create a submit token. As outlined below, logs will check that _some
domain_ is aware of the public key associated with a token. This is
part of a defense mechanism that helps log operators to deal with log
spam. Once present in DNS, a public key can be used in subsequent log
requests.

#### 3.2.2 - Submit request
Sigsum logs implement an HTTP(S) API.  Input and output is human-readable and
use a simple ASCII format.  A more complex parser like JSON is not needed
since the data structures being exchanged are primitive enough.

The signer submits their message, signature, public key and domain
hint as ASCII key-value pairs. The log uses the submitted message to
compute the signer's checksum, and verifies the signature. The public
key is then hashed to construct the Merkle tree leaf as described in
Section 3.1.

Before a new leaf is accepter, the log also verifies that the
secondary rate-limit key is present in DNS, and uses it check validity
of the submit token, and apply domain-based rate limiting.

A sigsum log will
	[try](https://git.sigsum.org/sigsum/tree/doc/proposals/2022-01-add-leaf-endpoint)
to add the submitted request to its tree, a process known as merging.
It will not issue _promises of public logging_ though, as done in Certificate Transparency
with so-called SCTs. Therefore, sigsum
logs cannot guarantee low latency.  The signer needs to wait until the log has
accepted their request, after which it can be verified using an inclusion proof.
A log must use a merge interval of five (5) minutes or shorter in order to
fulfill the freshness criteria that witnesses require, see also 3.2.3.

#### 3.2.3 - Wait for witness cosigning
Cosigning witnesses poll logs for tree heads to be cosigned at least once per minute,
verifying that they are fresh (not older than five minutes) and
append-only (no leaves were removed or modified) before doing any cosignature
operations.  Tree heads are signed using the same signing format as tree leaves,
except that a different sigsum and log-specific context is being used.  Cosignatures
are posted back to their respective logs, making them available in one place per log.

The above means that it takes up to 5-10 minutes before a cosigned tree head is
available.  Depending on implementation it may be as short as one minute.  The
added latency is an important trade-off that significantly simplifies sigsum
logging by removing the need for reactive gossip-audit protocols
	[\[G1,](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=7346853)
	[G2,](https://datatracker.ietf.org/doc/html/draft-ietf-trans-gossip-05)
	[G3,](https://petsymposium.org/2021/files/papers/issue2/popets-2021-0024.pdf)
	[G4\]](https://docs.google.com/document/d/16G-Q7iN3kB46GSW5b-sfH5MO3nKSYyEb77YsM7TMZGE/edit).

Use-cases like instant certificate issuance are by design not supported.

#### 3.2.4 - Distribution
Once a signer has collected proofs of public logging the distribution phase can
start.  Distribution happens using the same mechanism that is normally used for
the data.  For example, on a website, in a git repository, etc.
Signers distribute at least the following pieces:

**Data:**
the signer's data, for example an executable binary.  It can be used to
reproduce a logged checksum.

**Metadata:**
the resulting signature over checksum, and the public key hash used in
the log request. Note that the combination of data and metadata can be
used to reconstruct the logged leaf.

**Proof:**
an inclusion proof that leads up to a cosigned tree head.  Note that _proof_
refers to the collection of an inclusion proof and a cosigned tree head.

#### 3.2.5 - Verification
An end-user should only accept the distributed data if the following criteria hold:
1. The data's checksum is signed using the specified public key.
2. The provided tree head can be reconstructed from the logged leaf and
its inclusion proof.
3. The provided tree head is from a known log with enough valid cosignatures.

Notice that there are no new outbound network connections for an end-user.
Therefore, an end-user will not be affected by future log downtime since the
signer already collected relevant proofs of public logging.  Log downtime may be
caused by temporary operational issues or simply because a log has
been closed.

The lack of external communication means that a proof of public logging cannot
be more convincing than the tree head an inclusion proof leads up to.  Sigsum
logs have trustworthy tree heads thanks to using a variant of witness cosigning.
An end-user cannot be tricked into accepting data whose checksum have not been
publicly logged unless the attacker controls more than a threshold of witnesses.

#### 3.2.6 - Monitoring
An often overlooked step is that transparency logging falls short if no-one
keeps track of what appears in the public logs.  Monitoring is necessarily
use-case specific in sigsum.  At a minimum, monitors need to locate relevant
public keys.  They may also need to be aware of how to locate the data that
logged checksums represent.

### 3.3 - Summary
Sigsum logs are sharded and can be shut down _safely_ in the future because
verification for end-users is not interactive.

The difficulty of bypassing public logging is based on the difficulty of
controlling enough independent witnesses.  A witness checks that a log's tree
head is correct before cosigning.  Correctness includes freshness and the
append-only property.

Signers, monitors, and witnesses interact with the logs using an ASCII HTTP(S)
API.  A signer must prove that they control a DNS domain name as an anti-spam
mechanism.  No data or rich metadata is being logged, to protect the log
operator from poisoning.  This also keeps log operations simpler because there
are less data to manage.

End-users interact with logs indirectly through their signer's existing
distribution mechanism.  Signers are responsible for logging signed checksums
and distributing necessary proofs of public logging.  Monitors discover signed
checksums in the logs and generate alerts if any key-usage is inappropriate.

The signing format for logs, witnesses, and signers is based on a subset of
what is supported by OpenSSH.  Ed25519 and SHA256 must be used as primitives.

### 4 - Frequently Asked Questions
#### 4.1 - Why use the OpenSSH signing format?
Our main criteria for a signing format is that it can express signing contexts
without any complex parsers.  A magic preamble is good for overall hygiene
as well.  We sketched on such a format using Trunnel.  We realized that by
tweaking a few constants it would be compatible with SSH's signing format.  If
it is possible to share format with an existing reliable and widely deployed
ecosystem, great!

#### 4.2 - What is the point of hashing the submitted message?
Logging arbitrary bytes can poison a log with inappropriate content.  While a
leaf is already light-weight in Sigsum, a stream of leaves could be made to carry more
meaning. Disallowing checksums to contain arbitrary bytes, by having logs compute
them, makes crafting of leaves with chosen content computationally costly.

It is worth pointing out that the submitted message is limited to be a 32-byte
buffer.  If the data to be transparently signed is `D`, the recommended message
is `H(D)`.  The resulting checksum would be `H(H(D))`.  The log will not be in a
position to observe the data `D`, thereby removing power in the form of trivial
data mining while at the same time making the overall protocol less heavy.

#### 4.3 - What is the point of the submit token?
The submit token, and associated rate limit public key registered in
DNS, helpd log operators combat spam. By verifying that every signer
controls a domain name that is aware of their public key, rate limits
can be applied per registered domain (e.g, using
<https://publicsuffix.org/list/>). You would need a large number of
domain names to spam a log in any significant way if rate limits are
not set too loose.

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

A signer's domain hint must have the left-most label set to `_sigsum_v0` to
reduce the space of valid DNS TXT RRs that a log needs to permit queries for.
See further details in the
	[proposal](https://git.sigsum.org/sigsum/tree/doc/proposals/2022-01-domain-hint)
that added this criteria.

We are considering if additional anti-spam mechanisms should be supported in v1.

#### 4.4 - What parts of witness cosigning are not done?
There are interesting policy aspects that relate to witness cosigning.  For
example, what witnessing policy should an end-user use and how are trustworthy
witnesses discovered.  This is somewhat analogous to a related policy question
that all log ecosystems must address.  Which logs should be considered known?

We do however think that witness cosigning could be done _from the perspective
of a log and its operator_.  The
	[sigsum/v0 API](https://git.sigsum.org/sigsum/tree/doc/api.md)
supports witness cosigning.  Policy aspects for a log operator are easy because
it is relatively cheap to allow a witness to be a cosigner.  It is not a log
operator's job to determine if any real-world entity is trustworthy.  It is not
even a log operator's job to help signers and end-users discover witness keys.

Given a permissive policy for which witnesses are allowed to cosign, a signer
may not care for all retrieved cosignatures.  Unwanted ones can simply be
removed before distribution to an end-user takes place.  This is in contrast to
the original proposal by
	[Syta et al.](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=7546521),
which puts an authority right in the middle of a slowly evolving witnessing policy.

#### 4.5 - What parts of the design are up for debate?
Several parts are under consideration for the v1 design.  Any feedback on what
we have now or might (not) have in the future would be appreciated.  We are not
in any particular rush to bump the version and want to experiment more with v0.

A list of some debated topics:

  - Support any additional cryptographic algorithms?  For example, is it a
  worth-while complexity trade-off to add a NIST curve?  Note that this question
  is about cryptographic primitives; not additional signature formats like PGP.
  - Accept or reject the [checkpoint format][] that the TrustFabric team uses
  for (co)signed tree heads?  It is also a relatively simple ASCII format, and
  we support it as an experimental endpoint (`<log URL>/checkpoint`).  The main
  differences from our current cosigned tree head format are:
    - The signed blob is not based on SSH
    - Base64 instead of hex
    - Extensibility in an "other data" section
    - No timestamp verification without defining an extension
    - A signature-line format that is less minimal
  - Keep or remove tree head timestamps?  A monitor can convince itself of
  freshness by submitting a leaf request, observing that it gets merged by a
  cosigned tree head.  There are pros and cons, see [timestamp reflections][].
  - Is it a worthwhile complexity trade-off to have a "quick" cosigned tree head
  endpoint that provides cosignatures as fast as possible?  Right now there is a
  "slow" cosigned tree head endpoint that makes all cosignatures available at
  once.  The motivation for this is that a ["quick" endpoint adds complexity][]
  while only giving _lower latency_; not _low latency_.  The "slow" cosigned
  tree head endpoint could also be implemented to just rotate a bit faster.
  - Should there be support for any alternative rate-limiting mechanism?  A
  domain hint could be viewed as a subset of several possible _ownership hints_.
  - Should there be any IANA registration for the future `_sigsum_v1` DNS label?

[checkpoint format]: https://github.com/google/trillian-examples/blob/master/formats/log/README.md
["quick" endpoint adds complexity]: https://git.sigsum.org/sigsum/tree/doc/proposals/2022-01-no-quick-tree-head-endpoint
[timestamp reflections]: https://git.sigsum.org/sigsum/tree/archive/2022-02-08-timestamp-reflections.md

#### 4.6 - How does Sigsum compare to Sigstore?
A comparison between Sigsum and Sigstore was [archived on March 15, 2022][].

[archived on March 15, 2022]: https://git.sigsum.org/sigsum/tree/archive/2022-03-15-notes-on-sigsum-and-rekor.md

#### 4.7 - More questions
- What are the privacy concerns?
- Add more questions here!
