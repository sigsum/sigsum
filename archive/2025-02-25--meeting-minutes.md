# Sigsum weekly

- Date: 2025-02-25 1215 UTC
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
- elias
- filippo
- cc

## Status round

- rgdd: ensuring we get the minor feature requests and fixes milestone done
  - https://git.glasklar.is/groups/sigsum/-/milestones/19#tab-issues
  - sigsum-go now has man page generation with help2man and pandoc
    - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/228
  - follow-up MR that also improves usages messages (and so also man pages)
    - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/229
  - more efficient batch submit in sigsum-submit
    - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/227
    - should also be a good enough context error / timeout fix (long timeout)
  - looked at TX rollback error and escalated to martin who provided a fix
    - https://git.glasklar.is/sigsum/core/log-go/-/issues/98
    - https://github.com/google/trillian/issues/3734
    - thanks elias for helping with testing
      - elias: confirmed now that the "TX rollback error" did not happen since
        the change on feb 20
  - got help from elias to look at the yubishm-connector restart and talked
    about it with nisse last week in person
    - https://git.glasklar.is/groups/sigsum/-/milestones/19#tab-issues
    - working theory that has not been confirmed by looking more at code
      - our systemd stuff makes this a non-problem, restarts everything when
        needed
      - something in our sigsum-agent makes us exit when we probably shouldn't
      - and then primary is killed by systemd because agent is gone?
      - primary doesn't have any reconnect though if the socket disappears, it's
        a once at startup thing though. So that would also need fixing, not just
        sigsum-agent.
      - but tl;dr: we don't have to do anything right now, but let's make sure
        we have the appropriate issues so that this can be improved in the
        future
  - most of the above is now blocked on nisse not being here this week
    (review/merge)
- rgdd: emailing with jas on sigsum-general, one of his goals seems to be:
  - jas: I'd like to establish a "best practice" on how to Sigsum-protect
    software source code releases, for other maintainers to follow.
  - worth nothing that "generate new proofs" is not an option for his announce
    flow (mailing list)
  - better primer pages than broad getting-started and something that makes it
    easier to manage trust policy -> (still) looks like the two main painpoints
  - https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-general@lists.sigsum.org/thread/Z6KHDHDMF3Z42TID7OOPNYNJRXYBX7YL/
- elias: seasalp incident info was added
  - https://git.glasklar.is/glasklar/services/sigsum-logs/-/blob/main/timelines/seasalp.md
- filippo: good chats with TF, again aligning on the mental model of sigsum. A
  divergence: there's the claimant model, but they also think about self
  monitors. And you start thinking of signatures transparency as a thing in
  itself, rather than logging something else. Took two rounds, but I think we
  got it to click.
- filippo: some sunlight work, static-ct api v1. Now v1 is done!
  - https://c2sp.org/static-ct-api
  - capped size of levels
  - might be adding some lang (SHOULD) wrt. partial tiles, i.e., language we
    already have in tlog-tiles
    - https://c2sp.org/tlog-tiles
  - rgdd: would be nice with mirrors for all rfc 6962 logs to facilitate
    transition to tiles
    - filippo: please say it on the ct list, will be helpful
- filippo: go 1.24, almost done now!

## Decisions

- None

## Next steps

- filippo: still the same as last meet
  - merging the fix to litetlog for the sqlite concurrency issue
  - trust policies tooling, age prototype
  - ip address stripping in /logz
- rgdd: public witness network chat with TF today
- rgdd: ensure we have appropriate issues for yubihsm-connector restart $things,
  then close the issue that raised the question
- elias: work on Ansible v1.3.0 milestone
  - https://git.glasklar.is/groups/sigsum/-/milestones/20

## Other

- fyi: tdev community meet minutes from yesterday
  - https://docs.google.com/document/d/1cQop8_p7-fV5CEO5ADyvLrDGDm8BR79MytMqc0MeAeY/edit?tab=t.0
- elias: what should seasalp timeline look like?
  - https://git.glasklar.is/glasklar/services/sigsum-logs/-/blob/main/timelines/seasalp.md
  - see discussion in
    - https://git.glasklar.is/glasklar/services/sigsum-logs/-/merge_requests/3
  - a remaining question: what should it really look like in the right most
    column? It's called links. In this case it's two issues.
  - right now the way it looks: "issue issue"
  - it's just a cosmetic thing
  - anyone has ideas / suggqestions?
  - issue-1, issue-2? and then next time 1 and 2 again?
  - also just misc#54 looked good
  - elias will fix something based on the above so it's not "issue issue"
- elias: add another checker check doing test submission to seasalp with a
  policy specifically using Glasklar witness?
  - we're currently doing test submission, once every hour. One with policy
    without any witnesses. And another one that requires 8/15 armored witnesses.
  - now elias idea is: we could add a third submission that could specifically
    require only the glasklar witness (because it's ours)
  - rgdd: sounds great to me
  - it's completely different submissions, happens a few seconds after one
    another
  - rgdd: note one submission is sufficient, then multiple sigsum-verify with
    different policies
  - to begin with because it's so easy: to it in the quickest way
  - rgdd: aren't we already getting checker emails for witness.glasklar.is
    though? I recall seeing that yesterday.
  - we currently have two jobs in checker -- one is witness checker and one is
    submission checker. In witness checker we already have a check on glasklar
    witness. But submission checker doesn't have that.
  - why do we need both?
  - conclusion: we don't, let's keep as is for now which seems good enough
