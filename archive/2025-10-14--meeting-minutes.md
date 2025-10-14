# Sigsum weekly

- Date: 2025-10-14 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: nisse
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
- filippo
- Grégoire
- ln5
- nisse

## Status round

- rgdd: witness network tinkering/discussing, a bit behind on what I was hoping
  to get done until this meet so it's on my next steps
- rgdd: bunch of misc rubberducking and smaller fixes, like www.so not building
  etc
- elias: discussed with Tillitis about their planned prod witness
  - hopefully becomes available soon
  - talking about about page for it
  - currently thinking about exactly how it will look
- elias: been thinking about and looking at named policy impl. But haven't
  gotten around to implementing more this week.
  - so we're still at testing policy in the tool (like last week)
  - a.k.a. we have feature for builtin named policy, and only one we have right
    now is the testing policy
  - and what we haven't done yet: the non-testing policy
  - queued up discussion point related to this in the other section
  - nisse would be happy to just have a test policy for a while and let the dust
    settle before a builtin prod policy
- florolf: tinkered on my witness impl, but not much to report
- florolf: i've setup a litewitness, works with barreley
  - waiting for PR / witness network
- ln5: dns delegation, should we get that done filippo?
  - filippo forgot, will do it asap after this talk!
  - no more delibratation needed
- ln5: poc:ing a sigsum use case, tor directory consensus documents. One dir
  auth is doing this noe once per hour. Using florolfs sigmon monitor, to put
  things into database, generate emails, etc. And also looking at an archive
  (collector) with historical documents. So this becomes 'the archive cannot
  lie' transparency. Later will also do key-usage transparency for directory
  authorities. Kinda easy to integrate in Tor because of ~2h discussing with Tor
  people last week.
  - thanks florolf for the nice monitor, it's easy to use. Everything flows.
    Didn't even need to be clever. Just go step step step done.
- filippo: landed vkey spec in c2sp!
- filippo: was planning to land PR to pull logs in litewitness, strictness and
  parsing we can look into more detail later.
- filippo: looking at things that need to happen before tds
- filippo: chatting to $someone about making spicy cli for authenticating files
  with a local posix log.
- gregoire: still working on about page, think it should be ready to be
  published somewhere soon
- nisse: tkey things. Have the 'signed if logged' prototype app, seems to work.
  Tryin to get th elog signer that verifies consistency proof to work. But got
  stuck in toolchain issues. Not sure I will be able to finnish before the
  summit, will see.
  - cc is aware of this

## Decisions

- Decision: Adopt proposal on stricter policy format
  - proposal:
    https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/120
  - draft documentation changes:
    https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/261
  - discussed last week, did some updates and clarifications. Also emailed Al,
    he seemed to be happy with the changes. Signed note a bit liberal with
    unicode, but seemed happy with the changes.
  - resolved: drop support for line end comments, only have complete line
    comments
  - resolved: to not reject sharing the same pubkey for a witness and a log
  - filippo: any reason to allow both tab and space, instead of just space?
    - nisse: just because of transition
    - (it's easy to forget one and it works with some policy file, and you only
      find out a year later when someone uses something different)
    - nisse: if we're delibrate with num spaces, it makes sense to be liberal
      with other types of spaces
  - nisse: also a few editorial changes
  - it seems like we're happy with this proposal now
- Decision: Cancel next Sigsum weekly meeting due to Transparency.dev Summit
  - https://transparency.dev/summit2025/
  - rgdd will update nextcloud calendar

## Next steps

- filippo: delegerate witness network dns name
- filippo: prepare tds talk
- filippo: land litewitness pull-logs command
- filippo: if time permits, write a glossary that might help discussion at the
  summit
  - rgdd: make sunlight witness pull logs?
  - yes filippo will try to take a stab at this
- rgdd: setup witness network matrix/irc room, poke for bridging w/ tdev slack
- rgdd: give ssh key to elias, test witness network site deploy via GH actions
- rgdd: get witness network site + participate list deployed, includes ensuring
  we get the DNS records or delegation fixed by filippo
- rgdd: enroll rgdd.se/poc-witness in witness network (testing)
- rgdd: ensure barreleye gets enrolled in witness network (testing)
- rgdd: help wrap up witness getting started that ln5 started on
  - TODO: branch link
- rgdd: write bastion host blog post?
- rgdd: prepare silentct lightning talk
- rgdd: rubberduck for blog posts on a need basis
- elias: help out with witness-network.org website hosting
  - need dns domain delegerated first
- elias: start using litewitness pull-logs command for test witness
- question: should we make a release with sigsum test policy?
  - rgdd: yes that would be great
  - update news file, signed tag, send email
  - elias will do this
- florolf: maybe also turning on the pull-logs command once that's available
- gregoire: still making the about page, it's pretty busy though so will see
- ln5: wrap up tor consensus transparency prototype
- nisse: might need to prioritize between log signer and blog post
  - can discuss this with rgdd after the meet

## Other

- elias: recommendations for witness about pages for new witnesses?
  - what domain and URL to use?
    - should it be a domain that belongs to the witness operator?
  - hosting?
  - should there be some official recopmmendations about that?
  - context: this question came up when discussing with tillitis
  - should we have more guidelines or strict rules wrt. this? (or at least what
    is our opinion when we consider using witnesses in a policy)
  - nisse: main thing is it needs to be somewhere 'authoritative', e.g., website
    of the organization.
  - rgdd: we could give a few examples
  - filippo: it's repitation staking, needs to be official in some way from the
    organization and not a random different domain claimed to be operated by foo
  - so we can give this pointer + 3 good examples + one bad examples, and that's
    about what we can do wrt. pointers
- gregoire: Do test witness need an about page (to be included in the default
  test policy)? If so, what kind of availability commitment is required?
  - elias: what we have said about that so far is that for a test witness it is
    not required to have an about page. For a new test witness to be added to a
    built-in test policy, it is enough that the witness operator expresses an
    intention to keep it running for an extended period of time, at least for
    several months. But no formal commitment is needed about that for a test
    witness, no hard promise. It's just that if you don't even intend to keep it
    running then it's probably not useful for us to have it in a built-in test
    policy. Simply because we want the built-in test policy to be useful for
    test submissions.
  - tl,dr: seems answer is no.
  - gregoire might still make a small page
  - main reason for doing this is: help people understand *don't use this for
    anything serious -- it's a testing thing*.
- gregoire: Is it Ok to reset a test-witness database now and then?
  - elias: I think that yes, that should be ok for a test witness.
- elias: should we add another built-in test policy witm more witnesses?
  - existing built-in test policy name is "sigsum-test1-2025":
    - https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/pkg/policy/builtin/sigsum-test1-2025.builtin-policy
  - suggested new policy name: "sigsum-test2-2025"
  - could include these witnesses in additino to the other three:
    - filippo's navigli.sunlight.geomys.org/dev witness
    - florolf's remora.n621.de witness
    - gregoire's witness.stagemole.eu witness
    - tillitis.se/test-witness-1
    - then we get 7 in total, could use 5-of-7 for quorum in the new test policy
  - Note: not changing existing policy "sigsum-test1-2025", just add another one
    - because built-in policies should not change
  - tl;dr: yes it's ok to nuke the database for a test witness
- elias: another builtin test policy, sigsum-test-1-2025 we have now. Let's
  create sigsum-test-2-2025 with more witnesses? E.g., filippo's witness,
  florolf's witness, gregoire's witness, and tillitis test witness. Should we do
  this? Not a huge deal, it's just testing. But it's a way to practise adding
  another builtin policy. And now we're adding another one, i.e., not changing
  the policy of a previous name. So ppl can continue using the old name and it
  still has the same meaning.
  - rgdd: makes sense, but always ask the test witness operator first
  - nisse: when? today or in a couple of weeks?
  - elias could do it now
  - it's nice if there are more than one, because then understand it's choise
  - florolf, filippo, and gregoire are all happy to be in the test policy.
  - elias will ask tillitis
  - then we can maybe make -3 before TDS after having enrolled barreleye in
    witness network
