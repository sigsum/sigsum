Proposal to use origin line to identify the log in a sigsum proof

author: nisse

My current conclusion is that we can't do this at this point. Unless
we can find some easy way to support other types of leaves, without
doing changes beyond the "small update" we intend for version=2.

# Background

It has been decided to define a sigsum proof version=2, see [previous
proposal][]. If there are other small changes that would be
beneficial, this is therefore a good time to do it.

[previous proposal]: ./2024-11-proof-with-no-leaf-checksum.md

## Proposal

# Change the `log=` to specify log origin rather than log key hash

For a sigsum log, that means a change from
```
log=44ad38f8226ff9bd27629a41e55df727308d0a1cd8a2c31d3170048ac1dd22a1
```
to
```
log=sigsum.org/v1/tree/44ad38f8226ff9bd27629a41e55df727308d0a1cd8a2c31d3170048ac1dd22a1
```

## Pro

This change could potentially make it more practical to use Sigsum's
proof format and trust policy format as is for proof-of-logging (aka
"spicy signature") in non-sigsum logs. We don't expect the sigsum
proof format to be ideal for others, but it may still be useful if it
can represent proofs or "spice signatures" for other logs.

The origin line is essential for verifying a proof, since it is
embedded in the data signed both by the log itself and by witnesses.

There are other pieces of data that one would expect in a future
"spicy signature" format more consistent with checkpoint conventions,
like witness names and key ids, that are missing in a sigsum proof.
However, those are used mainly to aid management of the public keys
involved, and they are not essential for determining if a spicy
signature is valid or not.

## Cons

The `leaf=` line in a Sigsum proof is still sigsum-specific. A proof
format supporting any kind of log would need the leaf hash (for
validation of the inclusion proof), with log-specific verification
that the leaf hash is consistent with the data being logged.
