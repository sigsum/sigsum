# Sigsum weekly

  - Date: 2026-06-02 1215 UTC
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
  - tta
  - nisse
  - elias
  - florolf
  - gregoire
  - patrick
  - Justin Cappos
  - filippo

## Status round

  - elias: commented in https://github.com/FiloSottile/torchwood/pull/71 about witness metrics
    - litewitness metrics would be very useful for Glasklar's witness deployments
    - waiting for maintainer (filippo) to hopefully get some version of that merged
  - elias: worked on parallel signing for sigsum-agent with help from nisse. Draft MR:
    - https://git.glasklar.is/sigsum/core/key-mgmt/-/merge_requests/37
  - nisse: Minor update of https://github.com/C2SP/C2SP/pull/233 (tlog-policy). Unclear what's next step to configure maintainers for this spec?
    - how to register that properly, in maintainers file or similar?
    - filippo: second steward missing, will look at that
  - nisse: working on unit tests for sign-if-logged
  - nisse: proposal, see below
  - tta: making progress on a quick & dirty impl for "observers" in atrans
    - started implementing something
  - tta: haven't started work on slides to present transparency to non-technical ppl
    - social science lab
    - plan to start this week
  - tta: PTF kick-off meeting 
    - AT funding is now public https://www.prototypefund.de/en/projects/archive-transparency
    - talked about transparency logs to some nice ppl:
      - had a nice interaction with David from https://signstar.archlinux.page/
        - David pointed me to https://voa.archlinux.page/ (see linked UAPI spec)
      - found someone (Basile Simon) talking about transparency and witnesses:
        - https://digitalevidencetoolkit.org/tools/zeitwerk-timestamping/
          - rgdd: if you figure out more what they are doing, I'd be very interested
        - not sure if it relates to tlogs (he proposed me to talk about it, will update)
        - unsure if Zeitwerk is related to what looks like a SaaS product seed https://evidx.de/ by same author
  - florolf: sigsum-c 1.0 package merged in Buildroot distribution (https://gitlab.com/buildroot.org/buildroot/-/tree/next/package/sigsum-c), will be released as part of 2026.08
  - gregoire: configuring 100qps list at witness-network.org for our staging witness
  - filippo: drove many kilometers on a motorcycle
  - filippo: had a few conversations around MTC (merkle tree certificates)
    - filippo: a proposal that would have made it harder to interoperate with tlogs has been rejected, that's good
    - filippo: one big part still missing för MTC is browser policy
    - rgdd: what else is missing?
      - filippo: a better explanation of subtrees may be needed
      - rgdd: so from a technical opint of view it's done?
        - filippo: yes, now is a good time to read the MTC spec.
        - filippo: there will also be a C2SP spec saying how to work with MTC
          - things like "how do you get a tree witnessed?"
        - filippo: been thinking about how to make CA redundant
          - maybe just PR into each acme client to get them to support round-robining across different CAs
          - filippo: it's something that I think acme clients would benefit from anyway
  - Justin Cappos: Is there a list of attacks prevented by TLs?
    - has a transparency log stopped an attack, or other scenarios like this?
      - filippo: I'm not sure how that would look like
        - filippo: how would you detect if someone refused to use something because it was not logged
      - justin: my understanding is that people are not putting in transparency logs first
        - there could be cases where the first thing we detected was due to a transparency log
        - filippo: I think there is also a deterrance mechanism
        - filippo: take the Go checksum database as an example
          - if you just trusted google, then you would not need the tlog
            - the point of the tlog is that you don't have to trust google
          - justin: ok, but it could happen that a thing helps to detect mistakes
            - justin: it could be that something failed in the middle and a checksum was not updated, or similar
            - justin: it's helpful to be able to show specific cases
            - filippo: the Go checksum database just never made a mistake
            - rgdd: there is detection and prevention and deterrance
              - rgdd: for certificate transparency, there are incidents that have happened and where people detected misbehavior due to certificate transparency
              - filippo: yes, in the CT ecosystem there is plenty of examples
            - filippo: tlogs is the reason we were able to roll out something centralized
              - filippo: in Go, the attack where you change the meaning of a package version number does not exist,  and you can kind of thank tlogs for that.
            - justin: we could go back and look at some of the issues that have happened in the javascript community and compare to the Go community where corresponding things have not happened
              - justin: I want to cut through the hype and be able to see something from a comparison
              - nisse: I wonder if there is some interesting data from gopherwatch
              - rgdd: there are certainly cases where the github repo does not exist anymore
              - filippo: there is certainly the deterrance aspect, where an attacker will not try
              - nisse: if you try to get an evil thing into the Go checksum database, and then make something else visible
                - filippo: there are cases where someone has changed a github repo afterwards, after something bad was logged in the Go checksum database
                - filippo: Go avoided a number of attacks, partly due to tlogs and partly due to things made possible by tlogs (but harder to make that case)
                - justin: to win people over that are sceptical, it would be good to have some examples, I'll poke around
                  - justin: if you have examples, then please send them to me
  - patrick: trying to read through the document from last week, within the next week or two, then discuss that
  - mw: question for filippo: is there a planned version bump for litewitness that we could possibly get into the debian upstream?
    - filippo: sure, I can merge the metrics and tag a release
  - mw: I'm working on SELinux policies for sigsum-agent and litewitness
  - rgdd: doing a bit of tdev summit interest survey work
  - rgdd: a bit of planning work to move the witness deployment work forward at Glasklar
  - rgdd: was in Gothenburg yesterday and visited Elena who is working on research related to tlogs
    - justin: I would be interested to discuss with Elena
      - rgdd: ok I will put you in contact

## Decisions

  - Decision: Reject duplicate cosignature key hashes https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/145
    - nisse: the same keyhash appearing several times could be a hassle
    - nisse: I see no reasonable use in having multiple cosignatures with the same keyhash
    - nisse: so the proposal is to make that invalid
    - nisse: looked at implementations
    - gregoire: my library does essentially the same thing that the sigsum library is doing
    - filippo: I think this sounds right, a "should" seems right
    - rgdd: does it make sense to get this into tlog-proof?
      - filippo: it should be in tlog-checkpoint
      - rgdd: we can resolve that separately, but anyway it can get into C2SP
    - decided!

## Next steps

  - filippo: ensure 2nd steward in c2sp gives a +1 to tlog-policy in c2sp
  - filippo: litewitness release with prom metrics
  - filippo: tlog mirror and ml dsa in sunlight
  - mw: continue with witness deployment that we have going on at glasklar
    - more packaging & infra sysadm stuff
  - elias: continue work on parallel signing for sigsum-agent
  - nisse: follow-up from decided proposal (incl c2sp issue and later help figure out what may go ehwere), and help elias with his
  - nisse: also sign-if-logged stuff
  - rgdd: help with planning witness deploy things at glasklar
  - rgdd: send email to justin introducing justin and Elena to eachother
  - tta: start on slides as promised
  - gregoire: presenting sigsum at an internal conference
    - rgdd: if you have anything to share from that, please do!

## Other

  - None
