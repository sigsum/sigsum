# Use something simpler than SSH signature format

Sigsum adopted OpenSSH signature format, see
[proposal](./2021-11-ssh-signature-format.md). This was done for two
reasons: To be able to take advantage of OpenSSH tools, and to get domain
separation of keys are used for multiple purposes.

This proposal reconsiders this decision. It appears that

1. We no longer depend on SSH tools to create and verify signatures.
   We will keep using OpenSSH formats for key files, and support the
   ssh-agent protocol as a way to access a signing key, but that does
   not depend on also adopting the signature format.

2. We recently changed the format used for tree head signatures, for
   compatibility with the checkpoint format. Then, we no longer have
   the internal consistency of using ssh signatures for everything.

3. Some means of domain separation is still good practice, to make it
   impossible, or very unlikely, that a signature created for an
   operatino in the Sigsum system can be taken out of context and
   accepted as valid by an unrelated system, or vice versa. It's
   generally discouraged to reuse the same signing key for multiple
   purposes, but we still see some reasonable usecases (e.g., using
   the same key as a general release signing key, as the leaf signing
   key for Sigsum logging of releases. In particular, the set of leaf
   keys that can occur in the Sigsum system is open and potentially
   huge.
   
4. Domain separation can be done simpler than adopting the ssh
   signature format wholesale. It's also desirable to get a bit more
   consistency with the ad-hoc namespace prefix we use for tree head
   signatures.

Domain separation is particularly important for the leaf signatures,
since the signed data is otherwise arbitrary and not validated by the
Sigsum system. We want a Sigsum log to only publish signatures that
were intended for the Sigsum system: it shouldn't be possible to take
any valid ED25519 signature, regardless fo the purpose for which it
was made, and submit to a Sigsum log.

We have considered going one step further and have the data signed for
a leaf signature include the public key of the target log. However,
this idea was rejected, because we see valid usecases where leaf
signatures are created separately from the logging, and where it
should be possible to select which log to submit to later, e.g., in
case one of the configured logs is temporarily down.

# High-level design

A "namespace string" is attached as a prefix to all messages signed in
the sigsum system, it it should consist of three parts, the string
`sigsum.org` to identify the Sigsum system, as well as the
organization responsible for the system specifications, a version
string, `v1`, to distinguish signed objects intended for separate
versions of the system, and an id for the kind of signed object within
Sigsum. These components are part of the current namespace strings we
use with the OpenSSH signature format, e.g.,
`tree-leaf:v0@sigsum.org`.

The id is an ascii string, and it should be terminated by some special
character that can not be part of the id (e.g., NUL character, newline
character), so that we don't have to carefully select a set of
namespace strings such that no valid namespace is a prefix of another.

# Checkpoint-compatible tree head signatures

In the current protocol, a log's signature on a tree head is based on
formatting the tree head as a "checkpoint", a text format, where the
first line is an id that we format as `sigsum.org/v1/HASH`, where the
`HASH` is the lowercase hex representation of the SHA256 hash of the
log's public key.

For consistency, it seems reasonable to make other namespace prefixes
start with `sigsum.org/v1/`. That way, if some other applications
signs a set of messages that can't start with `sigsum.org/`, then we
can be sure that a data item with a valid Sigsum signatures will be
rejected if presented to that other application, and vice versa,
regardless of which keys have been configured.

The prefix used for checkpoint messages violates the design
requirements outlined above in two ways, though: It doesn't include an
id for the usage within the sigsum system, and it uses a plain slash
character to separate this prefix from the rest of the data. We could
consider addressing that, but with this proposal, there can be no
collision between a valid checkpoint, and any other signed message.

# Detailed proposal

There are currently three kinds of Sigsum signatures using the OpenSSH
signature format, each with its own namespace string:

1. Leaf signatures, namespace `tree-leaf:v0@sigsum.org`. As mentioned,
   domain separation is particularly important for these signatures,
   since the set of valid keys is so open-ended.

2. Witness cosignatures, namespace `cosigned-tree-head:v0@sigsum.org`.

3. Submit token signatures, namespace `submit-token:v0@sigsum.org`.
   The signed data is supposed to be the log's public key, not any
   arbitrary data, but it completely lacks syntactic structure. Adding
   a namespace adds such structure.

The proposal assigns a different namespace string for each of these
three uses, and specifies that the data blob signed using ED25519 is
formed by concatenating the namespace string, a single NUL character,
and the binary data formatted in the same way as in the current
protocol.

NUL as terminator is chosen because (i) NUL can't occur in a
checkpoint, so we rule out collisions with tree-head signatures, as
well as with any other messages using text syntax (e.g., changes to
cosignature formats are under discussion), and (ii) it's a reasonably
pretty way to separate the plain text namespace string from the
non-text data that follows.

## Leaf signatures

Recall that a an add-leaf request includes a 32-octet string called
the `message` (usually, `message = H(data)`, where `data` is neither
processed, nor published, by the log). The log receiving the message
forms `checksum = H(message)`. The signature, created by the submitter
and published by the log, is formed over the concatenation
`sigsum.org/v1/tree-leaf`, NUL, `checksum`. I.e., a octet string of 56
octets, the 23-byte ascii prefix, a single 0 octet, and the 32 octet
checksum.

## Witness cosignature

The signed data is the concatenation of the namespace string
`sigsum.org/v1/cosigned-tree-head`, NUL, the serialization of the
`cosigned_tree_head` struct (see [witness spec[(./witness.md)), for a
total of 113 octets.

## Token signature

The signed data is the concatenation of the namespace string
`sigsum.org/v1/submit-token`, NUL, the log's public key, for a total
of 59 octets.

