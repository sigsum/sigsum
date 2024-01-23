# Sigsum weekly

- Date: 2023-01-23 1215 UTC
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

- rgdd: jas showed up on irc/matrix and is (i) packaging sigsum-go for debian,
  and (ii) trying our tools again now that things are more stable. Some links:
  - https://bugs.debian.org/1061153
  - https://gitlab.com/debdistutils/debdistcanary/-/blob/main/debdistsigsum
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/69
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/70
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/71
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/72
- rgdd: initial roadmap thoughts that i'll write down until next week, eyeing a
  2 month period -- so next renewal 2024-04-02
- nisse: looking into 32-bit issues (issue 70 above).
- nisse: restarted poc witness. currently this isn't started automatically at
  boot.
- ln5: my update is that jellyfish is closer to be using a key in a yubihsm but
  not really yet.
- filippo: move forward process with c2sp (things are approved now, we have the
  PRs merged, codeowners file, etc), but unfortunately not much progress on the
  actual specs (many other things are being wrapped up at the same time).

## Decisions

- None

## Next steps

- rgdd: prepare and circulate roadmap proposal
- nisse: none
- filippo: sync with trustfabric folks on who they wanna assign as maintainer on
  specs; get the intial draft on in our repo and then push to c2sp and ensure
  everyone's onboard there.

## Other

- any roadmap input?
  - filippo: logsrv that implements new witness spec would be very helpful once
    it is available
  - filippo: reviews on specs when they're out, and rubberducking in general
  - nisse: log up and running in prod setting rather important, but not for the
    next 8w.
  - rgdd: batch submit?
    - nisse: a bit nontrivial hacking, but not that big. What's kinda difficult:
      define a nice API (as in library API). Current lib only one submit per
      time. Fix, maybe 1-2 weeks?
    - rgdd: then out of scope for the next roadmap when you and i are on lower
      bandwidth than usual
- rgdd: checker job for witness, very quick.
- rgdd: man pages?
  - let's see if we learn anything when figuring out similar things in ST the
    coming weeks, and also if we can piggy-back on what jas started putting
    together
- any other issues we consider higher priority for things to run smoothly? E.g.,
  - https://git.glasklar.is/glasklar/services/sigsum-logs/-/issues/9
  - https://git.glasklar.is/glasklar/services/sigsum-logs/-/issues/8
  - https://git.glasklar.is/glasklar/services/sigsum-logs/-/issues/7
  - (not discussed, but the bastion might be a reasonable and quick one; makes
    it a lot easier to spin up a prototype witness)
