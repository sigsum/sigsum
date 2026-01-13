# Sigsum weekly

- Date: 2026-01-13 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: elias
- Secretary: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- rgdd
- elias
- gregoire
- nisse
- filippo
- florolf

## Status round

- nisse: Merged sigsum-c quorum evaluation.
- nisse: quorum bytecode spec in review,
  https://git.glasklar.is/sigsum/core/sigsum-c/-/merge_requests/7
  - needs a few more edits before merge
- nisse: wip on policy and proof verification:
  https://git.glasklar.is/sigsum/core/sigsum-c/-/tree/wip/policy-parse. Trying
  to get more pieces in place, and at the same time split of parts that seem
  solid into their own MRs.
  - just made a small MR with checkpoint formatting things
- nisse: sigsum-go quorum refactor:
  https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/293 in review
  - (rgdd: sorry for the delay -- will look after the meeting.)
  - this is based on what florolf described a while ago wrt. evaluating
    timestamps with quorum weighting
- florolf: got some stuff done during holidays!
  - finnished first draft of spicy c library (low resource version of sigsum-c
    basically -- it's an experiment)
  - this is not final, still in discussion
- florolf: Sigsum tlog-tiles mirroring
  - sigmon can now mirror a sigsum log into tlog tiles, mostly for archiving but
    now could also use tlog tiles to query a sigsum log based on that
  - didnt publish code yet, want to polish a bit more
  - but mirroring both stable and testing logs on a vm right now
- florolf: SSH CT blog post
  - https://blog.n621.de/2026/01/ssh-certificate-transparency/
- rgdd: mainly review
- rgdd: fyi: starting next week a consultant will do a bit of code review in
  litewitness, sigsum-agent, yubihsm-dependency, sigsum-go offline verify, and
  sigsum-c
- filippo: mostly holiday and go work. Finally updated age sigsum signatures, so
  if you go to age you'll find sigsum.md with same pubkeys as before. But with
  sigsum-generic-2025-1 policy. How did this? Went back and resigned everything.
  It's an interesting question, we should write some docs aobut. I.e. how you
  change policy. When you make a sig for a log, signature does not say which log
  is being submitted to -- correct? Yes. So that means, someone could cross-post
  between two logs? Yes, assuming you know preimage (but that's often public).
  In this age case, made sense to just go back and resign. Because they were out
  there anyway, and had to stand by them anyway since its the same pubkeys.
  - (opt 0: rotate key -- the other three options are when keeping the same key)
  - 1. only submit new release to new log, not old ones
  - 2. go back, resubmit everything using normal sigsum-submit tool
  - 3. extract signature from old log, migrate it to the new log (essentially
       write a sigsum-migrate tool)
  - filippo decides to keep key, for key continuoty
  - filippo decided not to only do the last release, cause would be releases
    logged out there that could be added to the new log
  - so two optoinS: write sigsum-migrate or use sigsum-submit
  - decided to use sigsum-submit, because doesn't matter if its a fresh
    signature, or if it's the exact signature
  - florolf: standard ed25519 -> should give exact same result right?
  - florolf: signing should probably be deterministic in this case
  - filippo -> anyway, this stuff; this is worth writing up
  - you probably want ot keep same pub key
  - but then also need to stand by everything that was in the old policy
  - and that probably means you want to resubmit
  - (either copy or resubmit)
  - filippo: as an experience, was easy enough; but it took a bit of knowledge
    and details to know the right strategy
  - (on ed25519 -> if you follow spec it is deterministic, but there's no way to
    know to check if it was done correctly or not without knowing the private
    key.)
  - (vrf -> given a signature there can only be one pubkey; and only the one
    with private key an have generated that signature. This is not a property of
    regular signatures. There have been issues related to this in ACME.)
- filippo: some ctlog archiving and sunlight stuff -- pretty ct specific. -
  https://c2sp.org/vrf-r255
  - https://github.com/FiloSottile/age/blob/main/SIGSUM.md
- gregoire: mostly vaccatoin on our end, not a lot of updates
- elias: working on blog post about named policies, not done yet
- elias: added meeting calendar on sigsum contact page, in case folks want to
  follow it and didn't find it / know that it existed. It's mainly these weekly
  meets there though, but can be helpful when there's e.g. cancel decitions.

## Decisions

- None

## Next steps

- rgdd: more review (prio 1: sigsum-go, prio 2: sigsum-c)
- rgdd: (still) redeploy litewitness with latest ansible + poke william for
  per-log bastion config
- rgdd: (still) page witness blog post back in
- filippo: read api of tlog witness
- filippo: going to play with usb armory, because very annoyingly ct uses same
  tree for signing tree head and every single sct -> need 100s of signatures
  every second from primary key. Which is a bad design. MTC won't have that
  problem (tillitis stuff etc). But today, everyone just have plain keys on
  disc. Not about about that, so want a stronger story for the key. Want to see
  if can make it fast enough (i.e. 100s per second). I did consider yubihsm, but
  it's not fast enough. Might write it for this with tamago now, and later can
  run it on sev-snp (amd's thing).
- filippo: look at nisse's c2sp.org tlog-proof pr
- filippo: will unblock the litebastion issue gregoire mentioned below.
- florolf: in the context of spicy, if have system verifying offline proofs.
  Folks talked about policy migration today, and in the case of spicy. The
  proofs are very specific to policy blob being used. Still haven't fully though
  about how policies will evolve over time, esp. with devices that are offline.
  Device sitting on a shelf for a year. When witnesses change too much or log is
  lost -> your lost in worst case. But many shades of gray in between. So
  question -- how to migrate without breakage that's black and white like that.
  So trying to figure out how to stay alive. Thinking about this, and would like
  to write it down and think about / discuss it.
  - filippo: at very core, there's unsovlable tension if there's a break glas
    mechanism.
  - florof: this was one of the factors i though of, some break glas key and
    that's proibably how i'd built it too for a customer
  - filippo: suspect we would have that in go too
  - filippo: so basically, think break glas is acceptable as long as they're
    documented and acknoledged to break transparency
  - nisse: for gradual updates, would need a proof that satisifies different
    policies
  - florolf: to retrofit/integrate, could ship/know that you ship proofs for
    different policies. And client picks out proofs based on the policy it
    likes. Would be one way to do it in an abstract way without requiring
    anything.
    - filippo, some options:
    - 1. proof format that matches multiple policies
    - 2. make multiple proofs available
    - 3. say what policy you have before you have the proof (this is the one web
         pki is exploring now -- comes with interactive and privacy challenges)
    - this is "trust anchor negotiation" in web pki if you wanna read about it
- gregoire: still working on litebastion thing, currently blocked on being able
  to listen on !localhost.
- nisse: more of the same (sigsum-go, sigsum-c)
- elias: file issue in project/documentation about documenting policy change
  based on the above notes
- nisse: PR to limit tlog-cosignature timestamp to 63 bits.

## Other

- [skipped due to lack of time] nisse: We've been talking about REUSE in the
  general setting of glasklar repos. Question for sigsum: Make sense to try it
  out, starting in the new sigsum-c repo? Quoting a different document:
  - Pro
    - It is used by Tillitis, to make CRA compliance easier. See, e.g.,
      <https://github.com/tillitis/tkey-libs/blob/6dfdfcb0d2eeef09e4dc201e5bca423ddab1186f/libcommon/udiv.c#L1>.
      It will require us to be a bit more explicit with copyright ownership of
      contributions (compared to current AUTHOR files that refer to git history
      for details on who contributed what).
  - Cons
    - Slightly more book-keeping. Additional header lines in each file (but just
      a few lines, not a complete license notice).
- nisse: When looking again at verifying checkpoint cosignatures, I notices a
  slight impedance mismatch. In
  https://github.com/C2SP/C2SP/blob/main/tlog-cosignature.md, the timestamp is
  an arbitrary uint64. While log.go says that timestamps (and other decimal
  values) can be at mot 2^63 - 1. In our code, I think when sigsum-log-primary
  asks a witness for a cosignature, if the witness responds with a timestamp
  where bit 63 is set, then the log server gets into trouble when producing a
  get-tree-head response with that cosignature.
  - filippo: what time ranges will have issues with this?
  - nisse: it's far in the future
  - filippo: and a witness setting that bit -> misbehavior now, right?
  - nisse: yep
  - filippo: we could update spec, it would be backwards compatible to clarify
    this
  - nisse will file a PR on c2sp.org for filippo (filippo is happy to take a PR)
- elias: in notes
  https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2025-12-23--meeting-minutes.md
  there is a link to slack.com gives "You need to sign in to see this page"
  - (elias would prefer a public link if it's possible)
  - (filippo: we don't really get to decide where feedback is provided)
  - https://transparency.dev/slack/ if anyone wants to sign up to read that
    feedback
  - elias: one option would be to crosspost the feedback
  - actually andrew wrote almost the same thing in a replicated place
