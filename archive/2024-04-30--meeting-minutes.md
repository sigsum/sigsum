# Sigsum weekly

- Date: 2024-04-30 1215 UTC
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
- gregoire
- filippo

## Status round

- filippo: the discussion added in matrix, had a conversation w/ bluesky folks.
  For them to use tlog basically (identity binding -- name to a public key, to
  sign the posts). THinks they have a fantastic use case for a tlog. Recommended
  that they use the storage system they already have, and do spicy signatures on
  it. And make sure to have checkpoints so they can integrate with the witness
  ecosystem once we have something they can start playing with. THey seem
  excited, not anything they will be working on immeaditely but maybe later this
  year. So might align well when witnessing things start taking off for real.
- filippo: chats with martin and al at the trustfabric team. Talked about some
  CT things, and implementation stuff and vkey. Not sure what to do about vkeys
  yet. But we can have multiple implementations. Also talked about the tiles
  API, got around to the concept that not every log needs to expose internal
  merkle tree as an API. E.g., witnessing + spicy signatures -> only need to
  expose the list of entries. And that is already so ecosystem specific that it
  doesn't really matter if there is no universal API to fetch them.
- filippo: ed25519 thing that came up -- interesting thing to think about. We
  already identified the fact that log keys are really just ACL keys for
  witness. Maybe we shoudl go even harder because of this: witness protocol only
  supports ed25519 signed logs. Because logs can anyway sign their log with any
  key they want, as long as they use an Ed25519 key to connect with witnesses.
  - rgdd: similar to what we discussed before
  - rgdd: let's get this reflection documented somewhere
  - the "hence it can be a separate key" part would be nice to document
- rgdd: probably paging back into sigsum ~next week, a bit behind (was hoping it
  would happen this week).

## Decisions

- None

## Next steps

- filippo: witness api and splitting out the tiles api (which martin wants to
  collab on today). Useful thing to think about when you return: do we want to
  adopt tiles API in sigsum?

## Other

- https://docs.google.com/forms/d/e/1FAIpQLSet0fI1e_RNacQqvjf12ec3XceaC9Fk3WT_4isCXuSjzRVFUQ/viewform?usp=sf_link

### Copy-pasted message about the above event (from transparency.dev slack)

transparency.dev Summit planned for Oct 9-11! We are planning a Transparency.dev
Summit event at Google Academy London taking place October 9-11, 2024. This
event aims to bring together implementers, operators, and clients of real world
transparency systems in order to meet peers, share best practices, and learn
about the latest developments in the community. In addition to general
transparency topics, the event will also feature dedicated sessions for the
Certificate Transparency community (e.g a colocated CT day style event). Please
save the date: Oct 9-11, 2024!

We'd like ask folks to fill out this Interest Survey to help shape the event -
whether you are brand new or have been around for a while we'd love to hear from
you.
