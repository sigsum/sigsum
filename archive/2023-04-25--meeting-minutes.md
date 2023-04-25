# Sigsum weekly

  - Date: 2023-04-25 1215 UTC
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
  - Foxboron
  - filippo

## Status round

  - rgdd: discuss proposals with nisse, provide feedback on tooling docs
  - nisse: Meetup last week. Log-side of new witness protocol in review, see
    https://git.glasklar.is/sigsum/core/log-go/-/merge_requests/99. Tool docs in
    review: https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/100.
    - (witness stuff is for log server to query witness for cosignatures)
  - nisse: drafty MR on monitoring package and cli tool
  - filippo: reached out to Trillian about log identity
	  - https://github.com/transparency-dev/formats/issues/22
  - filippo: discussed proposals
	  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/32
	  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/33
  - foxboron: review of nisse's work, a bit distracted with st stuff

## Decisions

  - Decision: Move next planning meeting from 2023-05-02 to 2023-05-16
    - (ln5 will be back then, and rgdd is quite busy until 2nd May)
  - Decision: Stop using ssh signature format
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/proposals/2023-04-no-ssh-signature-format.md
    - https://git.glasklar.is/sigsum/project/documentation/-/issues/30
    - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/109


## Next steps

  - rgdd: sync with Foxboron about TODOs
  - rgdd: provide more proposal feedback on a need-basis
  - foxboron: review witness and monitor stuff from nisse (is waiting for a poke)
  - filippo: check nisse's witness MR too
  - filippo: align Trillian on cosignatures
  - filippo: update cosignature proposal
  - filippo: witness prototype
  - nisse: continued witness stuff, and talk proposals on a need basis

## Other

  - Key storage for witness: ssh-agent?
    - start by only supporting ssh-agent (to nudge towards not plaintext key on disk)
  - Which blob is cosigned and why
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/32
    - opens?
    - signing or not signing extension lines?
    - exact syntax of first line? (nisse suggests with a slash), sounds good.
    - mutilple cosignatures? that's about api, not for today (defer)
    - second line say "time <number>", otherwise if you look at it it could
      parse as a tree head of log with origin line...
    - specify what the meaning of the timestamp is, defined as "at time t, the
      largest tree i have seen from this log is...").  All of us seem to agree
      on this framing.
    - no extension line -> not so much a compatibility issue, we will still be
      able to be witnessed.  But not the other way around if we disagree on
      extension lines
    - semantics of v1 signature -> don't verify extension lines
    - question is whether we think there are usecase for signing extension lines
      blindly, or if we think that is never the case and it will lead to
      confusion and/or encourage mis-use
      - rgdd: it is easy to come up with examples that are flawed / confusing,
        can anyone provide a counter-example that is not flawed?  And, what are
        the main concerns of not cosigning the extension lines if we all anyway
        agree on the semantics of a v1 signature?  It sounds like the discussion
        (of extensibility) should be about how the path towards a potential v2
        signature looks, rather than leaving uninformed "maybe this could be
        useful" things in the format.
    - filippo will get their view on why cosign extension lines, then align on
      either not cosigning them (motivation: see semantics of a v1 signature and
      potential mis-use/mis-understanding that it opens up for) or cosign them
      (with a clear motivation of why, or in worst case, still do it and clearly
      state "pls don't do X because Y...")
    - nisse: interop -> test vector would be great, filippo will fix this
  - Integration tests: Can we move logs and other files to a  local dir (rather
    than randomly named under /tmp), and pick it up by ci system? See
    https://git.glasklar.is/sigsum/core/log-go/-/merge_requests/128, where one
    can download logs from the pipeline runs (for some reason, one can't open
    them directly in the browser, though).
    - sounds good, putting in /tmp just happened (no deep discussion around
      that)
