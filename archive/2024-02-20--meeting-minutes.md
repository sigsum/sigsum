# Sigsum weekly

- Date: 2024-02-20 1215 UTC
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
- gregoire
- ln5

## Status round

- None

## Decisions

- None

## Next steps

- rgdd: virtual walk/sync with filippo
- rgdd: still try to find the time to give feedback to use-case things that
  gregoire is doing
- ln5: will continue the agent things -- there is a sane default thing which
  linus would like to deploy in our ansible scripts. Which is always running it
  with a soft key (under a separate user). This gives separation between reading
  key material and the internet-connected service. So compromised user that runs
  the log service -> can use signing oracle, but not read the private key. So
  this was an interesting configuration space that is being explored now. Then
  next step is use yubihsm agent.
- nisse: still discussing sigsum use with the sunet people
- nisse: summarize the conversation with jas about policy in an issue somewhere

## Other

- gregoire -- related to the conversation in matrix. Have been using the same
  policy format for the sigsum policy, expect that the signing key (i.e.,
  use-case signing key) is in it. And then realized it is not in the policy.md
  spec. The conversation seems to assume it is not in there.
  - nisse: maybe there is an issue about that already?
  - nisse: might make sense to have submission key together with some kind of id
    that says application or purpose; and would make sense if you can use the
    same file on verifiers and monitors.
- gregoire -- recommended timings for submitting to a log? add-leaf and
  get-tree-head, how long should i wait?
  - e.g., how long to wait after HTTP 202 before trying again to see if the
    response is HTTP 200
  - nisse: a few seconds, maybe some exponential increase; peek at the sigsum
    submit tool and see what it used
  - note: the tree head is rotated peridiocally (~10s), and then you're waiting
    for cosignatures. So when waiting here, you are both waiting for cosigning
    to happen, and as a user need to ensure you got the cosignatures you wanted
    (and otherwise wait more).
