# Sigsum weekly

- Date: 2023-11-07 1215 UTC
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
- ln5
- filippo

## Status round

- rgdd: prepared roadmap proposal, see below
- rgdd: most everything else has been backloged on my side (wasn't able to make
  any more progress on wrapping up yubihsm or tagging+sending spec release
  email)
- nisse: Prepared for spec release, about to tag sigsum-documentation with tag
  `log.md-release-v1.0.0`
- ln5: updated ghost-shrimp instance to the latest release together with nisse

## Decisions

- Decision: Adopt updated roadmap
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2023-11-07-roadmap.md
  - To be renewed on 2023-01-30, a bit further away this time to account for
    holidays and the fact that all of us are only working part-time.
- Decision: Cancel weekly meet on 2023-12-26 due to holidays
- Decision: Cancel weekly meet on 2024-01-02 due to holidays

## Next steps

- rgdd: (still) wrap up yubihsm stuff, xxx: c2sp; and onboard nisse for
  ssh-agent yubihsm thing to see if that's a good solution forward; and figure
  out when go to stockholm for yubihsm provisioning
- filippo: specs of signed note, cosignatures, witness, bastion
- nisse: rember what happened before vaccay, probably design doc things before
  cats

## Other

- rgdd's yubishm stuff, currently in:
  - https://git.glasklar.is/rgdd/yubihsm
  - does it make sense to put it in project/yubihsm?
  - (after fixing the readme and slight refactoring so that the debug outputs
    and stuff are not in your face)
  - main things i expect here: doc on how to provision + the script(s)
    surrounding that. If we decide to wrap an ssh-agent for yubihsm, that would
    go here too then.
  - nisse: no other code in project/ currently, maybe under core/ next to the
    other code? Or possibly we could repurpose dependencies? Maybe some folder
    is missing, or maybe core/ and non-core things is hard. We can discuss and
    sort out together.
- filippo: a design for a lightweight ct log
  - https://filippo.io/a-different-CT-log
  - another, distributed, design: https://git.sunet.se/catlfish-web.git/tree/,
    https://git.sunet.se/catlfish.git/, https://git.sunet.se/plop.git/,
    https://git.sunet.se/catlfish-dockerfiles.git/
  - https://github.com/rsc/tlogdb
- filippo: https://eidas-open-letter.org/
