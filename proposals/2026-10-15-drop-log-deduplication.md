# Proposal to not keep any deduplication index in Sigsum v2

## Background

In the current (version 1) Sigsum protocols, it's not possible to add
multiple copies of the same leaf. The add-leaf request checks if the
leaf hash is already present in the log, and if so, it returns success
without doing anything. The same leaf hash index is used to lookup the
entry index when a client ask for an inclusion proof (with leaf hash
as input). Background for this design is not entirely clear, but some
potential reasons:

1. The way the add-leaf request works requires deduplication, since a
   request with the intention to poll current commit status of an
   entry being added looks identical to a request to add a brand new
   entry.

2. For a leaf with index i, the timestamps on a cosigned tree head of
   size n <= i is evidence that the leaf was added at a later time.

3. A log cannot be spammed by re-adding a large number of existing
   leaves.

4. Trillian works that way. "If the submitted leaf was already
   present in the Log (as indicated by its leaf identity hash), then
   the returned leaf will be the pre-existing leaf entry rather than
   the submitted leaf.", see
   https://github.com/google/trillian/blob/master/docs/api.md#trillian-QueueLeafResponse


## The case against deduplication

### Cost

A deduplication index is rather expensive. We are moving to using
tiles for the storage backend. Then the hot mutable state of the log
write-path is pretty small, it only needs the partial tiles
(representing the right edge of the tree) and book-keeping of the
log's commitments. The bulk of the log contents are complete tiles,
which on the write-path really is "write-only" data; once a tile is
completed and it's root hash propagated to the level above, it is
never accessed again.

So having the deduplication index means that need for fast *local*
storage can grow from at most a GiB to several TiB, with random access
to the index on disk for every leaf added to the log.

All tiles obviously have to be available on the read path, but that
indicates that they should be on storage with good read-only
performance for the read-path machinery, which can be rather
independent of the write-path.

### Utility

Originally, main utility of deduplication was to keep the protocol
simple, in a particular, the add-leaf request. The log server can
respond with "202 Accepted" (while the entry is in the process of
getting properly persisted and replicated), and the client simply
resends the same request. Then deduplication is essential.

In more recent discussions, I think the main potential benefit of
deduplication has been that a cosigned timestamp on an old tree head
demonstrates that entries with larger indices were not present in the
log at that time. However, this doesn't rule out the entry being
present in some other log, and we generally recommend having multiple
logs in one's Sigsum policy, without offering any deduplication across
logs. And in addition, an item not visible in *any* Sigsum log still
doesn't rule out that the item has existed elsewhere for a long time.
So I think that this is a neat feature that lacks a clear usecase.

### Monitoring

In our threat model, the log is not highly trusted. Hence, a
promise by the log operator to not allow duplicates should not be
sufficient for any security-related decisions. If we want to rely on
log deduplication, it ought to be monitored (which it can be).

It's desirable that a monitor doesn't produce multiple alerts if the
same entry is seen multiple times, be that in the same log or in
distinct logs. To do this, a monitor needs a limited deduplication
index for the entries the monitor is interested in (e.g., all unique
entries signed by a particular release key).

When we don't do any deduplication at the log, third parties can
insert duplicates at will (limited only by the general add-leaf rate
limits), and monitors will potentially see a lot more duplicates. As
long as the number of unique entries of interest is small, the
monitor's index stays small, and lookup cost should be insignificant
compared to the cost of getting all log entries and filtering out the
interesting ones. Lookup becomes more costly if the number of unique
entries of interest is huge, e.g., consider logging all builds of all
debian packages, and monitoring all those entries.

Some limited best-effort deduplication index at the log would make it
harder to spam monitors in this way. For this reason, I think it makes
sense to allow logs to reject some duplicates, even though it's not
clear to me it's really worth doing. Spamming becomes a problem on the
monitor side only when the number of unique entris of interest is
huge, and in this case, a deduplication index at the log needs to
be as huge, and hence costly, in order to have effect.

## Proposal

Design the Sigsum v2 protocols so that no deduplication index is
required, neither a complete index, nor a "best effort" index
including only recent entries. In particular, this means that the
polling scheme used with the current add-leaf request can't be adopted
as is.
