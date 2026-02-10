# Sigsum weekly

- Date: 2026-02-10 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: gregoire
- Secretary: rgdd

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
- gregoire
- nisse
- florolf

## Status round

- rgdd: been having very helpful ping-pongs with william about getting my poc
  witness up to the latest ansible + litewitness versions that support per-log
  bastions
  - now running this on my witness with serviceberry configured
  - we spotted a bunch of minor ansible nits along the way, william has been
    resolving and is still resolving a few things with review from elias
  - if anyone else wants to try per-log bastion configurations -> let me know
- rgdd, ln5: still hashing out high availability witnessing things
- rgdd: not much else, misc rubberduck and review things (sign-if-logged etc)
- elias: did some testing with litewitness and multiple bastions, seems to work
  - filed issue about TLS cert error handling for litebastion:
    - https://github.com/FiloSottile/torchwood/issues/63
- elias: blog post abouit named policies:
  - https://www.glasklarteknik.se/post/named-policies-for-sigsum/
- rgdd: oh one thing about litewitness per-log bastion stuff, bug (or missing
  docs)?
  - seems to get problems when trying to use both global bastion option and
    per-log bastions at the same time
  - rgdd: if it's not supported then it might be better to give an error message
    about that
  - filippo: do we have a usecase for global bastion option together with
    per-log bastions?
    - rgdd: I think yes, because that can make it easier to transition from
      global bastion to per-log bastion
    - nisse: longer term it seems reasonable to not have the global flag
    - rgdd: one possibility would be to not allow the global option, then users
      need to change their config to use the per-log bastion way
    - filippo: how about just disallowing the use of both at the same time?
      - rgdd: fine
    - florolf: how does that affect the witness-network.org things?
    - tl;dr: it's agnostic, just need a helpful command in litewitness to
      populate after pull-logs
    - tl;dr: witness to next version -> you need to start using the per-log
      bastion config path to achieve the same thing (this will be backwards
      compatible in ansible)
- nisse: working on sign-if-logged app (both device and host app), will be busy
  with this until a meetup next week. After that I will be on vaccay for a week,
  so not much progress on other things until next month.
- nisse: got a nice issue from florolf in sigsum-c, would like to talk more
  about this and other sigsum-c things in other section
- florolf: playing with sigsum-c, integrated in my test setup where i cross
  build. Resulted in the issue nisse mentioned above. For fun, took verifier in
  fuzzying harness. Ran for a couple of hours, so far no problems with that.
- florolf: few weeklies back -- we talked about how to deal with policies
  drifting away, and need to breakglass/backdoor. Thinking about impl. Need some
  kind of threshold mechanism. You can implement that using a sigsum verifier,
  it turns out! Basically generates a fake policy that lets you do m-of-n for
  this kind of mechanism. So can run with your regular policy. Fails? Can run
  again with the breakglass fallback mechanism.
  - https://github.com/florolf/sigsum-breakglass
  - filippo: mean run it again on the client?
  - yes
  - filippo: why not make that a separate group?
  - then you still rely on the log signature
  - if you want to handle the case where the log also fail...then need this
  - filippo: interesting departure of abstract policy in torchwood and actual
    sigsum policy
  - nisse: for breakglass, could add another log to the policy
  - could work
  - idea was: cleaner to have a completely separate thing
  - would not be that hard to get regular witness to get to cosign your
    breakglass log
  - current script - no state
  - filippo, think preference to have in policy rather than client have to do
    another thing right after?
  - florolf was thinking: i'm the party of getting these guarantees, not
    primarily trying to convince a 3rd party that i'm doing transparency
    property. But still fragile, can forget about it more easily compared to if
    it was in the policy. Have to think about that.
- nisse: speaking of fuzzing, external review was finished last week. And i
  think we had issues filed for all findings.
  - any public report?
  - there is a repo at gitlab, link:
  - https://git.glasklar.is/nevun/tlog-code-review
- filippo: missed meet last week. So report for last two weeks
  - custom host litebastion
  - duplicte keys
  - ...all in the news file for torchwood!
  - landed a few of the changes that came out of the code review (spec
    adherence, added the flag to try to hide the logs from public view)
  - merged PR by nisse (think it was also from that review, couathored på gk)
  - been working on geomys infrastructure for witnesses
  - probably usb armory plugged into tuscolo (which has 100% uptime so far as
    measured by google)
  - will then continue with a possible group scenario
  - nisse: could have 10 independent witnesses on sites and machine, and then a
    frontend that only cosigns the logs if it has a suitable quorum from the 10
    machines in the back.
  - this is what filippo is talking about, server looks for the quorum from the
    three armories. Prevents failure of a single armory.
  - want to do the quorum checking in a SEV-SNP VM, gets some hardware
    guarantees that quorum is enforced
  - florolf: and the VM is stateless, unlike the armories?
  - yes
  - VM as gateway; can even start doing e.g. ML-DSA signature and it will be
    fine for armory to not do ML-DSA. Will be fine as long as there's no quantum
    computer in between VM and armories.
  - "just give all the sigs to the client", doesn't work as well with post
    quantum signatures
  - AMD-SEV is nice for sign-if-logged
  - rgdd: resources for AMD-SEV?
    - filippo: https://github.com/usbarmory/tamago-sev-example
  - filippo has asked for the same thing from andrea, who have now written that!
- gregoire: an announcement, pushed sigsum-rust to crates.io v0.2
  (https://crates.io/crates/sigsum/0.2.0)
  - just the offline verifier w/ full quorum evaluation things

## Decisions

- None

## Next steps

- rgdd: take a look at the work by tta
- rgdd: more review and high availability witnessing with ln5
- nisse: sign-if-logged stuff more or less exclusively
- filippo: deprecate -bastion
  - https://github.com/FiloSottile/torchwood/issues/64
- filippo: tlog-witness read API
- filippo: also looking at witnessing with SLA
- elias: review sigsum ansible fixes from william
- rgdd: also follow up with william about a mis configuration for per-log
  bastion

## Other

- nisse: When should we try to make a first sigsum-c release? As early as March?
  To consider:
  - Proper docs (to which bar?).
  - REUSE annotations?
  - Shared library?
  - Release process/signing?
  - General polish.
  - nisse: kind of finnished for now, would be nice to make a release
  - before a release can happen ; where do we want the bar? and when do we think
    we can do that?
  - florolf: very much looking forward to that, would be happy if there was a
    release at some point. I'm happy to help if i can with some of these things
  - anything nisse wants help with?
  - would be heplful with review of the docs and general testing
  - florolf: are there any docs now, other than policy specs?
  - no, not besides what's in the header files - so by docs nisse means header
    files (and public APIs)?
  - nisse thinks README needs update, and good with an overview of API and
    examples
  - so once such docs available nisse would like review
  - florolf is happy to help
  - florolf: simon has been a bit silent, maybe we should ping him? And anything
    to help get this packaged in debian?
  - simon has asked for a shared library, even if we can't promise much of ABI
    stability
  - man pages for the tool would also make sense
  - nisse created a milestone for the release ; we will continue async (nisse,
    rgdd, florolf)

### request for input on irc/matrix from tta

links!

- gave a talk on the topic last summer, which reflect where i was at the time on
  the topic:

https://cfp.pass-the-salt.org/media/pts2025/submissions/DCMUBQ/resources/PTS2025-TALK-07-archive_rip_1LWK33D.pdf

- made a website since (this https://archivetransparency.eu/ here) and had to
  write a funding application, which both includes context for non-technical
  audiences:

https://archive.rip/archive_transparency_prototypefund25_redacted.pdf

- wrote a summary of "where i'm at" right now, there:

https://gitlab.com/archive-rip/openrip-draft/-/blob/main/SUMMARY.md
