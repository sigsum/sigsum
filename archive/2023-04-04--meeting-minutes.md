# Sigsum weekly

  - Date: 2023-04-04 1215 UTC
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

## Status round

  - nisse: MR to change tree head signatures
    - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/95. 
  - nisse: Overhaul of the user interface for the sigsum command line tools
  - rgdd: update roadmap and milestones

## Decisions

  - Decision: Update roadmap and milestones
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2023-04-04-roadmap.md
  - Decision: Next update of the roadmap on 2023-05-02

## Next steps

  - nisse: Need a plan for tree head signature upgrade, see
    https://git.glasklar.is/sigsum/core/log-go/-/issues/58
  - nisse: File issue on dropping ssh signatures
  - nisse: merge usage message / tooling doc stuff without review for now, poke
    rgdd if anything in particular stands out and needs review; rgdd will open
    issues later if he finds something that can be improved when
    testing+planning next tooling iteration
  - rgdd: give feedback to nisse on $stuff
    - tree head MR
    - token MR
  - (rgdd: still need to define "Future" issues + document some planning
    practises)

## Other

  - Retrospective, round table lead by rgdd
    - Is it clear what you're working on until the next planning meet?
    - Is it clear what the project works towards the coming 6 months?
    - Is it somewhat clear what the project may be working towards after that?
    - Is someone available to provide input to your work in a timely manner,
      i.e., is the feedback cycle short enough?  E.g., wrt. code review,
      discussion of proposals, or anything else that you're doing in the
      project?
    - Is there anything that I could do to make your working situation better?
    - Let me know async if there's anything else you'd like me to ask here
  - Library design questions: (i) Should we have an "abstract" interface for the
    log service? The log server would only need to implement this interface, and
    wrapping in http could be moved to the library. See
    https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/34. (ii) Somewhat
    related: Extend requests.Leaf (representing tha add-elaf request) to not
    only hold fields from the message body, but also from the Sigsum-Token:
    header?
