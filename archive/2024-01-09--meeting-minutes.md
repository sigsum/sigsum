# Sigsum weekly

- Date: 2024-01-09 1215 UTC
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
- filippo
- ln5

## Status round

- rgdd: prepared the below proposal with fredrik and filippo, a few other minor
  things like (finally) merging updates to history.md etc
- nisse: have some wip stuff on yubihsm from before christmas
- filippo: discuss proposal, and reach out to c2sp folks about our plans. And
  work on the draft of the witness spec, which is the main thing to finnish this
  week.
- ln5: talked yubihsm with nisse before the holidays, gist: how to start the
  agent, and what the options are to get it started with systemd etc.

## Decisions

- Decision: Adopt proposal on specifications and governance
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/71

## Next steps

- filippo: drafting the witness spec to first ocmmit to our repos, then move to
  c2sp.
- filippo: talk to c2sp maintainers now that we have a decision (to assign
  maintainers, get namespaces, etc.)
- filippo: if time permits, think more about the next steps in witness things,
  monitor things, what to build. But probably not before next week.
- rgdd: rubberduck wrt spec/c2sp things
- rgdd: start prepping next roadmap as discussed a bit out of band lately
- rgdd: setup go meta tags for the yubihsm repo (once we have a name we like)
- nisse: wrap up the yubihsm agent things so that linus can run it
- ln5: get the agent running on poc.sigsum.org, to see how it survives over time

## Other

- filippo: in other news: finnished the ct log!
  - Has a prototype that is feature complete.
  - Currently takes all the LE certs and staging certs. Which is roughly the web
    pki issuance rate.
- rgdd: in other news: a prototype here too on a silent ct monitor
  - https://gitlab.torproject.org/rgdd/silent-ct
