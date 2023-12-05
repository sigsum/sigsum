# Sigsum weekly

- Date: 2023-12-05 1215 UTC
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
- ln5
- nisse
- filippo

## Status round

- rgdd: attended cats and some follow-up from that, few wip branches for
  www.so/docs but none of which are worth looking at right now / yet
- nisse: catching up with sigsum (and st) work started prior to cats. Thinking
  about number of cosignatures that monitors need, see other section.
- filippo: cats, lots of good talking and feedback. Good enough feedback on
  getting witnesses syncronous. Alignment on "reputational units". We're all
  using different language for things, not sure how to fix it. Naming is hard.
- filippo: updated the proposals based on discussion
- ln5: cats

## Decisions

- Decision: Cosignature line covers extension lines if any, no change wrt.
  semantics of what that cosignature means regardless of if extesion lines are
  present or not
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/64
  - nisse: smallish check on how large a checkpoint can be -> helpful for
    implementing a witness on a constrained platform; like a microcontroller.
    And not have to check that extra data in any way.
  - filippo: this is a job for the note spec.
  - rgdd: not 100% sure where to have a limit, but would also like one somewhere
  - ln5: general comment is if we add things to a spec that is not motivated
    (unlike other things), then we can put a short sentence/note that makes this
    explicit. E.g., writing down that we don't know what extension lines would
    be.
    - nisse: would pitch this change on the account of compatiblity and use of
      checkpoint
    - filippo: will make a go at a good wording
    - ln5: would like to retract my comment, as i understand it's in line with
      the style of the rest of the spec (as opposed to f.ex. log.md which is
      written with minimalism in mind)
- Decision: Make add-checkpoint endpoint smarter, deprecating the get-tree-size
  endpoint
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/64/diffs
  - acknowledge where this idea came from before merging
- Decision: Cancel weekly on 2023-12-12
  - (Several of us will not be able to attend due to meeting up in person)

## Next steps

- filippo: will MR a new witness.md, and check nisse's number of cosignatures
  ideas (see below); and merge proposals.
- rgdd: readup and think a bit more about witnessing, www.so/docs if time
  permits
- nisse: nothing major, looking a bit at safe file atm.
- ln5: yubihsm provisioning, not sure if it will happen before next meet but
  it's my next step

## Other

- Feedback welcome on
  https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/66
- "full audit" terminology, see:
  - https://github.com/google/trillian/blob/master/docs/papers/VerifiableDataStructures.pdf
