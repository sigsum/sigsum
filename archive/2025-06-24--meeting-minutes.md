# Sigsum weekly

- Date: 2025-06-24 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- elias
- rgdd
- filippo
- gregoire
- nisse

## Status round

- elias: wrote notes about named policy things (also under Other below):
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2025-06-13-named-policy-notes.md
  - been discussing with nisse, more about this in the other section
- elias: discussed with Tillitis about the possibility of them running a witness
  - doesn't really exist yet, but they're looking into it and i'm discussing it
    with them (configuration things and so on).
  - they will of course want to run it so that they're signing with a tkey
  - question: plain signer app, or some apps with key backup?
    - this is the kind of things they have to think about
    - elias said it's good to get started even if its not the best long term;
      start in one way; document how they're running it and what to expect; then
      improve. But it's useful to get started as long as you're clear about what
      you're doing and why.
    - elias has been stressing the importance of both running and *documenting*,
      showed how glasklar documented operations. Doesn't have to look exactly
      the same, but it's a general idea that inspiration can be taken from.
- rgdd: fyi: slack bridge suddenly works again!
  - filippo will keep an eye on if the bridge continues to work the next ~weeks
    or so
- filippo: photosynthesis is out, tlog-mirror is c2sp spec and iterated a bit on
  it. Landed on a side-car design for tlog witness. So mirror is just a witness,
  after you submitted a checkpoint it behaves 100% as a witness. So it will
  never roll back. Then you can also send it entries and it will sign with a
  different key. Then it means consistent and mirrored up until a particular
  point.
  - https://mailarchive.ietf.org/arch/msg/tls/6jqhUVz58s4ZgsZ8HvuZftncT9A/
- filippo: some more ct stuff, and some conversations with fredrik and rasmus
- filippo: working a bit on verifiable index data structure, kind of hoping to
  find out that even at a billion keys it fits in memory. If it does, then might
  drop all support for storing the tree in a database. Or maybe just
  serialization and deserialization for fast start, but not directly into the
  database because it's way slower and harder to play with.
  - work in progress. :)
- nisse: was at cysep ~2 weeks ago. Talked to a bunch of people about our
  poster. I think we managed to get the main points across. Saw a few of the
  talks. One guy from FRA talking about vulns with examples. Another guy about
  gps jamming and disturbances.
  - elias: as we've been saying before, it's not super easy to grasp the ideas.
    Folks don't get it immediately, but when you talk to them you can get it
    across.
- gregoire: we have a test sigsum log up and running! We're waiting for hardware
  to setup a production log.
  - don't have the URL at the top of my notes, but gregoire will add to the
    notes later
  - question: do you want some other test witnesses?
    - yes
  - poke rgdd and elias for more test witnesses
  - question: public commitment for the mullvad witness?
  - this is still on gregoire's TODO list, to write an about page with this kind
    of info
- gregoire: because we use postgres in other things and trillian supports
  postgres, we're using that for the log!
  - how are things configured, ansible?
  - docker images, deploy with docker

## Decisions

- Decision: Cancel weekly meets from July 8 and forward, next meet on Aug 12
  - Due to summer holidays

## Next steps

- elias: implement named policy functionality
  - but depends a bit on if there are comments/input
- elias: release sigsum ansible v1.4.0
  - but first test and merge
    https://git.glasklar.is/sigsum/admin/ansible/-/merge_requests/80
- rgdd: read elias proposal, catch up with c2sp and photosynthesis stuff
- gregoire: will try to get more witnesses to our test log, and if we get the
  hardware get started with the production log
- nisse: won't be doing sigsum stuff for a while now (going on vacation)
- filippo: blanking right now, but. Figure out a sigstore format. Verifiable
  index data structure. We might have written doen something in roadmap or
  minutes from before -- vkey format, proof format? And feedback to elias about
  named polcies.

## Other

- elias: plans for named policy functionality are here:
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2025-06-13-named-policy-notes.md
  - feedback is most welcome
  - should that be a proposal?
  - so far policy = policy file. You supply it.
  - we want that to continue to work exactly as now.
  - but the "named policy" option has been discussed for a while, instead of a
    file you give a name. And it means an exact thing, similar to if you had
    specified a file with the same content that's associated with the name. It's
    basically a level of indirection. Makes UX easier.
  - three ways of specifying policy
    - pyt things in a file (what we do now)
    - built in policy -- policies compiled into the software. Certain names
      correspond to certain policies. Nice to have a way to just print out what
      the name mean. Nisse already mad an MR that does that.
    - but we think it's also good to somewhere in system directory
      /etc/sigsum/... there you can put files that are sort of on your system
      preconfigured; and they will also be named policies. But they're a
      different kind of named policies. Not built in my sigsum, but rather what
      you get from your system. Could be confusing?
  - named policy: either built in (hard coded) or one from /etc. And there will
    be an order of priority. If you drop in under /etc/, then that has priority
    over the compiled in policy. So that it becomes possible to do what you want
  - filippo: sounds great, doesn't sound confusing to me at all. Works as I
    would have expected.
  - (elias continues) detail that matters - ambig. if its a "name" or a
    filename. Current idea: same flag as now (-policy), but introduce a
    convention that if it starts with colon (:) then it's interpreted as a
    named policy
    - filippo: don't have a strong opinion, its ok
    - but generally not a fan of flags that can be files and not files
    - then you have to worry in scripts: attackers putting colon or not...etc. I
      like when flags have "imaginary types".
    - so something is either file path OR string, and there's no way to confuse
      a string for another thing
    - so filippo generally prefer when flags have a single semantic that doesn't
      depend from the value
    - don't think it's a major concern, but might be more clear with a separate
      flag
    - elias: one reason for doing it the way i wrote now is -- in sigsum-submit
      command it accepts -p flag and also a -k flag. And depending on if the -p
      flag is specified or not -> it behaves in different ways. Now with
      separate flag, that logic becomes more complicated to describe.
    - filippo: maybe just "capital -P"
    - nisse: i'm fine with separate options, we just have to find a good short
      option
      - capital -P?
      - nisse: not awful, only drawback visually very close
    - filippo doesn't have a strong opinion (and capital -P just a suggestion),
      whatever you pick makes sense
    - nisse: but think it makes sense with a short proposal that suggests
      options to use and priorities to resolve names; and a suggestion for a
      convention for how names would look like.
    - rgdd also thinks a proposal would be good -- decide after summer but
      sounds like we're happy with this direction based on how it was introduced
      verbally now
    - elias: should mention, the idea is once these named policies exist -> it's
      not supposed to change. We can def. ensure it is the case for built in
      ones. But on /etc/ -> it would be possible, and it's strongly recommended
      not to change them. And it will be reasonable to have a time indication
      related to the policy.
    - question: in which case it is beneficial to override built in policy with a
      file in your system? means that you kind of not agree with other ppl on
      what the policy mean anymore
    - elias: it's free software, so you could either way compile the software
      differently (in e.g. a debian package). So the tools should just let them
      do it.
    - nisse: one reason you might want to do this: you know a particular witness
      has been compromised, and maybe you want to delete it.
    - filippo: systems can always patch software -- if they want to override
      something let them. What matters is what we document as happy path. Don't
      have a strong opinion on if there's the technical capability to put a file
      in /etc/ or if it requires patching a file in /usr/bin
    - could have a "hook/option/env var" for only using built in policy
- what is photosynthesis?
  - a proposal for x.509 certificates out of tlogs, where ca runs a tlog. And
    puts entries in the tlog. Where entries are just tbs certs. So cert
    without signature essentially. Then when you want a cert, you make it out of
    an inclusion proof, a checkpoint, and a signature by the log on the
    checkpoint and signatures from witnesses on the checkpoint. That's the
    very core thing. But cool is what it lets you build. First you get
    witnessing. So you can replace all of CT with witnessing of the CA logs. You
    can put hashes of public keys in log instead of public keys. That solves
    problem of exploding the size of ct logs due to post quantum. And then you
    can completely optionally pre-ship checkpoints to clients, and then make
    certificates out of only the inclusion proof without checkpoint and
    inclusion proofs. Now you have certs without signatures. Solves problem of
    where do we put huge post quantum signatures without getting huge
    certificates. This is kinda how we wanted CT to be / closer to that, but it
    wasn't possible in the past.
