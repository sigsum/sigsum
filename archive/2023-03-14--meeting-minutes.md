# Sigsum weekly

  - Date: 2023-03-14 1215 UTC
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
  - filippo
  - ln5
  - Foxboron
  - nisse

## Status round

  - nisse: Merged docs for sigsum proof format,
    https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/75, merged
    step one of policy implementation,
    https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/71. 
  - nisse: In progress: Sigsum proof type,
    https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/70,
    witnessing,
    https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/72 (witness),
    https://git.glasklar.is/sigsum/core/log-go/-/merge_requests/99 (log server).
  - rgdd: discuss policy and flag packages with nisse
  - foxboron: catch up from last week, check ansible things from linus.
    Thinking about how to reconcile how we do things on poc.sigsum.org vs how
    most log deployments will likely look like.  (So: continued ansible work.)
  - ln5: testing ansible role from foxboron.  The remaining issues might be
    other than the role but simply not "just working" yet with
    primary/secondary.  Issues should be solvable in two weeks, assuming we
    focus on it.
  - ln5: poc log running, but not with secondary

## Decisions

  - None

## Next steps

  - filippo: checkpoint proposal for compatibility / witnessing prototypes; wrt.
    making bastion host into production shape, work with foxboron to get config
    and ansible.
  - nisse: continued work on policy
  - nisse: getopt for log-go-{primary,secondary}. [**EDIT:** added directly
    after meet in discussion with rgdd.]
  - ln5: more log deploying
  - ln5, foxboron: talk about ansible tests / CI
  - foxboron: prep announcement text and wrap up documentation; poke nisse and
    rgdd to take a read and work with linus for review
  - rgdd: provide feedback on a need-basis
  - ln5: poke richard with 2-week announcement heads-up

## Other

  - How to configure log server with a witness list, with pubkey and url for
    each witness? See https://git.glasklar.is/sigsum/core/log-go/-/issues/54
    - option 1: read policy file
    - option 2: multiple witness lines in the toml config, foxboron will provide
      a link and/or follow up async with nisse about this option
  - TLS Merkle Certificates:
    https://www.ietf.org/archive/id/draft-davidben-tls-merkle-tree-certs-00.html
