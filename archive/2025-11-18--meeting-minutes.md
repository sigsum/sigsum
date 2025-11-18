# Sigsum weekly

  - Date: 2025-11-18 1215 UTC
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

  - rgdd
  - elias
  - nisse
  - gregoire
  - filippo

## Status round

  - elias: new builtin test policy sigsum-test-2025-3 was merged
    - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/281
    - using 2 logs and 8 witnesses
  - elias: another MR for a prod policy
    - not merged yet, about to happen soon
    - we're hopin gmullvad log and tillitis witness would configure each other; so mullvad log can be in the policy
    - and as of today this has been fixed, so we will be able to have 2x logs and 3x witnesses in the stable/prod policy; at least that's the plan right now.
    - some polishing going on with the doc describing the procedure for creating the builtin policies
  - nisse: PR to support per-log bastions in litewitness: https://github.com/FiloSottile/torchwood/pull/35
  - nisse: Ongoing work to improve tests and error messages in the sigsum-go client package.
  - nisse: Reviewed tlog-proof PR https://github.com/C2SP/C2SP/pull/181, and wrote some text on how to verify tlog profs https://github.com/niels-moller/C2SP/tree/nisse/proof-verify (based on corresponding Sigsum proof docs).
  - gregoire: setup witness-network on Mullvad's staging witness
  - gregoire: added Geomys' staging witness to our staging log, and Tillitis' prod witness to our prod log
  - gregoire: mullvad prod log now using Tilitis witness
  - rgdd: testing of nisse's litewitness bastion updates
    - set up my own bastion host and tried it out with the barreleye log, it worked.
    - also worked to have two bastions configured at the same time
    - the only thing not working was the reconnect logic
      - nisse: made a change to try to improve the reconnect thing this morning
    - rgdd: I liked Filippo's idea of deprecating the commandline option for bastion
    - rgdd: so now you can configure bastions that are not global
    - rgdd: you can still have one or many different if you want to
    - rgdd: I would like to be able to run a bastion that is only used for our own log
    - filippo: I pushed an alternative implementation
      - the internet external connection is not http at all
      - before there was only a single if-line holing back the hoard
      - rgdd: I'm happy that you did the thing I really wanted!
    - nisse: we also discussed if it would make sense to have it listen on a unix socket
      - secureity-wise it could make sense
      - rgdd: the socket idea would involve some systemd things
      - filippo: I have no objections to adding unix sockets
      - rgdd: let's make a separate PR for the socket thing later
  - rgdd: changes to litebastion where requests can only be injected on localhost
    - https://github.com/FiloSottile/torchwood/pull/38
  - rgdd, ln5, elias: sketching/exploring a bit wrt. witness sla stuff, not much to share yet
  - rgdd: filed final issue about checker stuff, and Tom seems happy to take PRs with our proposed changes. I'll do it once I have a few free cycles (not highest up on my list right now though -- but at least wanted to get things filed).
    - https://github.com/tomrittervg/checker/issues/5
    - https://github.com/tomrittervg/checker/issues/6
    - https://github.com/tomrittervg/checker/issues/7
  - filippo: if there are things that people need from me before my vacation, let me know
  - filippo: a bit scattered week
  - filippo: span up staging geomys witness and announced that
  - filippo: updated sinlight witness implementation
      - https://github.com/FiloSottile/sunlight/pull/52
  - filippo: the main changes are:
      - easier to use
      - can pull multiple log lists
      - also a special log list that makes it work with the witness uptime service
         - witness uptime service
          -  https://ct-uptime-alerts.fly.dev/witness/
          - might be useful for other witness operators
          - you can point uptime monitoring to that service
          - you can then get notified if your witness is not actually working
          - very happy with that little thing
          - makes me more confident that the witness actually works
  - filippo: made a little progress with the age keyserver demo
    - https://github.com/FiloSottile/torchwood/pull/36
    - realized that Tessera right now will make a new checkpoint for a certain interval
    - so you may need a short interval
    - but if there are few submissions per day that may be a problem
      - talked to Al about that
      - considering change so that only checkpoints that are needed are added
  - filippo: still not the biggest fan of how anync internally Tessera turned out to be
    - something goes into a pool
    - then something later serializes the pool
    - feels like what broke a bunch of CT logs (so why are we doing it again?)
    - can be multi-node
    - you add a thing, then:
        - then wait for a background thing to happen
        - then wait for a second background thing
        - this adds so much latency
        - Al said they want to aupport multiple abstractions and multiple nodes
        - something about only being able to update Google cloud storage once every second
        - maybe useful for static CT api
        - many things will be slower in this world because there will be polling
        - nisse: in the sigsum case it would be nice to be able to ask Tessera to store on disk and then wait for replication
          - filippo: it sounds like Tessera will let you do that
          - filippo: you can have your own awaiter or a thing like that
        - filippo: I'm a bit annoyed that a simple thing has been made complicated
        - rgdd: maybe "tessera the server" and "tessera the CLI tool" should be two different things?
          - filippo: I did write tessera as a CLI tool before and it was not too large
          - filippo: I will keep chatting with the team and see what can be done
        - rgdd: maybe "tessera oneshot" could be named something else and then made as small as possible?
        - filippo: there are two things:
            - the first thing
            - then the polling
        - filippo: that adds latency unnecessarily
          - there should be an API that triggers what is needed and then returns directly
  - filippo: a couple small changes to torchwood, needed for other things
  - filippo: someone else tried uploading the thing to archive.org (from lightning talk) and then it worked?
    - elias: could it be a rate-limiting thing?
    - filippo: but I tried bisecting for the size
    - filippo: it's possible that archive.org fixed something?
    - filippo: testing uploading for another log

## Decisions

  - Decision? Support leaf context, see https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/125
    - changes since last week: Resolved open issues, renamed the key attributes (in pubkey files) to sigsum-context-id and sigsum-context-raw.
    - nisse: not sure if we need to name things exactly today, maybe we can do that in MR review later
    - nisse: proposing a separate endpoint to add a leaf with context
    - rgdd: it looked great already last week
    - filippo: not sure if I understand, context is?
      - nisse: context is 32-bytes arbitrary data
      - nisse: the point is that if you know the id and the pubkey then you can scan the log for that
        - filippo: the name "id" means something else to me
        - filippo: maybe just "sigsum context"
        - rgdd: I also preferred the old, just "sigsum context"
        - rgdd: as long as we have the "sigsum context" I am happy
    - filippo: the semantics looks great
    - rgdd: the other thing was the separate endpoint, added since last week
    - gregoire: I read it, a questoin:
        - suppose I am a software developer and I submit different software packages
        - say I do that for a set of opackages and I have a single key and different contexts
        - gregoire: if someone steals my key and uses it to sign some other package, then I will not be able to detect that?
          - nisse: right, but no verifier will accept that
        - nisse: good point, thanks for pointing that out
        - nisse: it would be a problem if someone makes others believe that there is a new context
      - filippo: I never really liked the saying that "you will know if someone uses my key" because what you really know is "you will know if someone uses my key in a way that verifiers accept", which is not exactly the same thing.
      - filippo: if you say a rule by which you can construct a context, then new context could be constructed that you do not know about
      - gregoire: there is no cryptographic binding between the pubkey and the context
        - gregoire: it's a bit like introducing subkeys?
        - filippo: looking at them as subkeys is actually not bad
        - filippo: this might be a strong argument for adding the context to the leaf
          - so that you can know about new contexts
          - rgdd: then it's not backwards compatible
        - nisse: if I have gregoire's key and I do due diligence to be sure it is the right key, but I am sloppy about how I find out about which contexts are possible, then I get into trouble
        - filippo: this is similar to how we used only keyhash in some places, to help avoid mistakes
        - filippo: if I used sigsum for age with context "age" and then someone else could do invent another context "age-extra" or similar and that social engineering could succeed
        - filippo: what is the value of making this backwards compatible?
          - nisse: the advantage is that monitors who do not care about contexts do not need to know about it
          - filippo: if we make a new leaf type?
            - rgdd: we do not have leaf types. if we want to have a new leaf, then thats version 2
            - nisse: when you ask for a set of leaves you expect to get that
            - filippo: I see that for things that read directly from the log
              - but for a verifier verifying offline proofs?
              - that is the most important backwards compatilbility
              - filippo: I think that breaking monitoring would be more acceptable than breaking verifiers
            - rgdd: I think that if something can be added in a backwards compatible way then we should do it, but otherwise we should wait
            - rgdd: let's get gregoire's point into the document and think about it more
            - gregoire: what is the advantage compared to having separate keys?
            - gregoire: could you have a key derivation function for ed25519 and use that?
    - nisse: good discussion! I will need to update the proposal with some new security considerations discussion and then get back to this proposal next week

## Next steps

  - nisse: update leaf context proposal with new security conseridations discussion
  - nisse, rgdd, filippo: get stuff merged regarding the bastion things

## Other

  - nisse: We should probably update everything to use go-1.24 (available in debian stable/trixie). I don't see any obvious killer features in the release notes, though.
    - https://go.dev/doc/go1.24
    - Alternatively, update ci toolchains etc to go-1.24, but keep 1.23.0 in go.mod until we (or some dependency) start requiring 1.24 language/library features.
