# Sigsum weekly

- Date: 2025-08-26 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: rgdd

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
- nisse

## Status round

- elias: prep:ed proposal on named policy, see queued up decision
- elias: talking a bit with gregoire about a test log -- conf:ed my test witness
  now so if gregoire also configures it will work
- rgdd: got positive feedback from mc regarding shared witness configuration
- rgdd: got a request to provide feedback on tkey verification stuff from mc
  - see other section
- rgdd: drafty roadmap until november -- feedback appreaciated
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/116
  - hoping to work towards decision next week
- nisse: example of format with claim + sigsum proof in one file,
  https://tee.sigsum.org/~nisse/pcr/43/43929c6dacb28003d46aa24d45cf73c7d4000a33fc08903bb4cf26602dc85a9d,
  code to parse and verify,
  https://git.glasklar.is/nisse/st-complete-poc/-/blob/main/cmd/client/claim.go
  - might be relevant for tkey verification too
  - one url with files where it is the sigsum checksum as filename, there
    monitors can look to find claims. This we know is needed.
  - but also have another index, filename based on pcr4 value. When you
    download, you get a claim and corresponding sigsum proof.
    - i.e., server can retrieve the proof it needs to serve to its clients
  - nisse thinks this can be useful in other use cases as well
  - nisse will poke gregoire and let him know nisse is tinkering on inline
    format
- nisse: regarding moving poc.so -- i need to move my witness. Is this urgent?
  When will poc disapear?
  - ln5: it will disapear when nisse migrated, it's not urgent but it would be
    good to get it done.
  - no one has prepared a vm for nisse yet
  - elias is preparing a vm for nisse and will poke him when it's ready
- rgdd: is sigsum-go available in trixie (debian stable)
  - nisse finds it when searching
  - cool!
- ln5: progress on issue
  [YubiHSM connector is spamming the journal](https://git.glasklar.is/glasklar/services/sigsum-logs/-/issues/20)
  which makes analysis of missing witness signatures from witness.g.is possible
  even 20h after an incident
  - logging is only in RAM; now got rid of some spam now so we see log messages
    for a longer time
  - our way to do the ansible packaging and using it: there are many small
    manual steps. If we're finding someone that uses our ansible, I'm curious
    about their experience.
  - elias: works good for my test witness
  - rgdd: works for me too and my witness
  - molecule is nice for dev/testing some things
    - ln5 used it several times -- nice we have it!
  - but rgdd sees why there might be some annoying manual steps when doing dev
    that's not via molecule

## Decisions

- Decision: "Add named policy functionality"
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/proposals/2025-07-named-policies.md
  - see discussion in https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/51
  - changed: policy files under /etc/sigsum, they will now be named
    <something>.sigsum-policy, using jas suggested regex
  - changed: if policy name in pubkeys, if >1 submitter key, what should we do?
    The updated proposal says only use info if policy is same for all keys,
    otherwise policy must be specified explicitly. We could relax later when
    thinking more about the semantics, this is the strict version that's easy to
    iterate on.
  - nisse: overall looks good to me, probably a few minor things we need to
    polish while implementing
  - nisse: long names on flags, would rather have something more explicit
    (rather than just large/small P. I.e., want a more explicit long flag
    names.)
    - i.e., replace "--Policy" with "--something-lower-case-explicit"
    - e.g., "--named-policy" would probably be nisse's suggestion
    - and then leave the other one as is
  - nisse: we've talked about this for a long time, makes sense
    - +1 from rgdd
  - elias: filed a few issues with good comments from jas, doesn't change the
    proposal but is related to the proposal and future things.
  - ln5: looks very well explained, structured, good level of detail. Good when
    we go back and try to remember why we did what. Doesn't start with a
    summary, but that's not needed. Intended audience is us to make decisions,
    and remember decision.
- Decision? Cancel next week's meeting (2025-09-02), since most participants
  will be at glasklar meetup?
  - Would be nice to be able to sync with filippo as well
  - Would be nice to decide the roadmap
  - We can keep it, at minimum rgdd will hold the meeting

## Next steps

- elias: start looking at impl of the above decision (named policies)
- elias: prepare new vm to nisse for his witness, then nisse will migrate
- nisse: reach out to mc and gregoire regarding publishing claims
- rgdd: feedback to tillitis (see other sect)
- rgdd: ensure roadmap gets wrapped up

## Other

- is next week's sigsum meeting happening as usual, or any change due to the
  Glasklar meetup that week?
  - see above
- tillitis is considering to incorporate sigsum into their tkey verification
  - https://github.com/tillitis/tkey-verification/tree/sigsum
  - open questions at the end of the README
  - deferred, rgdd will take a stab at this
- roadmap -- input/comments?
  - filippo mentioned before the summer that LE would run a witness? That's
    baked into sunlight? That has a witness feature enabled? Sounded like a good
    thing, and like it was bubbling? Can we get that to move forward?
    - it's in the roadmap already!
  - cosignature/v2 project, is that something we should be involved in?
    - c2sp: nothing is happening right now
    - ietf: would be good if rgdd keeps an eye on this by spending some but not
      too much time
  - ...out of time! rgdd will follow up more with folks individually
