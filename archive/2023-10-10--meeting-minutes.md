# Sigsum weekly

- Date: 2023-10-10 1215 UTC
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

- nisse: Editing log-go NEWS and RELEASE files.
- nisse: Setting up a sigsum-py witness at poc.sigsum.org (some questions below)
  - Docs: https://git.glasklar.is/nisse/poc-witness
- rgdd: now running checker on my vps, some notes for the interested
  - https://git.glasklar.is/sigsum/admin/checker/-/blob/sigsum/docs/fun-with-checker.md
- rgdd: talk witness proposal with filippo, summary in MR
  - https://git.glasklar.is/sigsum/admin/checker/-/blob/sigsum/docs/fun-with-checker.md
- rgdd: the usual review and feedback stuff, unfortunately did not have enough
  time to do any more yubihsm tinkering yet.
- rgdd, nisse: drafty proposal on how we do spec releases / what that means
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/51
  - (Would like to move this towards decision next week.)
- filippo: prototyped new witness API, pretty clean to implement
- filippo: discussed witness API proposal with rgdd and updated MR

## Decisions

- Decision: Move forward with new witness.md API direction
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/46

## Next steps

- rgdd: yubihsm tinkering, collect feedback on spec release proposal
- ln5: provide a URL for rgdd to direct his checker peer towards
  - (rgdd re-assigned issue
    https://git.glasklar.is/sigsum/admin/checker/-/issues/6)
- nisse: not so much more sigsum this week, but would like to continue with poc
  witness setup
- filippo: merging proposal, preparing mr for witness.md based on that, and
  implementing for litetlog 

## Other

- sigsum-py witness on poc, questions:
  - log rotation required? Some options:
    1. Do nothing until log gets large.
    2. Use logger(1) to let syslog deal with it.
    3. Use rotatelog
       (https://httpd.apache.org/docs/2.2/programs/rotatelogs.html) + cronjob to
       delete old log files.
    4. Add features to sigsum_witness.py to cooperate with logrotate;
       essentially, open a log file, periodically (or in response to SIGHUP)
       close and reopen. - (Adding things to sigsum_witness.py out of scope
       right now.)
    - Ports to use? By default, opens a metrics server on port 8000, and actual
      witness on port 5000.
      - Monitoring? Can have checker use get-tree-size. Would be pretty to also
        have some metrics "dashboard" with metrics from both log and witness.
        - Yes, give rgdd a url and he will direct his checker instance to do
          this.
        - More monitoring metrics is planned in one of the upcoming "DRAFT: "
          milestones, would be fantastic to make progress on soon. The actual
          rendering of the dashboard would be good to have Linus involved in.
  - (talked briefly about this, but TL;DR: keep it as simple as possible to not
    spend too much time on this now. "Poc". Talk to ln5 regarding opening
    ports.)
