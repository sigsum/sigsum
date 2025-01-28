# Sigsum weekly

- Date: 2025-01-28 1215 UTC
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
- nisse (not attending, some async notes below)
- gregoire

## Status round

- rgdd: closed abandoned BACKLOG/DRAFT milestones that are not helping anyone
  - https://git.glasklar.is/groups/sigsum/-/milestones/9
  - https://git.glasklar.is/groups/sigsum/-/milestones/11
  - https://git.glasklar.is/groups/sigsum/-/milestones/16
  - https://git.glasklar.is/groups/sigsum/-/milestones/18
- rgdd: tried to clean up a bit in issue board, and i think the "Future" label
  is now a little bit useful to filter on now for hints on possible future
  roadmap things
  - https://git.glasklar.is/groups/sigsum/-/issues/?sort=created_date&state=opened&label_name%5B%5D=Future&first_page_size=20
  - i filed a few new issues, and i probably don't remember some things from the
    top of my head. If you think of "Future" things that would be helpful,
    please pitch in!
- rgdd: roadmap suggestion, will be pushing for decision next week.
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/99
  - input would be helpful, e.g., in the other section or as you see fit
  - i want acks from those that are named with responsibilities/TODOs
  - elias: roadmap suggestion look good to me (but let's not forget the TODOs)
- rgdd: glasklar's witness about page is getting closer to 1st draft
  - https://pad.sigsum.org/p/5be1-fba6-360e-8f55-89fb-967a-fb5c-e7c9
  - plan is to not commit to it yet, so that it's easier to collect feedback and
    make adjustments for at least 90 days. But what's in the doc is our current
    thinking wrt. SLA, setup, etc. There will be a similar doc for seasalp
    that's mostly copy-paste.
  - gregoire: maybe discontinuation is an availability thing? Missed it at first
    glance.
  - elias: should when discontinuation announcements happen be some kind of
    protocol thing in the future?
  - rgdd: would like to collect input in the other section wrt. what's blocking
    me
- elias: added Milan witness to seasalp, and 2 other witness, to be able to
  compare behaviors of litewitness vs AW and also compare bastion vs non-bastion
  witnesses
- elias: investigated problems with ArmoredWitness (AW) witnesses for seasalp,
  now looks like bugfix will be needed in AW software
  - https://git.glasklar.is/sigsum/core/log-go/-/issues/101
  - https://github.com/transparency-dev/witness/issues/321
- nisse: Released sigsum-go v0.10.1.
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/v0.10.1/NEWS?ref_type=tags#L1-31
- nisse: Working on sigsum slides for fosdem.
  - https://git.glasklar.is/nisse/fosdem-sigsum-2025/-/tree/main
- nisse: A bit puzzed on
  https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/93, behaves as if
  GODEBUG=httpservemux121=1 is set in the debian build.
- gregoire: have a running test witness at mullvad. Can i get it added to
  jellyfish?
  - rgdd: give elias a url and verification key
  - i'm trying to get the production witness up before the weekend, not sure if
    i'll manage. Fighting with yubistuff!
  - is elias the one to ask to get it added to seasalp too?
  - rgdd: yes

## Decisions

- None

## Next steps

- rgdd: sync roadmap with filippo
- rgdd: things that make sense before fosdem, like wrapping up the about pages
  and anything else relating to glasklar's witness ops; nisse's talk; or maybe
  low hanging fruit improvements to www.so. I'm thinking about adding a brief
  README to age-release-verify, and to maybe link that and/or sshdt on
  www.so/docs. Any +1s for that?
  - let me know if you need anything from me / can think of any low hanging
    fruit
  - elias: sounds like a good idea to add them, but don't remember exactly what
    they look like
  - rgdd: nisse also wanted README in age-release-verify prototype, he's linking
    it from his talk
- rgdd: attend fosdem, and probably think a bit more about the next steps for
  "shared conf stuff" since there will likely be opportunities to talk about it
  at fosdem
- elias: Release v1.2.0 of sigsum ansible
  - https://git.glasklar.is/sigsum/admin/ansible/-/issues/54
- elias: also going to fosdem
- elias: also help check nisse's fosdem presentation if needed
- gregoire: see status round -- get witness configured on jellyfish and maybe
  also make progress on the production/stable witness before the weekend. Let's
  see!

## Other

- litetlog issues -- what's the status here?
  - litewitness: SIGSEGV: segmentation violation
    - https://github.com/FiloSottile/litetlog/issues/24
  - litebastion: "HTTP/2 transport error" with
    type=recv_rststream_INTERNAL_ERROR
    - https://github.com/FiloSottile/litetlog/issues/23
  - litebastion and litewitness: need a way to disable logs exposed at /logz
    endpoint
    - https://github.com/FiloSottile/litetlog/issues/22
  - defer this for filippo who's reading the minutes, rgdd will also remind
    filippo when he talks to him later this week
- Any input on the suggested roadmap?
  - elias: about choices of words in suggested roadmap: should it say "service
    continuity" instead of "business continuity"?
    - because this is something someone could operate and not do it from a
      business perspective. E.g., i'm just providing a service -- it's not a
      business.
- Any ideas for fun witness names?
  - gregoire: witness.domainname? Not very fun though.
  - rgdd: https://en.wikipedia.org/wiki/Keystone_species
    - we think it's a bit funny!
- elias: thoughts about ways to protect witnesses against DDOS attacks or other
  sabotage. Is it necessary that a witness is accessible from anywhere, or could
  it be accessed in a way that only the chosen logs know about?
  - nisse: It's should be possibly to extend bastion protocol so that (1)
    witnesses tell the bastion the pubkeys of logs it is willing to accept, and
    (2) have the bastion vet which logs/clients can connect, preferably with
    similar client cert hack, or possibly by verifying checkpoint log signature.
  - more context from elias: this came up when discussing the glasklar witness.
    I.e., you run a witness in the standard way without a bastion. Then it is
    publicly know how to contact the witness. So it would be very easy to spam
    with garbage requests. Anyone can do it. It's a threat to the whole system.
    So the DDoS -> no-one can get cosignatures from the witness. And people
    might not be able to sign as a result.
  - elias is thinking about it: the witness must be publicly know and what is
    the public key. That's one thing. And it can be separated from how is the
    log talking to the witness on a daily basis. That can be done without a
    communication that is publicly available. It doesn't have to be public. One
    adv: harder to sabotage it. And can change the communication channel to the
    witness when there's an issue. But there's basically an arrgagement between
    the log and the witness, and it's "up to them". But the point is it really
    doesn't matter to anyone as long as the log is able to show the cosignature.
  - elias: right now you can do "like this or that", different options. It gets
    more complicated. It might be simpler if it is only one way? Then maybe
    bastion is the only one good way?
  - rgdd agree with elias thinking (but not sure if it can be only a single way)
- elias: regarding the "test+document log failover" activity in the suggested
  roadmap: this will be easier if our test log (jellyfish) can be made more
  similar to the prod log (seasalp). Should we change jellyfish so that it has
  both primary and secondary and so that it uses yubihsm in the same way as
  seasalp? I think it would be helpful to be able to do more systematic testing
  of log failover.
  - "not nice to mess around with the production log, would like a testing thing
    that's as close as possible to the real thing"
  - it would still have the same name and it would still be the same log
  - maybe the best option is to create a new staging log and leave jellyfish as
    is (following main, not having a key that was provisioned for a yubihsm).
  - rgdd: at minimum it would be nice to get a secondary for jellyfish though
  - rgdd: another option is to deprecate jellyfish and set up a new one in the
    way you want (e.g., with yubihsm). Consider if the staging log
    can/should/should not follow main or not. Depends on the purpose. Jellyfish
    currently follow main of log-go.
  - rgdd: another maybe difference between jellyfish and a potential staging --
    jellyfish doesn't have rate limits. Not sure if that matters or not.
  - elias: seems like it would be great to add another staging log, i don't see
    a big downside with that.
  - rgdd also likes the idea of jellyfish = sigsum projects dev/prototype log;
    and if glasklar wants/needs a staging log that makes sense to add and then
    consider it a glasklar thing.
- rgdd: input on witness + seasalp docs
  - Witness (verification key) name?
  - Separation between witness and sigsum log ops?
    - glasklar/services/witnessing vs glasklar/services/sigsum
    - one or two mailing lists at lists.glasklarteknik.se
  - Past incidents URL
    - Checked in file that we keep updated?
    - GL issue board with label filtering?
  - gregoire: immediate reaction is the use is different so i would keep them
    separate
  - elias: thinks it is good that is separate -- for someone that comes from the
    outside -> it is likely they are completely uninterested in one of the
    things. E.g., just a witness. THen it is good that it is just a witness, not
    information/announcements about other things.
  - elias: to do them together, then we're assuming how it is for us. We could
    do that, but it's not good when we're communicating. We should think about
    how it looks to the people we're communicating with, not based on how it
    looks from us internally. And "the other end" doesn't need to know about
    both of the things.
  - rgdd, elias: also seems like the cost of splitting them should be pretty low
  - rgdd thinks the same as elias and gregoire
  - elias: also this is an example for folks that operate witnesses and logs.
    But maybe they just operate one of them. This sets independent examples for
    those that maybe just run a witness or just run a log. You don't have to run
    both just because e.g. glasklar happens to do that. Esp import for those
    eyeing the witness things, they shoulnd't see potential difficulities that
    may only happen for e.g. sigsum logs.
  - elias: re past incidents -- i like the "one checked in document idea". It is
    one file that is in git. You can see what commits have happened. Also a lot
    less error prone compared to "we forgot to add a label; someone
    accidentially removed a label; etc". And there's no history in the gitlab
    label things. So a version controlled document seems more robust. It's also
    good for those that look at this from external point of view: people can see
    if we are honestly updating things relatively quickly, i.e., it is possible
    to see how quickly (or slowly) we're updating the page.
  - rgdd: would be easy to to a sigsum app for "honestly maintained dist info
    page", at least one that is harder to tamper with / lie about.
  - so elias votes for "just a file" and it is checked into git
  - rgdd agrees with elias thinking, thanks
  - elias regarding name: how humans talk/speak/think about witnesses matters.
    We want to make it easy to understand and talk about it. Names that feel
    like they are "names" and not just "witness-1" might be helpful.
  - that's what rgdd is thinking too
  - counter argument is: the name could be "glasklar's witness", but then we're
    assuming a single witness. Which we probably don't want.
  - rgdd: can elias set up mailing lists for glasklar?
    - elias is not sure if that was resolved yet, there was some issue
    - rgdd can't see any obvious "add list" button, maybe don't have privs for
      it too?
    - let's escalate to ln5
- elias: for witnesses, should when discontinuation announcements happen on some
  kind of protocol level?
  - elias is thinking from the perspective of those who will be using sigsum and
    rely on it. This is a future scenario when things moved further and is
    widely. People will be relying on it and be using it for things they use
    routinely. It's there. It's used. Fundemental infrastructure in the same way
    we have DNS, certificate authorities, etc. We don't send an email to them
    and ask them things, e.g., "are you going to shut down soon". If the sigsum
    system works in a way that perhaps I'm running in a certain way that depends
    on a group of witnesses. After a while those witnesses shut down. And then
    things stop working for me. I would have much preferred if it was built into
    the system if I get notified about that. I.e., I don't want to think about
    that myself.
  - "if you run a witness, then you must do this something. Like raise a
    flag/warning"
  - elias: one way it could work. Keeping track of the status of different
    witnesses and then come up with what is a good trust policy based on that.
  - elias: argument against something more formal. You can think like this. You
    never know anyway when things will shut down. You can't know the future.
    What you want is to rely on things that are independent (hardware, org,
    ...). If you succeed for that, there's no reason why they should stop
    working at the same time. They stop working sometimes, but no reason they
    stop working at the same time. This "is the flag", you will notice when the
    witness is no longer cosigning.
  - elias: maybe email works, maybe recommending a procedure that when you
    decide on a trust policy then you need to check the status of witnesses.
    What are they saying about the future. E.g., policy is "i only use witnesses
    that don't plan to disappear the next year". Then every 6 months you review.
    So a procedure like this can be written down -- "this is how the trust
    policy is maintained".
  - rgdd: if you want to write some thoughts/notes on trust policy mangement,
    independence parameters, etc -> that would be nice!
