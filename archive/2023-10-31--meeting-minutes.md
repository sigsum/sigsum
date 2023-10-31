# Sigsum weekly

- Date: 2023-10-31 1215 UTC
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

## Status round

- rgdd: progressed on YubiHSM stuff and got feedback from nisse
  - https://git.glasklar.is/rgdd/yubihsm
  - minor annoyance (but opportunity to contribute in the future): ssh-agent
    doesn't support pkcs#11 3.0 which seems to be adding Ed25519. YubiHSM has a
    branch for this.
  - https://git.glasklar.is/sigsum/core/log-go/-/issues/72
  - (filippo ok with both options, main question is what ops folks prefer.)
- rgdd: picked-up milestone planning this morning, and as part of that tried to
  resolve one of the open issues to figure out what documentation we're missing:
  - https://git.glasklar.is/sigsum/project/documentation/-/issues/40
  - any input on this would be very welcome
- filippo: litetlog docs https://github.com/FiloSottile/litetlog#litetlog
- filippo: litetlog multiple bastions
  https://github.com/FiloSottile/litetlog/issues/3
- filippo: didn't get around to the c2sp spec, and talking to some folks about
  what they are doing right now wrt tlogs

## Decisions

- Decision: Transition log.md into state "version 1"
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/log.md
  - https://git.glasklar.is/sigsum/project/documentation/#releases
  - (async thumbs-up from nisse and linus)

## Next steps

- rgdd: circulate roadmap proposal
- rgdd: address nisse's minor yubihsm comments and get that wrapped up
  - (a bit unsure where to put what's currently in rgdd/yubihsm)
  - (will not move anything anywhere until nisse is back next monday)
- filippo: C2SP spec of signed note, cosignatures, witness, bastion
  - goal: good enough state to circulate to trustfabric folks 1w before cats,
    where we will be meeting them in person

## Other

- rgdd would like to look at the two remaining milestones that we need to close
  - https://git.glasklar.is/groups/sigsum/-/milestones/14#tab-issues
  - https://git.glasklar.is/groups/sigsum/-/milestones/12#tab-issues
  - close bastion.md, rephrase witness.md to be for the proposal and move the
    rest into next docdoc milestone. Main open question about bastion.md is
    whether it should be the same key or a different key; it is fine to share it
    as we have domain separation, but if there are possibly other sig types in
    the future it would be akward if the bastion key has to be coupled to the
    witness key. Filippo will think a bit more about this, but currently leans
    towards separate keys.
