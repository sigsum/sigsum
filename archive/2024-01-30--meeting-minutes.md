# Sigsum weekly

- Date: 2023-01-30 1215 UTC
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

- rgdd: put together the below roadmap proposal; not much else to report, have
  been conversating and answering questions on irc/matrix
- nisse: Fixed minor issue with 32-bit builds of sigsum-go, see
  https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/70
- filippo: not much to report this week, but submitted to have talk in real
  world crypto a while ago. And it was accepted! So have a talk on modern
  transparency logs at real world crypto. Abstract is basically "spicy
  signatures", "offline verifiable proofs", "titles if you need to", "serverless
  logs", "sigsum" -- different from the cats talk because it assumed you all
  know about tlogs. Whereas this one is more like "you probably heard about ct.
  But let me tell you, you can use that in many other ways too. Here's how we
  think about it. ANd how you can think about it too".
  - 20m talk
  - dont have an outline yet
  - if you have ideas -- please send over
  - otherwise i'll send you my initial ideas when i have them
  - (also attending real world pq, just before the main conference. And also
    open source cryptoyraphy. Where there will be a sess on cctv.)
  - will probably try to bring one type of poc for both server (sigsum) and
    serverless log (tbd)

## Decisions

- Decision: Cancel weekly on 2024-02-06
  - Most of us are at an in-person event and won't be able to attend
- Decision: Adopt updated roadmap
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2024-01-30-roadmap.md?ref_type=heads
  - To be renewed: 2024-04-02

## Next steps

- rgdd: none, but poke me if you need any input from me
- nisse: none
- filippo: same as last week, and start think about the talk

## Other

- monitoring client for both ct tiled logs and how that generalized to any tiled
  log
  - fundamental ask from a log as a client?
  - i have a cert, i want to know if it is included
  - i want to iterate all the certs (or all the certs from index n)
