# Sigsum weekly

- Date: 2025-04-29 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- elias
- rgdd
- filippo
- nisse

## Status round

- elias: preparing NEWS for release of sigsum ansible v1.3.0:
  - https://git.glasklar.is/sigsum/admin/ansible/-/merge_requests/73
  - review NEWS before release?
  - looks good to rgdd on a read-through
  - nisse: improved testing is worthy news but not user visible, would be nice
    to structure it a bit
  - elias will wrap it up and close the milestone after creating a tag
- elias: added one witness for new barreleye test log
  - https://test.sigsum.org/barreleye/get-tree-head
  - context: discussed for a while to replace jellyfish poc log, and now we have
    barraleye. The idea/plan is to remove jellyfish now. Whoever was using
    jellyfish for testing, please use the new one. Since it was a test log, it
    shouldn't be a big deal that it disapears. There were some practical reasons
    why it was easier to remove it rather than keeping it alive -- this saved
    some sysadm cycles.
  - nisse: i think it would be valuable to have a staging log as well, which
    preferrably doesn't go away.
  - elias: yes, but we look at that as a separate issue that has not existed so
    far and we should add it, but it's separate from jellyfish/barreleye
- nisse: registered for cysep, poster here:
  - https://git.glasklar.is/nisse/cysep-2025
  - rgdd: we should consider maybe getting this into project/documentation repo,
    and also link the compiled poster from www.so/docs
  - rgdd: at least linkling form www.so/docs soonish would be nice
  - nisse: considers it work in progress until its been presented
- filippo: few things. Did renaming of the litetlog repo that i promised.
  - https://github.com/FiloSottile/torchwood/
- filippo: also added/exposed a bunch of APIs from the main package
  - https://pkg.go.dev/filippo.io/torchwood@main
  - extend tlog package, edge computation, checkpoint parsing, helpers,
    cosignature impl, ...
- filippo: and there's a tlog tiles client!
  - https://pkg.go.dev/filippo.io/torchwood@main#Client
  - "higher level sunlight static ct api client"
  - https://pkg.go.dev/filippo.io/sunlight@main#Client
  - should be useful for monitoring of static ct api logs
- filippo: different topic -- geomys (my comppany) now operates a ct log since
  friday!
  - https://sunlight.geomys.org/
  - local baremetal machine with a bunch of ssd:s
  - will announce ~later this week, waiting for some load from LE
  - read path impl: you might find it interesting
    - https://github.com/FiloSottile/sunlight/blob/main/cmd/skylight/main.go
  - basically had a bit of opportunity to do a bit of computer science,
    implemented my own rate limits and stuff like that + metrics. Everything has
    a metric.
  - headers for various stuff
  - health cheking (/health will only return 200 if all checkpoints of
    configured logs are more recent than 5s)
  - thinking about write path -- number of successful serailized certs per time
    unit...maybe alert on that. Not sure if I want to be woken up by a phone
    call for this.
  - the whole thing cost ~15k including operating osts for a year (hardware,
    racking, power, ..., etc. Will share this stuff on the mailing list when
    it's ready).

## Decisions

- None

## Next steps

- elias: decommission old jellyfish poc log, it will dissapear completely
  - https://git.glasklar.is/glasklar/services/sigsum-logs/-/issues/49
  - rgdd: sounds great, go ahead
- elias: update checker jobs to check new test log barreleye instead of
  jellyfish
- elias: remove jellyfish from https://www.sigsum.org/services/
- elias: release sigsum ansible v1.3.0, then close the milestone
- elias: would like old jellyfish test witnesses to move to barreleye
- nisse: witness barreleye, and update ST ci job that depends on jellyfish
  - rgdd: is poc being killed?
  - yes at some point, but to begin with elias will just kill the log
  - nisse will need to move his poc witness longterm
  - elias will sync with nisse about moving when there's a good time for that
- rgdd: make progress on public witness network / shared conf stuff
- rgdd: witness barreleye
- filippo: work a bit on the web pki, then spicy cli

## Other

- Issue posted by tabbyrobin:
  - "Split sigsum-submit into offline/online subcommands (prep/send)"
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/122
  - a question of UX interface design, should probably discuss it in more detail
    but not today
  - nisse will have this as his placeholder so it's not forgotten
- nisse: New barreleye test log, no witnesses yet. Should poc.sigsum.org/witness
  be switched to witness barreleye (current implementation of sigsum-witness can
  handle only a single log)?
  - elias: now added one witness for barreleye, the smartit.nu test witness
- elias: Glasklar log and witness "about" pages are marked DRAFT "until the end
  of April, 2025", last day of April is tomorrow
  - https://git.glasklar.is/glasklar/services/sigsum-logs/-/blob/main/instances/seasalp.md
  - https://git.glasklar.is/glasklar/services/witnessing/-/blob/main/witness.glasklar.is/about.md
  - we don't have any major feedbak that we have received, the only "nit" we got
    feedback on is that there's missing a bit of description for "physial
    security"
  - elias will ask linus if we an add anything about that
- elias: wrt. renaming litetlog, will the old name still work now?
  - yeah github just does redirect, so things are not expected to break because
    of that
  - for future releases, please use the new name though
  - but old ones will at least continue working
  - elias will update the name before making the upcoming ansible release
