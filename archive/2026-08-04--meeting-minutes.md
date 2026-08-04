# Sigsum weekly

- Date: 2026-08-04 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: rgdd
- Secretary: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- rgdd
- tta

## Status round

- tta: now working on a new set of notes for AT with the goal of:
  - having an "entry point" to people new to the project
  - talking about trust and trying to define participants, their relations, etc
    https://codeberg.org/openrip/project/src/branch/main/notes/2026-08-02-007-entry-point.md
- tta: have a "root store" problem, and an "identity issuer" problem
  - the two next parts
  - root store: policy inside the tool; cryptographic identity of some parties
    configured inside (web PKI style in some ways). How do we do that properly,
    and how do we update it. And how do we keep this information alive. 'What
    will be left to be audited in 5-10 years'.
  - identity issuance: want to enable people to stake their repitation, some
    binding between real world entity/institution and cryptographic identity.
    - domain validation i PKI (in some degree sigsum, even tho outside of
      sigsum's model)
    - tta needs something in plaintext 'i claim to be that person'
    - current solution is doing some kind of email validation and signing
- rgdd: TDS chair work
  - been away for some time, now back, circling reviews & sending acceptance
    mails soon

## Decisions

- None

## Next steps

- rgdd: draft an about page for glasklar's witness-g1 group
- rgdd: continuous export of metrics for glasklar's witness-g1 group
- rgdd: add sigsum's signing context in WIP leaf format w/ hayden et al
- tta: writing more notes
- tta: refactor the code to make it human-editable

## Other

- C2SP has a new website! https://c2sp.org/
- question: is time of witnesses reliable?
  - yes, that's the intended semantics (see tlog-cosignature)
