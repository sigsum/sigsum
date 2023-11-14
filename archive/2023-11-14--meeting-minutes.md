# Sigsum weekly

- Date: 2023-11-14 1215 UTC
- Meet: https://meet.sigsum.org/sigsum
- Chair: rgdd

## Agenda

- Hello
- Other (C2SP)
- Status round
- Decisions
- Next steps
- Other (again, if time permits)

## Hello

- rgdd
- nisse
- filippo
- kfreds

## Status round

- nisse: log.md v1 finally released last week.
  - nisse: Started writing on a new design paper, current draft at
    https://git.glasklar.is/nisse/cats-2023
  - nisse: Dusting off sigsum server MR,
    https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/119
- rgdd: feedback to nisse and filippo, mainly related to:
  - https://git.glasklar.is/sigsum/project/documentation/-/issues/13
  - https://git.glasklar.is/sigsum/project/documentation/-/issues/49
- (These were async status reports, we did not to this part today.)

## Decisions

- None

## Next steps

- We didn't do this part today

## Other

- C2SP (what is it, what's the opportunity, etc)
  - We had an initial discussion about this, no notes sorry
  - Before moving anything forward -> proposal
  - Would be good to decide on this soon, ideally before cats

Some async other things:

- https://filippo.io/a-different-CT-log some questions: (nisse)
  - Is there a spec for the tiling? Naming and contents of tiles is not obvious
    to me. I'd be happy to do some sigsum tiling if/when we do a non-trillian
    backend.
  - I take it the proposed tree head signatures are compatible with sigsum (as
    long as Ed25519 is used)?
    - No
  - Nice having leaf index returned when leafs are added, so that one doesn't
    have to expose any "get-leaf-by-hash" lookup.
  - More on the by-hash thing: It is then needed only for deduplication, is that
    deduplication essential for ct, or for sigsum, or for tlogs in general?
    - In CT, a log is not allowed to issue two (different) SCTs for the same log
      entry. Not specified in RFC 6962, but required by the Google Chrome policy
      since ~2020 or so. See
      https://googlechrome.github.io/CertificateTransparency/log_policy.html for
      details.
  - Tangential: sqlite sounds like overkill for the hash->index key-value
    mapping. Is there some nice and simple go library for a key-value store aka
    persistent map? I tried to look for that a few months ago, but was rather
    confused.
  - Is there some summary of "recent events"? I'm blissfully ignorant of
    CT/cloudflare? outages.
    - https://groups.google.com/a/chromium.org/g/ct-policy
