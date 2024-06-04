# Sigsum weekly

- Date: 2024-06-04 1215 UTC
- Meet: https://meet.sigsum.org/sigsum
- Chair: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- nisse
- rgdd
- filippo
- gregoire

## Status round

- nisse: discussed bastion deployment in person last week. Concluded that for
  now, let's just run it as a separate service based on filippo's current
  implementation.
  - https://git.glasklar.is/glasklar/services/sigsum-logs/-/issues/7
  - as far as we know: nothing is needed from filippo's side to make progress
    here
- filippo: vaccay last week. Week before that: published tlog tiles as a PR.
  TrustFabric folks focusing on that. Trying to finnish it up, then another
  round of feedback on witness PR. Also been working on a revision on the
  sunlight spec, to be able to do engineering work that includes adding
  witnessing support.
- rgdd: prepped the roadmap below with input from folks

## Decisions

- Decision: Adopt updated roadmap
  - [Roadmap](./2024-06-04-roadmap.md)
  - To be renewed: after the summer holidays (~end of August)
- Decision: Put weekly meets on pause during the summer between 16/7 - 13/8. The
  first weekly meet after the break is 20th aug.
  - Keep in touch async on irc/matrix and do adhoc meetings on a need basis if
    you are working during the summer
  - (Works for filippo, but warning will be away for the last meet before the
    break.)

## Next steps

- filippo: get tlog tiles spec merged, and then hopefully the witness spec.
- filippo: sunlight engineering work (goal is to include witnessing
  implementation, to maybe get some of the test logs to start acting as
  witnesses)
- filippo: also working with the TrustFabric folk on the transparency dev event
  in london.
  - All of nisse, gregoire, and rgdd filed interest requests already; rgdd also
    suggested 4 talk ideas (3x transparency/sigsum, 1x ct monitoring), and
    offered to join the planning committee if needed. Seems like there are
    enough folks already though, great!
  - Let's remind ln5 to enter his interest to attend (if that is the case and he
    did not already do so)
- nisse: will look at the tiles spec, but not expecting to do any other progress
  until next week.
- rgdd: get bastion.glasklar.is up and running (needs assist by Linus with DNS
  records and IP addresses)
  - https://git.glasklar.is/glasklar/services/sigsum-logs/-/issues/7

## Other

- filippo: any opinions on tlog tiles or sunlight? Now would be a good time to
  let me know.
  - nisse will read the tiles spec (adding this to the next steps above)
  - https://github.com/C2SP/C2SP/pull/73
  - this spec will unfortunately be inompactible with both Go's sumdb and
    sunlight; because newlines in sumdb (not general enough). And sunlight has
    to deal with the fact that RFC 6962 does not put all the data in the merkle
    tree. So you have to save the actual thing as leaf, and as extra data.
  - nisse: log application specific stuff for leaf data, but use the same for
    interior nodes that only have hashes?
- For those looking to do client-side things for sunlight, see
  - https://pkg.go.dev/filippo.io/sunlight@main (but the latest untagged
    version)
  - x/mod/sumdb/tlog
  - with the above it should be possible to do monitor things. There's even an
    adapter where the function will fetch the title and give you the thing so
    that the hashes can be read. I.e., automatically finds the right title etc.
  - it should be relatively easy for https://git.glasklar.is/rgdd/silentct to
    start using this, there's already a placeholder to add sunlight support
