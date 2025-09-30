# Sigsum weekly

- Date: 2025-09-30 1215 UTC
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

- rgdd (async not here)
- elias
- nisse
- filippo
- florolf

## Status round

- rgdd: tds schedule is ready, should be publishes probably today or any day now!
- rgdd: al and i have been tinkering on our wip witness network
  - old wip location: https://git.glasklar.is/rgdd/witness-configuration-network/
  - new git source: https://github.com/transparency-dev/witness-network
  - governance plan: https://github.com/transparency-dev/witness-network/blob/main/archive/2025-09-23-notes-on-governance
- elias: worked on implementing named policy things
  - thanks nisse for reviewing
  - merged: https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/258
  - under review: https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/262
  - should also update documentation, like man pages? Now or later?
	- nisse: I think primary docs of named-policy things could go in
      doc/tools.md. Then new flags (like -P) should also be mentioned
      in --help messages, from which tool-specific man pages are
      generated.
    - could complete impl first, then do a doc MR.
- florolf: SSH cert CT demo: https://github.com/florolf/sshca/blob/ct-poc/doc/ssh-ct.md
  - A bit kludgy but I think the best you can do without patching OpenSSH
  - elias: any feedback on sigsum interfaces?
  - florolf: no way to give a checksum to go library verify functions.
- nisse:
  - working on sigsum tkey apps, starting with a new take of the
    sign-if-logged app from the hackathon a few years ago.
  - didn't get to writing up any proposals (stricter policy, maybe leaf signing context).
- ln5 (not present at the meeting): work on witness operations howto
  guide has been started, nothing exciting to report yet
- filippo: 
  - Implemented log list in litewitness
    https://github.com/FiloSottile/torchwood/pull/32
    https://github.com/transparency-dev/witness-network/blob/main/log-list-format.md
    - instead of internal schedule, relies on external cron job, silent except on log key collisions/changes
    - new witnessctl command
  - Thinking of polishing spicy tool, related to tessera-1.0
	https://github.com/transparency-dev/tessera/tree/main/cmd/examples/posix-oneshot
	should work as a drop in replacement for, e.g., pgp signature
	verification need context/metadata, defaulting to protecting
	filename
			
## Decisions

- None

## Next steps

- filippo: think through UX of spicy CLI tool, compare potential proof
  format with Sigsum proof format
- filippo: write abstract for my tds talk
- elias: try out litewitness log list pull thing
- nisse: write up policy proposal
- florolf: wants to run a witness
    - preferably with a restricted signer device, maybe
      microcontroller based (tkey is slow, hardware trust issues (side
      channels, NVCM vs a OTP fuse bank, TRNG (not relevant here
      though)), not yet with storage)
    
## Other

- None
