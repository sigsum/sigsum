# Sigsum weekly

  - Date: 2023-05-09 1215 UTC
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
  - filippo
  - nisse

## Status round

  - rgdd: roadmap/milestone planning
    - tl;dr: roadmap looks the same, we're just a bit further along and need to
      renew the next concrete milestones
    - will take some input from nisse later today, then poke you all async to
      see the final draft before next week's sync+retro session
  - filippo: updated witness.md
      - mistakenly pushed to main, please retroactively review (and maybe
        disable pushes to main?)
      - https://git.glasklar.is/sigsum/project/documentation/-/commit/eeee1e95c0ff76a388ae77c6b8cf57fe5e246e97
      - (nisse already checked, looked good)
  - filippo: cosignature version and API proposal
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/36
  - filippo: progress prototyping witness, reviewed MR
  - nisse: merged witness client in log, need to fix http status codes; about to
    merge unit tests related to this
  - foxboron: code review

## Decisions

  - None

## Next steps

  - rgdd: finalize milestone/roadmpa planning until next week and circulate
  - nisse: more iteration on witness in log-go, and work on witness things
  - foxboron: more review of nisse's stuff
  - filippo: add implementation caveat about witness state, and maybe about
    bastion logging
  - filippo: finnish witness+bastion prototypes

## Other

  - nisse: I'd like to discuss "abstract" api interfaces,
    https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/34, and server
    package which could be the first usecase,
    https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/119
   - defer this until we have more metrics in-place, also flesh out if it helps
     us with testing etc in some more detail.  Likely a good idea though, let's
     revisit later.
  - filippo: planning to use https://hurl.dev/ for cross-implementation witness
    tests
    - test vectors
    - dev environments
    - cool if multiple implementations of same protocol
    - (after we see how this turns out for the witness, we can consider doing
      the same for log-go)
  - rgdd: would like to chat a few more minutes about filippo's reports last
    week
