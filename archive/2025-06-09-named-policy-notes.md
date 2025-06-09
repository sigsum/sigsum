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

## Existing policy argument

Currently, all three programs accept a `--policy=policy-file`
argument, that should still work in the same way as before, we only
add an alternative way to specify the policy.

## New `--named-policy` argument

We add an option `--named-policy=policy-name` where policy-name is a
string that is expected to match one of the built-in policy names.

When the `--named-policy=policy-name` option is used, everything
should work in the same way as if a corresponding policy file had been
specified.

## Functionality to list and show available named policies

The MR
https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/248
already implements a `sigsum-policy` command that could be used to
list and show available named policies.

The built-in named policy functionality could be achieved by running
`sigsum-policy show name > policy-file` and then use the existing
`--policy=policy-file` way of specifying a policy. The purpose of
adding the `--named-policy=policy-name` option is to make this more
convenient for users, avoiding the need to create an intermediate
file.

## Changes in named policies

The idea is that a named policy does typically not change and will
remain available. New policies are expected to be added in the future
while the existing policies remain available with the same meaning as
before. It can make sense to let the policy name include the year (or
year and month, or similar) when the policy was introduced.

In a first implementation we can have only a single named policy
called e.g. "test-policy-2025" which we use to check that the named
policy functionality is working.
