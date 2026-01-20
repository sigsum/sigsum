# Sigsum weekly

  - Date: 2026-01-20 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: gregoire
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - rgdd
  - gregoire
  - elias
  - florolf
  - quite
  - nisse
  - filippo
  - wolf

## Status round

  - rgdd, ln5: fyi: sigsum room upgrade 10->12
    - if you saw "cilck this button to get to the new room", that's why
    - slack bridge is currently broken due to this
    - ln5 (async comment): the background for the matrix room upgrade is that rooms with a version < 12 suffer from security issue(s), see:
      - https://matrix.org/docs/communities/administration/#room-upgrades
  - rgdd: upstreaming out-of-tree checker patches i've had for too long to tom
    - https://github.com/tomrittervg/checker/pull/8
    - elias will try out the changes
  - rgdd: forgot to mention i drafted an update to history.md during christmas
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/133/diffs
    - would still benefit from minor polishing / wording improvements
    - if you see anything that's missing or should not be there -> let me know
    - please comment in the MR if you have suggestions
  - rgdd: wasn't able to do my next steps on paging in witness blog post and redeploying my witness with the new ansible that does per-log bastion
    - queueing it up again, but unsure if/what i'll manage until next week
  - rgdd: fyi: quite started at glasklar yesterday, he will be working with ST 75%
  - nisse: Progress on sigsum-c, merged bytecode spec and verifier.
    - https://git.glasklar.is/sigsum/core/sigsum-c/-/merge_requests/10
    - https://git.glasklar.is/sigsum/core/sigsum-c/-/merge_requests/7
    - also working on other missing pieces needed for tkey apps
  - elias: not much to report -- will be trying out checker changes rgdd mentioned
  - florolf: been trying to port the spic library to RP2350
    - takes about 200 ms to verify a sigsum proof
  - filippo:
    - thinking about how to upgrade security of geomys key storage
      - ct logs standard currently is keys on file, terrible
      - considering usb armory
        - possibly several of them
      - possibly use a confidential VM to sign leaves using a fast processor
      - can handle 200 per second
         - https://github.com/usbarmory/usbarmory/wiki/Benchmarks-(Mk-II)#cryptographic-acceleration
      - only things that seem to be fast are actual HSMs that would cost more than the entire log machine
      - want hardware security plus secure storage
      - can split high performance into confidential VMs
        - but then no storage so cannot be witness
      - still have not figured out how everything regardiong usbarmory will work
      - for confidential VM, if you can ssh in then you know you are running the right code (attested by AMD)
      - the part with usb armory, possibly several of them, still not clear
  - wolf: can give update on what we have been doing for the conda usecase
    - probably we will run our own log
      - considering participating in witness network
      - filippo: sigsum log or a plain tlog?
        - wolf: don't know yet
        - filippo: sigsum is essenially doing multiplexing of multiple identities
          - allows running a log as a public service
        - running a plain tlog means it's just for you
          - that is how the go checksum database works
        - sigsum is a mechanism to have multiple sub-logs in a single log
        - wolf: for now, it looks like there will be only one identity that signs and puts things in a log
          - with witnesses cosigning
          - filippo: all of those htings you can do with either a sigsum log or a plain tlog
          - filippo: if there is a concept of multiple identities then sigusm can be good
          - nisse: one possible benefit of using a sigusm log is that you can use some other log as well, for example if your log is not always available
          - filippo: ultimately they all work with the witness network
          - when will the witness network be production ready?
            - mostly testing witnesses so far?
            - rgdd: the thing I would like to see added is the per-log bastion feature
            - filippo: I think a good rollout starts by failing open, and then switches to failing closed after a few months
            - rgdd: if you want production witnesses already now, you can get that by contacting those witnesses directly, just email each individual witness operator
              - rgdd: we are happy to help you with that if needed
            - filippo: the witness network is intended to make that easier, but you can also talk to witnesses directly, without using witness network
        - rgdd: please write in the sigsum matrix room about anything that you tried and did not work, and so on
        - test vectors?
        - rgdd: we could have a binary that you can run, that runs various tests against your log or your witness, and tests various corner cases and so on
          - rgdd: florolf also requested something like that earlier I think
        - filippo: we could even do it for production witnesses, as part of adding them to the witness network we could run tests
        - filippo: note that logs are not trusted, the important thing is witnesses
    - rgdd: we (most likely) have at least one more person joining Glasklar soon, that will help us with keeping up on things like this that need to be done

## Decisions

  - Decision: In sigsum policy spec, disallow using "none" as a member of a group. Only valid use of none would then be to define the quorum. 
    - Issue: https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/170
    - implementation: https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/300
      - (the only intended use of "none" is to write "quorum none")

## Next steps

  - rgdd: highest on prio list is roadmap update draft + sigsum-c review
  - rgdd: after that (in sigsum) is ansible redeploy and witness blogpost
  - elias: try out checker changes that rgdd mentioned in status round
  - nisse: will continue with the sigsum-c
    - want to do policy compiler as well as verifier for sigsum proofs
  - filippo: same as last time because I went down the hardware rabbithole
  - florian: conptinue with bootloader work
  - quite: more onboarding and get into roadmapping with rgdd
  - gregoire: just waiting for litebastion changes
  - nisse: proposal about tagging (see notes in other section)

## Other

  - nisse: Tagging, see https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/171. It would be nice with a proposal for next week. If standard semantic tags are reserved for proper releases, we have two main alternatives: Either add a "-dev1", "-dev2" etc suffix on non-release tags, or depend on raw commit hashes for any inter-project dependencies on non-release versions. Some open questions: 
      * If latest release is, say, v0.14.1, should the next dev tag be v0.14.1-devX, or v0.14.2-devX, or v0.15.0-devX, or something different (say, date-based)? What are others doing?
	      - Canonical answer is v0.14.2-dev.X
	      - filippo: about go: the hashes can be used just like tags
	         - you can have a tag like 0.14.1 or anything like 0.14.1-devx
	         - if you use commit hash then that works too
	           - will be in the go checksum database
	         - the argument for using tags is that monitoring becomes impractical
	         - the reason to make explicit tags is to get the signal that "there is a new release"
      * How are tags that don't look like standard semantic tags handled by go tooling and the checksumdb? Say your dependency graph includes dependencies on the foo package, with several different versions like v1.1.0, v1.2.0 and v.1.1.0-dev? Which version will be selected in the build? Does it matter if it's a v0.* versions or not? How do dependencies with commit hashes fit in the selection machinery (they automatically get a "syntetic"  version name of the form vx.y.z-date-hash, chosen by go tooling, based on existing tags and commit history)?
	      - https://pkg.go.dev/golang.org/x/mod/semver
      * Will we get a monitor notification when people depend on such a synthetic commit-hash version of our go modules? Or can the monitor just check that the checksumdb entry is consistent with that git hash, and tell us only if there's a discrepancy?
  - rgdd: do we need a proposal for this?
    - nisse: yes I think so, I will write a proposal for next week
  - filippo: if anyone wants to chat about putting a witness on a usb armory then let me know
