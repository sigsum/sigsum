# Sigsum weekly

- Date: 2024-12-10 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- elias
- rgdd
- ln5
- nisse
- filippo

## Status round

- nisse: not that much to report today, did a v2 for sigsum proof format ~a week
  ago or so (dropping the short checksum)
- nisse: started looking at integrating sigsum in ST in a crude way, keeping as
  many things as possible the same. It's about doing OS package signatures with
  sigsum
  - There's a link in the other section
- rgdd: appened comments/feedback to the shared configuration notes
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/93
- rgdd: and wrapped up where i'm at with more notes here (not in as good shape
  as i would have liked, but didn't feel productive to continue polishing this
  more):
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2024-12-10-notes-on-log-to-witness-config-request.md?ref_type=heads
- elias: wrote seasalp monitoring proposal, see below under Decisions
- filippo: back from vaccay, catching up with litewitness/litebastion issues.
  Started planning a bit of productizning changes for these components. At least
  better visibility and debug tools, have an idea how i want it to look like.
  Also had the usual chats with trustfab folks. Talking about sandwiches.
  Thinking about how to implement, keep the map in memory, and so on. Also had a
  chat with M, intersection of transparency and go things. Will probably put
  togfether a list of things he could work on (including silent monitoring mode
  for go checksumdb, inspired by silentct.)
- ln5: nothing to report

## Decisions

- Decision: implement seasalp monitoring system
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/95
  - filippo: there's been a general conversation of heartbeatr submissions (e.g.
    ct ecosystem). e.g. google has a monitoring root in every ct log. but nobody
    else does. have wanted to start ac onversation of maybe we should have root
    struture where monitors can mint a cert etc etc. SImilar conversation in go:
    how often is a heartbeat acceptable. E.g., 1s too much but; but ~3h sounds
    reasonable. Useful thing to think about; this is only run by the operator of
    the log, right?
    - nothing stops anyone outside setting it up ("we can't stop them")
    - but rate limits would prevent that
    - so intention: yes, this is something that the log operator wants to run
      for their own log
    - and others that operate their own logs: could use the same tools *for
      their logs*
  - nisse: makes sense, filippo +1
  - nisse: some details, but think it can be sorted out in MRs
  - rgdd: sounds good to me as well
  - ln5: +1, the right level of complexity and as long as we're aware of feature
    creep we can make it happen within 2 weeks. And then build on it afterwards.

## Next steps

- elias: seasalp monitoring (based on the above proposal), so move into the
  practical side of now getting it done
- elias: also planning to do some development, but don't know exatly what yes
- rgdd: work on glasklar's "about page", both for log and witness
  - It would be nice if trustfabric also started working on an about page for
    their AW witness, so we can learn from each other and then probably write
    down a guideline of what a good page looks like (with pointers to our pages
    as examples/inspiration)
  - Maybe the "guideline" is just a template for filling out some headers, and
    looking at how a few others that filled out the same thing -> good enough
  - rgdd will shoot an email to al
- rgdd: shoot an email to tracy regarding the slack bridge
- filippo: litetlog productioninz work; and restoring milan witness. Which went
  down when the motherboard of the machine died. Would like to add a live
  dashboard / live debug log. I think that would have been usedful to you
  (looked at the debug session).

## Other

- nisse: In the context of ST, wrote up some ideas on how to do transparent
  certificates with sigsum (i.e., indirection from configured root keys to the
  trusted submitter keys), see:
  - https://git.glasklar.is/system-transparency/project/documentation/-/merge_requests/64/diffs#diff-content-e0a952af438c582a375eea119f0fb4ae3b4db4c8
- filippo: sandwich hackathon
  - what filippo calls "Log-backed maps", where specifically the map is a map of
    keys (arbitrary keys) to log entries (index). So a map for sigsum: a map
    from public key hashes to entries in the log that match that public key
    hash. I call it a sandwich because:
    - input log (sigsum)
    - map (e.g. key hash to entry in input log)
    - output log: where you put the tree heads for that map, so you can be
      accountable to how you generated hte map
    - clients can now take for granted that they see all the entries in the map
      and/or the latest value
    - so this is about: not having to download millions and millions of entries
      to get your entries out
    - this applies to all deployed log ecosystems so far
    - in gochecksum database: key would be module name
    - in ct: keys would be the sans on the certificate
    - in sigsum: the key hash
    - so sandwich: because it is a map sandwich. Map is the filling, and log is
      on both sides of it.
  - note: this doesn't exist yet, multiple folks have been thinking of log
    backed maps for way longer than filippo have. The one thing that might be
    new: instead of arbitrary ecosystem things in entries, then the entries are
    just append-only lists of indexes in the input log. And sandwich has some
    opinion on how the scale is handled. Anywhere where a log makes sense ->
    then sandwich makes sense.
  - when chatting with martin: maybe we should just build a prototype? Not
    necessarily the thing that becomes the real thing. But as a prototype.
  - would anyone like to join and spend a couple of days on it?
  - nisse: in context of sigsum: can the same log be used for both edges of the
    sandwich.
  - Either the map or the log is out of sync then, don't reach a steady state.
    But you anyway need a recency window. So it's probably fine.
  - location? remote
  - when in calendar? oppurtunstic
  - maybe martin will have availability next week, maybe not
  - also doesn't have to be syncronous, e.g. at the end of the day: someone can
    look at what was done so far
  - rgdd: would be happy to contribute with "end of day" thoughts at least
  - ln5: would love to listen in and contribute a bit, e.g., put an hour after
    this weekly for those that want to spend 30m on it. Either way: fun and
    interesting.
  - conclusion: let's try the opportunistic approach, filippo will keep us in
    touch regarding this
