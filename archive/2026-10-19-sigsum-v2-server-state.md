# Almost stateless Sigsum v2 log server

This document explores a design where the server responsible for the
Sigsum-v2 write-path keeps a bare minimum of persistent state. Let's
call this the primary server, for consistency with the Sigsum-v1
architecture. Persistent storage is delegated to one or more log
secondaries; log secondaries serve the data using the tile api.

Setup:

* The primary has one main signing key used for signing
  advertised checkpoints, and a separate signing key used to sign
  tentative checkpoints.

* The secondaries have a signing key each, used to sign what they have
  persisted.

# Server startup

The server reads its most recent signed checkpoint from trusted local
storage, and verifies the signature. The essential part here is to
prevent log rollback. (In case the server uses a tkey log-signer, it
wouldn't even need to have this state on disk).

It retrieves the partial tiles for this size from its secondaries,
and keeps in RAM. It computes the corresponding root hash, and checks
that it is the same as in the signed checkpoint.

It sends the checkpoint to the secondaries. A secondary will compare
it to its own state (possibly triggering alert, catchup, or discarding
of tentative data).

# Accepting entries

Entries are added to the current partial entry tile and the in-memory
tree tiles. Periodically, or when the level 0 tile gets completed,
data is pushed to the secondaries.

To do this, the server computes the new root hash, and signs a
tentative checkpoint. It sends the signed tentative checkpoint and the
new entries to the secondaries. The secondaries persist data, and
return their signature for the tentative checkpoint. These signatures
claim that the data is persistently stored. To not disrupt service,
new entries should be accepted, up to some limit, while the primary
waits for these signatures.

When a sufficient number of secondaries have returned signed
"persisted" checkpoints , the primary may decide to promote the
tentative checkpoint to an advertised published checkpoint. It re-signs
the checkpoint using its main signing key, and atomically updates
the "latest signed checkpoint" in local storage.

# Collecting cosignatures

Next to collect cosignatures, the server needs consistency proofs
relative to its witnesses' state. In the common case, this should be a
consistency proof relative to the previous checkpoint, which involves
only the new tentative entries and partial tiles above.

But some complete tiles may be needed as well, either if some witness
is behind, e.g., have been unreachable for a while, or if this is a
high-volume log where there's a large number of new entries.

To make this work, we need a cache in RAM also of some complete tiles.
It could potentially be abused for DoS by a malicious witness, but we
should be able to limit that by treating witnesses that reduce their
`old_size` value as misbehaving. We can forget complete tiles that are
included in the cosigned checkpoints of all witnesses.

The cache would be populated by pushing newly completed tiles, and by
retrieving tiles from secondaries. To ensure that a malicious
secondary can't poison this cache, we need to get tiles top-down, and
verify the root hash of each fetched tile to the value in the tile
above. Recall that the partial tiles are authenticated against the
trusted local checkpoint.

When cosignatures are collected on a checkpoint, the checkpoint is
sent to secondaries for publication.

# Client protocol

To submit an entry to the log, a client sends an add-entry request to
the primary. This may fail, if the number of tentative (i.e., not yet
persisted) entries is too large, or if submitter's rate limit is
exceeded. On success, an entry is added to the list of tentative
entries, and the index is returned, but the log has not yet comitted
to storing this entry.

Clients need to know when the log commits to storing the entry, and
collect an inclusion proof. The client could just poll the tree to see
when the entry appears. Once the published tree grows to include the
returned index, the client retrieves corresponding level 0 tile to
check that the entry has the right hash (if it doesn't, it was lost
before the log was able to commit it). This is somewhat unreliable, in
case the log is restarted and loses tentative entries, and it takes a
long time for it to grow back to the expected size.

One could also have a separate poll method. The client could send an
is-tentative request that includes the index and the leaf hash. The
server returns true if this is a tentative entry, not yet persisted
and included in a published checkpoint, otherwise false. When this
returns false, the client can retrieve the tiles for the entry itself
and the tiles needed to construct an inclusion proof, and if that
fails, it knows the log has forgotten the tentative entry and the
client has to retry.

## Operation of secondaries

The main job of a secondary is to store and publish the log data. For
any meaningful replication, there must be at least two secondaries.

At startup, a secondary contacts the primary, says that it wants to
persist data, and asks the primary for its current checkpoint. In case
the secondary is behind, it has to backfill by getting tiles from the
other secondary. To ensure it reliably gets back in sync, it should
still receive updates from the primary, but it can't sign off on any
checkpoints until it has all old data. And it also can't validate the
new entries until it has the old data, so it has to be sotered
separately. The tlog-mirror protocol solves this by having the primary
provide subtreee consistency proof together with the list of entries.
