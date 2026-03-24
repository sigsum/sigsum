# Sigsum weekly

- Date: 2026-03-24 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: elias
- Secretary: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- elias
- rgdd
- nisse
- filippo
- florolf
- gregoire

## Status round

- rgdd: trying to get tlog-witness tagged as version 1.0.0
  - https://github.com/C2SP/C2SP/issues/175
  - tl;dr: some minor fixes + we plan to keep sub-spec versions pinned
  - current blockers: click merge on two more minor fixes things (see next
    steps)
    - most of that has been done
    - another part of the discussion was about pinning versions for specs
- nisse: Made a spec bugfix release, see
  https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-announce@lists.sigsum.org/thread/BNUYGLMVPIR3SP2TBIT7TCD4MJGI5MNC/
  - "spec doesn't match reality", order fix.
- nisse: SSH signatures for sign-if-logged,
  - issue: https://git.glasklar.is/sigsum/apps/sign-if-logged/-/issues/1
  - host-only variant (same as last week):
    https://git.glasklar.is/sigsum/apps/sign-if-logged/-/merge_requests/12
    - as discussed last week
  - device variant:
    https://git.glasklar.is/sigsum/apps/sign-if-logged/-/merge_requests/17 +
    https://git.glasklar.is/sigsum/apps/tkey-sign-if-logged/-/merge_requests/18
    - only sigsum log actual data you wanna sign, then the tkey formats this
      into am ssh blob that's signed
    - complexity wise? more formatting of bytes with various lengths, but not
      horrible. The ssh specific things is ssh.c file, that's two dozen lines of
      code. And also more protocol logic to configure namespace and get that
      into the key derivation and having space for it in various protocol
      messages.
    - what's next?
    - would be nice if someone else could have a look at the device code and see
      if that looks reasonable, or if it's too much complexity
    - but nisse's assessment is that it's workable
    - florolf: advantages of doing this on the device? (missed last week)
      - background is: app only signs if it is already logged. All on host side,
        then makes things more complicated for users and monitors because the
        stuff that is sigsum logged is the ssh blob that includes namespace,
        open ssh magic bytes etc.
      - but there is also an advantage right? the device is more specific in
        what it will do.
- elias: sigsum ansible v1.6.0 released
  - https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-announce@lists.sigsum.org/thread/7ZNOJDNFTJYGKKJMZ3SSLMMDOCZA2Z2S/
  - v1.6.0 includes:
    - support for witnessctl pull-logs - fetching log list from
      witness-network.org
    - support for per-log bastions
  - now it will be easier to join witness network
  - is this ansible for both log and witness stuff?
    - yes, but these changes don't affect log side of things
- filippo: rgdd already listed all of the things from my side, i.e., c2sp
  conversation. ML-DSA based conversation for tlog cosignature etc. I still have
  to type up a draft, will circulate once I have some free cycles.
- filippo: release of sunlight, smarter rate limitting (low vs high prio
  entries). Helps one of the CT operators that are struggling with load (from
  cross posters, not CA). By limitting to pre certs that are recent or without
  SCTs -> can prioritize.

## Decisions

- None

## Next steps

- filippo: cirulate ML-DSA design ideas for possible c2sp spec extensions
- filippo: lightning talk on tlogs for ATProto on sunday, will share the
  recording
- filippo: click merge on rgdd's tlog-witness wording fix?
  - https://github.com/C2SP/C2SP/pull/217
- filippo: click merge on endianess clarification? (sounds good to rgdd)
  - https://github.com/C2SP/C2SP/pull/153
- rgdd: tag tlog-cosignature v1.0.1, tag tlog-witness v1.0.0
- rgdd: start using ansible v1.6.0 for my poc witness
- rgdd: review nisse's ssh sign if logged stuff (ssh understood by tkey device
  app)
- elias: prepare for using per-log bastions for Glasklar logs
- nisse: keep working on the tkey stuff
  - poke tillitis once the ssh stuff is merged, so they can start trying

## Other

- gregoire: status of the compiled policy thing that nisse was working on, is
  that part of the c library now?
  - yes, it's part of the c library
  - https://git.glasklar.is/sigsum/core/sigsum-c
    - https://git.glasklar.is/sigsum/core/sigsum-c/-/blob/main/doc/quorum-bytecode.md
    - https://git.glasklar.is/sigsum/core/sigsum-c/-/blob/main/lib/quorum.c
  - including a documented quorum machine and formats
  - there is no defined serialization there tho
  - is this something that could be made into a spec?
  - i.e., could it be possible to share the compiled policies?
  - quorum handling -> there is a spec
  - serialization -> not at the moment
  - do you have a use case for compiled policy distrbuted?
  - background: nostd support was asked for in rust library, turns out they
    still support allocation so it's just changing some import paths. But got
    gregoire thinking, could we support nostd..and this is the context for
    thinking about it.
