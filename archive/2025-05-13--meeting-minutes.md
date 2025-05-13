# Sigsum weekly

  - Date: 2025-05-13 1215 UTC
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

  - rgdd
  - elias
  - nisse

## Status round

  - elias, rgdd: witness and seasalp about pages are no longer marked with "DRAFT"
    - https://git.glasklar.is/glasklar/services/witnessing/-/blob/main/witness.glasklar.is/about.md
    - https://git.glasklar.is/glasklar/services/sigsum-logs/-/blob/main/instances/seasalp.md
    - good progress!
    - we did get feedback that additional info about physical security would be good to add --> nisse will create issue about adding that
  - nisse: tested the sigsum tools some more in the context of the ST project
    - created issue https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/125
      - "Let sigsum-submit discard (and overwrite) invalid existing proof files."
      - probably ok to change default behavior in that case
  - rgdd: worked more on "public witness network" repo
    - https://git.glasklar.is/rgdd/public-witness-network
    - working on suggestion for format of "list of logs"
    - clarification about "goals" vs "non-goals"
    - should there be some kind of a knob for "manual action needed" in that format?
    - something like "major version change" for the list?
    - there is a tradeoff between:
      - making things easier for witness operators
      - avoiding the "list of logs" becoming seen as too much of an "authority"
      - may be better to just have additional info via mailing list
    - also considering whether maintainers should add signatures for the list
  - rgdd: preparing next sigsum roadmap
  - elias: sent sigsum ansible release announcement to sigsum-announce mailing list
    - https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-announce@lists.sigsum.org/thread/2NGD4RI4NNBXIG7UB66QLZ2H3EZDESNB/
  - elias: our bastion host now uses litebastion from filippo.io/torchwood v0.5.0 instead of the old filippo.io/litetlog v0.4.3 (because the litetlog repo has been renamed to torchwood)
    - https://git.glasklar.is/sigsum/admin/ansible/-/blob/main/roles/litebastion/defaults/main.yml?ref_type=heads#L2-3

## Decisions

  - None

## Next steps

  - nisse: File issues based on meetup feedback
  - rgdd: wrap up "public witness network" repo so that there is a draft ready to discuss with others
	
## Other

  - nisse: bastion everywhere?
    - witness operator may not want the witness to be open to the world
    - how to support "serverless logs"?
    - should github then run their own bastion for their CI jobs?
    - rgdd: there could also be a 3rd-party bastion with some kind of auth
    - rgdd: if you do not yourself have a public endpoint then you need to handle it somehow
    - rgdd: when adding a log to a "list of logs" that witnesses can configure, that should also involve adding info about a bastion to use
    - nisse: from the witness side, is it a problem to have to connect to different bastions?
      - nisse: could there be a "reverse bastion" so that witness only listens to localhost?
      - nisse: but then one can ask: have things become too complicated with one bastion at one end and another bastion at the other end?
      - should there instead be some other kind of tunnel?
        - like a wg tunnel between log and witness?
     - rgdd: if you have a log without a public endpoint and also a witness without a public endpoint, then that has to be solved somehow
     - rgdd: I may have liked the idea of a "reverse bastion proxy"
       - abstraction for all the needed reconnect logic
       - then you can write a witness that is only a witness
     - interesting, but also interesting to see how much extra complexity it would be in the witness if that functionality were to be added in the witness
     - nisse: it is certainly doable to integrate it in the witness
       - but having a simpler witness has advantages, like not needing a TLS stack
     - rgdd: it fits nicely in the "list of logs" that a bastion can be specified there
     - rgdd: if the log has a public endpoint, then it is reasonable that it has a bastion
       - if the log does not have a public endpoint then a different bastion is needed
     - rgdd: bastion is always optional from the witness side, a witness can always choose to be on the public internet
     - when a log operator asks a witness to witness the log, the log operator needs to specify which bastion the witness should connect to
     - it is desirable that each log has a bastion that witnesses can use to connect to that log
     - witnesses can choose to have a public endpoint if they can handle DoS
     - for witnesses. two options:
         - using public endpoint, must be able to handle DoS attacks
         - not using public endpoint, can only witness logs that have bastion
  
  - rgdd: question about signed list of logs:
    - example: if there are 3 maintainers for the "list of logs"
      - each of them have their own separate key
      - imagine someone using the list, checking that list is signed by one of the maintainers
      - after a year or something, verification fails because there is now a 4th maintainer that has been added and signed the list
      - risk: if the new maintainer only signs sometimes, the list will seem to mostly work, so it leads to an unclear state
      - nisse: also a question: how to get the new signing key?
        - if the fetching of new signing key is also automated then what's the point?
        - rgdd: good point
