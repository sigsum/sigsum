# Roadmap and milestone prep

Notes from ad-hoc meet initiated by rgdd.

Warning: drafty notes, you probably want to look at the issues and milestones
created based on these notes instead.  Also, they are mostly focused on nisse's
next steps.

## Hello

  - rgdd
  - nisse

## Agenda

  - nisse provides input on what he think needs to be done right now in Sigsum
  - rgdd shares his thoughts
  - informally agree on what goes into the next milestone(s)

## Running notes

Recall previous roadmap:

  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2023-04-04-roadmap.md

### input from nisse

RE: roadmap overall?
- Witnessing stuff progressed quite far now, next steps there are to get
  go+python witnesses going and tests
- Refactor integration test to actually be an integration test would be good,
  i.e., what we have right now is mostly a bunch of curl and pipes that doesn't
  use the tooling that is now available in sigsum-go
- First draft of monitoring needs another iteration
- Command line tools seem to work pretty well, mainly batch submits that would
  be nice to add but prio for that is a bit unclear

RE: anything to add regarding what needs priority in our code-bases?
- Refator so we have Go interface for "HTTP server stuff"?  See
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/119
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/34
  - One option could be to try this with the witness, but not before filippo has
    a first draft of the Go witnesss
- Integrationtests needs to be re-worked to use our tooling, eventually retire
  the old "integrationtest" and sigsum-debug.  We may still want something
  similiar to "hurl" test vectors though that just tests the log API
- The procedure around log failover and tooling surrounding it needs work
  - rgdd: here also synergi with multiple secondaries and integration tests

Sounds reasonable to start on new integration tests that use our tools, and let
what we have continue to live on until they are done and we have "hurl" test
vectors too?

### notes from rgdd

#### Overview

Wrap up and polish specifications:
- Make a draft of pollished log.md, version 1, that references witness.md for
  the parts relating to witness cosignatures ("cryptographic semantics").
  - Q: structure and content?  We also have design.md, what do we do with it?
    We likely want to retire this document eventually, making log.md standalone
    and dense while also having user/tooling docs as well.  Unclear where to
    move the "why:s" of sigsum, but we don't have to figure that out just yet
    (but not in log.md at least).
  - Nisse would like to take a stab at this with feedback from rgdd/filippo.
- Make a draft of pollished bastion.md, version 1?
- Continue hashing out remaining changes in witness.md (filippo)

A bit all over the place:
- Minimal changes to make python witness compatible with witness.md
  (ongoing@nisse)
- Deploy bastion-go and updated witness (filippo, then deploy by linus)
- Look at (dynamic) configuration of bastion
  - Update witness list
  - Update logging verbosity (althought unsure what logging there is now)
  - defer until we have this working in log-go
- Look at (dynamic) configuration of log-go
  - Update witness list
  - Change logging verbosity
  - Doublecheck with Linus if anything else is essential
  - Nisse will take a stab at this, including considering the options to do so.
    - Some things that affect the design decision include whether it is easier
      (implementation and understanding as a sysadmin) to reload entire config,
      and how that reload is triggered.  E.g., timer, HUP, send to local HTTP
      API.
- Lower latency in log-go for witnessing, how will that be implemented now?
  - currently reach out to witnesses and rotate periodically, defer lower
    latency for now; we can configure this in the order of 10s intervals.

Tooling
- See detailed notes below

Use-case prototyping
- Tillitis, this is essentially a test-run of our sigsum-go tooling/packages
- (Later: well-documented "start to finnish" use-cases.  Eventually we want a
  handful of those, so that our (active) involvement isn't needed.  We will also
  need to dog-food+document use-cases with data storage and claims.)
- (Later: Demo use of witnessed timestamps, will to some extent also plug into
  tooling but it would be a distraction at the time being.)

Misc:
- Support for multiple secondaries would be good to have, after summer?

More later:
- Docs/website, would be a good idea to start an issue to track ideas in though.
- Document how to use our tools with yubikey/tkey ("ssh-agent")

#### Detailed tooling notes

XXX: misc milestone that morten will not complete?

RE: tools
- Nit-pick: long and short options would be very helpful, e.g., `-h` seems to
  not be accepted in most of the tools; `--diagnostics` is long to type, etc.
- nisse: also a bit inconsistent "key", "keyfile"
- The debug diagnostics doesn't seem to add much additional information?  E.g.,
  for sigsum-submit it would be very valuable to say what's happening.  Think
      about what would be helpful debug output in all tools (submit, monitor,
      ...)
- The option of not piping into the tools would likely be helpful, e.g., to have
  a `-m MESSAGE` switch which takes presedence over stdin input
- (Anything to be cleaned-up because it is more or less obsolete?)
- (Is sigsum-key using a different way of printing message for `-h`?)

RE: Submit tooling
- I like that the UX is simple in pkg/submit, "just call this thing and wait"
- Submit >1 leaf at a time
- (Later, we could consider storing of config in ~/.config/sigsum or similar)

RE: Monitor prototype
- I like the interface+callback design, monitor looks pretty neat overall
- Make the demo callbacks persist matching entries and tree head, and then use
  that state to not start monitoring from scratch everytime
  - nisse: add leaf index in callback? yes
  - nisse: lib functions for things like save tree head? yes, neat.
- Incorporate witnessing and alerts based on that, at least:
  - "havn't seen enough cosignatures for quite some time"
  - "freshness"
- It should be "safe" to stop+start without loosing information
- Think about how the log's config may be updated
  - Makes sense to stop+start to add keys
  - (Policy might be something one downloads (signed) in the future? defer)
- docs/monitor.md as part of the next iteration?
- (Improve perf by fetching less inclusion proofs? nisse would like to fix)
- (I'm confused by the "size" print for leaves output, consider dropping this or
  rephrashing with "count", "newly found leaves", or similar)
- (Looks a bit weird to have a sleep loop at the end of cmd/monitor main)

RE: policy
- Figure out how a client that wants to verify packages from 2 years ago would
  do that with the appropriate policy file, since the current trust policy may
  not be the same as the one used two years ago.
  - Option 1: bake this into the policy format somehow
  - Option 2: multiple (timestamped) policy files, select the right one
  - (And maybe more, needs thinking to figure out what is most simple.)
  - <--nisse will start thinking about this
- I think Sigsum should maintain a policy that would be sane for our own usage,
  probably sigsum-signed and made available for download on a fixed URL.  This
  is also a good example application of sigsum that we can document in detail.
  - bootstrap interesting, then basically sigsum-signed updates
  - <-- nisse will start thinking about this as well
- Should there be a default policy in our command-line tools, why (not)?  If
  yes, should it be downloaded dynamically or be hard-coded?  Why?
- (Any more thought on contact information to logs/witnesses in policy file, or
  should we KISS and consider out-of-band conversation?  At some point we talked
  about the name being an email address, but it was removed.  Another take: it
  is trivial to get in touch from now, e.g., send en email to a mailing list.)
  - optional: emails could be names or comment sin file, but let's defer this
    because we're quite happy with the policy format as is
- (Also: I've said it before, but good policy documentation!)

RE: sigsum proof
- Q: if someone wanted, e.g., JSON, to fit into their existing formats, how
  easy/difficult would it be to get this working for them with our tools/pkgs?
  - "yes"

RE: client package (or somewhere else where it is more appropriate)
- Figure out exponential back-off for potential rate-limiting
  - E.g., monitor that fetches to aggresively -> "backoff please"
  - I.e., this is a different type of "rate-limit" than submission
- defer, not that important right now

(Note: I have not done any code review here, just a very quick peek)

### TL;DR

- log.md spec, refactor and polish (nisse)
- continue with witness proposals/spec (filippo w/ input from nisse+rgdd)


- use-cases with tillitis, see what all of us learn from that when trying our
  things
- dynamic updates of log config (nisse)
- tooling ("what we didn't write defer on above", rgdd will clean-up)
- witness (filippo, to some extent nisse)
- metrics for log server (nisse), after that easier to look at Go interface
  changes
- if time permits, integration test improvements, failover, multiple
  secondaries,...

rgdd will persist these drafty notes and then make issues+milestones
