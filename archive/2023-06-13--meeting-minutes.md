# Sigsum weekly

  - Date: 2023-06-13 1215 UTC
  - Meet: https://meet.sigsum.org/sigsum
  - Chair: rgdd

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - nisse: Not here (on train).
  - filippo
  - rgdd
  - foxboron

## Status round

  - rgdd: follow-up regarding the "Other" idea about meet structure
    - When fleshing out a quick 15m proposal it did not really seem to be an
      improvement compared to today, aborted.  It would basically just merge the
      current "Status round" and "Next steps" into a single section.  Removing
      some of the "past" in these reports seem undesirable, it is very helpful
      for overview even though we have issues / MRs / milestones / roadmap in
      gitlab.
  - nisse: Python witness updated to act as server.
  - nisse: Refactored merkle tree functions, batch inclusion verification (for
    monitor) in progress.
  - filippo: addressed more litetlog comments from
    https://pad.sigsum.org/p/ed95-ae15-dc36-df89
    - add get-tree-size, make -backends a reloadable file, fix list-tree-heads
      help text, add startup log lines
  - filippo: merged pkg/ascii MR
  - filippo: updated https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/36
    - Add as proposed decision for next week, after that rc-1
  - Foxboron: patched ansible for witness config, currently waiting for linus
  - filippo: MR!36, should be ready to be merged and decided for next week.

## Decisions

  - None

## Next steps

  - filippo: litetlog: bastion library, support multiple bastions, metrics
  - filippo: follow-up on https://github.com/transparency-dev/witness/pull/41
  - rgdd: try the updated witness from filippo, try witness from nisse
  - foxboron: poke linus about ansible+witness config

## Other

  - test vectors, PR @CCTV please
  - do verifiable maps really add value to key transparency?
    - https://github.com/google/keytransparency/tree/master/docs
    - https://github.com/google/trillian/tree/master/experimental/batchmap
    - https://eprint.iacr.org/2023/081.pdf
    - https://cs.stanford.edu/events/kevin-lewi-whatsapp-key-transparency
    - Zoom presentation at 2300 UTC
      - https://stanford.zoom.us/j/99597298902?pwd=VVBpL3F6TldHd2w5U2dFckJXRGZ5UT09
    - https://securitycryptographywhatever.com/2023/05/06/whatsapp-key-transparency/
  - GitHub push log
    - https://abyssdomain.expert/@filippo/110497045267596945
