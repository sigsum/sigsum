# Sigsum weekly

  - Date: 2023-09-19 1215 UTC
  - Meet: https://meet.sigsum.org/sigsum
  - Chair: rgdd

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - nisse
  - ln5
  - filippo
  - gregoire

## Status round

  - rgdd: reading and thinking about YubiHSM $stuff, and trying to help move the
    open questions related to witnessing forward.  Oh, and started typing stuff
    about releases with input from nisse, not ready to be a final proposal yet
    (!47)
    - nisse: Doc update in review,
      https://git.glasklar.is/sigsum/core/log-go/-/merge_requests/146
    - nisse: Forked safefile, to add a CommitIfNotExists method, for use in
      log-go. See
      https://git.glasklar.is/sigsum/dependencies/safefile/-/merge_requests/
 - filippo: final touches to bastion API.  Updated the witness proposal, and
   responded to a couple of open things where poked.  And uploaded cats
   abstract.
   - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/46
   - https://pkg.go.dev/filippo.io/litetlog@v0.0.0-20230914154011-18cd17e869aa/bastion
   - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2023-08-30-cats-filippo-abstract.md?ref_type=heads
- ln5: nothing interesting to report
- gregoire: interested to look at a usecase of sigsum sometime soon

## Decisions

  - Decision: Drop cosignature version as interim state
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/48
		  See also https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/169
		
## Next steps

  - nisse, filippo: update go and python witness to drop v1
  - nisse: sort out what we do abouit the release and operations
  - rgdd: same as nisse, and help with feedback for the witnessing stuff
  - filippo: one last change to witness impl (multiple bastions), focus on
    witness proposal; then when decided want to do a C2SP-spec for note and
    (co)signatures.  Then another round of talking with the trillian folks.
    Heads-up: at gophercon next week.
  - ln5: working with rgdd and nisse in person wed+thu

## Other

  - Witness proposal
    - Continue async
