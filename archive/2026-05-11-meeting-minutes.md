# System Transparency weekly

- Date: 2026-05-11 1200-1250 UTC
- Meet: https://meet.glasklar.is/ST-weekly
- Chair: quite
- Secretary: rgdd

## Agenda

- Hello
- Status rounds
- Decisions
- Next steps
- Other

## Hello

- quite
- rgdd
- elias

## Status rounds

- Mostly meetup. But we solved
  https://git.glasklar.is/system-transparency/core/stboot/-/work_items/266
  - One idea is to first of all make stprov's checkURL make retries in the same
    way as stboot does when fetching ospkg.
  - spanning tree protocol (STP), something between switches to avoid loops
  - firsy 30s this switch doesn't forward things
  - usually works because OSes are not that fast, there are retries, etc
  - but here interface is picked up and stprov starts using it immeaditely
  - solution: on this port there is a host, we promise it's not a switch; start
    forwarding as fast as possible. This makes it ready in ~5s.
  - don't think we will do something about this right now in stprov, but
    eventually we will probably make it so that stprov and stboot have the same
    retry mechanism
  - more details in the above issue
  - quite might add an actual issue in stprov also -- but on pause for now

## Decisions

- None

## Next steps

- quite: continue with stprov @ st-demo, signing of new claims, etc
  - not blocked or in need of anything from anyone

## Other

- st-demo: maybe we can decide on a solution for its BMC getting an IP?
  - https://git.glasklar.is/glasklar/admin/-/work_items/29
  - elias agrees setting it statically can be a good idea
  - maybe ln5 has some idea of how he would like it to be configured
  - (not having to have a conf is nice..but here it might be OK to do it
    statically)
- new user in the st room writing a bit -- among other things hosting it's own
  matrix instance. And is looking to maybe run ST?
  - quite will respond that there's quite a bit of diskless deployment; but e.g.
    remote attestation is only poc right now (but it's on roadmap to get these
    kinda things supported and integrated in upcoming versions of ST)
