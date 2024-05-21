# Sigsum weekly

    - Date: 2024-05-21 1215 UTC
    - Meet: https://meet.sigsum.org/sigsum
    - Chair: nisse

## Agenda

    - Hello
    - Status round
    - Decisions
    - Next steps
    - Other (after the meet if time permits)

## Hello

    - nisse
    - filippo

## Status round

    - nisse:
      - Started to look at bastion support, see https://git.glasklar.is/sigsum/core/log-go/-/issues/70 and https://github.com/C2SP/C2SP/issues/71.
          - single binary or separate from log
            - reasons for bundling were encouraging running bastions, and reusing port 443 on a single IP
            - decide with rgdd
          - explicit witness URL for bastions or composing from key hash
            - advantages of explicit URLs: flexibility around using other bastions, not hardcoding witness key to bastion key hash mapping
          - error status codes
            - update spec with SHOULD send a different code for unknown witnesses if possible (not possible if CA auth is used)
      - WIP key-mgmt/ssh package, see https://git.glasklar.is/sigsum/core/key-mgmt/-/merge_requests/12 and https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/180
      - Started work on more efficient batch submit, see
https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/60
    - filippo: Merged bastion spec
       https://github.com/C2SP/C2SP/pull/56
    - filippo: shared tiles spec with TF

## Decisions

    - Decided: Cancel next week's meeting, due to Stockholm meetup + vacations

## Next steps

    - filippo: update bastion spec for error codes
    - nisse: update calendar

## Other

    - None
