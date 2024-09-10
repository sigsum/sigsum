# Sigsum weekly

- Date: 2024-09-10 1215 UTC
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
- nisse

## Status round

- rgdd: started to page in deployment of sigsum-agent (based on where ln5 left
  off)
  - https://git.glasklar.is/sigsum/admin/ansible/-/tree/yubishm?ref_type=heads
  - mostly reading up on socket activation and witrying it out on my local
    system
- rgdd: updating history.md before transparency-dev summit, poking relevant
  folks for input
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/85
- rgdd: notes on a possible "maintenance mode" for sigsum for the interested
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/86
- rgdd: prepared a roadmap based on our in-person discussions, see below
  - (was deferred from last week when most people weren't here -- including
    myself)
- nisse: Working on new checkpoint-based witness protocol. Plan: Make one huge
  wip MR to get the big picture, then split out reasonable sized pieces for
  review.
- nisse: Discussed tombstone mechanism with filippo. Main idea: When log is
  about to shut down, it signs a tombstone with intended final size of the log
  (which would be current size, or maybe current size - 1 if it is useful to
  also add tombstone to the log). The tombstone is submitted to witnesses for
  cosigning. Each cosignature is a commitment to not cosign anything beyond the
  stated final size. Then a monitor that has observed a tombstone cosigned by a
  quorum of witnesses, and has observed all leaves up to the log's final size,
  can safely forget about that log and stop monitoring it.
- nisse: ssh packages -- doesn't feel prioritized right now but would be nice to
  make progress on it sometime this fall.
  - Would like to make an ssh package in sigsum key management repo. That
    includes all ssh protocol and data format things. Used by sigsum-go, and
    which can also be used by ST (where ssh-agent / sigsum-agent is relevant).
  - Revisit when we renew roadmap, but would be nice to get fixed yes

## Decisions

- Decision: Adopt roadmap until the transparency-dev summit
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/84
  - Update the roadmap in the end of October
  - ln5 at matrix: "LGTM"

## Next steps

- rgdd: make progress on log operations
  - https://git.glasklar.is/glasklar/services/sigsum-logs/-/milestones/1#tab-issues
- nisse: will file an issue wrt. tombstone and any other notes/remarks he
  remembers
- nisse: will attend sec-t tomorrow
- nisse: witness impl i sigsum-go and log-go

## Other

- None
