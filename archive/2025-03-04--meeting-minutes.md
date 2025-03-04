# Sigsum weekly

- Date: 2025-03-04 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- rgdd
- elias
- ln5
- filippo
- nisse

## Status round

- elias: working on Sigsum ansible v1.3.0 milestone
  - https://git.glasklar.is/groups/sigsum/-/milestones/20
- nisse: Commented on named policies / trust policy stuff
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/51
- rgdd: merged more efficient batch submit (sigsum-go!227)
  - files issue with varying difficulty degrees of follow-up things that could
    be done
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/104
  - (i don't intend to do more things here right now)
- rgdd: synced with nisse on the improved usage message stuff, will be taking a
  stab based on that conversation and then merge
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/229
- rgdd: kfs and i talked to al and patrick last week
  - talked about public witness network
  - plan to save some notes and then revisit in about 3 months

## Decisions

- None

## Next steps

- elias litebastion ansible role: Move into admin/ansible and refactor
  - https://git.glasklar.is/sigsum/admin/litebastion/-/issues/2
- ln5: look harder at litewitness /logz (backlogged)
- rgdd: get the usage message MR(s)
- rgdd: still remaining yubihsm connector restart issue
- rgdd, kfs: braindump what we have so far wrt. public witness network (doc)
- filippo: same as last week

## Other

- elias: set litebastion ansible repo as "archived" as it moves inside other
  repo?
  - https://git.glasklar.is/sigsum/admin/litebastion
  - https://git.glasklar.is/sigsum/admin/litebastion/-/issues/2
  - how to handle it in gitlab (technically). It's possible to set to archive
    elias thinks.
  - question: should we do that? Input?
  - it's annoying when it's possible to make changes in two places.
  - ln5: thumbs up
  - at the same time: don't want to make things dissapear
  - elias thinks owner permissions are needed
  - rgdd will give elias owner perm
  - we can consider if the old repo can eventually be removed, but good to keep
    it around for a while
  - nisse: will history be kept when doing the move?
  - filippo: there's a tool for this
    - https://github.com/newren/git-filter-repo
  - but yes: you can keep history when you move
  - elias will try to keep the history
- nisse: tkey news, https://github.com/tillitis/tillitis-key1/pull/305 merged
  (cpu update for syscalls, preparing for storage)
