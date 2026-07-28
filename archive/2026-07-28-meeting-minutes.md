# Sigsum weekly

  - Date: 2026-07-28 1215 UTC
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

  - <insert nickname here>
  - elias
  - mw
  - tta
  - filippo
  - Patrick

## Status round

  - tta: back from vacations! (last thursday)
    - before vacation a talk submission to tds was made, fingers crossed.
  - tta: resumed work on AT, many things are getting more concrete, from
    API drafts, to signing ops, to side-quests clarifying loose threads,
    etc. Need to invest time to produce a new set of notes / updated design
    overview, so I can give these to other humans and ask for feedback
    / review
  - tta: build a 50TB setup @ home (an ODROID H5 + a 3-disk RAIDZ1 array of
    40T + a 2-disk array of 10T) where I started to download items from the
    internet archive (using their own "polite" client) and started to probe
    how I can turn ArXiv into a local dataset (3M+ papers with lots of files
    & artifacts, "polite" bulk access with S3 requester-pays, up to $1000+
    of egress for the whole dataset, will first start on a 100$ scale)
  - tta: I think that ArXiv could be good for demo-ing, can work
    on their dataset without "from the start" spending time and $$$ on
    yet-another-impolite-crawler, and shows a lot of practical details
    (discrepancies between != artifact versions, already found between the
    bulk S3 bucket and live website, different versions, how to resolve
    metadata and links, large enough to exercise several observers +
    a big mirror, etc)
  - tta: maybe I should try with something else / cheaper too (but I don't
    want to be pure Internet-Archive)
  - elias: glasklar witness group deploy still ongoing
  - mw: same ^^
  - filippo: new release of sunlight with tlogging.
    - finished setting up a second witness.
    - will be added on witness-network.org.
      - for these we wanted USB armory to be in place before witnesses
        are deployed to prod.
      - https://github.com/FiloSottile/sunlight/releases/tag/v0.9.0
  - patrick: not much from our side other than working on the submussion
    to tds.

## Decisions

  - no decisions today

## Next steps

  - tta: need to find a way to reconcile the stated goal of AT as a project
    (AT idea -> prototype -> maintainable tool) and the current work copy
    (a collection of python scripts more or less disposable written with
    heavy LLM agent assistance) because I'm not satisfied with that situation
    - elias: is there something there htat others can test?
      - yes, but mostly output from 2 or 3 different llms.
      - will do cleanup, and chose what to keep before asking for "proper"
        review.
      - it works against local sigsum log/witness, not now I need to
        clarify what needs to stay.
      - current playground is there:
        https://dev.archive.rip/ggs/only-vibes/playground
  - tta: need to prepare clean human-produced and reviewable design docs
    to communicate to other humans :o)
    - elias and mw are still in the middle of the witness deployment,
      and will be continuing that.
    - filippo: ml-dsa implemnetaiton in torchwood, currenyly blocked on
      some infrastructure, Azure/intel/something.

## Other

  - no other topics today
