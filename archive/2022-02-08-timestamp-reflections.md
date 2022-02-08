# Timestamp reflections
## Introduction
Sigsum logs sign tree heads that contain timestamps.  Witnesses must not cosign
a tree head unless the timestamp is fresh.  The original motivation to have a
timestamp was to ensure that monitors could be convinced of freshness.  This
document provides some of our latest insights on the why (not) of timestamps.

## Background
A witness must only cosign a tree head if it is fresh and append-only.  The
freshness criteria is defined as "not older than five minutes".  This means that
logs and witnesses are assumed to be configured with some kind of rough time.

Simply removing the freshness check would introduce the risk of slow-down
attacks against monitors.  See [past documentation][] on how that works.

[past documentation]: https://git.sigsum.org/sigsum/tree/archive/2021-08-24-checkpoint-timestamp

## Freshness without timestamps
Assume that a witness only cosigns a tree head if the current tree size is
larger or equal to the previous tree size.  A different way to approach
freshness for monitors without appealing to reactive gossip is as follows.

 1.  Every X time units, submit an entry for logging.
 2.  Check that the submitted entry gets merged in the next cosigned tree head,
 and that the cosigned tree head has enough cosignatures to be trusted.

A monitor can conclude that at the time its latest entry got merged into the
log, there cannot be any other outstanding entries unless there is a split-view.
A split-view is not possible unless the witnessing assumptions is wrong.  So,
within our threat model this can prevent a slow-down attack without timestamps.

The downside is that monitors must submit entries periodically to repeatedly
convince themselves of freshness.  It does not preclude the idea, but does not
necessarily work if the same cosigned tree head format is used elsewhere.  For
example, a [serverless transparency log][] might not want to allow write-access
to each and every monitor.  A different approach towards freshness is needed.

[serverless transparency log]: https://github.com/google/trillian-examples/blob/master/serverless/README.md

## Other timestamping arguments
An interesting property from having witness-verified timestamps is that a clock
can be set roughly by doing the above submission trick once at start-up.  A
system that already relies on witnesses for append-only logs can get rough time.

An interesting side-effect of witness-verified timestamps is that the setup as a
whole results in a distributed timestamping service.  It is easy to get excited
about this property.  It is not a strict Sigsum criteria, however.

 1. Get the current cosigned tree head `X`.
 2. Log an entry `E`.  Leaf index will be larger or equal to `X.tree_size`.
 3. Get inclusion proof to a newer cosigned tree head `Y`.
 4. Now a third-party that be convinced that `E` was logged in the interval
 `[X.timestamp, Y.timestamp]`.

(A bit-for-bit duplicated entry should be considered log misbehavior.)

Some policy aspects could become easier with timestamps, such as "witness W
should not be trusted for timestamps after time T".  The same statement can be
stated without time though: "witness W should not be trusted after tree size N".
The difference is that a timestamp works for all logs; tree sizes are per-log.
