# Sigsum weekly

  - Date: 2023-02-21 1215 UTC
  - Meet: https://meet.sigsum.org/sigsum
  - Chair: rgdd

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - rgdd
  - Foxboron
  - ln5
  - filippo
  - nisse

## Status round

  - nisse: Merged first version of sigsum-log and sigsum-verify tools. Working
    on witness client implementation in log-go + a basic sigsum-witness tool,
    want to test those together before merge.
  - nisse: Discussed tooling milestones with Rasmus.
  - nisse: Reworked secondary to not need the get-tree-head-unsigned endpoint.
  - rgdd: defined "DRAFT: " tooling milestone based on discussion with nisse
  - rgdd: read+discuss nisse's get-leaves proposal
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/29
    - tl;dr: no sigsum protocol changes, update internal endpoint; if we would
      like to also update the external endpoint in the future that would be
      backwards-compatible
  - foxboron: ansible documentation stuff + reviewing nisse's MRs, until next
    time gitlab pages so that ansible docs can be viewed
  - filippo: more thinking about log rotation + engage in issues/mrs.  Working
    on checkpoint proposal based on earlier discussion with rgdd.
  - filippo: playing with standing up a monitor for go checksum database

## Decisions

  - Decision: Next tooling milestone for nisse to focus on
    - https://git.glasklar.is/groups/sigsum/-/milestones/7#tab-issues

## Next steps

  - nisse: close #27, document the comments in !29 and merge
  - foxboren: ansible release, review with nisse
  - ln5: upgrade our stable log (ghost-shrimp) up to a recent version
  - ln5: write instructions and/or code for setting up availability monitoring,
    using checker
  - ln5: look into gitlab pages
  - filippo: checkpoint proposal, protoytpe witnessing, few other tlog stuff
  - nisse: sigsum tooling milestone + witnessing

## Other

  - Chair for next week (rgdd will not be here)
    - linus will chair next week
  - CI: MR to try build log-go on each sigsum-go mr, see
    https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/64. Would it
    make sense to also run the "ephemeral"-mode integration test? Intention is
    to have a warn-only job to detect api breaks or other subtleties break
    downstream.
    - Go ahead and build/vet stuff, if builder is to weak linus will bump up the
      resources available for CI.  Let him know.
  - Might be a good idea for nisse/rgdd to dog-food ansible stuff from Foxboron
    (after a quick read-up on ansible) when time permits; both to get another
    dimension to the review, but also so that we have a better understanding for
    what's actually in there.
    - Nisse will get started with this
  - gitlab pages, are they the appropriate tool for online docu? or should we
    simply push markdown to a doc/ directory? note that i might be misremember
    things and gl pages are really useful; RESOLUTION: ln5 looks into setting up
    pages, which is sphinx rendering to static HTML (which ties into Ansible
    Galaxy using RST documents, which sphinx can use as input)
  - reminder that Richard wants a two week heads-up for when a first release is
    due
    - defer poke until next week to see if we are ready to poke or not
  - Reproducible Go builds with a tlog https://beta.gobuilds.org
