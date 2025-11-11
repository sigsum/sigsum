# Sigsum weekly

- Date: 2025-11-11 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: elias
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
- florolf
- nisse
- filippo

## Status round

- rgdd: sync:ing with C2SP maintainers to get v1 tags
  - https://github.com/C2SP/C2SP/issues/175
  - https://github.com/C2SP/C2SP/issues/176
  - https://github.com/C2SP/C2SP/issues/177
  - https://github.com/C2SP/C2SP/issues/178
  - getting v1 tags for all except witness, that will come a bit later
- rgdd: helped elias sort out checker and filed some issues for Tom:
  - https://github.com/tomrittervg/checker/issues/5
  - https://github.com/tomrittervg/checker/issues/6
  - Tom is happy to take patches
  - TODO: one more issue about different login and from email
  - (elias can tell you about what's the current checker status)
- rgdd: sync:ed with folks to prepare roadmap proposal -- see decisions
- rgdd: the usual review/rubberduck stuff! :-)
- nisse: Implemented stricter policy file parsing
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/277
- nisse: First stab at per-log bastion support
  - https://github.com/FiloSottile/torchwood/pull/35
  - looks easy, but few details to sort out (how to react on config changes,
    retries, and how to test it -- right now completely untested)
  - maybe an other topic, or if we can sort it out in the pull request
- nisse: updated poc witness for mullvad test log
- filippo: had a good week!
  - tagged v1s for c2sp specs (see links that rgdd provided)
  - finnished impl of witnessing config pulling in sunlight, deployed to test
    witness
  - it's a PR if anyone wants to look at it
    https://github.com/FiloSottile/sunlight/pull/52
  - holding up pretty well -- took forever to resolve a not null bug thing in
    SQLite
    - upside: have metrics now -- as a result of the debugging process :-)
  - thinking about merging later this week; then decompission testing and move
    to staging
  - is it a problem to remove the testing witnesS?
    - no
    - but maybe we shouldn't add it in the new test policy
    - new staging witness should replace what is currently test witness
    - elias: how soon will that change be done?
    - filippo: not sure, 1 day to one week. Depending on what's more convenient
      for you folks.
    - elias will wait until filippo did this
    - filippo will speed it up so we can have it sooner rather than later
    - filippo is looking at metrics
      - age staging submitting; 2 sigsum logs submitting; ... -> looks like its
        going fine! And filippo is willing to call it ready, testing has done
        it's job.
- filippo: tagged new version of litewitness (including pull-logs command)
  - also functions to read tlog tiles bundles etc, some clean up, ...
  - see NEWS file: https://github.com/FiloSottile/torchwood/blob/v0.6.1/NEWS.md
- filippo: had a look at niels plan for per-log bastion, responded on the issue
  but havn't yet looked at the impl. Will try to do it ~tomorrow.
- filippo: published draft about what tlog-proof spec in c2sp could look like:
  - https://github.com/C2SP/C2SP/blob/push-ywowmntwnspm/tlog-proof.md
  - https://github.com/FiloSottile/torchwood/pull/34
  - the one change filippo made when experimenting with it: a "hint" field,
    which is just opaqye b64. Can be anything. E.g. for the context, things like
    "hey this doesn't verify but with different context it would have verified.
    Did you perhaps rename the file?" and so on.
  - how the context is built into the leaf is totally up to the application, so
    can be used for anything
  - the other use case filippo found for it: VRFs (and there's a pull request
    for impl tlog-proof in torchwood)
    - URL:
  - API that basically is similar to verifying a signature
  - rgdd: in proof spec document, good to have also steps for how to verify
    proof?
  - filippo: it's a branch in the c2sp repo
    - nisse can help?
    - yes -- put this down on next steps
    - Eric Myre's draft:
      https://github.com/warpfork/spicytool/blob/main/spicy/format.md
    - nisse wrote a comment about the hint thing, nisse thinks more structure
      could make it more useful? Or if it's just app specific blob, maybe the
      application could invent its own way
  - filippo: this abstraction is because you might want applications to move
    around these files as a single file. And then applications will have
    different needs for out of band things to communicate. Was thinking about
    defining structure to merge into context. But then can only use for apps
    that will follow that exactly.
  - maybe chat more about this in the other section? Made changages after the
    below example.
- filippo: another example about how the hint can be used.
  - been wanting to write a blog post: transparency backed key server
  - essentially say: key server, where sync really helps
  - most used openpgp server is just a centralized service that you trust! (you
    shouldn't trust it, but in practise don't accept signed keys so can't web of
    trust!)
  - blog post wants: start with central service, email address and gives back
    pubkey
  - then step through how to add transparency to it
  - 1. add tlog
  - 2. when client fetches, it wants a tlog proof (hence tlog-proof)
  - list of email addresses, bad. So instead use a VRF. Compute VRF on email,
    and put the VRF hash in the leaf. When someone asks hey can i have pubkey
    for hi@... we give them a proof that it's the correct VRF hash for that
    email. And that proof goes into the hint. Now for the tlog proof to be
    useful, you need the extra bits that lets you compute the VRF stuff. TADA.
  - now: poisioning risk, 32 arbitrary byte. Not the worst poison risk, but it's
    a poison risk. So next -- we hash them, and put a hash in the leaf. Which
    means we need an endpoint to return all the preimages.
  - that's it
  - blog post will step through each of these decisions, what they're for, and
    how it avoids breaking monitoring
  - have impl all the way to anti poisoning -- was really fun!
  - in the process: cleaned up VRF package that's in C2SP
  - rgdd is happy to review blog post if filippo wants
  - https://github.com/FiloSottile/torchwood/pull/36
- elias: added policy-maintenance document, feedback is welcome on how to
  improve it:
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/policy-maintenance.md
- elias: MR about adding new builtin test policy "sigsum-test-2025-3":
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/281
- elias: MR about adding first builtin prod policy "sigsum-generic-2025-1":
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/282

## Decisions

- Decision: Adopt roadmap until mid January, 2026
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/127/diffs
  - Renew roadmap towards end of January, 2026
  - sounds good to everyone

## Next steps

- rgdd: bunch of minor smaller things that i have on my TODO list
- rgdd: look at a PR for litebastion
- rgdd: file issue
- filippo: review nisse's litewitness bastion patch
  - and nisse will continue finalizing this
- filippo: bring up staging navigli witness
- nisse: will PR to the tlog-draft document (verify section)
- elias: named policy things, see MRs above
- rgdd: add sigmon to www.so/docs
- everyone: comment on leaf context proposal (see other section link)

## Other

- rgdd: question to florolf
  - link sigmon from www.so/docs ?
  - sure we can do that!
  - warning: thinking about changing config format and some other stuff
  - so basically it is a bit in flux
  - that's ok!
- nisse gathers input on open questions on "optional leaf context" proposal
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/125
  - Iron out open qustions today
  - Decision postponed for next week, it's not urgent.
  - Status: close to ready, nisse would like feedback to get it finalized until
    next week
- on the topic of licensing that was discussed at last weekly meeting 2025-11-04
  - https://reuse.software/ has tools that may be useful
  - Thanks florolf for the tip!
  - nisse: I haven't looked at the details, but I think tillitis applies REUSE
    to their code.
  - it's a guideline on how to declare copyright in a file/project
  - so it's basically just a way to do this
  - reasonable default if you're setting up something new
  - didn't comment in the PR and only mentioned on matrix since sigsum already
    has a template
  - i.e. not sure it makes sense to introduce a new standard
- c2sp.org spec webpage rendering?
  - at the moment https://c2sp.org/ redirects to https://github.com/C2SP/C2SP/
  - filippo: it's been on the todo forever
  - filippo: would be good to be able to easily navigate between versions etc.
  - filippo: the idea was to have some yaml frontmatter for specs
  - if anyone wants to help impl it: filippo is happy to help for 15m or so
- Out of time -- comments and discussion would be appreaciated wrt. hint!
  - https://github.com/C2SP/C2SP/pull/181
