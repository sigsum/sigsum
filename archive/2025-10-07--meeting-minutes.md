# Sigsum weekly

  - Date: 2025-10-07 1215 UTC
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
  - florolf
  - gregoire
  - nisse

## Status round

  - elias: worked on implementing the named policy proposal:
      - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/proposals/2025-07-named-policies.md
      - some parts are done:
          - there is now a -P option
          - policy name can optionally be specified in pubkey file
      - remaining: carefully look through the proposal and make sure we didn't miss anything, and add any missing bits. Also to add documentation.
      - then comes the part about what should the built in policies actually be
      - right now only have testing policy (the only built in so far)
      - the plan is to also have a built in policy that's not only for test, but actually a real one
      - and idea: sigsum projcet somehow decides how that policy should be
      - so this remains for us to think about (procedure, how to we arrive at the policy etc)
      - one thing we've dicussed: we will probably require each witness that we include must have witness about page, where it is stated it is intended to be up and running for at least $certain amount of time. E.g., a year, we have to decide on something.
      - then we write down what the requirements are
      - and should probably also consider other things
      - but for a witness to be considered at all in our policy, the above would be the minimum bar to not be auto rejected basically
      - btw: gregoire we would love it if you could get an about page for your witness, can you get it ready sometime soon?
        - yes, in some form
  - ln5, rgdd: attended tor community gathering in denmark, among other things
    talked to folks about website transparency (webcat / waict) and consensus
    transparency. We might help out a bit to unblock consensus transparency.
      - talked about website transparency things
      - discussions about transparent source for the website that is being rendered
      - also talked about Tor consensus transparency
        - right now signatures from 5 of 9 dir authorities needed
        - there could be transparency for that using sigsum
  - rgdd: onboarded filippo to join me and al as maintainers in the witness
    network
      - discussed domain name for witness network
  - rgdd: synced with al and filippo about next steps witness network filippo
  - rgdd: fyi: will lower the bar wrt. bastion host exploring before TDS, and
    only aim at a blog post describing this space (no more implementing yet).
      - will not have time to implement that before the tdev summit
      - will aim for writing down things, a blogpost about bastion host issues
  - nisse: Got a tkey sign-if-logged app working. See https://git.glasklar.is/nisse/tkey-sigsum-apps. Verifies sigsum proof on the device.
    - you first configure it by loading a policy and submitter keys
    - nisse shows a TKey that has new firmware that can use storage
    - signing key is derived from the policy and device secret
    - intended to work with for example legacy devices
      - then you would first do a transparency log entry and get a proof
      - then give that proof to the TKey to get a signature from the sign-if-logged app
      - can be used when it is not possible to make changes in some legacy device
  - florolf: Some work on hardware(HW)-backed witness implementation.
    - sort of redundant considering what nisse is doing, but anyway
    - rgdd: you don't need to justify having a separate hardware and software implementation
    - florolf: my reasoning has to do with the hardware, the TKey is too limited
    - want domething that is easy to get, easy to buy needed devices
    - want something reasonably secure
    - hope to have something running for the tdev summit
    - rgdd: will you have a test witness then in time for the tdev summit?
      - florolf: maybe, might not be very stable then
    - florolf: if having another party running a litewitness is helpful then I can do that too
    - rgdd: as long as you just know you will run it for more than a week or two, it is useful to add that to a test policy, and then also to offboard your witness from a policy, for a test witness that would be fine, that would be helpful pipe-cleaning I think.
    - rgdd: for test witnesses, it's not so much about being secure, it's more about trying out how things work and how to add a witness to a log and so on
    - rgdd: it would actually be helpful if someone did run a witness that rotated their key often because then we would need to handle that, but not this week perhaps, a bit later.
    - nisse: if you have any feedback on sigsum-c that would be great
    - Goals: Have something that works in companion with a Linux host and only signs consistent checkpoints, is easy to get (think: can buy a complete setup including host for < 50 EUR on Amazon), is reasonably secure (compromising the Linux side should not allow signing invalid checkpoints or leak the key, physical access should not allow key extraction but might allow rollback)
    - Current status: Working bits and pieces, hope to have something that works with persistent storage and can answer C2SP /add-checkpoint requests until tdev summit
  - florolf: Some discussion with elias about running a test witness
  - gregoire: we are still setting up the log
    - got information from elias, will try tomorrow
    - will think about creating about pages (for the witness, and also for the log)

## Decisions

  - Decision? Adopt proposal on stricter policy format
    - proposal: https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/120
    - draft documentation changes: https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/261
    - nisse: was discussed two weeks ago
      - the idea is to make policy format more strict
      - two parts:
        - allowed characters and treating names as opaque
        - disallow duplicates so that there should be at most one path from a witness key to the quorum
          - that makes it easier to reason about the policy
    - nisse: rasmus suggested that we should perhaps not take any decision today but wait another week to get input from Al
    - florolf: there has been some discussion in comments in the gitlab MR
    - nisse: as I understood the comments they were mainly about clarity
      - florolf: I commented on character sets
    - nisse: if you think it's useful to have a more polished suggestion then I can polish it
    - nisse: question about comment lines: should a comment always be a whole line, or should it be allowed to have part of a line being a comment?
      - florolf: preferable to say that comments should be full lines, because then you don't have to deal with which characters are allowed in names and so on
      - florolf: it's neat to have part of line comments, but perhaps not worth the added complexity
      - florolf: a bit of bikeshedding but if it were up to me, I would allow only full line comments
        - rgdd: I agree
      - florolf: if that is changed in the future then that would be a breaking change
    - nisse: one more open question: shared keys between log and witness
       - should the spec disallow the same key being used for a log and a witness?
       - nisse: my gut feeling is to not check for that
         - we have domain separation so it is not strictly a problem
         - I don't expect any subtle failures due to that
      - florolf: it could be a valid setup, that both a log and a witness have access to the same signing oracle, that would be pointless because then the same organization running the log is witnessing it (so the witness doesn't add anything)
         - there could be a scenario where it is not pointless (two logs running witnesses and cross-witnessing)
      - gregoire: another topic: two things:
        - I read the policy.md and wondering: must names be unique?
          - nisse: that is the intention
        - Can a group name override a witness name?
          - nisse: it's the same namespace. that could be spelled out more clearly
      - gregoire: would it be good to restrict to ASCII to avoid attacks with similar-looking characters and similar?
        - nisse: anything unicode goes
    - rgdd: TLDR: everyone is happy with the proposal but not decided now
      - nisse will clarify things in the MR
      - about comments: allow only full line comments

## Next steps

  - rgdd: take a stab at witness network deploy
    - both site and mailing list
  - rgdd: hunt for test logs/witnesses to populate witness network with
    - for example get barreleye onto the test log list
  - rgdd: see if we can setup a witness network chat room (irc,matrix,slack;
    would be bridged similar to our sigsum room)
  - rgdd: contribute to witness getting started doc that ln5 is working on
  - nisse: policy-related things
  - nisse: continue with TKey
    - will try to get ECDSA working
  - elias: more named policy and builtin policy things
  - florolf: will do more work on the hardware implementation
    - will also try to spawn a litewitness
    - rgdd: then I will poke you as well about the test witness network
  - gregoire: about pages for mullvad log and witness
    - will try to get that done this week or next week

## Other

  - None
