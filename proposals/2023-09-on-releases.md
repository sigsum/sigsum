# How Sigsum could do software releases, take one

This document proposes how Sigsum could get started with releases.  Don't let
perfect be the enemy of good enough.  Several iterations on this is anticipated.

## Background

Things we will likely want to release:

  - Log server software (log-go: `sigsum-log-primary` and `sigsum-log-secondary`)
  - Tooling to submit and verify (sigsum-go: `sigsum-key`, `sigsum-submit`,
    `sigsum-token`, `sigsum-verify`)
  - Monitor (sigsum-go: `sigsum-monitor`)
  - Witness (litetlog: `litewitness` and `witnessctl`)
  - Bastion (litetlog: `litebastion`)
  - Ansible collection
  - Specifications

We need to figure out which ones we are releasing, what that means, and how.  To
keep this proposal small, the focus is on repositories that contain Go code.

## TL;DR - An example log-go release

We announce releases on the sigsum-general mailing list.

> Hi everyone,
>
> The log server software is now released as git-tag v0.13.4 [1], succeeding the
> previous release at git-tag v0.12.2 [2].  See the NEWS file for a complete
> list of changes [3].  Note that **manual steps** are needed before upgrading,
> and that it is assumed you are upgrading (linearly) from the previous release.
>
> This release concerns the following log-go executables:
>
>   - sigsum-log-primary
>   - sigsum-log-secondary
>
> The expectations and intended use of the log server software is documented in
> the log-go RELEASES file [4].  No changes to these expectations have been
> done.  You can expect that the above is compatible with the following:
>
>   - log.md, rc-1
>   - witness.md, rc-1
>   - All tools in sigsum-go, tag v0.5.6 [6]
>   - Witness implementation in litetlog, tag v0.0.3 [7]
>
> Up-to-date log server documentation is available in the log-go repository [5].
>
> If you have any problems with this release or the log server software in
> general, please file a GitLab issue or report it on the sigsum-general list.
>
> Cheers,
> The Sigsum team
> 
> 1: ... links
>

Below is the actual proposal that provides more detail.

## Proposal

### General procedure

Releases are announced on the sigsum-general mailing list.  A release announces
that one or more executables from a single repository are ready to be used.

Exactly which parts are being released is stated in the announcement.

[This ensures that we don't have to put everything on the same release cycle.
And as, say, a log operator, you can care only about the log server release.]

For the Go libraries themselves, we follow [Go's module version numbering][].
At the time of writing that means our libraries are still being developed, v0.
Let's defer the release process of Go libraries until we want a v1 Go API.

Note that there may be multiple git-tags between adjacent releases.  We are not
properly documenting NEWS files and similar for those intermediate git-tags.
Any information about the v0 libraries in these NEWS files are "best effort",
and most likely a side-affect of high-level explanations of what's been done.

There are no promises that downgrading from announcement X to X-1 works.  There
are no promises that upgrading with the announcement notes in X from X-2 works.
We aim to provide clear instructions to upgrade from announcement X-1 to X.

Sometimes these instructions may require manual edits, such as updating a file
path, a file format, or a command-line option name.  In other cases, it might
even be a protocol change.  What to expect is documented for each artifact.

### Announcement email

Checklist:

  - [ ] Link to the previous announcement
  - [ ] Specify a new recommended tag to be used
  - [ ] Specify what executables in the repository is being released
  - [ ] The source repository has a NEWS file
    - A list of high-level changes
    - If any of the cmd/ changes are breaking with regard to to the previous
      announcement, detailed instructions on how to resolve those issues.  For
      example, "replace option `--foo` with option `--bar`".
  - [ ] The NEWS file is linked in the announcement
  - [ ] Highlight in the announcement if there are any breaking cmd/ changes.
        It is sufficient to state it and refer to the NEWS file with details.
  - [ ] The source repository contains a RELEASES file that outlines the release
        process and which expectations a consumer can have.
    - E.g., what is (not) expected to break in upcoming releases
  - [ ] The RELEASES file is linked in the announcement
  - [ ] Specify how to report bugs and any other issues
  - [ ] State what this release is known to be compatible with
    - E.g., "log.md rc-2" and "all command-line tools in the sigsum-go".

### What are we releasing with what expectations

Let's start by only releasing the log server software.  In other words,
`sigsum-log-primary` and `sigsum-log-secondary`.

#### Log server software (expectations)

[The below is written based on us toggling the log.md to a v1 protocol.  If that
is not the case, we will need to weaken the language in the first expectation.]

The expectation that log operators can have are:

  1. No planned changes to the interface between log clients <-> log servers.
     The log.md, version 1, protocol is used.  Any breaking changes would have
     to be considered **very carefully** and be coordinated well in advance.
  2. Expect changes between log servers <-> witnesses, however only on the API
     level ("wire bytes") and not wrt. cryptographic stuff ("signed bytes").  In
     other words, these changes would be completely invisible to log clients.
  3. Expect changes to be done for fixing log server configuration UIs and other
     non-protocol aspects like tuning metrics, performance, etc.

As described in the general procedure, we state in each announcement what other
specifications and tooling is interoperable with a particular release.  We
determine if something is "interoperable" based on CI/CD and manual testing.

[It is not in the scope of this proposal to hash out "manual testing", but that
is essentially the ping-pongs that allow ln5 rgdd to have things running.]

We do recommend operations of the log software in production environments.

We strongly discourage [fail-closed][] usage in end-user applications until
production-grade witnesses are available and operated as well.

[If this was sigsum-go, we could also state expectations wrt. the v0 library.]

[fail-closed]: https://chat.openai.com/share/00b88e34-3de8-4305-bb46-efa2f1486fd8

### Where to document the release process

We would create a RELEASES file in each software artifact repository.  If
helpful, we could have a general outline for this in project/documentation.

## Comparison to what we're doing today

We don't have any documented process.  We [released once][], sending an email to
the sigsum-general mailing list stating the log-go and ansible tags to be used
and what to expect.  The above is a stricter version of our prior commitments,
expect that it is not proposing anything about having ansible releases yet.

[released once]: https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-general@lists.sigsum.org/thread/3VBGVETN3Q44RFGVZJZDF4ZF4QLEMBC2/

## Open questions

  - Should we sign the released git-tag?
  - How do we deal with bug-fix releases?  E.g., if main has moved forward and
    is in no state to be released.  Backport that bug-fix if it is urgent?

## Future ideas

  - Hash out the "manual" testing procedure, so we can be clear about how we're
    testing **and** that is one step closer to getting this into our CI/CD.
  - Specify all tags of other "artifacts" that are known to be working?  Also
    related to improved CI/CD, which is expected to happen over time.
  - More broadly, stronger expectations/language on how things will not break.
  - Signing?
    - Tarball / other packaging
    - git-tag
  - A predictable release cycle?
  - Releases of library code?
  - Releases of ansible?
