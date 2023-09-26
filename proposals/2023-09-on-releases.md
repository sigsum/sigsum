# How Sigsum could do software releases, take one

This document proposes how Sigsum could do releases.  The goal is define
something that is good enough to **get started**, in particular for the log-go
repository and its `sigsum-log-primary` and `sigsum-log-secondary` tools.

This proposal is expected to be directly applicable to releases of our other
repositories with CLI tools.  It is also expected that we will have to iterate
on this process/proposal over time.  Please add any suggestions that you think
can be omitted in this initial stage at the end, see "Future ideas" section.

## Background

Things we will likely want to release:

  - Log server software (log-go: `sigsum-log-primary` and `sigsum-log-secondary`)
  - Tooling to submit and verify (sigsum-go: `sigsum-key`, `sigsum-submit`,
    `sigsum-token`, `sigsum-verify`)
  - Monitor (sigsum-go: `sigsum-monitor`)
  - Witness (litetlog: `litewitness` and `witnessctl`)
  - Bastion (litetlog: `litebastion`)
  - Other sigsum-go tools that didn't fit into the above: `sigsum-mktree`
  - Ansible collection
  - Specifications
  - Libraries

We need to figure out which ones we are releasing, what that means, and how.  As
already stated, the scope to consider here is CLI tools / log-go stuff.

## Proposal in general

Releases are announced on the sigsum-general mailing list.  A release is
tailored for a single repository.  For example, if we want to release something
in both log-go and sigsum-go, then that would require two separate releases.

[This ensures that we don't have to put everything on the same release cycle.
And as, say, a log operator, you can care only about the log server software.]

If something in a repository is being released, there must be a RELEASES file
and a NEWS file.  The RELEASES file documents the release process at large and
which expectations users of the released software can have.  The NEWS file
documents what changed since the last release, including **detailed** migration
steps if there are any breaking changes with regard to the previous release.

There are no promises that downgrading from release X to X-1 works.  There are
no promises that upgrading to release X from X-2 works.  What we aim to provide
are **clear instructions on how to upgrade from release X-1 to X**.  In other
words, it is assumed that users follow along in the linear upgrade history.

We don't backport bug-fixes.  To get a fix, upgrade to the next release.

[Practically speaking, this may mean that we checkout the previously released
tag, make a critical bug-fix, release a new version with that, then incorporate
that bug-fix into the main branch that may have other work-in-progress things.]

[And if we are starting to tag the main branch without making a release,
always bump v0.X.Y to v0.X+1.0 so we can do emergency release v0.X.Y+1.)

There's no release cycle.  We release when something new is available.  But to
reassure that following along with the release history linearly is not going to
result in excessive overhead, our intent is to not release more often than every
four weeks.  In most cases we will likely release even less frequently.  And in
some cases, we may have to fix a critical bug and release as soon as possible.

[As our implementations and processes mature we update these expectations.  The
intent here is to get started with something that we can try and iterate on.]

### NEWS file, checklist

  - [ ] The previous NEWS entry is the previous release
  - [ ] Broad summary of changes
  - [ ] Detailed instructions on how to upgrade from the previous release, only
    applicable if there are breaking changes (or if breaking changes are being
    fixed in the background as a result of starting to run the new software).
  - [ ] Other repositories/tools/tags that are known to be interoperable.

### RELEASES file, checklist

  - [ ] What in the repository is being released and supported
  - [ ] Where are releases announced (sigsum-general mailing list)
  - [ ] The overall release process (based on the above procedure)
  - [ ] The expectation we as maintainers have on users
  - [ ] The expectations users can have as us on maintainers
    - E.g., including how we're testing a release and what we intend to (not)
      break in the future.

### Announcement email, checklist

  - [ ] What is being releases
    - E.g., log server software / log-go.
  - [ ] Specify new release tag
  - [ ] Specify previous release tag 
  - [ ] Specify how to report bugs
  - [ ] Refer to the RELEASES file for information on the release process and
    expectations
  - [ ] Copy-paste the latest NEWS file entry

## Comparison to what we're doing today

We don't have any documented process.  We [released once][], sending an email to
the sigsum-general mailing list stating the log-go and ansible tags to be used
and what to expect.  The above is a stricter version of our prior commitments,
expect that it is not proposing anything about having ansible releases yet.

## Future ideas

  - Hash out "manual" testing procedures, so we can be clear about how we're
    testing **and** that is one step closer to getting this into our CI.
  - Specify all tags of other "artifacts" that are known to be working?  Also
    related to improved CI, which is expected to happen over time.
  - More broadly, stronger expectations/language on how things will not break.
  - Signing?
    - Tarball / other packaging
    - git-tag
  - A predictable release cycle?
  - Releases of library code?
  - Releases of ansible?
  - Releases of specs?

[Based on our discussions, it seems like signing and packaging are the two most
urgent things to improve on in the near future.]

[released once]: https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-general@lists.sigsum.org/thread/3VBGVETN3Q44RFGVZJZDF4ZF4QLEMBC2/

## Example: log-go

Based on the above general procedure: a RELEASES file and an announce email,
included here mostly as examples.  If this proposal is accepted, there will be a
separate log-go MR based on the below.  In other words, the exact text doesn't
have to be polished to perfection right now.

### RELEASES

The following command-line tools are released and supported:

  - `cmd/sigsum-log-primary`
  - `cmd/sigsum-log-secondary`

Releases are announced on the [sigsum-general][] mailing list.  All information
that operators need to upgrade is listed in this repository's [NEWS
file](./NEWS).  Pay close attention to manual migration steps, if any.

Note that a release is simply a git-tag specified on our mailing list.  You are
expected to build the released tools yourself, e.g., with `go install`.  There
may be intermediate git-tags between two adjacent releases.  Don't deploy those.

As of now there is no release cycle.  We release when something new is ready.
Unless there are critical bug fixes, expect at least a month between releases.

You are expected to upgrade linearly from release X to X+1 unless specified
otherwise.  Downgrading (X to X-1) or jumping ahead (X to X+2) may break things.

You can expect the following about the released log server software:

  1. No planned changes to the interface between log clients <-> log servers.
     The log.md, v1, protocol is used.  Any breaking changes would have to be
     considered **very carefully** and then be **coordinated well in advance**.
  2. Changes between log servers <-> witnesses on the API level ("wire bytes"),
     but not with regard to cryptographic stuff (such as "signed bytes").  In
     other words, these changes would be completely invisible to log clients.  
  3. Changes to improve log server configuration interfaces and other
     non-protocol aspects like tuning metrics, performance, etc.

The exact specifications and tags in other Sigsum repositories that are
interoperable are listed in the [NEWS](./NEWS) file for each release.  We
determine what is interoperable based on our CI pipelines and manual testing.

It is not recommended to [fail closed][] on the operated Sigsum logs yet.  At
least one production witness should be deployed before any such dependence.

[fail closed]: https://chat.openai.com/share/00b88e34-3de8-4305-bb46-efa2f1486fd8

### log-go email announcement template

Hi everyone,

The log server software is now released as git-tag vY.Y.Y, succeeding
the previous release at git-tag vX.X.X'.

If you find any bugs, please report them here on the sigsum-general
mailing list or open an issue on GitLab in the log-go repository:

  https://git.glasklar.is/sigsum/core/log-go/

The expectations and intended use of the log server software is
documented in the log-go RELEASES file.  You will also find more
information about the overall release process there.

Below is an extract from the release notes in the log-go NEWS file.

  Copy-paste NEWS file for git-tag vY.Y.Y here.
