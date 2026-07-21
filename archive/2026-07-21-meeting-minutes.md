# Sigsum weekly

  - Date: 2026-07-21 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: gregoire
  - Secretary: mw

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - mw
  - gregoire
  - warpfork
  - patrick
  - justin
  - filippo

## Status round

  - warpfork: in summer mode

  - filippo: Working on a design for API:s for making transparent maps "on top"
    of transparency logs. Will improve performance for monitors querying
    for specific domains by supporting reverse lookups. Basis for a stable
    verifyable index. It's on c2sp.
    - an implementation: https://github.com/transparency-dev/incubator/tree/main/vindex
    - It's the very bottom of the stack, turning a bunch of key/value's into a
      verifiable index. The smallest building block, sparse merkle trees,
      patricia trees (merkle trees with the patricia optimization), the
      inner nodes doesn't carry the key which reduces by half the number of
      nodes(?). 50k insertions/sec, pretty fast, useful/needed when rebuilding
      logs.
    - making this independent of tlogs(!), just "pairs with, very very nicely".

## Decisions

  - no decisions

## Next steps

  - martin: finishing up selinux on debian
  - patrick: talk proposal for tds.
  - warpfork: talk proposal for tds.
  - filippo: talk proposal for tds.
  - gregoire: going on vacation next week, away for two.
  

## Other

  - no.
