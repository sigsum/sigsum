# Sigsum weekly

- Date: 2026-07-07 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: elias
- Secretary: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- rgdd
- elias
- tta
- lucia
- warpfork
- filippo

## Status round

- rgdd: queued up a 'defer roadmap renewal' decision, see below
- rgdd: mostly been helping mw/elias with witness deploy (writing ansible)
- rgdd: fyi: we got a log that joined witness network that i think is "not us"
  - https://lists.witness-network.org/mailman3/hyperkitty/list/participate@lists.witness-network.org/thread/KJIXBGHZHVUAYFOUO6XWRTROSVWBZI5S/
- rgdd: also fyi: some wip edits by al are brewing in witness network to make
  ml-dsa-44 available (for the interested)
  - https://github.com/transparency-dev/witness-network/pull/46
- elias: working on glasklar witness group deployment things
- tta: been vibe-coding tirelessly the past week, result
  is https://dev.archive.rip/ggs/only-vibes/playground
- tta: made lot of progress on "clarifying the look & feel" of tools & future
  rip mirror/observer repositories
  - experiments against sigsum logs, witnesses, etc.
- filippo: spent whole week doing tlog stuff.
  - few PRs to tlog-mirror and tlog-witness (specifications -- edge cases that
    came up during impl etc)
  - few new APIs in torchwood, e.g., to verify and sign subtrees
  - released a patch (security fix) in sunlight
  - tlog-witness read api in sunlight
  - sign-subtree in sunlight
  - tlog-mirror in sunlight
  - mldsa keys in sunlight
  - think this can go into staging ~today or so
- lucia: joined meet because we have a draft of a formal verification of
  sigsum/tlog
  - deadline mid aug
  - if you have feedback we would like to hear it (e.g. something not clear etc)
  - link: https://git.chalmers.se/elenap/what-makes-a-log-transparent/-/blob/main/paper.pdf
  - elias: is this completely ready?
  - it's been submitted, they received review, and will submit again in august
    (was mainly 'acadmic' small-fix comments)
  - but this is a pretty stable version
  - filippo: is advocates the name for witnesses?
  - lucia: we're using this term because sometimes its called witnesses,
    sometimes it's called auditors, sometimes it something else.
- rgdd: about naming: it's hard to use the word witness in a more general
  framework
  - auditors in KT?
  - sometimes used to check inclusion of the log, sometimes consistency...
    sometimes it's related to split view.
  - eric: witness for us basically means append-only
  - auditors in KT is that or more?
  - lucia: depends on which paper you're reading

## Decisions

- Decision: Defer roadmap renewal until after summer holidays (~end of aug)
  - Previous/current roadmap:
    https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2026-04-21-roadmap.md?ref_type=heads
  - Short TL;DR of where we're at
    - sigsum-c v1.0.0 (and v1.1.0) -- done
    - sign-if-logged v1.0.0 -- done
    - support >1 YubiHSM for horizontal scaling in litewitness -- mostly done
      - litewitness side: done
      - sigsum-agent side: working code, not yet merged to main
      - ansible/packaging: working code, not yet merged to main
    - Glasklar high-availability witness -- work in progress, almost at MVP
      stage
    - PQ resistant specifications:
      - tlog-witness, tlog-cosignature: merged to main, not tagged. Largely
        done, might need some minor polish and incremental additions (like the
        dropped "dos" things)
      - witness network: work in progress, text about this is being integrated
      - Next version of sigsum protocol: leaf is being drafted with hayden, work
        in progress
    - C2SP.org website -- no progress
    - Other misc projects that are being considered
      - will be reported on when we do the full roadmap renewal
    - rgdd will put together a better summary when we do a proper renewal
  - Progress will be a bit slower during the summer, and to the extend that
    people are working we will continue with undone items.

## Next steps

- tta: vacations
- elias: glasklar witness deployment
- rgdd: a bit more helping out with witness deploy at glasklar

## Other

- elias: q for filippo: tag new version for torchwood soon?
  - yes, what do you need in the release?
  - parallel signing thing mainly, i.e., it's been in main for quite a long time
    and we're using it. But we're making packages, and if we can say it is a
    particular tag it would be more clear and helpful (recent enough version of
    x/crypto).
  - filippo doesn't want to freeze patricia tree right now, filippo might back
    it out; tag; and take it back into main.
  - filippo will take a stab at this
  - elias: thanks!
