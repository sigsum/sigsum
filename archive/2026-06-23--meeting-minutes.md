# Sigsum weekly

- Date: 2026-06-23 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: rgdd
- Secretary: gregoire

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- rgdd
- Justin Cappos
- mw
- filippo
- nisse
- Patrick
- gregoire
- warpfork

## Status round

- nisse: Merged https://github.com/C2SP/C2SP/blob/main/tlog-policy.md (still
  considering follow up MR to disallow single-member groups).
- nisse: working on sigsum-ci and signed-if-logged releases before going on
  vacation
- rgdd: been working on prometheus alerts and exporting scraped prometheus
  metrics
  - https://git.glasklar.is/glasklar/infra/site-ansible/-/merge_requests/17 ←
    alert manager alerts
  - https://git.glasklar.is/glasklar/infra/site-ansible/-/merge_requests/18 ←
    exporting prometheus metrics
- rgdd: and a ansible role that submits fresh data to a witness uptime monitor
  log
  - https://git.glasklar.is/glasklar/infra/site-ansible/-/tree/main/roles/sigsum_periodic_submit?ref_type=heads
- mw: working on glasklar witness group deployment
  - ansiblifying deployment using debian packging
  - for the parallel signing with multiple YubiHSMs
- filippo: gophercon eu + geomys summit
- filippo: designed how to do the architecture of geomys production witness +
  geomys CA
- Patrick: will be talking with tta on archive tranparency. More sigsum
  question after. Planning on attending the transparency.dev summit
  - rgdd: CFP openning hopefully this week. Will share once available
- Justin Cappos: had a conversation with Elena. Working on common way to write
  about tlog
- gregoire: OS update on witness, went almost OK. Next, upgrade logs. First
  staging, then production (probably next week)

## Decisions

- None

## Next steps

- nisse: Planning to cut releases on Thursday (when I'm back close to my signing
  key). See https://git.glasklar.is/sigsum/core/sigsum-c/-/tree/v1.1.0-rc.0,
  https://git.glasklar.is/sigsum/apps/tkey-sign-if-logged/-/tree/v1.0.0-rc.0,
  and https://git.glasklar.is/sigsum/apps/sign-if-logged/-/merge_requests/31
- mw: continuing work on the witness group deployment
- filippo: release of torchwood still needed
- filippo: working on implementing the MTC CA, ML-DSA support in torchwood,
  mirror in sunlight
  - rgdd: any progress on c2sp website?
  - filippo: some progress. defininively on the next steps
- rgdd: wrap up prometheus metrics and alert
- rgdd: after that, not sure
- rgdd: roadmap due for this week. Very small update noting holiday and back
  in August
- rgdd: if anyone need something from me happy to page it in
- Patrick: working on / talking about archive transparency
- gregoire: log-server update

## Other

- None
