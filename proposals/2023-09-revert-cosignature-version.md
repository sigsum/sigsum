# Revert versioned cosignatures

## Previous proposal

A few months ago, see [](./2023-95-cosignature-version.md), it was
decided to add a version field to sigsum cosignature version lines.
That was done to aid smooth rollout of witness cosignatures using
different crypto, either different serialization, or a different
signature algorithm, e.g., to deploy post-quantum algorithms.

The idea was also to aim for the Sigsum log <--> witness protocol to
be adopted by other witnesses, not primarilty intended to support the
Sigsum system, and not limited to Sigsum's algorithm choices.

To quote the earlier proposal:

> 1. The `cosignature` key in the output of the witness `add-tree-head` API is
>    changed to a repeated key.
> 
>    Different entries can have different key hashes, to enable witness key
>    rotation. Clients are expected to ignore unrecognized key hashes.
> 
> 2. The encoding of a cosignature is changed from its current three
>    space-separated fields to four, where the first is currently always `v1`, but
>    may be any string of non-space printable ASCII characters.
> 
>    `v1 dcce98012388f1b7a92973ba153b295d5f259097896871cb836066a37c9bf1e3 1679315147 1d765c6306fe124f388b0a6544c449e947b4f7db6c76fb0067be5a8f992460e4e1c286dfae825582f212d7d419a9fe89bcb19a23dc8d09d6ccd167b719e03b66`

This proposal reverts both changes (and the first part never got
implemented).

## Current plan

An interoperable log <--> witness protocol, supporting multiple key
types (for crypto-agility) is still in development, with cryptographic
details compatible with Sigsum cosignatures (as long as the witness
uses as Ed25519 signing key). However, this need to be visible to log
users; a Sigsum log could talk to a witness that produces additional
cosignatures that are not compatible with Sigsum, verify and publish
the Ed25519 cosignatures in the Sigsum log protocol, and simply ignore
any non-Ed25519 cosignatures.

At a later point, e.g., if Sigsum adopts a particular flavor of
post-quantum cosignatures, we would extend the Sigsum log protocol
with a way to publish those.

So we delete the "v1" version tag both in the Sigsum log protocol, and
in the current, Sigsum-specific, log <--> witness protocol.

## Open question

To provide a bit more flexibility for future extension of the Sigsum
log protocol, we could relax the syntax of the cosignature line to
allow a signature field that doesn't represent an Ed25519 signature.
We could specify the syntax as an arbitrary length hex string, or as
an arbitrary length string of printable non-space ascii characters.

When processing a cosignature line, if the keyhash corresponds to a
known Ed25519 public key, only then is the signature field required to
be exactly 128 hex digits, representing an Ed25519 signature.
