# Sigsum weekly

  - Date: 2023-05-30 1215 UTC
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
  - Foxboron

## Status round

  - rgdd: test filippo's witness stuff
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2023-05-30-litenotes.md
    - (filippo made his own TODO list based on this when we met in-person last week)
  - nisse, rgdd: tillitis hackaton, see wip prototype that uses sigsum
    - https://git.glasklar.is/nisse/tkey-sign-if-logged
    - https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/52
  - nisse
    - python witness error handling refactor in review:
      https://git.glasklar.is/sigsum/core/sigsum-py/-/merge_requests/22.
      Preparation for turning witness into a server.
    - Fix for witness status codes in review:
      https://git.glasklar.is/sigsum/core/log-go/-/merge_requests/133
    - Next step on editorial improvements to protocol specs:
      https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/39
    - Looking into merkle tree extension to batch inclusion proof (+ refactor).
      See https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/40
    - Implementation of cosignature versioning:
      https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/127
    - Foxboron: Witness config, it works (but found regressions in ansible!)
    - Foxboron: Mock thingie
		
## Decisions

  - Decision: Cancel meets due to holidays
    - Cancel June 6 (next week)
    - Cancel July 11 and forward, restart weekly meets on September 5
    - Push next planning meet (roadmap+milestones) to September 12
    - If you need an adhoc meet during the summer, please coordinate on
      irc/matrix and take notes that get archived so others can have a peek
      async (/once they are back).  You can get rgdd's attention on tuesdays up
      until and including August 1.

## Next steps

  - fox: look into why ansible is failling "regression", morten will figure out
    change log and give linus a tag for testing on poc.sigsum.org.  (Adding
    draft changes to the change log seems to make sense when adding commits).
    Sounds like we want a release candidate tag.
  - nisse: sort out merkle tree stuff (now that i get it), then back to python
    witness
  - rgdd: more feedback
  - filippo: check nisse's review request, and add missing get-tree-size in
    litewitness
    - (requests from those that attended the meet.)

## Other

  - Possibly updating our meet structure?
    - Why? It was invented when we did not have issues/milestones ("gitlab")
    - 1. Hello ("hi hi, how r you")
    - 2. Decisions ("decisions are prepared, we work in between meets")
    - 3. Round table ("what i'm doing, briefly, both past/present; do i need any
         help; do I have anything that needs to be discussed with higher bw")
    - 4. Other ("opened-ended, some people may leave after 3")
    - nisse: makes sense, working reasonable well as is too though
    - fox: reasonable
    - rgdd: ok, will try and write up a quick proposal
  - Merkle tree test vectors for CCTV
    - https://github.com/C2SP/CCTV
