# Sigsum weekly

- Date: 2024-10-01 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- ln5
- nisse
- filippo
- rgdd

## Status round

- filippo: gave the talk last friday. Went pretty good. Got plenty of interest.
  And some questions around what is the difference with CT. Need a coherent
  story to why not build ontop of CT. SCTs=compromise for solving a technical
  problem that we have solved if it ever existed. Separating the entity creating
  the entries and the log operator -> not how to mentally model. Because most
  systems don't have that.
  - got some interest from folks doing voting tech; who need a bulletin board
    thing. That hit a spot. They said they need a bulletin board, and how they
    build it in their poc is "it is a server that takes all values and promises
    to give them all back".
  - filippo thinks maybe we should make a bulletin board proof of concept app.
    Here's an ansible thing you point at a VM and now you have a bulletin board.
  - nisse: easy way -- use sigsum + a web server.
  - api: submit, retrieve, maybe some associated data which is app specific.
  - anyway -- there's interest in this!
- filippo: chatting with folks about how to structure the talk at
  transparency-dev summit. So that we're not repeating the same things. Filippo
  would want to talk more about end-to-end transaprency systems if
  andrea/martin/al can cover witnessing. Want to basically say "build monitoring
  systems not logging systems"; because people need to hear it.
- filippo: dropped notes from meetups.
  - signed note proposal:
    https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/81#note_20029
  - tombstones:
    https://git.glasklar.is/sigsum/project/documentation/-/issues/60#note_20028
- filippo: there's a PR in c2sp for a thing we discussed at the meet-up. Making
  SHOULD instead of MAY (reject invalid signatures from known keys). Reasoning
  in the PR.
  - https://github.com/C2SP/C2SP/pull/106
  - Need feedback on it to move forward.
- filippo: some local work on litewitness, didn't push anything yet.
- nisse: New witness protocol now implemented in both log-go and sigsum-witness,
  and deployed for poc.sigsum.org
  - Would be awesome to get the litewitness up to speed as well
- nisse: Added info page, e.g., https://poc.sigsum.org/jellyfish/
- nisse: Reached out to trustfabric on interop testing. Also filed:
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/78
- nisse: ready to release?
  - Dependency bumping would be nice if there's time.
  - filippo has a suggestion, let's talk in the other section
- ln5: we have the new stable log running (mostly). Curious to hear what we
  should be prioritizing now. What stands out: we're lacking witnesses.
  - https://seasalp.glasklar.is/get-tree-head
  - rgdd: restart and it should start using my witness.
  - ln5: want me to setup a !poc witness?
  - something to run on + plug in the provisioned yubihsm would be what's needed
  - this stable log, is the goal of to point other ppl to it? Am available log.
    And collecting as many witnesses as we can? So folks can do their own trust
    policy? Is the goal to attract ppl to do something meaningful with it?
    - (No notes -- but long term yes. Short term a stable log is a prereq to do
      any of the follow up work. Like getting more reliable prod witnesses etc.
      We're not quite there yet though.)
  - Correct that we will not be able to upgrade software in time for us to point
    linus' AW to this log instance?
    - Seems like no, because we reached out too late to trustfabric.
  - Anything we can borrow for how we setup our witnesses / communicate that?
    - Is question how to convey the value of the marginal extra witness; or tlog
      tech in general?
    - It's about documenting operational details so i can make some kind of
      judgement. Is it a good or a bad witness.
    - Filippo thinks if you don't trust the org -> you don't care about getting
      witnessed about them.
    - I might trust them, but not the technical team for example.
    - The world of "audits" and how they argue about compliance is probably
      status quo. And not particularly convincing / good job in many cases.
    - Filippo: just a technical writeup saying what you do -> already a point
      that you have your technical stuff together.
    - ln5: audit way of thinking about it feels useful. Ideally all audits have
      an output on the same form.
- ln5: I am running one of the armored witnesses. I would like that one to
  witness our log, obviously.
- rgdd: rubberduck for ln5 as he deploys seasalp.gis
- rgdd: released sigsum-ansible v1.1.0 after some input from ln5
  - https://git.glasklar.is/sigsum/admin/ansible/-/blob/main/docs/docsite/rst/CHANGELOG.rst?ref_type=heads#id8
- rgdd: fixed some sigsum-ansible nits. WIP changelog:
  - https://git.glasklar.is/sigsum/admin/ansible/-/blob/main/docs/docsite/rst/CHANGELOG.rst?ref_type=heads#id7
- rgdd: have an initial outline for my tdev summit talk. Slides will appear here
  (so far only pushed template):
  - https://git.glasklar.is/rgdd/tdev-summit-24

## Decisions

- Decision: Cancel next weekly on 2024-10-08
  - Because most of us are travelling to the transparency-dev summit

## Next steps

- nisse: log-go v0.15.x release, draft announce email:
  - https://pad.sigsum.org/p/sJUHFXAOS4Vgzl1OvPAu
  - would like to do it rather soon so we can update seasalp to the released
    version
- rgdd: flesh out a slidedeck from my outline; ensure it makes sense / some
  practise
- rgdd: if time permits, something related to seasalp docdoc
  - https://git.glasklar.is/glasklar/services/sigsum-logs/-/issues/16
- filippo: litewitness tag. Is it worth running a poc one even if it is not a
  long-term one?
  - It doesn't hurt, might help with dev.
- filippo: preparing tdev talk, and how to run witness break out (if i'm the one
  running it)
- filippo: would like to show up with an end-to-end example. The go one sort of
  exists. Maybe age end2end would be nice. Think I want to do that.
  - rgdd suggests these prios:
  - 1. litewitness
  - 2. tdev talk you're happy with
  - 3. bonus if end2end age example
- ln5: put an onion on seasalp. I wonder if I should bother with getting an x509
  cert for it, just for fun. But seems like no, not right now.
- rgdd: look at https://github.com/C2SP/C2SP/pull/106

## Other

- Go version numbers -- any questions?
  - https://git.glasklar.is/sigsum/core/log-go/-/merge_requests/172/diffs#note_20030
  - filippo and nisse will talk async in MR
- Discuss goals for tdev summit
  - Let's do this the day before summit, evening dinner!
- ln5: report-back from R-B summit (if time permits)
  - push to the next time if that's okay
