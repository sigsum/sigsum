# Sigsum weekly

- Date: 2026-04-07 1215 UTC
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
- filippo
- tta
- florolf

## Status round

- elias: per-log bastion now running for barreleye test log
- elias: filed issue for litebastion related to the per-log bastion usecase:
  - https://github.com/FiloSottile/torchwood/issues/69
  - only using ipv4 at the moment, due to that
  - probably a minor thing, perhaps elias can provide a PR
  - input from filippo before elias do anything -> helpful, just to know its
    wanted
  - name that resolves to ipv4 and ipv6, and listen with that name; what
    happens?
    - elias did not try this, but will try
  - filippo doesn't remember what UNIX does, if it listens on both; then maybe
    that's the recommended way to do it. Otherwise send PR.
- rgdd: mainly review and other input (e.g., wip sign-if-logged blog post)
- tta: passed deadline for paper work (looking for funding for AT work), will
  probably have funding june-november. Planning to make use of things that
  already exist, e.g, Sigsum!
- tta: making progress on my notes of what i'm trying to build, will be sharing
  in the sigsum channel soon and/or during the weekly. Still need to clarify
  what gets verified by end user and what gets monitored.
  - rgdd is happy to take a look, just post in the channel!
- filippo: blog post on quantum computer stuff
  - https://words.filippo.io/crqc-timeline/
  - people are responding a lot, taking quite a bit of time!
- filippo: starting work on go 1.27 work, pulling me away a bit
- filippo: chatted with MTC (Merkle Tree Certificates) side: ML-DSA, timestamps.
  They seem happy with the simpler version where MTC just doesn't have a
  timestamp for the subtrees (which is mostly an MTC thing, or other application
  that needs that kind of space saving).
  - rgdd: we need a public issue / somewhere to point ppl towards so we can
    gather input
  - filippo is working on fixing this (PR to tlog-cosignature)
  - filippo: tlog subtree cosigner equivalent of tlog-witness (or addition)?
    Something the MTC folks are asking for. Endpoint to request these subtrees.
    It occurred to filippo: we don't have a good way to represent them, and it's
    probably not checkpoints?
  - filippo will file an issue to keep the discussion going
- filippo: for awareness: thinking about if it makes sense for Geomys to do
  merkle tree cert CA operation

## Decisions

- None

## Next steps

- elias: setup per-log bastion for seasalp log
- rgdd: provide input to academic paper stuff, Chalmers
- rgdd: input to filippo, nisse, others; mostly just input this week for me
- filippo: c2SP PR + issue (see above)
- filippo: witness network per-log issue, see other sect. below
- tta: finnish writing SUMMARY.md doc and share in sigsum channel until next
  week

## Other

- nisse: Design of a witness proxy; would fit in the big picture in a similar
  place as a third-party bastion, but aware of the witness details and doing a
  lot more work on behalf of the witness operator. See
  https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2026-04-01-witness-proxy.md
  - a.k.a. '3rd party bastion' as opposed to / as a complement to per-log
    bastion, i.e., a different deployment option with other trade-offs
  - florolf: has been thinking about something similar
  - rgdd: on this note, reminder per-log bastion support in witness network
- florolf: if a witness configures per-log bastions automatically via
  witness-network.org, the witness will try to connect repeatedly?
  - yes. need to avoid too frequent hammering, have some backoff.
  - https://github.com/transparency-dev/witness-network/issues/32
