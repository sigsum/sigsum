# Sigsum weekly

  - Date: 2025-09-23 1215 UTC
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

  - rgdd
  - elias
  - ln5
  - filippo
  - nisse
  - florolf

## Status round

  - nisse: MR to make policy file spec stricter -- enough with MR review, or do we need a proposal for these changes?
    - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/261
    - was discussed last week
  - nisse: reviewed named policy MR
  - nisse: sigsum-c things, TKey
  - elias: MR for part of named policy implementation:
    - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/258
    - got review from nisse, thanks!
    - should that be merged before creating MR for remaining parts?
    - did a version with all the different pieces, then got suggestion from nisse to break it out into several smaller MRs. So no there is a smaller MR, the first part (see above). Got lots of review on it from nisse -- and did a few changes today so would like another review round from nisse.
    - question: how to proceed, merge to main and then make another MR after that? Or should everything be done before merging anything to main?
    - nisse: merge (even without the other MRs still a good step forward)
  - rgdd: updated witness configuration stuff based on feedback from Al, and partially from elias/nisse (few minor things I'm still intending to address from elias/nisse).
    - https://git.glasklar.is/rgdd/witness-configuration-network/-/commit/2efa0fe5f531fac81d936148c4a49231257cebf2
    - will do a separate commit with remaining things
  - rgdd: started paging in plants
    - https://mailarchive.ietf.org/arch/browse/plants/
    - photosynthesis a.k.a. merkle tree certificates
  - rgdd: provided some more feedback to florolf wrt. sigmon configuration UXz
    - doing a fuzzy match
    - earlier one instance of the monitor per log
    - now one config for multiple logs
  - ln5: no progress on witness ops BCP; nothing is blocking me
    - BCP: best common practices
  - filippo: worked on archiving logs
    - there was a specific tile that got rejected by the internet archive
    - https://groups.google.com/a/chromium.org/g/ct-policy/c/Y25hCTrCjDo
    - something about the specific position of that tile, or something, unclear
    - will try to upload all of the logs
    - forcing googl rate-limits a bit to make it fast enough
      - using public mirrors
    - have not yet tried downloading zip-files from the internet archive
    - the internet archive is a nonprofit
      - they are short on engineering resources
      - they have lots of bandwidth and storage
      - nisse: seems like they sometimes like to take content and store it for later even if they cannot publish it right now
    - rgdd: nice to see progress on the archiving of logs!
      - the internet archive would be a very nice place for that
      - for example for research when you want results to be reproducible
      - historical data is going to be very useful, not only for CT but also for other things
      - would be interesting to try archiving a sigsum log as well
        - filippo: I think the same process would work
        - rgdd: that would be a very nice piece of future work
        - rgdd: could be interesting to try archiving our current test log
  - florolf: some work on policy parsing in the monitor
  - florolf: added a mechanism to download content, the data that corresponds to the checksum
    - looking at the key to find out what kind of data it was
    - this is merged, "leaf info" section
    - https://github.com/florolf/sigmon?tab=readme-ov-file#leaf_info
    - nisse: would be good to agree on a way to get the checksum
      - florolf: the way this is currently implemented is using a hook
    - nisse's poc: https://tee.sigsum.org/~nisse/checksum/

## Decisions

  - None

## Next steps

  - elias: continue implementing named policy things
    - get first part merged
    - start with second part
  - rgdd: continue sync:ing with al regarding witness configuration stuff
  - rgdd: more plants page in
  - rgdd: file issue in litewitness about supporting witness config stuff
  - rgdd: maybe bastion host things if time permits
  - nisse: sigsum-c and TKey things
  - ln5: the witness documentation thing
  - filippo: the issue that rgdd gave me
  - florolf: playing with ssh certificates and transparency for that, using sigsum
    - want to have an ssh CA and want to log the issued certificates for that
    - have an implementation that uses sigsum for that, creating a sigsum proof
    - not really polished but I can perhaps push it somewhere
    - rgdd: not urgent at all but would be very interesting to look at!
  - nisse: Write up short proposal on policy fixes.
  - nisse: Write up proposal on context (not urgent)

## Other

  - fyi: load testing tool for witnesses
    - https://github.com/transparency-dev/witness/tree/main/cmd/loadtest
    - just an fyi, in case anyone is running a witness and would like to check how many requests per second it can handle, and similar
  - nisse: policy improvements?
    - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/261
    - the changes are:
          - not allow any kind of duplicates
          - syntax things, which characters are allowed
          - two appendices, one of them about constrained devices
    - should this be a proposal, or just reviewed in an MR?
      - rgdd: lean towards proposal since it is about changes in a spec
      - rgdd: we can also see if Al has any comments
        - Al has just implemented this in tessera
  - nisse: If we have time, any comments on leaf context notes/ideas?
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2025-09-03-leaf-context-for-sigsum-v2.md
    - submitter can pass context together with the message
      - the signed message would contain the context
      - you could monitor and look for a key and a context
    - another way would be to add the context as an additional part of the leaf
      - that would be a larger change, not backwards compatible
      - then you would submit two items that would get into the leaf
        - one would be specific to this log entry
        - the other would be from some small set of contexts
    - rgdd: so in the version that is not backwards compatible, you could monitor on a context only if you want, but in the backwards compatible variant you need to have both the key and the context
    - rgdd: for sigstore, if they do not have a CA key, then the backwards compatible variant would not work
    - filippo: I like the backwards compatible version better, even without thinking about backwards compatibility
      - sigsum is already not a way to monitor all uses of a key, but it is usage of a key in a way where the signatures are going to be accepted by a client
    - rgdd: I think it's a really good idea
      - this is feedback we have been getting also from jas who is a debian maintainer
        - this feature would solve his problem I think
    - filippo: generally I want digital signatures to always have a context
    - filippo: the API of a signature operation should have a context field
    - rgdd: it does not really complicate things very much
    - ln5: I think the idea of a context is generally sound and good
      - good if it would be possible to make it mackwards compatible also in a UX way
        - so that if you just do things like before, things would work simply with an empty context
    - ln5: at first I was worried that we would make things more complicated
    - rgdd: I think that would be possible: if you pass exactly the thing you did before then things would work
    - filippo: that should be a separate decision then, the cryptography would be different
    - florian: I was thinking about the implications for monitoring
      - with that in place you cannot detect any key, you need to know all the context strings
    - A backwards compatible way is to add context to keyhash and signed leaf data, but not store or publish it separately. Effectively making it a salt for the key. Is that generally useful? Is it likely to be enough for sigstore's use case?
    - elias: I guess the thing that is gained is the ability to answer the question "which context does this leaf belong to?" -- but that question could be answered anyway if the submitter had a lookup service that could map checksum to context? So it is perhaps not necessary to have the context in the leaf, submitters who want to use the same key for different contexts could provide the mapping themselves? (there must anyway be some place where information about checksums can be fetched?)
