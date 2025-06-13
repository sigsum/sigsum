# DRAFT: Built-in named policy functionality notes

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

## Built-in named policies

The user can choose to specify `-p policy-name` where policy-name is a
string that is expected to match one of the built-in policy names.

When a built-in policy name is used, everything should work in the
same way as if a corresponding policy file had been specified.

## Functionality to list and show available named policies

The MR
https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/248
already implements a `sigsum-policy` command that could be used to
list and show available named policies.

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
called e.g. "test-policy-2025" which we use to check that the named
policy functionality is working.

## Policies distributed by others

To make it convenient to use policies that are defined and distributed
by others than the Sigsum project itself, we allow reading policy
files from the `/etc/sigsum/policy/` directory: if the user specifies
`-p xyz` then the sigsum tools will look for the file
`/etc/sigsum/policy/xyz` and use that policy file if it exists.

For example, debian could define their own policy and install it as
`/etc/sigsum/policy/debian-strict-2026` and then a user of the sigsum
tools can specify `-p debian-strict-2026` to use that policy.

There could be a convention for policy names saying that each name
should have the form "org-arbitraryname-time" or similar, where "org"
is the organisation name and "time" is some kind of time indication
like year or year-month or a complete date. The sigsum tools could
possibly check that to some extent, like checking that the name
contains precisely two `-` characters.

## Order of priority

Given that the `-p` option can be interpreted in different ways, it is
necessary to decide an order of priority.

One thing we want to avoid is a user accidentally (or getting tricked
into) using a different policy than what was intended. That can be a
reason to give higher priority to the files under
`/etc/sigsum/policy/` compared to files in other locations, so that a
user does not get unintended behavior because a file happened to be in
the current working directory.

Based on the above reasoning we use the following order of priority,
given that the user has specified `-p xyz`:

- First check if the file `/etc/sigsum/policy/xyz` exists and if so, use that file
- Then check if `xyz` matches one of the built-in policy names and if so, use that built-in policy
- Finally check if the file `xyz` exists and if so, use that file

The above order of priority means that it is possible (although not
recommended) to override a built-in policy name by placing a file with
that name in the `/etc/sigsum/policy/` directory.

Note that if the user has specified `-p xyz` and the given `xyz` does
not match any built-in policy name and also does not match any file
under `/etc/sigsum/policy/` then the behavior is as before. So things
will be backwards compatible except when the name matches either a
built-in policy name or a file under `/etc/sigsum/policy/`.
