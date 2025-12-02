# Sigsum weekly

  - Date: 2025-12-02 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: rgdd
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - rgdd
  - elias
  - florolf

## Status round

  - elias: been thinking about the upcoming sigsum-go release, but not done yet.
    - mainly just blocked by nisse not being here right now
    - NEWS file and everything is ready
  - elias: should update getting-started guide but did not have time
  - florolf: thinking about comments that rgdd and nisse did in log health PR, especially the minority quorum comment.
    - makes sense to support minority policy in some way in the code
      - rgdd: I would be happy to review that if you want
    - florolf: I might write down how I think it could work and then hear what others think
  - rgdd: did a bunch of small things
    - commented on tlog-proof spec
    - commented on the PR from florolf about monitoring and timestamps
      - interesting idea
      - if one wants to think about minority policy and using timestamps
      - if you have a very flat policy then it may be easier to just use median
      - but it seems like different organisations may be running witnesses so there can be different sizes of groups so median may not always be great
  - rgdd: witness-network.org: added so that tdev git repo is linked in the footer
  - rgdd: started working on litewitness and litewitness things
    - new features related to having multiple bastions

## Decisions

  - Decision: Cancel next Sigsum weekly (2025-12-09)
    - for context: there is a meetup in Gothenburg and due to that, Glasklar people will be busy with other things

## Next steps

  - elias: check that all is ready for release of sigsum-go
  - elias: update getting-started guide to use named policy
    - will help in the way that readers don't need to wonder as much where to get  the policy from
    - still should make it clear that you can use other policies as well
  - florolf: continuing on the health monitoring
  - rgdd: maybe finish the ansible stuff for litewitness and litebastion
  - rgdd: maybe blog post about what is needed for an organisation to run a witness
    - florolf: I really enjoy the blog posts, glad to hear that there are more coming
    - florolf: when coming from the outside it's really helpful to flesh things out
      - rgdd: we have a bunch of more blog posts coming
      - rgdd: we are trying to change the way we work to include writing blog posts, as part of each work package
        - rgdd: a way of communicating with people about the ideas behind things, where we are aiming to go, and so on.
      - rgdd: I would like us to do blog posts even more
      - rgdd: if you (florolf) would like to write a blog post then that is very welcome
        - florolf: I might do that later
        - https://git.glasklar.is/glasklar/services/website/

## Other

  - florolf: Testing stage is too reliable?
    - about the whole monitoring thing: the testing stage currently is quite reliable
      - never had a single issue
        - all the witnesses are always there, everything is always working smoothly
      - would it make sense to have a testing setup where things are delibarely less stable?
        - rgdd: maybe. I would certainly like to have more tools to test things
        - florolf: I was thinking that there could be a witness that for example intentionally puts a weird timestamp, things like that
        - rgdd: if there was such a witness, what would you do with it?
          - florolf: I was wondering, when you mock something then maybe you miss some aspects, you only see the error paths that you anticipate
          - florolf: you could catch some error path that you would have missed
          - elias: the idea makes sense to me
          - rgdd: I would not rule it out
          - rgdd: one could imagine a special test policy that has a few witnesses that are deliberately behaving wonky
    - florolf: but for a tlog, some failure modes are one-way
    - rgdd: what would be nice is if there was a reusable thing that could be used to do tests
    - rgdd: if we can make it easier for people to test their things, then that's good
    - rgdd: maybe the first step here would be to think about how to make some kind of test suite for monitoring tooling, and also for witnesses and logs
      - like: is this monitor detecting when cosignatures are missing?
      - rgdd: in our ansible we have some "good path tests", but not much trying to catch the mistakes
      - rgdd: this is most interesting for the parts where we expect there to be diversity of implementations
  - elias & rgdd: thanks florolf for all the work on monitoring things!
