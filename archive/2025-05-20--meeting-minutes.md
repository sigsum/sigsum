# Sigsum weekly

- Date: 2025-05-20 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- elias missing this meeting due to Karlstad trip
- rgdd
- filippo
- nisse

## Status round

- elias: added gitlab milestone that could be part of upcoming roadmap
  - https://git.glasklar.is/groups/sigsum/-/milestones/22
- rgdd: drafty roadmap, hoping to work towards decision next week
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/109
  - several other things i'd like to put in the roadmap, but considerings
    there's also vaccation and nisse and i are also spending time on ST right
    now it's hard to bring more things in scope. It's probably a bit ambitious
    already.
  - anything missing in the highlights of what's been done since last roadmap?
- rgdd: i think design wise shared witness configuration is in a good place, but
  would like to do one more round of improving the presentation before
  circulating more
  - https://git.glasklar.is/rgdd/public-witness-network
- filippo: bunch of transparency stuff, including client library (torchwood).
- filippo: been itterating on ctlog deploymed with sunlight, ~done
- filippo: torrent for tlog tiles
  - nisse: for doing more or less one huge file? if you have tiles of reasonable
    size, maybe you want content addessable peer to peer thing to get tiles?
  - filippo: if you care about one tile -> you will http it. Torrent would be
    more to get the entire log. Filippo's theory -> this would be for ppl that
    want to fetch the whole log.
  - nisse: it's the use case nisse is thinking about too, but was thinking i can
    fetch one tile from one peer and another tile from another peer
  - filippo: but that's basically what torrenting allows
  - filippo: integration into client library is missing
  - torrent directly into the cache is the current idea (just data tiles, not
    the merkle tree)
  - torrent -> need to specify all the file paths, makes the torrent file huge
  - level 0, makes sense to hash a tile instead of fetching it
  - prewarm cache with torrent, all level-1 titles
  - asks client for an entry
  - by asking for an entry, it will check inclusion with a checkpoint
  - to do that, it needs hashes of the inclusion proof
  - the torrent solution -> makes it really nice to not "lose" old logs
  - rgdd thinks the abstraction is "warm up the cache", then use existing
    tooling (so shouldn't have to know the cachd was "warmed up")
  - so run torrent, it finnishes
  - hydrate the cache
  - then you can use it, but you can still serve the torrent from that directory
  - but: there's also how the log grows
  - torrent have a mechanism for this
  - files get deduplicated, can update torrent to new version
  - if careful, hashes will stay the same (in our case its append only so stays
    the same)
  - its even possible that if you're tailing the log, you don't fetch the new
    stuff from the torrent. You just start seeding the new torrent right away,
    because you have the files laid out in your cache the right way
  - both rgdd and nisse thinks this makes sense!
  - nisse, would have to look at the details though
- nisse: looked at elias' milestone, rather large list of concrete improvements.
  All on the sigsum-go tooling. Not sure if he wants to do some stuff on the log
  server as well, e.g., rate limit issues could fit as well. Will have to disuss
  when he is back.

## Decisions

- None

## Next steps

- rgdd: talk roadmap with nisse
- rgdd: talk roadmap with elias
- rgdd: talk roadmap with filippo
  - ideally thursday or later
- rgdd: queue up roadmap for decision next week
- rgdd: one more round improve presentation shared witness configuration

## Other

- nisse -- it was suggested a while back that sigsum submit tool should be split
  into subcommands for "online" and "offline" things. Does filippo have any
  useful feedback wrt this?
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/122
  - offline - e.g. sign on a separate computer
  - online - e.g. send the request to the log
  - filippo: to me makes sense to have in the same command
  - issue was aobut splitting up into subcommands
  - nisse: i'm biased to keep as is and not split up
  - filippo: think its a matter of preference, i don't do subcommands. Go likes
    small cli, and i'm used to unix tools. Some other ppl are very into
    subcommands. But I can't say i have a strong opinion.
  - if it needs to be split, then maybe two unix command would be better
  - is the difference going to be significant enough to do the engineering to
    fix?
  - sounds like maybe not, status quo wins - there's other stuff to do
  - we all agree there are other things that are more important, and maybe lower
    hanging fruit would be to improve the docs
  - nisse will politely close the issue
