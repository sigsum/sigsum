# Sigsum weekly

- Date: 2024-03-19 1215 UTC
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
- nisse

## Status round

- filippo: launched sunlight. sunlight.dev has all the details.
  - Went great, and lots of interest. Both for CT and possibly non-CT. Good
    interest generator entrypoint.
  - A few things surfaced thx to this.
    - bluesky folks would like to have a tlog of the plc identities,
      cryptographic identities you can use on bluesky although not a lot of ppl
      use it. But they would like a tlog for that tree they have authority over.
    - Chad Loder
      https://bsky.app/profile/chadloder.bsky.social/post/3kno7bxpxd223
    - https://github.com/cleverbase/scal3, patented though.
    - not great fits for sunlight, but it is for what we are doing.
- filippo: retrospective with fredrik, talked a bit about latest happenings,
  rwc, etc.
- filippo: tlog specs have landed
  - nisse: does it include tiles?
  - filippo: no, but tiles is described as part of the sunlight spec because
    they needed to be described. I am interested in making it into its own spec
    at some point and refernece it from sunlight. Google folks also would like
    that.
- filippo: witness spec is merged in sigsum repo, working on the c2sp version
  now and expect to have it ~today.
- filippo: made the debian prototype
  - https://github.com/FiloSottile/litetlog/blob/main/cmd/spicy CLI tool,
    prototype
  - https://github.com/FiloSottile/litetlog/blob/main/cmd/apt-transport-tlog
    - can run it today
- filippo: putting together notes for rwc slides and outline, deadline tomorrow

## Decisions

- None

## Next steps

- filippo: witness.md into c2sp, prepare talk
- filippo: c2sp spec for spicy signature is of interest
  - if work on this before april meet-up, rubberduck with nisse
  - (doesn't need this before rwc)

## Other

- https://github.com/rgdd/CCTV/tree/merkle/merkle
- https://blog.josefsson.org/2024/03/18/apt-archive-mirrors-in-git-lfs/
- https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/sigsum-proof.md

### Copy-paste filippo's current spicy signature format

Parser:
https://github.com/FiloSottile/litetlog/blob/d246ff9a0973a8d52b044f9b44d657babe084f23/cmd/spicy/spicy.go#L47-L82

```
index 231
sfjxvl6rIfw0yTdjSijfAFx0dd79U1yzq7MykoTHXa0=
u7ED51vnXiG2Cac/mtEOe7l985Vjvb/CGIosROvcWm0=
oRkYduPgij1PstulJQniEtMkC47LxUTmxEJrmHQchX4=
CLUu3QscQvnF7f/orkLYw1QLUSK7Dg27IkaF2+2cyIw=
mu2la4+ScBb2R21TS0k6vWoEXw+O3fkWVFKThRsCqCA=
zRovMEcwOsL7WF51figbxWf7e3KvUL7SwZxiblnoaBk=
oY64vvVP2ONVnj1SRMnV7+htaDO2WRti8zotjzBd/gk=
1Rt6zMBb4s3GeQ+ZT81LEthPf1zRRB1qQUwV3/BVkAA=

filippo.io/debian-archive
250
yhw1mXGIJ9psQEPUm9zmmlgA4OHoylDokNaOZMJBuwI=

— filippo.io/debian-archive bGG3C2XlpntvPMeGZtlczFuA8UNDHwgleOwso13tvhz1kmZ+f1xTGJRSylTGP7DNUWpS63/xojl+cAVCoYZFysxKZQk=
```

syntatic difference between log signature and cosignature? /nisse

- filippo thinks it would be hard without breaking the note format
- could add prefix maybe in the name, but would like to encourage agonistic view
  of the note verify function. "Here are the keys i know".

nisse: not sure if it is important, but it is a difference compared to the
current sigsum format.

64-byte vs 72b is a difference, but not great to depend on though.

Two possible variations:

- 2x checkpoint for timestamp (window when logging happened)
- binary, not detached

nisse: note that there's verification steps in the sigsum proof docs.

nisse: another difference in sigsum proof: It includes the leaf signature and
keyhash.
