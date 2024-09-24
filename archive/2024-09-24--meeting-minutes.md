# Sigsum weekly

- Date: 2024-09-24 1215 UTC
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
- nisse
- filippo

## Status round

- nisse: hacking on the witness protocol. Did get some things working last week,
  and now trying to split it up in pieces and get those pieces look prettier.
  - %-wise to get things merged and be done so far?
  - a little bit stressed because not so much time left until tdev
  - cosignature thing that's in review now, and then its the actual witness
    things in sigsum-go (client-server http things); and then rather minor
    change in log-server.
  - hopefully doable to get it done this week, so the release things can happen
    next week
  - current plan is to have day-off on friday. So will be here tomorrow and
    thursday.
- filippo: don't have much to update today. Mostly a go focused week.
- rgdd: ~10 MRs in our ansible collection. A few highlights:
  - add ssh-agent protocol support in the sigsum role
  - molecule tests for primary+secondary setup, and primary with sigsum-agent to
    access (soft) key
  - docdoc improvements
- rgdd: opened an issue or two in log-go of docdoc things i was missing when
  hacking our our ansible collection
- rgdd: found a fix for the excessive trillian logging issue linus reported
  - https://git.glasklar.is/sigsum/core/log-go/-/issues/87
- rgdd: planning/syncing log deployment with ln5

## Decisions

- Decision: Bump golang version to 1.22 right away
  - It's available in debian backports and testing. See
    https://packages.debian.org/search?keywords=golang-1.22&searchon=names&suite=all&section=all,
    https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/201
  - filiipo +1, 1.21 doesnt get sec updates anymore
  - rgdd +1 as well

## Next steps

- rgdd: add support for rate-limit file in our ansible collection
- rgdd: clean-up old meta and doc things in our ansible collection
  - https://git.glasklar.is/sigsum/admin/ansible/-/issues/17
- rgdd: prepare changelog and do ansible collection release
- rgdd: run on poc.so with agent
- rgdd: try to move log deployment forward, depends a bit on ln5's availability
- rgdd: start preparing my transparency-dev talk
- filippo: same next steps as last week
- filippo: talking at topics in applied cryptography, will test brining a tlog
  talk. And try to present it to a mostly more academic audience and see what
  happens.
- nisse: hack more on witness impl
- nisse: do the go version bump

## Other

- nisse: Cosignature type in sigsum-go: Drop keyhash from the struct, or split
  into Cosignature/CosignatureBare? The key hash makes the struct rather
  inconvenient for code handling checkpoint-based cosignatures. Context: draft
  MR https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/200
  - seems ok, if needed we can also revisit more later
