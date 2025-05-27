# Sigsum weekly

  - Date: 2025-05-27 1215 UTC
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
  - rgdd
  - nisse
  - filippo

## Status round

  - rgdd: synced roadmap with folks, see queued up decision below
  - rgdd: tried to rewrite witness configuration network as a proposal, didn't merge yet but the gist of it is in this branch right now:
    - https://git.glasklar.is/rgdd/public-witness-network/-/blob/rgdd/wip/docs/proposal.md
    - worked on two things re. witness configuration network:
      - design
      - readme
  - elias: discussed roadmap things with rgdd
  - filippo: discussed verifiable indexes with Martin
    - verifiable indexes is the obvious next step for CT
    - after static CT API
  - filippo: discussed roadmap
  - filippo: added caching to the tlog client
  - filippo: wrote a library function that can be used to prove inclusion of subtree
  - filippo: wrote tool to partition a log chunk into torrents
  - filippo: for some reason could not get my two clients seeding from eachother
    - need more debugging regarding the seeding things
  - filippo: a magnet link can be used by those who only want to help with seeding
    - rgdd: so either you are just helping to distribute something that someone else has started, or you are adding something new?
    - focus only on the leaves and not on the hashes
  - nisse: discussed problem with witness ssh-agent setup with ln5
    - agent uses a library that talks to the yubihsm
    - fails at startup
    - looking at simple fix to retry a few times
      - to make it work when there are problems around startup
  - rgdd: also did some Transparency Dev Summit things
    - git feedback on the call for papers (CFP)
    - will soon close interest survey and publish the CFP

## Decisions

  - Decision: Adopt updated roadmap until end of august
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/roadmap/archive/2025-05-27-roadmap.md
    - (Sorry about the few TODO placeholders and missing links -- rgdd will fix before merge based on the input you all provided individually when syncing last week.)
    - elias+ln5 milestone -- expected done end of august 
    - most things are continuations of what we have been doing
    - work on shared witness configuration will continue
      - hopefully we can bring that to life now, not just talk about it
      - hope it can be done before Transparency Dev Summit
    - nisse and elias will work on named trust policy things
    - improvements on the monitor code, rgdd will do that
    - elias also has an onboarding milestone with some smaller issues
    - at the bottom of the roadmap there is a summary of progress since Feb 2025
    - due to vacations there is not so much time until August
      - that is reflected in the roadmap
    - rgdd will fix minor things and merge the MR

## Next steps

  - rgdd: fix links in roadmap doc and merge
  - rgdd: merge witness config network proposal
  - rgdd: few more tdev-summit things
  - rgdd: fyi: short week for me, won't be available thu+fri
  - filippo: fyi: will be missing next sigsum weekly

## Other

  - nisse: Docker image "docker.io/library/golang:1.22" disappearing? Used for several  of our CI jobs, including sigsum-go/.gitlab-ci.yml. I have no clue about the namespace for images, would it make a difference to use just "golang:1.22" (which we have in log-go/.gitlab-ci.yml)?
    - it would be good if we could use our own images that we control
    - filippo: we can check on docker hub
    - filippo: the official docker images have started being rate-limited
    - nisse: it looked like the name did not resolve
    - rgdd: we don't have them cached?
    - elias: we will check this and solve it somehow
    - filippo: I can pull that image from my local machine, using that name
    - could be rate-limiting after all, even though the error does not look like that
    - rate limiting is apparently 100 per ipv4 address
  - elias: can filippo's witness start witnessing our new test log barreleye?
    - see barreleye details at https://www.sigsum.org/services/
    - filippo: ok, will do it, doing it now
    - filippo: it is working now
    - elias: yes, it works now, thanks!
  - filippo: about metrics, note that prometheus has problems with some things
    - https://grafana.com/blog/2020/09/28/new-in-grafana-7.2-__rate_interval-for-prometheus-rate-queries-that-just-work/
    - filippo: so they are working around problems, things prometheus is bad at
  - filippo: hetrixtools is good: https://hetrixtools.com/

```
barreleye config notes:
2025/05/27 14:46:57 Added log "sigsum.org/v1/tree/4e89cc51651f0d95f3c6127c15e1a42e3ddf7046c5b17b752689c402e773bb4d".
2025/05/27 14:46:57 Added key "sigsum.org/v1/tree/4e89cc51651f0d95f3c6127c15e1a42e3ddf7046c5b17b752689c402e773bb4d+778629b1+AUZEryq9QPSJWgA7yjUPnVkSqzAaScd/E+W22QXCCl/m".

{"origin":"sigsum.org/v1/tree/4e89cc51651f0d95f3c6127c15e1a42e3ddf7046c5b17b752689c402e773bb4d","size":726,"root_hash":"gTvl5791UKjeiIY3ipW4MN6kFKNgDAjYkjqBbUJjyx8=","keys":["sigsum.org/v1/tree/4e89cc51651f0d95f3c6127c15e1a42e3ddf7046c5b17b752689c402e773bb4d+778629b1+AUZEryq9QPSJWgA7yjUPnVkSqzAaScd/E+W22QXCCl/m"]}
```
