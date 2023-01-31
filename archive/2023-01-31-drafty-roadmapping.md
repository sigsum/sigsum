# 2023-01-31

Drafty planning notes, read with a pinch of salt until there's something more final.

## Hello

  - rgdd
  - nisse

## Agenda

  - Drafty discussion of roadmap for "at least spring"
  - Get a rough idea of which "Draft: " milestones to propose

## Running notes

Request/fyi from nisse: quick batch-review from Morten on Thursday afternoons
would be helpful.  Just to see what's there and resolve simple MRs + quick look
on the ones that are more complicated.  Morten already ACK:ed and will try it
out.

Q: What would nisse like to see prioritized in Sigsum?

  - Tooling for the differnet roles
    - Submit things
    - Verify sigsum proof
    - Witness (the new witnessing things) + monitoring, either as tools or packages
  - Deploy stable log and witness for use by us and others
  - Would like to work on a minimal backend for the log later
  - Phase out sigsum-debug incrementally in integration test, run with the new tools

Copy-paste drafty roadmapping from rggd in discussion with kfreds:

  - Wrap-up and pollish specifications (filippo, nisse, rgdd, ...)
    - log.md
    - witness.md
    - bastion.md
    - (Probably horizon ~spring)
  - Update witnessing
    - sigsum-py, minimal changes to be an http server
    - log-go, start polling witnesses in state manager
    - bastion-go (filippo)
    - witness-go (filippo)
  - Itterate on tooling and associated libs/formats
  - Demonstrate use-cases (priority: ST)
    - https://git.glasklar.is/groups/system-transparency/core/-/milestones/11#tab-issues
  - Monitor (MVP, then itterate as with tooling)
  - Backlog and clean-up
  - Website, documentation, and fixes based on feedback from users

When the above is done we will likely start transitioning into maintenance mode
and discuss what further development we would like to do and when to prioritize.
Will start documenting some of these future development options when there's
spare time.

## Conclusion

  - nisse: sounds reasonable for the coming ~half a year
  - rgdd: create drafty milestones and circulate
  - rgdd: run planning meet at next weekly
