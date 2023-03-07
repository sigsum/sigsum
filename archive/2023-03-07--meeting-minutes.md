# Sigsum weekly

  - Date: 2023-03-07 1215 UTC
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
  - ln5

## Status round

  - nisse: booting up after vaccay, merging clean-up MRs
  - rgdd: review MRs from nisse

## Decisions

  - Decision: merge and iterate on the currently documented sigsum proof
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/18.
    - Recent change: Add 16-bit truncated checksum to the leaf line

## Next steps

  - nisse: policy format and implementation; tooling milestone
  - ln5: upgrade our stable log (ghost-shrimp) up to a recent version
  - ln5: write instructions and/or code for setting up availability monitoring,
    using checker
  - ln5: look into setting up gitlab pages, for documentation
  - rgdd: discuss policy with nisse
  - rgdd: follow-up with foxboron if we are ready to poke richard yet

## Other

  - nisse (from prev meeting): Is it right that secondary doesn't need the
    primary's pubkey? See
    https://git.glasklar.is/sigsum/core/log-go/-/merge_requests/106, it seems to
    work fine to just delete it.
    - Yes, see also comment in the above MR and note that "internal consistency
      endpoint" can also be dropped
  - Does anyone have experience with some of the (many) gopackages that attempt
    to do options parsing that is consistent with posix as well as GNU-style
    getopt_long? See discussion on
    https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/24, reasonable
    options (fairly minimalistic, and no transitive dependencies) seem to
    include pflags (https://github.com/ogier/pflag or some fork thereof) and
    getopt (https://github.com/pborman/getopt/, v2 variant). I'd like to try one
    of them out to see how it looks.
    - Try pflag, getopt, or both; seems to be roughly what we would like (small
      dependency w/o transitive dependencies; easy to understand; gives
      consistency with lots of other command-line tools).  If anyone has async
      comments here that would be much welcomed, poke nisse on irc/matrix.
