# 2025-07-21 - Notes about built-in named policy functionality

Below are notes about the current plans to add named policy
functionality, written by Elias with help from others.

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

## Different ways of specifying a policy

Currently, all three programs accept a `-p, --policy=policy-file`
option, that should still work in a similar way as before, but there
will also be additional ways to specify the policy.

It will be possible to specify either a policy file (as before) or a
policy name. A policy name can be specified either as an input option
`-P, --Policy=policy-name` or as an option privided inside a submitter
public key file.

### Specifying a policy name inside a submitter public key file

A submitter public key file is specified as input to the
`sigsum-submit` and `sigsum-verify` programs, and can include options
as described in the "AUTHORIZED_KEYS FILE FORMAT" section of the
`sshd` man page. For sigsum, the option `sigsum-policy="policy-name"`
can be placed there and can be used as a way of specifying the
policy. For the sigsum tools, if neither `-p` nor `-P` input options
were given and a `sigsum-policy="policy-name"` option is found inside
the submitter public key file, that policy name is used.

Example: a submitter public key file that contains the following
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPwsfu294zCxiE157E4N5od+wkx7eZtH1Lz+L9Zg5g4r sigsum key
```
could be modified to add a policy name like this:
```
sigsum-policy="sigsum-test-2025" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPwsfu294zCxiE157E4N5od+wkx7eZtH1Lz+L9Zg5g4r sigsum key
```
and then the policy name "sigsum-test-2025" would be used, provided
that none of the `-p` or `-P` input options were given.

## Named policies

Regarding named policies, there will be a two-step process to
determine the specific policy to use:

- First determine the policy name, either from the `-P policy-name`
  option or from an option inside a submitter public key file

- Then determine which specific policy that name corresponds to:
  either a named policy locally installed under `/etc/sigsum/policy/`
  or, if no such locally installed policy is found, a built-in named
  policy.

There are thus two kinds of named policies:
- Built-in named policies
- Named policies locally installed under `/etc/sigsum/policy/`

A locally installed named policy with the name `xyz` would correspond
to a file `/etc/sigsum/policy/xyz` and a user of the sigsum tools
could use the option `-P xyz` to use that named policy.

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
file, and also adding the possibility of specifying the policy as an
option inside a submitter public key file.

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
`-P xyz` then the sigsum tools will look for the file
`/etc/sigsum/policy/xyz` and use that policy file if it exists.

For example, debian could define their own policy and install it as
`/etc/sigsum/policy/debian-strict-2026` and then a user of the sigsum
tools can specify `-P debian-strict-2026` to use that policy.

There could be a convention for policy names saying that each name
should have the form "org-arbitraryname-time" or similar, where "org"
is the organisation name and "time" is some kind of time indication
like year or year-month or a complete date. The sigsum tools could
possibly check that to some extent, like checking that the name
contains precisely two `-` characters.

## Order of priority

For named policies we need to consider order of priority in two ways:
first for the name itself, and then for how a policy name is
interpreted.

Regarding how to specify a name, that can be done either using the `-P
policy-name` option or by having the policy name as an option inside a
submitter public key file. Here the order of priority is that the `-P`
option takes priority over any policy name specified in the public key
file.

Regarding how a policy name is interpreted we use the following order
of priority, given that the user has specified the policy name `xyz`:

- First check if the file `/etc/sigsum/policy/xyz` exists and if so, use that file
- Then check if `xyz` matches one of the built-in policy names and if so, use that built-in policy

The above order of priority means that it is possible (although not
necessarily recommended) to override a built-in policy name by placing
a file with that name in the `/etc/sigsum/policy/` directory.

We could have an environment variable for overriding the location
`/etc/sigsum/policy`, and a documented way to use that variable to
completely disable locally installed named policies.

Note that if the user has specified `-p xyz` (with `p` rather than
`P`) then the behavior is the same as before. So things will be
backwards compatible, the existing `-p` option will work in the same
way as before.
