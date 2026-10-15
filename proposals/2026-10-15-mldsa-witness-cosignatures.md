# Minor protocol extensions to support mldsa witness cosignatures?

As witnesses start to support mldsa44 signatures, can we support that
in Sigsum without major changes? Suggested by filippo at Sigsum weekly
2026-10-13.

This may also be a nice incremental step towards sigsum-v2.

## Overview

To support mldsa cosignatures, we need:

1. Support for log-server to collect and publish signatures

2. A way to specify mldsa44 pubkeys in a policy file

3. A way to include such cosignatures in a sigsum proof.

4. Support in tools, primarily, sigsum-submit and sigsum-verify.

This proposal sketches what needs to be done in each case.

## Log server protocol

Collecting mldsa44 cosignatures will use the add-checkpoint endpoint,
with mldsa signatures according to tlog-witness@v1.1.0.

We should probably support getting both Ed25519 and mldsa44
cosignatures in the same response. The log server is configured via a
policy file with one key per witness (see below on mldsa44 extenstions
to the policy file), so this means that the listed witnesses would
have to be grouped by URL.

Returning mldsa cosignatures from the `get-tree-head` endpoint would
break old clients. We can add a new endpoint `get-tree-head2` or the
like, with the difference that the last field of a cosignature line
may be larger, 4840 hex digits for mldsa44 (unclear if it's worth
switching to bas64 to save 1600 characters). The old endpoint simply
omits all non-Ed25519 signatures.

Key hash can be the raw sha256 hash of the public key.

## Policy file

For each mldsa44 key used by a witness, there should be a separate
witness line with a name for that key. To get the effect of a hydrid
signature scheme, one can define groups combining Ed25519 and mldsa44
keys in various ways, see
[hybrid notes](../archive/2026-08-26-hybrid-sigs-in-sigsum.md).

It seems desirable to make algorithm explicit when configuring a
public key. One could have a format like `mldsa44:<base64 pubkey>`,
but for consistency with tlog-policy, it seems nicer to allow either a
hex string (for backwards compatibility) or a vkey, with type 0x04 for
plain old Ed25519 witnesses, and 0x06 for mldsa44. For now, the vkey
key name would be ignored.

A policy file with vkey would obviously be rejected by old tools.

## Sigsum proof

Define a Sigsum proof `version=3` format, with the only difference
from version 2 being that the last field on a cosignature line may be
longer, using same format as `get-tree-head2`.

## Tooling

The sigsum-verify tool should be updated to support all of version 1,
2 and 3 of the proof format.

The sigsum-submit tool should support the updated policy format, and
check if any mldsa keys are listed. If so, it should use the new
endpoint `get-tree-head2`. Maybe it needs a fallback to old
`get-tree-head`, e.g., if some but not all of the listed logs support
`get-tree-head2` and talk to mldsa44-capable witnesses.

It should produce a `version=3` proof only if there are any mldsa44
signatures in the proof.

## Plumbing

The sigsum-go library was written without any "algorithm agility", and
needs some breaking refactoring to support additional signature
algorithms besides Ed25519.

The sigsum-c library would also need some refactoring to support more
signature algorithms (and underlying Nettle library doesn't yet
support mldsa at all). I think adaptation of sigsum-c can be postponed
until sigsum-v2 design is a bit more mature. Maybe some easy changes
are helpful, e.g., reading a `version=3` proof and ignore all
non-Ed25519 signatures.
