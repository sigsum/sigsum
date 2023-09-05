# Document process for reviewing and adding dependencies

## Objective

When adding, or updating, dependencies to the sigsum-go repository,
it's important to:

1. Review the source code of the package we depend on, to judge
   general code quality and rule out malicious code.

2. Ensure that the dependency that we, as well as our users, will
   download as part of the go build process, actually is the same code
   that was reviewed.

## Naïve approach

E.g., when considering a adding a package hosted at github as a
dependency, it is easy to review code by browsing at github, and copy
the corresponding version tag or commit hash into our "go.mod" file.
However, we then totally depend on our view of github. If there is a
targeted attack (e.g., involving a github insider, or a mitm attack
using a rogue CA certificate), the code we reviewed on the web need
not correspond at all to the code we list as a dependency in go.mod.

## Local review

It seems better to review code locally: clone the repository we want
to depend on. Code can then be reviewed locally, and the corresponding
git hash should be added in the "go.mod" file, or compared to what is
added to "go.sum". Then correspondence between reviewed code and
commit hash depends only on the integrity of local tools (and in case
local git executable, editor, or operating system is compromised,
we're in deeper trouble than problems with dependency review).

(There have been bugs making it dangerous to even clone a malicious
repository, see https://www.cve.org/CVERecord?id=CVE-2014-9390 and
https://git-blame.blogspot.com/2014/12/git-1856-195-205-214-and-221-and.html,
but it is intended to be safe and under no circumstances execute any
of the downloaded code).

## TODO

* Understand exactly what help we get from the go checksum database,
  if we do local review at a certain version tag, and specify that tag
  in go.mod. As far as I understand, the local commit hash must be
  included in the process in some way.

* Plan migration of all our git repositories to sha256, see
  https://git-scm.com/docs/hash-function-transition/, and track how
  our dependencies migrate. As far as I can tell, all our repos are
  currently on "repositoryformatversion = 0", see `.git/config`. I'm
  checking my local clones, not sure what's on out gitlab server;
  transition plan includes some interop between sha256 and sha1
  repos.
