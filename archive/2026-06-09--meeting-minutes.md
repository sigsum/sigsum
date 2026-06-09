# Sigsum weekly

  - Date: 2026-06-09 1215 UTC
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

  - elias
  - tta
  - Justin Cappos
  - nisse
  - florolf
  - mw
  - filippo
  - rgdd
  - marco

## Status round

  - rgdd: iterated a bit on 'next' ideas with hayden
    - https://github.com/C2SP/C2SP/pull/244#issuecomment-4615035651
    - now is a good time to read through the spec there
  - rgdd: followed up wrt. some CA incidents that motivate CT, and also included the San Bernardino case which is pretty old but nice because of threat model aspects.
    - https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-general@lists.sigsum.org/thread/VLEQLPTVCNLNK4ITJICA5ICFEPG7PUGV/
  - rgdd/martin: tdev prepping, have a drafty CFP (call for presentations) now and is about to invite PC members
    - the CFP should go live in about two weeks
  - rgdd: looked at eric's litewitness metrics patch
    - currently running it on rgdd.se/poc-witness + hooked it up with grafana
      - seems to be working
    - will be suggesting a few minor changes and additions asap
      - hopefully later today
  - nisse: Released sigsum-go v0.14.1, see https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-announce@lists.sigsum.org/thread/B7KAQP7LH7EGTQPYAXL2KJZ552A2ORXW/
  - nisse: Improving tests for tkey-sign-if-logged.
  - tta: various things
      - no progress on slides or text to talk about transparency to non-tech ppl :(
        - need to do it asap, only 10 days left and I've told Basile Simon from StarlingLabs that I'm sending some
      - misc progress on AT nothing much
      - had a discussion with Basile Simon
        - he is using "witness" to talk about "court witnesses" in his "Zeitwerk" project
        - next steps are unclear yet, he looks interested by the transparency model and reputation-staking talk
        - Basil is interested in having proofs that hold up in court
          - Looking for better ways of doing that digitally
          - Courts tend to not look much at tech but at surroundings, who is using the solution
          - filippo: these things are very much more social that technical
            - something to ask him: what techincal thing would he need to convince others?
            - perhaps link to Chrome MTC (merkle tree certificates) usage as an understandable example
            - does he need something where a file is checked, showing checksum, timestamp or similar?
            - rgdd: would like to hear more about the court cases and similar, to understand more how transparency could be useful there
            - rgdd: please point him in the direction of the transparency dev summit
            - justin: good to tie to something people understand
            - justin: people using the legal version of TUF
            - justin: we are intertested in using transparency there, that can be a tie
            - justin: we're very interested in whatever comes out of this, I have connections to lawyers and others
            - filippo: point them to the transparency dev slack and interest survey
            - tta: next time I will talk more with him
              - right now he is doing freelance work
              - will spend some time talking to him
  - florolf: pushed an updated version of sigsum-go to buildroot
    - rgdd: q for florolf: is tombstone things on your list soon?
      - florolf: yes, hopefully soon
      - rgdd: later in June I may start writing something about that myself, let me know if you start before then
  - nisse: minor release of sigsum-go earlier today
  - nisse: working on sign-if-logged tests and other things needed for that
  - filippo: implemented subtrees in torchwood
    - filippo: sent a PR to merkle tree certs with test vectors
    - rgdd: so you implemented subtrees and you made testvectors based on that?
      - filippo: I also used other implementations and made sure three separate implementations agree
      - filippo: if anyone tried the test vectors and they don't match up, that will be interesting
      - filippo: there is one CT log operator that will not archiove its own logs
      - rgdd: did I read correctly that you had to not use a persistent connection?
        - filippo: due to rate limiting things, you have to spread out
        - rgdd: so you had to patch your archiver?
          - filippo: did something using claude, checked that the result worked, easy to verify the output
        - filippo: upgraded witness machine operating system (debian)
  - justin: had a bunch of meetings, including with Hayden, related to this
  - justin: had discussions in Linux Foundation about standardization
  - justin: to put on everyone's radar: isojdf (?) standardization
  - justin: expect to have more to talk about next week
  - elias: working on parallel signing for sigsum-agent, with help from nisse
    - using pipelining w/ ssh in litewitness (using specific commit from crypto lib)
    - seems to be working, have run some tests
    - filippo: the patch in go crypto has been merged, but no release yet
      - rgdd: could we get that into litewitness then?
        - filippo: sure
  - mw: working on the deployment of a group of witnesses at Glasklar
    - working with linus on that

## Decisions

  - None

## Next steps

  - filippo: bring in ssh patch wrt. pipelining in litewitness
  - rgdd: suggestest changes/addition to prom metrics in litewitness
    - then poke filippo to get this merged and tagged
      - hopefully today or at the latest tomorrow
  - rgdd: start looking at end-to-end monitoring of a witness
    - filippo: you can look at the wiitness uptime hting we have as a starting point
      - filippo: it publishes a witness-network format log list with a single log
        - filippo: there the log does not change, just the same checkpoint over and over
        - rgdd: I will want something where the log grows
  - filippo: a bunch of PRs and issues in torchwood and sunlight
  - filippo: implement new things in sunlight
  - filippo: if there is anything that needs me that is not a PR or an issue, please make a PR or issue
    - nisse: what about the tlog-policy spec?
      - filippo: at the moment that is blocked due to other stewards (not me), will talk to them
  - tta: talk to Basile and produce my slides

## Other

 - tta: spend a day packaging various SLH-DSA for python https://dev.archive.rip/ggs/only-vibes/slh_dsa_multi
   - not sure exactly what I'm going to do with it – produced with much agents and generated code
   - for the usecase of archive transparency, would like to use SLH-DSA
   - filippo: SLH-DSA has maybe better theoretical footing than lattices, but other things also matter
     - filippo: For MLDSA there has been much more effort put into securing them
     - filippo: there are different classes of risk
     - nisse: speaking of bugs, as an implementor I have the impression that SLH-DSA should not be too vulnerable to certain kinds of bugs
       - filippo: yes, and also may be better against sidechannels
    - tta: there seems to be a lot of fear and uncertainty around this topic
    - tta: one usecase is a tombstone for archive transparency
      - an observer may use a different key for a tombstone
      - florolf: about implementation security: MLDSA care about long-living signatures
        - if people are validating signatures made today in 10 years
        - filippo: yes, verifier bugs are not a problem, someone just has to eventually make a good verifier
      - tta some people have taken the position of using a fixed seed for the randomness of the algorithm, as a way to protect against some side-channels
      - filippo: when I say randomness sampling I mean something different
        - filippo: if you have good test vectors you will probably be fine
        - filippo: if you have a MLDSA prototype for now, it could make sense to wait with SLH-DSA
        - tta: I think I will use MLDSA everywhere I can
        - tta: a lot of artifacts will be captured in the early days of the project
          - so early signatures will be important
          - important in the chain of "who believes who believes who"
  - q for tta: why different key for signing tombstones?
    - tta: people are not very good at operational security
      - tta: may want to have an offline key somewhere that I only access sometimes
        - tta: also want to have only one story to tell to my operators
        - tta: the story will include offline signing of tombstones, I think
