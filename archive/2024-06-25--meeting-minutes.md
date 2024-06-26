# Sigsum weekly

  - Date: 2024-06-25 1215 UTC
  - Meet: https://meet.sigsum.org/sigsum
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
  - ln5 (async)

## Status round

  - ln5: On the choice of email address for witness registration with a bastion:
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2024-06-25-on-witness-registry-email
  - ln5: email address for registering your witness with bastion.glasklar.is
    - witness-registry (at) glasklarteknik (dot) se
  - rgdd: litebastion ansible role is publicly availabe now
    - https://git.glasklar.is/sigsum/admin/litebastion
    - bastion.gis runs git-tag v1-rc2, configured with my + trustfabric's test
      witnesses
    - It might be more appropriate to have a monorepo of sigsum-related ansible
      roles. I did not go down this path to keep the scope down. E.g., would
      require understanding how collections work, and also to do the merging
      with the logsrv ansible role. I wanted to focus on just getting the
      litebastion ansible role working and tested with molecule.
  - rgdd: continued piling up metrics requests for litebastion
    - https://github.com/FiloSottile/litetlog/issues/5
  - rgdd: added/extended my hacky witness config notes in the archive
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2024-06-18-litewitness-systemd.md
    - at some point i would like to write an ansible role for this as well
  - rgdd: read filippo's notes, put down some comments below
  - filippo: worked on getting ppl connected for bastion. Good chats with
    trustfabric folks. Think we're aligned now on claimant model and the space
    for it. We agreed the claimant model is as simple as it gets when you try to
        describe something as complex as CT. When log is distinct from claimant
        etc. And agreed we can probably build something simpler for the avg
        case, where the log operator is the same as the claimant and it is just
        adding things to its own log.
  - filippo: chat with hayden, think we have shared view of an ideal world.
    Couple of things we aligned on - ed25519 for witness support. He seems happy
    about that. One log per application is a nice deployment model. Don't
    actually need multiple logs for pypi. When there is a central database
    anyway. And if that goes down, you have a problem. And it is not
    transparency related. And moreover, hayden 
  - filippo: also talked about witness spec. Seems align on submission part, not
    roaser part. But that is TODO, we know it already. And problem for offline
    logs that don't have a slow endpoint. Something we need to fix. Maybe link
    old discussion of roaster and nisse's writeup. Then get something merged in
    c2sp.
    - nisse: might be useful to make it a requirement spec first, what problem
      is the roaster trying to solve.
    - filippo: so for now we will take out roaster and describe problem and
      write TODO, and get what we have merged.
  - filippo: hayden also seems into the sync model of witnessing
  - filippo: transparency-dev summit call
  - filippo: checked in the friction doc in our archive
  - nisse: wrote some initial notes on the friction doc MR, but haven't look at
    it again

## Decisions

  - None

## Next steps

  - rgdd: page in deployment of stable sigsum log with linus
  - filippo: take the roaster out of tlog witness spec. Try to land tlog tiles
    and tlog witness specs. We seem to know all the steps now, no more alignment
    needed. That way, have the specs before PETS.
    - (PETS is 15-21 july. So after gophercon, 7-10 july)
  - filippo: want to think about the litetlog repo. Will try to do a cycle on
    this. Both looking at the issues, the metrics, etc. And figure out if it is
    a good living place for this software or not.
    - rgdd: litebastion and litewitness together, could be branded as sync
      witness
    - filippo: think want witness to be a library too, to be used in sunlight
  - nisse: vaccation, see you august

## Other

  - litebastion, option to support lockdown of what paths backends are allowed
    to use?
    - Worried bastions become part of the upgrade story, but maybe overworrying.
    - Might require monitoring the traffic going through, not only the URLs.
      "Something that looks like a valid witness request"
  - Discuss filippo's notes on applying sigsum for age releases
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2024-06-19--filippo-friction-log.md
    - nisse: https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/76
    - rgdd: https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2024-06-25-on-friction-comments
    - See running notes below. I think what we'll do is just go through the doc
      and take notes. The above links is what nisse and rgdd wrote down before
      the chat.

### Discuss filippo's notes on applying sigsum for age releases

https://git.glasklar.is/system-transparency/project/documentation/-/blob/main/archive/2024-05-03-rgdd-release-signing-notes.txt

Can we pass two verify keys to sigsum-verify?
- not right now (we think), but it shouldn't be hard to add

https://github.com/FiloSottile/age?tab=readme-ov-file#verifying-the-release-signatures 

Seems like we're agreeing. Main discussiion points.
- Monitoring, we agree there's work to do and that's longer term. In the short
  term we can probably move around the getting started doc to make it a little
  more clear.
- Some editorial stuff, we agree on it. And minor UX things, we can hash out
  offline.
- Disagreement on if default for verify should be quite or verbose. Argument for
  verbose: if just run the things in age readme, we want to know it succeeded.
  Esp. if we start supporting multiple keys, then we want to know which key.
  Maybe even room for training users, "verified it was incvluded in the log,
  cosigned by this witnesses. Yay".
- nisse agrees this makes sense, and there could be a quite option for making it
  quite.
- rgdd likes this as well.
- getting started keeps using key files, and mention ssh agent without actually
  using it.

nisse: i have an email on a tkey app/backup
- https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-general@lists.sigsum.org/thread/V3DLTPCBHXBBBOT6AUTOX2PKPQPTFD4V/

Trust policy. And the linked issues.
- filippo likes the idea of named policies. Originally was gonna suggest default
  policy that ships with the tool, and a way to override it if you want.
- would like it built in, not even packaged. Messing with files is a bit
  annoying. Nice to go install and it just works.
- But then reading your conversation and updating policies. Was thinking even
  nicer: named policies. Like "sigsum-202406". And tool comes with number of
  named policies built in. Then there's a folder where you can put more
  policies. And file name -> the name of policy. Just like the builtin. We could
  use the ssh public key comment field to say which policy this public key is
  tied to. So for example, in age documentation could declare it. Then
  sigsum-verify would know what policy to apply to that public key. Think that
  works because these things have to stay verifiable offline forever. And the
  pubkey is trusted. If they can change it -> its over
  - nisse: so it's trust policy in pubkey, but with a level of indirection
  - nisse: issue of indirection is if the meaning of the name somehow changes
    over time. If you would want some hash of the policy to tie it down.
  - Reason why like name: then works with the override. And trust map in the
    code makes sense -> otherwise we have bigger problem if sigsum-verify is
    broken. The custom ones are a bit by definition "changeable". So maybe
    feature and not a bug that they can change over time.
  - Change key and change policy, kinda the same from a verifier perspective?
  - nisse: think we should think of the semantics, and then may or may not use
    the ssh public key format with the meaning in the comment.
  - nisse: could just get the policy file and install it under the custom
    policy, to not need to update the software?
  - moving part of fetching a list -> could be a can of worms. There's already a
    trusted channel: however the tool is installed. Package system, go install,
    or something else. So using this trusted channel, might as well use it.
    Other trusted channel is public key in README, that has to be trusted
    otherwise its over.

nisse:
- Multiple verify-keys on the command line is one option.
- Think would be straight forward with file with multiple keys
- Doubt I can complete it in a reasonable way the next few days, given that I'm
  doing ST things as well.
- Filippo can make an MR.
- Nisse think it makes sense with one key per line

rgdd will make/update issues based on all comments. But not today.
