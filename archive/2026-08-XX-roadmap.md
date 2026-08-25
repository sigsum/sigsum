# 2026-08-25

This document provides an overview of Sigsum's roadmap and people with standing
responsibilities.  A new roadmap will be decided around ~mid of November, 2026.

## High-level priorities

In roughly this order whenever possible:

  1. Specification work
  2. Sigsum logs are operated with good business continuity
  3. Witnesses are operated with good business continuity
  4. It is easy to use Sigsum
     - Wrt. integrating into something existing
     - Wrt. being a party that offline-verifies
     - Wrt. being a party that monitors
  5. Further development (broader and possibly experimental)

From these high-level priorities we define shorter-term activities.

**Change note:** we put specification work back at priority one, to reflect that
there's a flurry of activity already and more spec work is needed (see below).

## Main activities until mid November, 2026

  - **Talk at and attend the transparency.dev summit 2026 (29 Sep - 1 Oct)**
    - https://transparency.dev/summit2026/
  - **Release sigsum-agent with parallel signing**
    - Work by: elias
    - Review by: nisse
    - Expected outcome:
      - Finalize work-in-progress
        [branch](https://git.glasklar.is/sigsum/core/key-mgmt/-/tree/elias/parallel-signing)
        so that it can be merged to main
      - Release engineering / make the release
    - Estimated done: TODO(@elias)
  - **Release log-go with Prometheus metrics**
    - Work by: nisse
    - Expected outcome:
      - A few minor improvements (sockerfri/nisse have been discussing)
      - Release engineering / make the release
    - Estimated done: TODO(@nisse)
  - **Various specification-related work:**
    - **Work by:** rgdd, nisse, others
    - **Expected outcome:**
      - Gain confidence in the [drafty leaf-format specification](https://github.com/C2SP/C2SP/pull/244)
      - Draft a sigsum/v2 log.md specification based on C2SP.org building blocks
        - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2024-11-04-sigsum-v2-ideas
        - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2025-09-03-leaf-context-for-sigsum-v2.md
        - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2026-05-12-sigsum-next-meetup-notes
        - Be ready to talk about this on the transparency.dev summit
      - Explore use of Tessera and changes to our libraries and tools
      - Other specification work that might be paged in (less certain):
        - Tombstones for secure off-boarding of logs?
        - Secure configuration updates in witness-network.org?
        - Per-log bastion support in witness-network.org?
        - Optional authentication of incoming log checkpoints?
        - More progress and/or releases of work-in-progress C2SP.org specs,
          e.g., related to ML-DSA-44, tlog-policy, and similar?
        - More progress on getting ML-DSA-44 wordings into witness-network.org?
      - **Estimate done:** no estimate, but this is nisse's primary focus and
        rgdd's partial focus until ~mid of November.  Revisit status then.
  - **Support ML-DSA-44 cosignatures in litewitness and sigsum-agent**
    - **Work by:** quite
    - **Review by:** nisse, filippo
    - **Expected outcome:**
      - Soft ML-DSA-44 key; encrypted at rest with a passphrase
      - sigsum-agent interacts with the soft ML-DSA-44 key
      - litewitness interacts with sigsum-agent via the ssh agent protocol
      - litewitness supports cosigning with >1 key, e.g., so that it's possible
        to rotate a key while keeping the old one or to run with Ed25519+MLDSA.
      - Use namespace ML-DSA-44@sigsum.org or similar (there's no standard yet)
      - For exploration: take a look at where standardization work is at, but
        we think that the right call right now is to step 1: do our own thing.
    - **Estimated done:** October ish.
  - **Further development of sign-if-logged:**
    - mw will be working on our backlog of ideas and TODOs, likely starting by
      exploring gpg signature support (to bring transparency to legacy places).
    - No definite expected outcome/timeline yet, talk to mw for current status.
    - Input and review from nisse, quite can also help with TKey questions

  - **TODO:** anyone else want to contribute something to this list to let folks
    know what they're working on?  No need to commit to when/if it will be done.

As usual: support, bug fixing, and other maintenance is in scope and planned
separately when needed.  Please reach out if there are any off-roadmap needs!

## People and their standing responsibilities

  - elias:
    - Maintains Sigsum's [ansible collection][]
    - Responsible for the Sigsum project's test log, [barreleye][]
    - Point of contact for log and witness operators who would like user support
  - filippo
    - Maintains [C2SP.org][] specifications
    - Maintains [litebastion][]
    - Maintains [litewitness][]
    - Maintains <https://witness-network.org>
  - florolf:
    - Maintains [sigmon][]
  - ln5:
    - Maintains Sigsum specifications in [project/documentation][]
  - mw
    - Maintains Sigsum's [app/][] repositories
  - nisse
    - Maintains [C2SP.org][] specifications
    - Maintains Sigsum specifications in [project/documentation][]
    - Maintains Sigsum's [core/][] repositories
    - Maintains Sigsum's [app/][] repositories
  - rgdd
    - Maintains [C2SP.org][] specifications
    - Maintains Sigsum specifications in [project/documentation][]
    - Maintains the content on [Sigsum's website][]
    - Maintains <https://witness-network.org>
    - Responsible for planning, coordinating, chairing, "catch all", etc

**Change note:** elias is now solely responsible for barreleye and operational
point of contact questions (used to also be ln5).

**Change note:** mw is now a maintainer of [app/][] repositories.

[ansible collection]: https://git.glasklar.is/sigsum/admin/ansible
[barreleye]: https://test.sigsum.org/barreleye
[C2SP.org]: https://c2sp.org/
[litebastion]: https://github.com/FiloSottile/torchwood/blob/main/cmd/litebastion/README.md
[litewitness]: https://github.com/FiloSottile/torchwood/blob/main/cmd/litewitness/README.md
[sigmon]: https://github.com/florolf/sigmon
[project/documentation]: https://git.glasklar.is/sigsum/project/documentation
[core/]: https://git.glasklar.is/sigsum/core
[app/]: https://git.glasklar.is/sigsum/apps
[Sigsum's website]: https://www.sigsum.org/

## What happens after November, 2026

To be decided, but we don't expect any major changes in high-level priorities.

A natural next TKey app after sign-if-logged is a log signer or a witness
signer.  In other words, such work is likely to make it into the roadmap.

For further hints on what might be selected as the main activities in the
future, refer to Sigsum's [issue boards][] and (sometimes "DRAFT:")
[milestones][].  Try filtering on the GitLab ["Future" tag][].  If you have
input on what you want to see work on, file and comment on issues or reach out
as you see fit.  Contact information can be found on <https://www.sigsum.org/>.

[issue boards]: https://git.glasklar.is/groups/sigsum/-/issues
[milestones]: https://git.glasklar.is/groups/sigsum/-/milestones
["Future" tag]: https://git.glasklar.is/groups/sigsum/-/issues/?sort=created_date&state=opened&label_name%5B%5D=Future&first_page_size=20
[sigsum/next]: https://git.glasklar.is/sigsum/project/documentation/-/issues/66

## Previous roadmap from April, 2026

  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2026-04-21-roadmap.md
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2025-04-21--meeting-minutes.md#decisions

## Summary of progress since April, 2026

  - We hosted a Sigsum community meet in Stockholm, Sweden (May 5-7).
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2026-03-02-community-meetup-in-may-info
    - A highlight: https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2026-05-12-sigsum-next-meetup-notes
  - sign-if-logged v1.0.0 is available, see announcement for details.
    - https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-announce@lists.sigsum.org/thread/4JIBPYQXICPHQZLXRI34HENNUPQ7W3PB/
  - sigsum-c v1.1.0 is available, see announcement for details.
    - https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-announce@lists.sigsum.org/thread/7G3SKN73UDYFHGH2VQAVJAPFWDDO6KZY/
  - torchwood vX.Y.Z is available, see NEWS file for details.
    - TODO: add link
    - Among other things, litewitness now supports pipelined SSH agent signing
      requests and logs that sign checkpoints with ML-DSA-44.
  - There's a branch of sigsum-agent that supports >1 YubiHSM (not in main yet)
    - https://git.glasklar.is/sigsum/core/key-mgmt/-/tree/elias/parallel-signing
  - There's a branch of what might become Sigsum's v2 ansible collection
    - https://git.glasklar.is/sigsum/admin/ansible/-/tree/pkg
    - The main differences are: clean up old legacy and depend on packaged
      versions of Go binaries rather than using Go's toolchain in ansible.
    - Current status is that this is what Glasklar uses for witness-g1.
  - Glasklar started operating a high-availability witness group
    - https://git.glasklar.is/glasklar/services/witnessing/-/blob/about-witness-g1/g1.witness.glasklar.is/about.md
    - Current status is that it's up and running but still being finalized
  - Drafty C2SP.org specifications with ML-DSA-44 support are available
    - TODO: add brief summary and/or links -- current status etc.
  - C2SP.org now renders specifications (as opposed to redirecting to GitHub)
    - https://C2SP.org/
  - We attended PETS, where kfs had a keynote that mentioned Sigsum's work
    - https://www.youtube.com/watch?v=FZy20hw4uok&t=0s
  - TODO: more summary items?

We did not have time to release a version of sigsum-agent with support for >1
YubiHSM (parallell signing).  This work continues in the upcoming roadmap.

We won't have enough time to start working on a TKey log signer app with
integration in log-go.  We're putting this back into our backlog for now.

Glasklar did not have time to do a proper write about about witness-g1 yet.
Glasklar still plans to document how witness-g1 was designed and developed.
