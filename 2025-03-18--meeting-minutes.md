# Sigsum weekly

- Date: 2025-03-18 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: rgdd

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
- filippo
- (ln5 not present, reporting late ~13:30)

## Status round

- nisse: filed issue on claim format based on discussions last week. (Based on
  the discussion with simon on sigsum-general and this meeting last week.)
  - https://git.glasklar.is/sigsum/project/documentation/-/issues/70
- nisse: filed issue for investigation of gccgo support.
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/116
  - note: even the x repos move on
  - safefile: probably very stable it fine
  - mock: for test
  - getopt: probably fine
  - mod, x/mod, x/net..., e.g., x/net requires 1.23
  - nisse: we use them for idna things for sigsum token, could possibly be
    worked around
    - filippo: that's probably x/text
    - nisse thinks x/net is related to idna, but not entirely sure
    - yeah both x/text and x/net
  - maybe we have so few dependencies we could just not use slices package,
    generics; and keep these dependencies back + setup ci to do gccgo.
  - but fair point/question: no one asked to run on these platforms, maybe we
    could wait for the first person that asks "hey i have an $X machine that i
    want to run sigsum on"
  - rgdd thinks that makes sense
  - nisse: unclear if it's worth it / how much work. not high priority right
    now.
  - elias: in some ways its about creating public infra that's useful for
    everyone, so it could be a signaling point to fix this
  - nisse: would probably prioritize a c library higher than alfa/spark
  - filippo: and it's just the verifier that needs to be portable
  - rgdd will put some of the above notes into the issue -- thanks!
- elias: still working on "Ansible v1.3.0" milestone
  - https://git.glasklar.is/groups/sigsum/-/milestones/20
  - https://git.glasklar.is/sigsum/admin/ansible/-/issues/50 solved thanks to
    filippo's litetlog fix -- thanks!
- elias: debugged issues related to rate-limiting
  - https://git.glasklar.is/glasklar/services/sigsum-logs/-/issues/42
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/118
  - https://git.glasklar.is/sigsum/core/log-go/-/issues/109
  - spotted with test submissions, supposedly well above what we're using
  - turns out rate limit counter is ticking up too much
  - elias has been debugging this a bit, see above
  - let's talk more in the other section
- rgdd: took care of sigsum-go follow-up issues and MRs from jas, releases
  v0.11.1
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/112
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/113
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/236
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/237
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/239
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/240
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/241
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/242
  - and filed this for later (fix some nits spotted by mandoc):
    - https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/114
- rgdd: looked around a bit wrt. the matrix-slack bridge issue we're having,
  just emailed patrick with some ideas to see if we can figure it out
  - (it would probably be easier to debug if we were running our own bridge)
- filippo: v0.4.3 litetlog, including the fixes we discussed. Deployed it to
  milan, my dev witness.
- filippo: talked with the TF folks, keeping in touch with plans etc. Let's talk
  more in the other section. At the same time, thinking about what makes most
  sense for me to do and not do.
- ln5: been looking at /logz data from currently (today) running bastion.gis
  - short summary: 99.5% of log lines are debug info; some IP addresses are
    redacted, some IPv6 addresses are not; some PING and "received DATA" look
    interesting, need to take a pass over the code
  - more details in https://pad.sigsum.org/p/pg4KvaCrhte0evfHyEeh (lmk if you're
    interested in the methods section as well)
  - filippo: IP addresses are not redacted because they're truncated, not sure
    why there are truncated log lines at all. Seems like a bug in the log
    pipeline.
    - ln5: ah, yes the longest i've found is '\[2001:67c:8a4:100::' and assuming
      /64 (or shorter netmask) that's enough for not pointing out an endpoint to
      attack
    - ln5: and ipv4 addresses are redacted completely, using '\*\*\*'?
  - filippo: the pings should be random bytes, it's random bytes in the ping
    pong.
  - filippo: the base64 stuff is signature, it shows a little bit of the
    response. E.g., armored witness BLA + base64. Interesting that's an end
    stream. That would be useful to debug in general for connection reuse. Don't
    think signature and checkpoint is sensitive. Even error message for the
    log-witness protocol should be fine. So filippo doesn't think the data is a
    problem. But the truncation is a problem, will need to look into that.
  - conclusion: IP addr redaction needs a little more work; still missing an
    understanding of what to expect when signing up for running litewitness (via
    a bastion or not); still not done analyzing data

## Decisions

- None

## Next steps

- elias: do something about rate-limiting problem
  - https://git.glasklar.is/sigsum/core/log-go/-/issues/109
  - short-term fix may be to simply make sigsum-submit poll less frequently?
  - elias: prio one: do something to not get the checker alerts, short term fix
  - rgdd: reduce the --timeout?
  - elias no there's two problems, when rate limit is hit then we have the try
    again large number of times until the 10m limit. But that's something that
    happens when we hit the rate limit. Elias is talking about why we hit it in
    the first place. When we do one test submission, the counter is increased by
    more than 1.
  - let's talk more in the other section, elias will do $something
- rgdd: finalize one more manpage generation nit, then release v0.11.2
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/245
- rgdd: (still) join the conversation at https://github.com/C2SP/C2SP/issues/115
- rgdd: (still) catch up on the latest messages on sigsum-general
- rgdd: move comments into issue (see above)
- ln5: more /logz; want help with "a taxonomy of witness operators" to make sure
  we're talking about the same thing when we say things like "the expectation of
  privacy for a witness operator should be foo"
- filippo: look at truncated ip address
- nisse: might be involved a bit in the rate limit debugging, otherwise no next
  steps right now

## Other

- elias: related to https://git.glasklar.is/sigsum/core/log-go/-/issues/109
  - can we get detailed enough info from trillian about the add leaf status?
  - there seem to be 3 different states after we try to add a leaf:
    - the leaf is not yet seen as existing (but we did try to add it
      already)\<--?!
    - the leaf is existing but not yet sequenced
    - the leaf is existing and sequenced, everything is done, we are happy
  - https://git.glasklar.is/sigsum/core/log-go/-/blob/main/internal/node/primary/endpoint_external.go#L18
  - https://git.glasklar.is/sigsum/core/log-go/-/blob/main/internal/db/trillian.go?ref_type=heads#L92
  - seems to elias like there is three different states, and the problem we have
    is with the first state. "We tried to add this leaf before, but trillian is
    not saying that the leaf exists yet. A few seconds later, trillian will say
    it exists".
  - can we distinguish between these cases? Maybe if we look more carefully at
    the different result codes.
  - rgdd: table of unsequences leaves, table of sequencews leaves. The latter
    the trillian log signer populates on the clock, e.g., every 100ms takes up
    to 1000 leaes. This is configured in the seasalp config.
  - rgdd, nisse: there should be more details in the trillian responses, start
    by looking there if there's more we can do
  - filippo: maybe ask the trillian folks? rgdd thinks we should be able to
    resolve it ourself, and that we should try first and if we $fail poke them
    after that.
- filippo: public witness network repo status
  - what's the status of making the repo of markdown table of witnesses, machine
    readbale list of logs for witnesses, etc?
  - remember say conersation with general alginment on direction, but then maybe
    not enough resources to work on it right now
  - rgdd: summary is: kfs and I talked to Patrick and Al
    - there should be a machine-readable list somewhere
    - maintained by some community members
    - witnesses can apply that configuration
    - the TrustFabric team are very busy now with Tessera and other things
    - not on the top of their list to work on this now
    - for us, it's not critical that this gets done immediately
    - let's revisit in 3 months and see what has happened regarding resources
  - filippo: looked at how things are devloping
    - for adoption it's pretty important to have that list as an entry point
    - there are folks making their own logs, they will have their own idea of
      how things should work
    - it's important to have something to catalyse that
  - rgdd: I don't think it's that urgent
    - if you want to point to something you can point to the Glasklar witness
      about page
  - filippo: it's different to just say "here is a witness", compared to saying
    "here is a list that you can be included in"
  - rgdd: counter-question: where is the documentation for how to build your own
    transparency log right now? there is no such documentation?
  - rgdd: the system is evolving, but I don't think there is so many people
    involved now that it's not possible to talk to eachother
  - filippo: there is a chicken-and-egg problem
    - what is the way for developers to get involved?
    - rgdd: they can open issues in gitlab and so on
    - rgdd: they can send an email asking to be added
  - nisse: it's good to have 3 different examples forst before you do the
    abstract thing
    - so not urgent to have the list right now
  - filippo: I'm worried about the chicken-and-egg problem
  - rgdd: I'm not worried about a chicken-and-egg problem
  - rgdd: I'm not worried about getting the witnesses part
  - nisse: if we reach out to TrustFabric in 2 months and they can still do
    nothing then, then we might need to do something
  - filippo: it seemed like Q4 this year was when they would have time
  - rgdd: Fredrik is on vacation now, away 2 weeks
  - filippo: you have not convinced me that there are no problems with a 6
    months delay
    - people like to "join a thing"
  - nisse: what would it take to get som commitment or SLA for the
    ArmouredWitness witnesses?
  - rgdd: I don't think we are in such a rush that 2 months delay is a big
    problem
  - rgdd: let's think some more about it and then pick it up again
