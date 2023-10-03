# Sigsum weekly

  - Date: 2023-10-03 1215 UTC
  - Meet: https://meet.sigsum.org/sigsum
  - Chair: rgdd

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - rgdd
  - nisse
  - filippo
  - ln5
  - gregoire

## Status round

  - rgdd: releases proposal (below)
  - rgdd: following up on gregoire's test-vector request on best-effort level,
    wip to be added @ cctv as discussed before with filippo
    - https://github.com/rgdd/CCTV/tree/merkle
  - nisse: Think I've merged everything for removing cosignature version.
  - nisse: Updating log-go NEWS file
    - missing tag for witness and other tools
  - fiilippo: mostly gophercon, reviewed proposal; and interact in witness api
    mr.  And change get tree head to nisse's suggestion
  - ln5: order yubihsms+yubikeys for sigsum ops, here ~tomrrow; talking with
    nisse about embargo mailing lists with tlogs.  Hashes out some more details
    and writing it down, but it's cooking.

## Decisions

  - Decision: Adopt on-releases proposal
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/47

## Next steps

  - nisse: take a stab at the log-go RELEASES file
  - nisse: figure out what else needs to be done before release, and playing a
    bit more with the server package thing.  Post release work.
  - filippo: same things as the list two weeks ago - tagging repo, moving
    witness api forward, probably implementing it.
  - rgdd: checker peer, "yubihsm stuff", help move the witness proposal forward
    w/ feedback
  - linus: liberating logsrv hardware, let me know if there's anything we need

## Other

  - witness api proposal
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/46
    - continue discussing with a virtual walk, then add summary in MR thread
  - ops status: Can we have (test) witnesses up and running?
    - rgdd will check if litetlog is ready ot be tagged / try running that
    - nisse will run python witness on poc.sigsum.org, ask rgdd for help to
      configure poc log to recognize it
  - log.md, move towards decision v1? -> let's bring up for decision next week.
    - "what does it mean", fix one paragraph on this (rgdd).
