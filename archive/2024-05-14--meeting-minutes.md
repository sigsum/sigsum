# Sigsum weekly

- Date: 2024-05-14 1215 UTC
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
- gregoire

## Status round

- rgdd: we're done with our ST releases now, which means we have more time to do
  Sigsum again. In the process of paging things in now.
- filippo: bastion up and running that trust fabric folks can use on sigsum
  host? Would be helpful.
  - nisse: before new witness protocol? would that make sense?
  - filippo: they want the bastion to start testing their thing
  - nisse can have a look at getting the bastion library adopted by logsrv
    software, ping filippo if there are questions about the library or things
    that would make it easier to integrate
  - bastion key configured how? Needs a bit doing/thinking.
- filippo: been going back and forth on the tiles spec, to wrap it up. Esp. how
  clients fetch partial tiles. Think: clients fetch partial and full tiles, so
  log can decide to delete partial tiles once the full exists.
- filippo: client facing key and witness facing key, the trust fabric folks seem
  happy about having the witness ecosystem ed25519 only too (this observation
  helps).
- filippo: application -- message broadcast? E.g., useful for MPC. Don't 100%
  understand what properties the broadcast channel needs here, or what the
  attacker can do if they can selectively hide or fake messages. But feels like
  there should be an application for tlogs here. Because everyone needs to see
  the same lists of messages that were sent. But would probably need technical
  thinking to apply.
- filippo: some chats about sepcs, hoping merge in the next couple of days.
  - nisse: if i want to look at the witness protocol, where is it?
  - filippo: it's in the c2sp PR right now
- nisse: been looking recently at the ssh package in the key manage repo, to see
  if we can move things over there for both sigsum and st.

## Decisions

- None

## Next steps

- rgdd: heads-up, not here next week due to attending a conference. Nisse will
  do the chairing. Let me know if you need anything from me this week.
- nisse:
  - integrate bastion with log server
  - checker job for witnesses
- filippo: i think it's mostly merging specs

## Other

- filippo: in new york, the mullvad marketing campaign is impressive. The color
  really helps, the adds are bright yellow. "Oh, it's one of those". Well done!
