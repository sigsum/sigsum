# Sigsum weekly

  - Date: 2025-11-25 1215 UTC
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
  - nisse
  - florolf
  - filippo
  - gregoire
  - warpfork

## Status round

  - elias: new builtin policy "sigsum-generic-2025-1" was merged:
    - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/282
    - this is the first builtin prod policy (earlier were only test policies)
    - merged but not released yet so can still be changed, feedback welcome
    - see https://git.glasklar.is/sigsum/project/documentation/-/blob/main/policy-maintenance.md
  - nisse: Added link-time hook for overriding --version for the sigsum-go tools.
    - to make it easier to get proper version info whan packaging, for example for debian package
  - nisse: also bugfix related to double slash (//)
  - nisse: worked on litewitness to get per-log bastion config
    - filippo helped with that
  - filippo: about hint in spec: if there are no strong arguments on either side, let's go with what we have in there
      - nisse: it would be good with some explanation of why the hint is needed
  - florolf: First stab at log staleness monitoring in sigmon (https://github.com/florolf/sigmon/pull/10) -- feedback appreciated whether this makes sense
    - currently sigmon sends you an alert when a new leaf arrives
      - you don't know if the log has disappeared
    - now, tracking when last timestamp happened and send alert if too long time has passed
    - work in progress, but something like that is probably useful to have
    - nisse: good to have an alert if you cannot reach quorum for some period
    - nisse: could also be good to have a less serious alert if only some single witness has disappeared
    - rgdd: there could be separate alerting for additional things
    - florolf: ok so beyond quorum monitoring
    - rgdd: the quorum is a bit unintuitive in some ways
      - for a minority policy, as a monitor if you want to be sure there is no split view then you need to see many cosignatures
    - rgdd: ideally what I would want:
        - you pass a policy to the monitor, and the monitor will know what to do
    - florolf: I don't really like doing magic things
      - I want to be explicit about what should be done
    - rgdd: you would expect all the witnesses to be there all the time, and if one witness is gone for a significant time then it's reasonable to alert about that
    - florolf: see comments in github
      - rgdd: ok I will take a look at the PR
  - rgdd: redeployed www.so with some smallish doc updates, e.g., listing florolf's monitor, updating status of wip / stable specs, etc.
  - rgdd: been testing litewitness/litebastion stuff to help nisse/filippo iterate
    - the thing that filippo merged recently seems to be working
    - tests in the CI look good as well
  - rgdd: fyi: filippo tagged torchwood v0.7.0 with the new witness/bastion stuff
    - https://github.com/FiloSottile/torchwood/blob/v0.7.0/NEWS.md#v070
  - filippo: main thing: landing the changes in torchwood
  - filippo: did a small pass on tlog proof
  - filippo: figured out the internet archive upload bug
      - there was a but in go tools, that archive.org somehow worked around
      - there was a size that was 4 GB which was suspicious
      - to get things uploaded, zip -f worked
  - filippo: been rushing to get things in before go freeze

## Decisions

  - nisse: leaf context proposal deferred to next week
  - nisse: want feedback from others
    - rgdd: please poke relevant people

## Next steps

  - nisse: the bastion things are more or less completed now
  - nisse: will get back to the TKey and sigsum-c things
  - elias: possibly thinking about a blog post on topic named policy, and if there is any additional polishing that should be done wrt. policy that was merged and not released yet. And the release. Plan here is release in ~a week or so.
  - elias: update getting started guide with testing name policy
  - filippo: vacation!
  - gregoire: think about possibility to run bastion for mullvad's sigsum log
  - rgdd: send info to gregoire about running bastion
  - rgdd: prepare sigsum's ansible to use the new things that filippo has added related to per-log bastion
  - rgdd: take aonther look at PR conversation with florian
  - florian: iterating on log health stuff
  - florian: other work on sigmon
    - using test vectors from rgdd

## Other

  - tlog-proof: https://github.com/C2SP/C2SP/pull/181
  - filippo: would like to hear if anyone would be unhappy if we landed optional hint as a base64 string
    - having it at the bottom would be prettier, but there are pros and cons
    - I like that we can have a go function that takes the whole thing
    - maybe we don't call it hint but something else?
    - rgdd: options:
        - option 1: don't have it. evey library would have its own way of handling outer information, different libraries will likely do it differently
          - rgdd: to me, option 1 does not seem great
        - option 2: put it in the bottom, "bring your own data" and just put it in the end
        - option 3: there is a "hint" or "extra" or "extra-data" line, with a base64 blurb
          - if it gets very long then it's annoying, but we will anyway have signatures that will get very long
        - rgdd: are there any technical arguments?
        - warpfork: there are two different specs that seem to govern this:
            - the signed note specification
               - permits as many linebreaks as you want
            - the checkpoint spec which says you cannot have as many line breaks
            - filippo: that's an argument for having the base64 part
            - filippo: a third spec?
            - rgdd: all the different objects could be split on a single character?
            - warpfork: we want a recursive format instead of a bunch of concatenations
            - filippo: you have to do one seek to check if there is an extra line or not, and then you call the checkpoint parser for the rest
            - warpfork: it's fine as long as we remind everyone using this which spec they must use
            - rgdd: would it be better if there was an appendix with guidelines about how to use the spec, like implementation guidelines?
              - yes, that could be good
            - filippo: we could also stick to what's in the spec right now and there is no problem
            - nisse: it would be perfectly fine according to the current version of the spec to not use the hint and append any data I like
              - so you can do your own thing anyway
            - filippo: the hint is there to support usecases where that is useful
            - rgdd: the only other technical argument is that base64 encoding makes it bigger?
              - nisse: if the data is very large then it would be weird to have it in base64 form in the middle
            - filippo: it's optional
            - nisse: I'd be fine with the extra line with base64 if that's what others want
            - warpfork: I want clear section endings
            - warpfork: I will post a comment on the PR
            - rgdd: the status is that we are iterating on it, so changes can be made later
