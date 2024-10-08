# Draft design for running a tlog witness on a tkey with storage

Upcoming versions of the Tillitis key are expected to support local
storage for apps. Assuming this materializes in a form with sufficient
integrity, this could be used to run a tlog witness that cannot be
compromised by attacking the host computer.

# Storage abstraction

Details of the storage interface defined by tkey formware is not yet
defined. For these notes, we assume that we can store a sequence of
records, where new records are always appended (written at the unused
end of some flash sector). We would need some mechanism to reclaim
sectors with mostly obsolete data, one possibility sketched at the end
of these notes.

# Host responsibilty

We let the host program manage the interaction with the log(s) to
witness, possibly via a bastion host. In particular, it owns the
configuration of which logs we are willing to witness, the translation
of origin string to public key, and any limits on how often we are
willing to cosign each of them. The host program translates a log's
add-checkpoint request to a message sent to the tkey device app. But
as a gate-keeper, the host program must verify the log's signature on
that checkpoint, before forwarding it.

The host is also responsible for time keeping (tkeys don't have any
trusted clock), and it should manage clock synchronization in some
reasonably secure way.

# Messages and responses

The message should include the public key of the log, the current
time, and the decoded contents of an add-checkpoint request: The
origin string, a signed tree head, a consistency proof, and the old
size the consistency proof refers to.

There are three possible outcomes, sent back to the host:

* Success, the host gets a cosignature back, to return to the log.

* Old size conflict, the host should get the previous tree size recorded
  by the witness for this log, and relay back to the log as a 409
  response.
  
* Other errors. The tkey should provide error message to be logged by
  the host, and sufficient detail to return an appropriate http error
  resposne to the log.
  
We will also need some additional messages. There must be a way for
the host to get the witness' public key (similar to the signing oracle
app). It would also be useful with requests to query the witness'
state, e.g., latest recorded tree head for a given log, or maybe dump
list of logs or entire stored state, for trouble shooting.

# Storage record

The witness stores records including

* A log's public key (32 bytes)
* Latest tree head (40 bytes, root hash + size)
* Timestamp (8 bytes)

By storing the timestamp, the witness can ensure that it doesn't make
cosignatures where passage of time and tree growth are inconsistent.
The witness still can't ensure that timestamps correspond to correct
wallclock time, it depends on (aka trusts) the host for timekeeping.
See security considerations below for further discussion.

We could consider also storing signatures

* The log's signature (64 bytes)
* The witness' cosignature (64 bytes, signature also covering 8-byte timestamp)

This could provide some protection against attacks on the storage, but
the utility seems questionable, since the main attack vector is
*deleting* entries, and for that, these signatures don't help. So the
mimimum of 72 byte byte records (or 80 if we also record timestamps)
may be good enough.

# Tkey witness app

The app receives the message corresponding to the add-checkpoint
requests. It then needs these processing steps (terminating with an
error if any step fails):

1. Verify the log's tree head signature, using provided public key and
   origin string.

2. Scan the storage for the record carrying this public key and the
   largest tree size. If none is found, it is treated as if an empty
   tree were stored at the beginning of time.

3. Check that the found tree size equals the old size in the request,
   or fail with a conflict error.

4. Check that provided timestamp is larger or equal to the recorded
   timetamp (if timestamps are recorded).
   
5. Verify the provided consistency proof.

6. If the new size (or time) is larger than the previous one, store
   the provided tree head as a new record for this log, and ensure
   that it is commited to storage by the firmware.

7. Use signing key to produce a cosignature on the tree head, using
   provided origin string and timestamp. Return to host.

# Security considerations

## Rollback

Attacks that can roll back the witness state breaks the witness
promise to only cosign consistent trees. Besides security bugs in the
witness app, we could think about attacks that modify flash storage
outside of the app's control, e.g., physical access, or a different app
exploiting firmware bugs. Authenticating the flash contents using a
MAC and a key derived from the witness secret could help in some cases
(but not, e.g., against an attacker that uses physical access to make
a complete flash backup, restored at a later time).

Of particular importance are any mechanisms for factory reset of the
tkey. If it's possible to reset storage outside of the app's control,
such a reset must also destroy the witness key/identity.

## Timetamps

What attacks are possible because the witness blindly applies
timestamps provided by the host? Anyone on the path between log and
witness can stop providing fresh treeheads to the witness, instead
passing historic tree heads and get those cosigned with fresh
timestamps; so that attack is not unique to this setting. The
consistency check means that once a larger tree has been cosigned,
older tree heads will not be cosigned, and if the witness' clock
matches real wall clock, cosignatures on older trees will carry older
timestamps.

If we don't record timestamps in the tkey storage, a compromised host
could pass on any current tree head with a timestamp far into the
future, keep resulting cosignature for later use, and continue to pass
tree heads with accurate timestamps as the tree grows. This particular
attack will no longer be possible if the tkey stores timestamps and
ensure they're monotonically increasing.

One could maybe argue that an attacker compromising the host is
unlikely to use timestamps that are far off for cosignatures shared
publicly (both the log itself and monitors will notice that the
witness is behaving oddly, drawing attention to the attack). Enforcing
monotonicity by recording timestamps on the tkey therefore seems to
provide some value: If the attacker wants the witness to appear to
operate normally, the range of potential false timestamps that the
host can get the witness to cosign is rather limited: it must fall
between the cosignature timetamps on the previous and the next tree
size that the attacker wants to distribute publicly.

# Reclaiming storage

One possible way to reclaim storage is as follows: When we need to
allocate a new flash sector, read the oldest sector, and for each
record check if that is still the largest one recorded for that log.
If it is, copy it to the newly allocated sector, and ensure that it is
properly committed. After all those old records are examined and
possibly copied, erase the old sector (the corner case that all
records must be kept needs special handling).

If we use available sectors in a cyclical manner, and don't reclaim
space in this way until we have used some substantive fraction of
available space, we should get reasonable flash wear. Unless we take
some additional steps to manage the storage, the app will still need
to read *all* of its allocated storage at startup, to identify the
used portion of its storage (unused parts are identified by all-ones
records, produced by the flash erase operation).
