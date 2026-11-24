# Sigsum weekly

  - Date: 2026-11-24 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: rgdd
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - elias
  - mw
  - rgdd
  - nisse
  - tta
  - gregoire
  - quite
  - warpfork

## Status round

  - nisse: About to deploy prototype server. Currently tiles-server (with no data) at http://poc-v2.test.sigsum.org:2001/
    - running but currently no data to serve
    - it should perhaps have a root page with some info, does not have that yet
  - nisse: Updated log-go to use sigsum.org/sigsum-go/v2 v2.0.0-dev.1
    - updated module name everywhere and corresponding tag
    - started thinking about what to do for checksum support
  - quite: some progress on understanding sigsum-go code and sigsum log-go architecture
  - quite: about checksum: in sigusm there is no concept of "origin line"?
    - nisse: sigsum logs always have an origin line that is derived from keyhash
    - see vkey example at the bottom of this pad
  - quite: looked at USB Armory a bit, investigating the hardware
    - learning about filippo's project regarding usb armory
    - there are notes, https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2026-11-24-small-investigation-of-the-usb-armory.md
  - tta: this friday is going to be a demo-day for archive transparency
    - have a demo of a mirror:
      - https://mirror26.testing.archive.rip/
      - there is the concept of observers
      - an observer can submit a manifest
      - sigsum logged using sigsum-generic policy
      - made my first sigsum signatures, happy about that
      - one thing I tried was to give a manifest to a LLM agent and it could come up with a verifier
    - rgdd: so on friday you will be demoing this alongside many other projects?
      - yes
      - will there be a livestream?
        - not sure
      - other projects include tools for investigative journalism
      - rgdd: if there is a livestream, please share it in the sigsum matrix room
    - warpfork: I have some feedback for tta
      - --> see other section below
  - elias: working on glasklar witness deployment things
    - hardening -- limiting which dns queries can be done from the witness machine. Part of an effort to make it hard to extract information from the machine.
  - mw: have been paying back some tech debt that we took on earlier this year regarding packaging for witnessing software
    - will now use a single source-of-truth instead of information spread out as before
  - rgdd: main thing since last week; scripts for plotting and computing availability numbers from metrics exported for the glasklar witness group
    - also a readme file describing the metrics and how they can be used
  - rgdd: worked on getting a meeting time with hayden
  - rgdd: did not have time to draft new roadmap yet, will do that soon
  - quite&nisse: the parallel signing feature was merged in sigsum-agent
    - in the sigsum key-mgmt repo

## Decisions

  - Adding a "Distinguished contributors" list on the sigsum web page?
    - no decision now, but will queue it up for decision next week

## Next steps

  - rgdd: draft next sigsum roadmap
  - rgdd: witness metrics
  - rgdd: queue up proposal for "distinguished contributor" list
  - rgdd: continue trying to find a time to sync with hayden about identity based leaf
    - probably also prepare the changes that we want to apply in a commit that can be applied?
  - mw: finish the packaging stuff
  - mw: talk to nisse about what we have for pgp now
  - elias: use packaging that mw has done for witness machines in glasklar witness group
  - nisse: will focus on the Sigsum v2 prototype
  - quite: 
  - tta: demo friday, will check if there is a livestream
  - gregoire: update rust sigsum verified to support new policy format
  - warpfork: package manager using a manifest format connected to a transparency log

## Other

  - warpfork: feedback for tta:
    - suggest making a more interactive demo
    - tta: the idea is for the mirror to be something to be used for the coming several months
    - tta: hopefully next week there can be something you can click on and go through the steps
    - tta: please send me more feedback if you have
  - rgdd: q for warpfork: links to your PLC work?
    - not yet  
  - elias: should we change protected branch settings for sigsum repos so that nobody can merge directly to main?
    - to avoid pushing to main unintentionally if intended workflow is to always do changes via MRs
    - do this for all Sigsum repos in "core"?
      - https://git.glasklar.is/sigsum/core
      - yes, let's do that
      - also for the sigusm ansible repo
      - do it for all code repos basically
  - nisse: self-authenticating origin line in c2sp? Say prefix c2sp.org/self-authenticated/<type>/<label>, origin = prefix + / + hash(prefix + NUL + pubkey)
    - the full hash? yes
    - nisse: the spec would have a strong recommendation that if you use a log identified in that way, then you should not use any other key than the one given inside the self-authenticating origin line
    - nisse: the main thing is that it's human-readable
    - rgdd: it has been a hassle that we always have a comment next to each thing
    - nisse: could make sense in the c2sp checkopint spec
    - rgdd: sounds like a good step forward
    - nisse: makes most sense for origin lines which is why it could be in the checkpoint spec
      - you could use it for witness keys or other keys, but not sure how useful that would be

### Example vkey for a sigsum log in witness network

```
vkey sigsum.org/v1/tree/e93cb678c04cc52e4da380c4b19cfa14062032a722da254c65cbd95e7e76321d+c6279f6d+Ae3din1x8uLDUC6N8XgsRfxj5BmBw23kv3Aq2y6nVHHd
qpd 8640
contact services@mullvad.net | https://driftwood.tlog.devmole.eu/about
```

### mirror26 demo

- these folders (policies//observers//mirrors//manifests//issuers) probably mean something!
	- do a reading guide alongside the folder view.  if someone's got one tab open on their screen, and they need to understand what they're looking at without opening a second tab: aim for that.
	- others (e.g. "obs26+rfcs" and siblings) are presumably instances and examples -- ok, have the reading guide pane on the side just say that.
- if you want to make a visceral impression that this describes other documents that are currently live in the world: do that.
	- so like these paths that are inside `manifest-*.txt` files:
		- make a renderer for these.  spice them up with links to the originals.  and/or links to a mirror.
		- if someone interacts with this demo, give them something to click!
		- (you don't have to copy this, but, for example, i was kinda pleased with how https://catalog.warpsys.org/warpsys.org/bash/_replays/zM5K3Vgei44et6RzTA785sEZGwuFV75vCazjhR11RH5veFdMTx7F5cg2c4NA5HXPK8Zv5TQ.html turned out: it's literally json of raw data, still, but... spiced with links.  Not so much a rendering that it hides data or abstracts anything: but makes it interactable.)
