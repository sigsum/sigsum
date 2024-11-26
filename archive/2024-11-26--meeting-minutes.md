# Sigsum weekly

- Date: 2024-11-26 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: nisse
- Notes: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- elias
- rgdd
- gregoire
- nisse
- ln5
- filippo

## Status round

- elias: did setup test witness using litewitness ansible role, but not yet
  connected to log.
- rgdd: a bit more progress on notes related to shared configuration
  for logs and witnesses, configuration requests, etc. Other than
  what's already in the MR shared last week (including comments ontop
  of it) I don't think its worth sharing what's in my branch yet (but
  if you want to peek early it's somewhere in sigsum/project repo).
  Also sending emails related to this.
- rgdd: misc review / user support / ops related things
- nisse: Merged vkey conversion, and sigsum proof v2
- gregoire: not much to report but happy to be here :)
- filippo: looking at what's blocked on me. litebastion issues seems important.
- filippo: chatting with trustfab folks, both about general 2025
  planning and direction; what they want help with etc. Which is
  perfectly aligned with glasklar roadmap. Chatted today with Al about
  shared log list configuration, pitched two things. List of witnesses
  not machine readable. Just a markdown. Which we were keen on but
  they were initiallyh thinking machine readbale foirmat. Seem
  receptive. Second: not using yaml/something like that. Posting a
  sketch in the bottom of the pad. So usual line separated things.
- filippo: also discussed alg type on vkeys. Al says it's perfectly OK
  to switch to using the correct (arguably) type in the vkey, and
  they're happy to do the switch if we also want to use the
  cosignature algtype in the vkey.
    - nisse: makes sense to have it consistent with what the vkey is intented to verify
- ln5: glasklar witness v1 hw arrived
    - RPI with a PoE hat (in the name of development time and unit price)

## Decisions

- Decision: Adopt proposal on experimenting with a slack bridge
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/92
    - nisse would be even happier if a contact person on the slack side could push the buttons on that end.
    - filippo: Person on slack side would probably be tracy. And on matrix not sure (rgdd says probably me)

## Next steps

- filippo: litebastion reconnect issues, and generally the logging verbosity.
- filippo: still need to reach out to https://github.com/mjl-
- filippo: draft on a vkey spec, or at least figuring out where that
  goes? we're clearly missing some language somewhere. if we agree on
  what it should do -> would be good to write it down.
    - not so likely that i will get to this this week
    - nisse: should probably be an appendix on signed-note
- elias: connect test witness to jellyfish test log.
- rgdd: more of the same from last week
- ln5: fix (another) log+agent startup bug showing up yesterday after
  a system reboot. And update the docs on glasklar's operational side,
  helpful for us and others (including things like monitoring if the
  log isn't able to sign tree heads -- this was found manually
  yesterday).
- nisse: Extract per-witness stats

## Other

- <insert other discuss topic here>
- PR on documentation of good startup behavior, would it be accepted in litewitness?
  - filippo is open
- nisse: Collected stats last week. Scripts used available at
  https://git.glasklar.is/nisse/cosignature-stats. See below.
  - ln5: have we decided we should not try to track each and every witness separately?
  - nisse: we don't have consistent monitoring at all now, my stats are one-shot.
  - histogram of which witness is missing: was not done for any
    particular reason. There is data to plot this though, we just
    didn't plot it.
  - per-witness numbers would be helpful to debug further
- rgdd is still looking for comments on sigsum/v2 thoughts that's been
  circulating. Note that even though we're not planning to do a
  sigsum/v2 tomorrow, this can be helpful much earlier than "v2" since
  some things can be backwards-compatible, influence formats we
  use/push, etc.
  - https://pad.sigsum.org/p/19fe-e132-b60b-7a47-7839-c8b9-96e3-52c9
- nisse: Unrelated question for filippo: Is there some way to hook
  net.Resolver or net.Dialer to get the list of candidate IP adresses
  used by Dialer.DialContext? (On success, the connection's
  RemoteAddr() gives one address, but I'd like to also have any
  addresses that were tried but failed, or addresses that were
  candidates but not tried. In particular for the failure case).
  - net/http/httptrace might have that?
  - nisse saw nettrace in the code, but filippo says httptrace package
    might have what you need. Looks like it does?
  - nisse will have a look
- ln5: re shared configuration for logs and witnesses: would this
  benefit from also including system log formats and monitoring
  metrics?
  - from operational experience with IP peering (experience which is
    dated but perhaps still relevant) i think that sharing logs is
    often useful
  - being able to point ones own monitoring tool at peers and/or
    access peers monitoring dashboards seems useful
  - helping witness operators to signal "planned downtime" to log(s)
    they sign would probably be useful too, and vice versa (log
    operator telling witness operators); same for bastion operators
  - rgdd will incorporate comments into notes
  - Sunlight has public Prometheus https://rome.ct.filippo.io/metrics
  - "how i can monitor yours, how you can monitor mine"
  - sometimes unified log format (or fewer log formats) help
  - but if there is a way to signal "expect this to be flapping for a
    day now because i will be doing foo" could help (other than email)
  - useful, but potentially something we first want more XP with
    before we put it in there. E.g. wouldn't block v1 on this, but
    useful to have on the radar.
  - most of this might not go into an api, some of them are
    human-to-human interaction. But mapping out which interactions are
    human-to-human, and which ones are machine interactions -> good to
    start writing down thoughts
  - public metrics -- can we think of things a witness knows that it
    should not make public?
  - ln5 would argue to the contrary: thinks of (system) logs as
    public, and try to fix (system) logs so they can be public. So
    thinking about what can and should be put into logs -> useful.
  - if all log lines are public -> http page that when you open it
    logs go to that page as well? filippo thinking out loud
  - ln5 other aspect: when you start writing or fixing a program where
    all log lines is public -> you start thinking differently of what
    you put there. It is not "maybe public if someone breaks in to my
    thing" -- *it is public*.
- gregoire: trying to go through key management thing. there are two
  different yubihsms on the website. does it matter which one i have?
  there's fips and not fips.
  - filippo: don't get the fips one
  - ln5: if you get the fips one, dont put it in fips mode (unless you
    have a weird req from your upstream that it needs to be fips; and
    then you can have an argument with them)
  - but tl;dr: don't get the fips one unless you have to for $reasons

### Stats collected by nisse

For seasalp:

```
Stats for count-seasalp-2024-11-21.txt
  #measurements: 20720
  start: 1732003706 Tue Nov 19 09:08:26 AM CET 2024
  end:   1732191855 Thu Nov 21 01:24:15 PM CET 2024
Distribution:
   2876 15
   7674 14
   9733 13
    404 12
     31 11
      1 10
      1 9
```

So for this period, distribution peaks at 13 of 15 witnesses available.
In the same period, jellyfish had 3 cosignatures at each and every request.

### Sketch of a list of logs format by filippo, shared with TF

```
logs/v1
revision 8738

# comment
example.com/log1
VKEY1
qpd 86400

# comment2
example.com/log2
VKEY2
qpd 24
```

qpd is queries per day.
