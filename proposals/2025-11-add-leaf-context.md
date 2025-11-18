# Add an optional context to leaf signatures

## Motivation

The context enables use of a single signing key for multiple purposes,
with signatures for each purpose monitored separately.

In the original sigsum design, the user would need to manage multiple
signing keys, which is simple in theory, but in practice can be quite
a hassle for users. E.g., consider a software maintainer using the
same release signing key for multiple independent projects, or for
signing both official release artifacts and pre-release artifacts
intended for testing.

Another use case is software distribution using non-crypto identities.
E.g., a service providing build machinery for a large number of
projects, like github and gitlab, could use a well known key to sign
and sigsum log artifacts + metadata, and use the context to identify
the user or project responsible for the artifact.

The main benefit is for monitoring; a monitor can tail the log and
extract entries signed with a particular key and a specific context.

## Proposal

This proposal adds a leaf `context` in a way that is backwards
compatible, and does not require the log to store the `context`. The
`context` is always used together with a public key, and the owner of
the corresponding private is responsible for managing the set of
contexts used with that key.

A leaf context is either empty, or a string of 32 arbitrary octets.
The context could be constructed as the SHA256 hash of some
human-readable identifier. Since the context is not stored or
published by the log, there is no need for double hashing (unlike the
`message` --> `checksum` transformation which is needed to prevent log
poisoning).

### Empty context

There is no change regarding leafs with empty context: They are
submitted using the `add-leaf` API endpoint with input consisting of
`message`, `signature` and `public_key`. The processing of this
request and the contents of the resulting leaf are unchanged. In
particular, the signature is computed over the concatenation of the
namespace string `sigsum.org/v1/tree-leaf`, a single NUL character,
and the `checksum` (32 octets, the SHA256 hash of the 32-octet
`message` provided by the submitter), for a total of 56 octets signed
using Ed25519.

### Including context

To add a leaf with context, we need an additional `context` input for
add leaf. Add a new endpoint `add-context-leaf`, where the request
body format for `add-leaf` is extended with a new line with key
`context` and value being the hex-encoded context.

For a leaf with context, the `signature` is formed over the
concatenation of the namespace string
`sigsum.org/v1/tree-context-leaf`, a single NUL character, the
`context` (32 octets) and the `checksum` (32 octets), for a total of
96 octets signed using Ed25519. To make monitoring work, the
`key_hash` is no longer just the hash of the `public_key`. Instead, it
is the SHA256 hash of the concatenation of a the namespace string
`sigsum.org/v1/context-key`, a single NUL character, the `context` (32
octets) and `public_key` (32 octets), a total of 90 octets hashed.

The server verifies the submitter's `signature`, and if valid, a leaf
consisting of `checksum`, `signature` and `key_hash` is added. Note
that the leaf structure is unchanged, and that the log uses the
`context` only for verifying the signature and constructing the
`key_hash`: after this processing, the log keeps no record neither of
presence or contents of the `context`.

Alternative that's been considered: Introduce an optional `context`
line in the input body for the existing `add-leaf` end-point. But a
new endpoint seems preferable, both for being more explicit, and
because optional lines would be a new convention not used elsewhere in
the api ascii formats.

## Implementation

### Public keys

Essentially, all submitter public keys need to have the context (if any) attached.
For convenience, we can add this as an attribute in public key files, like
```
sigsum-context-id="foo" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPwsfu294zCxiE157E4N5od+wkx7eZtH1Lz+L9Zg5g4r sigsum key
```
or
```
sigsum-context-raw="LCa0a2j/xo/5m0U8HTBBNBNCLXBkg7+g+YpeiGJm564=" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPwsfu294zCxiE157E4N5od+wkx7eZtH1Lz+L9Zg5g4r sigsum key
```

The identifier version is useful when the context is the hash of a
short human-readable identifier. The raw version is useful when the
context is the hash of some large or not human-friendly data, and it
uses base64 (for conciseness, and consistency with the key blob
encoding).

Potential related work, for later: Consider corresponding PEM headers
for private key files, both for sigsum-context and the recently added
sigsum-policy. Add features to the `sigsum-key` command to help manage
key attributes.

### Submission

The `sigsum-submit` command needs to know the context to use, both for
signing the leaf request, and for computing the `key_hash` and
`leaf_hash` when verifying the inclusion proof. This could be taken
from the public key file (if any, e.g., when using `ssh-agent`), or
from a separate command line option.

It is unclear if we can do any additional user interface tweaks to
help prevent mistakes like signing an item using an unintended
context.

### Verify

The `sigsum-verify` command needs to know the context to use, for
each authorized submit key. It will likely be most practical to
include the context to use for each key in the submitter public key
file passed with the `-k` option.

### Monitoring

The configuration issues for the monitor is similar to those for a
verifier, and the most practical way is likely to include contexts in
the submitter public key file(s).

Note that this design only enables monitoring for log entries
associated with *pairs* of (`public_key`, `context`). It is not
possibly to monitor all log entries with valid signatures for a given
public key, regardless of context.

### UI issues

There are a few UI issues left open for now, which will have to be
sorted out when implementing tooling support. There should be command
line options for overriding some or all of the contexts specified in
the public key files. And we need to think about how to support the
case of multiple valid contexts for the same public key.
