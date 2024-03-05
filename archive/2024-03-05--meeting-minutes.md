# Sigsum weekly

- Date: 2024-03-05 1215 UTC
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
- filippo
- ln5
- nisse
- gregoire

## Status round

- filippo: finished sunlight ct log thing, spec should be out hopefully today.
  Was a long detour, this week picking up c2sp. Talked to rasmus about possibly
  using sunlight as a way to get witness operators. Sunlight deployed on fly at
  the moment. Sunlight already has similar database ops that witnesses needs, so
  fits kinda well. "Upload this, if it hasn't changed". Idea then is basically
  if an org runs a ct log and commits to that for many years, we could possibly
  make them run witnesses by making it easily configured via sunlight.
  - https://github.com/FiloSottile/sunlight
  - https://filippo.io/a-different-CT-log
- filippo: rwc coming up at the end of the month, talked about how to structure
  the talk. Idea is to convey our designs and how we think about tlogs to a
  broader audience. Instead of copying CT, "do this" kinda. So: no scts, offline
  verifiable proofs, witnessing. Won't be focused on witnessing, will be
  mentioned, but will be more about you want tlogs -- but you don't want to work
  on tlogs. Cause audience is more likely to wanna stick a tlog somewhere,
  rather than contributing to tlog design. So the talk is about presenting our
  design. Sigsum one example. Go checksum DB as one example. And intent to build
  a small prototype on how one could write a batch serverless log for debian.
  Not meant for "deploy", just an example.
  - plan to prepare for that: this week, c2sp. Cuz of rasmus' availability.
  - next week: work on the debian prototype
  - next week after that: slides
  - if there's anything you'd like to see the talk, please let me know
  - (when i have slides i will share, but might be on short notice)
  - nisse: might be useful if you make an outline even if you don't have slides.
    - filippo: already have, will post it

## Decisions

- None

## Next steps

- linus: the same sigsum-agent things that have not been prioritized yet
- filippo: see above

## Other

- nisse: Rename agent tool?
  https://git.glasklar.is/sigsum/core/key-mgmt/-/issues/15
  - nisse sees no reason to rename the repo if we keep the current scope which
    is docs on how to do key mgmt. But the actual agent could be named to
    sigsum-agent instead of yubihsm-agent. Possible drawback: if we think we
    will use it extensively for other things, e.g., ST.
  - linus: brought it up because i wanted to rename the binary, sits wridlt when
    wanting tor deploy. Then jas show up, but didn't even click on it because of
    the weird repo name. Which made linus think the naming of the repo matters
    -- because jas totally missed it because of the name. No other input given,
    linus would rename the entire repo sigsum-agent. But won't push if anyone is
    strongly opposed.
  - nisse: think the scripts and docs a bit weird that we have now in a
    specically named "sigsum-agent".
  - linus: we could possibly move that to a different place then? E.g..,
    glasklar's operational stuff?
  - nisse: then would not be too unreasonable, but operationally things would be
    good to have them in the base and as recommendation for others and not only
    our use.
  - rgdd: would be fine to just rename the repo (and the binary) to sigsum-agent
    and keep all the content, while adding a README outlining the context
  - nisse: happy to rename the binary, not so sure about the repo name.
  - Let's rename the binary and leave the rest as is then.
  - Linus will ask jas if he can tag along when he's packaging, for the learning
    experience
