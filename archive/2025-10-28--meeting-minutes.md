# Sigsum weekly

- Date: 2025-10-28 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: elias
- Secretary: rgdd

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
- nisse
- filippo

## Status round

- rgdd: attended/organised TDS, loads of good talks, conversations, etc!
  - trying to debrief with as many as possible
    - talked to fredrik, elias, nisse
    - would like to hear from filippo and florolf also if they have time
- rgdd: silentct talk at tds, recording should appear sometime soon on YouTube
  transparency-dev channel
  - https://git.glasklar.is/rgdd/tds-25/
- rgdd: witness network is up, and we got already some logs + witnesses!
  - site: https://witness-network.org
  - src: https://github.com/transparency-dev/witness-network
- rgdd: fyi: bridge in direction from slack to matrix is buggy, I've joined
  sigsum and witness-network slack rooms with notifications to do a bit of
  manual bridging for a while and see how that goes
- rgdd: fyi: Al noticed latency spikes for my witness, debugging in progress
  - Might be caused by bastion host?
    - could be something related to bastion reconnections
  - https://github.com/FiloSottile/torchwood/issues/11
  - https://github.com/FiloSottile/torchwood/issues/23
  - latency goes up to about 1 second sometimes
  - rgdd's test witness is the only one in the test list that uses bastion host
  - al has graphs showing things about how witnesses are working
- rgdd: discussing next steps tkey+sigsum with nisse this morning, roadmap
  candidate
- rgdd: discussing more roadmap candidates with nisse and elias
  - prod named policy --> elias will work on that
  - bastion client + similar support in log-go ("optional one bastion per log
    srv")
  - witness getting started / blog post / out reach
  - leaf context proposal + implementation
    - having a signing context, in a backwards-compatible way
  - to be discussed: tesserera, sigsum/v2 -- good time to now/soon get going?
- elias: working on documentation for named policy functionality
  - some things done
    https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/271
  - draft: https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/272
- florolf: sigsum-go package submitted to Buildroot
  - buildroot = embedded linux distro
  - waiting for feedback
- florolf: witnessing support for tessera posix-oneshot for witness testing
  - merged already
  - (this is when i noticed the vkey / hex encoding nit/issue.)
    - florolf will file an issue in the tessera repo
  - tessera one shot, super straight forward to use
  - tessera designed in a long run service, some things don't map perfectly for
    1 shot. E.g., garbarge collection every 60s, but one shoot doesn't run for
    that long.
  - florian will file an issue with suggestions/feedback
  - (kind of want: serialize now, garbage collect now, etc.)
  - fail open vs fail closed, also something that would have been nice to have
  - timeout is how long it takes to respond for a single request, and would e.g.
    like to say "try for 30 seconds" including retries. Current behavior makes
    sense in long lived tessera but maybe less so in oneshot
  - expectation: set deadline, retry until that deadline expires
  - and want fail open as a configuration knob
- filippo: chatting with Al about verifiable indexes and CT
  - we thought we had solution, running one VI for all logs
  - what if one log disappears: then can't audit the VI
  - so not good
  - might have to go back to one VI per log
  - working on a way to do batched checking for VI auditors
  - problem with one VI per log: if log operator runs VI, fine
  - but if auditor wants to audit all VIs and keep them all in mem at once, it's
    like 1TB
  - so would be a bit too expensive
  - so now: idea is to think about something more batched, and do one at a time
  - rgdd: as mentioned few weeks ago, i like this approach more. Assuming that
    it works. :-)
  - rgdd: thanks for working on this, super exciting!
- filippo: bunch of thoughts about the summit, not for status round
- filippo: post summit, not much happened
- filippo: playing with spicy cli with eric m, related to tessera one-shot
  - so far no witnessing
- nisse: we accepted stricter policy format last weekly (two weeks ago)
  - working on the corresponding doc change, got review from rgdd
  - will be merged soon
  - then someone will have to implement the actual changes
  - that will probably be me
  - btw: mtc (Merkle Tree Certificates) folks have seen the policy format, and
    they're excited to already have a format to specify policy
  - they might need to specify slightly more complex policies than what we have
    envisioned
  - e.g. because they have concept of both mirrors and witnesses
    - "is this mirrored" and
    - "also m-of-n witnesses"
  - witnessing is the same that we have
  - mirrors might overlap with entities that are witnesses
  - could have: one group that is "mirrors" and one group that is "witnesses"
    and then require "mirrors-and-witnesses"
  - so this use case should work with the existing format, assuming no shared
    keys between witnesses and mirrors
- elias: as some of you noticed. We had downtime for some glasklar things, due
  to a power outage in this part of town. Not only our building. But it is a
  good lessoned learned for us (something we already know of course, not optimal
  place to host. We host in a few different locations. Some in proper data
  centers. But the things that are in our office -> not same redundancy as on DC
  sites)
  - working on summary of what happened and updating timelines for log/witness
  - note: secondary was down due to this, which meant no-one could submit during
    the 3h outage. But monitors and such still worked, i.e., primary was alive
    and running but wasn't able to get the replication it needed for moving
    forward the tree head
  - interesting to note: can talk about uptime in many different ways (can you
    contact log, can you read, can you submit and get it merged...)
  - filippo: also talking about uptime and delays, maybe offer commercial sla:s
    and which SLA:s we can offer (contxext: geomys witness). Maybe a familiy of
    witness, the SLA is for a witness in this pool of several witnesses. And
    this group only counts as one in the group.
  - filippo: this is a thing we can do, right?
  - nisse: yes

## Decisions

- None

## Next steps

- rgdd: prepare roadmap proposal until next week
- rgdd: virtual walk with filippo
- filippo: few loose items and then mostly VI
  - showing it works for CT -> needed to build confidence in it
  - and building confidence in it is needed to keep it moving forward
  - (now ppl are starting to adopt witnessing, but what about monitoring. So we
    need to show we have a productzioned solution for that.)
- filippo: but first, sunlight as a witness. Then VIs. Then probably age key
  server proof of concept. I realized it would be fun to do as a blog post
  rather than a thing I just put out there. It's a good example of how to make a
  transparent key server.
  - we want this thing
  - we can start with just a service
  - that requires trust
  - let's make it transparent
  - so we took a tlog
  - how does the service work now if person is authroized...
  - backed by transparency mechanism
  - and 3rd party monitors that can email you when you got a new key in your
    name
  - now 3rd party with emails....VRFS
  - how monitor efficiently-...VIs
  - so it's a good composing to show case!
  - question: write before VIs exist, monitoring inefficient. We will look at
    VIs in the future. Or wait for VIs, might delay.
    - rgdd: probably a good idea to not be blocked by VIs
    - such a blog post already has lots of good contents
  - show of tessera, to self host log. Torchwood to do the monitoring. Witness
    ecosystem and sigsum policies, to specify policy in the client.
  - "monitor expensive, you're not sure you have the latest version. Just that
    you have an included version" without VI. Which is OK for 1st iteration.
  - maybe make entries expire, e.g., just for a week
- elias: complete documentation of named policy functionality
  - when all documentation pieces are there, ask others for feedback on that
- elias: prepare for creating prod builtin policy
  - includes writing down the procedure used for that
- florian: want to log into log failure monitoring in sigmon
  - e.g. not getting any new cosignatures and stuff like that
  - so want to sketch and try a bit
- nisse: will try to wrap up recent policy format tweaks
- nisse: help rgdd tkey/sigsum next steps
- rgdd: debrief TDS with florolf

## Other

- New MRs from florolf updating getting-started guide (merged already, thanks!):
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/123
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/124
- more debriefing after TDS, anyone?
  - deferred, out of time
  - if you want to talk about this, rgdd would be more than happy to!
