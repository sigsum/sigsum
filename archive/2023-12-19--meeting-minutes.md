# Sigsum weekly

- Date: 2023-12-19 1215 UTC
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
- ln5
- filippo
- nisse

## Status round

- nisse: ssh-agent backed by yubihsm,
  https://git.glasklar.is/sigsum/core/yubihsm/-/merge_requests/2.
- nisse: Integrating the sigsum.go pkg/server package in log-go.
- rgdd: reminder that sigsum weekly is cancelled the following two weeks due to
  the holidays, next weekly is on 2023-01-09
- filippo: proposals merged, made progress on witness.md. Was hoping to have
  ready today, but let's talk more about it in the next steps.

## Decisions

- None

## Next steps

- rgdd: sync on the OSS governance / where to put spec stuff with filippo
- rgdd: wrap up before holidays, back 8th
- nisse: wrap up before holidays, would like to get the ssh-agent things done
  and then see how much progress can be made on other things. Would it be doable
  to take out one of the HSMs, go through rasmus' provision script and deploy it
  on poc? With or without backup. The opportunity: see how well it runs overt
  time on poc.
- ln5: setup yubihsm on poc, let nisse know when it is plugged in. Linus will
  talk to nisse about if any startup service is needed.
- filippo: finish witness.md. Main thing filippo is going back and forth on, was
  hoping to know the destination of the spec. Like semantic content. But it
  changes how things are referenced, is it sitting next to the checkpoint spec,
  does it not. Slightly different audience/expectation depending on where we put
  it.

## Other

- None
