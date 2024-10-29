# Sigsum weekly

- Date: 2024-10-29 1215 UTC
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
- nisse
- filippo

## Status round

- rgdd: filed and added comments on some lite{bastion,witness} issues
  - https://github.com/FiloSottile/litetlog/issues/5
  - https://github.com/FiloSottile/litetlog/issues/12
  - https://github.com/FiloSottile/litetlog/issues/13
  - https://github.com/FiloSottile/litetlog/issues/15
  - https://github.com/FiloSottile/litetlog/issues/17
  - Also missing something that makes it smoother to ensure a list of logs is
    configured -- which is what I'll be working with when doing this in ansible.
    With the current witnessctl UX I can detect duplicates from exit-code 1 and
    grep for the right SQL error. Ugly but will work for now. Holding off with a
    concrete suggestion until we've made some more progress on "shared
    configuration" since that's a related UX question.
- rgdd: filed a PR with the fix I needed for poc.so/jellyfish to accept
  cosignatures
  - https://github.com/FiloSottile/litetlog/pull/16
  - rgdd.se/poc-witness is running with this fix out-of-tree for now
- rgdd: fixed checker's cosignature monitoring, details here:
  - https://git.glasklar.is/sigsum/admin/checker/-/merge_requests/7
- rgdd, ln5: did a few more ping-pongs with trustfab (al) to get seasalp.gis
  witnesses by 15 production AWs. That has now been rolled out. Seems like we
  are not always getting all 15 cosignatures when we ask for them, to be
  debugged (i believe nisse is collecting data to analyze the end-to-end
  behavior?).
- rgdd: prepared and circulated roadmap draft, hoping for decision today
- nisse: Looking into checkpoint/verifier-releated conversion tools. First MR in
  review
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/214
- nisse: did stats over the weekend, concluding 12 witnesses cosign almost all
  the time. but three are lost. possibly due to the bastion http/2 things
  getting into a bad state. Sent an email to al, but i'm not planning to the
  debugging anytime soon (because not working the rest of the week, and next
  week gone for a meetup).
  - rgdd: would be good to let al know so he's not left hanging (if he's waiting
    for us)
- filippo: busy week, didn't get tha tmuch done. Milan (filippo's litewitness)
  updated to switch the endianess, merged and tagged in litewitness. Looked at
  the issues rgdd filed. THere's a lot of manual friction around right now,
  passing around public keys and unspecified operational stuff. Which we should
  probably decide what format to use for interchange. Which we need to do the
  log of log.
  - rgdd: agree about the "ops stuff" here, i consider this in scope of the
    current roadmap under "shared conf".
- filippo: emailed fredrik about a meet, e.g., to talk about common calls etc.
- filippo: seeing issues reported on the thread with litebastion. Had a look
  into what it could be. I think i might have an idea. I had a look at that, and
  will put this in my next steps (i.e., do this sooner rahter than later --
  because its causing friction).
- filippo: thought more about cosignature test vectors, might make a witness
  test program instead

## Decisions

- Decision: Adopt the updated roadmap until ~mid january
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/88

## Next steps

- rgdd: deal with review backlog
- rgdd: drafty litewitness ansible -- it's quick and there's synergy to have
  this before next week (i'll be meeting with folks that want to operate a
  witness soon).
- rgdd: start taking a stab at shared conf + the very brief "sigsum/v2" detour
- filippo: debug bastion reconnect issues
- filippo: tweak litewitness and litebastion logging verbosity
- filippo: then start with the experiment things
- filippo: probably won't make more progress on "test vector binary" for
  witnessing
- nisse: not until next meet (holiday rest of the week, and next week away on
  meetup)
- rgdd: undraft roadmap milestones and merge

## Other

- https://security.apple.com/blog/pcc-security-research/
- filippo: still contending with litetlog scope and naming
- nisse: mk-add-checkpoint-request tool
  https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/5f3885925524cd214accc18a2de8da64f904b6f0/tests/mk-add-checkpoint-request/mk-add-checkpoint-request.go
- filippo: litewitness test requests
  https://github.com/FiloSottile/litetlog/blob/main/cmd/litewitness/testdata/litewitness.txt
- docs "migrating from gpg to sigsum", would be nice. For next renewal and
  similar docs then -- to be considered.
