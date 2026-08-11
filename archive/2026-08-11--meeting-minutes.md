# Sigsum weekly

  - Date: 2026-08-11 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: rgdd
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - elias
  - rgdd
  - tta
  - Patrick
  - warpfork
  - gregoire

## Status round

  - tta: AT (Archive Transparency) update status
      - I now have 1.5TB of pdf & src files from ArXiv eprint 1991-2000 (included) on my hard drive \ô/
      - I'm in process to deploying a testing mirror (w/ in mind giving me space to play more w/ observers)
      - progress on clarifying how AT "root store" / policy would work has stalled (will resume later)
      - clarifying AT "identity issuers" stalled too, side-stepped it by having a temp "authorized-issuers" allow-list
      - haven't done much progress on writing down a refreshed primer on AT, current (stalled) work copy here:
          https://codeberg.org/openrip/project/src/branch/main/notes/2026-08-02-007-entry-point.md
          (last update: 6 days ago – not ready for review yet)
  - warpfork: have been looking at AT-proto and how tlogs could be used there
    - looks like it fits semantically very well
    - tlogs would apply well, and the volume is really low
    - high value and low scale
    - tailing live events, when people are doing identity-based operations, those are not that common
    - there are millions of users but not that many operations of that type
    - rgdd: perhaps you could write a blog post about that? I would love to read that!
      - like what you found so far, what the scaling numbers you got
      - warpfork: maybe in the future
  - patrick: chatted with tta about archive transparency
    - planning to submit proposal to transparency dev summit this week
  - elias: still doing things regarding witness group deployment
    - There is a drafty about page for the group now (still wip)
      - https://git.glasklar.is/glasklar/services/witnessing/-/blob/about-witness-g1/g1.witness.glasklar.is/about.md
    - SELinux enforced on all the machines
  - rgdd: have been helping out with glasklar witness group things
    - exporting metrics for that
    - also worked on transparency dev summit organizing

## Decisions

  - None
 
## Next steps

  - tta: try to up a « mirror.testing.archive.rip » this week & un-stall the stalled writing work
  - patrick: submission to transparency dev summit
  - elias: finalizing about page about the witness group
  - rgdd: MR for litewitness so that MLDSA keys can be used for logs
  - rgdd: getting witness metrics ready
  - rgdd: finalizing accept/reject emails for transparency dev summit
  - warpfork: considering standardization of attachement information relating to a log, things that don't have a standard yet
    - tta: maybe related https://github.com/florolf/windrow

## Other

  - elias: tag in the torchwood repository, could we get a new release soon?
    - eric will remind filippo
