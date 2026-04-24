# Proposal on how we select Go version

## Background

Our current practise is to select Go version based on what's available in Debian
backports.  The original intent for this policy can be summarized as follows:

* Have a clear guideline for when it's OK to start using new Go features
* Make installing a Go compiler that works easier (i.e., not *too new*)
* Make Debian packaging easier (at least we thought we were helping here, in
  reality [Debian packaging ignores the Go version we declare][jas]); and by
  extension make it easier to get security updates from Debian (at least we
  thought we were getting this, in reality [there is no such promise][jas] but
  it might still happen for individual packages on a [case-by-case basis][jas])

This current practise has been causing friction lately:

* We're stuck on Go 1.24, which is not a supported Go version anymore.  In the
  past, we've usually had a supported Go version available in Debian backports.
* Several of our dependencies require Go 1.25, e.g., [golang.org/x/net][].  Even
  though it might not be a problem to stay on an older dependency version right
  now, it could become a problem in the future if there are security fixes.

Since our current practise is mostly based on *making it nice and easy on Debian
and then it probably works kinda smooth in other places too*, we asked for
[pointers from jas][jas] who packaged sigsum's Go software in Debian.

This proposal takes these pointers onboard.

[jas]: https://git.glasklar.is/sigsum/project/documentation/-/work_items/96
[golang.org/x/net]: https://git.glasklar.is/sigsum/core/sigsum-go/-/issues/175#note_31713

## Proposal

Select go.mod Go version based on *the oldest version of Go that's still
supported by the Go team*.  Right now, this means selecting Go version 1.25.

Think twice about using newer language features, since this will cause friction
for packagers that may not be using the same Go version in their builds.  Our
current pointer is to not use any Go language features that require Go >1.23.

## Discussion

We start by using the *oldest supported Go version* to see if that solves our
problem.  Let's revisit if this still causes friction with our dependencies, in
which case we would likely start using *newest supported Go version* instead.

Note that declaring more recent Go versions causes less friction with users and
developers these days, since Go's tool chain can automatically update itself to
the appropriate version.  This might sound scary, but as a silver lining these
updates are at least transparent and can be reproduced by [monitors][].

---

This proposal should not be read as: we can never use new language features.
But we should be intentional about using new language features that causes
headaches and/or incompatibilities for packagers.  To make it easier to detect
when this happens, we have a [CI job][] that detects Debian issues early.

---

This proposal should be consistent with the pointers we received from jas:

>
> 1. You should feel free to bump go.mod to latest Go stable version whenever
>    you want.
>
> 2. You should monitor the debian pipeline jobs to make sure code still builds
>    in the debian trixie and forky environment.
> 
> [snip]
> 
> I think you need to decide which Go compiler version you will want to support,
> not which version to put in go.mod
>

[monitors]: https://youtu.be/W7r670cfFoo?si=TbGh9pLvrHHP90_W&t=1557
[CI job]: https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/307
