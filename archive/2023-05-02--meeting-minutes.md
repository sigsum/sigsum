# Sigsum weekly

  - Date: 2023-05-02 1215 UTC
  - Meet: https://meet.sigsum.org/sigsum
  - Chair: rgdd (nisse as backup)

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - rgdd (will have to drop-out ~1230 UTC)
  - filippo
  - foxboron
  - nisse

## Status round

  - rgdd: had a bit of a bump with ghost shrimp secondary, it's running again
    but need to look further into the cause
  - filippo: finalized cosignature proposal
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/32
  - filippo: sent PR to Trillian to implement cosignature/v1 and scheduled call
    - https://github.com/transparency-dev/witness/pull/41
  - filippo: reviewed nisse's domain separation MR and test-agent (nice!)
  - nisse: Implemented and merged new namespacing.
  - nisse: Merged first iteration of monitoring.
  - nisse: Log-side of witness protocol still in review
    - https://git.glasklar.is/sigsum/core/log-go/-/merge_requests/99
    - filippo will review this week
  - fox: Review code
  - fox: continue some mock test case work

## Decisions

  - Decision: cosignature/v1 format proposal (with standing option to include
    Sigsum-irrelevant extension lines if there's documented pushback from the
    Trillian side)
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/32 

## Next steps

  - rgdd: redeploy website, check ghost shrimp, take a more detailed look at
    nisses tooling/monitor things to provide feedback and start planning next
    steps, provide feedback on proposals on a need-basis
    - will be here most of Thursday if you need/want my attention
  - filippo: finish witness prototype
  - filippo: witness protocol proposal
  - filippo: land consensus on Trillian side
  - nisse: implement new cosignature format
  - nisse: look into batching for both sigsum-submit and monitoring

## Other

  - None
