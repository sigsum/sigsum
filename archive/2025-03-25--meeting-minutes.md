# Sigsum weekly

- Date: 2025-03-25 1215 UTC
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
- nisse

## Status round

- rgdd, patrick: trying to fix slack bridge but with no luck so far. We emailed
  matrix.org's support, which they suggested to someone with a
  [similar issue](https://github.com/matrix-org/matrix-appservice-slack/issues/749).
- rgdd, patrick: we heard back from the matrix folks, tl;dr: seems rough right
  now
- rgdd: paged in <https://github.com/C2SP/C2SP/issues/115>, will click send on a
  typed up response to keep that discussion going right after this meeting
  - about the "list of logs" idea
  - post-meet post:
    - https://github.com/C2SP/C2SP/issues/115#issuecomment-2751285423
- elias: rate-limiting fix merged
  - https://git.glasklar.is/sigsum/core/log-go/-/merge_requests/189
  - want new log-go release with that fix?
    - yes
- nisse: Updated log-go dependencies.
- nisse: NEWS update
  - https://git.glasklar.is/sigsum/core/log-go/-/merge_requests/194
- nisse: emailed cc regarding matrix-slack bridge to see if he can dig wrt.
  bridge options
  - rgdd: let's together make sure that we make an explicit decision on either
    dropping or finding options in 1-2 weeks from now. I won't do anything right
    now while we wait for a response from cc, we can also check more with kfs
    next week.

## Decisions

- None

## Next steps

- elias: work on Ansible v1.3.0 milestone
  - https://git.glasklar.is/groups/sigsum/-/milestones/20
- elias: when new log-go release is available, deploy that to seasalp
- nisse: Make log-go release, v0.15.x.
- rgdd: possibly followup sigsum-general mailing list discussion
  - will check if there is something there I should respond to, perhaps Giulio

## Other

- elias: for log-go rate-limiting, allow adding rate-limit token pubkey
  explicitly in log config (as alternative to getting it from DNS)? That would
  make it easier to test the rate-limiting functionality.
  - Related to https://git.glasklar.is/sigsum/core/log-go/-/issues/109
  - aha! already exists, see
    https://git.glasklar.is/sigsum/admin/ansible/-/blob/main/roles/sigsum/defaults/main.yml?ref_type=heads#L51

### Response regarding matrix-slack bridge

> Hi,
>
> Unfortunately, the bridges are not really maintained at the moment as we do
> not have the resources to keep them running. And unless we can secure $100,000
> of funding by the end of March the brides will be turned off completely. See
> [2]https://matrix.org/blog/2025/02/crossroads/#doing-less-to-do-better for
> more information.
