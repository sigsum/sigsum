# Sigsum weekly

- Date: 2024-03-12 1215 UTC
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

## Status round

- rgdd: not much to report, just sync and review with filippo
- filippo: productive week, c2sp MRs in. Applied c2sp code owners based on what
  the trustfabric folks said, and added them to the repos. MRed witness.md into
  sigsum repo, not a polish run just update content. Will do the polish when
  moving to c2sp. And published the sunlight spec at c2sp, about to be
  announced. And been thinking about rwc talk, still thining about outline.
- nisse: looking into reusing sigsum ssh-agent tools for ST (medium term plan:
  move to an exported ssh package in the sigsum.org/key-mgmt repo)

## Decisions

- None

## Next steps

- rgdd: review filippo's witness MR
- nisse: at some point implement the new witness things, but not in the next two
  weeks.
- filippo: PR witness spec into c2sp, and resolve review comments from al and
  rgdd in the open c2sp PRs. Writing up meta stuff about c2sp (contributing
  policy, releases, etc -- i.e., the things we need to be able to tag release).
  This week will also experiment with the debian prototype, and start outlining
  the talk in more detail. Something to pass as a message: two catefories of
  things we're saying. 1) requirements that you're log needs to follow to be
  part of the witness ecosystem to access it -- to be witness:able. This is hard
  requirement, otherwise you need your own witness system. 2) recommendation to
  run a modern tlog, things like 'spicy signatures'. Things like cosignature
  format.

## Other

- Go subdb monitor, someone built it before filippo! Yay!
  - https://www.gopherwatch.org/
- https://gitlab.torproject.org/rgdd/silent-ct if filippo wanted a link to the
  silent ct stuff
