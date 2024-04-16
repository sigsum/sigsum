# Sigsum weekly

- Date: 2024-04-16 1215 UTC
- Meet: https://meet.sigsum.org/sigsum
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

- rgdd: a note on planning/roadmapping -- nisse and I (and also on a best-effort
  level ln5) are soon about to ramp up our sigsum work. We are wrapping up ST
  releases this week and the next, then the plan is to focus more on Sigsum
  again. I will create an updated roadmap that captures this soon, but it won't
  happen this week.
- filippo: worked with trustfabric folks to figure out what things go where --
  bunch of Go modules spread out everywhere. Reviewed some of their PRs
  implementing some of our stuff. Shared RWC talk with a few folks, responding
  to some non-goal suggestions in c2sp. And have been semi-off first week of
  april.
  - nisse: Go module things -- not a big problem if every group have its own
    implementation, might even iron out issues in the spec. And we will also
    have non-Go implementations of the specs as well -- e.g., C.
  - filippo: and we have made it simple enough for it to be possible to have
    multiple impl; it is test vectors we really need to share.
  - nisse: the main danger with many impl is if one ref impl becomes the spec;
    but this is why we have specs now in c2sp that should be the ref.
- filippo: vkeys in note format, trustfabric folks like it. They like them
  because agnostic encoding. We're a bit unsure exactly what we want here, needs
  more thinking.
- filippo: sunlight and tile-based static api for ct (spec) with the same name
  -> mistake; e.g., if trillian implements the sunlight spec its not a sunlight
  log. If you have brilliant idea for the spec name -> please let me know.
  - "the static ct api" is the best idea so far
  - c2sp.org/static-ct, short and sweet? cf just name "ct" in rfc 6962

## Decisions

- None

## Next steps

- filippo: most useful thing right now would probably be to help with the
  bastion feeder for the armory witness. Which will include merging the protocol
  API.

## Other

- None
