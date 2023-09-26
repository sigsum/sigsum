# Sigsum weekly

  - Date: 2023-09-26 1215 UTC
  - Meet: https://meet.sigsum.org/sigsum
  - Chair: rgdd

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - gregoire
  - linus
  - rgdd
  - nisse

## Status round

  - nisse: Merged deletion of cosignature version in sigsum-go. Will need a
    couple of additional MRs and tags to bring repos in sync.
  - rgdd, linus, nisse: drafty notes on key management with YubiHSMs
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2023-09-26-on-key-management.md
  - rgdd: drafty proposal on getting started with releases
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/47
    - (please read and comment, would like to work towards decision next week.)
  - rgdd: dropped the v1 label in witness.md per last week's decision, also some
    reviewing etc.
  - gregoire: filed typo wrt. rfc in sigsum-go

## Decisions

  - None

## Next steps

  - rgdd: review safefile stuff by nisse
    - https://git.glasklar.is/sigsum/dependencies/safefile/-/merge_requests/1
    - and any other MRs nisse assign related to the cosignature version stuff
  - rgdd: move release proposal towards decision next week
  - rgdd: let me know if i can unblock you, otherwise a slow sigsum week for me
    until next time (will mostly be busy with ST things the coming days).
  - nisse: fix the cosignature witness stuff, if time PR litetlog/witness
  - ln5: ordering stuff needed for key management, read release proposal
  - gregoire: talking/discussing use-case, and just starting to do a rust lib

## Other

  - Test vectors for inclusion proof, signatures, etc?
    - make check target in sigsum-go repo, has some things
    - could create test vectors with sigsum-go tools
    - uncommited stuff from rgdd exists on merkle trees, closest thing would
      otherwise b in rgdd's ct repo <<< rgdd
    - might have some unit tests in the Go repos (?)
  - Any of us looking at the open/unassigned tickets?
    - nisse: for MRs, we see it if a reviewer is assigned
    - linus: triage-like bot? something that spits things into irc/matrix?
    - gregoire: code owners file, does that exist for gitlab?  Automatic
      assigning.
