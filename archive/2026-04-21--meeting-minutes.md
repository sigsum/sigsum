# Sigsum weekly

  - Date: 2026-04-21 1215 UTC
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
  - mw
  - nisse
  - filippo
  - gregoire

## Status round

  - filippo: reviewed tlog-cosignature PR
  - filippo: go 1.27 and PQ stuff
  - filippo: discussed parallel signing, pipelining
    - discussed making pipelining degree configurable
    - right now, pipelining is not supported
    - suggested hard-coding limit of 32
    - nisse: I had a quick look, it was a bit more complicated than I had expected
      - filippo: I have not done the code review yet
    - rgdd: can we assume that this will land in one way or another?
      - filippo: yes, and in the meantime you can test locally
    - rgdd: how about metrics for litewitness?
      - filippo: not yet
        - we have discussed a few times adding prometheus metrics to litewitness
          - warpfork could do it?
  - florolf: paged in sigmon again and did some stuff
    - added quite a bit of tests
    - fixed things when log has only one or zero entries
    - accept leaves even if there is no quorum
    - preparations for doing more stuff with tracking witnesses for split-view and byzantine situations
    - switched a project from sigsum-go to sigsum-c
      - used for about 120 devices
      - using cli tools as dropin replacements
  - nisse: added shared library support in sigsum-c
    - seems to be working fine
    - going to a workshop on friday, giving a talk there
  - rgdd: queued up decision on roadmap renewal
    - see decisions section below
  - rgdd: few MRs with updated log/witness things @ witness-network
    - now Google's CT logs are in withess-network.org
    - if someone has 100 qps witnesses, welcome to contact witness-network about that
  - rgdd: bunch of feedback and syncing (paper, AT, tlog-cosig, ...)
  - rgdd: about tlog-cosignature spec, the PR about that, it would be nice to write down why we are doing the things we are doing
      - filippo: adding a paragraph to tlog-checkpoint could be good
      - nisse: I don't know about using the new format for log signatures
        - filippo: that should be a paragraph in tlog-checkpoint
  - tta: not much progress (stalling on unrelated topics)
  - warpfork: not a ton (other nerdsnipes... ask me after)
    - still have https://hackmd.io/UfsG7EE3TXKp9QGuekUr0g?edit= draft for tlog.directory introductory site, slowly growing -- feedback requested
	    - there's a large new section on "Witnessing vs Monitoring", because I've seen that be a repeat confusion source... that when resolves, also makes people get way more hyped, so.
    - ... rediscovered i'd also done a previous more prose-y pass on an explainer: https://hackmd.io/93nYqgZqR3u6Bcj2rBglEA?both= -- feedback double requested
    - which of these approaches seem more useful?  (both, in separate pages...?)
    - contact warpfork via transparency dev slack
      - also, it's globally world writable
  - mw: I want to say something, but I have not really gotten started with things yet
    - getting onboarded currently
    - have read some code, the sigsum-c code
    - played around with the sign-if-logged app
    - florolf: you made a MR in sigsum-c, right?
      - mw: yes!
    - rgdd: earlier tta wrote notes about first impressions about sigsum
      - do that too if you like?
  - elias: about to start looking at parallell signing, but didn't get around to it yet. But interested in the stuff filippo mentioned above -- sounds good!

## Decisions

  - Decision: Adopt updated roadmap until mid June
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/142/diffs
    - the roadmap is mostly about continuing things we were diong before
    - nisse continues with tkey things
    - parallel signing
    - Glasklar high-availability witness group
    - PQ specification
    - The c2sp.org website
    - Metrics for log-go
    - Rust library for signing and submitting
    - Are there more things that should be added in the roadmap?
      - no
    - There is also a summary of what was done since last roadmap
    - rgdd: can we decide this?
      - yes, decided.

## Next steps

  - rgdd: will be taking to hayden this week to sync on possibly working together on future sigsum and rekor stuff
    - including PQ aspect
  - rgdd: look at tlog.directory (sorry for the delay)
    +tta: also want to take a look at tlog.directory later
  - nisse, elias: Talk and poster presentation at https://chains.proj.kth.se/software-supply-chain-workshop-5.html on Friday.
    - slides: https://git.glasklar.is/nisse/chains-2026/-/blob/main/slides.pdf
    - poster: https://git.glasklar.is/nisse/cysep-2025/-/blob/main/poster.pdf
  - warpfork: prometheus metrics in litewitness
    - how many instances are there of litewitness running?
      - glasklar
      - mullvad
      - tillitis
      - filippo: our plan (geomys) is to run litewitness on our second witness
      - several more also, several test witnesses
  - elias: parallel signing
  - filippo:
      - go 1.27 work
      - want to land tlog-cosignature spec
      - possibly look at tlog.directory
  - florolf: play with the sigsum-c shared library, integrate it somewhere
    - let nisse know if you run into issues
  - tta: would like to take a look at tlog.directory
  - tta: the archive transparency project starts in 5 weeks
    - have a todo-list related to that
  - mw: make a plan for what I should do

## Other

  - nisse: about PQ stuff:
    - it seems the lattice things are the most popular flavours
      - regarding classical attacks, is it based on some known problem that is hard?
        - filippo: yes, there is a hard problem that is hard both classically and PQ
          - it is a hypothesis in the same way as factorisation
