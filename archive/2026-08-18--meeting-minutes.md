# Sigsum weekly

  - Date: 2026-08-18 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: elias
  - Secretary: mw

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - elias
  - nisse
  - warpfork
  - justin
  - mwh
  - patrick
  - filippo

## Status round

  - nisse: Back from vacation. Pending MR,
    https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/146
  - warpfork: have a first draft of "addenda" spec.
    - https://hackmd.io/@warpfork/HysAh6ZvGg
    - contains some boring-but-need-agreement parts: sharding, etc.
    - spicier: in situations where you want to be able to redact something
      from a log, and there are at the same time monitors that want to verify
      things, you may need a partition key of some kind
      - the structure of sigsum kind of gets that for free, others like
        tessera may need something
  - justin: was traveling / sick so was not as focused on this as I would
    have liked.  Now located in Iceland for the Fall.  In a shared office
    space so cannot use voice.  Nothing to report.
  - patrick: need to read + discuss material with tta on AT, submitting
    t.dev proposal within a day/two
    - rgdd: yay \o/
  - rgdd: PR with ml-dsa-44 log signatures in litewitness
    - https://github.com/FiloSottile/torchwood/pull/85
    - there are some ideas on integrating this in the ssh-agent.
  - rgdd: drafty exported metrics for glasklar's witness-g1 group
    - https://metrics.g1.witness.glasklar.is/
  - filippo: most of my tlog work lately has been operational, getting
    witnesses up etc.
    - c2sp.org looks more grown-up now!
      - https://c2sp.org/
      - not bound by github's rate-limits, deployed on separate server on
        a push-action.
      - Agents sending markdown in their accept headers will get markdown back.
  - filippo: there's a fixed vulnerability in a dependency of the torchwood
    client, which is used when verifying tiles. The dependency will be bumped.
    - https://go-review.googlesource.com/c/mod/+/814960

## Decisions

  - none today

## Next steps

  - rgdd: get input from you all wrt. updating of roadmap
  - rgdd: plotting of metrics.g1.witness.glasklar.is/
  - filippo: releasing torchwood and look at/include rgdd's ml-dsa PR,
    aiming for doing that today.
  - filippo: think about possible TDS talk
  - warpfork: same ^^

## Other

  - ml-dsa-44 support in litewitness via ssh-agent, short discuss/reminder?
    - filippo: as long as you control both ends, you can use your own
      idenfitiers/keys, if all you're doing is signing: it doesn't have to
      be a known algorithm, it's just pk encodeing and signature encoding.
    - we can come up with our own identifiers like how openssh does it
      with an @-suffix.
      - nisse: I think we should go with our own domain for that.
      - nisse: how do we want to represent the pub-keys in the protocol?
        - Q: for listing the keys?
          - yes, and also for selecting which key to use.
          - If performance becomes a practical issue we may need to think
            about that.
  - general discussion about https://hackmd.io/@warpfork/HysAh6ZvGg (pasted
    above in status-round).
    - key/value (identitiy based) spec: https://github.com/C2SP/C2SP/pull/244
    - warpfork: what matters to this spec: do these thing need to be
      redactable separate to eachother?
      - filippo: anythihg that needs to be redactable: you put behind the hash.
        - to be continued ...

