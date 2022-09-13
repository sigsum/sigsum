Proposal to replace cgit with GitLab.

# Background

As more people are getting involved in Sigsum we need better tooling for issue
tracking and merge requests.  We discussed and tried some light options before:

  - [git-bug](../archive/2022-05-31-notes-on-git-bug), not mature enough
  - [git-appraise](../archive/2022-06-28--meeting-minutes), we didn't try much
  - Mailing list, we have it (and will continue to) but it is not used much
  - [etherpad](https://pad.sigsum.org/p/sigsum-db), current ad-hoc solution due
    to the lack of a good issue tracker and merge request tool.  Requires a lot
    of work because it is manual, has poor overviews, etc.  We similarly have a
    [milestone pad](https://pad.sigsum.org/p/sigsum-ms) which works pretty well.

We [selected cgit](../archive/2021-06-21--meeting-minutes) 14 months ago because
it is low-effort to self-host.  We were so few people that we did not have a
large need for full-blown issue tracking and merge request flows.  We were also
unsure if we would ever need this.  For example, a mailing list might have been
sufficient and we erred on the side of starting as simple as possible.

Other than cgit, the two options that we considered free enough
[were](../archive/2021-06-21-self-hosted-services):

  - Codeberg
  - GitLab

Most of us are more familiar with GitLab from other project involvement.

# Proposal

Migrate our repositories to a GitLab instance that is self-hosted.  Shut down
cgit.  The main downside is that links used in past presentations will break.
This is why we [did not rename](./2022-04-restructure-repositories.md) the
current repository named sigsum, which we would like to be "docs" or similar.
So, this proposal means that we will make this "breaking link change" anyway.

We are not aware of any Sigsum deployments that will be inconvenienced by this.

Below is a preliminary GitLab structure for the top-most group "sigsum".

  - admin ("ansible, operations, etc")
    - testing
    - checker
    - etc.
  - core ("sigsum source code")
    - log-go
    - sigsum-py
    - sigsum-go
  - project ("documentation, website, etc")
    - documentation (archive, specs, proposals)
    - www.sigsum.org (current Hugo source)

I.e., "admin", "core", and "project" are subgroups.  We split the current sigsum
repository into "documentation" and "www.sigsum.org" (i.e., website).
