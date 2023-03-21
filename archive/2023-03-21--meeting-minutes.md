# Sigsum weekly

  - Date: 2023-03-21 1215 UTC
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
  - foxboron
  - nisse
  - filippo

## Status round

  - rgdd: gentle reminder that our weekly's are at 1215 UTC, depending on where
    you are located your local time may be affected by daylight savings
  - rgdd: had a virtual walk to sync with gregoire
  - rgdd: read docs/proposals to provide input
  - nisse: For log-release: 
      1. log config changes,
         https://git.glasklar.is/sigsum/core/log-go/-/merge_requests/115
      2. Revive MR to delete witness and cosignature support (soon to be added
         back with new witness protocol)?
         https://git.glasklar.is/sigsum/core/log-go/-/merge_requests/66
  - nisse: Updated sigsum-log and sigsum-verify to use policy file
  - ln5: re-deployed jellyfish (the one on poc.so) and ghost-shrimp using new
    Ansible roles
  - filippo: prepared proposal for checkpoint witness compatibility
    https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/30
  - filippo: prototyped a ssh-agent based witness
  - filippo: summarized bastion productionizing steps, emailed Foxboron
  - Foxboron: Announcement, test suite, finalize ansible details.
    - https://molecule.readthedocs.io/en/latest/

## Decisions

  - None

## Next steps

  - foxboron: check if any ansible things need to be updated after nisse's
    get-opt MRs
  - foxboron: announcement, ansible tests, Linux bootstrapping
  - nisse: drop cosignatures before release so that the old thing is not being
    used, put in announcement that this will be added back properly in an
    upcoming release
  - nisse: tooling milestone, feedback on proposals
  - nisse: docs for policy format + the open TODOs regarding that
  - filippo: reach out to Trillian folks?
    - yes, good to let them know where we're at wrt. compatibility
  - filippo: will be at RWC/HACS, anything to discuss?
  - ln5: document checker setup
  - rgdd: enagge in open proposal discissuions, feedback on announcement text

## Other

  - question: Rename sigsum-log, e.g., to sigsum-submit? Since in our context,
    "log" is usually a noun, using it as a verb may be confusing.
    - ln5: +1
    - rgdd: +1
  - Discuss and provide feedback to the ongoing witnessing proposal
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/30
    - Pseudodecision to write up and propose: drop SSH prefix from (co)cosigned
      tree head, line-terminated encoding for backwards-compatibility.  Sigsum
      specs will not have extensibility / use the optional lines.
