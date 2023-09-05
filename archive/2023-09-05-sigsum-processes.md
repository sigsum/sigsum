# Sigsum's project processes

This document describes how we collaborate in the Sigsum project.  May
eventually be expanded, polished, etc.  For now just drafty archive notes.

## Async communication

On a daily basis:

  - IRC: `#sigsum` on OFTC.net
  - Matrix: room `#sigsum`, bridged with IRC
  - Email: sigsum-general (at) lists (dot) sigsum (dot) org
  - GitLab: https://git.glasklar.is/sigsum

## Video/voice meets

We have open Jitsi meets every week on Tuesdays, 1215 UTC.  Meet details:

  - Jitsi: https://meet.sigsum.org/sigsum
  - Minutes: https://pad.sigsum.org/p/sigsum-YYYYMMDD

A meeting chair creates the above pad and persists it after the meet is done in
our [archive][].  The chair also leads the meet and ensures someone takes notes.

The meet structure is as follows:

  - **Hello**: add your name/nickname in the pad, "hi how are you", etc.
  - **Status round**: everyone gets a chance to report, briefly, what project
    activities they have been up to since we last met.  Aim to keep this short
    and down to the point, max a few minutes.  We often bring links related to
    our reports, in case someone would like to check them out further later on.
    Some of us fill out the pad with our status round before the meet, while
    others let the chair take notes as they report.  Pick what suits you better.
  - **Decisions**: anyone can propose decisions.  All you need to do is document
    what you'd like to be decided and why, then insert "Decision? Thing to be
    decided" together with a link to that proposal.  For example, you may put
    your proposal in a [pad][] or create an MR in our [proposals][] directory.
    Circulate your proposal _before the meet_.  In practise, this means that we
    usually have consensus on moving the decision forward once it is proposed.
    Proposal that don't get decided typically require more work/consideration.
    Decided proposals are marked as "Decision: ...".  (So, you can grep them.)
  - **Next steps**: roughly state what you're up to until next time, if
    anything.  It's totally fine to just be a fly on the wall as well.
  - **Other**: here we discuss topics related to the project in more detail,
    just add what you'd like to talk about.  We pick-and-choose, and sometimes
    split up into smaller groups.  This part is open-ended based on people's
    availability, but for the most part we aim to end by 1300 UTC (45m meet).
    Please note that sometimes we don't have time to discuss everything.  This
    might be your cue to instead schedule a meet with someone the coming week.
    Don't forget to take notes and add them to the [archive][].  By the way,
    that's perfect to tell us about and link in the next week's status round.

The idea with this meet structure is that we are forced to get work done
**before the meet** in order to push through **well-documented decisions**.  We
also get to sync on the past (status round) and immediate future (next steps),
while supporting opt-out of the lengthier discussions in the "Other" section.

So what type of things are we usually deciding on?  Mostly changes to protocols
and specifications that define what our software is meant to do.  The idea is
that if we reach consensus on this, then we can build interoperable things.

So: if you're looking to update a protocol or break APIs/ABIs, you probably want
to create a proposal that outlines why.  For example: "Here's how it works
today.  That's bad because.  The alternative solutions I've thought of are.  So,
my conclusion is that the best way forward is.  The concrete proposal is."

Note that a proposal doesn't have to be polished to perfection.  It's merely
meant to help us discuss and document how we would like to move forward and why.

Some trivial but important-to-convey decisions don't need a pad or document,
e.g., "cancel next weekly, most of us will be away attending a conference".

[archive]: https://git.glasklar.is/sigsum/project/documentation/-/tree/main/archive
[pad]: https://pad.sigsum.org
[proposals]: https://git.glasklar.is/sigsum/project/documentation/-/tree/main/proposals

## Collaborating in GitLab

This part needs to be expanded.  But briefly:

  - Create issues to document things that are missing, not working, etc.
  - File MRs, the rule of thumb is to get at least one review before merging.
  - Mark MRs that are not ready with "DRAFT: ".  If you assign a reviewer for a
    DRAFT MR, please specify exactly what you're looking to get feedback on.
  - The reviewer doesn't update your MR, you do as the assignee by moving the
    MR forward, pushing to the branch, etc.  Don't forget to include tests!
  - The assignee clicks the merge button once all review comments are addressed,
    all pipelines passed, and the reviewer clicked the approve button.  Sometimes
    the reviewer clicks the approve button with conditional comments like "just
    fix X", "consider Y", etc.  Make sure to address those comments too.  If you
    don't have permission to click the merge button, transfer the assignee role
    to a maintainer once everything is ready.  They will do the merge for you.
  - If you're done with an issue, get it closed in any way you see fit.  For
    example, click the close button or reference it to be closed from an MR.
  - See the milestone tab for things that are being worked on.  If you see a
    milestone starting with "DRAFT: ", it might be considered for our roadmap.

You will find the most essential protocols/specifications in the top-most
[project/documentation][] repository.  Tooling-specific specifications, e.g.,
proof and policy formats, are kept in the same repository as the given tool.

Most other documentation is dumped in our [archive][] with very rough edges.

If you're still not sure about something relating to GitLab, please reach out.

[project/documentation]: https://git.glasklar.is/sigsum/project/documentation/

## Project roadmapping and milestones

Our roadmap is updated periodically, typically every 4-12 weeks.  The next
roadmap update date is set while [deciding on the roadmap][] on a weekly meet.

We have a project lead that proposes the next roadmap, see [a concrete
example][].  As shown, it is composed of the following sections:

  - **Summary of changes:** what's different compared to the previous roadmap?
    For example, what's been done (yay!) and what's been changed or added?
  - **Roadmap:** Macroscopic view of what we're planning to work on, in rough
    order of priority.  We aim for there to be enough concrete things in this
    list so that we're working on the top-most part.  Unless anything changes,
    we will continue working on the list's tail.  Which part is considered the
    tail is specified, so that it is clear what is not being worked on now.  We
    also add any other useful information about the longer-term roadmap here,
    which in the case of Sigsum means getting into the defined maintenance mode.
  - **People**: who's involved, and what parts of the roadmap do they work on?
    No-one works alone, and we roughly specify who will be reviewing what/where.
  - **Concrete milestones**: typically a concrete milestone for every item in
    the roadmap list that breaks it down in further detail.  Depending on the
    preferences of who's involved and how well-defined the TODOs are, this can
    range from just a few placeholder issues (e.g., "gather requirements for X",
    "create library Y", "extend tool Z") to more detailed ones from our backlog.
    As a rule of thumb, all active milestones should have a start and end date.

If we run out of time, we try to make sure that we still close the milestones we
worked on.  Milestones that drag on risk the feeling of no progress.  In other
words, to the extent possible we re-plan backlogged tasks in a new milestone.

The project lead ensures that new "DRAFT: " milestones get proposed for the next
roadmap.  Once the roadmap is decided, the "DRAFT: " prefixes are dropped.  The
project lead takes a stab at this with input from those that are doing the work.

After the new roadmap has been set, we also have a short team retrospective.
The chair goes through the questions in [the following pad template][].

[deciding on the roadmap]: https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2023-05-16--meeing-minutes.md#decisions
[a concrete example]: https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2023-05-16-roadmap.md
[the following pad template]: https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/template/retrospective.md

## Releases and announcements

Currently a bit hand-waved, but if it had to be summarized it boils down to
shooting an email on our mailing list stating that a new version of our
protocols or associated software is available, including expectations.  This
will need to be refined a bit more now that we are very close to v1 protocols.

## Is any important project information missing?

Please reach out, we would like clarify that and get it roughly documented!
