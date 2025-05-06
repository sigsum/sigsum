# Sigsum weekly

- Date: 2025-05-06 1215 UTC
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
- filippo

## Status round

- elias: decommissioned old test log jellyfish, replaced by new test log
  barreleye
  - filippo you were witnessing jellyfish, can you change to barreleye?
  - filippo will fix this, yes
- elias: updated https://www.sigsum.org/services/
  - there you can read about barreleye now
  - added also a section on that page called "historic logs", i.e., mentioning
    that jellyfish is a once upon a time thing now. Suggested by nisse, thanks.
- elias: released sigsum ansible v1.3.0
  - https://git.glasklar.is/sigsum/admin/ansible
  - nisse: announce email?
  - have not been a process so far, but elias will think about adding it in the
    HACKING process
- rgdd: in ~3 weeks from now our sigsum roadmap is due for an update. Please
  take a look at what we said we would do and let me know what you expect to be
  done with, what's in progress but needs more time/work, and what's totally
  backlogged.
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2025-02-04-roadmap.md
- rgdd: and also please send me a message (or reach out in any other way you see
  fit) with what you think should you should be working on in the upcoming
  roadmap.
  - I'm thinking we will renew again next time end of august, so post holidays
    and with 1-2 months until tdev summit is happening
- rgdd: speaking of tdev summit, please share and fill out the interest survey
  if you haven't already
  - https://blog.transparency.dev/announcing-transparencydev-summit-2025
  - https://docs.google.com/forms/d/e/1FAIpQLSfabrC4JnWQCKGjPuHg4-kAua6Fe9wc0259IEn0pLTW1vAeOQ/viewform
- rgdd: sketching/dumping public witness network (aka shared configuration)
  things into a wip repository that we'll move somewhere else eventually
  - https://git.glasklar.is/rgdd/public-witness-network
  - minor suggestion: instead of sequence number of whole list, instead have
    date and time in some specific format?
  - to replace or complement?
  - complement.
  - sounds like a good idea
- nisse: updated ST tests to use the new barreleye log, had some discussions
  also on what different kinds of test logs we want to operate.
  - Gist of the discussion?
  - may be useful to have logs others can use for their interop rtests / ci
    pipelines etc. That isn't seasalp log.
  - another point raised by linus: for case of ci tests, it would be nice to
    have an easy way to spin up your own thing (epehemral log + witnesses). So
    tests don't depend on someone elses service
- filippo: mostly been doing web pki stuff, productizing ct log.

## Decisions

- None

## Next steps

- rgdd: more public witness network / shared config things. Something like:
  - go through notes and see what i forgot, so far mostly from memory
  - complete few TODOs/placeholder
  - make a pass to see what doesn't make sense, identify open questions / tricky
    things (if any)
  - bounce one more time with kfs, then bounce more with $youall
  - (i might want to note down a few design remarks that are important)
- rgdd: look at vkey docdoc, sorry for the delay
  - https://github.com/C2SP/C2SP/pull/119/files
- rgdd: some tdev summit stuff
- elias: consider sigsum ansible release announcement
- elias: debug https://git.glasklar.is/sigsum/admin/ansible/-/issues/71
- nisse, elias, filippo: input to roadmap, see above
- filippo: web pki, and updating my witness
- filippo: make vkey edits based on feedback from nisse (but filippo agrees what
  what nisse suggested)

## Other

- fyi: auk who put together a
  [python wrapper for the sigsum-go cli tools](https://github.com/tabbyrobin/py-sigsum-tools-wrapper)
  is hacking on an internet-archive like service for artifact checksums. The
  core property is to make timestamped observations about what checksum the
  service computed when downloading an artifact via URL, and the initial idea
  seems to be to support >1 such archiving services so that clients can
  configure m-of-n verification as an upfront proactive check. What a tlog adds
  here is: make it more difficult to undo previous observations. Some related
  work that auk mentioned on matrix:
  - https://github.com/mkmik/getsum -- does not allow changes
  - https://github.com/asfaload/asfald -- operates as an "authoritative" single
    source of truth
  - https://github.com/rootkovska/codehash.db -- interesting but underspecified
    and never implemented
