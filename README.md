# Documentation

This repository contains protocol specifications and other
documentation related to the [Sigsum project][].

[Sigsum project]: https://www.sigsum.org/

## Structure

  - [archive/](./archive) - persisted pads and meeting minutes
  - [assets/](./assets) - project assets such as fonts, colors, and logos
  - [proposals/](./proposals) - proposals relating to design or the project at large
  - [www.sigsum.org/](./www.sigsum.org) - source code of the project website
  - Top-level - documents like [logging design](./design.md),
    [log server protocol](./log.md), and [project history](HISTORY.md)

## Contributing

Feedback ranging from minor nits to proposals are most welcome.  Get in touch
via the [sigsum-general][] email list, in room `#sigsum` at OFTC.net and Matrix,
or through GitLab issues and merge requests.  Anything that requires a formal
decision is decided on Tuesdays at 1100 UTC during [weekly project meets][].

[sigsum-general]: https://lists.sigsum.org/mailman3/postorius/lists/sigsum-general.lists.sigsum.org/
[weekly project meets]: https://meet.sigsum.org/sigsum

## Releases

When technical specifications are released, that means that we assing
a version number to a particular version of a specification, e.g.,
[log server protocol](./log.md), version `v1.0.0`.

### Release principles

Development of the specifications to be released are guided by these
principles:

  1. **Open process:** The community have had a chance to raise
     concerns and suggest improvements leading up to the release of
     the specification. Discussion takes place on IRC/Matrix and the
     [sigsum-general][] list. Substantial changes are prepared as written
     proposals that are decided on Sigsum's open weekly meets.
  2. **Completeness:** The specification has a clear scope, goal, and
     description language that to the best of our knowledge is non-ambiguous.
     It should be possible to implement the specification independently.
  3. **Running code:** There is at least one publicly available, free
     and open source implementation of the specification.
  4. **Stability:** Unless a specification is clearly labeled as
     experimental, the cryptographic formats and other user facing interfaces
     are well-tested, and unlikely to undergo any breaking changes.  Any
     breaking changes must be discussed and communicated well in advance.
  5. **Extensibility:** Additions to the specification that are
     backwards-compatible with previous versions of the specification
     are more easily accepted than breaking changes.
  6. **Versioning:** Specifications are semantically versioned using a
     major, a minor, and a patch number, e.g., `v1.0.0`. The major
     number is incremented if changes are expected to break
     compatibility with implementations of the previous version. The
     minor version is incremented if the specification is extended
     with new backwards compatible features. The patch version is
     incremented for releases including only bug fixes and editorial
     improvements.

### Publishing released specifications

Released versions are identified by git tags of the form
`<filename>-release-<version>`, e.g., `log.md-release-v1.0.0`. The
initial prefix ensures we can have several specifications in the same
git-repository, with independent releases and version numbers.

When a specification is released, it is accompanied by an addition to
the repository's NEWS file and an email to the [sigsum-announce][] list.

If we ever reach a v2 specification while still wanting to make
another release of a v1 specification, we would do the latter on a
dedicated v1 branch.

We intend to publish the latest patch version of each major and minor
release of each specification on
[www.sigsum.org/specs](https://www.sigsum.org/specs). We don't intend
to publish each patch version there, but refer to the git repository
for older patch versions.

[sigsum-announce]: https://lists.sigsum.org/mailman3/postorius/lists/sigsum-announce.lists.sigsum.org/

## Maintainers

  - Linus Nordberg (ln5)
  - Rasmus Dahlberg (rgdd)

## Licence

CC BY-SA 4.0 unless specified otherwise.
