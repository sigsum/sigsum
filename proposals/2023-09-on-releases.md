# How Sigsum could do software releases, take one

This document proposes how Sigsum could do software releases.  The goal is to
get started with something that's good enough.  We can refine it over time.

## Background

The current software artifacts are:

  - Log server software (log-go)
  - Command-line tooling (sigsum-go)
  - Monitor (sigsum-go)
  - Witness (litetlog)
  - Bastion (litetlog)
  - Ansible collection?

We need to figure out which ones we are releasing, what that means, and how.

## TL;DR - An example log-go release

We announce releases on the sigsum-general mailing list.

> Hi everyone,
>
> The log server software is now released as git-tag v0.13.4 [1], succeeding the
> previous release at git-tag v0.12.2 [2].  See the NEWS file for a complete
> list of changes [3].  Note that **manual steps** are needed before upgrading,
> and that it is assumed you are upgrading (linearly) from the previous release.
>
> The expectations and intended use of the log server software is documented in
> the log-go RELEASES file [4].  No changes to these expectations have been
> done.
>
> Up-to-date log server documentation is available in the log-go repository [5].
> Other software artifacts that are known to work with this release include:
>
>   - Sigsum tooling in sigsum-go, tag v0.5.6 [6]
>   - Witness implementation in litetlog, tag v0.0.3 [7]
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
a single software artifact.  For example, a release of our log server is
separate from the release of our ansible collection and witness implementation.

[This ensures that we don't have to put everything on the same release cycle.
And as, say, a log operator, you can care only about the log server release.]

Note that there may be multiple git-tags between adjacent releases.  We are not
properly documenting NEWS files and similar for these intermediate git-tags.

There is no release cycle.  We announce releases when something new is ready.

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
  - [ ] The source repository has a NEWS file
    - A list of changes
    - If any of these changes are breaking with regard to to the previous
      announcement, detailed instructions on how to resolve those issues.  For
      example, "replace option `--foo` with option `--bar`".
  - [ ] The NEWS file is linked in the announcement
  - [ ] Highlight in the announcement if there are any breaking changes
  - [ ] The source repository contains a RELEASES file that outlines the
        release process and which expectations a consumer can have.
    - E.g., what is (not) expected to break in upcoming releases
  - [ ] The RELEASES file is linked in the announcement
  - [ ] Specify how to report bugs and any other issues

Optionally:

  - [ ] Link other software artifacts that are known to be compatible

### What are we releasing with what expectations

Let's start by only releasing the log server software.  If we're not releasing a
software artifact, we should clearly state that and why in its git repository.

#### Log server software

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

Until (2) is is a stable interface, every announcement of the log software
release should be accompanied by an interoperable witness tag.  And similarly if
(1) is not stable, an operable tag for the Sigsum tooling in sigsum-go.

We do recommend operation of the log software in production environments.

We strongly discourage failed-close usage in end-user applications until
production-grade witnesses are available and operated as well.

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

Maybe what will (not) be a "smooth" upgrade should be tied to the semantic
versioning in our git repositories.  Leaving this as is for now in favor of
getting some early feedback.

## Future ideas

  - Specify all tags of other artifacts that are known to be working?
  - More broadly, stronger expectations on how things will not break.
  - Tar ball / packaging?
  - Signing?
  - A predictable release cycle?
