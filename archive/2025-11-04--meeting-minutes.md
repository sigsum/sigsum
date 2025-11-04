# Sigsum weekly

  - Date: 2025-11-04 1215 UTC
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

  - elias
  - ln5
  - rgdd
  - nisse
  - filippo

## Status round

  - nisse: Created sigsum-c repo, https://git.glasklar.is/sigsum/core/sigsum-c.
    - who wants to review code there?
    - <--- rgdd
    - next step: figire out which license to use
    - next step: seutp CI and build appropriate CI images
  - nisse: New proposal on leaf context, 
https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/125. Please have a look, and we could decide this in a week or two.
  - nisse: Merged stricter policy docs, https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/261. Filed https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/152 for corresponding implementation changes.
  - nisse: made sigsum-go release yesterday
    - tag v0.12.0
    - https://git.glasklar.is/sigsum/core/sigsum-go
  - rgdd: roadmap drafting -- will probably looking something like this (but still need to sync with others and circulate; was hoping to already have a doc i could share today. I will share it later today and will queue up decision for next week).
    - Support sigsum leaves with signing contexts
    - Support deployments with one bastion host per log
      - talked to filippo about that last week, agreed on direction
      - semantics is that if a log has its own bastion then the witness can choose to use only that bastion when talking to that log
      - plan is to add that functionality as part of litewitness
    - First supported version of the sigsum-c library
    - First supported version of the sign-if-logged TKey app
    - Recommended trust policy for non-testing usage
    - Experiment with Tessera-backed sigsum log
      - can be helpful to get closer to rekor, possibly converging
      - find out if replication works, or what it would take to get that working
    - (Elias might ship away at a few more onboarding issues.)
      - helps to get familiar with different parts of our codebases
    - TODO: talked with filippo but need to look in my notes, might be something more based on that
  - rgdd: providing some input/feedback wrt. VIs (it's also on martin's wish list that we get a VIs going for Sigsum logs)
  - rgdd: probably something more i'm forgetting right now, been doing a bit of rubberduck:ing and review
  - elias: writing down procedure to decide upcoming builtin named policy (so far we only have test policies, and this is what you'll find in the sigsum-go release yesterday)
    - naming: current suggestion is "sigsum-default-YYYY-n"
      - e.g. first policy during 2025 would be called "sigsum-default-2025-1"
        - "sigsum-default-2025-1"
        - "sigsum-default-2025-2"
        - "sigsum-default-2026-1"
        - "sigsum-default-2026-2"
        - "sigsum-default-2026-3"
        - nisse: better use something like "generic" instead of "default"
      - is it okay to call it "default" in the name despite not technically having any default?
        - nisse: default is not quite right
        - maybe "generic", "general purpose"
        - rgdd: is a word necessary? could it be just "sigsum"?
        - elias: then user's won't know it can be other things? I.e. understand intuitively that there can be others.
        - nisse: org, name, time
        - name should catch essense / purpose
        - the "pretty good" policy, that's sane if you don't know what you're doing
        - filippo: not much to add, all sounds good / reasonable
        - filippo: ppl will want a default (so there should be a default when they don't have witness opinions). And second, default need to be able to evolve but without breaking existing users such that old signatures stop verifying. So when we generate a public key, it will be tied to a specific policy.
        - filippo: if i generate a pubkey, does it include a policy?
        - nisse: no not yet at least, maybe we should add something for managing key attributes in sigsum-key
        - filippo: selection should probably happen at key generation time, and then there's a way to override it
        - filippo: but feels wrong if i have the same pubkey, message, signature; and then one year apart they used to verify but they don't verify anymore
        - nisse: agreed, it should not get a default from the verify-tool
        - filippo: and it can't be in the signature
        - filippo: so public key should include the policy
        - nisse: yes most convinient way for user is to have this in the public key file
        - nisse: it's just the sigsum-key tool that doesn't have this yet
        - filippo: maybe the policy should be in the key file rather than the name?
        - rgdd: currently it's the name that can be specified together with the key (as an attributed)
        - filippo: the way to create user flow with a default -> newly generated pubkeys get default policy embedded. So TL;DR: feature request get this into sigsum-key.
        - filippo: about policy change, users will have to think about it like a key rotation
    - filippo: people will want a default, so there should be something for them
      - that default needs to be able to evolve but without breaking existing usage
    - filippo: thinking about where the policy can be decided
    - how we select witnesses and logs for the prod builtin named policies
      - hard requirements
      - other considerations
  - ln5:
      - tor consensus transparency:
          - one dirauth (directory authority) is submitting consensus documents (two variants) every hour, to barreleye, since about three weeks; https://gitlab.torproject.org/linus/tor/-/tree/tlog-consensus/contrib/dirauth-tools/consensus-transparency
          - a monitor is running, following barreleye and collector.tpo; https://gitlab.torproject.org/linus/consensus-transparency-monitor
            - continously downloading the consensus documents that show up in the archive (called collector)
            - does not scream loud enough right now, plan to change that
          - immersed myself in the fine art of alerting
  - filippo:
    - got started on release notes for torchwood
      - including litewitness with the "pull-logs" feature
      - https://github.com/FiloSottile/torchwood

## Decisions

  - None

## Next steps

  - elias: complete draft of document about builtin named policy procedure
    - nisse wants to review
  - rgdd: circulate concrete roadmap proposal, aim for decision next week
  - rgdd: review sigsum-c things
  - everyone: read nisse's leaf context proposal, aim for decision next week?
    - backwards-compatible implementation of leaf context
  - ln5:
        - tor consensus transparency:
            - finish the simplest possible alerting functionality
            - write a blog post
  - filippo: release torchwood
  - filippo: finish sunlight witness implementation including pulling witness-network.org configuration
  - filippo: then, verifiable indexes

## Other

  - License for sigsum-c? It will depend on GNU Nettle and GNU GMP, which are dual licenced GPLv2 (or later) or LGPLv3 (or later), meaning that users of sigsum-c will have to comply with one of those licenses. So in some ways, it would be simplest to use the same dual license for sigsum-c. Using a license that is more permissive than LGLv3 would matter mainly if we or someone else modifies sigsum-c to make it depend on some other implementation of the underlying cryptographic operations (which should be rather easy).
    - rgdd: if we choose BSD-style license, then someone could replace Nettle and GMP and then use our code as part of something proprietary
    - rgdd: not much has changed since we took the decision for the other repos
      - sticking to BSD license should not make things difficult for users
    - rgdd: then I think status quo wins?
    - ln5: if we hope that people will include this everywhere, then this might differ from our other repos in that respect
      - rgdd: I think that makes it even more important to use a permissive license like the BSD license
      - rgdd: people will be able to use sigsum-c in something proprietary if they only go through the trouble of removing the Nettle and GMP dependencies
      - nisse: it seems reasonable to stick to the BSD license
      - nisse: we will not really object if people use sigsum stuff in their proprietary stuff
      - rgdd: if we later want to do a collaboration where GPL license is needed, then we can relicense in that way, more easily than changing in the other direction
  - elias: should history.md be updated?
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/history.md
    - rgdd: yes! good catch
      - rgdd: if nobody else wants to do it, I will do it before the end of this year
  - nisse: implementing the stricter policy thing, is that something I should do pretty soon or should someone else do it?
    - nisse: I could do it
      - rgdd: if someone other than nisse wants to do it, poke nisse
