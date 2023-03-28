# Sigsum weekly

  - Date: 2023-03-28 1215 UTC
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
  - rgdd
  - ln5

## Status round

  - rgdd: roadmap and milestine planning, drafty tl;dr:
    - roadmap is roughly the same as last time, will copy it with minor edits
    - tooling milestone will be done and replaced by a monitoring milestone
    - witness prototype milestone stays due to lack of progress, bumping
      expiration date by one month (same reponsibilities as before for nisse and
      filippo)
    - continued work on spec milestone, we need to prioritize the final witness
      changes so that we get a complete draft that we're happy with
  - rgdd: misc feedback on things
  - ln5: some ansible related testing and bug fixing
  - nisse: merge get-opt in sigsum tools, next usage messages; get-opt formats
    options, then have a text after that with more details is current plan.
    Working on client package (one interface to talk to primary log, one to chat
    with secondary, one to chat with witness).

## Decisions

  - Decision:  Use signed tree head blobs that are checkpoint compatible
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/30
    - Note: what is decided here is the encoding of the blob that logs sign
      (three lines), the decision to also update cosignature serialization is
      deferred.
    - Note: sigsum.org/v1/<key hash hex> is a namespace for sigsum logs, clarify
      that it is not expected that something should be returned if visting this.
    - Note: is there a risk that someone starts adding keys on these URLs?  We
      don't want to facilitate automatic fetching of keys.  Not a problem for
      sigsum though, because we can decide to not serve anything on the sigsum
      URL.

## Next steps

  - rgdd: create branch+MR to track updating of cosignature serialization
  - rgdd: plan milestone + roadmap docs for next week, proof-read announcement
  - rgdd: clarify that ball is @fox, and then when ln5 has approved, send email
    even if it is not tuesday)
  - ln5: waiting for a thumbs up from fox for when it's time to dog-food the
    ansible collection
  - nisse: polishing, wrapping up tooling milestones
  - nisse: merge and update specs based on the above decision

## Other

  - hosting stuff like pad.sigsum.org -> pad.glasklar.is?
    - yes, when ln5 has time; it is glasklar that operates services
      sigsum/st/...
  - request: support for multiple secondaries? when?
    - preliminary: after mid may, before summer vaccay?
    - rgdd will create a "DRAFT: " milestone
  - benchmarking
    - potential user that wants to use sigsum, 100 x 100M entries per year; in
      batch roughly twice per year.
      - Q1: throughput
      - Q2: latency
      - Q3: storage requirements
      - It would be good to have a tool, and/or documentation what can be
        expected.
      - rgdd will make a "DRAFT: " milestone so issues can be attached.
      - nisse creates issue on multiple leaf submissions efficiently
  - bullseye-backports is what our things should be targeted towards
  - move from docker -> podman post-release for ansible tests
