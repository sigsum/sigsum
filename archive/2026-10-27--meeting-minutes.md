# Sigsum weekly

- Date: 2026-10-27 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: rgdd
- Secretary: gregoire

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- rgdd
- tta
- florolf
- nisse
- mw
- filippo
- tta
- gregoire

## Status round

- nisse:
  Updated https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/154,
  from Rasmus' suggestion to adopt checkpoint and tlog-proof right away.
  - minimal changes to the log API
  - next step: decision queued for next week
- nisse: hacking on log server prototype that pushes storage to the secondaries.
  Not much to share at this point
- tta: still making LLM-fueled go->python
  https://codeberg.org/openrip/tlog_merkle (from transparency-dev/merkle)
  https://dev.archive.rip/ggs/only-vibes/tlog_c2sp (from torchwood+sumdb) and
  later, will use this to improve my LLM-fueled sigsum
  - unclear how could be used these (apart from my needs of prototyping)
  - questions of trust, correctness & ethics of LLM-averse people!
- tta: (context: ATrans hasn't been selected for funding extension)
  - in the scope of looking at alternatives ideas for funding:
    https://nlnet.nl/codesupply/ "please build FOSS for code supply"
  - why not sponsor pure handwritten python stuff for sigsum+tlogs? :o)
  - (may also look for a new job and convert tlogs to part-time hobby)
  - rgdd: no-AI policy is a bit weird
  - tta: they had a more relaxed policy before but got abused
  - rgdd: on the topic of python: would like a python module for ansible. right
    now, needs to wrap binaries. Would be nice with python module instead.
- tta: need to ship sexy demo of ATrans in november, mock-up website below:
  http://archive.rip/static/tmp/mock-up/archive.rip/
- florolf: read through proposal (didn't catch which?), no comments
- filippo: sunlight release, and MTC implementation including our MTC CA operate
  to tlog in lockstep so they are committed atomically.
- filippo: Working on bringing up the production geomys witness. Want to bring
  it up on the USB armories.
  - armory exposes tlog-witness with no auth and only talks to the host. Like a
    HSM that only signs valid request.
  - armory will keep state and do consistency proof
  - will not do signature verification from the log
  - rgdd: how many sunlights will you operate
  - filippo: multiple sunlights. probably three: prod/witness network, staging,
    one dedicated for SLAs customers
  - staging has test MTC mirror
  - rgdd: people using the SLA one will also use prod?
  - filippo: only the SLA one
  - rgdd: usb armory witness publically available?
  - filippo: yes, but may not be ready for other to run. still needs a bit of
    updating to work with multiple witness keys for now it has a single key.
    https://github.com/cpu/vitrum
  - florolf: how do you store the state? rollback protection?
  - filippo: uses the counter thing (?), and signs in authenticated storage to
    store encrypted blob in the emmc.
  - florolf: do you do batching?
  - filippo: yes. the design is to batch otherwise the counter will run out
- martin: working on deploying the soft keys we're going to use for ML-DSA,
  packaginf for debian and fedora, deployment scripts to deploy the key by
  creating it on the server and pipe to ansible vault so it's never stored
  outside the vault. key encrypted with a passphrase that is only on the witness
  just in case (...?)
- also been working on list.transparency.dev
- rgdd: catching up with the last two weeks

## Decisions

- None

## Next steps

- martin: need to get the list thing up
- tta: one of next step would be submittin a proposal to nlnet
- filippo: sleep and figure out
- nisse: would like to get log-go released; next step is to update test log to
  release candidate
  - rgdd: test log runs auto-deploys main so should already be running
  - rgdd: long list of things to look at; witness-network backlog;
    communicationg with Al; etc.

## Other

- nisse: question to filippo: relation with tlog-mirror and work in sigsum. If
  you have a log with a tlog-mirror would just retire the log and use the mirror
  as archive or try to resurect the log from the mirror's data
  - filippo: dependso no how you use tlog mirror. tlog-mirror just a protocol to
    get copy of the log and get a signature. Used asynchrosously: make a
    checkpoint, publish it, mirror somewhere else then mirror useful as
    archive backup; if instead you don't make the signature until the
    tlog-mirror has finished, synchrosously, then it does help resurect the same
    log. It's an implementation choice.
  - nisse: in later case, you want a separate key for the mirror per namespace
  - filippo: would want separate authentication; easiest way separate key; could
    also setup wg so it only allows the log; we are going to use tlog-mirror
    this way for our log; plan to tlog-mirror from Ams to Lon inside our infra
    as step one. If fails, we'll continue growing the log but not published
    signed checkpoint. Continue growing because don't know if it really fails.
    If mirroring fails that pool is considered fails. If it works and comes back
    then we sign and make public.
  - nisse: internal mirror cosignature line on the checksum as well?
  - filippo: design will probably not carry the signature from the internal
    mirror to the outside world because MTC has no concept of them. They are
    internal details of our storage. not implemented yet. may not even get a
    signature from internal mirror, just rely on mirror saying it got it. Then
    we tlog-mirror to a public mirror. Steps: tlog-mirror internal; tlog-witness
    hsm; tlog-mirror externally.
  - rgdd: similar to what we're doing
- nisse: if we have only the hash of the signature in the leaf, would like to
  include the signature through tlog-mirror
  - filippo: that's the point of tlog-addenda: extend tlog-mirror in generic way
    to support tlog-addenda
  - nisse: can also extend the tlog-mirror protocol to include extra data
  - filippo: yes, if you do custom software you're not limited to the spec
