# Sigsum weekly

  - Date: 2026-05-12 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: nisse
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - tta
  - rgdd
  - florolf
  - elias
  - nisse
  - mw
  - warpfork
  - Justin Cappos
  - filippo
  - gregoire

## Status round

  - rgdd: had a lot of fun at the meetup last week, thanks everyone who showed up
    - a highlight for me was discussing the ongoing sigsum 'next' ideas
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2026-05-12-sigsum-next-meetup-notes
    - i've also posted this link in our drafty C2SP PR where we iterate with hayden
    - https://github.com/C2SP/C2SP/pull/244
  - rgdd: we're gonna figure out maybe persisting some more meetup material next week
  - rgdd, nisse: reviewed / posted comments on tlog-witness subtree cosign API
    - https://github.com/C2SP/C2SP/pull/245#issuecomment-4430254853
  - rgdd: filed issue to get Al Cutter added to tlog-witness as maintainer
    - https://github.com/C2SP/C2SP/issues/247
  - rgdd: poked again about tlog-policy getting assigned in c2sp by stewards (ben asked what's needed to move it forward / what's the hold up)
    - https://github.com/C2SP/C2SP/issues/226
  - tta: very happy with the meet-up
    - took a lot of notes at the meetup about ATrans
    - got the idea to pollute barreleye with a png (bruteforcing H(H(data)) only)
      (vibe-coded source https://dev.archive.rip/ggs/only-vibes/poison-sum bwoop)
      - it works
      - the result is hard to recover: it is not obvious it is an image.
    - just to make the point
      - nisse: good to get some more input on what the cost is for an attacker to add data
      - warpfork: since it is not obvious that what you have added is an image, people may not see the point in doing such an attack (this is a good thing!!)
  - florolf: experimented with TrustZone ed25519 signing oracle + vanilla litewitness to reduce storage bottlenecks -> ~150 qps
	  - still figuring out how to do rollback protected storage safely without exhausting monotonic counters
	    - somewhat similar to what others are doing using YubiHSMs
  - florolf: Polished demo https://github.com/florolf/windrow and did a test deployment
    - to simplify storing payloads of what is being translogged
  - florolf: Mullvad relay list monitoring
    - Mullvad does tloging of their relay list
    - the way it is currently setup it's not easy for 3rd party to monitor
  - florolf: wrote notes about witness network capacity planning
    - put that into a PR (https://github.com/transparency-dev/witness-network/pull/42)
  - justin: trailofbits did something intereting about TEE-based things (https://blog.trailofbits.com/2026/04/07/what-we-learned-about-tee-security-from-auditing-whatsapps-private-inference/)
  - warpfork: finally pushed a round 1 of content to become https://tlog.directory/ : https://github.com/FiloSottile/mostly-harmless/pull/11/changes
	  - thanks to everyone who reviewed earlier iterations of this!!!
	  - still not perfect but I think good enough to start with, and extend in more PRs from here?
	  - fine by me if someone were to extract more of this to a completely separate resource, and we reduce this even more sharply to just a link hub, but anyway this exists now
	- it renders to tlog.directory? --> not yet
  - elias: tested litewitness metrics that warpfork implemented
    - https://github.com/FiloSottile/torchwood/pull/71
  - filippo: spent a few days travelling and sick
  - filippo: Go freeze is really soon, lots of work related to that
    - that takes most of my bandwidth at the moment, will have more bandwidth starting Wed next week
  - filippo: tlog-wise some things happened:
        - we got unblocked regarding verifiable indexes
          - want to avoid having a A and B tree for verifiable index
          - if you need to block on witness cosigning then that's a problem
          - want to say "I will write this, what will the new root hash be?"
          - the google team seem to be prioritizing verifiable indexes now
          - rgdd: earlier it was mentioned to setup a verifiable index for a sigsum log, will that happen?
            - filippo: yes, I'd be happy for Geomys to run that
            - filippo: we can let google figure things out a bit first, then we can deploy it for sigsum
        - MTC (Merkle tree certs) is moving, it is the truly unstoppable train of the tlog infrastructure right now
    - filippo: I will likely purchase expensive HSMs
      - considering putting things inside the HSM firmware, stateful tree
    - Justin: thinking about related to all of this:
        - we work with systems that do more than a tlog tries to achieve
	          - systems tend to (if you squint) act as witnesses and logs for eachother
	   - if some people want only tlog and others want more extensive security properties, then the question is if tlog is a good stepping stone on the way
	    - nisse: if you use a tlog like Sigsum, then you get the advantage of witnesses helping you, without those witnesses needing to know anything about your application
	    - Justing: in some cases systems have a bit of a tlog property
	      - filippo: can we discuss this more concretely?
	       - filippo: for Go, tlog and verifiable indexes are all that's needed for some things
	    - Justin: I'd be happy to look closer at that
	    - Justin: in some other systems one needs some stronger properties
	      - assuming everyone here is relatively familiar with Sigstore
	        - there you have ephemeral keys, you trust that Fulcio is doing the right thing with Rekor
	          - when trying to integrate that into a full system there are problems
	            - suppose there is a sigsum package in PyPi and Filippo is the person supposed to sign that package
	              - we then ask PyPi who is supposed to sign that package
	               - now all I have to do is to hack PyPi to make others believe that someone else is to sign sigsum
	               - so all you have added is some kind of auditablity, which is helpful but may not be enough
	             - filippo: the tlog should be poerated by PyPi and it should be tloging everything
	               - you would have the correct person monitoring tlog
	            - filippo: need a systems thinking about how and where to apply tlogs
	            - Justin: you are asking hundreds of thousands of developers to do something, you blame them?
	              - filippo: no I blame us for not making it easy enough
	           - Justin: I wonder, is there some tweak we can do to tlogs to make things work better?
  - nisse: have been working on sigsum-c together with mw
  - mw: it's been that and some internal debian packaging for our sigsum-agent

## Decisions

  - None

## Next steps

  - tta: n/a (away next week for admin work & holidays)
    - tta: my project starts in June
  - rgdd: ops looks like i persisted ST minutes in sigsum repo yesterday, will fix
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2026-05-11-meeting-minutes.md?ref_type=heads
  - rgdd: more spec tinkering, maybe progress on per-log bastion in witness network?
    - short week though so not sure how much progress i'll be able to do
    - will wait for filippo more available next week wrt. per-log bastion witness netw
  - rgdd: if anything is urgent, poke me, preferably today or tomorrow
  - florolf: looking at tlog-policy spec
  - florolf: considering improving usability for sigmon
  - filippo: I'd like for folks to add here
  - filippo: litewitness metrics: https://github.com/FiloSottile/torchwood/pull/71
  - nisse: more sigsum-c
    - more release polish and then do a release or release candidate next week

## Other

  - elias: could anti-poisoning be improved by additional ping-pong for each submission?
    - (related to what tta wrote above) 
    - log server would pick a salt that the submitter must use, so that the submitter cannot predict what the logged double-hash will look like
        - if the submitter computes fast enough, he can still do the same thing, no?
          - no, it will cost in terms of wasting the rate-limit quota for the submitter
    - If rate-limit counter is incremented each time a submission is initiated, poisoning would become expensive for the submitter.
 - nisse: about prevention vs detection:
       - if you want prevention then tlogs will not do much for you
       - but if you have done all you can about prevention and you want to improve further, then you can add detection using tlogs
       - rgdd: we are not in the business of prevention, basically
       - filippo: the reason I love tlogs is that they let me deploy mechanisms
         - filippo: the go checksum database is an example
         - filippo; tlogs let us do prevention in context of the go checksum database
         - filippo: so we don't need to just say "just trust google"
         - filippo: now there is a system where you get protection, because if you try to publish two different versions of a package you will not suceed
         - filippo: so tlogs in a systems way let you achieve prevention
         - rgdd: you're right that it's hard to change the same version, but you can create new versions
           - filippo: yes, but this means you cannot affect an existing build
         - justin: I think, what I'd rather do is take the Go sumdb and some other examples and do a security analysis of that
             - justin: you can never get perfect security, so it's always a question of if an improvement can be made
             - filippo: these are two known shortcomings about Go at the moment:
                   - go sumdb is not using witness cosigning (but will soon have it!)
                   - we are putting the monitoring ability into the Go tools
            - justin: I need things that are well-formed that I can look at
              - justin: sometimes people say "version 2 will solve everything" and that's not always clear what that means
              - rgdd: an example of existing tooling is gopherwatch
              - rgdd: there is work on a academic paper at Chalmers, but from a more mathematical approach
              - justin: what is the right thing for me to be looking at?
                - rgdd: we are moving to C2SP, all specs should be there longterm
                - rgdd: the only spec not yet in C2SP is log.md
                  - rgdd: the log.md spec basically says "we are building LEGO with these specs"
              - rgdd: if you want to schedule a call, let us know
        - justin: building blocks are good, the question is if the building block that Sigsum is now, if that fits into other places where it could be used
          - let's think about if there is something we can do to make it better
        - rgdd: we are more than happy to hear if you spot somthing that is bad or that could be improved
          - rgdd: regardless of the outcome it will be good
          - justin: you have a superpower, which is that you can say "this is out of scope"!
            - justin: it's good to be clear about what the scope is
        - filippo: with my Go hat on, I'm happy to read anything about the Go sumdb
        - filippo: I want to read something that pokes at the things I need to fix that I did not know about before
        - tta: I'm going to spend the next 10-12 months is talking to people who have never heard of transparency, regarding digital archives
          - tta: I will try to get them to ask questions about transparency
          - tta: I would very much like a resource that I can point to where I can say: "I am proposing this thing but it has its limitations"
          - tta: the thing justin is talking about is going to be useful to me
          - justin: yes, it's good to be able to say "here is what this is, caution about this"
          - justin: I expect in about a month that we will have something, we will also come back with questions
