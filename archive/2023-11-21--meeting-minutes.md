# Sigsum weekly

- Date: 2023-11-21 1215 UTC
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
- grégoire
- ln5
- filippo
- rgdd

## Status round

- nisse:
  - Working on design paper, to be ready for CATS
  - Trying out a minimal ssh-agent: https://git.glasklar.is/nisse/oracle-agent
- rgdd: idea for an entrypoint to our documentation, screenshot/mock-up here:
  - https://git.glasklar.is/sigsum/project/documentation/-/issues/39#note_10610
- ln5: enabling more ways to interact with our gitlab instance
  - https://git.glasklar.is/glasklar/services/gitlab/-/issues/22
  - (also trying to figure out how to enable email)
  - nisse: another annoying thing: landing page asks you to login, rahter than
    giving you an overview of what projects there are etc.
- filippo: talk to Al and trillian folks, syncing. Working on CT stuff that's
  been linked previously. And C2SP discussions. Busy days with conferences and
  deadlines.

## Decisions

- None

## Next steps

- nisse: cats things (paper+talk)
- ln5: continue with the gitlab stuff, around if you need anything
  - nisse: would like you to read and give feedback on wip paper
- filippo: next couple of days nothing, after that full cats prep
  - trillian team wants a review of their impl
  - c2sp, a document somewhere we can point to
- rgdd: yubihsm, docs wrt. websites, low having fruit before cats?
- gregoire: talk about relay list with rgdd

## Other

- Feedback on possible doc entrypoint linked in rgdd's status round?
  - nisse: like the structure, first paragraph is rather lame. Delete or write a
    summary or main point or something?
  - nisse: at the end, for academic papers: i think it would be useful, but
    maybe a lot of work to also list of the relevant by others with brief
    commentary. Like e.g., the old cowitnessing paper.
    - rgdd: so I hear you say missing link with related work? "Yes"
  - nisse: specs at different landing page? Makes sense to have them here.
  - ln5: each heading could expanded into "user documentation", "documentation
    for operators", etc. Don't need to be so sparse. Think of user that don't
    have "documentation" in the back of the head. And project should go way
    down, users and operators top. Project last. (Gregoire agrees; and put
    getting started first in user documentation. Same goes under project,
    history should be last.)
  - filippo: agree with above comments, listing acamdeic papers that are
    relevant -> good idea. Introduction needs to be fleshed out. "Users" not
    clear to me, change heading as described above. Because now I'd expect a
    list of Sigsum users.
- filippo: Three items of feedback on witness.md from trillian folks
  - Rename add-tree-head to add-checkpoint?
    - Let's make a proposal for next week, that's before CATS \<- filippo will
      do
  - get-tree-size: you mostly only use it when you get a 409. You think you know
    the size of the tree, you try to submit something but it wasn't the right
    thing. Another way: 409 could be specified in its format. I.e., the body
    could be size instead of 409:ing and then doing a separate request.
    - nisse: just add a content type to ensure it is robust?
  - roster: how we got to rosters is path depended? Then we realized sizes are
    not enough. Then we redesigned the roster format. Just a concatenation of
    checkpoints. At that point why are we serving a gigantic blob? Timestamp is
    one another reason.
    - We need to write something down about why the roster looks the way it does
      right now, to ensure we present what arguments we have
