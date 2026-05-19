# Sigsum weekly

  - Date: 2026-05-19 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: gregoire
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - rgdd
  - elias
  - tta
  - nisse
  - gregoire
  - mw
    - we are looking into Etherpad issue
      - https://git.glasklar.is/glasklar/services/pads/-/work_items/10
  - florolf
  - filippo

## Status round

  - rgdd: commented on florolf's witness-network notes + concrete TODO suggestions
    - https://github.com/transparency-dev/witness-network/pull/42#issuecomment-4478271299
    - some ongoing discussion here for the interested
    - two things happening:
      - talking about the different log lists, if a 100qps list is good or not
      - considering tombstone messages
         - log would sign a tombstone message when log is about to shut down
           - witnesses would cosign tombstone message
      - next step could be to write a proposal, possibly "tlog-tombstone" spec, or similar
  - rgdd: nothing to report wrt. status sigsum 'next' stuff, messaged hayden yesterday
  - rgdd: sketched a bit on some potential new docs ('beyond testing'?, 'handbook'?)
    - not done and needs work
    - loosely based on some feedback from tta and jas (but not all of it yet)
    - nisse already commented that maybe what i'm really sketching on is a handbook
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/rgdd/beyond-testing/www.sigsum.org/content/beyond-testing.md?ref_type=heads
    - if anyone has input on direction -> let me know
    - could include practical things that are relevant for someone looking at what to do next after the existing "getting started" guide
      - how to think about trust policy
      - how to handle your keys
      - please tell rgdd if you have ideas on what should be included in "handbook"
  - rgdd: we received feedback on https-bastion -- as step one helped reply w/ context
    - https://github.com/C2SP/C2SP/issues/252#issuecomment-4479078972
    - need to specify encoding of Ed25519 pubkey
    - filippo and i need to take a look at a few should/must statements
  - nisse: Getting closer to sigsum-c 1.0.0 release.
    - worked with mw
    - API polishing for sigsum-c
    - getting ready to make a release this week, hopefully
  - tta: n/a (in-between vacations)
    - about the link that rgdd sent to sigsum channel
      - has lingo of "logs" and "witnesses", distributed system
      - not sure yet what to think about it
  - florolf: also posted to matrix, a quick hack for a pull-mode for witnesses (https://github.com/florolf/cross-examination)
    - pulls a checkpoint from a log
    - trying this for rekor logs and sigsum logs
    - main reason for doing that was that I wanted to write a tlog-tiles client (https://github.com/florolf/tlog-scales)
    - demo client that you can point at a log and it will talk to the log and construct something
  - florolf: changed config system for sigmon (https://github.com/florolf/sigmon/pull/12)
    - in sigmon, can now control which hooks are doing things in what order
    - would appreciate feedback from linus who ran into a problem that this should solve
  - Question: what lang is this tlog client in?
    - python
  - filippo: this week has been entirely Go 1.27
    - only hours left until the release
  - elias: preparing glasklar witness group

## Decisions

  - None

## Next steps

  - rgdd: continue poking various spec-related things
    - witness-network things, see status round above
    - "sigsum next" things with hayden
    - sync with filippo after Go freeze
    - candidate: maybe per-log bastion also in witness network?
  - mw: work on sigsum-c with nisse
  - mw: setting up witness group at Glasklar
  - nisse: sigsum-c release
  - florolf: will look at various comments that rgdd has dropped in PRs
    - also think about tombstone things

## Other

  - nisse: Trying out REUSE-annotations for sigsum-c (see https://git.glasklar.is/sigsum/core/sigsum-c/-/work_items/14 and https://git.glasklar.is/sigsum/core/sigsum-c/-/merge_requests/63). Unsure how to deal with this for CCTV test vectors and sigsum policy files. My understanding of the current state is that CCTV merkle test vectors are (C) rgdd and BSD 2-clause license, and published policies are (C) glasklar and also BSD 2-clause. Is this how we want it to be? To me, it seems questionable if these files are copyrightable at all. The REUSE FAQ lists some options for uncopyrightable files: https://reuse.software/faq/#uncopyrightable
    - some files are "data files"
      - e.g. files used for tests
      - should we claim copyright on those, or not?
      - rgdd: to me it stands out to put "glasklar" copyright, the copyright should belong to whoever contributes
        - nisse: right, we will have to add all contributors
          - that is how the REUSE thing works
        - florolf: "copyright the $foo project authors"
        - filippo: for my projects it's usually like that "$foo project authors" without specifying an authors list, instead just let people look at the git history
        - rgdd: if you need a copyright to belong to a certain person, then add that person
        - rgdd: working idea: put "copyright the $foo project authors" and check with Tillitis folks what they think
    - nisse: about timing: I will not aim to get this done before release, but we will do it as a later step
    - rgdd: what about the data files?
      - nisse: my understanding is that in other places the data files sometimes have copyright
        - if you think some files are really not copyrightable then you could put cc0 or something on those
  - rgdd: q for nisse: if you have a concrete suggestion about how to change copyright things, can you add it to my thing?
     - nisse: yes, sure.
