# Sigsum weekly

  - Date: 2026-09-15 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: tta
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - elias
  - tta
  - nisse
  - quite
  - mw
  - tta
  - filippo

## Status round

  - nisse: More or less done with tile prototype, see  https://git.glasklar.is/nisse/tiles/ for code and notes.
  - nisse: wip ed25519 pubkey validation, https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/318. Questions:
      - Do as part of the sigsum-go/pkg/crypto.Verify function, or elsewhere?
      - Depend on filippo.io/edwards25519 (a dozen lines in sigsum-go), or write up in terms of math/big (probably 100 lines)?
      - Should validation also check that q A == identity? That is more expensive than the low order check that 8 A != identity? This would reject an input pubkey if that is the sum of a valid key and a low-order point, which I think is a mostly harmless deviation from what's expected. 
    I think it makes sense with new releases of sigsum-go and log-go after this is completed.
	- nisse: Merged refactored log-go metrics, see https://git.glasklar.is/sigsum/core/log-go/-/merge_requests/218
	- nisse: Started on outline for tds talk about the sign-if-logged TKey app.
 - tta: on Archive Transparency this week, me trying to get numbers that reflects a production scale
	- found out that I'm missing 2000-2020 ArXiv (misconfigured DL by me a month ago) and bad home internet means it's weeks to DL that (so I'm going to start with the 7.5TB from 1991-2000 & 2020-2024 I have on disk)
	- I've processed a million PDF files \ô/ into records (see https://archive.rip/static/tmp/record-example.txt cc)
	- currently processing ~5 times more source files (total projected to be about ~3-4GB for 8-10M records)
	- batching this in ~5MB manifests gives ~10K items per manifest and total of 800-1000 manifests to sign
	- at 1 transparency-logged signature per manifest, rate limit at 200 leaves per day, it's 4-5 days to submit
- tta: to sum up, ArXiv is ~15TB of items, would be ~20M records, ~2 weeks of background jobs at current rates
- tta: almost finished a "complete description" that I'm confident I can refactor in a v1 spec later:
https://codeberg.org/openrip/project/src/branch/main/notes/2026-08-25-015-observer-workflow.md
	- currently it's a monolith of 20k+ words / 120min+ read — I'll sort through all this later to make it readable
	- started implementing it +now adjusting with lessons from the impl (like how to // process 7TB etc)
    - nisse: do you download the pdf files or something else?
      - tta: they provide both pdf and source files via s3 buckets, I download all of it
- quite: for sigsum-agent: added support for mldsa-44 key in openssh PEM format, and as well passphrase encryption.
  - not in x/crypto
- quite: for litewitness: will add a separate flag for the bastion key, instead of automatically using the witness key, as discussed last week. Also makes things much neater for the support for additional algorithms and multiple keys (cosignatures).
  - separation of concerns
- mw: work in progress: pgp in sign-if-logged
  - slow progress, but at least have something that can generate a key
    - will ask nisse for feedback later
- mw: sysadm work, hardening for our new witness group.
- filippo:
    - chatted with martin about the problem eric was having related to metadata for a log
      - needed for verifiable indexes
      - CT has json files with info about logs that are monitored
      - need to decide where to put it, as a separate spec or not
      - like a superset of the log-list used in witness-network.org
- filippo: worked on MTC (merkle tree certs)
- elias: been working with mw on the hardning for witness deployment.

## Decisions

  - None

## Next steps

  - None

## Other

  - TDS summit is in 2 weeks already!
    - https://transparency.dev/summit2026/
