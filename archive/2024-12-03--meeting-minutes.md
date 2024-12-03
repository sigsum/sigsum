# Sigsum weekly

  - Date: 2024-12-03 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: elias
  - Secretary: ln5

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - nisse
  - elias
  - ln5

## Status round

  - rgdd: experienced some issues with litewitness (hooked up to litebastion), see
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2024-11-28-rgdd-witness-debug-notes
    - https://git.glasklar.is/sigsum/core/log-go/-/issues/101
  - nisse: submitted abstract to fosdem
  - elias: will hopefully join to fosdem

## Decisions

  - No decisions.

## Next steps

  - ln5: setting up gitlab runners for Sigsum
    - any special needs? testing various linux dists and versions is already easily done by chosing `image:`
    - would >1 endianess be valuable? maybe
  - nisse: IETF draft on SSH agent protocol has been accepted by wg sshm
    - https://datatracker.ietf.org/doc/draft-ietf-sshm-ssh-agent/
  - elias: working on easy sigsum issues

## Other

  - next meeting on tuesday, as always (despite some of us meeting in person that day)
  - ln5: we need seasalp monitoring and alerting in time for the xmas holidays
    - seasalp status page, public
      - is submit is working, yes/no? up to 6h latency is acceptable
      - list of expected witnesses and which of these did sign the latest tree head
    - alerting
      - email only is fine for now
    - AP sysadmin team: write a proposal
  - elias: signatures on git commmits? why, how, who are allowed signers?
    - step 1 would be to start signing release tags, which we are not doing yet
    - ln5 has set up https://git.glasklar.is/glasklar/git-signing-keys as an experiment
    - merge commits done by gitlab will not be signed
