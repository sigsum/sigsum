# Sigsum weekly

- Date: 2025-04-01 1215 UTC
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
- nisse
- filippo

## Status round

- elias: cannot join meeting, vacation on 2025-04-01
- elias: log-go v0.15.2 with rate-limiting fix deployed to seasalp
  - https://git.glasklar.is/sigsum/core/log-go/-/issues/109
- rgdd: fyi: will be program chairing tdev summit together with martin, starting
  to bootstrap things around this today / this week
- rgdd: fyi: guest lecture on CA/CT/Sigsum on thursday
  - slides will appear at https://git.glasklar.is/rgdd/yh-25
  - will likely be based on:
    - https://git.glasklar.is/rgdd/yh-24
    - https://git.glasklar.is/rgdd/kau-24
- rgdd: synced with patrick, seems like TF will have cycles to review and help
  polish a stab at shared configuration / public witness network next quarter;
  it is helpful if we get started since we're already very aligned since before.
  - rgdd is thinking it would make sense to have something concrete before we
    renew sigsum's roadmap towards the end of may
- rgdd: synced a bit with nisse wrt. ongoing ST work that overlaps with Sigsum;
  one outcome of this sync is that i'll be fixing cosignature verification in
  sigsum-monitor and ensure there's a non-continuous run-mode sometime later
  this month.
- nisse: Working on support for sigsum verification in stboot
- nisse: Made a draft MR on how to add a first builtin test policy to sigsum
  tools
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/248
- nisse: Released a new version of log-go. Includes Elias' rate limit fix, and
  improvement to how witness problems are logged.
  - https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-announce@lists.sigsum.org/thread/ZWAN77U6UTQOKR5GPSL2IF5MLVO3BJKH/
- filippo: mostly RWC. Bunch of conversations, people are interested in tlogs.
  Talked a bit abouit self enrolling with M. Think it could be a separate API,
  could slot well with current witness deisgn. Witnesses can chose to implement
  it or not.
  - idea: send signed note with logs and vkeys
  - then the log goes out to the domain /.well-known for enrollment; if the key
    that signed the note is there -> that's how authorize and anti-spam. Now
    it's bound to a domain.
- filippo: got rerewned commitment from $someone to run a witness
- filippo: talked a bit about how pypi can do tlog and use witnessing
- filippo: found another group that want to do webapp transparency, trying to
  get people in the same space to talk to each other
- filippo: talking to people who wanted entrypoint for "how to do tlogs"
- filippo: cloudflare had a talk to do auditing (meaning both witnessing and
  monitoring) key transparency product of whatsapp. Talked to baz how to
  separate witnessing and auditing. Witnessing have to be cheap -- was a good
  conversation to explain this part.
  - "plexi"
- filippo: got some questions about spicy signatures, apparently the name stuck
  but when you search on the internet there's nothing
- filippo: eidas person asked about how to structure logs and so on,
  specifically for relying party certificates (not identidies like driver
  licences, but certs for ppl that can check your driver license. E.g., bank
  could have a cert that authoritized them to ask for your driver license.
  Having transparency for these certs = something that's a priority. Law says
  you have to do things in terms of privacy that's impossible with what's been
  standardized.)
- filippo: talked about mozilla revocation stuff and how it might be used for
  sct auditing. But that would be a usecase for a tlog -- put revocation updates
  in. E.g., every day 50 kib updates for the matrix.
- filippo: there's interest in the vkey spec
  - on me [filippo] that it doesn't exist yet
- filippo: people kept asking about spicy signatures..
- filippo: verifiable index structure, one nit / improvement idea (?).
  Verifiable index gives you a list of indices in the origin log. But, inclusion
  proof is not designed to prove that something is at a specific index. For
  example, two subtrees that are identical. tHEY SIT next to each other.
  Inclusion proof for the subtrees are identical. That's not a problerm because
  entries are identical. But is that the only scenario?
  - nisse: would help if you rule out duplicate leaves
  - rgdd -- explains for a bit and is not worried about this issue, i.e.,
    inclusion proof does prove that somethign is on a particular index; assuming
    you have a root hash + size of tree -> then this is locked down. Also have
    domain separation between interior nodes and leaf nodes.
  - filippo: ah so it's because when you recompute root hash you do it based on
    the index and size you expect?
  - yes

## Decisions

- None

## Next steps

- rgdd: prep/refresh for thursday's guest lecture
- rgdd: tdev program chairing things with martin
- rgdd: poke kfs about moving shared configuration / public witness forward
  - already had a reminder in my calendar for checking in on this yesterday
  - then later ~this month get something concrete done w/ filippo
- filippo: think putting some order in my notes from rwc; sending some pointers
  to people that asked for them. Then still need to figure out truncated IP
  addresses (i'm actually not seeing it -- might need to take it apart more
  srsly. Two different logging libraries interacting and none should be
  truncating. Will be hunting for this).
- filippo: have been asked about sunlight client library, will be publishing it
  because it's finnish on my disk. Will push.

## Other

- None
