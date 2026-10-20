# Sigsum weekly

  - Date: 2026-10-20 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: nisse
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - elias
  - nisse
  - quite
  - Gregoire
  - filippo
  - warpfork
  - florolf

## Status round

  - nisse: Announced sigsum-go v1.0.0, see https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-announce@lists.sigsum.org/thread/4H4PW5CCE4UCDXBCVCRAGWOPIHN23H62/
  - nisse: Proposals that I would like to discuss (but too early to decide today):
      * mldsda cosigs (as suggested by filippo last week), https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/154
      * no deduplication in sigsum-v2, https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/153
  - nisse: Playing with an "almost stateless" log server, where all data storage is pushed to secondaries.
  - nisse: released sigsum-go version 1.0
    - rather small changes
    - https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-announce@lists.sigsum.org/thread/4H4PW5CCE4UCDXBCVCRAGWOPIHN23H62/
  - nisse: there should be a corresponding log-go release fairly soon
    - to fix poisoning issue
  - gregoire: done maintenance on log and mullvad witness servers
  - tta: won't be there today, went for some camping!
    - no clear path for collaboration with https://authenticmemory.org/ as for now
      - looks like they're unsure of why tlogs could be useful for their use case
      - I think I prefer continuing cultivating what I'm doing (even not full time)
      - I'll stay in touch w/ them and continue interacting as they build their "v2"
    - also got a negative answer for current grant extension (thus will end next month)
    - will look into new ideas for funding +I will likely also look for a new job!
  - elias: fixed gofmt ci job problem in sigsum-go repo
  - elias: working on Glasklar witness deployments
  - quite: help out with some deployment stuff, some work on sigsum-agent
  - florian: getting back into it
    - packaged sigsum-go 1.0 update for buildroot
  - filippo: blur of urgent things
    - NIST seeds came out
    - tried to do MTC development but other things happened
    - release of Sunlight related to today's emergenycy thing
    - submitted a talk to Real world crypto
      - MTC
      - talk about how large-scale cryptography changes really happen
      - explain how you have to "draw the rest of the owl"
        - we'll see if it's accepted
    - there was an emergency Go release - please update Go.
  - warpfork:
    - the tlog-addenda spec PR: https://github.com/C2SP/C2SP/pull/353
      - slightly modified to be more explicit that it's an extension, not a requirement
      - otherwise i'm surprised to say, no substantial structural changes
    - https://github.com/FiloSottile/torchwood/pull/93
      - filippo: please remind me about that later
    - quietly working on that one application :)

## Decisions

  - No decisions today, but we can discuss nisse's proposals (see above)
    - filippo: looking at the mldsa one right now, looks pretty good to me
    - nisse: support for additional signature types is something we will need eventually anyway
    - nisse: 2 questions:
      - is it worthwhile to do?
      - does the proposal look like a good way to do it?
    - filippo: thinking about the part about getting both ed25519 and mldsa in the same response
    - nisse: you could talk to one witness to get one cosignature and then do another request to get another cosignature
    - filippo: given that there are no large fail-closed deployments of ed25519 deployments, would it be better to start fresh?
    - filippo: would it be better to consider different keys as separate witnesses?
      - nisse: I would not expect it to get too messy
    - filippo: the policy part is easy
    - may need clarification regarding wording, to avoid confusion about what is meant by a witness, it that is always a single key or not
    - filippo: one way to handle it is that if you know a witness has three keys, you can talk to that witness multiple times
    - quite: so this is about when a log talks to a witness using the add-chackpoint endpoint?
      - yes
      - that is the spec currently
      - nisse: in the sigsum log-go server we currently only support ed25519
      - nisse: if a witness supports both ed25519 and mldsa then it would be nice to be able to get both with a single request
      - nisse: today, for each witness line in the policy there is one key and one url
      - quite: so this is about the logic of the sigsum log? ok.
      - nisse: I expect that grouping by url would not be that big of a deal
  - what about the deduplication proposal?
    - filippo: I agree that deduplication is the hardest part about running a log
    - filippo: how does this stop someone to take something that is in the log and just hammering the log with it?
      - the same ratelimit applies anyway, so it's ok
    - filippo: one possible nehative outcome is that I can make somebodyelse's monitor do some work. I can resubmit things a lot causing the monitor to do things, (which the monitor should be able to handle but still)
      - filippo: goes from O(logs) to O(ratelimit of someone who does not like you)
    - nisse: q to florolf: does your monitor detect duplicates?
      - florolf: if something is submitted muliple times, you get multiple notifications from the monitor

## Next steps

  - at the summit we agreed "identity based leafs" (https://github.com/C2SP/C2SP/pull/244) and a tlog-addenda(-v2?) should probably get aligned somehow (because they're already extremely close)
    - not sure what the next step is here
    - maybe all the people closest to that should hang out next monday after the big community call?
    - rgdd is expected back from vacation tomorrow
  - nisse: log-go release soon
  - nisse: exploring sigsum-v2 things
  - florolf: will try to read all the current proposals and stuff

## Other

  - nisse: Question on tlog-mirror: What is expected to happen when a mirrored log crashes with data loss? Should it just be retired, and mirrors used for archival purposes, or is it expected that the log can be resurrected from the mirrored data and start accepting new entries?
    - tlog-mirror spec: https://c2sp.org/tlog-mirror@v0.1.0
    - florolf: my understanding was that tlog-mirror was more about archiving, but maybe it could be used as a backup mechanism as well
    - nisse: if a log signs a checkopint and then sends data to a mirror, but the data is out in the wild
      - what is sent to a mirror is like a tentative checkpoint?
      - you send checkopint to mirrors and then (later) you send the data to the mirror
      - florolf: that would be the wrong way around?
        - the mirrors will not make any cosignatures until they have the data
      - a log could be configured to not send to other witnesses until it has the cosignature from the mirror
      - normally, a log wants to ensure data is replicated properly before talking to sitnesses
      - florolf: so you are thinking about if you could use tlog-mirror internally as part of a sigsum log implementation?
        - so using the tlog-mirror protocol because it exists
      - florolf: in the active-passive scenario, it would be fine for the mirror to allow rollbacks.
        - in that scenario, if it turns out that the primary decides to not commit to something, that is okay
        - florolf: not sure if tlog-mirror is a good fit for that
          - nisse: it's quite close, but not sure if it's the right thing
