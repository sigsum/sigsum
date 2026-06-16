# Sigsum weekly

- Date: 2026-06-16 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: elias
- Secretary: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- elias
- nisse
- mw
- rgdd
- Patrick (NYU)
- Justin Cappos (NYU)
- tta

## Status round

- nisse: Progress on tkey-sign-if-logged unit tests
- nisse: Initial man-pages for sign-if-logged (see
  https://git.glasklar.is/sigsum/apps/sign-if-logged/-/merge_requests/29).
- nisse: Considering a sigsum-c 1.1.0 release. Changes: cosignatures are now
  sorted by witness key hash, and new configure option --disable-tools. (Some
  other changes I'm considering, see other section)
- nisse: Almost all procedural hurdles cleared for
  tlog-policy https://github.com/C2SP/C2SP/pull/233, but looks like
  .github/MAINTAINERS.md now lists @BenBirt as the only maintainer. Possibly
  related to missing C2SP membership?
  - rgdd: email filippo about the maintainer issue
- rgdd: tried prometheus metrics in litewitness
  - many good things already there, gave thumbs up to the MR
  - has been merged, so now there is metrics in litewitness
  - have added metrics for log-go also, a few new metrics there
    - including things like how often each witness has responded successfully
    - also metrics related to latency, how long it would have taken to reach
      quorum
    - changed naming of metrics in log-go
      - added documentation for that in log-go handbook, metrics part there
- elias: working on glasklar witness group deployment
- tta: bit etoomuch things going
  - still has to talk to non-tech ppl next week about transparency, haven't
    managed to start slides
  - but a blog post, half-finished -- where for now I explain the "why" of
    transparency, wants to talk "how" now
    https://dev.archive.rip/ggs/openrip/project-notes/src/main/notes/2026-06-13-003-about-transparency.md
    - if you read things that looks bad or unexpected, please tell me! (will
      send the link later again)
- Patrick: A few questions after reading the AT/OpenRIP document summary. Unsure
  if these design points are still being worked on or unclear in the doc. (tta:
  it's still very much WIP everywhere, yes)
  - How are mirrors trusted/authenticated? Is it via some sort of centralized
    directory service or do they vouch for other mirrors? Is it possible for a
    "fake" majority of mirrors to be created to sink the reputation of the
    legitimate mirrors? (tta: yes, very good questions, answer for now is TBD)
  - How does a user discover the mirror which has signed a specific manifest for
    online verification? (TBD)
  - What is the intended/anticipated time scale of AT? Decades, centuries,
    proton-decay, etc. (+/- 50yrs)
  - tta: for now prototype stage. Goal when building something new: if project
    dies tomorrow, then at least have the artifacts we produced -> stays
    verifiable.
  - tta: for mirrors, public key part of integration. User pick mirrors they
    like. Orgs will be able to run mirrors. "If you want to use my mirror ->
    here's what you should configure".
  - tta: happy to talk more, e.g., after the meet / at other time when there's
    more time
  - patrick happy to follow up more at another time, yes
  - elias: note: in this context mirror is the party that holds the data.
    - so trusting the mirror is trust it in the sense of availability
    - but tta is not talking about this trust distinction when pitching AT
  - justin: very happy to help with the "sigsum for kids" or similar. It's a big
    part of what we're struggling with / the main characters.
- mw: working on glasklar witness group deployment
- gregoire: We're going to to update our infra (servers to -26). Will include
  witness and maybe the logs. Will announce downtime on the respective mailing
  list.

## Decisions

- None

## Next steps

- rgdd: will make sure that Glasklar collects metrics both for witnesses and
  logs
- rgdd: CFP for Transparency Dev Summit
- rgdd: if anyone needs something from me, please tell me
- tta: away next week (won't be on the sigsum weekly). Mostly prep for the talk.
- nisse: working towards sign-if-logged release
  - think it will be wrapped up early next week, and properly signed release
    thursday next week
- elias, mw: keep working on glasklar's upcoming witness deployment

## Other

- nisse: sigsum-c changes I'm considering * somehow drop or deprecate the \*idx
  argument from sigsum_key_map_lookup? Feature no longer used, and currently not
  tested. * improve error reporting for sigsum_proof_verify, we now get the same
  error messages for problems with submitter's leaf signature and the log
  signature. * mw: sounds good * elias: consider asking florolf, might have good
  input
- elias: related to question before about git forges and things. A project
  that's about a decentralized approach to that: radical. Are you aware of this?
  - yes
  - interested to get in touch with ppl connected to that?
  - might already be connected, but another connection would be good
