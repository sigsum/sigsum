# Sigsum weekly

- Date: 2024-12-17 1215 UTC
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
- nisse
- ln5
- filippo

## Status round

- rgdd: checked that github mirroring still works, and added so that
  core/key-mgmt and admin/ansible are now mirrored as well.
  - https://github.com/sigsum/
- rgdd: guest lecture on merkle trees and sigsum yesterday at kau
  - https://git.glasklar.is/rgdd/kau-24/
- rgdd: reached out to tracy about bridged room, the tdev end would like to try
  it as well. Their slack admin has been informed that we're waiting in
  #sigsum-test to give configuration a go / see if it works well enough
- rgdd: reached out to al about the excerise i mentioned last week (write down
  "about page" for witness), no response so far but there's also no major rush
  so that's okay!
- nisse: fosdem talk has been accepted, and scheduled for Saturday 15:30
  - https://fosdem.org/2025/schedule/event/fosdem-2025-5661-sigsum-detecting-rogue-signatures-through-transparency/
  - presentation prep -> after holiday, might do an outline before
- elias: worked on seasalp monitoring, heartbeat submissions (implementing w/
  checker)
  - kind of works
  - a bit of polishing now what should be in the email body etc
  - happy to get comments if you have any
  - would appreaciate if rgdd can look
  - nisse: any accompanying ansible mr to setup config and policy?
  - yes, elias did that last week already
  - it's a bit confusing perhaps that it's an interplay between those two:
    ansible setup that has to happen first, and then the checker thing is using
    things that must already be in place
  - so it's not ideal, but maybe ok for now
  - ln5: one thing that makes it worse: we do it in the closed ansible repo, so
    we can't even refer to it right now. Would have been great to have pointers
    to the ansible setup. Maybe we should move this role out of the closed repo
    once it is working properly
    - +1
- elias: added rate limiting config on seasalp (it was missing), now the rate
  limit is "once every 5 minute" as default (per domain)
  - filippo: is it a window? how does it work?
  - nisse: it's a counter that's reset every 24h, which time of day is not well
    defined
  - "i have now created a problem for my heart beat submissions, will need to
    setup the key with dns"
- ln5: i built an image for the rpi which will be the seasalp witness
- filippo: did a round of litewitness productionizing; there is now a v0.3.0.
  Changelog:
  - https://github.com/FiloSottile/litetlog/blob/main/NEWS.md#v030
  - https://milan.filippo.io/dev-witness/
    - operators are free to block if they want -- just a human readable file
      that is not meant to be easily parsed so that people start using it as an
      api
- filippo: my prototype witness is working again!
- filippo: good chat with M, scoping project. Including silent monitor for
  sumdb. I think that's a useful example for the ecosystme in general.
- filippo: a bit of sunlight work
- filippo: been struggling with naming of litetlog for a year now (as you know).
  I've decided to give up, I'll call the project something generic. ANd have the
  existing and other future tools here in one place.
  - so scope+name -> too hard, instead going for just "name"
  - current naming idea: torchwood
- nisse: bastion problem we had a few weeks ago, likely with the connection via
  the bastion. Did filippo check that?
  - filippo: no, not yet. Just did witness so far.

## Decisions

- Decision: Cancel weekly on 2024-12-24 due to holidays
- Decision: Cancel weekly on 2024-12-31 due to holidays

## Next steps

- rgdd: something is not working with my checker's email, need to debug and fix
- rgdd: more of the things i didn't have time to do from last week -- draft on
  "about pages" for glasklar's log/witness (to get the ball rolling)
- rgdd: upgrade witness to v0.3.0
- filippo: litebastion issue nisse mentioned in status round
- filippo: next step is likely to stand up a sunlight witness in rome
  - will email with the witness details
- elias: get seasalp monitoring up and running before xmas

## Other

- FOSDEM
  - nisse and elias are going, maybe linus
  - how about filippo? probably not, unless it's a last minute thing
  - in sec devroom: tkey talk by mc; morten will be there talking about tpms.
    and nisse's sigsum talk. so lots of stuff will probably be going on.
  - rgdd also won't go, same motivation as filippo
- filippo: litewitness. Went back and forth of making logs public (as in log
  lines). "Logs should not have private information". And this is true for
  litewitness. But then couldn't quite figure out how to expose them without
  risk of using bunch of bandwidth. Best idea: **publish on a website?** I.e.,
  filippo is worried about the constant reconnect and overhead from that.  ops
  feedback on having such an endpoint?
  - "can see the logs without logging in on ssh"
  - nisse: good enough to have a page where you first click a page and then you
    get the log streamed for 5 minutes?
  - so we're not too worried about ppl using it as an api?
  - nisse: not sure how likely abuse is
  - use case is: you ping me in chat, something is wrong with the witness. Now i
    can on my phone go and check my log endpoint. But also: maybe you're
    submitting up a new log that's submission and it gets rejection. And you want
    to just look at the logs of the witness. ANd you would have to email, ask to
    look at the logs, etc. Now instead. You can see the log lines yourself.
  - and worry? they use it as "an api" / maybe they want to be notified every time
    a log has a new checkpoint. So i just tail the log lines and use it as a
    notification service
  - maybe **limit the number of simultaneous connections is the answer?**
  - and when the problem arises...have now two solution ideas (see bold)
