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

4. Support in tools, primarily sigsum-key, sigsum-submit and
   sigsum-verify.

This proposal sketches what needs to be done in each case.

## Log server protocol

Collecting mldsa44 cosignatures will use the add-checkpoint endpoint,
with mldsa signatures according to tlog-witness@v1.1.0.

We should probably support getting both Ed25519 and mldsa44
cosignatures in the same response. The log server is configured via a
policy file with one key per witness-line (see below on mldsa44
extensions to the policy file). If we make independent requests for
each configured witness key, and two lines are actually backed by the
same witness instance with shared "latest seen state", the exchange
would be something like:

    log -> witness: add-checkpoint request, checkpoint of size 20, old size 10.
    log <- witness: response with two cosignatures, one used, one ignored
    log -> witness: add-checkpoint request, checkpoint of size 20, old size 10.
    log <- witness: conflict, should use old size 20
    log -> witness: add-checkpoint request, checkpoint of size 20, old size 20.
    log <- witness: response with two cosignatures, the other one used, one ignored

This is extra work for both log and witness, and could be avoided by
grouping the witness keys by URL before making the requests.

Returning mldsa cosignatures from the `get-tree-head` endpoint would
break old clients. We could add a new endpoint `get-tree-head2` or the
like, with the difference that the last field of a cosignature line
may be larger, 4840 hex digits for mldsa44 (unclear if it's worth
switching to bas64 to save 1600 characters). The old endpoint simply
omits all non-Ed25519 signatures. A slightly larger step towards
sigsum-v2 would be to introduce a new `checkpoint` endpoint,
compatible with tlog-tiles (without supporting the rest of the tiles
api at this time).

To support a checkpoint endpoint, the log server logic would also
have to be extended to handle witness names.

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
plain old Ed25519 witnesses, and 0x06 for mldsa44.

A policy file with vkey would obviously be rejected by old tools.

## Sigsum proof

Use the tlog-proof format. The information from the `leaf` line in
current sigsum proof would need to move to the base64-encoded `extra`
line. This line could contain a version prefix, say
"sigsum.org/v1/proof-leaf\x00", followed by the leaf keay hash (32
bytes) and the ed25519 signature (64 bytes).

## Tooling

The sigsum-verify tool should be updated to support all of version 1,
2 and tlog-proof.

The sigsum-submit tool should support the updated policy format, and
check if any mldsa keys are listed. If so, it should use the new
`checkpoint`. Maybe it needs a fallback to old `get-tree-head`, e.g.,
if some but not all of the listed logs support `checkpoint` and talk
to mldsa44-capable witnesses. In case there are no mldsa witness
cosignature, it could produce either the current sigsum proof format,
or a tlog proof. A reasonable default behavior could be to produce a
tlog-proof if all witnesses in the policy file were configured using
vkeys.

The sigsum-key tool needs to be updated to support mldsa key
generation, and relevant format conversions.

## Plumbing

The sigsum-go library was written without any "algorithm agility", and
needs some breaking refactoring to support additional signature
algorithms besides Ed25519.

The sigsum-c library would also need some refactoring to support more
signature algorithms (and underlying Nettle library doesn't yet
support mldsa at all). I think adaptation of sigsum-c can be postponed
until sigsum-v2 design is a bit more mature. Maybe some easy changes
are helpful, e.g., reading a tlog-proof and ignore all non-Ed25519
signatures.
