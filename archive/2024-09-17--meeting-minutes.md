# Sigsum weekly

- Date: 2024-09-17 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- rgdd
- nisse
- filippo

## Status round

- filippo: c2sp spec tags done
  - rgdd: happy where we're at with this before transaprency-dev summit
- filippo: not much to report today -- had vaccation and mostly catching up last
  week. Starting to think through the talk for transparency-dev summit. Chatting
  with Martin and Hayden about monitoring. And starting to build e2e stories for
  how we talk about the transparency systems. Because now we built the building
  blocks, and would like to shift the focus towards complete stories.
- filippo: discussing maps. Think in sigsum and witness ecosystem -> extracted
  useful subset that is easy to think about. Starting to think whether we can do
  the same thing for maps, or if you need the whole seamless complexity stack
  for doing anything useful. Essentially -- simpler version for maps that's
  useful for things that are not the KT hyper scalors? Whatsapp needs the whole
  thing fine. But age key server for example. Is there a meaningful subset of
  maps?
  - rgdd: "yes"
  - https://docs.rs/akd_core/latest/akd_core/
  - https://continusec.com/static/VerifiableDataStructures.pdf
  - we're not sure if it was written up that log-backed map can get you an
    append-only map (for versions of a key, aka history proofs) without the
    seemless stuff. If not it would be helpful to write it down. Would also be
    good to point out that global consistency and the full audit function
    doesn't necessarily need to be coupled.
- rgdd: mostly been working on sigsum's ansible collection
  - fix nits that made tests not working; and target testing on Debian bookworm
  - golang role
    (https://git.glasklar.is/sigsum/admin/ansible/-/merge_requests/9)
  - sigsum-agent role
    (https://git.glasklar.is/sigsum/admin/ansible/-/merge_requests/10)
    - works with >1 instances per host (systemctl --user configuration)
    - uses systemd socket-based activation for process separation
    - only soft key is supported in the initial implementation now
    - extending with yubihsm support should be relatively easy though
- rgdd: tried to figure out some magic ansible-galaxy things in our ansible repo
  - currently thinking we can delete some .rst and duplicated metadata stuff
  - https://git.glasklar.is/sigsum/admin/ansible/-/issues/17#note_19263
- rgdd: would like to get the updated history.md merged (ping filippo)
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/85
- rgdd: misc things like transparency-dev summit planning, review, etc.
- nisse: wip witness protocol, see:
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/190
  - https://git.glasklar.is/sigsum/core/log-go/-/merge_requests/163
  - starting to get into shape -- don't need anything from anyone right now but
    will be splitting out smaller MRs for review soon ish.
- nisse: Filed issue on tombstone proposal:
  https://git.glasklar.is/sigsum/project/documentation/-/issues/60
- nisse: filed test vector with one test vector in c2sp
  - filippo: need to figure out if it should be in cctv or specs.

## Decisions

- None

## Next steps

- rgdd: upgrade poc.so to use its soft key via sigsum-agent
- rgdd: extend sigsum-agent role with yubihsm-support + test-deploy somewhere
- rgdd: figure out if our ansible collection needs anything wrt. the DNS TLD
  list
- rgdd: consider a yubihsm-connector role (or maybe this is left as "manual")
- filippo: post notes in tombstone proposal
  - https://git.glasklar.is/sigsum/project/documentation/-/issues/60
- filippo: post notes on signed note dicussion in gregoire's MR
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/81
- filippo: litewitness which is tag compatible with spec. And tag it.
- filippo: write-up proposal for named policy files (if time permits)
- nisse: just keep hacking

## Other

- fyi: preliminary transparency-dev schedule is available now
  - https://transparency.dev/schedule/
- what's the status of --version flags for all sigsum software?
  - it would be nice if go install "just works" as recently fixed in ST
  - for log-go it would allow quite a bit of clean-up in our ansible repo
    (currently we git-clone, go build with -ld flags, etc)
  - (ST uses runtime.debug.buildinfo. Filippo warns it works with go install TAG
    or latest, but git clone + go build or go install locally -> it might not
    work with.)
  - see
    https://git.glasklar.is/system-transparency/core/stboot/-/blob/main/stboot.go?ref_type=heads#L87
  - maybe filippo have the release timing wrong -- though that was a later go
    version thing.
  - if that works in 1.22 -- fantastic. 1.24 -> info main version will start
    autopopulating. So the whole vcs stuff gets folded into the main version.
  - rgdd will open an issue to get something like this for our things when we
    have some spare time
  - and reliably setting --version for sigsum-go tooling will likely help users
    too
