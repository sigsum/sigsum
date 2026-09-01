# Sigsum weekly

  - Date: 2026-09-01 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: tta
  - Secretary: rgdd

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - nisse
  - quite
  - warpfork
  - patrick
  - mw
  - rgdd
  - filippo
  - gregoire

## Status round

  - nisse: Me and florolf identified a sigsum log poisoning issue. See https://git.glasklar.is/sigsum/project/documentation/-/work_items/97. Is there some easy way to reject bad public keys (low order)? From a quick look, I found no utility function for that in the crypto/ed25519 package.
    - easiest way would be to use filippo.io/ed25519... think there is an option to do the additional low order verification; but it's not easy to do fast.
    - https://github.com/FiloSottile/edwards25519
    - multiply cofactor
    - ed25519 validation rules, messy.
    - nisse's thinking: it's rather serius and ought to be fixed
    - filippo, will control of public key let you do arbitrary signatures anyway?
      - nisse did an initial analysis
      - everyone that has knowledge here: please read and see if it makes sense (!97)
  - nisse: Playing a bit with tiles format, to better understand how it works.
  - tta: 20 days left to prepare a demo of me work archive transparency :o)
      - happy with ideas being more clear
      - started to write a detailed "observer workflow" that looks like a spec:
https://codeberg.org/openrip/project/src/branch/main/notes/2026-08-25-015-observer-workflow.md
      - last week, build 2 missing pieces that I want to use:
          - python bindings for sequoia-pgp-agent (b/c I want OpenPGP hardware tokens)
          - small lib to build reproducible ZIPs (b/c is a need that keeps coming up)
            - quite remembered seeing this: https://pypi.org/project/rpzip/
            - yes, I'm using this, but ended up needing more precision: they are doing
              stock CPython ZIPs which has ambiguities in how time is stored, because
              ZIPs have DOS 2-second precision time as default, rounding implemented in
              different ways by writers (ex: go) +sometimes extra UT/NTFS fields in
              local file headers/central directory/sometimes both (or not) read != by
              different readers, etc -- took 3-4 days to understand/clarify all these
            - mostly it was an exercise for me to clarify how exactly I'm going to ZIP
              files that contain cryptography+will be hashed later. ZIP files without
              compression are a choice already used in archiving (see WACZ as example)
              because ZIPs have been around forever (but, for example, WACZ spec do not
              bother at spec-ing what their ZIPs are, it is implementation defined)
        - warpfork: suggest you decide outloud if you're hashing {the packed thing} or {the semantic content} and what those accomplish.
          - if your goal is reproducible observation of something that's not already packed, you might want the latter.
          - tta -- agree, but also a longer discussion topic than what we can do now
        - filippo: would be nice to get a reproducible zip out of this
  - quite: implemented doing multiple cosignatures in litewitness, using optional additional mldsa-44 key. Paired with support with sigsum-agent for additional mldsa-44 key. Not sure yet how workable, setting up some log to try it out with is in progress
    - witnessing and logging in general: noticed litewitness is not required to be configured with log public key; but sigsum's log require witness pubkey
    - rgdd explains that delete key is essentially "unconfigure log but without forgetting log state for the given origin"
- warpfork: tlog-addenda spec draft v0.2: https://hackmd.io/@warpfork/Sy5MbSVdMl/edit

      - substantial rewrite from previous; more worth your time now :)

      - includes concrete description of message format.

      - probably the smallest amount of structure possible (based on last week's feedback)

      - should be backportable to static-ct -- iff we introduce some configuration; currently this is not included per a "YAGNI" stance, but it could be added.

      - think i will turn this into a c2sp.org PR soon, any feedback would be helpful

      - `AppendIndex(entry []byte, offsets []uint32) ([]byte, error)`

      - `ParseIndex(entry []byte) ([][32]byte, error)`

- patrick: (Need to leave early)
      - Chalmers folks have reached out to us again re sigsum paper, we will follow up with them
      - Will discuss more also w/ tta w.r.t. AT
- rgdd: submitted a lightnight talk to TDS 2026
  - CSP for TDS 2026 is closed, more than ~20 submissions
  - everything is in review & website is in process to be updated
  - short week, started to look into sigsum v2 again & witnessing
  - bunch of new requests to be included in the witness network
    - some LLM spam & some real people
    - the witness network seems to work as expected, removing pain from operators
- fillipo:
  - also looked at the witness network submissions
  - done misc. MTC stuff and still wip MTC CA
  - admin+work+ETooManyTasks currently saturating bandwidth +too much context switch
  - fips work
- mw:
  - some last things in our witness group deployment
  - started looking a bit at sign if logged
    - planning to add pgp support
  - next step from last week, was to ask jas about go version and mldsa in stdlib vs separate dependency from deb point of view
  - jas answer: they don't really care, they have it packaged for go 1.26, and higher  (e.g., 1.27) than that they can get it from the crypto libraries. I.e., it's some poor's maintainers headache (and he refers to himself).
  - if they need to buid from 1.26, then they ensure to package that dependency.
  - 1.27 is not an additional headache, it's already available for packaging
  - just go up to 1.27 seems fine, it's the working plan for filippo now



## Decisions

  - None

## Next steps

  - rgdd: will try to take a loog at tlog-addenda, and to page in more sigsum/v2 things with nisse
  - filippo: 1.27 for mldsa from stdlib in litewitness + tag/release
  - tta: continue on AT, talk to Patrick, talk to warpfork, write & code
  - nisse: will be working on sigsum/v2 things

## Other

  - warpfork: offer for tta: i've cranked out "the git treehash, just that" as a single file, in several langauges: it's easy, i recommend; if you decide to go with a logical hash approach I'm happy to drop links or port it again. I'm interested, hit me up :)

      - golang: https://github.com/warptools/gittreehash

      - rust: https://github.com/warptools/gar/blob/main/src/gittree.rs

      - highest order bit: these are both *literally* single file :D

  - log poisoning possible using invalid public keys?
    - discussed in sigsum matrix room 2026-08-31 and above issue
  - quick question to filippo wrt participation requests @ witness network now that we have high bw
    - https://github.com/transparency-dev/witness-network/pull/53
    - we're happy to merge these 3, rgdd will click the merge button
    - 1% of staging bw is fine
  - warpfork: reminder that RB summit is happening
  https://reproducible-builds.org/events/gothenburg2026/
    - tta is going
    - warpfork is probably going but just remembered about it this morning
    - elias is at least going
      - tta: can i have my charger back that i forgot then? thx!
      - yes
    - maybe someone more
