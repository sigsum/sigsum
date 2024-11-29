About go dependencies and the go.mod and go.sum files, Nov 2024

nisse wrote:

Uploaded
https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/219
with a dependency update. See comment for an analysis on why we
despite this update have long outdated versions of x/net listed in our
go.sum.

Related question: It seems common to have a lot more modules listed in
go.sum, than are listed as "// indirect" in go.mod. Why is that, are
the ones in go.mod indirect in one step, while go.sum lists the
complete transitive closure?

elias wrote:

I have also tried to understand this, but so far failed. [...] the
go.sum file [...] matches what is created by the "go mod tidy"
command. But it's not clear to me why all those lines are there.

There is the command "go mod why" that can supposedly find out why a
given module is needed, so at first I thought that doing "go mod why"
for each module in go.sum would give the answer why that line was
there, but for many of them it says they are not needed.

nisse wrote:

There's also some distinction between dependencies for test and
non-test code.

filippo wrote:

I replied in
https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/219#note_21107

tl;dr is that the go.sum has no semantic meaning, and you can just not
look at it

The longer answer is that the module version resolution algorithm
walks the whole dependency tree before selecting the latest version of
each module, so to do that securely it needs the hash of all nodes.

-----

The following is from
https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/219#note_21107:

nisse wrote:

Despite this update, we have versions of x/net from 2019 and 2021 in
go.sum. So this may be an interesting small exercise in software
supply-chain issues.

We depend on github.com/golang/mock@v1.6.0, which is latest
release. mock depends on golang.org/x/mod@v0.4.2, which is outdated
(March 2021). x/mod@v0.4.2 depends on
golang.org/x/crypto@v0.0.0-20191011191535-87dc89f01550, which depends
on golang.org/x/net@v0.0.0-20190404232315-eb5bcb51f2a3.

We also have a chain x/mod@v0.4.2 ->
golang.org/x/tools@v0.0.0-20191119224855-298f0cb1881e ->
golang.org/x/net@v0.0.0-20190620200207-3b0461eec859.

And mock@v1.6.0 -> golang.org/x/tools@v0.1.1 ->
golang.org/x/net@v0.0.0-20210405180319-a5a99cb37ef4

So three different paths from the mock module (which luckily is used
only for our tests) to different long outdated versions of the x/net
module.

filippo wrote:

You can disregard versions in go.sum entirely. It's not a lock file
like in other languages: the only file that lists versions you depend
on is go.mod. go.sum is only a cache of sumdb entries.

You are using golang.org/x/net@v0.31.0 and nothing else. In Go, there
is no way to be using two (minor) versions of the same module at the
same time.

nisse wrote:

Thanks. I feel I don't understand go.sum. Questions:

1. What conditions makes go tidy add stuff to go.sum?

2. From my understanding of go mod graph, there is a dependency chain
like mock@v1.6.0 -> golang.org/x/tools@v0.1.1 ->
golang.org/x/net@v0.0.0-20210405180319-a5a99cb37ef4. If that old x/net
actually is not used in the build, is that because compiler/linker
eliminated all code paths that could reach that code? Or because a
later version of x/tools is selected automatically (but I wouldn't
expect golang.org/x/tools@v0.21.1-0.20240508182429-e35e4ccd0d2d to be
compatible with code that is written for golang.org/x/tools@v0.1.1,
since both are v0.* versions, so that's also a bit puzzling)?

filippo wrote:

There is only one golang.org/x/net and one golang.org/x/tools in the
build. Everything that imports golang.org/x/net or golang.org/x/tools
gets the version in the main module's (sigsum-go's) go.mod.

> I wouldn't expect
> golang.org/x/tools@v0.21.1-0.20240508182429-e35e4ccd0d2d to be
> compatible with code that is written for golang.org/x/tools@v0.1.1,
> since both are v0.* versions

Using v0 modules means indeed that there can be breakages. However
note that golang.org/x/... modules are not "true" v0, they are
maintained with the same compatibility as v1 modules. But yes, in
general using v0 modules is undesirable because of this.

go.sum additionally lists the hashes of some older versions to allow
for the secure exploration of the dependency graph. i.e. how does the
go tool know what minimum version of golang.org/x/net is required by
golang.org/x/tools@v0.1.1?

See https://go.dev/ref/mod#minimal-version-selection
