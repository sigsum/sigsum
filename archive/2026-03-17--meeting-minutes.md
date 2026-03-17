# Sigsum weekly

  - Date: 2026-03-17 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: gregoire
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - elias
  - rgdd
  - gregoire
  - nisse
  - filippo

## Status round

  - rgdd: put together some sigsummy notes with suggested reading links
    - intended for ambitious readers that want to learn about the details -- not an 'easy' or 'quick' read
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2026-03-16-sigsum-reading-suggestions.md?ref_type=heads
  - rgdd: fyi: notes from 'transparency' session by ln5 @ tor gathering
    - https://onionize.space/2026/sessions/tsigs/
  - rgdd: fyi: notes about Tor Browser auto updates + transparency integration
    - https://onionize.space/2026/sessions/tb-auto-updates/
    - looks like it's not very much work needed to use sigsum there
    - gregoire: could be interesting for updates of mullvad browser as well
  - rgdd: went through the feedback in tta's pad + filed some issues
    - https://pad.sigsum.org/p/qqZN2UhFSwYTFnoYwwJ9
    - (also got ack to persist the 3x pads from last week + the 1x pad above)
    - lots of good comments and suggestions there
  - rgdd: at Glasklar we are making progress on our upcoming high-availability witnessing deployment
  - elias: configured test witness using per-log bastion config --> it works
    - (configured my own test witness, now configuring mullvad's log.)
    - rgdd: also configured per-log bastion for mullvad's new test log
  - nisse: have been working on the TKey sign-if-logged thing
    - see the Other section below
  - rgdd: have been trying to figure out if there are objections to moving to version one of the tlog-witness spec, see below
  - filippo: attended Real World Crypto, talked to people about witnessing there
    - showing people how to intergrate their things into the witnessing ecosystem
    - there is a proposal for web transparency (waict)spoke 
      https://github.com/waict-wg/waict-transparency-spec/issues/29
    - spoke to a researcher working on "incrementally verifiable computation"
      - using zero-knowledge proofs
      - relevant for verifiable indexes
        - could be self-verifying
      - rgdd: how to get started with zero-knowledge proofs, any reading suggestions?
        - filippo: I would ask the C2SP steward (Jack Grigg / @str4d)
  - filippo: spoke with Mozilla about publishing witnessed checkpoints
    - rgdd: are they interested?
      - filippo: they want to, not sure if they have time yet
      - rgdd: I would have expected them to do things with MTC
  - filippo: about MTC (merkle tree certs) I presented remotely at IETF:
    - https://datatracker.ietf.org/meeting/125/materials/slides-125-plants-pruning-mtc-00
    - created figures using https://excalidraw.com/
  - filippo: have been chatting with Al about post-quantum signatures
    - the scope for that expanded a bit because of possibility to merge with merkle tree certs
      - more in Other section if we have time
  - gregoire: moved our log to the staging list
  - filippo: about encrypted memory, turns out you can observe values by physically observing memory, you can build a dictonary
    - https://tee.fail
    - bad news
    - nisse: I talked to someone about that, seems shaky
    - filippo: if an attacker can attach a logic analyzer to your bus, then the attacker can do a lot
      - filippo: still better than nothing, but disappointing
  - filippo: all the attestation stuff is pre-quantum
  - filippo: https://github.com/C2SP/C2SP/issues/175#issuecomment-4074193803
  - filippo: C2SP self-serve tagging
    https://github.com/C2SP/C2SP/blob/main/.github/CONTRIBUTING.md#tagging-new-versions
      - you create a file and check it in
        - it does not introduce any new auth mechanism
          - if you can add a file, you are also allowed to add a tag in this way
          - the tag is added automatically
  - filippo: we now have a new website for C2SP
    https://github.com/C2SP/C2SP/tree/main/.website
    - it has a mechanism to stay up to date with the git repo
    - if you go to https://c2sp.org/tlog-witness

## Decisions

  - None

## Next steps

  - rgdd: persist 4x pads with tta conversations
  - rgdd et al: tlog-witness tag, and tlog-witness clarification?
    - https://github.com/C2SP/C2SP/issues/214
    - https://github.com/C2SP/C2SP/issues/175
    - ...and we also have a few more open issues and PRs in tlog-* namespace, would be good to get this prioritized.
    - filippo: happy to tag it
      - filippo: we should pin the version that we refer to for tlog-cosignature
    - filippo: the format of the signature returned in the response, one cannot change
    - rgdd: pinning the major version makes sense
    - nisse: when specs are updated we will have to think about to what extent changes are backwards compatible
    - rgdd: do you want to do the tagging?
      - filippo: can you do it?
        - rgdd: ok, I will do it
    - filippo: there is a new tagging bot
  - rgdd: virtual walk with filippo
  - elias: sigsum ansible release
  - nisse: more sign-if-logged stuff
  - filippo: tagging of c2sp
  - filippo: meta-next-step is to figure out what's next
  - filippo: will be at AtmosphereCon next week

## Other

  - rgdd: any +1s or objections to v1.0.0 tlog-witness spec?
    - https://github.com/C2SP/C2SP/issues/175#issuecomment-4069048125
    - if not would like to see this move forward
    - Not discussed further -- we already covered next steps above
  - nisse: sshsig support in sign-if-logged, (openssh-style)
  https://git.glasklar.is/sigsum/apps/sign-if-logged
  https://git.glasklar.is/sigsum/apps/sign-if-logged/-/issues/1. Main options:
      - 1. Host only logic. Sigsum log the "Signed Data" blob, see https://github.com/openssh/openssh-portable/blob/master/PROTOCOL.sshsig. Pro: Device app need not be aware. Cons: Need tooling to prepare the blob to be logged. More indirection on monitoring side.
      - 2. New signature type in device app. Pro: Easier UX, for both signer and monitor. Cons: More code complexity in the code handling the secret signing key. Have to decide how to configure name space, could be viewed as part of the signature type, and hashed into the key generation.
      - Draft MR for first alternative: https://git.glasklar.is/sigsum/apps/sign-if-logged/-/merge_requests/12
      - nisse: if you sigsum-log the special blob, then a monitor needs to do more
      - filippo: implications for context separation?
        - filippo: could e.g. only allow signatures for a certain signature type?
    - filippo: the most interesting part here is separating context
      - rgdd: called namespace in ssh
      - filppo: and that requires option 2?
        - rgdd: if you want to bind it tightly, yes.
      - filippo: tighter namespace sounds like a good property
      - nisse: I'm not so worried about the complication in running the signing tool
        - nisse: value in making monitoring simple
        - nisse: also value in keeping device app code simple
      - rgdd: I'm worried about complexity when it comes to explaining things
      - nisse: it will get unwieldy if we have many different signature types
      - nisse: I have an MR for the alternative 1, will try to make an MR for alternative 2 as well.
  - filippo: more about post-quantum signatures?
    - if we define a formate that's acceptable for a signed message, then we have a chance at not having two different code paths
