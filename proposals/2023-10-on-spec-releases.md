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
  3. **Running code:** the specification has been tested in implementation.
  4. **Stability:** the cryptographic formats and other user-facing interfaces
     are stable, well-tested, and unlikely to undergo any breaking changes.  Any
     breaking changes must be discussed and communicated well in advance.
  5. **Extensibility:** any additions to the protocol that doesn't undermine
     stability may be accepted.  The open process must be followed for this.
  6. **Versioning:** the specification is semantically versioned using a major,
     minor, and a patch number, e.g., `v1.0.0`.  The major number is incremented
     if the stability guarantee is broken.  The minor version is incremented if
     the specification is extended with new backwards-compatible features.  The
     patch version is otherwise incremented, e.g., if the language is improved.
  7. **Hosting:** the specification is hosted so that all released versions can
     be read, including a NEWS file that describes what changed in each version.

## Managing versions

The specification is hosted in a (shared) git-repository.  The tag format is
`<filename>-release-<version>`, e.g., `log.md-release-v1.0.0`.  The initial
prefix ensures we can have several specifications in the same git-repository.

If a specification is released, it is always accompanied by an addition to the
repository's NEWS file and sending of an email to the sigsum-general list.

If we ever reach a v2 specification while still wanting to make another release
of a v1 specification, we would simply do the latter on a dedicated v1 branch.

We intent to list the current major+minor releases on www.sigsum.org/specs.  We
don't intend to render every patch version there (they are available in git).

## Where to document this information post-proposal?

project/documentation/README after some polishing of the text to suit a README.
