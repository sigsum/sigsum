# Sigsum weekly

- Date: 2026-01-27 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: florolf
- Secretary: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- rgdd
- nisse
- florolf
- filippo
- gregoire

## Status round

- rgdd: some notes with pointers of what the status quo of chairing is
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2026-01-27-chair-pointers.md
- rgdd: 1st drafty draft of the upcoming roadmap renewal
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/136
  - would like a bit of input on the "other" section
- rgdd: sigsum-c review (and a bit behind on that and sign-if-logged review)
- rgdd: fyi: code review is ongoing, some first reports and fixes
  - https://git.glasklar.is/nevun/tlog-code-review/-/blob/main/sigsum-agent.notes.md
  - maybe nisse wants to summarize a few words on how it's going so far?
  - (nisse is the one doing the rubberduck:ing with gb)
  - started looking at litewitness and litebastion, and wrote up these notes. We
    should file some issues with his findings. Maybe i can do litewitness and
    rgdd can do litebastion
  - nisse: he also found some smaller nits in key gen scripts for yubihsm and a
    few other minor nits + appropriate fixes
  - notes about litewitness and litebastion findings:
    - few things, nothing very bad
    - Todo: add link
- nisse: working on sigsum-c and getting started with tkey things, got a bit
  hung up on CI building things relating to tkey building
- gregoire: we have a testing version of litebastion setup, so if someone (like
  rgdd) want to test it -> we should be able to do that know with the staging
  log
- filippo: not much to report
- florolf: not much to add

## Decisions

- Decision: How to tag releases and non-releases,
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/135
  - Open question on initial numbering of -dev-tags. Suggestion: Assuming
    previous release is vX.Y.Z, start with vX.(Y+1).0-dev.1. To make sure it is
    later than potential future bugfix releases v.X.Y.(Z+1), and I think -dev.1
    (and -rc.1 etc) is more common than -dev.0.
  - Summary. confusing that we have standard semantic tags for things we don't
    think of as releases. So proposal is basically: use that form of tags for
    releases only. Remaining question is, what to do with development. Raw
    commit hashes, not that nice because of monitor story. Preferrable to make
    explicit tags. Proposal is to use a "-dev" suffix. See exact numbering
    pattern above.
  - Question about .1 or .0?
  - Nisse prefers .1
  - Filippo - go tags release candidates from .1
    - So makes sense to filippo, but no strong comments about this
  - leaving space for bug fix releases -> makes sense, but a bit confused about
    which one is selected
  - proposal says to increase patch version, but then it's also explained why
    that's a problem
  - nisse: i will edit the proposal to move that to the main section, i.e., that
    it is MINOR version that's bumped (the middle one) before starting on new -dev
    tags.
  - filippo: sounds like a good strategy

## Next steps

- rgdd: finalize roadmap proposal and work towards decision next week
- rgdd: test yubihsm scripts again after nisse's final edits
  - https://git.glasklar.is/sigsum/core/key-mgmt/-/merge_requests/30
- rgdd: more sigsum-c and sign-if-logged review
- rgdd: test litebastino thing gregoire mentioned in status round
- rgdd, nisse: file issues aobut litewitness/litebastion
  - https://git.glasklar.is/nevun/tlog-code-review/-/blob/main/litewitness.notes.md
  - https://git.glasklar.is/nevun/tlog-code-review/-/blob/main/litebastion.notes.md
- nisse: make the minor proposal edits based on above comments (clarifications)
- nisse: no specific next steps other than working on the TKey things
  (sign-if-logged)
- gregoire: testing the litebastion (even though it will probably be william
  working on this)
- filippo: exactly the same as last week -- appologicies for those that waited
  on anything this week.
- florolf: still working on the bootloader / microcontroller integration of
  spicy. Needed to build a debugging tool (for hardware), because the dev env on
  my board was tedious. Waiting for $something to arrive.
- florolf: heading to FOSDEM
  - rgdd: recommending to try and speak to olle!

## Other

- rgdd: what are the big strokes progresses you'd want to be in the upcoming
  roadmap's "summary of progress" session? Did I miss anything?
- rgdd: input roadmap draft? Things to add, remove, change?
  - florian: happy to see the witness SLA productionzining things move forward!
- nisse: Anyone going to fosdem?
