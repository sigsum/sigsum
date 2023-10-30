# Proposal: how we release specifications and what that means

## Overall traits

The traits we expect to surround a specification that is being released:

  1. **Open process:** the community have had a chance to raise concerns and
     suggest improvements leading up to the release of the specification.  The
     open process takes place async on IRC/Matrix and the sigsum-general list,
     as well as in proposals that are decided on Sigsum's open weekly meets.
  2. **Completeness:** the specification has a clear scope, goal, and
     description language that to the best of our knowledge is non-ambiguous.
     It should be possible to implement the specification independently.
  3. **Running code:** the specification has been implemented.
  4. **Stability:** the cryptographic formats and other user facing interfaces
     are well-tested, and unlikely to undergo any breaking changes.  Any
     breaking changes must be discussed and communicated well in advance.
  5. **Extensibility:** additions to the protocol that doesn't undermine
     stability may be accepted.  The open process must be followed for this.
  6. **Versioning:** the specification is semantically versioned using a major,
     a minor, and a patch number, e.g., `v1.0.0`.  The major number is incremented
     if changes are expected to break compatibility with
     implementations of the previous version.  The minor version is incremented if
     the specification is extended with new backwards compatible features.  The
     patch version is incremented for bug fixes and editorial changes.
  7. **Publication:** the specification is published so that all released versions can
     be read, including a NEWS file that describes what changed in each version.

## Managing versions

The specification is hosted in a (shared) git-repository.  The tag format is
`<filename>-release-<version>`, e.g., `log.md-release-v1.0.0`.  The initial
prefix ensures we can have several specifications in the same git-repository.

When a specification is released, it is accompanied by an addition to the
repository's NEWS file and sending of an email to the sigsum-general list.

If we ever reach a v2 specification while still wanting to make another release
of a v1 specification, we would simply do the latter on a dedicated v1 branch.

We intend to publish the current major and minor releases of the
specifications on https://www.sigsum.org/specs.  We
don't intend to render every patch version there (they are available in git).

## Where to document this information when this proposal has been adopted?

project/documentation/README after some polishing of the text to suit a README.
