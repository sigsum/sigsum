# Sigsum maintenance mode?

This document provides a birds view of what Sigsum in maintenance mode could
look like.  We loosely define _maintenance mode_ as the state in which Sigsum's
edges are not too rough: we and someone that is not us can operate and use
Sigsum, and we would not be too sad if we did not develop "nice to have" things.

Note: this is not a roadmap.  The intent is to help us talk about what *things*
need to exist without too rough edges to eventually enter maintenance mode; both
as *input* to roadmapping but also to start estimating the maintenance overhead.

## Specifications

- Sigsum log API
- Sigsum proof bundle format
- Sigsum trust policy format
- Bastion host API
- Witness API
- Witness cosignature format/semantics
- Checkpoint format
- Signed noted format

Specifications are rendered www.sigsum.org/specs or C2SP.org.

## Go software

### For operations

- Log server
- Witness 
- Bastion host
  - Stand-alone
  - Integrated in log server
- Ansible for all of the above software

### Packaged tooling

- `sigsum-key`
- `sigsum-token`
- `sigsum-submit`
- `sigsum-verify`
  - Ships with built-in default policy that is sane (can be overridden)
- `sigsum-monitor`
  - Only for key-usage transparency
  - Also ships with built-in default policy that is sane (can be overridden)
- `sigsum-agent` (a minimal ssh agent)
  - backends: file, yubihsm

To have default policies for our tools we need to maintain a list of Sigsum logs
and witnesses.  It would likely be a good idea to also provide a list of logs
for witnesses to consume, and a list of witnesses for logs to accept.  So that
as an operator, one can subscribe to it and so get it managed automatically.

### Libraries

- Everything we need for the above tooling.  The tools themselves should mostly
  just be terminal-UI wrappers that let users interact with our Go libraries.
- We should also have an offline-verify library in a low-level language like C,
  to both have and maintain high-level and low-level reference implementations.

### Release engineering

- We have a streamlined release engineering process.  We should not feel like it
  is annoying to do the release testing in order to cut a small-ish release.

## Test vectors

- Should be available for "offline verify libraries"
  - Includes Merkle tree test vectors, as well as (co)signature and policy stuff
  - Motivation: because we want more implementations of this by others than us.
- Should be available for witnessing
  - Includes valid API requests, responses, and relevant formats/verification
  - Motivation: because we want implementations of this by not us (diversity)

## Documentation

- Introduction to key usage transparency ("getting started")
- How to design a simple use-case step-by-step ("example")
- How to monitor, including how to reason about missing witness cosignatures
- A few well-documented real use-cases, to further help others in their designs
- Manuals for our software and tooling -- including man pages for packaging and
  other relevant further reading that we want to link to from getting started.
  Could be a few "HOW-TO" documents, a glossary of terms we use, etc.
- Operator's best practises -- and other documentation that we think new log
  operators and witnesses should read before onboarding themselves to Sigsum.
- A holistic system overview if the introductory documents doesn't cover this.

We link this documentation so that it can be found from www.sigsum.org/docs.

## Maintenance burden from here on?

- Keep the pulse of the project going, e.g., by giving talks, encouraging
  operations of logs and witnesses, and maintaining a sane trust policy.
- Maintain the codebase by processing issues, MRs, and other feedback we get.
  Also includes keeping tracking of dependencies and doing release engineering.
- New users will likely want to discuss their use-cases and get feedback.  Such
  discussions will likely happen on IRC, Matrix, mailing lists, and/or a
  recurring meets where higher bandwidth is available (e.g., every 2-4 weeks).

The maintenance burden will be bursty and depend on how much traction Sigsum
gains (as well as how fast such traction is gained).  As an initial estimate it
seems reasonable to assume that this will be a part-time requiring <50% work.

Overtime the maintenance effort should decrease.  Because our tools and
documentation matures while the conceptual integrity of Sigsum is constant.

Roles the above entails: project management, user support, software design and
development.

## Future development projects in Sigsum?

Not in scope of this document.
