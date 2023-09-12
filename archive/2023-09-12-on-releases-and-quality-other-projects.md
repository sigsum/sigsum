# On releases and quality

Be warned: drafty notes by rgdd, shared is better than not shared. :)

What we're trying to answer: how are other projects that we like defining
releases, release cycles, and quality?  Can we copy-paste any of that?

These notes focus on the first question, i.e., what other projects do.

## curl

### TL;DR

8w release cycle in three stages: cool down ("fix bugs from last release"),
features ("bring em in!"), and freeze ("hunt bugs, polish").  Repeat.

Releases are versioned as <Major>.<Minor>.<Patch>, all three are counters.
Minor is bumped for new features; patch for bug fixes etc.  Unclear on a quick
read when Major is bumped.  Seems like it may happen even w/o breaking changes.

The Shared Object Name is bumped on libcurl ABI breakage.  "We are determined to
bump the SONAME as rarely as possible. Ideally, we never do it again."

Quality is based on every MR being reviewed by a maintainer, and by a CI test
suite that runs in many different environments.  Expectation is managed by
aiming to avoid changes to behavior, and only updating (non-experimental)
APIs/ABIs deliberately and carefully.  If a release causes serious breakage,
contains critical bugs, or similar, a patch release is created.  There is no
formal process for what qualifies.  Argue your case.  If a consensus can not be
reached in tricky situations, Daniel is the Benevolent Dictator For Life.

The most crucial part to deliver on these expectations seems to be: know your
APIs/ABIs.  And to have a test suite with good coverage, which is applied on a
wide variety of supported systems that matters to the project / its users.  And
that this test suite remains in a good state gets enforced by the maintainers.

Note that the definition of quality is largely related to managing expectations,
and that even curl (that is _very well documented_) is a bit hand-wavy here.

### Wall

Lots and lots of documentation about curl's processes, see [curl/docs][].

  - [Governed by][] Daniel Stenberg as Benevolent Dictator For Life (BDFL).
    "Will only continue working as long as Daniel [listens to user]
    expectations.  [...] The project is not a democracy, but everyone is
    entitled to state their opinion and may argue for their sake within the
    community.  [...] Ideally, we find consensus for the appropriate way forward
    in any given situation or challenge.  [...] If there is no obvious
    consensus, a maintainer who's knowledgeable in the specific area will take
    an "executive" decision that they think is the right for the project".
  - [Contribution guidelines][], including things like: every new feature must
    be documented in the curl man page, and every new feature and function must
    have at least one valid test case to ensure that it works as documented.
    Not having tests requires explaining why and how you ensured that it works.
    Changes should obviously not break existing tests, see CI pipeline status.
    All MRs should [get reviewed][] by an experienced maintainer before
    acceptance, and if an MR is not wanted the maintainer should explain why as
    early as possible (and possibly if it can be changed to maybe become
    acceptable).  API/ABI changes may be fine, but must be deliberate and
    carefully done.  Changing existing behavior should be avoided if possible.
  - Sometimes MRs get the `need-votes` label by a maintainer.  Basically means
    in addition to meeting all normal requirements, the need needs motivation.
  - Features that are [experimental][] are disabled on build-time by default.
    Any features that are considered experimental have zero stability promises.
  - So [what runs in the CI][]?  Test suites applied to different environments.
    To some degree, this sets the expectation of what bugs will be caught.
  - The actual [release process][] is to release every 8 weeks.  Sometimes
    releases happen +-1 a week due to red days, holidays, etc.  Such moving is
    advertised well in advance.  Each release cycle has three stages:
    - _Cool down_, 10 days:  Only bug fixes are merged.  No new features.  A
      follow-up patch release might be made if a regression is detected.
    - _Feature window_, 21 days: new features and changes are accepted.
    - _Feature freeze_, 25 days: only bug fixes and polishing.  No new features.
  - The actual release process is just to follow a step-by-step "do this", "zip
    that", "sign", "upload", etc.  See [release process][].
  - Sometimes an [early release][] is warranted.  Typically because Something
    Went Really Wrong For Something That Is Deemed Important.  See the list.
    Unless very urgent, never early release more frequently than 7 days after
    the previous release.  This ensures that more fixes can be resolved.

[curl/docs]: https://github.com/curl/curl/tree/master/docs
[governed by]: https://github.com/curl/curl/blob/master/docs/GOVERNANCE.md
[contribution guidelines]: https://github.com/curl/curl/blob/master/docs/CONTRIBUTE.md
[get reviewed]: https://github.com/curl/curl/blob/master/docs/CODE_REVIEW.md
[experimental]: https://github.com/curl/curl/blob/master/docs/EXPERIMENTAL.md
[what runs in the CI]: https://github.com/curl/curl/blob/master/tests/CI.md
[release process]: https://github.com/curl/curl/blob/master/docs/RELEASE-PROCEDURE.md
[early release]: https://github.com/curl/curl/blob/master/docs/EARLY-RELEASE.md

## Go

### TL;DR

The Go project releases every 6 months.  There are two phases:

  - _Open tree_, where changes and new features are accepted.  Large and risky
    features are preferred in the early stages of this phase.
  - _Freeze_, where only bug fixes and documentation is accepted.  Includes
    creating release candidates that the community can test on their systems.

The first two weeks of each release cycle is used for planning.  It is announced
on the go-dev mailing list.  Contributions say/sync what they plan to work on.

The goal is backwards compatibility as the major/minor versions are incremented.
This expectation is meant for source code, not compiled code.  The Go team
reserves the right to break backwards compatibility, and have a list of reasons
why they might have to do so to help set expectations.  The go tool chain (e.g.,
`go`, linkers, etc) is not backwards-compatible across different major versions.

Quality is assured by:

  - Being design-driven.  Significant changes that, e.g., break APIs or modify
    externally visible behavior requires a proposal.  After discussion, it is
    either accepted, rejected, or a detailed design documented is requested.  In
    other words, crucial design decisions are not discussed while writing code.
  - Aiming for backwards-compatibility and refining release candidates to make
    them as stable as possible.  The main tree of Go is also deployed internally
    at Google in production.  If that does not succeed, main is rolled back.
  - (There's also a entire handbook for making contributions, I did not go
    through it.  I would assume there's stuff there about testing, etc.)

### Input from Filippo

The size of the project matters.  The Go team is ~20-50 people.  There's
constant churn and development.  No-one knows everything that goes into the
tree.  There are people who's only job it is to be on the release team.

Contrast this to a small project.  It is possible to know exactly what goes into
the tree.  If you can't keep it all in your head, you need systems to help you.

Go is [released][] every six months.  Two phases in the release cycle:

  1. _Open tree_: Changes, new features, etc., are welcome.
  2. _Freeze_: No major changes are welcome.  The focus is to resolve bugs and
     issues to make a stable release.  Release candidates are created.  The
     community is encouraged to test and report issues from their environments.
     The closer to the release, the fewer fixes are accepted as they may too
     contain bugs.  Trade-off between risk and benefits.  Argue your case.

The community feedback aspect doesn't really work though.  People don't run
release candidates in production.  They show up later to report their issues.

The Go team deploys the current development tree internally at Google.  It
becomes the main Go production tool chain at Google.  This is very different
from three years ago.  Then only release candidates was deployed like this.

If the main branch fails in this internal deployment: rollback and fix it.

So the minimum bar for quality here is "works for Google's infrastructure", and
there is an entire infrastructure to get that tested in production work loads.

[released]: https://github.com/golang/go/wiki/Go-Release-Cycle

### More details

The development process is design-driven.  Significant changes [requires a
proposal][].  At minimum to be discussed, sometimes also formally documented.

Creating a proposal:

  - Open an issue
  - After issue tracker discussion: accept, decline, or ask for design doc.  The
    latter becomes another round of discuss, then it is accepted or declined.
  - Implementation can proceed as usual if the proposal is accepted.

Significant changes include API changes in the main repo and golang.org/x, as
well as command-line changes to the `go` tool and visible behavior changes in
existing functionality.

There's a [template][] for how a proposal should be structured.

Go is [released][] every 6 months.  Release planning happens the first two
weeks, announced on the [go-dev][] mailing list.  Large and/or risky features
should preferably land early on in the development phase, to detect and fix
problems.  After a release, it is supported with minor releases that fix serve
bugs and issues.  Typically: either security or stability issues get minors.

Minor releases "preserve backwards compatibility as much as possible, and don't
introduce new APIs".

The freeze may be ignored if communicated and approved by the Go release team.

Example of a release email:

  - https://groups.google.com/g/golang-dev/c/ixHOFpSbajE

Example of a "planning email":

  - https://groups.google.com/g/golang-dev/c/V8ez4YunkeE/m/hKBvkZOZAQAJ
  - Essentially, tell us what **you** plan to be doing.  So that you and others
    and coordinate as the tree opens.

Promise on backwards-compatibility?  The intention is that a program that
compiles in Go `v1.X` should continue to compile and work in `v1.Y`, `Y>X`.

This is not always the case, however.  Impossible to guarantee.  There's a list
on things that may result in breakage.  Helps set [expectations][].

For the Go tool chain (compilers, linkers, build tools, etc), a script that
depends on the location and properties of the tools may be broken by a point
release.

Compatibility is at the source level, not binary level.  Something compiled for
`v1.X` may not work properly with `v1.Y`, `Y>X`.  There's no guarantee that code
compiled for `v1.Y` would also work on an earlier version `v1.X`.

Code in subtrees (not main Go tree), e.g., golang.org/x/net, may be developed
under looser compatibility requirements.

[requires a proposal]: https://github.com/golang/proposal#readme
[template]: https://github.com/golang/proposal/blob/master/design/TEMPLATE.md
[go-dev]: https://groups.google.com/g/golang-dev
[expectations]: https://go.dev/doc/go1compat

## tor

- https://gitlab.torproject.org/tpo/core/team/-/wikis/NetworkTeam/CoreTorReleases
- https://gitlab.torproject.org/tpo/core/team/-/wikis/NetworkTeam/SupportPolicy
