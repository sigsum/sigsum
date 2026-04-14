# Sigsum weekly

  - Date: 2026-04-14 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: florolf
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - rgdd
  - warpfork
  - florolf
  - elias
  - tta
  - mw
  - nisse
  - filippo
  - gregoire

## Status round

  - nisse: sign-if-logged pre-release
    - https://www.glasklarteknik.se/post/sign-if-logged-prerelease/
    - try it out! Any feedback is most welcome!
  - warpfork is working on a draft of a one-stop-shop info link extravaganza: https://hackmd.io/@warpfork/Bybd49snZl/edit
    - something to rapidly show what transparency logging is about
    - it's a draft at this point, there are some TODOs in it
    - including links to community things
    - if someone wants to read through it and give feedback, that would be appreciated
    - intended for a planned "tlog directory" website
    - can have sections for e.g. "developer tooling", with links to different projects
    - to have a place to collect stuff
  - fyi, mhutchinson is working on a static-html(+js) tlog viewer (like woodpecker, but web): https://github.com/transparency-dev/incubator/pull/119
	  - florolf: neat! deployed a copy to https://nyx.n621.de/sigsum/barreleye/ and added a sigsum decoder
	  - seems really nice
  - elias: added per-log bastion for seasalp log:
    - https://git.glasklar.is/glasklar/services/sigsum-logs/-/blob/main/instances/seasalp.md
    - deployment similar to barreleye
    - runs on the same server as the log itself
  - tta: wrote all my ideas about Archive Transparency here
        https://dev.archive.rip/ggs/openrip/draft-spec/src/main/SUMMARY.md
        until I could no longer write, I think I need external output, feel free to
        take a (quick) look -- but start from #Introduction :)
      - created https://matrix.to/#/%23archivetransparency:matrix.org to talk about it
      - rgdd already asked some clarifications, will answer them today
      - need to read about / teach myself about everything C2SP
      - plan to read more this week
      - rgdd: questions about c2sp so far?
        - tta: just getting familiar with it right now
          - planning to write some python code to try things out
          - at the moment everything looks clear
    - rgdd: have read the intro and overview parts of what tta has written
      - nice
      - had a few minor questions about terminology
      - rgdd: recommending others to take a look at the introduction and the overview
      - good that the scope has been narrowed down
      - nice work!
  - rgdd: have been looking a bit at the PQ tlog-cosignature suggestion
    - have a few questions on that in the Other section
  - rgdd: have also been reading a tlog-related paper and providing feedback on that
  - filippo:
    - worked on tlog-cosignature update with ML-DSA signature type (https://github.com/C2SP/C2SP/pull/237)
    - addressed most things except wether to do clever encoding of oid
      - question about how hard it will be to make IETF accept certain things
    - another question is prefixing for names
      - is there a reason to have a name that is more than three lines long?
      - happy to hear opinions on that
      - a suggestion is to limit names to at most 255 characters
        - nisse: another option is to use hash of names, then you get the same length always
        - filippo: I don't think I care so much about fixed size in this case, when it's not something that is parsed
        - nisse: it's just a minor thing, the difference is that you can't make the mistake of using a size that works in some cases and not others
        - filippo: I think that bounidng sizes of things is something we should have done
        - nisse: I agree it's good to limit the size of things
        - filippo: a bit afraid of entering into bikeshedding about kind of hashes
          - want to avoid parametrisation hell
        - filippo: some decisions here are defensive to avoid bikeshedding
          - want to avoid ending up with 2 different implementations

## Decisions

  - None

## Next steps

  - rgdd: will take a look at warpfork's link
  - rgdd: think more about tlog-cosignature PQ PR
  - rgdd: roadmap
    - nisse will continue with sign-if-logged and other tkey-related stuff
    - elias will work on witness deployment things
    - rgdd: if others want to add things in the roadmep, please tell me about it
  - nisse: starting looking at sigsum-c issues that need to be fixed before release
  - nisse: preparing slides for a presentation next week
  - elias: m looking at issues we're having with perf + yubihsm
    - we will want to run with >1 yubihsm per machine
    - will be making progress on this to ensure this happens
    - (more about this in other sect.)
  - mw: get onboarded :-)
  - tta: take a look at tlog.directory +will work through C2SP+other docs 
  - florolf: work on some issues in sigmon that have been pending for some time

## Other

  - elias: litewitness, we (Glasklar) need parallel signing
    - parallel signing for multiple logs
      - filippo: will ping nicola about this issue
      - rgdd: what is the timeline for getting an answer?
        - filippo: can ask for it to get prioritised this week
    - https://github.com/FiloSottile/torchwood/issues/66
    - https://github.com/golang/go/issues/78473
    - likely to happen in x/crypto/ssh soon, or do we need a workaround?
  - elias: need prometheus metrics for litewitness
    - https://github.com/FiloSottile/torchwood/issues/5
    - filippo: this should be easy to add
  - maybe a few words about tlog-cosignature w/ PQ resistance
    - rgdd: about the "oid hack"
      - nisse: ideally if we are settled on ascii names then it would be nice to stick to ascii names
        - if someone wants to add other things then they can do that as a blob
        - filippo: this was an attempt to minimize the diff on their side
        - nisse: would like the witness to not have to know the structure of the origin line or log id
          - filippo: I have no strong opinion, we can try with decimal
        - rgdd: you have the log orging line, and then a cosigner id, and those could be the same?
          - filippo: yes, one of the cosigners can be the log
        - filippo: a wording thing, what is a log if not a cosigner?
        - filippo: at the cryptography layer, there is nothing special about the log signature
    - rgdd: if we look back a bit, we had a binary sigsum format earlier and then that was changed to checkpoint, and now it's going back to binary again?
      - filippo: this is just a different signed message
      - filippo: there is the cryptography layer
      - rgdd: to me it looks a bit more like a v2 thing rather than a v1.1 thing
      - rgdd: anyway I got the answers that I wanted!
      - nisse: minor comment on choice of hash:
        - if we pin the hash function used in underlying merkle trees and inclusion proofs, then it seems uncontroversial to use that also for other things.
