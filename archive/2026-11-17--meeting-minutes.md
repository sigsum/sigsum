# Sigsum weekly

  - Date: 2026-11-17 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: nisse
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - rgdd
  - warpfork
  - nisse
  - mw
  - elias
  - tta
  - quite
  - florolf
  - filippo

## Status round

  - rgdd: fixed sigsum's ansible so i could upgrade my litewitness version to latest
    - https://git.glasklar.is/sigsum/admin/ansible/-/merge_requests/138
    - been running this and the latest torchwood version for ~1w now
    - changes related to bastion usage
  - rgdd: drafty "source-header" label for litewitness (metrics)
    - https://github.com/rgdd/torchwood/tree/source-label
    - holding back on filing a PR until quite's MLDSA work is merged
    - can show how many add-checkpoint requests have been received from a given source
  - rgdd: sent out sync email wrt. identity-based leaf yesterday
  - rgdd: fyi: arguing for tombstones instead of tlog-list extension
    - https://github.com/C2SP/C2SP/pull/399#issuecomment-6945035511
      - nisse commented there also
    - if we're lucky maybe agwa will be nerdsniped and provide input
  - rgdd: availability computation and plotting for witness-g1 (wip)
    - found out things about e.g. how prometheus rate is computed
    - nisse: will there be some publicly visible metrics graphs?
      - rgdd: yes, probably
  - rgdd: ....a bit behind on processing witness network participation request
    - there are some requests from the past week that need answering
  - tta: archive transparency demo in 10 days!
    - in process of writing docs / specs (will continue in december)
      - wrote spec for the text format used
    - learning how to deploy things :o)
      - want to have a testing server for next week
    - ex: http://wit26n0.testing.archive.rip/ (should bastion? EDIT: see below)
      - rgdd: about bastion, do you mean having a bastion for a witness or for a log?
        - tta: I did not think about it yet
        - rgdd: quick summary: the current thinking is that the bastion is a property of a log
          - rgdd: if you only operate a witness, you should not need to worry about setting up a bastion
          - rgdd: for example, if you run your witness behind NAT you can connect to those logs that have per-log bastions
          - tta: I have configured the witness-network testing list
  - quite: got a bit into the USB armory device that I received
  - quite: looking at things that nisse has done
  - filippo: mostly been involved in MTC things
  - filippo: looking at specs, things seem to work when implementing, happy about that
  - mw: finished egress filtering and some simple local dos protection for our new witness group
  - mw: been to Tor community gathering
    - there was some discussion there about Tor consensus transparency (https://onionize.space/2026/november/sessions/ctrans/)
      - it's about how the Tor directory authorities log their consensus
        - rgdd: so if any of the Tor directory authorities start signing split views then that would be detectable?
          - yes
  - florolf: implemented sigsum/tlog-policy parser to support v1.1 in sigmon
    - are there any logs/witnesses actually using ML-DSA today?
    - would like to try it out using real-world MLDSA cosignatures
      - failed to find any log where witnesses had published their mldsa pubkeys
        - filippo: all of the MTC testing CAs are MLDSA tlogs
          - if you go to the chrome mtc place there are test CAs there
          - https://googlechrome.github.io/chromerootprogram/cqrp/root-store/
  - nisse: made a log-go release yesterday with a new mTLS feature
    - aiming to make changes in sigsum-go next
  - nisse: merged part 1 of vkeys in sigsum policy
  - nisse: working on Sigsum v2 prototype, log and witness
    - next thing there is the sigsum-verify tool
  - elias: working on glasklar witness group deployment things
  - warpfork: lil sitrep of plc-tlog'ify
    - PLC Transparency
    - PLC: public ledger of credentials
      - designed to be an operational log
        - idea is to somehow make it (merge it with?) a transparency log
    - they already have this hugely deployed service
      - a couple of hundred million entries or real user data at the moment
        - would be nice to have that in a tlog
    - discussing moving things from typescript to golang
      - so currently there are two versions in two different languages
      - taking the golang version and combining it with Tessera to get a tlog
      - this is also a rollout of the tlog addenda spec
      - the tlog only contains un-poisonable entries
        - everything else is put into tlog addenda
      - work scattered across a half-dozen (about 6?) git repos
      - it's a work in progress
      - rgdd: fun to see how tlogs are received in other communities!
        - warpfork: yes, this one should be easy but it's still some work
      - rgdd: have you talked to them about policy and witnessing, are they thinking about that?
        - filippo: PLC is moving into its own independent organisation
          - filippo: full disclosure: I'm a board member
          - filippo: so PLC will be outside of Bluesky
          - Bluesky might want to run a witness
          - others might want to join the game as well and run witnesses
          - filippo: also suggest talking to glasklar
        - warpfork: I have a longterm wish to do something related to lawful monitors
          - it is already the case that identity management events are signed
            - it could be reachable to make all identity management actions logged
            - it would be cool to have a verifiable index map
            - rgdd: there is a claim for how identities are being progressed
              - rgdd: you can already go through the entire database and verify
                - so a tlog would help ensure that you see the same view as everyone else
                - rgdd: the smallest step to do something here would be to do it without a verifiable index?
                  - who are you putting up the verifiable index for?
                    - cool if users can rapidly check it
                    - in atproto, "app view" servers also need to consume this ~constantly.
                    - it is currently assumed that the PLC server is honest... yes it *is* checkable, but the actual read path in practice rn goes through a REST api and an sqlite DB, so, does the actual live read path go through something easily auditable: not really.  a vindex would improve the heck out of this.
                - link about PLC?
                  - warpfork: ask me next week

## Decisions

  - None

## Next steps

  - rgdd: start prepping updated sigsum roadmap, it's due ~now
  - rgdd: take a pass over the pending witness network participation requests
  - rgdd: hopefully identity-based leaf sync
  - rgdd: hopefully wrap up 1st take of availability computation and plotting
  - rgdd: will probably also need to page in tdev SPI things to not block too much
  - rgdd: q for filippo: can you look at litewitness PRs soon?
    - filippo: hoping to make a pass at that soon
  - nisse: hacking more on Sigsum v2 prototype
  - nisse: getting mldsa things into sigsum-go
  - quite: adding checkpoint endpoint to log-go
    - rgdd: florolf will probably be happy about that
  - elias: check MR from rgdd in sigsum ansible
  - florolf: integrating the checkpoint endpoint into sigmon

## Other

  - warpfork is confessedly sketching what pkgman<3tlogs looks like.
  - tta: build https://tsa.testing.archive.rip/ last week
    - made me think about rfc3161+tlog use cases? (dunno, won't try anytime soon tho)
    - there's a signed "serial" field in .tsr certs that we can hack
    - you can have a "CA for time" the TSA, you give a hash and get back a signature
    - can add support for ed25519 and also mldsa
    - wondering: can we, and should we, use transparency logging?
      - don't have time right now, but it could make it possible to add things in the unsigned part, there could be a tlog proof inside the unsigned part
      - there could be two signatures: a legacy one for clients who are unaware about the new thing, and another one for new clients
      - florolf: there is also an extention field where things could be placed?
      - tta: clients are maybe sometimes strict and not allowing nonstandard extentions
      - tta: rfc3161 is used a lot in the EU, eIDAS related things, legal work, etc.
