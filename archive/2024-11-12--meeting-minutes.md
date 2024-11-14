# Sigsum weekly

- Date: 2024-11-12 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- rgdd
- elias
- nisse

## Status round

- rgdd: litewitness ansible, see:
  - https://git.glasklar.is/sigsum/admin/ansible/-/merge_requests/40
  - rgdd.se/poc-witness is already deployed using the above MR (merged)
- rgdd: drafty sigsum/v2 notes, see:
  - https://pad.sigsum.org/p/19fe-e132-b60b-7a47-7839-c8b9-96e3-52c9 (do not
    persist yet, still being circulated)
  - comments and input wanted!
- rgdd: started thinking and typing up notes on the shared configuration (wip)
- rgdd: some review (e.g. nisse's proposals) and user/operator support
- nisse: prepared proposals and a bit of work on vkeys
- elias: trying to initialize myself
- nisse: collecting stats for aw devices now that al pushed some fixes

## Decisions

- Decision: Delete short checksum from proof's leaf line
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/90
  - (for today or next week)
  - we don't see any other smaller incremental changes
  - we might want to do larger change in the future, more "signed note like"
  - the interesting part of the change: the semantics, we no longer change the
    short checksum. We're basically dropping redundant bits from the proof.
  - we're not deferring the changes for this "v2", nisse will take a stab when
    he has free cycles. Nisse will create an issue to take a stab at this
    sometime in the future.
- Decision? Design of vkey conversion tools
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/89
  - Defer, take a stab based on the comments in the MR and decision next week

## Next steps

- rgdd: continue on shared configuration
- nisse: merge proposal and create issue; and update the vkey proposal
- elias: will take a look if i can get a poc witness up and running
- nisse: run the cosignature collect script on poc.so/jellyfish to compare stats
  for litewitness+litebastion

## Other

- Any update on backend connection expired?
  - https://github.com/FiloSottile/litetlog/issues/11
- Also seing a lot of "http: proxy error: http2: client conn not usable", does
  that need an issue in litetlog? Any potential fix for this?
- (The above two issues seems to lower availability, but more so for AWs than
  litewitness+litebastion?)
  - Can nisse run the same uptime monitoring on poc.so/jellyfish to see how my
    poc-witness behaves under the same lense?
  - nisse: long term doesn't work so well to run this script
  - rgdd: long term should have prom metrics for this kinda thing
  - nisse: maybe elias wants to fix prometrics?
- project/archive/2023-09-05-sigsum-processes.md
