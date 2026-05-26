# Sketch of what should go in a release manifest with Sigsum

If one Sigsum logs just the hash of a release artifact (say, a tar
file or git commit object), claims about that release have to be
implicit. E.g., a tarfile is expected to unpack to a single directory
where the name of that top-level directory includes the package name
and the version being released.

To make claims more explicit and gain flexibility, it seems preferable
to Sigsum log a "release manifest", that includes the hash(es) of the
release artifact(s) together with metadata. At a minimum, the metadata
should include name and version. This could be a key-value list or
somethng more structured. These notes lists manifest items in
key-value style, but is not intended to be very opinionated on the
format.

After sketching the release manifest, and we will then move on to the
"process manifest", saying how the release manifests should be
handled.

## Release manifest

At a minimum, the manifest file should include it's type (to
distinguish it from other items being logged), the name of the package
being released, the version, and a hash that cryptographically
identifies what's being released. E.g.,

    type: release-manifest
    package: sigsum-c
    version: 1.0.0
    git-tag: v1.0.0
    git-commit-sha1: 504f3bdc16410ff7eadb00fc463bb9c958ef6ce9

In addition, it could make sense that the manifest includes names and
hashes of other artifacts that can be derived from or extracted from
the release in a reproducible way, e.g., a tar file from `git archive`
or `make dist`, binaries built for some selection of platforms, or
NEWS file and other documentation. Including such additional hashes
makes sense whenever it seems useful to distribute the corresponding
artifact separately. So to continue this example, one could possibly
have a line like

    artifact-sha256: sigsum-c-verify x86_64-linux-gnu fde5333ac97f04d9ccee4e060abf3b5076b4dfee3430db33edb4ff0aca4d7b17

There are two main paths for distribution the release manifest:
Artifact distribution and monitoring.

### Artifact distribution

A user that gets a release artifact should also get the manifest and a
Sigsum proof for that manifest. To make verification easy and robust,
the manifest has to be machine readable, including the list of
artifact names and hashes.

Manifest verification could be part of a mostly unattended upgrade
process, with updates constrained, e.g., to apply only after a certain
time to allow monitors to discover problems with an updated release,
or require human confirmation before updating to a new major version.

### Release monitoring

A monitor tails the log (based on the "Process manifest" described
later), to discover checksums of the release manifest. It must then
access the manifest repository, indexed by checksum, to retrieve the
manifest itself. If fetching the manifest fails, the must raise an
alert.

The monitor can then take several actions on the manifest:

* Archive the manifest for future reference.

* Fetch the release source code based on git hash. Possibly archiving
  that too for future reference.

* Check that the manifest complies with the "Process manifest".

* Verify some or all claims in the manifest, e.g., reprobuilding
  additional artifacts.

* It could package artifacts together with the manifest and a Sigsum
  proof, to distribute to users. E.g., publish binaries, or
  automatically generate a release announce email including the NEWS
  excerpt.

## Process manifest

For the release manifest and corresponding verification and monitoring
to have value, one must configure the related trust policy and public
keys with care.

The "process manifest" is a file that describes how releases are made
and how they should be verified.

At a minimum, the process manifest should have a date from which it is
valid, a URL for the manifest repository, a definition of the set of
releases it applies to, the Sigsum policy and the authorized submitter
keys used to verify release manifests, and a URL for the manifest
repository. E.g.,

    type: process-manifest
    from-date: 2026-05-26
    manifest-repository: https://repo.sigsum.org/by-checksum
    git-repository: https://git.glasklar.is:sigsum/core/sigsum-c.git
    sigsum-policy: sigsum-generic-2025-1
    submitter-keys: 9ff167ebf97b8df9eb4e4c4b805813cf4f2dc824f034f93efba8336a004a7ba4
    package: sigsum-c
    required-release-metadata: version, git-tag, git-commit-sha1

This information is sufficient both for verifying the Sigsum proof for
a release manifest and corresponding artifacts, and for configuring a
monitor that flags new releases, checks that releases are available
under the proper tag and with a sigsum proof, and maybe archives all
data for later.

In addition, the process manifest could specify how reprobuilding of
artifacts work (e.g., how to identify a suitable build environment),
and how the process manifest is updated. Part of this could be machine
readable, but some may require human interpretation.

I think it is highly desirable to require that process manifests are
Sigsum logged (but clearly the initial process manifest would be
self-signed, and has to be distributed out-of-band for bootstrapping).

Some monitors (e.g., for key usage transparency) would generate an
alert for all discovered process manifests, while others could handle
changes to configured keys and policies automatically and silently.

Which submit keys should be used for the process manifests?

* Using a separate submit key could potentially improve security in
  case releases happen very often and have to use an online signing
  key; then the more rare process updates could use a key that is more
  strongly protected.

* On the other hand, if releases are done infrequently, it makes sense
  to use the same key. Then any monitor for release manifests will
  necessarily discover also the process manifests.
