# Sigsum weekly

- Date: 2025-08-19 1215 UTC
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
- elias
- nisse

## Status round

- rgdd: prototype/demo site for witness configuration, work in progress
  - https://git.glasklar.is/rgdd/witness-configuration-network/-/tree/main/site
  - will be pinging for a bit of feedback, but not all at once to avoid burning
    everyone's first impressions at the same time
  - but this is basically just an attempt at fleshing out the proposal for the
    target audience (existing operators, potential new operators; both logs and
    witnesses)
  - elias -- so witness, no downside that it configures all kinds of logs?
    - yes; whereas which witnesses you chose is something that logs select
      manually from the table of participating witnesses
  - nisse: no big cost for log to add a random witness? Sort of, but with some
    limit. Tree heads scale with number of witnesses, so not great if it grows
    to large (and doesn't make that much sense to get huge amounts of witnesses)
  - elias is happy to take a look whenever rgdd pokes
- elias: worked on proposal about named policies, see Other section below
  - got many comments already, some things that need specifying
  - rgdd, nisse: few small things to polish, but largely speaking -> looks great
  - should be a proposal on accept track next week
  - elias will make an MR with final changes until next week
  - it's not critical with review on these changes, just circulate the proposal
    before next week's weekly for those that are interested reading and weighing
    in
- nisse: asked for tkey castor prototypes, to soon start doing tkey+sigsum work

## Decisions

- None

## Next steps

- elias: update named policy proposal for accept track next week
- elias: dm rgdd with what will not be done in current roadmap, and whether he
  thinks it should be continued next roadmap (or if he should focus on something
  else -- if so what is elias' suggestion)
- elias: get my test witness cosigning mullvad's test log
- elias: ensure we have issues for simon's good suggestions
- rgdd: roadmap update; virtual walk with filippo; then figure out what's
  highest up on the priority list for me

## Other

- Tillitis published this on their website:
  - "Guide: Setup A Sigsum Lab Witness Using TKey"
    - https://www.tillitis.se/guide-tkey-sigsum-lab-witness-howto/
  - there is also another doc they wrote, elias added it in our archive with
    feedback
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2025-07-02-witness-setup-feedback.md
- [comments](https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/51#note_27391)
  from jas on named policies, two related questions jas raises:
  - "Consider putting /etc/sigsum/ skeleton files in a separate project, and
    don't put it in the sigsum-go repository since ideally I would like to see
    non-go sigsum implementations being able to use the same configuration
    files."
  - "I'm still not certain how we should protect policy files. Signed?
    Checksums?"
  - elias: think simon wants the info that is compiled into the binaries, should
    not be in sigsum-go repo. Which is like a lib that we use from the Go code,
    but that can also be used from sigsum-c and sigsum-py etc.
  - nisse: i can see the point, could be its own repo and if you want to include
    it in a cryptographically sound way; then maybe a git submodule would be
    reasonable. And then explicitly bump that when it's reasonable.
  - but then it's a distribution thing. So if we keep it in sigsum-go, and you
    want to use it in another project, then you'd either have to copy that
    catalog from sigsum-go or do something like go-run sigsum-install to get
    them dumped.
  - elias: think it seems sounds to have them in a different repo, because
    sigsum-go is bound to the programming language. (Cf specs - also not bound
    to a particular impl)
  - and then the go binary uses that repo as source of truth, bumped manually
    probably
  - not super critical as step 1 perhaps, but sounds sound
  - elias: a point to have it in a different repo - if you think someone that
    looks at the project from the outisde. What kind of changes are happening?
    Some are impl. Some are spec. Some are policy. Feels reasonable that there
    is then a change in the policy corner.
  - elias: on /etc skeleton files, hard coded policies. They are not the same as
    etc/sigsum catalog. I.e., this is what other actors can chose to install on
    their systems. What we're talking about is: what should be compiled into the
    binary. That doesn't come from etc/sigsum catalog. If I did this in other
    repo -> i wouldn't call it /etc sigsum skeleton, it's not what it is. It's
    built in policies.
  - elias will ensure we have issues for all good ideas from simon if we're not
    addressing them right away in favor of something something smaller first and
    iterating
- nisse: ST usecase, sigsum-logged claims of appropriate pcr values?
  Pre-vacation sketch:
  https://git.glasklar.is/nisse/st-complete-poc/-/blob/main/doc/pcr-claim.md. I
  see two variations,
  - 1. claim specifies the pcr hash value + source of that value (git repo +
       commit). Monitor needs a procedure for checking out that repo and
       reproducing that single value.
  - 2. claim specifies individual event hashes (EFI action, EFI separator, UKI
       PE hash, kernel image PE hash) together with some source reference for
       each. Makes monitor's job more complicated.
  - But in either case, it's essentially a build claim, which is falsifiable by
    a third party. Ideally, one would also need a tlogged source claim; some
    authoritative party claiming that this particular version of the
    corresponding sources is appropriate. The build claim monitor could
    potentially verify that the commit corresponds to a signed tag or something
    like that, but then things become a bit fuzzy and implicit.
  - And in the absence of a separate source authority, what checks should
    verifiers do, e.g., should the verifier check that the listed source in the
    pcr claim is known, or leave that vetting to monitors?
  - rgdd: think build and source authority = the same in this poc
  - nisse: question - pcr hash value and pointer to source code its tied to -
    should verifier have criterias on how the source code pointer should look
    for "accept"?
    - rgdd: i'd say no - it needs to be able to extract a signed + tloged pcr
      value, that's the essence.
  - for what to log, the essense is the monitor can reproduce pcr value
  - monitor looks up checksum in some service to get the same claim, and from
    the claim it tries to verify its correct. If claim includes a pointer to
    shell code, then the monitor needs to know how to build.
  - pcr value + git revision seems to be the minmal, and monitor needs to know
    which repo to look in.
  - (verifier mainly cares about pcr value)
  - same submit key for many different machines, then maybe you also want
    something that identifies what service this is for - context.
    - but not needed in poc
    - rgdd: i a little bit miss an additional h(context) in log entry
      - nisse agrees, would be useful; not the most minimal design but can see
        some use
      - nisse: concrete example, now nisse signed os pkgs when doing tests
        without saving ospkgs. Now he can't use the same key for things he want
        to monitor, instead have to create a new key. With context/namespace, he
        could have kept the key and changed the namespace.

### rgdd remarks when reading through the tillitis post

- painpoint: design doc (cats'23 pdf) is a heavy read for newcomers
  - explainer doc on both sigsum and witnessing would be helpful, perhaps also
    bastion separetly. I.e., I'm missing docs for newcomers that are not specs.
  - (getting started is a tutorial, not an explanation doc.)
  - also a good link to have: something for vkeys that isn't spec
- painpoint: >1 key formats
  - mention sigsum-key might have been helpful in this post

nisse added comments in the matrix/irc room.
