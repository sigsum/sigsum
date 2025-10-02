# Proposal to make the Sigsum policy format more restrictive

## Background

The policy format was defined in March 2023, as a configuration file
for the Sigsum tools. We are quite happy with the semantics, and at
some point we would like to turn this into a more formal
specification.

There's also been some interest to use the policy format for verifying
other kind of "spicy signatures", for tlogs that rely on cosignatures,
but doesn't use a Sigsum log. This makes formalization more relevant
now than it was back then.

## Proposal

There are two independent changes being proposed:

### Clarify character set issues

The items on each line are "separated by white space". Specify that
only the ascii space and TAB characters are recognized. I.e., fields
are separated by a sequence of one or more of these characters, and
they are also allowed at the start and end of lines. (The current
implementation uses the go function `strings.Fields`, which is unicode
aware).

Motivation: Don't require unicode tables for parsing, and don't make
the meaning of the policy file dependent on unicode version.

Disallow all ascii control characters but TAB (in particular, disallow
NUL characters). Motivation: policy is intended to be a text file,
easily processable by text tools. Control characters, in particular
NUL, is a likely source of problems.

Still allow non-ascii characters. Strongly encourage use of utf-8 for
any non-ascii contents, but allow an implementation to treat the items
as opaque octet strings, with no validation of utf-8 or unicode
semantics.

Motivation: Allow using [signed note]() key names as witness names.
Allow non-ascii in comments, and allow international domain names in
URLs, without resorting to punycode. Do this without requiring the
policy parser to be unicode-aware.

Open question: Should the comment start character, `#`, be recognized
only at the start of a line (possibly preceeded by space and TAB
characters)? Or anywhere on a line, as currently implemented? It
matters if one attempts to use the `#` character in a URL or name, and
it is an allowed character for a [signed note]() key name.

[signed note]: https://github.com/C2SP/C2SP/blob/main/signed-note.md

### Disallow duplicates

Specify that a policy is invalid if there are multiple log lines with
the same public key, or multiple witnesses with the same key.

Motivation: Duplicates are confusing, likely errors, and duplicate
witnesses also violate the one-single-path rule below.

Specify that a policy is invalid if the same witness or group is
listed as a group member more than once. No duplicates in the list of
group members, and no name listed as a member of more than one group.

Motivation: This ensures that the tree of groups and witnesses
contains at most one single path from a witness to any group, or to
the quorum in particular. Duplicates are likely configuration errors,
and excluding duplicates makes the policy semantics easier to reason
about.

Note that it is allowed for a witness or group to be listed both as
the quorum, and as a member of one group; the quorum can be any
defined group or witness, and the policy is allowed to define
additional groups and witnesses that aren't actually used by the
quorum definition.

Open question: Should we also check that the set of log keys and the
set witness keys are disjoint? Using same key for a log and a witness
is a bit weird, but we do have needed domain separation for the
signatures. And it doesn't seem that likely to happen by mistake and
then make things break in only a subtle way.
