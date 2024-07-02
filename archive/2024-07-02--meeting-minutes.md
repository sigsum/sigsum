# Sigsum weekly

- Date: 2024-07-02 1215 UTC
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
- gregoire
- filippo

## Status round

- filippo: tlog-tiles merged!
- filippo: sigsum-verify MR, and tested the tkey flow. Have a new age key. And
  tested rotation flow. That we should probably document. "Hey here are the new
  keys". Will stick this into a large commit message. Just need a sigsum-verify
  release to point to in the README.
  - rgdd: notes on update flow and put them in the archive?
  - filippo: commit should maybe be sufficient but if anything else is useful ->
    will do that
- filippo: trying to move tlog-witness spec forward, finnished addressing all
  comments. Think Al and Martin might be on vaccation? Unclear. But waiting for
  thumbs up and then it will automerge.
  - note: please no new threads, new issues/mrs instead
  - (codeowners in github -- concept is kinda broken. What filippo wants -- at
    some point in the PR cycle, someone who is a code owner including the author
    can approve. And then you leave it up to the social process when it is OK to
    merge.)
  - (there is a github app for this. You can't do it with github actions,
    because github actions can be modified in a PR. And the modification takes
    precedence. So have to install a github app that is out of tree to do the
    policy enforcement.)
- rgdd: upgraded poc.sigsum.org from bookworm to bullseye
  - jellyfish worked out of the box after the upgrade, most notably including a
    MariaDB bump from 10.6 -> 10.11
  - nisse's poc witness did not start
    - there's a .bak script in the poc-witness directory with the old script
      (+-1)
    - fix was basically: `apt install python3-poetry` and `poetry install`.
    - https://git.glasklar.is/glasklar/services/misc/-/blob/main/bookworm-upgrade-notes.md?ref_type=heads#notes
- rgdd: observed some uptime monitoring errors, filed the below for litebastion
  - https://github.com/FiloSottile/litetlog/issues/11
- rgdd: peeked at tlog-witness PR (diff in latest commit), and also peeked at
  sigsum-verify MR briefly.
  - https://github.com/C2SP/C2SP/pull/66
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/185
- rgdd: can mention ln5 configured armory-witness
  - https://git.glasklar.is/glasklar/services/armored-witness
- gregoire: also been trying to setup armory witness, but we're currently moving
  offices so no where to put it right now.

## Decisions

- None

## Next steps

- rgdd: re-read tlog-witness spec (but latest diff already looked good)
  - give thumbs up in a couple of days if al/martin are unreachable
- rgdd: properly review sigsum-verify MR and merge, will wait until there's a
  test
- rgdd: work with linus on deploying stable sigsum log
- filippo: if we merge sigsum-verify thing, then i want to finnish age
  instructions. Minted offline key and all that already.
- filippo: will make a PR to the tkey ssh agent, to not use pinentry mac.
  Because I found a different way to do it in yubikey agent without
  dependencies.
  - #tillitis on irc, it is bridged with a matrix room. Ping mc if you want to
    chat with higher bandwidth.
- filippo: will ensure tlog witness gets merged
- filippo: gophercon next week, so will mostly be preparing for that

## Other

- FYI: filippo won't be here next week, because of gophercon.
- Remember: next week is final weekly before the summer break.
