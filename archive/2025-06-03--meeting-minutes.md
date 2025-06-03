# Sigsum weekly

- Date: 2025-06-03 1215 UTC
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
- elias
- nisse
- filippo

## Status round

- rgdd: fyi: transparency.dev summit cfp is now open
  - https://docs.google.com/forms/d/1A8hUFeoDlGkzCGZp6oDfBf5liK7qQ68rvFFRIkZNg8Y/viewform?edit_requested=true
  - The official deadline is August 31st, but we will be making decisions and
    accepting presentation proposals as they come in. So please do submit ideas
    sooner rather than later.
  - filippo: is there any opportunity to fund people to come to the event?
  - rgdd will bring this up / take a look; have been thinking about that too
- rgdd: reached out to al/patrick regarding witness configuration network,
  proposal that i'm hoping we can iterate from idea to prototype below
  - https://git.glasklar.is/rgdd/witness-configuration-network/-/blob/main/docs/proposal.md
- filippo: digging into akd, and the merkle patricia trie. Explained in a way
  that it's hard to grock, but when you get it's like 5 line spec. Extracting
  into a go impl, and will write up a mini spec of that merkle patricia trie. To
  use for verifiable indices.
  - rgdd is happy to look
- nisse: fixed restart issue with sigsum-agent and yubihsm connect, have an MR
  that linus has been trying and seems to work. Once merged will make a new
  release of key mgmt repo. Noticerd we are sloppy with news files and releases
  there, so will try to retroactively make some basic news entry for what i
  think are previous releases.
  - https://git.glasklar.is/sigsum/core/key-mgmt/-/merge_requests/25
- elias: thinking about / starting to use prometheus metrics from the test log.
  We have a prom server now so we can start to actually scrape.

## Decisions

- None

## Next steps

- elias: consider using prometheus metrics for test log
  - focus is mostly on other things right now
  - possibly named trust policy things
- nisse: key-mgmt release, will not think about named trust policy things unless
  poked by elias
- filippo: will try to finnish merkle patricia trie impl, have it all in my head
- filippo: same thing that i had last week (will look in the notes from last
  week)
  - nisse: vkey spec is probably one thing
- rgdd: review nisse's news MR, be responsible if al/patrick wants to talk
  witness config network; few more tdev summit planning things.

## Other

- nisse: cysep is next week, poster has arrived. Elias and nisse will most
  likely miss next week's weekly.
