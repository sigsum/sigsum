# Sigsum weekly

- Date: 2024-06-18 1215 UTC
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
- gregoire
- filippo

## Status round

- filippo: couple of smaller things. But main thing - wrote this up:
  - https://pad.sigsum.org/p/filippo-friction-log
  - document long because some ideas on how to make some improvements
  - but tl dr very happy with this exerceise, went great
  - https://github.com/FiloSottile/age/releases/tag/v1.2.0
- filippo: user support for litebastion :). Small progress on sunlight as well.
- rgdd: created an ansible role that deploys litebastion as a systemd service,
  and deployed it on bastion.glasklar.is. So, ln5 and I can now configure your
  witness backends if you provide us with your key hashes. Opened two issues in
  the process:
  - https://github.com/FiloSottile/litetlog/issues/9
  - https://github.com/FiloSottile/litetlog/issues/10
- rgdd: also updated my witness to run as a systemd service just now, have yet
  to try some corner cases to see it automatically recovers after e.g. a bastion
  restart. When time and inspiration strikes I will most likely write a
  litewitness ansible role too.
  - (Side conversation: we all a bit interested in automation of a transparent
    configuration for logs/witnesses/bastions etc. To be discussed and thought
    of more.)

## Decisions

- None

## Next steps

- rgdd: find a public home for the ansible role
- rgdd: give filippo information on how to get witness key hashes configured at
  bastion.glasklar.is, he will relay it
- rgdd, nisse: read filippo's doc. Then we can talk more about it in the other
  section until next week.
- filippo: let trustfabric folks know about the bastion now being available
- filippo: checkin the above pad, and add docs in age on how to do verification
