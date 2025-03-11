# Sigsum weekly

  - Date: 2025-03-11 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: nisse
  - Secretary: elias

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
  - nisse
  - ln5

## Status round

  - rgdd: wrapped up sigsum-go v0.11.0
    - fixed sigsum-token crash when passing --verbose
    - smallish MR with minor improvements in docs/tools.md
    - releng (news-file entry)
    - created and pushed tag
    - closed https://git.glasklar.is/groups/sigsum/-/milestones/19
    - if anyone wants to look, it's available now
  - rgdd, nisse: more emailing with jas on sigsum-general
    - one highlight: https://gitlab.com/debdistutils/sigsum-artifact-reproducer
    - some other broader conversation on
      - possible rate limiting improvements
      - alternative rate limit mechanisms
      - sigsum-submit improvement ideas, ranges from conventions of where/how to upload data to not proceeding with logging unless the data is already published (to reduce the risk of a "hidden release")
      - see sigsum-general mailing list for more details about the above
  - elias: working on "Ansible v1.3.0" milestone, making progress
    - https://git.glasklar.is/groups/sigsum/-/milestones/20
  - filippo: litetlog development
    - looked at the PR from nisse and why a test does not pass
    - realized that simply using a mutex is probably okay
    - tried to write a test to reproduce the issue but failed to reproduce
    - working on regx-fix regarding /logz to remove ip addresses
    - should have litetlog 0.4.3 out today probably
      - elias will try 0.4.3 when it's available

## Decisions

  - None

## Next steps

  - rgdd/filippo: check if sigsum and tdev slack bridge recovered, or if messages are still not relayed from slack -> matrix as reported by kfs last week
    - for the IRC<-->matrix bridge it happens that there is a problem but then it starts to work again after a while
    - is it like that also for the Slack<-->matrix bridge?
    - rgdd will check
  - rgdd: join the conversation at https://github.com/C2SP/C2SP/issues/115
    - Fredrik was mentioning this
  - rgdd: catch up on the latest messages on sigsum-general
  - rgdd: send release announcement email about sigsum-go
  - ln5: look harder at litewitness /logz (backlogged)
  - elias: try litetlog 0.4.3 when it's available
  - elias: more work on "Ansible v1.3.0" milestone
  - filippo: pushing 0.4.3 today
  - filippo: trust policies
    - catch up on where progress and conversations are at
    - rgdd: named policy is one thing we are considering
    - nisse: happy to add a named policy for a test log soon
    - rgdd: happy to discuss trust policy things more with filippo
  - nisse: consider creating a sigsum poster? (see below)
  - nisse: file an issue about signing metadata

## Other

  - elias: litewitness: Support adding non-sigsum logs
    - https://git.glasklar.is/sigsum/admin/ansible/-/issues/50
    - https://github.com/FiloSottile/litetlog/issues/28
    - the go.sum database tree just is one example
    - there are also other logs that have fixed there origin line
    - which non-sigsum-log do we expect to be the first to support witnessing?
      - the armored-witness one?
      - maybe later the go.sum database could do it, but probably not right now
  - nisse: Participate at https://cysep.conf.kth.se/, with a sigsum poster/demo?
    - seems like various professors are invited to do lectures
    - going there for a week does not make much sense for us, but maybe shorter
    - maybe a talk or a poster
    - got a reply that a poster is possible, no answer about a possible talk
    - rgdd: having a sigsum poster might be nice, can be useful also in other contexts
    - rgdd: it could be good if 2 people could go and present a poster there
    - nisse: I can look at creating a sigsum poster
    - elias: maybe I could go there also
  - nisse: bundle proof and "claim"?
    - from the discussion with Simon: https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-general@lists.sigsum.org/thread/I465MH46WGSGNKOFDSUZM5T3SLRG2IC7/
    - one case is a person who uses the same signing key for a lot of different articacts, then it gets difficult to know what is relevant to monitor
    - a monitor can monitor a log and get all the claims that should be public
    - the claims then need to be public
    - a verifier then needs the claims?
    - rgdd: if you use the same key for many things, then specify
    - filippo: sigsum is a way to multiplex multiple logs in a single log
      - it would be possible to allow the same key to be used for multiple things
      - but maybe better to suggest that the person uses different keys?
    - nisse: seems good to focus more on claims, making claims more explicit
    - rgdd: the claim Simon has is "I am building things reproducibly"
    - rgdd: what you need is to configure the monitor with the relevand urls?
    - filippo: you want to only accept things from the right place?
    - filippo: you could imagine a Windows binary that builds reproducibly and which is fine for Windows, but when run on Linux it is some backdoored thing. Then it would be bad if you could trick someone into running the Windows binary on Linux.
    - filippo: we kind of lack a way to claim metadata
    - rgdd: in that case you would have to sign the metadata as nisse said
    - filippo: yes, maybe we should have some simple format for that
    - rgdd: just something line-terminated would be nice.
