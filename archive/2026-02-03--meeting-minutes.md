# Sigsum weekly

- Date: 2026-02-03 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: nisse
- Secretary: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- rgdd
- florolf
- nisse
- gregoire

## Status round

- nisse: First iteration of sigsum-c library is ready; no more features planned
  in the near future.
  - current state: what nisse thinks is important for the library, not expecting
    features in the near future
  - regarding backends: certainly doable, but not high prio on nisse's list atm
  - florolf is fine with nettle, but context -- buildroot (appplication) people
    usually like it if they already have a crypto library they don't want to
    pull in another one. So that's where the request was coming from.
  - nisse: it was built with this in mind, so if there are MRs / use-cases ->
    reach out
- nisse: Filed a couple of torchwood issues based on external review of witness
  and bastion, fixed bugs in sigsum repos.
  - https://git.glasklar.is/nevun/tlog-code-review
- rgdd: prepped roadmap based on the input from last week, see decisions
- rgdd: attended fosdem real quick fri evening / sat morning
  - preached about tlogs and witness cosigning (as you would expect)
  - met some familiar faces :-)
- rgdd: more sigsum-c review (and unfortunately did not come through 100% before
  gk had to start look, sorry about that nisse)
- rgdd: bouncing named policy blog post with elias
  - will probably be available today / later this week
- rgdd, ln5: in the middle of hashing out witnessing with high availability
  - e.g., reviewing DDoS things and such on our sites
- florolf: not much happened on my side, also looked a bit into sigsum-c. To get
  familiar as a whole rather than just a few MR as before. Looks cool.
- gregoire: think we're in the middle of updating bastion and witness, with
  latest torchwood version. A.k.a. we will be able to run a bastion properly
  from the actual upstream.
- gregoire: merged some changes in rust sigsum library
  (https://github.com/mullvad/sigsum-rs)
  - now there's full quorum logic
  - should make a release soon

## Decisions

- Decision: Adopt renewed roadmap until mid April
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/136/diffs
  - florolf, nisse, gregoire, rgdd: looks reasonable
  - rgdd: merge after ack from filippo (and doublecheck there is no other silly
    TODO left)

## Next steps

- nisse: ask gk to make the link public (not just if you have an account at GL)
- nisse: Make more progress on the tkey sign-if-logged
- rgdd: Look at William's email. Deploy per-log bastion for my witness
- rgdd: Figure out what I need to review in sign-if-logged, check with nisse
- rgdd: Make sure roadmap gets merged (get an ACK from Filippo first)
- rgdd: Continue witness SLA discussions with ln5
- florolf: will try to package sigsum-c for internal impl that uses sigsum-go
  currently (to verify proof); so it's a cross-compliation thing.
  - if something comes up -> will make issues / MRs
- gregoire: release of sigsum-rust
- gregoire: probably more per-log bastion with william
- nisse: figure out / fix so that we get sigsum-c and rust impl linked from
  www.sigsum.org/docs ?

## Other

- rgdd: a thought about sigsum-c that i discussed a bit with nisse the other day
  - context: we started out with wanting a c verifier for sign-if-logged;
    invented byte code stack machine thing to not have to do complicated things
    on tkey / in low level language. In the end we also implemented ascii
    parsing + verify in sigsum-c, by means of parsing, compiling policy, and
    then running the byte code machine. In this sigsum-c case, it's kinda
    redundant to go through the compile step + quorum byte machine step. So a
    thing that could stand out is: why go through that complexity, and maybe it
    would be nice to have a "simplest possible c impl" that folks can look at.
    rgdd also flagged this because review = harder when having to go through the
    compiler rather than just verifying straight from the parsed "defs tree".
  - the question: any thoughts on the way it currently is (or for how this could
    be) based on this context?
  - florolf: like the way sigsum-c is done now with not having two different
    code paths, i.e., that it always go through the byte code format
  - agree it is more to understand because need to understand the compiler
  - so from understanability perspective -- with rgdd on that point
  - but from correctness perspective, like that it's just one impl
  - and you can reason about these separately (compile, then verify)
  - florolf: an advantage of how it is structured -> have a policy compiler that
    you can use as a c library; can see how it is useful to not have the full
    blown policy compiler. That's a nice benefit of doing it this way
- gregoire: in named policy proposal, it says standard path is
  /etc/sigsum...that's only for linux. Is there anything for windows?
  - no / unclear what happens on windows
