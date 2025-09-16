# Sigsum weekly

- Date: 2025-09-16 1215 UTC
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

- rgdd
- elias
- nisse
- florolf
- filippo

## Status round

- nisse: Spec fix for sigsum-proof
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/255
- nisse: Prototyping sigsum C library
  - https://git.glasklar.is/nisse/sigsum-c
  - merkle tree inclusion/consisntecy a while back
  - now impl policy
  - sort of half way done
  - motivaiton here: be able to do computing on the tkey security key
    - https://www.tillitis.se/
  - requires nettle as a dependency, elias was able to try it already
- elias: started looking at named policies implementation
  - want to first merge some modified version of nisse's MR
    - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/248
  - should I create new MR or modify nisse's existing MR?
    - nisse: if you want to do some smallish changes, easiest to just push new
      commits to that branch
    - nisse: if you want to do more complete rewrites, or rebase on that branch;
      then that would be confusing
    - elias just want to do small things, like replacing old test log to new
      test log; and also name and filename extension. Small things like that
    - elias will make changes in the existing branch
    - should name be glasklar or sigsum of the named policy?
    - opinions on this?
    - rgdd: leans "sigsum"
    - nisse: +1
    - built in production policy? can think one more time
    - sigsum-test-2025 (or similar, e.g., year+month)
    - new policy -> just the time/date changes
  - name of the first built-in policies for testing, using test log & test
    witnesses:
    - should the policy name start with "sigsum", as in "sigsum-test-1-2025"?
    - or "glasklar", as in "glasklar-test-1-2025"?
    - nisse: I think sigsum make sense, log is at test.sigsum.org/barreleye
      after all.
- elias: discussed with gregoire about log failover things
  - thinking about scenario where two things go wrong at the same time:
    - primary node disappears
    - secondary node has broken HSM
    - then it becomes relevant to setup a new primary and fetch data from
      secondary to primary, so the same thing gregoire wants
- rgdd: martin and I have a TDS draft schedule
  - TDS: https://transparency.dev/summit2025/
  - currently being circulated within the program committee
- rgdd: (also topic TDS) - martin and I are sending out speaker information and
  cherry-picked comments (in aggregted form) from the reviewers to speakers that
  we think will help them when preparing their talks
- rgdd: sync:ed with Al about our ongoing witness configuration work
  - the idea is to maintain a list of logs, and a witness can be configured to
    use that list of logs
  - https://git.glasklar.is/rgdd/witness-configuration-network
- filippo: fips season, time not tilted towards tlogs right now. Played a bit
  during the weekend, build archival format and tool for tlogs. Google is
  thinking of shutting down ct mirrors, and i think that's valuable data for
  research (and just histoprical data that's useful to go back to). Now can
  basically get input rfc6962 logs and archive it, $details, zip file subtrees,
  can extract titles even without unzipping the whole thing. Basically finnished
  it and tried uploading things to internet archive. Had to do various network
  engineering to get more speed. Then decided one of the zip files that was
  exactly like all the other ones was not accepted. And then I ran out of time.
  If anyone wants to fight internet archive to make it accept a zip file ->
  would appreaciate the help!
- filippo: had a bit of a chat with martin about verifiable indexes and
  multiplexing >1 input long into a single verifiable index. Bunch of
  complexity, but for CT might be a good idea. If we need to maintain one for
  every CT log, monitors will not be able to reproduce the indexes. So think we
  need to multiplex multiple logs into a single prefix tree.
  - memory scales with number of keys
  - rgdd is happy to talk more about it later, and filippo will think more about
    it
  - (rgdd's entropy was basically: if per log, might be ok to not run all of
    them in parallel; and it might also be ok if reproducing the index is not
    done in real time. I.e., what's important is that there's no split view and
    there's at least someone that clicks the "try to reproduce" button. Can be
    one-off. Can be something that runs daily. Etc etc. This is in contrast to
    users monitoring e.g. example.org, which will want to tail the index. And
    they're happy to do so as long as it is cosigned, no split view. Then the
    exceptional issue of incorrect index will be caught after the fact. So all
    rgdd is trying to say: consider if the complexity of multiplexing is worth
    it, or if it would already be good enough without multiplexing given e.g.
    the above thoughts. And if not, it's nice to be explicit about why it's not
    good enough, when we're trying to remember three years from now why we
    decided to go in a particular direction!)
- gregoire: started with load testing of a log, don't have the extact number
  here. SHould i write them somewhere? We have them somewhere internal. Put them
  in chat somewhere?
  - yes - gregoire will post!
  - seems like around 1000s leaves per second
  - also estimated the storage space of the leaves (using postgreqs), around 700
    bytes (seems a lot?)
- gregoire: have pushed a public repo with rust impl of sigsum verifier, which
  we made as a proof of concept for an internal tool. But extracted it
  - LINK: https://github.com/mullvad/sigsum-rs
  - FWIW it's a bit unpolished and not yet pushed to

## Decisions

- None

## Next steps

- elias: work on named policies implementation
- elias: set up my own sigsum monitor(s) to start using sigsum in practice
- rgdd: page in where ietf merkle tree cert stuff is at (backlogged from last
  week)
  - top of my list now!
- rgdd: likely another sync with Al $soon
  - will reach out once i've addressed the feedbacked received so far
  - or maybe Al will beat me to it and reach out before then, lets see!
- rgdd: try to wrap up the final TDS program things with martin
- rgdd: check if there's anything i should comment/reply on wrt. sigmon by
  florolf, have some unread emails with notifcations that i haven't tended to
  yet
- rgdd: if time permits, get started with per-log bastion host exploring
- ln5: working on docs about setting up witness (getting started)
- nisse: maybe do something about the policy spec (depending on below
  discussion)
- nisse: otherwise just more of the same tkey stuff
- filippo: exactly the same as last week, because i didn't make much progress.
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2025-09-09--meeting-minutes.md
- florolf: backoff handling in sigmon, would like to resolve that!

## Other

- nisse: Would like to discuss policy spec issues, see:
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/137
  - nisse want to specify its mainly ascii format, but want to allow non ascii
    stuff in comments and urls (no puny code)
  - few other issues - currently allows duplicates in group definitions. Think
    it makes sense to reject that.
  - Can have indirect dups with witness being member of multiple groups, kind of
    weird. One potential use case: policy with bunch of witnesses and a
    different policy with same witnesses. And you want the quorum to be "one
    policy or the other". Then the groups would overlap. But it's also a way to
    shoot yourself in the foot. Not sure what the right thing is.
  - Arbitrary limits - if you implemtn this. Is it fine to have e.g. at most 10
    witnesses or 64 witnesses etc. Would be good to have some guidance.
  - For cosignatures we said "support at least 16" or something like that, i.e.,
    in the c2sp.org spec.
  - input?
  - elias: same witness part of multiple groups. Agree it seems good to restrict
    that or disallow that, because witness is something that's independent. It's
    the main point. And if you have differnent groups, then the groups are
    supposed to be independent. Then you're breaking that. It seems wrong. Maybe
    there are cases, but it becomes easier to understand the whole thing if it's
    not allowed.
    - nisse: so then each witness/group has at most one parent
  - gregoire: have a maybe usecase for this. Multiple versions of the policy for
    different clients that have policy.1 and policy.2; then can maybe write a
    common policy that's just policy satisyfing both.
  - elias: what i think should be forbidden is rely on the same witness twice
  - filippo: does it have to support arbitrary merging of policy formats, or
    could it be a higher level feature "hey please ensure you satsify all of
    these policies"
    - i.e. not sure we need to encode this merging into the policy format
    - e.g. multiple policies to submitter
    - gregoire: yes that would work
  - filippo: so saves a bunch of complexity, would be nice to save us from it
  - (main complexity is reasioning about policy; good thing if we can make it
    narrower)
  - filippo did like the: erroring out if >1 witness has the same key; can
    imagine ppl making that mistake.
    - but removes the DAG hack though
  - florolf: could image want quorum of witnesses i run, but also larger quroum
    from public witness pool. If I'd also put the witnesses in that public pool,
    then there would potentially be a bit of overlap. If there's reasonable
    scenario with witness in multiuple groups, makes sense to keep it. Unlike
    key reuse, this is not as much of a footgun (or at least a less likely foot
    gun).
  - elias: think it is a foot gun in the sense that, there is a group of
    witnesses and you decided your witness wil be part of that group; and then
    also want to use the witness independently at the same time. The thought of
    the policy is i get more security because i'm using both independent witness
    and group. It becomes stronger. But if your witness compromised, it
    colappases because you think you have sec you think you don't have (i.e.
    both witness and group gets affected).
  - shoudl this be a syntax error, or should you be allowed to shoot yourself in
    the foot by making the choices?
  - texutal verification makes sense to avoid stuff like copy paste errors and
    typos; but if decide would like a policy like that. Not sure if it makes
    sense to prevent on tht level.
  - If we want to prevent users from doing this, then would also have to add
    other checks on top of that
  - filippo: not sure i agree, foot gun removal by its nature not complete. Can
    always paste key to pastebin. But what are plausible mistakes, what are more
    likely mistakes than others. Sometimes they are not pure etc. But sometimes:
    is it more likely i'm helping user or letting them shoot in the foot.
  - filippo: is there specific use case where we want same witness in >1 group,
    then we can't prevent the foot gun because it's something we want to allow.
    But if we can't think of a good use, we can keep it strict and relax it
    later.
  - filippo: in defining set of accetable characters, keep in mind c2sp key
    names allow any characters that's not unicode space or a plus. So you
    probably want to make it probably the same set.
  - nisse: see it makes sense to allow that, but i'd like to spec it in a way
    that you don't need to have the unicode tables to parse the file.
  - nisse: easy way is to allow unicode spaces in name format and those names
    will be incompatible with c2sp names
  - filippo: can't think of any way that would blow up badlyt
  - filippo: but you proibably want to not allow the pluys in names probably
  - filippo: aside from that, making things stricter sounds like good direction
  - rgdd: suppose a company runs 3 witnesses
    - what if an internal witness also in in a public group?
    - then even if your witness is in the public group, in your internal usecase
      you could define your own cusom policy where you define the group such
      that your witness is not included in the group (even if others are seeing
      your witness as part of that group)
    - florolf: yes that makes sense
- elias: would like to discuss this case:
  - submitter wants to know if key is compromised
  - attacker controls:
    - submitter key
    - log
  - attacker can do this:
    - perform a signature using submitter key
    - collect cosignatures from witnesses and create proof
    - make log unavailable, claim that log is "temporarily down"
    - deliver the proof to verifier(s)
  - monitors do not know about the new signature
    - can only see that log is "temporarily down"
    - so log being down must be interpreted as possible key compromise?
  - nisse: Time delay might help: Don't accept treehead until a few days have
    passed, to give monitors time to work, or tell you if log is down.
  - rgdd: "temporarily down" would just be a way to delay detection, and after
    some time one would conclude that it's more than just temporary and that's
    very fishy. The log's choises are: continue to be down forever, come back up
    and detection happens, or come back up and split-view in which case
    witnesses won't cosign.
- rgdd: on the topic of accounts at git.glasklar.is, might be worth finding a
  good place to write a sentence or two about that at www.sigsum.org and/or the
  gitlab instance. Another part that's under documented is that it's possible to
  send email directly to all the core repos, which then arrive in our issue
  inbox (confidential at first - made public manually by someone with maintainer
  privs). And it's also possible to reply to emails from gitlab when being part
  of an issue. Very convenient sometimes!
