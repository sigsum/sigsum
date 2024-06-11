# Sigsum weekly

- Date: 2024-06-11 1215 UTC
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
- filippo
- nisse

## Status round

- rgdd: not much to report, was a short week last week. I deployed
  bastion.glasklar.is VM, but have yet to also deploy the bastion software.
  - filippo: good, trustfabric folks asked about it this week
- nisse: some improvements to pid-file handling in (key-mgmt) sigsum-agent, MRs
  in review to use it in log-go integration tests, and reference it from log
  docs.
  - https://git.glasklar.is/sigsum/core/log-go/-/merge_requests/162
  - https://git.glasklar.is/sigsum/core/log-go/-/merge_requests/161
- nisse: Improve sigsum-go README
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/182
- filippo: move forward with iteration on sunlight, including impl of the
  witness things. Now the protocol change is being discussed on CT policy list.
  Planning to merge the changes this week (spec). After that can push the impl
  change. Hopefully get deployed next week (rome), and LE whenever they have the
  time to start the logs over.
  - Change what? Align with tile spec in c2sp. So not related to witnessing.
  - Discussion on tlog tiles about key types. Different folks pushing for
    different key types, and filippo is pushing back. Seems like we're landing
    on: you can sign with whatever keys you want, but you must have at least one
    ed25519 key so that witnessed don't have to learn about your key types. Will
    add this to sunlight as well.
  - So this is for tree head sig? Yes
- filippo: good chat with al. There's been sigstore talk for package system.
  Complex, don't want that. Have been talking about branding. It's easy to say
  "try X". But if you are a package ecosystem and you run your own log
  compatible with the witness ecosystem -> a lot longer to explain, harder to
  brand than "try X".
  - Comment: and there are different interfaces in the system. log \<-> witness,
    and spicy signatures.
  - We have good specs for this, but the branding is difficult
  - Is a name needed for this umbrella?
  - filippo: looking back at my talk, "the witness ecosystem" kinda needs a
    name.
  - nisse: one thing we want to name -- is it a user visible proof of logging.
    Witness \<-> log protocol is important, but only cryptographic details that
    matter for users.
  - so focus on spicy signature as the final product?
  - The problem filippo want to solve is: not have to sit done for an hour and
    explain it. Instead want to say "you should consider FOO".
  - rgdd: maybe lets focus on what we want to point at, iterate, and then do the
    name last. Maybe it's the "spicy framework"? The fundemental thing is to
    produce the offline proof. Gossip is not part of the framework. KT is not
    part of it. KT can use it to log SMT tree heads, but it's not like VRF is
    inheneretly part of it. When something needs a bulletin board, then use
    "spicy framework".
  - nisse: more meaningful name, "spicy bulletinboard"?
  - naming last tho.
  - filippo would like to start with the doc now

## Decisions

- None

## Next steps

- rgdd: deploy the bastion host software on bastion.
- nisse: not much the coming week, merge what i mentioned in status round
- filippo: (1) close sunlight run, (2) getting the specs to merge, and (3) start
  putting together the framework doc with ideas of what goes into it.

## Other

- FYI: Apple's post on PCC, Private Cloud Compute. An append-only transparency
  log is an integral part of their arhictecture, which is pretty much an ST
  stack.
  - https://security.apple.com/blog/private-cloud-compute/
