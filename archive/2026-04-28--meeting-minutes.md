# Sigsum weekly

  - Date: 2026-04-28 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: rgdd
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - rgdd
  - elias
  - tta
  - florolf
  - warpfork
  - filippo
  - mw
  - nisse
  - Justin Cappos (NYU)
  - Marco (NYU)
  - Patrick (NYU)

## Status round

  - nisse: did a sigsum talk at the chains workshop at kth, slides: https://git.glasklar.is/nisse/chains-2026/-/raw/main/slides.pdf. Me and Elias also brought our poster: https://git.glasklar.is/nisse/cysep-2025/-/raw/main/poster.pdf
  - nisse: sigsum-c docs, https://git.glasklar.is/sigsum/core/sigsum-c/-/merge_requests/45
  - nisse: preparing for sigsum-c release
  - filippo: landed tlog-cosignature 1.1
    - ML-DSA based cosignatures
    - https://github.com/C2SP/C2SP/pull/237
  - filippo: MTC document, considering what should be in C2SP
  - filippo: format for signed subtree and protocol to request a witness to please sign a subtree
    - filippo: just needed a way to request signature on a subtree
      - PR to tlog-witness https://github.com/C2SP/C2SP/pull/245
      - subtrees are something that MTC does to reduce the size of standalone certificates
        - getting a signature on a subtree is an optimization
  - filippo: CT log dashboard
    - people keep asking how much it costs to run a CT log?
    - created https://stats.sunlight.geomys.org/
  - rgdd: prepared proposal on how to select Go version
    - Based on the pointers we received when discussing with jas
    - see Decisions section below
  - rgdd: a few words about the sync hayden and i had about future collab stuff
    - https://github.com/C2SP/C2SP/pull/244
    - hayden is working on sigstore
    - the idea is to look at merging sigstore (rekor) and sigsum v2
      - can we have the same read API so that we can share monitor tooling?
      - further: can we even have the same submission API
    - there is some flexibility to do things in a good way
  - rgdd: the usual -- various feedback / rubberducking (e.g., tlog.directory)
    - currently wip paging in the details in tlog-witness extension PR
  - warpfork: litewitness (lives in torchwood repo) gaining some prometheus metrics:  https://github.com/FiloSottile/torchwood/pull/71
    - modulo... ci has go version opinions, is that... intended?  (no)
    - main forwardlooking thought: starting to think this stuff could use an integration test playground?
      - discussion:
        - we don't love integration tests that are always broken because they're overcomplicated or depend on difficult-to-set-up sandboxing, etc... so this needs to be simple and needs to be worth it if it's done.
        - exercised getting-started documentation for potential users would be nice tho.
        - pondering using nushell?  not universally available but also maintainable vs bash, and you still ultimately see commands being run in a shell-like way.
    - nisse: for sigsum logs we have tests where we check at least that the metrics endpoint works
  - warpfork: published one explainer/intro doc about tlogs I've been working on: https://warplog.leaflet.pub/3mkiaduggkc2c
    - this is a high level one ("for the C suite") rather than the more technical/professional link-hub I've also been drafting.
    - link to it if you dare?
  - tta: worked on AT (archive transparency) , understood few things
    - what I probably want is re-using tlog mirrors
      - want to be able to allow people to create immutable logs of "their files"
    - I am trying to spec 2 things at once there:
        1. how to turn collection of items into leaves (api, ux, etc)
        2. how to log leaves into logs & mirror them (trust model, etc)
    - worked on making 1/ clear to make 2/ easier later
    - summary about archive transparency:
        https://dev.archive.rip/ggs/openrip/draft-spec/src/main/SUMMARY.md (wip)
    - played a bit with sigsum logs also
  - florolf: had plans to integrate sigsum-c into something
    - then I found a hardware that's available and suitable for creating a witness
      - ARM system with secure boot and trustzone support (https://www.st.com/en/evaluation-tools/stm32mp257f-dk.html)
        - built a small demo witness system
        - not just signing but also verification of consistency proofs
        - if currently mostly works, have substituted my test witness for this one for a few hours as a test
    - what kind of hardware is it?
    - emmc integrated
    - storage is currently slow
    - one solution would be to have the whole storage in the secure world
    - filippo: 2^32 seconds is years

## Decisions

  - Decision: Adopt proposal on how to select Go version
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/143
    - so far we have used the version in debian backports
    - but for debian packaging it's okay to use newer
    - filippo: sounds reasonable
      - good practice for a library is to be on latest minus one
    - nisse: for debian users it means you will have to either let go download the needed version, of to use go from debian forky
      - filippo: I strongly recommend to use toolchain "auto" to allow downloading
  - Decision: cancel weekly next week due to sigsum/st community meetup

## Next steps

  - nisse: keep working on sigsum-c release milestone
  - filippo: more Go 1.27 work, the freeze is coming
  - filippo: get that tlog-witness PR to land
  - filippo: implement tlog-mirror and ML-DSA signatures in torchwood and sunlight
  - filippo: look at per-log bastion
  - elias: try out litewitness prometheus metrics
  - florolf: more work on the witness thing
  - tta: try to draft up a CLI to create leaves for archive transparency
  - rgdd: main thing is to unblock in the tlog-witness spec

## Other

  - tta: ppl vibe coding merkle tree visualizers made me try something
          - asked $agent to take an old py script of mine (ascii merkle trees) and made it js
          - see https://archive.rip/static/tmp/merkle/ (for fun, throw-away code)
  - Justin: is the sigsum-design-cats-2023.pdf paper the most complete security analysis of Sigsum?
    - rgdd: yes, that's definitely a good one to look at
    - rgdd: there is also the specifications - https://www.sigsum.org/docs/
    - rgdd: there is some thread modelling in the log.md document - https://git.glasklar.is/sigsum/project/documentation/-/blob/log.md-release-v1.0.1/log.md
    - trying to understand the boundaries around what you are trying to do, in corner cases
      - very difficult to reason about how to use a tool if you don't understand the corner cases
    - justin: would it be of interest to have a document saying "if attacker does this, then the system works like this"?
      - rgdd: yes!
    - justing: what's the best way for us to ask questions?
      - rgdd: best way is sigsum matrix room
      - rgdd: then there is also the sigsum mailing list
      - https://www.sigsum.org/contact/
      - rgdd: there is also this meeting every week
      - rgdd: you can also schedule time to talk outside these meetings
  - next week is a Sigsum/ST meetup, should we have the Sigsum weekly meeting anyway?
    - we will cancel it (noted above under Decisions)
