# Sigsum weekly

  - Date: 2023-06-20 1215 UTC
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
  - foxboron
  - filippo

## Status round

  - rgdd: took updated lite{bastion,witness} and poc python witness for a spin
  - rgdd: minor updates to milestones, based on where we're at now before vaccay
    - https://git.glasklar.is/groups/sigsum/-/milestones
    - Closed "Misc backlog fixes"
    - Closed "Logs poll witnesses for cosignatures"
    - To be closed this week: "Bump protocol version to v1 (rc-1)"
    - Remains ongoing until end of August: "Iterate on libraries and tooling"
    - Toggled "Health of log-go-{primary,secondary}" back into "DRAFT: ", backlogged.
  - nisse
    - Python witness updated to act as a server (via flask package).
    - Added batch inclusion proof verification to monitor.
    - Added command line interface for batch submission to sigsum-submit; actual
      processing still completely serial though.
    - Soon on vacation, will see some of you at PETS.
  - filippo: got some questions from trillian folks regarding timestamps
  - foxboron: poked linus about ansible things, still backlogged

## Decisions

  - Decision: adopt cosignature version proposal
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/36
  - Decision: consider log.md, witness.md, and bastion.md in state "rc-1"
    - Update "Warning: " disclaimers in .md docs to say release candidates or similar
    - Q (nisse): Should rate limit label stay as "_sigsum_v0" for now?
      - Current status of doc at the top, "rc1"
      - DNS label is the only v0 left?  Let's fix.
    - As soon as witness.md is updated we should shoot an email to
      sigsum-general; no need to wait for us polishing the presentation of these
      documents before doing so.
      - Email suggestions: https://pad.sigsum.org/p/bf74-ed94-aa96-dd26

## Next steps

  - nisse: create issue for multiple lines (implemting above proposal), already have an MR for the version addition
  - nisse: wrapping and then vaccay
  - filippo: update witness.md, will take a pass over the entire thing as well; assign rgdd as reviewer.
  - filippo: update all version from 0 to 1 in specs, say "rc-1" at the top
  - filippo: talking to trillian folks, looking at things for adding to cctv
  - rgdd: take a pass on log.md, review from filippo; some planning of the fall
  - foxboron: sync with linus regarding updates of ansible

## Other

  - None
