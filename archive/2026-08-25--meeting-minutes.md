# Sigsum weekly

  - Date: 2026-08-25 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: nisse
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - elias
  - rgdd
  - tta
  - warpfork
  - mw
  - filippo
  - nisse
  - quite
  - patrick
  - justin

## Status round

  - nisse: Considering delete of the Metrics abstraction in pkg/server. See https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/314. Replaced with a simpler HandlerDecorator config, that should fit well with, e.g., promhttp, and which isn't limited to any specific per-request metrics.
  - nisse: Followup work from https://git.glasklar.is/sigsum/project/documentation/-/blob/main/proposals/2026-05-29-no-duplicate-cosignature-keys.md
    - Merged https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/146
    - Next, proofs: https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/316
    - Intend to also make a corresponding C2SP PR on tlog-checkpoint
  - rgdd: prepared roadmap update, queued up for decision. Let's see if we're ready to decide on it today, or if we want to push it for another week?
  - rgdd: prepared a talk proposal for tds (got input from nisse+hayden, thanks!)
    - https://pad.sigsum.org/p/f225-6ea0-fd76-50f1-ead9-7110-2b9d-9a40
  - rgdd: reminder that the TDS CFP closes today ~ last chance to get your proposals in!
    - https://transparency.dev/summit2026/
    - https://docs.google.com/forms/d/e/1FAIpQLSds5HdEVXDssOKYETEEMoTbveqJe8i2QyPpKPtXFpXCd5-cXw/viewform
    - get your submissions in!
  - justin:
    - very early stage, but:
        - if I were able to get some fundting from the national science foundation in USA, is that something that people here would be interested in?
        - given the fact that the US is resistant to sending money outside the us, so how would that work?
        - this could be problematic, but raising the question anyway
        - nisse: at Glasklar we are probably not interested, but maybe others
        - filippo: for Geomys, not sure
        - justin: it would not be a strict contract, more like "go do some good science"
        - rgdd: is the goal still in the end to produce science?
          - or can it be money going to engineering, that may not be science?
          - justin: it could be about building world-class transparency systems, not necessarily only science
          - rgdd: timeline-wise, when would this be?
            - justin: need to get ideas together
            - justin: start time would be around next September or so, like 12 months or 15 months from now
            - justin: I got money before related to Python, from the national science foundation
  - tta: (won't be there today, I'm inside a moving train again)
  - tta: about Archive Transparency
     - I (may) have resolved my current internal monologue on what I need to do for the next 2-3 months
         - some sigsum python code is still on topic, but cannot commit on this again :/
     - I'm planning for a scope reduction for ATrans v1, by changing several things:
         - v1 observers would be stateless + v1 mirrors would be non-tracking + no "identity creation" step
         - long-form notes about this below (15min read approx)
            https://codeberg.org/openrip/project/src/branch/main/notes/2026-08-25-014-scope-reduction.md
    - I think I need to talk to someone in a "high bandwidth" conversation about project management
      and the issues I am currently having with ATrans, to avoid further side-quests and scope reductions :)
  - warpfork: addenda draft needs another round, thank you for input so far
    - v0.1draft is still: https://hackmd.io/JPrF0yOHRZOzu5MowXKLWQ
      - this now has numerous todos, but if that's readable, then :)
    - big question is how to structure the entries, how little can we structure the entries and still get some value
      - we don't want to overspecify and overstructure; that will not ease adoption.
      - but we DO want to know how a tool like e.g. woodpecker can recognize this in a log and its leaves, without needing too much custom instance code.
    - biggest choices: should we have a partial specification
    - filippo: what this needs is a way to tell generic implementation of logs where the hashes are in the leaf
      - for sigsum you need to tell them where the hash of the key is
      - for identity-based logs you need to tell them other things
      - could say: this is a spec for prefix or suffix of a leaf, which says where in the leaf are the hashes
        - like: how many hashes are there? indexes into the leaf?
      - filippo: would like this to be usable across different leaf types
      - warpfork: a difficulty is: how do we tell if a leaf is using that specification at all?
        - filippo: maybe simply: there is a file, and if that file exists then you use this
        - filippo: there is already a directory, there could be a file in there with a certain name/contents
      - filippo: if leaf format is to change, probably better to create a new log than to change leaf format for existing logs
      - warpfork: an example is woodpecker
      - filippo: some leaf formats already have a version field
        - does sigsum have a version field in the leaf? --> no
        - rgdd: sigstore has leaf format version field
      - filippo: it would be great if mirroring could be generic
      - filippo: next step is probably for rgdd and others to look at the draft
      - nisse: I have not read it yet, but started to think about related things
  - quite: hello! I will be working on stuff here
    - started looking at ML-DSA-44 support in sigsum-agent
  - patrick: submitted proposal to Transparency Dev Summit
    - will get myself up to date with what's been going on here
  - elias: still working on operational things related to the glasklar witness deployment.
  - mw: last week we deployed litewitness with rgdd's patch (that is currently in teview in the torchwood repo) for MLDSA support in litewitness
    - mw: can we get a release of torchwood soon?
      - that would be helpful because then we can more likely get help from Debian maintainers
      - filippo: sorry about the delay with the torchwood release
      - filippo: now Go 1.27 just came out
      - rgdd: Simon (debian maintainer) essentially said don't bother about the go version
      - filippo: Go 1.27 has MLDSA in the standard library
        - mw: it sounds like it would be one less dependency to worry about
        - filippo: if they can already package go 1,27 packages (go 1.27 came out about 10 days ago)
  - filippo: have applied some pressure on the standards process to get MLDSA codepoints assigned
    - filippo: there is a debate over which draft to use, and they are identical apart from the names
      - names like ssh-mldsa-44 or mldsa-44
    - filippo: the problem with composites is that then you have to decide how to structure them
      - if you don't use a composite then it's just a thing, so you just use the thing
    - filippo: on the mailing list there's like 5 different vendors trying to get codepoints
    - rgdd: would it help to send an email about the thing we are using currently?
      - filippo: you can send something like "yes, we are looking forward to this", that could be helpful
    - filippo: there are questions about "is that a widely deployed thing?"
    - nisse: they are supposed to document existing things
    - filippo: but I just want a IANA codepoint!
    - rgdd: we are about to do our own thing where we control both ends, we could do that first and then send an email saying that we are looking forward to something we can use

## Decisions

  - Decision: Adopt roadmap until ~mid Nov
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/149/diffs
    - nisse: in case someone here knows: can you have a PGP public key without having some kind of self-signature by that key?
      - filippo: not 100% sure, but I don't think so
    - filippo: I'm interested in helping out with getting different leaf types to work together, but it's fine if that happens without me as well

## Next steps

  - rgdd: submit my TDS talk proposal (see above)
  - rgdd: this is a short week for me so won't get too much done; main thing on the TODO list will be TDS program things as the CFP closes today.
  - nisse: Look at addenda draft
  - mw: send question to simon about packaging

## Other

  - more about justin's question about the national science foundation?
    - rgdd: q for justin: have you spoken to Elena about this?
      - justin: not about this, it's hard to get it for anyone outside the US
      - justin: about 10 years ago, it was possible to get funding for someone who lived outside the US
        - things have changed regading that
    - rgdd: I will look around and hear if there is someone else who might be interested
  - filippo: c2sp is getting a forum
    - not announced yet, but disc.c2sp.org ("disc" like discuss)
      - hosted forum platform that has both markdown and email
      - you can interact with it entirely via email if you want
      - any maintainer of a c2sp spec can request a forum category for discussion of their things
        - that maintainer would then be moderator for that part of the forum
        - filippo: starting to see LLMs posting to IETF mailing lists
        - filippo: I plan to ban users who do not follow the rules
        - rgdd: I would like to discuss this also regarding witness-network.org
