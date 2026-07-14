# Sigsum weekly

  - Date: 2026-07-14 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: rgdd
  - Secretary: mw

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - mw
  - rgdd
  - gregoire
  - warpfork
  - patrick
  - Justin Cappos

## Status round

  - rgdd: glasklar has been working on witness deployment, it's up and
    running, some cleanup left.
  - rgdd: witness network stuff, requirements for ml-dsa in witnesses coming,
    at some point "soon" all new witnesses will be required to support this
    alongside ed25519. Witnesses already in the network might get some slack
    during a transition period.
  - gregoire: the witness spec has sub-tree signing now, will that be required
    from now on?
          - rgdd: not as of now
  - filippo: [tlog mirror](https://navigli.sunlight.geomys.org/) is a thing!
    https://groups.google.com/a/chromium.org/g/mtcs/c/pn-h-vY9JhE
	  - a few changes was made to tlog mirror and tlog witness when
	    implementing this, refinements mostly.
	  - using a loglist hosted on github for this. One thing we don't have
	    a standard way to know what is accepted by a log and/or a mirror.
	  - got question if we could use the loglist for reading the
	    configuration.
	  - key rotation has not been discussed yet for witness network
	  - witnesses only have one v-key, can that be changed?
	  - perspective justifying one v-key: The key is effectively an ACL to
	    be able to ask the witness to issue a cosig for this log.
	    https://github.com/C2SP/C2SP/issues/298
  - rgdd: the main reason we haven't wanted this before is that you could
    discover what key belongs to which log, people automating discovering
    keys, weakens the authentication story.
  - filippo: it's interesting for operators to know if a witness has rotated a
    key so they can decommission the previous one.
  - rgdd: we should also hash out the tombstone thing
  - filippo: I'm worried that witnesses will start building their own infra
    for this.
  - rgdd: there's currently no update mechanism in the spec.
  - filippo: proposed name is known logs, ok?
	  - room: no objections
  - rgdd: DoS signature when asking for a sub-tree to be co-signed, was pulled
    when thought to be redundant, but it's not, so it's coming back. Filippo
    will create an MR to get that added.
  - for stronger authentication with the add-checkpoint endpoint an out of
    band mechanism like a bearer token (or similar) should be used.
  - gregoire: we've updated our log server, it's back up and running.
  - patrick: I've been working with tta on archive transparency, will submit
    a talk to transparency.dev.


## Decisions

  - no decisions

## Next steps

  - mw: mostly working on remainders wrt. witness group deployment at glasklar
  - rgdd: same as mw, away next week for pets.
  - rgdd: talking to Hayden about the leaf format, things are moving forward.
  - filippo: mine are the known logs (^^) and the sigsum tree log signature


## Other

  - warpfork: target of opportunity: would like to compare notes with other
    readers of the Chalmers draft.
  - we spend a lot of time defining the property "append only", and it this
    paper it seems to be rolled together with all other possible rules engines
    about permitting updates, under the "ECO" property.
  - we tend to differentiate this because it's a very minimum bar; everyone can
    agree on what it means; and there's a lot of efficiency optimizations we
    can also agree on.
  - so does it seem reasonable to ask them to split this out of the other
    criteria that can be used?
  - rgdd: what they're doing is that they create a framework, and show you how
    to map this framework onto things. Will it make it easier to understand
    the framework if this is split? If yes, then it should be split, otherwise
    it's not necessary. The authors having defined their own terms has been
    needed for them to describe it in non-confusing ways, without collisions
    and/or simply using the wrong words.
  - warpfork: some unresolved questions in the back of of my head...
  - lawful monitors -- things running a rules engine, an example could be key
    rotation events are only accepted when a previous key signs etc etc...
  - this is something most of our designs talk about as being after-the-fact
    and not blocking log appends (on purpose, so log appends are simple and
    unblockable, and witnesses are standard and nearly resourceless, etc).
  - this paper (by wrapping the concept into ECO) only examines such rules
    engines if they block log advance. This is fine, but doesn't really
    describe the world most of us are building towards right now?
  - unclear to me how much consideration there is right now towards how we
    would actually expect to roll out and use lawful monitors (things that
    *cannot* block log append).
  - Justin: We got sent the paper. We're going thouhgt all of this. I assume
    that if this was written more like a specification, that would also be
    helpful? Or do you prefer to read it in this format?
	  - rgdd: I prefer this format, there's a gap between this paper and
	    the spec, just as there's a gap between the sigsum docs and the
	    spec, but I don't think this paper is the bridge to that gap.
	  - Justin: people from the crypto field describe things differently
	    from the systems-people, I'm trying to understand from your
	    perspective what the preferred way of talking would be.
	  - rgdd: I don't have a concrete answer to "how would you do it with
	    the actual specs".
	  - justin: it's good to know that it's not off-putting to you to have
	    it in that format.
  - Gregoire: what's the status of armory witness?
	  - filippo: daniel is working on building the firmware, it's not
	    ready, we have the usb armory in the rack, can boot it but not
	    ready.
	  - it will be open sourced once we're done with it, but not yet.
	  - Gregoire: benchmarks?
	  - filippo: we don't have our own yet, but what was in the previous
	    ones would be sufficient for
  - rgdd: filippo and I talked about adding ml-dsa support in litewitness and
    sigsum-agent. Targeting the softkey in phase 1 for sigsum-agent.
