# Sigsum weekly

- Date: 2024-10-22 1215 UTC
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
- ln5
- nisse
- filippo

## Status round

- nisse: Worked on tkey log signer proof of concept,
  https://git.glasklar.is/nisse/tkey-log-signer. Plan to revisit when we have a
  tkey with persistent storage to play with.
  - "Done for now"
- nisse: Wip on sigsum-key options to convert to and from note-verifier strings.
  - Sounds good to rgdd
- nisse: A couple of sigsum-go refactoring MRs merged or in review.
- filippo: virtual walk with rgdd, plenty of nice little things came up. I've
  written up client for tiled logs in go that uses the new range over func thing
  and does automatic verification and caching + optimization of avoiding partial
  tile at the end. Pushed to litetlog. So far only supports sumdb format, but
  will add a little switch to support sunlight and tlog-tiles. Want to use this
  to do the maps (log-backed map experiments).
- filippo: looked at akd (the whatsapp key transparency impl) code base and
  trillian batch-map code bases, to learn what they use for SMTs and if there's
  overlap to specify the same sparse merkle trees.
- filippo: litewitness v0.2.1, started debugging but nothing to report here yet
- rgdd: virtual sync-walks with folks, but mostly not here last week. Currently
  WIP planning for bot sigsum and ST.

## Decisions

- Decision: cancel weekly November 5
  - Because we have a meetup so most folks won't be here

## Next steps

- ln5: wrap up loose ends around
  https://git.glasklar.is/glasklar/services/sigsum-logs/-/issues/22 and get
  things actually released and deployed
  - current status is that all the fixes are running on sigsum-log-\* (seasalp)
    while on poc (jellyfish) none of them are
- nisse: next week only here mon+tue
- nisse: wrap up MRs that are in review, and expect to give feedback on
  planning. Besides that no solid plan on what's next. Apart from sigsum-key
  changes.
- rgdd: roadmap suggestion
- filippo: litewitness tag, test vectors; reach out to data trail and go through
  the notes from the summit and make sure i reached out to everyone i said i
  would reach out to. And if any time for it: continue with map experiments.
  (Will make client work for different tree styles, see status.)

## Other

- Pick filippo's brain on what he hopes/plans to work on (short+mid term)
  - Land witnesses -- take the time to talk to people and address what they need
    to start running witnesses (litewitness, witness in sunlight). Probably
    bunch of social cycles here.
  - The log of logs. If no-one else drives that. Aka "shared conf for
    witnesses".
  - So that's mostly short term.
  - Medium term -- excited about maps and want to build prototype. Maybe a spec
    for sparse merkle trees.
  - age -- deprioritize until we can make it a prototype for the map sandwitch?
  - named trust policy -- that probably we should do though? Don't think it
    makes sense to prioritize it over witnesses. If no-one picks it up after
    that, maybe in parallel with maps after witnesses?
  - nisse: maybe it would make sense to first do the thinking needed to get a
    default policy into the sigsum tools, and later generlize to named policies?
    - filippo: on the top of my head -- makes sense
- Why ppl call them patricia trees even if they have keys in each node?
  - right now most systems (with variations) -- they are compressed radix trees?
    Each intermediate node have a left and a right. Its saved in the database
    under its prefix. It stores the bits before the branch point.
  - but in patricia tree, it reduces storage reqs by not stroing the bits at
    all; next branch is at the 5th bit
  - patria tree paper from 1970s?
  - do we agree the storage format of all of the post-coniks (maybe patricia
    tree) is for an internal node -> it is the key to where you store that is
    the label that gets you all the way up to the nodes; and the bits of the
    compressed position; and then a hash for the left and a hash for the right.
    And leaf is a completely different node (remaining bits of the key + value).
  - sounds about right to rgdd
  - input on if filippo has patricia trees wrong -> helpful
