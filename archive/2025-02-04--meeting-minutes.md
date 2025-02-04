# Sigsum weekly

  - Date: 2025-02-04 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: nisse
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - elias
  - rgdd (async -- won't be able to make it today)
  - filippo
  - ln5
  - gregoire

## Status round

  - elias: wrote down preliminary thoughts on trust policy management: https://git.glasklar.is/sigsum/project/documentation/-/blob/elias/2025-02-01-trust-policy-thoughts/archive/2025-02-01-elias-trust-policy-notes.md
  - nisse: Did a talk on sigsum at fosdem. Video recording not yet up (there seems to be some issues with many of the talk recordings).
    - the talk went fairly well!
  - rgdd, ln5: got about pages merged
    - https://git.glasklar.is/glasklar/services/witnessing/-/blob/main/witness.glasklar.is/about.md
    - https://git.glasklar.is/glasklar/services/sigsum-logs/-/blob/main/instances/seasalp.md
  - rgdd: added a readme to age-release-verify prototype
    - https://git.glasklar.is/rgdd/age-release-verify
  - rgdd: lots of talking to $people at fosdem
  - rgdd: finalized roadmap proposal for today based on input and where we're at
    - rgdd: filippo, please double check that what i put under your name looks reasonable based on our chat last week
  - gregoire: Mullvad is running a witness!
    - the witness is up and running and running fine so far!
    - using litewitness and a yubihsm
    - remains to add docs for how the witness is setup and how long it is planned to run and so on
    - seems to be different formats for keys (vkeys) on litewitness landing page compared to what the sigsum-key command gives
      - filippo has an idea why this might be, he will look into it
    - gregoire will create an issue in filippo's repo about that
  - filippo: talked to lots of people at fosdem
    - good chat with alpine maintainers, see under Other section below
    - good chats with a person from Github about how sigstore fits in the ecosystem. They (Github) have been trying to do things that can not only detect but also avoid attacks, so they have had partly different goals compared to sigsum. Also chatted about npm, which is related to Github
  - filippo: synced with Martin about verifiable indexes today
  - ln5: setting up a witness just like gregoire has done, but not done yet, hopefully will be working really soon

## Decisions

  - Decision: Adopt updated roadmap, renew towards end of May
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/99
    - async +1 from rgdd
    - decided! nisse will press merge button after this meeting

## Next steps

  - ln5: documentation updates and minor fixes for ansible roles for setting up a witness, kind of cleanup
  - gregoire: document Mullvad's witness operations
  - filippo: a few maintenance items on litewitness and litewitness
  - filippo: trust policies
    - when changing the trust policy, should proofs be regenerated?
    - how do we rotate trust policies? create new proofs? or just new witness cosignatures? We need to document these things.
    - there could be a test witness policy
  - filippo: age, make that ready as an example of how to use sigsum
  - elias: make release of the sigsum ansible repo

## Other

  - litetlog issues -- what's the status here? (copy-pasted from last week's minutes)
    - litewitness: SIGSEGV: segmentation violation 
      - https://github.com/FiloSottile/litetlog/issues/24
      - in sqlite, called via cgo?
      - filippo: this will take some digging
      - filippo: have seen this also for my witness
      - filippo: may be something done concurrently that should not be done concurrently, will look into that
    - litebastion: "HTTP/2 transport error" with type=recv_rststream_INTERNAL_ERROR 
      - https://github.com/FiloSottile/litetlog/issues/23
    - litebastion and litewitness: need a way to disable logs exposed at /logz endpoint 
      - https://github.com/FiloSottile/litetlog/issues/22
      - filippo: anything else than IP addresses that would ever be sensitive in a bastion or a witness?
      - filippo: in principle the witness should not have anything secret other than the key, which should be protected inside a hardware module so that it cannot end up in a log
      - ln5: it depends on how you look at what a witness is
      - ln5: if you want to keep secret who is running the witness, then there are lots of things that you may not want to reveal
      - filippo: a witness that is run secretly would not be very useful?
      - ln5: there could be cases where it is useful, possibly
      - nisse: the witness is a smaller issue I think because if the witness is behind a bastion? no, it is anyway available to the world via the bastion
      - filippo: we could of course add a debug option to enable logs but a question is if we should encourage debug info
      - nisse: I think we should put things in the log that are useful for debugging, but I don't think we should be opinionated on if or how the logs are made available
      - filippo: what usecases are we encouraging by not exposing logs?
      - filippo: this ties into what rgdd was talking about regarding witnesses
      - filippo: this is not a strong opinion but I am not sure the default should be that logs are off
      - ln5: I don't care about the default right now, as long as we get a way to disable it
      - ln5: what exactly is the bastion publishing?
         - when a witness tries to connect
      - ln5: if someone could encode some bad information inside that data, then maybe a bastion operator would not want that information made public?
      - ln5: in order to get correct expectations for operatots, we need to be able to explain what information becomes published
      - filippo: the point of the bastion is to expose things from the witness, so whatever information comes there must have been sent from the witness, so the witness should expect that the information is relayed to the public. The only thing the bastion knows that the public does not know is the details about the network link, and I think the only important thing there is the IP address.
      - filippo: I was thinking that the protocol itself does not have space for secret things
      - filippo: we can redact ipv4 and ipv6 addresses
      - filippo: let's also think about it async, I will make a patch to remove IP addresses and if anyone can think of other things then we think about that.
      - nisse: is it easy to remove IP addresses in a robust way?
      - filippo: I don't think there are any string encodings that could cause problems for that, but will check.
  - Alpine archive and tlog?
    - chatted with alpine maintainer, there is interest in transparency logging their things, connecting to a witness ecosystem
    - they do not have a snapshot service
    - if there was a company that already did such things? ha ha Glasklar is doing that
    - ln5: we have debian snapshots, but that is different
    - nisse: there could be a solution for long-time archiving for alpine?
    - filippo: we could talk to them about not deleting old archives
    - filippo: if that gap is filled then they might use sigsum
    - ln5: alpine is interesting for several reasons
      - I know at least one person there
      - they seemed to make good decisions
    - filippo: alpine care very much about offline verifiability of proofs, need that for example in the context of booting things. sigsum has solutions for that
    - filippo: Ariadne is a contact person
    - ln5: will lurk
    - filippo: IRC OFTC channel name may be alpine-devel or alpine-infra
  - meetup in Stockholm in two weeks, is filippo coming? --> probably not
  - elias: discuss trust policy management? see https://git.glasklar.is/sigsum/project/documentation/-/blob/elias/2025-02-01-trust-policy-thoughts/archive/2025-02-01-elias-trust-policy-notes.md
    - we did not have time for this on today's meeting, will discuss it async or at next meeting
