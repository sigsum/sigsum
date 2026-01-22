# Use vX.Y.Z tags only for rofficial releases

Historically, we have used sigsum-go tags of the same format for both
official releases, and development releases (e.g., to enable uses of
new library features in log-go). The documented distinction is that
only tags mentioned in the NEWS file ar releases.

However, this practice is a bit unconventional and has caused some
confusion. See
https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/171.

# Proposal

* From now on, use tags of the format vX.Y.Z (e.g., v0.14.1)
  exclusively for releases.

* For non-releases, if the latest releast is vX.Y.Z, use tags of the
  form vX.Y.(Z+1)-dev.W, with increasing W. Then semantic versioning
  and the go tools order this version between vX.Y.X and vX.Y.(Z+1).
  The dot before W ensures that the W field is compared numerically
  rather than lexicographically.

# On using raw commit hashes

One can also specify a dependency version using a commit hash. E.g.,
if I use a go.mod require line like

    sigsum.org/sigsum-go 78c70772b806312f248772504e6af2c360d5c05d

the `go mod tidy` tool translates that to a synthetic pseudoversion,

    sigsum.org/sigsum-go v0.14.1-0.20260122082554-78c70772b806

(the previous tag was v0.14.0). This kind of dependency versions is
handled by go modproxy and checksumdb similar to any other version.
E.g.,

```
$ GET https://sum.golang.org/lookup/sigsum.org/sigsum-go@v0.14.1-0.20260122082554-78c70772b806
49187087
sigsum.org/sigsum-go v0.14.1-0.20260122082554-78c70772b806 h1:AA6yIQ1rqVdK6zlOSFAhU4xggPMEPYTpfXBK1G+6Ibk=
sigsum.org/sigsum-go v0.14.1-0.20260122082554-78c70772b806/go.mod h1:C9uX+IuDkPwQpb4C+jQCKZpLHJ9cYvIUy498Mmroa90=

go.sum database tree
49189689
ftjbAOzaupaIvaPo/G+Dk63nxOZ2s1OPOKIaPtXs7S4=

— sum.golang.org Az3grlKZssqRoMNPpZfKt0TphbbcF+pzXqElURJKRNFKfaUAgqeI5k2AORH0QAhg/ebRwyIqD/OqP4oLtLnNumvOBAM=
```

However, monitoring for pseudoversions is difficult; they are too many
to make monitoring of existence useful. Unfortunately, the commit hash
that is included in the pseudo version is truncated to 48 bits, which
is not quite enough to cryptographically identify a commit.
Potentially, a monitor could check that for each pseudoversion, there
is a unique commit matching the truncated commit hash, and that the
record in the checkum database is consistent with the data at that
commit.

But until such monitoring is in-place, it seems preferable to stick to
explicit -dev tags, which can be monitored in the same way as release
versions, e.g., via gopherwatch.org. Mixing of pseudo versions based
on commit hashes with explicit -dev tags will likely not result in a
sane ordering of versions.

# Considerations for bug fix releases

We will likely have to tweak these tagging scheme if/when we need to
do bugfix releases. E.g., assume we have this series of events:

1. Release version v1.1.0.

2. Add new features, release v1.1.1-dev.0.

3. A bug is discovered, and a bugfix-branch is created starting from
   1.1.0. A bugfix is backported, and released as v1.1.1.

4. Now I v1.1.0 is considered later than v1.1.1-dev.0, even though it
   lacks features added in that dev version.

Maybe this is a reason to bump the minor (middle) number rather than
the patchlevel when making a -dev-tag? I.e., vX.(Y+1).0-dev.W? That
would mirror our previous practice: e.g., when new features are added
after a v0.13.1 release, our non-release tags start from v0.14.0, to
reserve the v.13.x tag space for potential bugfix releases.
