# Sigsum weekly

  - Date: 2023-05-16 1215 UTC
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
  - filippo
  - ln5
  - Foxboron
  - nisse

## Status round

  - rgdd: finalized and communicated roadmap/milestoens (see proposed decision below)
  - filippo: https://github.com/FiloSottile/litetlog
     - litewitness: a simple witness with bastion support
     - witnessctl: a CLI to interact with the witness db
     - litebastion: the bastion from mostly-harmless, with minor config changes
     - cmd/litewitness/testdata: testscript + Hurl tests
  - filippo: witness race warning MR
     - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/40
  - filippo: updated cosignature version MR
     - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/36
  - filippo: cleaned up sigsum-go/pkg/ascii
     - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/121
  - nisse:
     - Been working on Python witness, halfway there but want to refactor it
       before turning it into a server. Will be using flask for an HTTP server.
  - ln5: Nothing to report.
  - Foxboron: Nothing to report.

## Decisions

  - Decision: Adopt next roadmap and associated milestones
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/37
  - Decision: Next update of the roadmap on 2023-09-05
    - (Context: this is post-vacation for many of us.  If you are working during
      the summer and need to plan/coordinate before then please poke rgdd.)

## Next steps

  - rgdd: page-in tillitis
  - rgdd: try setup witness+bastion
  - rggd: review nisse's log.md draft
  - rgdd: review the cosignature version proposal
  - filippo: fixing the signing in litewitness, adding metrics, adding docs,
    pinging the trillian folks again, land sigsum MR's
  - nisse: python witness
  - nisse: review cosignature version
  - Foxboron: reviewing
  - ln5: none

## Other

  - retrospective: notes below
  - cosignature proposal
    - Polish for next week
    - We agree on the version field in the protocol.
    - Return multiple cosignatures from the tree head? yes/no?
      - Seems like we agree on "yes"
    - Need a new round on the wording of the proposal
  - log.md
    - Nisse will polish

### Brief team retrospective

One question at a time, round-table.  There will be no public notes, and it's OK
to say pass if a question is n/a or you have nothing more to add.

  - Is it clear what you're working on until the next planning meet?
  - Is it clear what the project works towards the coming 6 months?
  - Is it somewhat clear what the project may be working towards after that?
  - Is someone available to provide input to your work in a timely manner,
    i.e., is the feedback cycle short enough?  E.g., wrt. code review,
    discussion of proposals, or anything else that you're doing in the project?
  - Is there anything that I could do to make your working situation better?
