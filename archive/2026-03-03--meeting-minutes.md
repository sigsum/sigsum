# Sigsum weekly

- Date: 2026-03-03 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: elias
- Secretary: nisse

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- gregoire
- rgdd
- nisse
- filippo
- warpfork
- elias

## Status round

- rgdd: staging is now open in the witness network
  - google and geomys already joined the witness staging table
  - i've also asked if mullvad still wants to join it (as mentioned before)
  - staging witnesses are expected to at least not reset their state randomly
- rgdd: trying to move the per-log bastion dialog forward in witness network
  - https://github.com/transparency-dev/witness-network/issues/32
  - have been waiting until now that it has been added in litewitness
  - appreciate feedback in that issue
  - after feedback, the plan is to create a MR
- rgdd: added gh link in witness network footer + rendered list format
  - https://github.com/transparency-dev/witness-network/pull/27
- rgdd: small announcement: we're planning a community meetup in
  stockholm 5-7 may. If you're interested to attend all of it, or just
  a bit of social on 6th may afternoon/evening let me or someone from
  glasklar know and we will take it from there.
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2026-03-02-community-meetup-in-may-info
  - if you want to attend you can get more detailed info as well
  - reach out to rgdd or anyone at Glasklar if you want to attend
  - filippo: unfortunately those days seem difficult for me.
	- Teaching a phd course in cryptography engineering
- nisse: About to merge leaf-context proposal for reference, even
  though it has not been adopted.
  https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/125
  - agreed that it's probably not a good idea at this time
- nisse: for the sign-if-logged tkey app, the Tillitis people have
  merged an IO change that should make it easier to support both the
  old (Bellatrix) and new (Castor) version of the firmware.
- filippo:
	- Some thinking about AT proto tlog application
	- working on tagging with c2sp website
	- bot to let spec maintainers make tags
	- website in progress
	- merkle tree certs progressing in plants ietf wg
	- https://security.googleblog.com/2026/02/cultivating-robust-and-efficient.html
	- https://www.chromium.org/Home/chromium-security/post-quantum-auth-roadmap/
- gregoire:
  - deploying bastion
  - elias: can use that once new sigsum ansible is released

## Decisions

- None

## Next steps

- elias: sigsum ansible release
- gregoire: getting onto the staging list
- rgdd: filing MR for witness network for per-log bastion
- rgdd: high availability witness operation
- filippo: c2sp week, web ui, discussion board
- filippo: Going to real world crypto,
- filippo: high availability witness
- rgdd: sigsum-c review

## Other

- rgdd: question about last week's discussion about signature-less leaves
  - filippo: if signature is not stored anywhere, then that is
	something you would probably only do if the log is tightly coupled
	- the submitter is tightly coupled to the log to which things are submitted
	- sigsum keeps signatures so that the log can prove that the log
	  is not lying about an entry
	- rgdd: if you happen to have a log setup where it's the same trust domain
- filippo: AT proto tlogging
  - https://atproto.com/
  - https://overreacted.io/a-social-filesystem/
  - social media records are mutable and deleteable
  - how to also support immutable records? tlog for subsets of records
  - tlog configuration could be published as an AT record, then log
	operators could look for such records.
  - used by bluesky, tangled, talk about package managers, appstores
	- https://standard.site/
	- https://tangled.org/
- elias: question about witness-network.org staging list
  - is it reasonable to add production logs and witnesses there?
	- that's ok, then later when the prod list is open those can be
	  moved from staging to prod
