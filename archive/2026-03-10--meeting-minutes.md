# Sigsum weekly

- Date: 2026-03-10 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: rgdd
- Secretary: gregoire

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- rgdd
- nisse
- gregoire

## Status round

- rgdd: merged updated history.md with a diff from end of 2024 until ~now
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/history.md
- rgdd: looked through tta's AT and tried to understand more past 1-2 weeks
  - most of our exchanges are in pads, see below if you're interested
  - 1st: https://pad.sigsum.org/p/00ff-06b9-5327-3c43-518e-3e7d-68df-4a8e
  - 2nd: https://pad.sigsum.org/p/00ff-06b9-5327-3c43-518e-3e7d-68df-4a8e-tta
  - 3rd: https://pad.sigsum.org/p/67fc-50da-a03f-a1e0-4483-eb9b-bb22-c5ce
  - sounds like tta will work on an updated SUMMARY.md and ping us again
  - nisse: this ensure that an archived has not changed after it was archived
  - rgdd: does item with hash h exists at time t, hard to tamper statement
  - rgdd: there's already existing format for doing archiving, can stack
    inclusion-proof etc. on top
  - rgdd: more things can be added but could be left for 'v2'
  - rgdd will ask if ok to persist the pads
- rgdd: few words about 'updated' yubihsm provisioning scripts/steps
  - https://git.glasklar.is/sigsum/core/key-mgmt/-/merge_requests/35
  - rgdd: to provision more witnesses at GK
- nisse: tkey-sign-if-logged now appears to reprobuild.
  - considering how to support this longer time (after needed version of clang
    is dropped from debian). Main alternatives:
    1. Pin a golden container image (that's what Tillitis are currently doing
       for the plain signer device app)
    1. Pin a clang source package,
       https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.7/llvm-project-19.1.7.src.tar.xz,
       build from source (for the riscv cross compiler as well as linker and
       other needed binary utils).
    1. Depend on debian snapshot.
  - nisse: opt 2. most robust?
- nisse: Support ssh signatures in sign-if-logged?
  https://git.glasklar.is/sigsum/apps/sign-if-logged/-/issues/1
  - could add the ssh-blob on device but better to do it on the host side?
  - rgdd: great to keep it open to more things than just ssh signatures (e.g.
    gpg, ssh, etc.)
- gregoire: filed issue in sigsum-go library (api)
  - fairly small thing
  - wanted to get signing keys, no easy function to do that
  - did i open an MR?
  - nisse: haven't seen an MR yet
  - gregoire has code, will push the MR
- gregoire: think we have deployed the bastion in production (so: per-log
  bastion in all logs)
  - glasklar witness is probably the first one to join production, blocked on
    $ansible right now
  - it's now at the top of elias list to fix the ansible release and deploy on
    glasklar

## Decisions

- None

## Next steps

- rgdd: provision 3x YubiHSM witness keys
- rgdd: attend Tor gathering & talk transparency with folks there
- nisse: sign-if-logged cont.: getting started documentation
  - MR created
- rgdd: will review above MR
- nisse: make a new tag in sign-if-logged
- gregoire: witness-network update, can i just open a PR in the repository?
  - yes, then assing rgdd as reviewer

## Other

- gregoire: curious about yubihsm provisioning: what do you provision 'on'?
  - rgdd: we have dedicated laptops with a minimal, no-network image stored in a
    tamper-evident bag.
  - rgdd: improvmenet this time we put the encrypted key in tmpfs so it never
    touches the disk.
  - new person at GK starting in April will refactor some of the provisioning
    tooling to use stable API
- nisse: is github working well for us? It's very slow
  - rgdd: not experienced that
  - gregoire: neither
  - rgdd: noticed that I get rate-limited by not being logged-in. C2SP will
    eventually gets its own website and that'll avoid some of those issues.
- gregoire: random question, do you have a way to monitor your bastion?
  - i know you have a python tool for monitoring the log
  - rgdd: we notice if the bastion is not working if the witnesses using the
    bastion are not working. But we don't have anythnig particular for the
    bastion.
  - gregoire: thinking can do this, but then have to figure out if bsation is
    the problem or if you are the problem. Or if the 3rd party witness is the
    problem.
  - rgdd: have your own witness that uses the bastion, and if the witness is
    working -> then you can conclude that the bastion is working. If witness is
    not working, then you know that it is either the witness or the bastion.
    Both of which you can debug.
  - rgdd: sth like that may be of interest to elias and linus in the coming
    months as metrics and prometheus are or their roadmap. If you have
    input/ideas please share and it may influence what they do.
