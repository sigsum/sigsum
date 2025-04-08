# Sigsum weekly

  - Date: 2025-04-08 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: rgdd
  - Secretary: elias

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
  - filippo

## Status round

  - rgdd: had the guest lecture as mentioned last week, slides:
    - https://git.glasklar.is/rgdd/yh-25/-/blob/main/handout.pdf
    - mostly webpki and CT (certificate transparency), not mush sigsum
  - rgdd: tdev summit things, we're working on interest survey / cfp / save the date post
    - thanks for the early eyeballs elias !
  - rgdd: did a preliminary sync with kfs, have a public witness network / shared conf session booked for later this week
    - in progress, will talk more later this week
  - rgdd: misc input/review to elias/nisse, e.g., cysep poster and ansible stuff
  - rgdd: heads-up i will not be working 12-21 april, so if you need something from me that can't wait ensure you get it this week
    - can nisse chair sigsum weekly next week?
      - sure
  - elias: Worked on Ansible v1.3.0 milestone
    - https://git.glasklar.is/groups/sigsum/-/milestones/20
    - only one issue remaining there now
    - would be nice to get jellyfish running with secondary on same machine after the final issue is done
  - elias: minor website change (change was done by ln5 before but not deployed)
    - https://www.sigsum.org/services/
    - now mentions stable witness there, not only test witnesses
    - elias: will make an MR with another minor change there
  - nisse: Merged sigsum support in stboot.
  - nisse: Working on cysep poster
    - week-long KTH summer school
    - will not be there the whole week but probably one day
    - https://cysep.conf.kth.se/call.html
  - nisse: about TKey, we have rough plan to use TKey for log and witness to have the TKey do consistency proof
    - a new version of TKey is upcoming
    - flash storage of 128KB
    - expected to survive at least 100 000 erase/write cycles
      - can write sequentially and re-use only when coming back to the same bits
    - filippo: we could have software for it, where most storage is outside the tkey and only small storage needed inside the TKey, to get improved performance and lifetime
    - rgdd: a TKey could be like walking around with a merkle tree in your pocket
    - filippo: a possibility is that if each signature is slow, one can collect many signatures into a merkle tree and just sign the tree head
  - filippo: pushed vkey spec, which is super tiny as expected
    - https://github.com/C2SP/C2SP/pull/119/files
    - rgdd and nisse will take a look at it
  - filippo: preparing a tlog client
  - filippo: playing with spicy cli
    - similar to tiles format
    - prototype that I presented a year ago
    - serverless log
    - keeping all entries on the file system
    - produces spicy signatures
    - monitors can download the entire history of the log that is on the file system
    - two things:
      - two bits of metadata in the leaf:
        - index (easy)
        - space for metadata
          - for example, saying which architecture or OS an executable is for
          - the spicy signature format would need a place for that info
          - just use the filename for that?
          - put it just in the leaf?
          - should the spicy signature format have a place for that?
        - nisse: there are two things you need to couple:
            - metadata
            - a policy saying what metadata you are expecting
        - filippo: we cannot put things like "version" because users may have different ideas about what a version number means
          - filippo: filename can be used, but what if the filename changes
        - nisse: you can have a machinery, sounds like that could be a regex thing
        - nisse: put the policy together with.. (?)
          - filename would go into the leaf and into the spicy signature
        - nisse now we have just witnesses and logs in the policy
        - filippo: if it's "I want this exact filename", then..?
        - nisse: could be a regex
        - filippo: have to use different public key for each metadata thing I'm signing?
        - nisse: you could have different public-key files with different attributes, but for the same public key
        - nisse: the important thing here is: is regex on filename a powerful enough mechanism, or is simething else needed?
        - filippo: in case of apt it already knows what the filename is expected to be
        - rgdd: metadata options:
            - filename
            - metadata in a separate file (when proof moves around that needs to go along)
            - third option: specify on the commandline "I'm expecting this and that"
        - filippo: you could default it to the filename, and allow people who want more control to use the CLI option
        - rgdd: having a separate file for metadata could also be okay
        - rgdd: sounds like a good default to use the filename
          - if you don't use the filename, then allow commandline or separate metadata file options
        - filippo: the log also needs to be stored
        - filippo: the filename could be "index-metadata" like "0000001-metadata"
        - filippo: this means putting the metadata in the proof?
          - rgdd: either it's in there or you have a hash
          - nisse: it should be easy to reconstruct the leaf
        - filippo: want to be able to say "this thing verifies for this metadata"
        - rgdd: so when verification fails, there could be a hint saying "this would have worked for the following metadata: x"
        - filippo: for the same reason we don't put public key but instead hash of public key, it could be argued that it's problematic to have metadata?
        - nisse: two different usecases I think:
          - one is: you have a filename and you know exactly what to expect
          - the other: something more complex
        - filippo: the metadata bits are in the log

## Decisions

  - Decision: Cancel weekly on 2025-04-22 due to in-person meetup in Stockholm
     - rgdd will update calendar

## Next steps

  - rgdd: more rwc catch up / public witness network / etc with filippo
  - rgdd: more public witness network / shared conf with kfs
  - rgdd: more tdev summit things with martin/tracy
  - rgdd, nisse: take a look at vkey spec (see link above)
  - elias: finish Ansible v1.3.0 milestone
  - rgdd will update calendar for the cancelled meet
  - nisse: Make draft poster
    - will post a link in sigsum room when there is something to look at
  - nisse: will also look at filippo's vkey spec
  - filippo: playing with the spicy format and the cli
    - target is to handle small cases, like 1000 log entries, not millions
    - monitors would download everything

## Other

  - elias: should we link to seasalp about page from www.sigsum.org ?
    - https://www.sigsum.org/services/
      - nisse:  Makes sense to link to all known (public) sigsum services. Including link to appropriate about/operations page for each service. And I think the services page is a reasonable place for that.
        - elias: after talking to rgdd about it, maybe better have that on glasklar webpage? Not sure.
        - added links to log and witness about pages at https://www.glasklarteknik.se/
    - https://git.glasklar.is/glasklar/services/sigsum-logs/-/blob/main/instances/seasalp.md
    - make it easier to find seasalp about page from www.sigsum.org ?
    - elias: https://www.sigsum.org/services/ now shows one stable witness
      - should other stable witnesses be listed there also, not only the glasklar one?
  - ptr for nisse on tikz + merkle trees
    - https://git.glasklar.is/rgdd/yh-25/-/blob/main/img/mt.tex
