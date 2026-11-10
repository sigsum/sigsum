# Sigsum weekly

  - Date: 2026-11-10 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: quite
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - tta
  - florolf
  - warpfork
  - elias
  - nisse
  - rgdd
  - quite
  - filippo

## Status round

  - nisse: sigsum v1.1-related milestone: https://git.glasklar.is/groups/sigsum/core/-/milestones/1#tab-issues
    - mldsa cosignatures and related things
  - nisse: Prototype code: https://git.glasklar.is/nisse/prototype-sigsum-v2
  - nisse: added a decision in the agenda, see below
  - tta: end of funding & demo of archive transparency in 2.5 weeks
    - archive transparency (AT)
    - split between fixing bad code / cleaning up vibe-coded slop
    - still want a better website to show to people
    - in that aspect wrote a new (and final) summary of the idea of ATrans:
        https://archive.rip/static/tmp/mock-up/archive.rip/trust-model.html
        (20 min read, will end up on the final archive.rip website)
    - want to submit to FOSDEM
    - about code, need to clean up a lot
  - rgdd: prepared a proposal on (simple?) core contributors...
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/155
    - not intending to put for decision today, but maybe next week?
    - could for example help when someone is applying for funding
    - please take a look until next week
  - rgdd: been doing plumbing to get mTLS working in glasklar's witness-g1 infra
    - https://git.glasklar.is/sigsum/admin/ansible/-/commit/4ee1fd01290a89680d013fd393efe21e005a1f85
    - https://git.glasklar.is/glasklar/infra/site-ansible/-/commit/9fe6da3ed27946905ed7b77e817e4bdbad7a6070
  - rgdd: wip extending litewitness with a label that helps me get metrics sorted as i want (related to mTLS)
    - rgdd: I have a very small addition to litewitness
      - rgdd: planning to make a PR for filippo

  - florolf: tlog-policy implementation for Sigsum v1.1 in sigmon
   - thought about the file type marker some more
   - how to detect sigsum v2?
  - florolf: playing with no_std sigsum-rs
  - elias: work on witness deploy; hardening; mTLS
  - filippo: no emergencies for like 4 days straight!
    - moved forward with magnolia implementation and with sunlight
    - magnolia is the MTC CA (both the software and the CA have that name)
    - tried to setup USB Armory formware
      - figured out a few things we want to change before production
      - thinking about physical locations for high availability services
      - getting operational things ducks in a row
      - site in Amsterdam, Nikhef?
      - second witness for the broader public
      - main operations are in London
      - rgdd: we (Glasklar) are running witness 3 instances for our "witness-g1" group
        - one of the 3 is in Amsterdam
  - quite: have been wrapping up work on MLDSA deployment
  - quite: will probably be helping nisse with Sigsum v1.1 things

## Decisions

  - Decision: Design sigsum-v2 to not require any deduplication by the log server
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/153
    - has been discussed for a few weeks
    - deduplication is kind of costly
      - the proposal says that we should not do that in Sigsum v2
    - discussed if duplication could be used to spam monitors
      - it could help a monitor if the log can avoid duplicates
        - some kind of best-effort deduplication could make sense
      - rgdd: best-effort cacha has worked well for sunlight?
        - filippo: kind of, but it was the trickiest part regarding sunlight
          - had to learn things about sqlite because of that cache
        - rgdd: even if we did not have a cache at all, the decision would be the right thing to do
    - rgdd: the proposal sounds good
    - others nodding heads
    - filippo: sounds good to me

## Next steps

  - rgdd: fixes in sigsum's ansible that blocks me from upgrading litewitness version
    - not a litewitness problem, just something to fix in sigsum's ansible
  - rgdd: file MR with "-source-header" option and "source" prometheus label (litewitness)
  - rgdd: plotting and documentation of available witness-g1 metrics
  - rgdd: will try to setup a recurring meeting with Hayden
    - to make sure that we continue with what we said at TDS
  - filippo: looking at litewitness PR, good next step
  - filippo: main thing I want is to get us to a production loglist for the witness-network.org
    - need our (Geomys) production witness for that
  - elias: more witness deployment things for GLasklar witness group
  - nisse: working on my Sigsum-v2 prototype and sigsum library
    - Sigsum-v2 prototype has a primary node and a secondary that supports read-path
      - part of that is a tiles client
      - as a test, ran against android log with a million entries
        - gets checkpoint, gets partial tiles, sequentially reads all entry tiles and creates tiles and fetches those and compares
  - quite: will begin paging in more Sigsum things
    - wrapping up witness deployment things
    - sync with nisse about how to best help with Sigsum v1.1 and Sigsum v2
      - nisse: start with looking at the issues in the milestone
    - rgdd: adding checkpoint endpoint in log-go would be helpful for our uptime monitoring

## Other

  - florolf: Sigsum profile for identity based leaves? Wasn't there a draft somewhere?
    - very abstract, is there some explanation of how to map the Sigsum semantics to that?
      - nisse: I wrote up something
        - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/150/diffs
        - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/sigsum-v2.md
    - rgdd: you can look at the TDS talk, or in MR (see link above)

  - suggestion for AT (archive transparency): prioritize specs, usage examples, and docs that have snippets of e2e usages... instead of code.  Easier to review; more legible to others; more likely to be useful to resume from later.-- tta: yes! thank you for input, it's definitely the direction I'm moving towards (was too distracted on making "new stuff" before)
    - might also offer https://github.com/warpfork/go-testmark as a structural help.  (easily ported to other langs... tl;dr: literal docs, it shoves data into codeblocks.  helps me!) -- tta: will look into it (esp. because I want to move away from "showing writing" to "showing code and working stuff" wipwip)
- core contrib?
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/155
  - past contributors would be nice to include
  - +1
  - do you want links to the recordings of the meeting minutes? a way for external eyes to see who shows up
  - rgdd: the idea is to keep it as simple as possible
  - rgdd: if we make it too formal there is a risk of a slippery-slope where it becomes too much and then we don't even do a simple list, which is what happened so far
  - rgdd: other projects are Debian and Tor project, will ask for feedback from folks involved in those projects
