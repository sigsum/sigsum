# Sigsum weekly

- Date: 2025-09-09 1215 UTC
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
- linus
- gregoire
- nisse

## Status round

- nisse: Started on a Sigsum C library.
  - See https://git.glasklar.is/nisse/sigsum-c
- nisse: I now have two tkey castor prototypes. Toolchain working, I've rebuilt
  a signer app, using clang-16, and hacked tkey-ssh-agent to use my version, and
  it seems to work.
- nisse: thinking about a few other topics we can talk about in the other
  section if there's time
- elias: prepared new VM to which nisse can migrate the test witness
- elias, nisse: discussed witness configuration with rgdd
- rgdd: TDS accepting/rejecting talks + schedule sequencing w/ martin
- rgdd: mailing with Al about wintess configuration
- ln5: verification of yubikey functionality
  - both for witnesses and logs, so we have better chance at understanding if
    any of our devices break in between; and this is of course mostly for the
    secondary nodes of sigsum logs where they have the yubikey and they're
    waiting for the primary to break so they can be failed over to. Want to know
    if yubikey works too. Same goes for the hsm's (our current setup). Checking
    verification of our HSMs, did they break etc.
- key conversation topic in the matrix room (hex to pem), to be continued
- filippo: not that much, first conference and then a bit of vaccay. Been
  chatting about witnesses in the CT ecosystem. Tesera has witness suport as a
  log, which puts it ahead of sunlight (fantastic). So sunlight will be catching
  up.
- filippo: Right now google publishes list of STHs it observes from CT logs, so
  monitors now they can be sure they are on the same tree as chrome's SCT
  auditor (the k-anonymity sampling thing).
  - filippo is suggesting an endpoint that returns a checkpoint with a witness
    cosignature, so monitors can start thinking about getting cosignatures
    rather than special STH feeds. Incremental step towards brining CT into the
    status quo.
- filippo: bit of web pki stuff, dropped some data on pre-cert signing data.
  Which would be nice to remove.
- filippo: been thinking about archiving on logs
  - perhaps other section topic!
- gregoire: we're working on having a production log at mullvad, we have hw and
  most of the things we need but have a small problem with hsm and need to wait
  for some ppl to come back before we can fix it. In mean time, thinking about
  doing some benchmaking and then see how much perf we can handle.
- gregoire: have a question about a different way to do failover
  - let's take it in the other section

## Decisions

- None

## Next steps

- rgdd: more TDS scheduling things and meets
- rgdd: trying to find a high-bandwidth slot to sync with Al
- rgdd: page in the latest stuff in ietf wrt. merkle tree certificates
- rgdd: read leaf context by nisse (link below)
- rgdd: input on nisse's issue in other sect
- nisse: migrate test witness to the VM
  - not sure when it will be done but keeping this in mind, maybe this week
- nisse: will fix spec bug (see other sect), want feedback on issue
- nisse: main thing - tkey stuff and sigsum-c
- elias: start impl named policy
- filippo: finalize vkey PR
- filippo: config format tessera uses for configuring witnesses, which filippo
  is told is the sigsum policy format. Maybe it can be adopted in sunlight as
  well.
  - nisse: i don't actually think that's a great way to configure a log
  - filippo: ok, then i should form an opinion about it
  - nisse: log needs to know keys and possibly names of witnesses, but doesn't
    care about quorum and such
  - filippo: but it can't publish checkpoint before its useful for clients
  - nisse: ah, if you want that kind of policy then the policy file makes sense
  - nisse: but when you do a "collect for 10s and restart" -> then it's not
    necessary
  - filippo: for failed closed, you kinda do want to think about the quorum;
    because publishing a tree head without quorum is like not publishing at all
  - elias: that's the responsibility of the submitter, i.e., you will not
    consider submit done until you have a checkpoint that satisify your policy
  - filippo: but its possible it will never show witness cosigs i need, no?
  - nisse: makes sense for the log to make a best effort to get cosignatures,
    but there's more than one possible policy in sigsum
  - filippo: imagine tree head that makes it every second, not every 10s. And a
    witness required by policy has latency 2s. If the log doesn't slow down,
    because it nows the quorum policy, the system just goes down.
  - nisse: i'm a bit sceptical even in the low latency case \[rgdd missed some
    details\].
- filippo: log list format, take a look. And named policy format.
  - will batch these document reviews into one item
- filippo: read email with possible todos rgdd sent before filippo went to the
  US

## Other

- failover question
  - slight problem is: want to run secondary log in location B and primary in
    location A. Sending HSM to secondary is annoying. Maybe we don't need to?
    Because its not used as long as its the secondary log. But problem: if we
    lose primary, we can't promote secondary to new primary, what we want to do
    is setup a new primary in location A and still use the location B as the
    secondary.
  - we understand its not the failover procedure you tested, and we need to do
    that ourselves.
  - but i want to check if it's a problem, are there concerns?
  - nisse: attack, someone takes down your primary. Since you intentionally
    don't have a strong key sec. at secondary, attacker gets access to secondary
    and modifies tree there. And then ....new primary syncs up a split view
  - rgdd: if attacker have access to secondary we lost anyway in our threat
    model
  - nisse: ah yes, and also no easy way to detect the compromise of the
    secondary; so would be a case of having support for >1 secondary?
  - gregoire: >1 secondary then can do a failover much faster
  - nisse: a bit unclear how the procedure would be to transfer data from
    secondary to new primary, that's a new flow we haven't tested / supported
  - gregoire: one thing we want to try, we use postgres as database. We just
    want to dump the database, put it on the new server. And it should work,
    right?
  - gregoire: other way - could setup the secondary and somehow tell it (there's
    an sth bootstrap file); and then say something like restore towards this
    secondary and sth file.
  - nisse: it would be easier if you configure the secondary in a state where it
    doesn't accept new items but it published the old tree with the signed tree
    head with its own key. And then you can configure the new serrver to be a
    secondary of that one. When it has all the data, it is promoted.
  - gregoire: was looking at the spec for witness protocol, and there is a todo
    about a way for the monitor to get cosignatures? maybe this is useful to
    restore a log?
  - rgdd: how about mirror spec?
  - filippo: it's a push based
  - filippo: but could make sense to check what witnesses have seen for your log
    when you're failovering
  - ln5: i'd prefer doing the replication on the app layer, the patch for log-go
    would likely be small and not a lot of work. And would probalby be the least
    complicated and most likely to get correctness
  - elias: given software as it is, where there's a primary and secondary and
    how things work. It's very close to possible by doing what you want. I.e.,
    primary disappears. Now there's only secondary. You say you don't want to
    make that primary. Then what if you make it primary for a short while to do
    the sync. So it's like a primary, but it can't take submissions because it
    can't make signatures. But it has the data. Then you create your new
    primary. At this moment it is a secondary, and it will get the data from the
    primary (that is only temporary a primary; and its not really a primary
    because it can't sign). Then when you have all the data, you make the
    promotions.
  - gregoire: that makes sense, but would need to try
  - what would be most helpful for gregoire?
  - temporary promoting secondary to primary and see if that works, could be a
    good solution for using sigsum as it is now
  - elias and gregoire will continue this conversation

### Deferred

- nisse: Wrote up notes on adding sigsum leaf context.
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2025-09-03-leaf-context-for-sigsum-v2.md
  - I see one possible and backwards compatible alternative: Make both signed
    blob and keyhash include the context provided by submitter, but without the
    log storing or publishing the context itself. That makes the context even
    more of a salt attached to the pubkey. We'd need a new variant of the
    add-leaf endpoint, but other users wouldn't need to know.
- elias: add functionality for more format conversions in sigsum-key?
  - might be useful here
    https://git.glasklar.is/sigsum/core/key-mgmt/-/blob/main/docs/quick-start.md?ref_type=heads#generate-keys-and-create-initial-backup
- nisse: Spotted doc bug, sigsum-proof.md specifies a field "tree_size=...", but
  it's only "size=...", to be consistent with output from get-tree-head.
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/135
- nisse: Thinking about a "compiled" sigsum policy
- filippo: capture log to cold storage? archiving logs?
