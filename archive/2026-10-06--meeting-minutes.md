# Sigsum weekly

  - Date: 2026-10-06 1215 UTC
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

  - rgdd
  - tta
  - mw
  - nisse
  - warpfork
  - quite
  - filippo
  - elias

## Status round

  - rgdd: TDS was a blast!
    - Program: https://transparency.dev/summit2026/schedule/
    - Live stream can be watched after-the-fact on the transparency-dev
      youtube channel
    - (Eventually the talks will probably be chopped up into videos from
      the live stream)
    - Would like to highlight for the people following the contributors
      in this group:
      - Setting thresholds in witnessing cosigning (Lucia)
      - tlog-addenda: an adoptable standard for log-adjacent data,
        mirroring, and redaction too (eric)
      - Archive Transparency (tta)
      - Simplicity through transparency: how the PQC migration is
        streamlining sigstore (hayden)
      - The diff between sigsum/v1 and sigsum/v2? (rgdd)
      - The sign-if-logged tool (nisse)
  - rgdd: did together with nisse and mw very quick and dirty drafting
    of a 'sigsum-v2.md' that's meant to be incomplete, imperfect, and
    something we need to iterate on. It's mostly TODO notes as we were
    cutting and pasting a bit in the current 'log.md' doc.
    - Nisse will be moving this forward so we have something imperfect
      to iterate on together
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2026-10-03-sloppy-sigsum-v2-sketching
  - rgdd: new mailing list 'tsc' for transparency.dev /
    witness-nertwork.org governance stuff
    - probably to be moved to lists.transparency.dev instead of
      lists.witness-network.org?
    - elias is debugging why the 'reset password' email is not being
      sent correctly
      - elias: it turned out that we need to do an additional step
        to create each user before they can do 'reset password'. Those
        accounts have been created now, so now it should work.
  - tta: this week I'm applying for a 4-month funding extension for AT
    fingers crossed!
  - tta: vibecoded sigsum https://dev.archive.rip/ggs/only-vibes/pysigsum_bindings
    (not sure what to do of it, for now I'm using to work in python mostly)
  - nisse (and the rest of us): summit last week, that was fun!

## Decisions

  - none

## Next steps

  - rgdd: will be out of office for the next two weeks, back 21st oct
  - rgdd: take a look at my witness-network / c2sp / email backlog
    before end of day
  - nisse: give review to mw and quite
  - nisse: sigsum/v2
    - Specs <-- 1st prio so we can iterate on it together, but needs 1st imperfect stab
      - Open questions
      - sigsum-go library and tool prototyping
      - log prototyping, incl backend
  - warpfork: tlog-addenda immediate v2??  i think we all already agreed
    sigsum/v2 / "identity" (tangent, i don't like this name) format and
    addenda should hug.  details: tbd.
     - ...maybe to discuss more post rggd return :)
     - nisse: addenda can be for each leaf, it could also be useful to
       have some way of adding things that apply to all leaves?
       - warpfork: will think more about that
         - nisse: you are adding some "well-known" file anyway?
         - filippo: in sigsum, the only thing that probably would have
           the addenda is the receipt.
           - for the well-known thing, it could be usefull to define
             more general log-metadata too, like a logs own vkey etc.
           - It would be nice if sharding was easier, for expiration.
             - rgdd: index-based is the robust approach.
             - warpfork: this sounds like a lot of complexity for a
               garbage collection problem.
               - filippo: having to scan the whole log means you need to
                 parse every entry.
               - a bit open-ended discussions about mtime-based sharding
                 vs tile-based.
             - nisse: there are other ways too, ref-counting.
               - filippo: with that you need to get your databases in
                 sync.
      - warpfork: we should have a meeting to hash things out once rgdd is back from OOO.
  - elias: start using new torchwood version 0.10.0 for glasklar litewitness deployments
  - mw: openpgp for sign-if-logged, witness deployment hardening, packaging
    - asked jas about debian packaging
  - quite: continue with deployment related things, mldsa etc. Also
    re-test our parallel signing on hw; it had to be rebased.

## Other

  - nisse: sigsum-go releases... We will most likely need breaking
    api changes to support additional signature types. I'd suggest:
      * make a sigsum-go 1.0.0 release reasonably soon
      * continue developing on main branch, making v2.0.0-dev.X tags
	until we are happy with the new api and we can make a v2.0.0
	release
      * when needed create a v1 branch for bugfixes to the v1.0.0
	version.
      See
      https://stackoverflow.com/questions/53344471/taking-a-repository-to-v2.
      As I understand it, there must be a "/v2" on the module
      path, but creating an actual v2 subdirectory is not required, and
      I would really like to avoid doing that.
      - confirmed by filippo.
