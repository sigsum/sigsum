# On specifications and governance

## Proposal

We should donate specifications that are useful outside of the Sigsum system to
the broader open-source software community.  These specifications will then be
maintained and developed further by us as well as other community contributors.

The specifications to be donated and maintained are:

  - **Cosignature**: maintained by Glasklar Teknik AB (rgdd), Independent
    (filippo), and Trust Fabric (al).
  - **Witness protocol**: maintained by Glasklar Teknik AB (rgdd), Independent
    (filippo), and Trust Fabric (TBD, first we contribute what we have now).
  - **Bastion protocol**: maintained by Glasklar Teknik AB (rgdd), Independent
    (filippo), and Trust Fabric (TBD, first we contribute that we have now).

Other related specifications we rely on and/or maintain are:

  - **Note**: maintained by Independent (filippo) and the Go team (rsc).
  - **Checkpoint**: maintained by Trust Fabric (martin), Independent (filippo),
    and Glasklar Teknik AB (rgdd).

We might want to donate additional specifications in the future, such as a
trust-policy format specifying rules for which logs and witnesses to depend on
and a proof-bundle format useful for offline verification.

To have a platform that is more stakeholder-neutral to meet and work on, we will
use [C2SP][].  The process of developing and maintaining a specification will
be:

  1. Open an issue in C2SP's issue tracker.  The filed issue describes a
     proposal to change a specification.  Anyone can file such proposals.
  2. The proposal is discussed by commenting and possibly updating the issue to
     reflect any suggested changes.  Anyone can be part of the discussion.
  3. The appointed maintainers of a specification eventually accept or reject
     the proposal by commenting in the issue.  It is implied that the decision
     can be motivated by the public discussion that happened in the issue.  In
     other words, the gist of any out of band conversations should be conveyed.
  4. A pull request is created that reflects the proposed changes.  If it makes
     sense to have a pull request while still discussing the proposal, file one.
  5. Once a proposal is accepted, a maintainer merges a corresponding pull
     request.  If a new version of the specification should be released, a
     maintainer will do that by requesting a scoped SemVer git tag (like
     `spec-short-name/v1.2.3`).  These tags are currently created by the C2SP
     stewards, and will be automated in the future through GitHub Actions.

The expectation of a proposal is that it describes:

  1. What to change in a specification and why.
  2. How it is different compared to today.
  3. Pros, cons, trade-offs, alternative solutions, or other relevant analysis.

For a proposal to be accepted, the appointed maintainers should have a rough
consensus among themselves on how to move it forward and why.

That the maintainers use these processes will be described in a dedicated file
at `CONTRIBUTING/tlog-specs.md` in the C2SP tree, which we will request from
C2SP upon requesting the spec name assignments. A table in the main
`CONTRIBUTING.md` file will map our specifications name to this file.

## What are we doing today

Proposals are filed on Sigsum's self-hosted GitLab instance as merge requests,
see [proposals directory][].  Proposal discussion mainly occur in merge requests
by commenting in-line.  We try to update the pending proposals to reflect the
discussion.  Sometimes, we link back to a lengthy merge request if helpful.

Some proposals are more complicated than others.  If it is helpful to discuss
with higher bandwidth, we usually do so on Sigsum's open weekly meets or on
private virtual walks.  We make notes of these conversations public, so that
others can follow along and we can remember later why we decided on something.

Once there is a rough consensus among the active Sigsum contributors, we decide
to move a proposal forward on Sigsum's open weekly meets.  By the time such a
decision is made, it is a formality as the work has been done between meets.

"Rough consensus" usually means there are no concerns that haven't already been
discussed and weighted into the decision of (not) moving something forward.  In
other words, we can at minimum agree to disagree and then move forward united.

Proposals can be filed by anyone.  Similarly, anyone can take part in the
discussion or just follow along by reading meeting minutes and merge requests.
Sometimes suggestions are brought into our specifications via a proxy, e.g., the
Trust Fabric team have suggested improvements by just talking to us out of band.

We recently started announcing specifications.  So far, the Sigsum log server
protocol have been announced.  This boils down to following the open process
summarized above, creating a git-tag, and sending an email to sigsum-announce.

There are a few more [release principles][] for announcing v1 specifications,
e.g., the specification has been implemented and tested, any future changes that
are not backwards-compatible will be communicated well in advance, etc.

## A brief analysis

First of all, note that this proposal is heavily scoped to a finite set of
specifications.  All other aspects of Sigsum and its processes remain the same.
For example, the Sigsum log server protocol stays where it is, and we will
continue to prepare proposals and make decisions as usual for other things.

Secondly, what we are trying to achieve is maximizing the probability that we
end up with an interoperable witnessing system.  For example, this is why the
name "sigsum" was stripped from the cosignature namespace; why no other parts of
the witness protocol says "sigsum"; and why we made the witness protocol more
checkpoint-like. The transition to develop and maintain some specifications in
C2SP can be viewed as yet another step to maximize the outcome that we want.

The choice of platform, i.e., C2SP's GitHub repository, is motivated by the fact
that it is convenient for the key players that are collaborating right now.
It is a more stakeholder-neutral home, rather than conducting the conversation
in Sigsum's existing forums: email, IRC/Matrix, GitLab, weekly meets, etc.  We
considered if we should set up a completely new forum for the emerging
witnessing system, but decided against it because it introduces significant
overhead.  The gist is that C2SP is already there, and the parties that are
relevant right now can do the work there.

This may exclude some contributors that don't want to register a GitHub account,
as they can currently interact with Sigsum's forums in a variety of ways like
email, IRC/Matrix, Jitsi, or registering a GitLab account with more than one
identity provider (e.g., including GitHub).  To the extent that we have such
contributors, we are more than happy to have the conversation with them in our
forums and then proxy that into the conversation happening over at C2SP.

It is also worth calling out that not much is going to change with regard to our
existing asynchronous work flows.  In other words, we will continue to file
proposals and process them similar to today.  The main differences are:

  1. Proposals that concern the donated specifications will be fully contained
     as GitHub issues in C2SP's repository, i.e., not a mix of merge request
     discussions and files committed to Sigsum's GitLab which is the case today.
  2. No formal decisions on weekly Sigsum meets regarding the donated
     specifications.  These decisions will instead be fully asynchronous, and
     considered decided when the appointed maintainers say so on GitHub/C2SP.
     This also includes meta decisions, such as adding or removing a maintainer.

     (It is likely a good idea for the appointed maintainers to not accept
     proposals too quickly, so that the broader community have time to comment.
     This is largely why Sigsum enforces formal decisions on weekly meets.)

With regard to announcing specifications, the differences are:

  - New versions will be tagged in the C2SP repository, and not necessarily
    announced on Sigsum mailing lists.
  - We will not render the donated specifications on www.sigsum.org.  That said,
    we will (like others should) link to them and point out our involvement.

In terms of governance, the C2SP stewards have no practical power over who
maintains a specification.  If they do something inappropriate, the maintainers
of a specification can simply move to a different platform.  In other words, we
see no risk of moving specifications into C2SP and doing the work there because
implementers will follow specifications and maintainers that are reasonable; not
blindly implement any specification just because it is hosted by C2SP.

The same argument applies to maintainers.  If the appointed maintainers do a
poor job, implementers will stop implementing the specifications they produce.

[C2SP]: https://github.com/C2SP/C2SP
[proposals directory]: https://git.glasklar.is/sigsum/project/documentation/-/tree/main/proposals
[release principles]: https://git.glasklar.is/sigsum/project/documentation/#release-principles
