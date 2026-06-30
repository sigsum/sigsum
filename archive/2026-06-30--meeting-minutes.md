# Sigsum weekly

  - Date: 2026-06-30 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: rgdd
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - rgdd
  - elias
  - mw
  - warpfork
  - tta
  - filippo
  - patrick
  - justin

## Status round

  - rgdd: TDS'26 CFP is opened, please help share and consider submitting a talk
    - CFP link: https://docs.google.com/forms/d/e/1FAIpQLSds5HdEVXDssOKYETEEMoTbveqJe8i2QyPpKPtXFpXCd5-cXw/viewform
  - rgdd: nisse just when on vaccay, but he released sigsum-v v1.1.0 and sign-if-logged at the end of last week!
    - https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-announce@lists.sigsum.org/thread/7G3SKN73UDYFHGH2VQAVJAPFWDDO6KZY/
    - https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-announce@lists.sigsum.org/thread/4JIBPYQXICPHQZLXRI34HENNUPQ7W3PB/
  - tta: ended up making the talk discussed earlier
    - did produce slides trying to explain transparency logs
      - p10-38
      - https://codeberg.org/openrip/talk-n-slides/src/branch/main/spml26/archive_transparency_in_20min_non_technical.pdf
    - also wrote blogpost explaining how and why
    https://codeberg.org/openrip/project/src/branch/main/notes/2026-06-13-003-about-transparency.md
    - will resume work on archive transparency
    - had a call with justin and patrick last week
  - filippo: there is now a PR to torchwood for subtrees and MLDSA cosignatures
    - working on sunlight implementation
    - landed signed submit (?)
      - currently have to use software keys for performance
    - tlog-witness read API
      - would like to land that this week
    - library in torchwood
      - rgdd: right now ssh agent is used for doing signatures, will that work?
        - filippo: that may take some work
      - message signer interface, maybe make ssh agent implement that
  - filippo: racked a new server for geomys in Italy, as an EU node
    - can run sunlight there
  - filippo: some progress on MTC (merkle tree certs)
  - filippo: torchwood now has a sparse merkle tree implementation
    - want to support both keys that are hashes and keys that are arbitrary strings of certain length
  - elias: been on vaccay last week, ongoing thing: finalize parallell yubihsm signing
    - have a version that works but needs some polishing
  - mw: witness group deployment at glasklar, still working on that
    - things left:
      - some networking stuff
      - getting certificates for boxes that only have restricted network access
        - getting cert via dns
      - then we should have the 3 wotness group machines up and running
  - patrick: had good discussion with tta, will followup this week
  - justin: have been trying to get some software supply chain stuff formalized into (IETF?)
    - there might be a pathway there to get things standardized, if desired later
    - filippo: what would be the benefit of a standard vs a spec like we have now?
      - justin: a lot of arganizations treat it as a more formal thing
      - justin: when governments want to use it, or lawyers
      - justin: in areas where government might buy something, it can matter
      - filippo: I wonder how that will work with MTC where C2SP specs are used
      - justin: there are companies that are really find of doing shitty things that they then get standardized
        - then they argue "hy use something that is not standardized?"
      - justin: the processes for stadnard bodies
        - you can sometimes bring your own process
    - rgdd: what would be the scope?
      - justin: TUF, in-toto, DSSE, TAF, Uptane (help add to notes here!)
      - filippo: that's a lot of scope
      - justin: this is like an umbrella, where all the different groups have their own processes
        - justin: different groups have different processes that are similar but not identical
        - justin: there are different groups, e.g. for the TUF spec
        - justin: then there is a steering ocmmitee that often says ok
        - filippo: about sigstore, will that be inside this umbrella?
          - justin: no, you can use things that are not in the spec, that is fine
          - justin: for a big system like sigstore you typically dop not specify the whole thing at once
          - filippo: so you can have a normative reference to a thing that ois outside?
            - justin: yes, to my understanding right now
          - filippo: in IETF with MTC we had to be careful to avoid different tlog variants
            - filippo: can you say "use that thing from that ecosystem over there"?
          - justin: this is supposed to be easier than IETF
          - justin: IETF worries about a lot of corner cases
          - justin: we want reasonable effort
          - filippo: what would it take to get C2SP to get recognized as a standards body?
            - justin: I don't know
            - justin: it does not have the "it is a standard" bit.
            - justin: I see what we are doing as a step beyond the C2SP model
            - justin: there are legal entities, something that has legal standing, a bit more framework around it
              - filippo: I would like to know what the things are
              - filippo: if the C2SP website says "this is a standards body", what else would it take?
              - justin: everybody has their own judgment about it
              - filippo: we have things that are used by all browsers
              - justin: do you mean all of C2SP, or some parts?
              - justin: I'm trying to eat an elephant here, don't want to put another elephant on my plate!
              - justin: happy to share what I learned
              - justin: it took us 7 years to get to this point
                - these projects are also under the Linux Foundation
                - something is now finally starting to happen
              - justin: I will have a small domain where I can take things and put them into this standardization process
              - justin: C2SP could declare on its website that we are a standards body
              - justin: want to make things smoother
              - filippo: so one thing is to have a legal entity
                - filippo: I often got vague answers, would like to get specifics written down
              - justin: there are some Linux Foundation processes
                - filippo: sure, but is all that necessary?
              - justin: I don't know.  I only know what the LF's lawyers asks me to do.
              - filippo: if one part of tlog things gets standardized and then there is a version 2 that it not standardized, then that would be a problem
              - rgdd: I share the concern about spec forking, it almost happened already and we avoided it

## Decisions

  - None

## Next steps

  - rgdd: still ensure that we queue up a 'this is what we're doing end of august when we're doing a broader renewal of the roadmap' decision
  - rgdd: witness deploy things (wrap up) with elias and mw
  - rgdd: also look at witness spec things, have some pokes in my inbox
  - filippo/warpfork: litewitness with ML-DSA?
  - filippo/warpfork: message signer interface, maybe make ssh agent implement that
  - filippo: sunlight implementation work this week
  - tta: have vacation coming up. want to have something to show in September
  - tta: will be implementing an observer, a producer, dirty and fast to begin with
  - patrick: discuss with tta
  - justin: talk with lawyers and community members
  - mw and elias: witness deploy things

## Other

  - None
