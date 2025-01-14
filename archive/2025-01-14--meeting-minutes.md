# Sigsum weekly

- Date: 2025-01-14 1215 UTC
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
- nisse

## Status round

- rgdd: our irc/matrix room is now bridged with room `#sigsum` in the
  transparency.dev slack. Thanks Patrick and Tracy for making it happen! For
  context about this, see:
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2024-11-26--meeting-minutes.md#decisions
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/proposals/2024-11-slack-bridge.md?ref_type=heads
  - Notes from testing what seemed to (not) work:
    - reactions (like thumbs up etc) works on both slack and matrix
    - threads work on both slack and matrix
    - reply on individual message also work on both slack and matrix
    - even profile photos on slack and matrix are shown correctly on the other
      end
    - images that slack users send show up in matrix
    - images that matrix users send *don't* show up in slack
    - DMs between slack/matrix users doesn't work
    - (the UX is a bit poorer on the IRC side, but should be the same as before)
    - (on the irc side, most of the slack users appear as e.g. Al\[m\]. Except
      for Martin so far, which appears as \_slack_transparency-dev_U05V4F.
      Unclear why.)
      - Update: a few more of these now -- not sure why it's like this for some
        users but not others.
- rgdd: rgdd.se/poc-witness is now running v0.3.0, worked out of the box
- rgdd: filed bumping of litewitness version in sigsum's ansible
  - https://git.glasklar.is/sigsum/admin/ansible/-/merge_requests/46
- rgdd: drafty witness about page for glasklar's witness, nothing public to
  point at yet but if anyone that doesn't already have access to it and want an
  early sneak-peak let me know and i can share it via email. My goal is for
  there to be a finalized about pages for glasklar's log and witness until 28th
  Jan. Current sections in draft#1 are:
  - Business continuity
  - Infrastructure and setup
  - Operational issues
  - Request witnessing of a log
  - Configure the witness
- rgdd: (i expect the above about pages, esp., witness., to be useful if we want
  to extrapolate into a 3rd party service that helps with discovery and manging
  witnessing requests.)
- rgdd: when writing on the witness about page, realized this will need fixing:
  - https://git.glasklar.is/sigsum/admin/ansible/-/issues/50
  - maybe elias wants to take a stab at this? --> yes ok / Elias
  - (depending on how elias chooses to fix, maybe the sigsum-log specific
    witnessctl command can be dropped after this)
- rgdd, nisse: good conversations with jas on sigsum-general
  - "sigsum-release-verify"
    - https://git.glasklar.is/rgdd/age-release-verify/-/issues/1
  - some +1s for some kind of primer on www.so for "how a 3rd party can verify",
    "what a user needs to know when using sigsum-verify", and how to get rid of
    the policy EOF blurb
    - jas had an idea related to named policies that i copy-pasted into the
      other section
  - some difficulties selecting policy, because no docs or commitments by anyone
    yet
- rgdd: fyi -- will be missing next sigsum weekly, will be attending a
  licentiate defense at kau. Any volunteer to chair?
  - nisse will chair
- elias: monitoring, merged checking that log size grows as expected
  - https://git.glasklar.is/sigsum/admin/checker/-/merge_requests/12
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/proposals/2024-12-seasalp-monitoring-shortterm.md
- elias: my test witness witness1.smartit.nu now also running litewitness v0.3.0
  - rgdd: consider an MR that adds it to the getting started guide
  - nisse: service pages on www.so -- maybe services framing is not right. I.e.,
    it is not the sigsum project's services. But services for sigsum things. To
    be fixed/considered.
- nisse: Started on the slides for fosdem
  - https://git.glasklar.is/nisse/fosdem-sigsum-2025/-/tree/main
  - https://fosdem.org/2025/schedule/event/fosdem-2025-5661-sigsum-detecting-rogue-signatures-through-transparency/
  - still needs several more iterations, want input from rgdd
- filippo: played with litebastion debugging. Can see a lot of what's happening,
  but a lot is ugly logs and so on and not root cause for why connections are
  dropping in the first place. Can't reproduce connection drop locally, not
  great. I have a new version that I'll push now with better logging. If you
  deploy that one and can catch it as it happens, I think we need that to make
  progress.
  - rgdd: give a tag and we'll bump version for bastion.glasklar.is
  - rgdd: poke elias, he will do the bumping
- filippo: played with age reproduction. Got completely stuck on PE binary to
  transfer the signature
  - rgdd: start with prototype that doesn't work on windows?
  - figuring out a good way to do this on windows -> will inform on what the
    right interface is
  - the easy way is very easy (with new go toolchain version variable) -- you
    don't even have to download load. Just set gotoolchain variable based on
    what the binary say, and you get the binary out
  - filippo wants to talk about what the rb interface is in the other section

## Decisions

- None

## Next steps

- rgdd, ln5: more witness/log about pages for glasklar's operations
- rgdd: need to page in next iteration of sigsum planning / milestones
  - if you can briefly summarize you're high-level progress since last time and
    send me -> that would be helpful for preparing the summary in the next
    roadmap doc
  - see also last roadmap update
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2024-10-29-roadmap.md
- elias: more monitoring for the seasalp log, add submission with policy
  requiring some witnesses
  - rgdd: you might find one of my replies to jas at sigsum-general helpful,
    i.e., policy file example with 8/15 AW witnesses
  - https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-general@lists.sigsum.org/thread/I465MH46WGSGNKOFDSUZM5T3SLRG2IC7/
  - (not sure how to link the exact reply, but search for GoogleTrustFabric and
    you'll find it)
- elias: do new release of https://git.glasklar.is/sigsum/admin/ansible
- elias: the ansible mention during the status rounds
  - https://git.glasklar.is/sigsum/admin/ansible/-/issues/50
- elias: www.so/getting-started, update to include my poc witness
- nisse: would like to get a better idea of the priorities for my fosdem talk.
  How much focus on explaining the sigsum system, and how focus on how to use it
  in practise
  - rgdd: will give feedback on thursday when i see you in person
- filippo: with the logging stuff and bastion debugging blocked on getting the
  version deployed at bastion.glasklar.is, my next steps are not on this side.
- filippo: will push age linux reproducer, but that one is also mostly ready
- filippo: more useful to work on the vkey spec or getting a witness into the
  rome sunlight instance?
  - nisse: don't have much clue about witness in sunlight, but vkey spec would
    be useful. Another spec thing that would be useful is the tombstone thing.
  - rgdd: vkey spec is quick, right? I think we all agree on what it has to say
  - rgdd: i'm also reffing the vkey spec from the about pages now, and using the
    golang docs as the link right now. Think nisse is also doing this in a few
    places.
  - broader next steps -- log of witness configuration work, but seems like
    rgdd+trustfab folks are already making progress. Then there's maps. And
    there's witness in sunlight.
  - witnesses for go checksumdatabase? how far into the future is that?
    - filippo can bring it to them at any point
    - guess it takes a couple of months to deploy it
    - filippo want to bring it when there are a few witnesses they can use
    - i.e., plays out: they add witnessing, leave it fail open for say a year
    - then after a year can have a conversation about the shape
    - e.g. did the sumdb ever fail in a way that would have cause db outage
      because of witnessing
    - "no"
    - so are we comforttable failing close? yes
    - ^: would be a good story
    - rgdd: defer for now, until we have about pages for glasklar and AW witness
- filippo: today push the litebastion version and poke elias

## Other

- nisse: got a feature request for nettle to do stateless hashbased post
  quantuom signatures that i'm not at all familiar with. But it does use a lot
  of merkle trees inside.
  - so something nisse will be looking into in his spare time
  - but basically -- another use of merkle trees
  - filippo: slh, right?
    - yes
  - this is something filippo also want to implement in go
    - keys are huge, signatures are tiny
    - nisse: pubkeys tiny too no?
    - maybe we're misremebering, there's a strong bias in some direction but we
      don't remember which one. Maybe it is the signatures that are large.
- sigsum-release-verify interface
  - commit rb script to prototype repo? No, filippo should commit it to his repo
  - filippo grown farily convinced of: for this to work nicely and reliably into
    the future, the thing that does the reproducing needs to come from $latest.
  - so reproducer is a script that can change over time; should be short and
    reviewable. Goes back and clones the old version, and builds the old version
  - if we kind of agree on what its output needs to be, then it can be a script
    in the age repo
  - what you do: point it to a GH project, sigsum set of keys, and where the
    reproducer script is. Then the tool could just work.
  - so what is input and output?
  - input
    - tarball?
    - Much much stronger if we don't do that
    - If script doesn't take existing release, instead produces one-by-one
      binary that has to match the existing one -> then guarantee stronger. At
      very least it does not adapt output to the specific release you're trying
      to reproduce. Whether it is the backdorred one or not.
    - Harder to implement, easier to explain
    - Script could know how to reproduce something even if it is not in GH
      releases
    - sigsum part: "any hidden releases"
    - rb part: the releases we found reproduce bit-for-bit
    - so maybe answer
    - script takes a version (git tag)
    - a file name (the file that is attached to the gh release)
    - reproduces that file exactly
    - this also answers question (unpack or not unpack tarball)
    - you have to reproduce the entire tarball
    - so if you made mistakes with timestamps in the tarball -> it doesn't rb
    - nisse: for hints on building an RB tarball, see
      - https://git.glasklar.is/system-transparency/core/system-transparency/-/blob/main/releng/mk-release-archive.sh
    - other nice thing of script in repo -> filippo can run CI for it
- elias: want new release of https://git.glasklar.is/sigsum/admin/ansible
  - rgdd: you can do the release, but sync with linus
- fyi: tracy announeced on matrix that there's a first transparency.dev
  community meeting next monday 1700 CET. Everyone that wants to show up are
  invited!
  - Agenda doc:
    https://docs.google.com/document/d/1cQop8_p7-fV5CEO5ADyvLrDGDm8BR79MytMqc0MeAeY/edit?tab=t.0
  - Meet link: https://meet.google.com/gqx-gkvd-qtc

### Feedback / ideas from jas on the topic of policies

https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/90

From jas on sigsum-general, 2025-01-13:

```
I would prefer if tools used a system-installed
/etc/sigsum/trust-policy.conf file with options to disable and/or
override and use a user-provided trust file.  Please don't hard wire
magic crypto values into the binary, it smells of TPM's.

Another idea is to use named self-integrity-protected trust policies
like this:

cat <<EOF > inetutils-sigsum-trust-policy.txt
log 154f49976b59ff09a123675f58cb3e346e0455753c3c3b15d465dcb4f6512b0b https://poc.sigsum.org/jellyfish
witness poc.sigsum.org/nisse 1c25f8a44c635457e2e391d1efbca7d4c2951a0aef06225a881e46b98962ac6c
witness rgdd.se/poc-witness  28c92a5a3a054d317c86fc2eeb6a7ab2054d6217100d0be67ded5b74323c5806
group  demo-quorum-rule all poc.sigsum.org/nisse rgdd.se/poc-witness
quorum demo-quorum-rule
EOF

sha256sum inetutils-sigsum-trust-policy.txt =>
72af4399354bc7803a540999c27d249493f8fd00e74414e0de79e692260df635  inetutils-sigsum-trust-policy.txt

Then that file could be provided in

/etc/sigsum/trust-policy.d/72af4399354bc7803a540999c27d249493f8fd00e74414e0de79e692260df635.conf

and the user could run something like this:

 sigsum-verify
  --signing-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILzCFcHHrKzVSPDDarZPYqn89H5TPaxwcORgRg+4DagE" \
  --trust-policy-hash 72af4399354bc7803a540999c27d249493f8fd00e74414e0de79e692260df635 \
  inetutils-2.6.tar.gz.proof < inetutils-2.6.tar.gz

Assuming the system installed this particular trust policy during
installation.  This avoids you "blessing" any particular trust policy,
but move this on to users.
```

Comment from filippo: if the tool is trusted to know how to verify a hash, then
the hash could just as well be a name that is easier to understand for humans.
