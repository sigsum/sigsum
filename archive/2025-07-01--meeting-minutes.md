# Sigsum weekly

  - Date: 2025-07-01 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: elias
  - Notes: rgdd

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
  - gregoire

## Status round

  - rgdd: paged in photosynthesis, tlog-mirror, and tlog-cosignature v2 ideas
    - photosynthesis a.k.a. merkle tree certificates
    - also looked at tlog-mirror, possibly related to cosignature v2
  - rgdd: put a maintainer's touch on tlog-cosignature v2 to try and unblock
    - input would be much appreaciated
    - https://github.com/C2SP/C2SP/pull/146
    - the difference is that the witness name is signed
    - other than that, cosignature/v1 can still be used for everything needed
    - with cosignature/v1 you just need to use separate keys
  - filippo: implemented witness support for sunlight, staging instance of tuscolo ct log has a witness endpoint! Probably going to change a bit how it works, so def. still a dev witness. Specifically: right now it stores in the checkpoint database just based on the log name, but the checkpoint database is meant to be shared across multiple instances as a safety. (Idea: by mistake move a key from one instance to the other -> saves you from signing a split view on your own tree.) But asides some details, seems to work. Hoping to roll out to production on tuscolo, and it will be the geomys production witness just like we're running a production ct log. Will ask LE to enable it on their instances too.
  - filippo: stewards actions on c2sp, think i got through it. If anyone's waiting on anything from me here i missed it - please let me know. (As maintainer i still have things to tend to here.)
  - filippo: in c2sp.org, now there's a maintainer file that's tracked in git. Shows how the maintainer ship changes over time.
    - markdown file that's updated by a bot; git is not the source of truth, but good enough.
    - https://github.com/C2SP/C2SP/blob/main/.github/MAINTAINERS.md
  - question from elias:
    - time estimate for prod witness at geomys and LE?
    - filippo wants to test and such for at least a week now, also want to share on mailing list to give people a change to call out if we're doing something silly
    - geomys, maybe in a couple of weeks?
    - le - no idea, can't speak for them. But config wise it will be very easy
    - for now logs are configured manually until we have the witness configuration lists, so even if we enable it we can't ask them to go and update the configuration every week
    - game plan - would make sense to have witness configuration network before LE starts
      - question from filippo: is there a good link to use for the list?
        - https://git.glasklar.is/rgdd/witness-configuration-network/
    - elias: amazing milestone to reach the point when there's someone like LE running a witness / others outside of the folks that's been actively developing
  - elias: reminder that weekly meets are cancelled next week and forward, next one is on aug 12

## Decisions

  - None

## Next steps

  - rgdd: vaccation modulo a few virtual walks / tds chairing / other minor things.
  - gregoire: send test log info so elias can configure witness
  - elias: named policy things
    - want to look a bit more at the named policy things, to at least get started on that. Perhaps have something i want feedback on from someone, and while waiting on that i can shift over to the other things.
  - filippo: fixing sunlight witness support and announcing it
    - dev witness -> staging witness -> prod witness
  - filippo: need to catch up about conversation regarding tlog-mirror
  - filippo: unfortunately not getting any feedback on photosynthesis mailing list
    - secdispatch - where you go when you have a document under the security area, but it doesn't have a clear working group to get adopted from. Then they say "bring it up for adoption in this working group", or "there's no working group for it and people are interested, let's make a new working group for it"
     - https://mailarchive.ietf.org/arch/browse/secdispatch/
  - filippo: have some work on verifiable indexes
  - filippo: want to setup a proxy for gochecksum db that serves it using c2sp.org tiles format, it's annoying that there are three formats (staticct, tlog tiles, gosumdb). To have staticct in its own thing with extra data was motivated by: compressed so nicely. This could also be the start of a proxy that serves things like verifiable indexes and/or having this proxy with witness cosignatures - "here are the metrics, it worked well for the past 9 months and here are the graphs for added latency".

## Other

  - rgdd: about cosignature/v2:
      - about the changes that cosignature/v2 proposes (adding the name)
      - Martin thinks that maybe it's not worth it to change that now
      - We could live with v1 for now
      - filippo: the IETF is likely to create its own cosignature format
        - maybe we wait that out and see if we can contribute and steer that
        - and then we could bless that as our cosignature/v2
        - a likely outcome is that we make cosig/v2 and then IETF makes another one, then there will be three different
        - rgdd: there is also the "sub-tree signature"
        - filippo: there are a lot of conversations like this that will happen in the next few months
        - rgdd: for me, I liked the v2 things but we could also live with v1
    - rgdd: then I might add to the v1 spec instead of creating a v2
      - distinct tuple (name, key, cosig-version)
    - filippo: in hindsight, it was a mistake we made that we did not include the name in what is signed
      - rgdd: I agree, if I could go back in time that's how I would have done it
      - rgdd: maybe we would have had the same signature format for logs and witnesses
    - rgdd: basically, the complexity of adding a v2 is maybe not worth it
    - rgdd: can add text about additional claims
  - filippo: in photosynthesis there is an appendix
  - rgdd: I will take a look at the appendix
  - filippo: in IEFT world there has to be everything you need to verify a cosignature, but not how you got it, so protocols do not necessarily need to be there
