# Background

Current repository structure at git.sigsum.org:

    $ tree -L 2
    .
    ├── research
    │   └── README.md
    ├── sigsum
    │   ├── archive
    │   ├── doc
    │   ├── hugo
    │   ├── issues
    │   ├── LICENSE
    │   └── README.md
    ├── sigsum-lib-go
    │   ├── cmd
    │   ├── go.mod
    │   ├── issues
    │   ├── LICENSE
    │   ├── pkg
    │   └── README.md
    ├── sigsum-log-go
    │   ├── cmd
    │   ├── go.mod
    │   ├── go.sum
    │   ├── integration
    │   ├── issues
    │   ├── LICENSE
    │   ├── pkg
    │   └── README.md
    ├── sigsum-tools-go
    │   ├── cmd
    │   ├── go.mod
    │   ├── go.sum
    │   ├── LICENSE
    │   ├── pkg
    │   └── README.md
    ├── sigsum-witness-py
    │   ├── issues
    │   ├── LICENSE
    │   ├── README.md
    │   └── sigsum-witness.py
    ├── sysadm-tickets
    │   └── README
    └── testing
        ├── cmd
        ├── hello
        └── hi

Here's what we don't like about the current structure:

  a) "sigsum" is not an intuitive name for documentation, notes, etc.
  It hogs the top-most namespace and is inconsistent compared to other
  repos (could be "sigsum-docs").

  b) "sigsum" in all repo names is redundant.  We already have all
  repositories grouped at git.sigsum.org.  Go module names have
  redundancy too (git.sigsum.org/sigsum-lib-go).

  c) unclear where everything "not log server and not sigsum lib"
  should be placed.  Both now and as we keep adding more tools and
  other running components like monitors.

# Proposal

  1. Keep "sigsum" repo name.  We shared many links to this
     repository, avoid breakage.

  2. Move towards generic repositories, per language.

     - sigsum-go, "lib + tools that in the long run don't pull in the whole world"
     - log-go, "depends on sigsum-go, pulls in other log server specific stuff too"
     - sigsum-py, "witness + tools"

  3. Remove repos "research" and "sysadm-tickets".  No use or planned usage.

Connecting this to the problems we had with the current repo structure:

  c) Rule of thumb is to place <lang> stuff in sigsum-<lang>.  If
  there is a reason not to, break it out into a separate repo without
  "sigsum" in the name.  E.g., log-go and monitor-go, both of which
  will likely have to be more permissive about dependencies.  It is
  crusial that generic repos are easy to use, reuse, pull-in, review,
  and maintain.

  b) Fixed to some extent.  One strength of the new structure is that,
  e.g., sigsum-go signals that "this is where you should look for
  sigsum stuff in Go".  We expect that most newcomers will be more
  interested in the lib or tools rather than Trillian stuff. If you
  are looking for "not the generic stuff", you probably know where to
  go already.

  a) Not fixed.  There will however be relatively few repositories
  that don't have a language ending (-go, -py, etc).  This likely
  signals that "this is a sigsum portal".  This is further mitigated
  by good repo descriptions on the listing at git.sigsum.org.

The plan is to do the above restructuring after our v0 API changes are in place.

# Examples

An import in log-go:

    import "git.sigsum.org/sigsum-go/pkg/types"

Installing the sigsum tool:

    $ go install git.sigsum.org/sigsum-go/cmd/sigsum@latest
