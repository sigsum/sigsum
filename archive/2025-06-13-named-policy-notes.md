# 2025-06-13 - Notes about built-in named policy functionality

Below are notes about the current plans to add named policy
functionality, written by Elias with help from Nisse.

The plans might still change, this just shows what the plans are right
now.

## Affected programs

Programs that should have this functionality added:
  - sigsum-submit
  - sigsum-verify
  - sigsum-monitor

All three programs are part of the sigsum-go git repo, so the
functionality can be implemented in that repo as code used by all
three programs.

The changes below are to be done for each of the three programs, so
that they all behave the same way with respect to the named
policies.

## Using the existing policy argument

Currently, all three programs accept a `-p, --policy=policy-file`
option, that should still work in a similar way as before, but we will
now allow the option to refer to a file under `/etc/sigsum/policy/` or
to a built-in named policy.

Rather than adding a separate "named-policy" option, we choose to
extend the meaning of the existing `-p, --policy=policy-file` option
given that there are already rules for how the `sigsum-submit` program
behaves depending on whether the `-p` option is used or not. Allowing
specifying a policy using another option than `-p` would make that
more complicated. The basic meaning of the `-p` option is to specify
which trust policy should be used, so it makes sense to use it also
when referring to a named policy.

## Named policies

The user can choose to specify `-p :policy-name` where `policy-name`
is a string that is expected to match an existing policy name. The
policy name can be either one of the built-in policy names, or a name
added in a configuration file under `/etc/sigsum/policy/`.

Note the `:` in `-p :policy-name` -- the purpose of the `:` character
there is to say that the argument should be interpreted as a policy
name.

There are two kinds of named policies:
- Built-in named policies
- Named policies locally installed under `/etc/sigsum/policy/`

A locally installed named policy with the name `xyz` would correspond
to a file `/etc/sigsum/policy/xyz` and a user of the sigsum tools
would use the option `-p :xyz` to use that named policy.

When a named policy is used, everything should work in the same way as
if a corresponding policy file had been specified.

## Functionality to list and show available named policies

The MR
https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/248
already implements a `sigsum-policy` command that could be used to
list and show available built-in named policies.

The built-in named policy functionality could be achieved by running
`sigsum-policy show name > policy-file` and then use the existing `-p
policy-file` way of specifying a policy. The purpose of adding the
possibility of specifying a built-in policy name is to make this more
convenient for users, avoiding the need to create an intermediate
file.

## Changes in named policies

The idea is that a built-in named policy will not change and will
remain available. New policies are expected to be added in the future
while the existing policies remain available with the same meaning as
before. It can make sense to let the policy name include the year (or
year and month, or similar) when the policy was introduced.

Built-in policies should never be removed. We can consider marking
obsolete policies as deprecated in some way, and possibly output a
warning if a deprecated policy is used.

In a first implementation we can have only a single named policy
called e.g. "sigsum-test-2025" which we use to check that the named
policy functionality is working.

## Policies distributed by others

To make it convenient to use policies that are defined and distributed
by others than the Sigsum project itself, we allow reading policy
files from the `/etc/sigsum/policy/` directory: if the user specifies
`-p :xyz` then the sigsum tools will look for the file
`/etc/sigsum/policy/xyz` and use that policy file if it exists.

For example, debian could define their own policy and install it as
`/etc/sigsum/policy/debian-strict-2026` and then a user of the sigsum
tools can specify `-p :debian-strict-2026` to use that policy.

There could be a convention for policy names saying that each name
should have the form "org-arbitraryname-time" or similar, where "org"
is the organisation name and "time" is some kind of time indication
like year or year-month or a complete date. The sigsum tools could
possibly check that to some extent, like checking that the name
contains precisely two `-` characters.

## Order of priority

Since we use the `:` prefix to distinguish between file path and named
policy, there is no ambiguity there.

Given that the `-p` option with `:` can be interpreted in two
different ways, it is necessary to decide an order of priority between
those two.

We use the following order of priority, given that the user has
specified `-p :xyz`:

- First check if the file `/etc/sigsum/policy/xyz` exists and if so, use that file
- Then check if `xyz` matches one of the built-in policy names and if so, use that built-in policy

The above order of priority means that it is possible (although not
recommended) to override a built-in policy name by placing a file with
that name in the `/etc/sigsum/policy/` directory.

We could have an environment variable for overriding the location
`/etc/sigsum/policy`, and a documented way to use that variable to
completely disable locally installed named policies.

Note that if the user has specified `-p xyz` (without `:`) then the
behavior is the same as before. So things will be backwards compatible
except in the hopefully rare case where a filename starting with `:`
has been used.
