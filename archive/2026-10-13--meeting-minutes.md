# Sigsum weekly

  - Date: 2026-10-13 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: elias
  - Secretary: mw

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - elias
  - nisse
  - quite
  - tta
  - filippo
  - warpfork
  - gregoire
  - mw

## Status round

  - nisse: Updated sigsum-go to require go-1.27.
  - nisse: Draft spec for sigsum-v2, see
    https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/152
    - intention is to merge that soon and then continue working on it
  - tta: end of 1st funding +demo of ATrans 27th November!
  - tta: wip refactoring my vibecoded sigsum python client/lib
    https://dev.archive.rip/ggs/only-vibes/pysigsum_bindings
    (would like to finish review & cleanup this month)
  - tta: on-going talks with founder of https://authenticmemory.org/
      - I would like to convince them to do less web3-blockchain-stuff
        (and adopt more of the value I see in tlogs for archival integrity)
      - split discussion between "join us!" and "why start a competing product?"
        (and I don't see myself as a product then but hey)
      - also me: need to find sources of funding for the next year.
  - filippo:been chatting with the go team to do updates to sumdb for
    mldsa signatures.
    - published an article about various post quantum things.
    - worked on the MTC implementation.
    - USB Armory is connected to what's going to be the final production
      witness, will probably be deployed in the coming week.
      - elias: will that be with mldsa signatures?
        - filippo: yes, possibly only.
      - <discussions about what this means for sigsum, would it break
	compatibility? Sigsum won't get mldsa until the next version>
      - filippo: we can always add ed25519 to the witness if it becomes
	necessary, but we're trying to do everyrhing pq-first.
      - elias: would this prod witness be part of a production list for
	the witness network?
        - filippo: yes
  - quite: working on getting mldsa/multiple signatures operational, the
    functionality is in, it needs to be deployed somewhere to test and
    verify, which we're also working on.
  - elias: like quite mentioned we're working on deploying ML-DSA, using
    versions of sigsum-agent and litewitness that quite has made.


## Decisions

  - none

## Next steps

  - warpfork: overdue to reply to comments on tlog-addenda spec pr.
    - needs to be louder and clearer about its optional nature,
      evidently.
    - more than one person missed that the spec is optional.
  - nisse: playing with changes to sisgsum-go to support additional
    signature types.
  - the plan is to do ML-DSA, and hybrid ML-DSA/Ed25519 the same way
    OpenSSH does it, some details on that is in the draft spec
    for Sigsum v2
  - filippo: minor, MTC and witness deployment.
  - filippo: then I will look at those quite's torchwood PRs.
  - elias: witness deployment things
  - mw: samw as ^^
  - tta: this week I'll think I'll continue my vibepysigsum!
    - mostly tracking the go upstreams, trying to not do anything fancy,
      reviewing the code, writing docs by hand.
    - would like to have something stable at the end of this month, a
      goal is to open source at the end of the year.

## Other

  - nisse: I have been thinking a bit about tile log backends, related
    to the sigsum v2 spec and if it should do full deduplication etc.
    - a tiled log server doesn't really need to have any of the
      entry-tiles locally
    - it probably doesn't need complete tile either
    - what needs to be available on the log machine are the partial
      tiles and the index.
    - means you can get pretty far with a 50TB server and you can have
      2^40 entries or more.
      - filippo: this is how sunlight is implementetd, all the tiles are
	stored into s3 and never ftched, the server keeps in mem just
	the right side of the tree, and loads the ritght side when it
	starts, loads it's own signature so it doesn't have to truest
	the storage. The one thing it has stored locally cached on disk
	is the deduplication index.

