# Sigsum weekly

- Date: 2026-09-22 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: nisse
- Secretary: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- rgdd
- quite (async only)
- nisse
- mw
- filippo

## Status round

- nisse: Who wants to review
  https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/318 (pubkey
  validation)?
  - nisse will ask quite to take a look, maybe filippo in-person on the summit
- nisse: Iterated on tds slides, see
  https://git.glasklar.is/nisse/tds-2026/-/blob/main/slides.pdf
  - not entirely done with summary at the end
  - the rest: pretty about about
  - rgdd will take a look wrt. feedback until thursday
- quite: continued good progress on mldsa in litewitness and our sigsum-agent
- mw: (tkey-)sign-if-logged, continued work on pgp support, changes to the
  wireformat to fit the things we need into exisiting messages, and adjustments
  for nisses work to get ecdsa point compression in there.
  - mw has one question to nisse, but can take it later or on thursday
- mw: witness group work, egress hardening, as well as sysctl kernel params
  hardening.
  - in fw for witnesses: which processes, groups, etc...are allowed to talk! 1st
    step of egress hardening. 2nd step, http proxy that prevents connections out
    to unexpected things.
  - what's sysctl kernel hardening?
    - sysctl params are read and set for the kernel, e.g., to control what the
      kernel can do. E.g., no program that doesn't run as root can get a
      debugger attached (one parameter). Or IPv6 root announcements -- if you
      have ipv6 network, then can say something like: on my subnet publish i'm
      the router for this address. Then dynamic IPv6 interfaces get a
      notification, and when address resolved....this kinda stuff we're tuning!
- nisse: noticed we have lacking unit tests for ssh sigs and namespaces, filed
  an issue
  - https://git.glasklar.is/sigsum/apps/tkey-sign-if-logged/-/work_items/8
- filippo: mtc dicussions and implementations. And eric's spec.
- rgdd: TDS program is published and ready
  - https://transparency.dev/summit2026/schedule/

## Decisions

- None

## Next steps

- rgdd: prep TDS talk, prep TDS welcome (the 'not a keynote talk' with martin
  and joe)
- mw: continue with sign-if-logged and witness hardening
- nisse: review mw/quite work, finalize talk, input to rgdd

## Other

- None
