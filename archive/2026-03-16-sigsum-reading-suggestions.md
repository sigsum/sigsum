**Warning:** this is not meant as a smooth read.  The intent is to help you know
where to start digging if you really want to understand a lot of the details.  By
doing this reading exercise on your own you will probably learn a lot, and also
be able to ask questions that you otherwise wouldn't have thought of asking.

And who knows, maybe you will want to help improve sigsum's documentation so
that there's much smother onboarding readings in the future?

Typed up by rgdd on 2026-03-13, archived 16th.

# Some suggested readings to grok Sigsum in detail

What is a transparency log in sigsum's context?

* Basically an append-only list represented as a Merkle tree
* https://gitlab.torproject.org/rgdd/ct/-/blob/main/doc/tlog-preliminaries.md
* https://gitlab.torproject.org/rgdd/ct/-/blob/main/doc/tlog-algorithms.md

In sigsum, the Merkle tree leaves correspond to *signed checksums*:

* 32 byte checksum (sha256)
* 32 byte key hash (sha256)
* 64 byte signature (Ed25519)

The following specification defines the leaf format, as well as other related
data formats and a REST API to interact with sigsum logs.

* https://git.glasklar.is/sigsum/project/documentation/-/blob/main/log.md

While you could use something like curl to interact with a sigsum log (as shown
in the examples), it will probably be easier to use sigsum's existing tools.  To
get an overview of some of the existing tools, try the getting started guide.

* https://www.sigsum.org/getting-started

Read usage messages for the different tools, or if you did `apt install
sigsum-go` you might prefer to read usage messages through the man pages.  Also
consider checking out the detailed tooling guide, or `man sigsum-tools`.

* https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/tools.md

For relevant formats (inputs and outputs) that the sigsum tools use, see:

* https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/sigsum-proof.md
* https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/policy.md
* https://www.glasklarteknik.se/post/named-policies-for-sigsum/

Now note that Sigsum is a building block.  In other words: much like Ed25519 is
a building block for signatures and SHA256 is a building block for cryptographic
hashes, sigsum is a building block for signed checkums that can be discovered.

Three examples that use Sigsum as a building block:

* https://git.glasklar.is/sigsum/apps/sign-if-logged
* https://git.glasklar.is/rgdd/sshdt
* https://github.com/FiloSottile/age/blob/main/SIGSUM.md
  * https://git.glasklar.is/rgdd/age-release-verify
  * (warning: the verify tool was a quick demo and might not run right now, but
    it might still be helpful to checkout to understand the utility better.)

The sigsum home page contains further elevator pitches for Sigsum.

* https://www.sigsum.org/

By now you should start having an intuition for Merkle trees, inclusion proofs,
consistency proofs, the formats and REST API of sigsum, how sigsum can be used
as a building block, that witness cosigning is the crucial part that adds trust
(i.e., split-view protection), that sigsum logs are mainly depended on for
availability (in particular during submission and to facilitate monitoring).
End users *never* talk directly to the log.  Submitters distribute proofs.

Some talks that might help digest Sigsum from a few more angles:

* https://transparency.dev/summit2024/sigsum.html
  * In particular, see if you can start understanding and appreciating the table
    about how the design space was enumerating when designing sigsum (p. 13).
* https://archive.fosdem.org/2025/schedule/event/fosdem-2025-5661-sigsum-detecting-rogue-signatures-through-transparency/
* https://www.osfc.io/2022/talks/using-sigsum-logs-to-detect-malicious-and-unintended-key-usage/

This poster should also summarize much of what you've just learned:

* https://git.glasklar.is/nisse/cysep-2025/-/blob/main/poster.pdf

---

Now we've traversed Sigsum from the bottom and up.  Let's dive back down.

How does the current implementation of a Sigsum log work?

* [Trillian][] is used as a transparency-log backend.  Think of Trillian as a
  separate process that interacts with a database such as MariaDB or postgres,
  and additionally manages a Merkle tree (including computing proofs etc).
* Trillian doesn't know "what it's storing" at the leaves, i.e., it's opaque and
  could be anything: an X.509 certificate, a Go module, or in the case of sigsum
  a signed checksum that's just 128 opaque bytes from Trillian's perspective.
* So what sigsum's [log-go implementation][] implements is a *Trillian
  personality*.  This basically means that we have another process that
  implements sigsum's REST API, and then sends queries back and forth to
  Trillian internally (using gRPC).  There's of course nothing that prevents
  using a different backend than Trillian, but that's what is currently used.

[Trillian]: https://github.com/google/trillian
[log-go implementation]: https://git.glasklar.is/sigsum/core/log-go

Some reading that might help understand Trillian a bit better:

* https://www.rgdd.se/post/observations-from-a-trillian-play-date/
* https://www.rgdd.se/post/trillian-log-sequencing-demystified/

Finally, since creating sigsum/v1 we've gradually migrated specifications to
C2SP.org.  The following specifications are worth looking at:

* https://C2SP.org/tlog-cosignature <-- witness cosignature semantics
* https://C2SP.org/tlog-witness <-- protocol for logs to request cosignatures
* https://C2SP.org/https-bastion <-- expected to be implemented by logs, so that
  witnesses can connect the log's bastion and so not need a public endpoint.
* https://C2SP.org/tlog-checkpoint <-- the internal representation of signed
  tree heads / cosigned tree heads.  Not vissible to end-users of sigsum.

Since witness cosigning is generally useful beyond Sigsum, we've also created
<https://witness-network.org/> based on the above witnessing specifications.

Want to know a bit of sigsum's history? See:

* https://git.glasklar.is/sigsum/project/documentation/-/blob/main/history.md

Want to know some things we're considering in a future sigsum/v2? See:

* https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2024-11-04-sigsum-v2-ideas
* https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2025-09-03-leaf-context-for-sigsum-v2.md
* (And when going up to sigsum/v2, we would most likely start using [Tessera][]
  as the backend instead of Trillian.)

[Tessera]: https://github.com/transparency-dev/tessera

Want to try and get your head around a (perhaps not so intuitive) observation
about the number of cosignatures an end-user and a monitor needs to see?

* https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2023-11-byzantine-witnesses.pdf
* Assuming all witnesses are honest, see if you can figure out how many
  cosignatures a monitor needs to see to be sure there are no split views
  if end-users use a 1-of-3 policy. What if it's instead a 2-of-3 policy?
  What if it's a 2-of-3 policy and one witness is dishonest?

# Some additional reading

Sometimes you will hear people talk about authenticated dictionaries, Merkle
search trees, or similar to mean a transparency log with the property of
efficient search.  So, in the Merkle tree structure we've been looking at we
have efficient inclusion and consistency proofs; but not efficient search.  A
searchable Merkle tree is expected to have an efficient *non-membership proof*.
I.e., it is possible to prove that a particular item is *not in the log*
efficiently.  (The inefficient solution is of course to reveal the entire log,
which is how monitors in Sigsum and most other transparency logs work today).

The intuition for how these kinda data structures work is basically: take a tree
data structure that supports efficient search; then represent that tree data
structure as a Merkle tree.  Done!  (There are of course other constructions
that can achieve this without trees, but I'll try to keep it brief here.)

Examples of tree data structures in this category include:

* Sparse Merkle trees: https://eprint.iacr.org/2016/683
* Merkle prefix trees: https://www.usenix.org/system/files/conference/usenixsecurity15/sec15-paper-melara.pdf
* ...

The downside? Now it is instead "hard" to prove consistency.  To overcome this
limitation, it is possible to combine "append-only logs" and "searchable logs".

* https://github.com/google/trillian/blob/master/docs/papers/VerifiableDataStructures.pdf

This is called *log-backed maps*, and the most current industry work to
facilitate log-backed maps is so called *verifiable indices* (a type of
verifiable map, i.e., to use the terminology in the above white paper).  Think
of a verifiable index as a deterministic mapping from an append-only log to a
searchable log.  If you have both these building blocks = log-backed map.

* https://github.com/transparency-dev/incubator/tree/main/vindex

For a concrete application / demo that uses a verifiable index, see:

* https://words.filippo.io/keyserver-tlog/

The threat model for verifiable indices is that *at least someone* verifies the
mapping from log -> index.  This is a pretty modest assumption given that we
have witness cosigning to protect against split views.

We of course want a verifiable index for sigsum -- it's basically been in our
wishlist / backlog since we started working on sigsum.  It makes monitoring
cheap, and can also help provide efficient "latest" queries for end users.

There's of course more stuff you could read and dig into, but I'll stop here
since it's already a lot.  But if you still want something more to dig into,
perhaps take a look at rgdd's previous transparency work which will get you into
the direction of Certificate Transparency, verification challenges there, etc.

* https://www.rgdd.se/stable/phd-thesis.pdf

Feel free to ask questions to rgdd and others in #sigsum on IRC/Matrix.
