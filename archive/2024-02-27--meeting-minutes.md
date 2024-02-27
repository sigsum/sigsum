# Sigsum weekly

- Date: 2024-02-27 1215 UTC
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
- ln5
- gregoire

## Status round

- ln5: since we have been metioniong the funding applicaiton in brief (cra) --
  it might be worth mentioning that this is not happening.

## Decisions

- None

## Next steps

- rgdd: same as last week, i.e., feedback to gregoire and virtual walk with
  filippo
- ln5: same as the last two weeks, agent stuff. Rename the repo to sigsum-agent.
- gregoire: virtual walk with rgdd

## Other

- filippo mentioned on irc/matrix that chronicle could benefit from witnessing
  - https://github.com/paragonie/chronicle
- gregoire: agent-question, it talks to yubihsm? Is there somewhere documented
  how many yubihsms you need (to run a log)?
  - The answer depends on how quickly you want to be able to promote a secondary
    to a primary if the primary goes away.
  - And also on your requirements on the host that actually has access to the
    hsm device.
  - TL;DR: so many ways to configure.
  - Here's one way to do it though, which is not trying to optimize for the
    number of YubiHSMs:
    https://git.glasklar.is/sigsum/core/key-mgmt/-/blob/main/docs/key-management.md?ref_type=heads
  - One more thing to this: linus is setting up ansible role for running the
    different parts for doing this. In a way that gives some value even if you
    don't have the yubihsm. Because you move the key material to a separate
    agent process (that runs under another unix user). Isolation between network
    facing server and key material.
