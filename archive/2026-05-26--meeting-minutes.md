# Sigsum weekly

  - Date: 2026-05-26 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: florolf
  - Secretary: elias

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
  - tta
  - florolf
  - mw
  - warpfork
  - Patrick (NYU)
  - Justin Cappos (NYU)

## Status round

  - rgdd: had a session with filippo where we unblocked a bunch of things
    - looked at nisse's MR about tlog-proof
    - also looked at proposed tlog-policy spec
    - bastion spec things, a PR was merged
    - tlog-witness API and tlog-cosignature
      - what is pending there?
        - tlog-cosignature is already merged, nothing pending there
           - there is a new format, with ML-DSA, there is a release candidate tag for that
        - need an API to request subtree cosignatures, that part is still being discussed
          - the current draft was adding some DOS-protection things, discussed that
          - filippo is going to make a next iteration of the PR about that
  - rgdd: just started on a per-log bastion PR in witness network, midthrough (wip)
  - rgdd: martin and i are program chairing TDS, please fill out interest survey
    - https://docs.google.com/forms/d/e/1FAIpQLSd7AO-j7L0uMz-KeEJyK4ZWf-dlPwyd3nLbnpwdGI2kfcS0BA/viewform
    - September 29 to October 1
    - Please volunteer if you want to contribute in some way
  - elias: preparing glasklar witness group deployment
  - nisse: sigsum-c 1.0.0 released last week. https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-announce@lists.sigsum.org/thread/JPBYWTX5JMS67OFETMERJHDR7MJ46OUD/
  - nisse: No sigsum logging for this release... Wrote up a sketch on how one might want to do releases, based on recent offline discussions. See https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2026-05-26-release-manifest.md?
  - nisse: Looking at improving sign-if-logged testing, see https://git.glasklar.is/sigsum/apps/tkey-sign-if-logged/-/work_items/4
    - a large part there is improved tests
  - tta: back from vacations
    - intend to go to  https://reproducible-builds.org/events/gothenburg2026/ to spread the word
    - September 22-24
  - tta: next week will start implementation work
  - filippo: have been working on MTC (merkle tree certs), and also what rgdd mentioned
  - mw: working a bit with nisse and elias, focusing on witness deployment at the moment
    - looking at sigsum-agent with SELinux
      - want to deploy both sigsum-agent and litewitness from a glasklar-hosted deb repo
        - instead of having to do "go install", a package repository can be used instead
        - packaging is a prerequisite for getting SELinux policy for that
    - also worked on sigsum-c things with nisse
  - florolf: tlog-scales read path basically useful now
   - vibe demo tool https://github.com/florolf/tilepecker
  - florolf: hardware witness more hardware bringup/secure boot stuff
    - wanted to put that on firmer footing
  - florolf: didn't get to tombstones, try again next week
  - Justin Cappos: Started to read through docs / spec
    - Do you want writing cleanup feedback too?
    - started to read C2SP documentation
      - in places it says, "alice sends something to bob, and bob is expected to use that in an offline way"
        - things that may make sense to internal folks, but hard to understand for someone coming from outside
        - documentation could be a lot easier for someone who is not deep in the project
        - warpfork: I have been trying to improve that recently, there is a PR about that
          - > https://github.com/FiloSottile/mostly-harmless/pull/11
          probably that still is not enough!
        - justin: there are also places where it says that something is solved by another thing and then there is a link to something that just says "todo"
        - justin: it may take more time than I initially expected before I can come up with what I wanted
        - florolf: there may be some overlap where several people work on the same things, but still probably worthwhile to improve documentation, fresh eyes are helpful
        - justin: it's okay for something to be not fully described, as long as it's described somewhere.
        - justin: for example exactly what it means for some things to be "offilne"
        - nisse: comments and suggestions regarding documentation is most appreciated!
          - then what can be done may differ depending on the kind of documentation it is
        - justin: there can be different perspectives
        - warpfork: the idea for tlog.directory is that there should be a high level description and then quick links to everything else
          - justin: I'd really like to look at what you have written, and see if it helps me
        - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2026-03-18-tta-getting-started-feedback?ref_type=heads
          - example of how tta was providing some feedback before, very helpful input
        - rgdd: it would be extremely useful if you could make a bullet list of the things that you found unclear
          - justin: I have that, already started such a list
        - rgdd: there are a lot of glue documents that are missing, that is known
          - tlog.directory is one part of such glue
          - another thing is a sigsum overview
            - there is a drafty start of that
        - rgdd: if you see things like "this is a paragraph that can be added or improved", then please make a small PR about each such thing
          - justin: sure, I will create small PRs about each thing
        - rgdd: it's good that you can read about this from different perspectives
        - rgdd: please don't feel discouraged to also write your own if you think that will help others
        - rgdd: some wip/drafty glue stuff for sigsum after reading getting started, wip wip wip; needs work. E.g., based a bit on what tta was missing for further reading a while back. Input on direction before fleshing out more is helpful.
          - https://git.glasklar.is/sigsum/project/documentation/-/blob/rgdd/beyond-testing/www.sigsum.org/content/beyond-testing.md?ref_type=heads
  - patrick: working with justin

## Decisions

  - None.

## Next steps

  - rgdd: more TDS prepping with Martin
  - rgdd: continue w/ per-log bastion PR @ witness network
  - rgdd: sigsum 'next' stuff, maybe. Depends on hayden's availability, will poke him
  - rgdd: input/rubberduck, poke me if you need something
  - nisse: sign-if-logged tooling, planning to get a release out before summer vacations
  - filippo: will be out-of-office for part of the coming week
    - open to spend some time thinking about stuff while on a motorcycle though, any suggestions?
    - nisse: release manifest
    - florolf: tombstone discussions, how to publish tombstone?
  - filippo: there are next steps from call with rgdd
    - PRs about signing subtree and read API in tlog-witness

 - tta: I'll be next month give a talk to non-technical people about ATrans, and will explain transparency to them
   - will explain to people who are not at all in cybersecurity domain, may want to discuss that with someone
     - justin: I'd like to give feedback
    - the presentation is in the last week of June
  - florolf: planning to do a package for sigsum-c in buildroot
    - something came up while packaging that, nisse answered about that in a MR

## Other

  - "need an API to request subtree cosignatures" -- what's an example user story that wanted this?
    - https://datatracker.ietf.org/doc/html/draft-ietf-plants-merkle-tree-certs-04#section-4
    - filippo: the story on subtrees:
      - MTC does certificates out of trees
        - want to use a single tree and chunk that up into smaller trees
          - conversation on Plants mailing list
        -. use cases: 2 of them:
          - 1: how tdo you tell a browser that something is part of a tree
            - for that, the size may not matter much
          - 2: standalone certificates:
            - a standalone cert is a "spicy signature" instead of using subtrees
            - then you would enbd up with quite a chunky inclusion proof
            - nisse: it was a size reduction of about 20% of a few KBytes
              - filippo: so by being able to request subtree cosignatures you can reduce size
          - filippo: shipping to browsers happens every few minutes
          - filippo: MTC does 2 things:
            - 1 every once in a while we take a piece of the tree and send that to browsers
              - we do that once every N minutes
              - you want a website to start working quickly, more quickly than N minutes
              - so then you have to send a different certificate that actually includes the signatures
              - most certificates will use the smaller landmark-based certificates
              - but some will be of the other kind
              - what subtrees say is, you already have this stuff, use a signed subtree that is smaller
              - filippo: this decouples the size of a certificate from the age of the log
              - filippo: if someone wants to go to the Plants mailing list and argue that we should drop the requesting signed subtree thing, then go ahead.
