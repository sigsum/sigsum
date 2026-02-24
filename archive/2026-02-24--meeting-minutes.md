# Sigsum weekly

  - Date: 2026-02-24 1215 UTC
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
  - filippo
  - warpfork
  - florolf

## Status round

  - rgdd: glanced at spicytool status
    - https://pad.sigsum.org/p/9226-359f-8422-1636-74ac-254d-410f-83d2
    - cli for generating keys for signing and verifying?
      - using hard-coded policy
      - using Tessera
    - warpfork if you use a log once a year, then I think you don't need a continuóusly running log
      - florolf: interesting because it's close to what nisse and I have been discussing in matrix, about breakglass things
    - warpfork: Tessera with posix backend is good
  - rgdd: mid through looking at tta's archive transparency stuff
    - about how to bring transparency to the internet archive and other similar archives
  - elias: preparing new release of sigsum ansible collection
    - https://git.glasklar.is/sigsum/admin/ansible
    - includes things filippo impl recently (e.g. per-log bastion; so supporting config of that is possible)
  - florolf: there's a buildroot Linux distro release that now includes sigsum-go
  - filippo: figuring out how to implement things with USB armory
  - filippo: thinking about AT proto tlogging thing, see Other secion
  - warpfork: about spicytool, it's open to suggestions!
    - can we replace signing like people do for files, with this thing?
    - like something that people can distribute like other signature files?
    - still don't know what to do about the policy
    - hard to sell something as a PGP replacement if you have to do some kind of signup first
    - filippo: about format, for spicytool, need witnesses that accept anything
    - filippo: we should have a mode that just doesn't use witnessing
    - rgdd: for a "dev mode", would it be helpful to have some "yolo" witnesses?
      - rgdd: at least one test witness could be online and ready to sign anything?
    - filippo: you cannor throw away all state and expect things to work
    - warpfork: (this is in the weeds but) might be good to have an extra flag in dev mode about generating an N+1'th identity.  (don't hide the problem, but make it non-annoying.)  but maybe this is a something where a docs example is enough.
	    - this is in addition to a yolo witness.  the yolo witness is what makes the user (usefully) aware of the problem that this then re-de-frictionalizes.
    - filippo: the dev mode should train you about the realities needed for prod
      - so it's good that it breaks
    - rgdd: the other UX challenge here is that you actually need to keep the state, so the state is important in a way that might not be obvious to someone looking at it for the first time
    - filippo: the yolo witness seems like a good thing generally

## Decisions

  - None

## Next steps

  - elias: sigsum ansible release
  - rgdd: a bunch of review things for nisse
    - sigsum-c
    - sign-if-logged

## Other

  - filippo: sigstore leaftype
    - filippo: this is something that came up with hayden
    - filippo: been thinking about how to merge the leaf types for sigstore and sigusm
      - why?
      - what both sigsum and sigstore do is "identity-based logging"
        - in sigsum the id is the hash of a public key
        - in sigstore the id is something else
        - we can express both of those as having an identity root of trust and then having some metadata (which in sigsum is nothing right now but could be something in v2)
          - in sigstore the metadata is oidc account, workflow identifier, and so on
        - the idea is to put the hash of the root of trust, and then hashes of key-values (hash of key, hash of value)
        - for sigstore that would be hashes of oids
        - for sigstore there is already a fixed list of oids
        - filippo: for me that seems very simple, almost obvious
        - filippo: first, I want feedback
          - second, how do we feel about the signature being optional or always external to the log?
            - post-quantum is coming, which will make signatures very large
          - sigsum has a very well contained, almost not possible to poison
          - for sigstore, the proof is gigantic, big risk of poisoning
          - filippo: I'm going against my own previous advice because I used to have to have things outside the log
          - filippo: how do we feel about storing this kind of stuff outside the merkle tree?
          - filippo: it's the kind of thing that's only needed when a key owner says that "wait, I did not sign that"
            - rgdd: are you saying that the log should always store this data?
              - filippo: it could be application-specific
              - filippo: in sigsum it can make sense to store it, the log operator would store it
              - filippo: the signature is only needed if the key owner accuses the log owner of injecting an entry
                - rgdd: what's awkward is that the log can cause false positives, as a key owner I cannot distinguish between the cases that my key was owned or the log injected an entry
              - filippo: the leaf type could be one and only one
              - rgdd: if you can fetch all the leaves, then you can fetch all the signatures?
              - filippo: this is not a decision or anything, just putting this thought into everybody's head
              - rgdd: in the case of sigstore, you are thinking that you would probably not store
                - filippo: it's signed by a thing that's sitting next to the log
                - filippo: custom x509 chains are different, more "sigsum-y"
            - rgdd: for the leaf, in addition to removing the signature, it would be key=value (hashed) and one such thing could be the context that we have wanted for sigsum?
              - filippo: yes
              - filippo: the leaf will have the many key-value pairs
                - but the API of sigsum can look like whatever sigsum decides
                - the API could let you specify arbitrary key-values, or not
              - rgdd: in sigstore they already know which key-value pairs they are interested in?
              - filippo: only the monitors interested in a particular identity need to know which key-value things are needed in that case
              - rgdd: if you have an opes set then you would want to hash them
              - filippo: a nice thing is that the same monitoring tooling could then work across sigsum and sigstore
        - rgdd: summary: extension of leaf, and dropping the signature
        - florolf: worrying a bit about size considerations
          - rgdd: you could choose to still use a small leaf for your usecase
        - filippo: one other thing to keep in mind: how do we feel about, if there is now no poisoning risk, sigsum could start accepting sigstore-stype submissions
          - rgdd: the showstopped before has been the poisoning risk
            - rgdd: but will need to think about if I'm forgetting something
            - rgdd: it's just the question of what is the submission API
          - filippo: this idea makes it possible to decide to join the submission API
  - filippo: AT protocol (bluesky)
    - warpfork: 
  - calendar link - see https://www.sigsum.org/contact/
    - https://nextcloud.glasklarteknik.se/index.php/apps/calendar/p/P2RDRwn8gNoCaBJd/dayGridMonth/now
