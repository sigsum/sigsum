# Sigsum weekly

  - Date: 2026-09-08 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: gregoire
  - Secretary:

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - rgdd (first 15m)
  - tta
  - gregoire
  - nisse (async only today)
  - quite
  - warpfork
  - filippo

## Status round

  - rgdd: mainly TDS program things (and other things) past week, not much to report.
	- a lot of submissions and soon the final schedule is done, program looks exciting!
  - tta: busy with writing part 2/3 of new archive transparency story / observer workflow spec
    https://codeberg.org/openrip/project/src/branch/main/notes/2026-08-25-015-observer-workflow.md
  - tta: settled on WIP implem for gpg-agent integration & ZIPs moving forward now (no public URL yet)
  - tta: started work (again) on impl aformentioned story (for demo in 2 weeks) +vibecoded sigsum-py v2
  - tta: new admin work to get 4 more months of funding after november (TBD may not be successful)
  - nisse: Updated notes on hybrid signatures in sigsum, https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2026-08-26-hybrid-sigs-in-sigsum.md
  - nisse: Continued playing with tile format prototype; generation of inclusion proofs seem to work, consistency proofs close to working.
Work on the proposal should be done before the meet. And we
  defer decisions if new information against the decision is raised (unless it
  can clearly and quickly be agreed the new information doesn't change the
  decision, even though the information maybe should have been considered). The
  chair doesn't do the decision, but they call it on "enough" consensus. If
  someone thinks there isn't enough consensus, or that there are still parts of
  the proposal that benefits from more discussion -> that's a
  - quite: litewitness can now make and deliver multiple cosignatures, with mldsa-44 key that it uses through sigsum-agent. Also interop with Tessera, with a policy requiring ed25519 and mldsa-44 signatures (from same witness endpoint), and getting those 2 signatures over the checkpoint. This works on Tessera from main branch as of now, thanks to some fairly recent changes.
  - so far no tests, but it's on-going
  - about bastions:
    - the log says "this is where I accept connections to my bastion" and the witness connects to that bastion & uses that to communicate with the log, and there's authentication of the witness on the bastion side
      (currently with the same key as the witness key)
    - does bastion authentication needs ML-DSA-44 soon? -> it's not high up in the list, these signatures are not long lived, and an attacker breaking the key can at worst do DOS so PQ migration is not urgent (it will)
    - likely the witness use of the bastion should have a separate key from the witness key (and that bastion key is not that important, it can be stored on disk, it's just for authentication) but for now it's the same key
  - warpfork: no much things moved forward this week
	- got feedback on addenda draft, still need to absorb it
  - fillipo: some sunlight & witness operation stuff that needed to happen (doing stats, etc)
    - haven't got any time for dev, still swarmed with admin / people on-boarding
    - hopefully this week the clouds will go away and will be able to make progress

## Decisions

  - None

## Next steps

  - rgdd: same as last week ("take a look at tlog-addenda, and to page in more sigsum/v2 things with nisse")
  - tta: finish writing AT v1 observer workflow 3/3 and move to 100% move-fast-build-things to rush demo :o)
  - tta: follow-up on new inbound contact (a smartcard engineer interested to contribute to AT, human this time)

## Other

  - q for filippo: torchwood release soon?
     - the joys of monorepo makes gives more administrative work around the release unfortunately
     - will do soon
