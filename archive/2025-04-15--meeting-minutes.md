# Sigsum weekly

  - Date: 2025-04-15 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: nisse
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - elias
  - nisse
  - filippo

## Status round

  - filippo:
    - had a walk with Rasmus and discussed a few things, talked about:
      - certificate transparency logs and monitoring them
      - adding metadata to spicy signatures (more about that in other part below)
      - planning for the year
      - "spicy CLI" serverless tool
    - also had a good chat with Al, discussed two things:
      - adding tiles support to trillian frontend
      - you can use tessera as a library in a cli tool
      - so maybe spicy CLI can use tessera as a library
    - also discussed client library and how to make it work
    - unfortunately CT has extra data per entry
      - therefore a different format is used in static CT api
  - nisse: Preparing a Sigsum poster for cysep. See https://git.glasklar.is/nisse/cysep-2025
    - rather happy with it now, will submit it this afternoon
  - elias: Ansible v1.3.0 milestone done, remains to write NEWS entry and release
    - https://git.glasklar.is/groups/sigsum/-/milestones/20
    - so we can now have a secondary for jellyfish
  - rgdd is not here, but we can note that Transparency Dev Summit is in Gothenburg
    - filippo is also helping out with that

## Decisions

  - None (already decided last week that weekly on 2025-04-22 is cancelled)

## Next steps

  - elias: release ansible v1.3.0
    - test with primary+secondary for jellyfish
  - nisse: Submit poster  proposal to cysep
  - filippo: publish tlog-tiles client
  - filippo: then spicy CLI prototype on Tessera
  - elias: update calendar, next weekly cancelled

## Other

  - note: No weekly next week, due to meetup in Stockholm.
  - spicy signature metadata field
    - the interesting part is: feels like there should be a space in the proof for additional metadata where semantics is decided by the application using it
      - example: signing a file where you may want the filename to be authenticated
        - pgp does not do that
        - could be possible to provide a binary for another operating system
        - so, would be good to authenticate the filename
        - the CLI might or might not do that
        - the question now is: where do we keep the metadata that allows us to give the user a helpful error message telling the user that "this fails to verify due to metadata ..."
        - leaf line in the current sigsum proof format
        - needs to be a little more sigsum-specific information in the proof
        - another use for metadata is that it could be a json blob that could contain additional claims
        - those claims could be in the proof and an application could check only one of them
        - all those things could be handled if there was a format that allowed metadata to be added inside the leaf
        - nisse: I think it makes sense
          - if you have sigsum with claims then you would have the claims there
          - filippo: you would hash the claims
        - filippo: it would be tempting to define
        - nisse: you could want the metadata to be the filename
        - filippo: there could be a problem with generating such proofs for existing trees because existing trees do not support that
        - nisse: from the library point of view there would be a callback for the metadata stuff?
        - filippo: two ways to do the API:
            - either the callback captures the context
            - or there is still the concept of a message
        - nisse: some things could be inside the proof, other things outside the proof
        - filippo: the exact design of the API is nuanced
          - a callback that gets metadata, returns hash
          - in the extreme case in which there is no metadata, all it does is it returns the hash
          - so instead of passing the hash you pass a function that returns the hash
          - nisse: I think this makes sense but there are lots of details to consider
          - nisse: on a high level it makes a lot of sense
