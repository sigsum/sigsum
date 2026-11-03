# Sigsum weekly

  - Date: 2026-11-03 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: rgdd
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - mw
  - nisse
  - tta
  - gregoire
  - quite
  - florolf
  - warpfork
  - rgdd

## Status round

  - nisse: Several parallel tracks:
      - preparing log-go release
        - release should be out within a day or two
      - extending sigsum-go with mldsa primitives
      - hacking on sigsum-v2 prototype, so far focusing on tiling machinery

  - tta: submitted to nlnet CodeSupply Restack a "Sigsum & TLogs in Python" proposal
    - submitted yesterday
    - answer is typically in a 2-3 months time (likely january)
    - fingers crossed! if approved it could give funding for 6-12 months
    - rgdd: would it have helped if you had a more formal Sigsum affiliation?
      - not sure, would need to ask nlnet about that
    - tta: nlnet have rounds about every 3 months
    - warpfork: an idea is to have a list of acknowledgments on Sigsum website
      - rgdd: a list of acknowledgments is on my wishlist of things I'd like to do

  - rgdd: tinkering with mTLS for log-go, sigsum's ansible, and glasklar's witness-g1
    - tested in Glasklar's infrastructure
    - considering adding support for mTLS in the log-go sigsum log server software
  - rgdd: been getting up to speed with proposals and various design docs
  - rgdd: been rubberduck:ing soft mldsa key management with quite and mw
  - rgdd, mw, elias: think it's new for this week that there's lists.transparency.dev?
  - rgdd: have read the tlog-addenda spec
    - (https://github.com/C2SP/C2SP/pull/353)
    - tldr: the spec is nicely written
      - one question: well-known url and hex of digest, s0 and s1 and then hex string
        - why s0 and s1 and why not none of them, or s0 s1 s2 or something else?
          - warpfork: that could be changed
          - nisse: another alternative could be to have a single long hash and leave it to the server to handle it
          - warpfork: i'd like to just add a standard webserver in front of it
          - rgdd: what are the limits?
            - warpfork: will need to check. i've been doing benchmarks
            - warpfork: have not finished the graphs
            - warpfork: preliminarily: it doesn't matter "a lot" on "good" filesystems, but it does matter due to hard limits in not-so-good filesystems (cough ext4).
          - rgdd: a question is who is adding entries to the log
            - if you have untrusted submitters when it may not be randomly distributed
            - might be worth clarifying that in the document
        - warpfork: we should do a v2 aligning with the "identity-leaf" spec
          - rgdd: hayden is not married to any of the naming
          - rgdd: if you have ideas of how to improve naming, please let me know
            - that would not be bike-shedding!
  
  - mw: infrastructure chores for glasklar.
    - mailing list things
    - lists.transparency.dev
      - https://lists.transparency.dev/mailman3/hyperkitty/list/tsc@lists.transparency.dev/
      - anyone can subscribe to that list, all welcome to do so!
  - mw: witness hardening work.
    - egress filtering

  - elias: been on vacation, and also worked on the same stuff as mw
  - gregoire: released a new version of sigsum-rust
    - https://github.com/mullvad/sigsum-rs/tags
  - quite: have been on vacation last week
  - quite: planning around how to handle soft keys on file for witness deployments
    - adding features in tools needed for that
    - https://git.glasklar.is/sigsum/core/key-mgmt/-/merge_requests/47
  - florolf: not much, but took a look at the Geomys new witness implementation
    - using USB armory, that filippo mentioned
    - we had a discussion a couple of months ago, it'äs pretty much that
    - one thing is that they don't verify signatures on the USB armoty
      - it's basically just a ratchet for checkpoints
      - if the USB armory does not verify signatures, a malicious host could move it into a state where it will not accept any new checkpoints
        - but that can happen anyway
        - losing non-repudiation property
        - has the witness stopped because the host got owned, or did a split-view happen
        - nisse: you need to have a mapping from origin line
          - need to know the authentic public key for each origin line
            - that's an advantage with self-authoenticating origin lines as in Sigsum
            - you would need to secure that with some CA infrastructure
        - florian: that's a consideration on top, if it verifies signatures
        - florian: there is also a difficulty if there are multiple keys, then which one to use for the origin line
      - rgdd: could be an optional thing, somewhere near where the vkey is
        - could go in the checkpoint spec
      - warpfork: about self-authenticating keys
        - if the threat model is that the host can cause the witness to advance
          - the host can just say "I have valid signatures for you"
        - florolf: you can view the log "as a witness too"
        - florolf: if you do the sigsum thing where the origin line is derived from the public key, the witness always needs to store the origin line anyway
          - then by definition the key used cannot work for another log

## Decisions

  - Decision: Add support for mldsa cosignatures, https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/154
    - we are starting to see witnesses that are using MLDSA
    - allow vkeys in the policy, making the Sigsum policy similar to a tlog-policy
    - have the log server collect signatures of different kinds and publish them on a different endpoint
    - client tools could then use the tlog-proof format
      - use extra line in tlog-proof
    - may be useful, you get the split-view protection more PQ secure
      - need to add stuff in tools that will be needed anyway for Sigsum v2
    - for the log server it would be a one-off hack to get things in, but not a big work, most would be in tools
    - florolf: I have read the proposal and I like it
      - it's a good tradeoff
      - you are getting many things you would have needed for Sigsum v2 anyway
      - looking forward to implementing the other side, in my monitor for example
    - tta: interesting to see how this affects my own usecases
    - rgdd: I also think the proposal looks good
      - rgdd: my main hesitation is, that I would rather have Sigsum v2 as quickly as possible
        - my worry is that some things will come up that will take more time
          - like making something backwards compatible
          - unclear who is actually asking for version 1.1
            -maybe the answer would be florolf who is using Sigsum for binary transparency
        - rgdd: I would like to go in a straight arrow towards Sigsum v2
          - and if a version 1.1 falls out for free, then take it, otherwise not
        - rgdd: I would like a "conditional accept" in that way
        - nisse: I think the main extra work here is the work to adapt log-go
          - rgdd: I am not so worried aout that part, since that seems rather easy
        - rgdd: what do others think of a "conditional accept" in that way?
          - florolf: I'm not sure what the timeline for Sigsum v2 is
            - in the past it has been "at some point we will have a v2"
            - florolf: filippo's view seems to be that every project needs PQ in some way, yesterday
            - florolf: Sigsum v2 is basically this plus some other things
            - florolf: I get that you do not want to delay Sigsum v2
              - doing a v1.1 will be to some extent a detour
                - so if you really want to spend no extra time at all, then no v1.1
            - rgdd: nisse is spending all his time in the direction of Sigsum v2
            - rgdd: I think we need a Sigsum v2 log server in some form
              - when we have that, we can update tools as needed
            - rgdd: when w ehave a rough v2 we will want to get it stable
            - warpfork: how orthogonal is the work for this v1.1 stuff?  how much rollout effort?
              - if totally orthogonal then it seems inexpensive to do it independently
              - nisse: practically, if we want these endpoints in the log server, then
                - need at a minimum client tooling to be able to test our log server
              - warpfork: sounds like things you want to do anyway?
                - if it's essentially practice for v2, then it seem fine
                - nisse: we need e.g. support for tlog-proof format
                  - that's needed for v2 anyway
        - rgdd: anyone else, more comments?
          - mw: it sounds reasonable to do it as we would for v2 and do v1.1 if small work
          - gregoire: this would mean that would be 3 different formats?
            - old Sigsum
            - new Sigsum v1.1
            - new Sigsum v2
            - rgdd: there may be things we have not thought through enough yet
              - rgdd: therefore the "conditional accept" seems good to me
                - basically abort v1.1 if it takes attention away from v2
            - nisse: I think it makes sense to say that we aim for this and if v1.1 turns out to be a can of worms, we focus on Sigsum v2
        - rgdd: ok, let's consider that as decided
  - Decision? Design sigsum-v2 to not require any deduplication by the log server https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/153
    - postponing that to next week

## Next steps

  - Skipped because meeting time was running out

## Other

  - nisse: MLDSA question, when does it make sense to use deteriminstic signatures (SignDeterministic in the go library)? Off the top of my head, one obscure case where it matters: Say you submit an mldsa-signed entry to a Sigsum v2 log, which only publishes signature hash (it should publish signatures for a limited time, but say they have expired). If you still have the data and the private key locally, but not the signature, then you can recreate the logged signature only if it was made deterministically.
    - tta: I think it would/should be up to the submitter
  - tta: I was also thinking about hedged ML-DSA vs the deduplication conversation, and I'm under the impression that in the current direction of Sigsum & Sigsum v2, the submitter is always expected to keep a copy of the data & context used to create the leaf nonetheless. I'm unsure if a use case exist to "forget" the signature and not store it with the leaf data & context. If there's none, why restrict ML-DSA to be only deterministic? (while there are good arguments for use of hedged implementations)
  - In general, everything needed to reconstruct the leaf ought to be bundled together with the tlog-proof. But I'm still interested in pros and cons for deterministic signatures.
