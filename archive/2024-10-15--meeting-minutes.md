# Sigsum weekly

    - Date: 2024-08-15 1215 UTC
    - Meet: https://meet.glasklar.is/sigsum
    - Chair: nisse

## Agenda

    - Hello
    - Status round
    - Decisions
    - Next steps
    - Other (after the meet if time permits)

## Hello

    - rgdd (async -- note here today)
    - filippo
    - nisse

## Status round

    - rgdd: tdev summit last week
        - Full talk: https://www.youtube.com/watch?v=Mp23yQxYm2c
        - Lightning talk: https://www.youtube.com/watch?v=ca-qnXIo-2Y
    - nisse:
        - tdev lightning talk: https://www.youtube.com/watch?v=fY_v7yNrl2A
            - looking into tkey poc for witness and log signers
            - working on conversion utilities
            - Draft design for running a tlog witness on a tkey with storage
	    https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2024-10-07-design-witness-on-tkey.md?ref_type=heads
	- filippo: tdev summit
            - Talk about end-to-end stories: https://www.youtube.com/watch?v=PdiPUFYM5bY
            - Reached consensus for public witness ecosystem (including log of logs in transparency-dev and trust policy semantics by nisse):  https://docs.google.com/document/d/1IIeih8MPaJrMPtvHTjkwHGjzNSdql6G9Z-1JrFTmF8s/edit
            - Some volunteers for running witnesses (incl. from IETF-world)
            - Ideas about log-backed maps
	- filippo: chatting with TF about log-backed map abstraction
	- filippo: new version of litewitness
	  https://github.com/FiloSottile/litetlog/releases/tag/v0.2.0
	  https://milan.filippo.io/dev-witness/
	
## Decisions

    - None

## Next steps

    - rgdd: vaccation this week, and next week i'm picking up planning and roadmapping (both sigsum and ST).  I already did quite a bit of discussion and debrief with kfs post tdev-summit, and I might want to continue a bit of that and also 1on1 sync with some of you as further input (i'll poke).
    - filippo: discuss Matrix / Slack bridged room
    - filippo: debug litewitness cosignatures
    - filippo: prototype age end2and and/or log-backed map?
    - filippo: C2SP spec for Merkle Patricia Tries
    - filippo: respond on sigsum-general
    - nisse: tkey prototyping

## Other

    - nisse: origin-line-to-key authority?
        - https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-general@lists.sigsum.org/thread/BBTA2MJ3U3T7HNYWM6GFQ7565MYTRQOM/
        - tkey host can do the checking, if it were malicious it would be like a malicious log, which is acceptable per threat model, and a DoS which is anyway possible by the host (although the DoS is unrecoverable)
	    - as long as tkey keeps track of (origin, latest tree head)
	    - we should write up the role of log signing keys as purely access control to interact with witnesses, they don't have any other security role
	        - also they don't have to be the same as the client-verified keys (which allows those to be of different type)
    - useful reading for KT https://docs.rs/akd_core/latest/akd_core/
    - interesting Mastodon discussion on silentct
    https://abyssdomain.expert/@filippo/113301544688289383
