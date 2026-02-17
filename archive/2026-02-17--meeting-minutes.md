# Sigsum weekly

- Date: 2026-02-17 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: florolf
- Secretary: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- rgdd
- florolf
- gregoire

## Status round

- <insert status report here>
- nisse: Created a milestone for sigsum-c 1.0
  - https://git.glasklar.is/sigsum/core/sigsum-c/-/milestones/1#tab-issues
- nisse: Have a first version if sign-if-logged + tkey app,
  - https://git.glasklar.is/sigsum/apps/sign-if-logged
  - https://git.glasklar.is/sigsum/apps/tkey-sign-if-logged
  - Having some repro-build issues with the tkey app.
- florolf: sigsum-breakglass updates in response to last week's discussion
  - https://github.com/florolf/sigsum-breakglass/pull/1
  - there's some discussion in matrix as well
  - this is mostly a poc / wanted to throw something out there
  - if in the end it makes more sense to just run your own sigsum log -> happy
    if that's the outcome
  - will continue discussing with folks on matrix
  - florolf will try to summarize what the outcome of the discussion
- rgdd: Planning to do a ST/Sigsum community meetup in Stockholm
  - There is a date now: 2026-05-05 (Tue) to -07 (Thu)
  - Reach out to Glasklar/rgdd if you want to attend
- rgdd: Redeployed my witness using the latest Ansible version, Torchwood
  version 0.9.0
  - Everything seems to work now with per-log-bastion
  - Talk to rgdd if you want help with setting that up

## Decisions

- None

## Next steps

- rgdd: still look at tta's archive stuff, and the above breakglass stuff
- rgdd: update my sshdt poc to use $main of things + named policy
  - https://git.glasklar.is/rgdd/sshdt
  - florolf has been thinking about this demo recently
  - thinking about doing something similar
  - basically want some kind of audit logs if someone logs in
  - planning to try this with sigsum-c
  - (it's a soon-ish thing from florolf, not necessarily this week)
- florolf: interact more with the breakglass stuff in matrix

## Other

- rgdd: ack from florolf that it's ok to be mentioned in history.md?
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/133/diffs
  - florolf: ack!
- rgdd: fyi: merlke tree certs is at draft -10
  - Call for adoption: draft-davidben-tls-merkle-tree-certs-10 (Ends 2026-02-18)
  - https://datatracker.ietf.org/doc/html/draft-davidben-tls-merkle-tree-certs-10
