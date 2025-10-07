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

There are a few independent changes being proposed:

### Clarify character set issues

Lines are terminated by the newline character (0x0a).

The items on each line are "separated by white space". Specify that
only the ascii space and TAB characters are recognized. I.e., fields
are separated by a sequence of one or more of these characters, and
they are also allowed at the start and end of lines. (The current
implementation uses the go function `strings.Fields`, which is unicode
aware).

Motivation: Don't require unicode tables for parsing, and don't make
the meaning of the policy file dependent on unicode version.

Disallow all ascii control characters (octets 0x00 -- 0x1f and 0x7f)
except TAB (0x09) and new line (0x0a). Motivation: policy is intended
to be a text file, easily processable by text tools. Control
characters, in particular NUL, is a likely source of problems.

Still allow non-ascii characters. Non-ascii characters should use
utf-8 encoding. An implementation may warn or reject invalid utf-8
sequences, but for input that is accepted, the items must be handled
as opaque octet strings, e.g., comparisons must not apply unicode
normalization.

Motivation: Allow using [signed note]() key names as witness names.
Allow non-ascii in comments, and allow international domain names in
URLs, without resorting to punycode. Do this without requiring the
policy parser to be unicode-aware.

[signed note]: https://github.com/C2SP/C2SP/blob/main/signed-note.md

### Comment lines

Recognize comments only when the `#` (0x23) character occurs at the
start of a line, possibly preceded by some space and TAB characters
only. If it occurs elsewhere, it has no special meaning in the context
of policy syntax. (The current implementation allows `#` to occur, and
introduce a comment, anywhere on the line).

Motivation: The character `#` may be used in [signed note]() key names
and for URL anchors. Such use may be a bit obscure in a policy file,
but there is value in not introducing syntax that is incompatible with
these formats. The utility of having end-of-line comments, in addition
to complete-line comments, seems rather small.

### Disallow duplicates

Specify that a policy is invalid if there are multiple log lines with
the same public key, or multiple witnesses with the same public key.

Motivation: Duplicates are confusing, likely errors, and duplicate
witnesses also violate the one-single-path rule below.

Note that it is still allowed to list a log and a witness that use the
same public key. Motivation: When an organization operates both a log
and a witness, there's sufficient domain separation between log and
witness signatures to make it a technically valid option to use the
same signing key. Furthermore, if a policy file includes a log and a
witness with the same key, by mistake, that seems likely to make
things break in obvious rather than subtle ways.

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
