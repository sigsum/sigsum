# Sigsum weekly

- Date: 2025-01-07 1215 UTC
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
- filippo
- gregoire
- ln5
- nisse
- elias

## Status round

- rgdd: deployed email notifications on new (direct) dependency updates in
  sigsum-go, log-go, and key-mgmt. The check runs every day at 0800 on
  monitor-01.gtse.
  - nisse: all reported issues can be viewed by
    https://git.glasklar.is/search?search=godep-check&scope=issues
  - (Thanks Linus for fixing the email alias for key-mgmt)
- rgdd: holiday ssh+sigsum prototype with e2e story
  - https://git.glasklar.is/rgdd/sshdt
- rgdd: holiday check-if-filippo-publishes-all-age-releases prototype
  - https://www.rgdd.se/volatile/age-release-verify.txt
  - pointers from filippo on how to build the binaries reproducibly so this
    prototype also gets the full end2end story that we want to be able to demo?
  - btw: there are no sigsum proofs for the latest age release -- nit?
- rgdd: a few half-baked holiday notes/ideas relating to policy format and named
  policy things (sharing so i get them persisted and not lost if they're useful)
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2025-01-07-notes-on-policy.md
- rgdd: got my broken checker setup fixed, it's self-test emails were arriving
  in spam.
- rgdd: i didn't have time for two of my TODOs that I listed last weekly, so
  copy-pasted them again for today's next steps.
- filippo: chatting about maps -- the interesting that came out: intermediate
  format for how to form the map? How to convert entries in a log into keys and
  indexes.
  - martin's idea, he will write it up
- filippo: played with the public dashboard for litetlog, snowballed a bit into
  a reusable component to expose logs from arbitrary go applications (slog
  component -- http endpoint / slog handler that automatically limits
  connections etc). Does it need to be that much? No, but it was the holidays
  having fun hacking on stuff!
- nisse: on holiday since last weekly, catching up on email. Replied to jas on
  sigsum-general about proof format / spec.
- ln5: working on something related to what we need for our witness, namely
  building reasonably nice images for RPI. So there's progress there, but won't
  be able to finnish the next week. But I think it is doable in ~2w.
- elias: did work on monitoring thing for the log (checker) -- we have something
  now (heartbeat submission). Did something for checking the size, but saw
  comments about that from rgdd and we might do it in another way.

## Decisions

- None

## Next steps

- rgdd: more of the things i didn't have time to do from last week -- draft on
  "about pages" for glasklar's log/witness (to get the ball rolling)
- rgdd: and upgrade witness to v0.3.0
- filippo: litebastion issue still needs to be handle (from last weekly)
- filippo: exposing that litewitness logging (actually litebastion logging too)
- elias: monitoring for the seasalp log, think about what to add (if the log
  size check is needed or not)

## Other

- fyi: feedback/suggestions/questions from jas on sigsum-general
  - https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-general@lists.sigsum.org/thread/I465MH46WGSGNKOFDSUZM5T3SLRG2IC7/
  - it's a good point that if the format is "in flux", it will be a barrier for
    deployment. (And if it isn't a barrier and people deploy, then we will be
    stuck with the current version=2 format and likely not want to deprecate it
    for a long time.)
  - sticking with a "sigsum format", e.g., ".sigsum" might not be so bad? I.e.,
    rgdd is not 100% sure it makes sense to converge on a proof format that
    doesn't include the signature. Apart from "version=2", there's nothing
    redundant in the current format that can be removed without the proof being
    unverifiable. I think it could be relatively quick to push this into a
    stable spec in project/documentation alongside log.md?
  - (not raised by jas, but i think policy.md is equally important; but I'm
    worried we haven't done enough dog-fooding of its use and evolution to be as
    stable yet. This relates to named policies, default policies, when you
    transition from one policy to the next, etc.)
  - leaf line -> would be content in a non-sigsum thing
  - filippo: supporting two encodings = not the end of the world
  - filippo: supporting two semantics = not great
  - tooling could quite easily support both in the future
  - main possible improvement of more checkpoint like: witness name instead of
    keyhash, easier to debug
  - but still mostly encoding
  - filippo: if it's blopcking deployment, then would not block on something
    with unclear timeline. Even if we start working today, who knows if we get
    everybody on board and if we end up bikeshedding on something. So anything
    broader than the people in this call: outside of our control and has
    coordination time baked into it.
  - so: consider making the current spec a first-citicen spec, because it seems
    like it wouldn't be so hard to start supporting a new one with different
    encoding.
- best practices for reproducing binary releases: post-facto? unpacking?
  - number of ways to make a release reproducible
  - check in a script that generates a release; checkouit that version of the
    repo and run the script.
    - some limitations -- e.g. can't update it if something breaks
  - have a separate script that just has a gigantic switch, that behaves
    differently for different releases. Because you probably change your
    process. But means you need to keep build steps in two places; one that does
    the build and one that reproduces it.
  - Orthogonal decision: of whether you reproduce the entire tarball, or if you
    take a tarball as input and take it apart and check that some parts are what
    you expect them to be.
  - nisse: in st releases, the input would be signed git tag. And from that a
    tarball is made and its made in a reproducible way. And its separate from
    building the executables from that tarball.
  - filippo: difficult step is building the executables in a rb way.
  - elias: rule to say that you have to reproduce everything that's inside? so
    that there can't be any "run-me-first" in there that the monitor doesn't
    spot and reproduce?
  - filippo: different tar parsers might disagree on what's inside a tarball. So
    you might make one tarball that monitor thinks is one file, and windows
    think is two files.
  - so filippo prefers the exact set of bits that went into sigsum.
  - unsigned repro, and then inject the signature?
  - the microsoft signature to use is in the tarball?
  - guidande / first example is needed; filippo can solve for age but others
    might need more handholding
  - filippo: will try something similar to this: make a script that given a
    version generates it; and that script has hardcoded the signature for now.
    And then nice thing about it: can test the script in CI, like can have ci
    run the script; download all the releases / plug parts of it into what
    rasmus poc:ed. To make sure the script is correct. And as soon as i make a
    release, ci/release fails; i extract the signature and stick into the script
    and commit.
    - ...missed a few bits when taking this note -- sorry about that!
