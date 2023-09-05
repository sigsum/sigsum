# Sigsum weekly

  - Date: 2023-09-05 1215 UTC
  - Meet: https://meet.sigsum.org/sigsum
  - Chair: rgdd

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - rgdd
  - nisse
  - filippo
  - ln5

## Status round

  - rgdd: paging back where we're at after vaccay, catching up with review backlog
  - rgdd: drafty documentation of sigsum's processes
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2023-09-05-sigsum-processes.md
    - (if you have any input, please poke rgdd)
  - rgdd: drafty answers about sigsum's current readiness
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2023-09-05-sigsum-readiness.md
  - rgdd: what we learned from tillitis and sigsum hackaton before the summer?
    - closing: https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/52
    - (won't write it up more than those comments, now we can grep for tillitis to find them)
  - rgdd: 50/50 now on sigsum/st (working 100%)
  - nisse, rgdd, filippo: submitted two talks to cats workshop
    - https://catsworkshop.dev/cft/
    - https://git.glasklar.is/nisse/cats-2023
    - (Filippo will push an abstract to the archive soon)
  - nisse: drafty dependency proposal
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/44
    - read/comment, would like to get this decided in 1-2 weeks from now
  - nisse: 50/50 now on sigsum/st (working total 80%)
  - nisse: wrapping up sigsum v1 changes, moving MRs forward after getting
    review. Including progress on monitoring, so that we can save+restore state.
  - ln5: addressed !140; took a pass over the Ansible collection
  - filippo: ramping back up from vaccay this coming week.  Talked about
    witnessing APIs with rgdd, have proposal that's about to be filed about that.
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2023-09-05-summer-walks
  - filippo: making progress on Go monitor, and that tooling.  Have a good idea about
    what needs to be done to move this forward, as discussed a bit during our walks.

## Decisions

  - None

## Next steps

  - nisse: more of the same, working on the monitor
  - nisse: take a pass on the refactored/polished log.md, consider making a
    proposal for defining cosignature=output so that the spec becomes fully
    self-contained
  - nisse: new tag for log-go with v1 stuff
  - rgdd: draft a release email, and note done something about that process
  - rgdd: propose and circulate an updated roadmap, to be decided next week
  - ln5: nothing planned, please point me at sysadmin related things you need to get done
  - filippo: will push cats abstract to the archive, and a witness.md proposal
    based on this summer's walks with rgdd

## Other

  - An email on the (concluded) ietf-trans group that may be interesting to peek at:
    - https://mailarchive.ietf.org/arch/msg/trans/Xyqdf8lWmiT-o1X-8X6C2RqkTos/
  - New log-go release? It never happened before the summer
    - NEWS file have been merged, not sure about the release process
    - Will make a new tag with the latest v1 stuff (nisse)
    - Then prepare an email (rgdd)
    - jellyfish (on poc) is currently running v0.13.0-16-gc2d0561
    - ghost-shrimp is currently running v0.12
  - Do you have a favorite project that has well-defined releases cycles,
    release expectations, definitions of quality, etc?  What are the criteria
    for changes and new things to get included in the next release?
    - filippo: there's a release team at Go, makes sure things are stable.  Not
      very documented, other than the release cycle. rgdd/filippo will talk more
      after the meet.
    - filippo: [curl writes](https://curl.se/dev/release-procedure.html) a lot
      about their processes
    - filippo: there are counterexamples of what not to do...
  - Input to rgdd's drafty pads?
    - provided by nisse, thank you
  - Input to roadmap planning? We're renewing next week
    - nisse: need to finish monitor and witness, to get them in a good state.
      Get our own operations up and running.  Related to that we need docs
      around key management.  And docs about primary/secondary failover.  Tests,
      of the documented failover procedure.  Docs, like explaining and tutorial,
      something similar to design.md but up-to-date, that would be nice to have
      too.
   - filippo: stabilize witness api, same with tools (bastion and witness).
     "The short term list of TODOs", still represents my immediate next steps
     probably.  Writing up the witness-monitor connectivity requirement, or at
     least push our notes on that.
   - linus: mostly interested in how we communicate releases.  If we can
     practise what happens if we break backwards compatibility etc, would be
     good.  And would like to consume that from an operator's perspective.  A
     document for the release stuff would be nice.
  - Any opinions on molecule (for testing our Ansible roles)?
    - No input; ln5 will deal with it
  - Dependency proposal 
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/44/diffs
    - if we add dependency (rather small, often the case in sigsum), then we
      want to review before adding.  1) we want to do that locally, so that we
      get the right hash.  2) once we reviewed and decided on version, how do we
      compare that what we get in our go module is the same?
      - filippo: observation, comparing git hash with go sum line is kind of
        hard. What you can do is a go get on the git hash, and let go clone and
        find the right thing and put in the go sum file.  That's how you know
        you can rely on go tooling to fetch the right thing.  (So what's in go
        sum, is hash of tarball stuff).
      - filippo: concrete suggestion: go mod vendor.  Either keep the vendor
        folder, or use it to do the review.  So if you go vendor -> you're
        reviewing what's in the go mod file.
      - If the vendor thing is saved, you get a diff in the vendor directory.
        So you don't have to review everything from scratch, again.
      - Are there any docs about this?  The go command / manual.  Filippo will
        send something later today on Matrix.
    - filippo: general tooling for checking consistency of local views and
      checksum database would be nice in general...e.g., to check that the code
      you wrote is actually what's in the checksum database. But that's not a
      tool that exists right now.
