# Sigsum weekly

  - Date: 2025-12-16 1215 UTC
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

  - rgdd
  - elias
  - gregoire
  - nisse
  - florolf
  - filippo
  - william
  - wolf
  - mamone

## Status round

  - rgdd: fyi: the hex/vkey difference in sigsum policy format use by TF was clarified
    - https://github.com/transparency-dev/tessera/issues/800#event-21528591859
    - the tessera documentation was updated to explain that vkey format is used
  - rgdd: had a guest lecture at karlstad university, mostly talking about sigsum
    - https://git.glasklar.is/rgdd/kau-25/-/blob/main/handout.pdf
  - rgdd: reading the tlog-sig, tlog-proof, ... naming issue
    - will add a comment there -- maybe talk about it for a min or two in other sect
  - filippo: working on tlog-proof
    - made the changes that we discussed
    - found andrew ayer's comments very on point
    - about naming, "proof" is not a great name
    - https://github.com/C2SP/C2SP/pull/181
  - filippo: also worked on the PR implementing spicy signatures in torchwood
    - building a thing on top of tlogs
    - https://github.com/FiloSottile/torchwood/pull/34
    - finishing things that are needed
    - one part is spicy signatures, which means everything you need to verify that something was included in a transparency log
      - instead of just a public key, it's the name of a log and policy information
    - go api: interface, has a way to check if a policy is satisfied
      - one thing I want feedback on: where in the API should the log origin live?
          --> other section
    - still using the word "proof", should probably change that
      - should discuss naming "proof" vs "signature" etc.
  - filippo: finished age keyserver demo!
    - https://github.com/FiloSottile/torchwood/pull/36
    - https://keyserver.geomys.org
    - you can put in your key and it is added to a tlog
    - there is a CLI for fetching those keys
    - in the log there is no email addresses, only hashes of keys, to avoid poisoning
    - test key that we can search for?
    - filippo: just added my log to witness-network.org to get this running
      - using a 2-or-3 policy for witnesses
      - for some reason always using the same two witnesses and never the geomys one
        - could be because those witnesses are faster
      - filippo: the PR is structured as several separate commits
        - so you can see the progression
        - there is also a monitor tool
          - you can do "go run" you will see keys
          - go run filippo.io/torchwood/cmd/age-keylookup@push-zyyrrwlttzvr -all filippo@geomys.org
  - elias, rgdd: gave getting-started a brush up with named policy
    - https://www.sigsum.org/getting-started/
      - we should not forget to add policy name in generated keyfile as discussed earlier
      - https://github.com/FiloSottile/age/blob/main/SIGSUM.md
  - elias: reviewing MRs from nisse and Sockerfri:
    - https://git.glasklar.is/sigsum/admin/ansible/-/merge_requests/92
    - https://git.glasklar.is/sigsum/admin/ansible/-/merge_requests/94
    - https://git.glasklar.is/sigsum/core/log-go/-/merge_requests/201
    - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/293
    - https://git.glasklar.is/sigsum/core/sigsum-c/-/merge_requests/4
    - rgdd: thanks to william!
  - nisse: working on the sigsum-c library
    - discussed that with Tillitis people last week
    - one thing is the sign-if-logged app for TKey
  - william: sigsum ansible MRs for pull-logs and multiple bastions
  - florolf: merged the log freshness thing and basic testing infra in sigmon
  - florolf: changed my monitoring to also monitor the ginkgo log
  - florolf: investigating some weird latency
    - using filippo's tool for my witness, getting occasional failures
      - https://ct-uptime-alerts.fly.dev/witness/
      - suspect some latency spikes
      - will keep an eye on that
  - florolf: thought about compiled policy things
    - compiled policy could be made more compact given that policy is not more strict
    - nisse: nice!

## Decisions

  - Decision: Cancel weekly on 2025-12-30; 2025-01-06 due to holiday season
    - (meeting on Dec 23 is happening, rgdd will be there)

## Next steps

  - elias: review MRs, see above
  - filippo: move age to named Sigsum policy
  - filippo: post about keyserver
  - filippo: do what is needed to land the implementation of tlog sig
  - rgdd: witness blog post
  - rgdd: review sigsum-c MRs by nisse
  - rgdd: will say something in filippo's issue
  - nisse: will continue with sigsum-c and Tillitis tkey app things
  - william: MRs, comments

## Other

  - questions/comments?
  - wolf: already got the comment that our usecase (conda) seems like a good fit for using sigsum
    - wondering what kind of state Sigsum is in, is it production-ready?
      - rgdd: the status right now is that Mullvad is running a log and Glasklar is running a log
      - there should be at least 1 year in advance notice if those are shut down
      - similar story for witnesses, currently 3 witnesses which commit to give 1 year advance notice if they were to shut down
      - wolf: the idea is to use one of the public logs, or would it be better for our community to run our own log?
        - rgdd: you can use the available public logs, that would be fine
          - you could also run your own, or do both
        - wolf: what if we have a million packages, would there be rate-limiting problems?
          - rgdd: 1 million no problem as such but you would need to get the rate-limit lifted
        - filippo: there is a tradeoff regarding individual packages or a big release file
        - filippo: think about monitoring also, if you hash repo state then you need a monitor that checks that
        - filippo: if you instead do it go checksum database style, then it's easier
        - filippo: if you do both, then monitors need to do both, so that's even harder
        - nisse: for rate-limiting you would need to contact log operators
        - wolf: if could be like 500 per day
        - wolf: are there any rust libraries that could be used for verification?
          - gregoire: we have a rust library that Mullvad is working on
          - https://github.com/mullvad/sigsum-rs
        - wolf: I will probably start trying some things out
        - wolf: are there companies around for consulting around these things?
          - rgdd: start with writing questions in the matrix room
          - filippo: we are in a stage where we want things to work well, we are motivated to help
        - wolf: public keys, how to distribute, thinking about that
          - filippo: presumably you have a client already, that's your distribution story
            - wolf: that's what go does?
              - yes
          - filippo: people still run our code for the client, so they already trust us
  - litebastion: allow starting without witness: https://github.com/FiloSottile/torchwood/pull/43
	- litebastion: allow listening on !localhost https://github.com/FiloSottile/torchwood/issues/42
	- litebastion: bring-your-own-cert? (Issue TBD)
  - problem with https://ginkgo.tlog.mullvad.net/get-tree-head returning 404 error
    - was discussed in Sigsum matrix room 2025-12-14
    - network configuration issues?
      - should be fixed now
  - filippo wants feedback: where in Policy API should log origin be checked?
  - tlog-proof vs tlog-sig vs something else?
