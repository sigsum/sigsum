# Open-ended shard interval
We would like to remove `shard_end` from a log's static metadata, and instead
have an open-ended shard-interval.  An open-ended shard interval allows an
operator to continue its log operations without starting a new log unless it
really necessary.  This should make it easier to maintain lists of known logs.

## Details
An operator defines how long they intend to run a log at minimum.  The log
operator may increase this time later on but should not decrease it.  The log
operator should give an account for how they plan to achieve said operations,
and possibly under which circumstances they will (not) extend a log's lifetime.

So, `shard_end` is not fixed and instead closely related to log policy.

For a log to accept a submission, the submitted leaf must fit into the log's
shard interval.  This interval is open-ended: `[shard_start, now()]`.

By still having a shard interval, it is possible for a new log to protect itself
from replayed leaves that were logged in a different log before `shard_start`.

A signer can set `shard_hint` to 

	max([ shard_start for shard_start in list_of_active_logs ])

to ensure that logging requests can be performed in all active logs.

We think that this setup could work with hard-coded, manually adjusted, and
dynamically adjusted log policies; all with different trade-offs of course.

## Other
- We need to create a best practise document for log operations.  It would also
be helpful for verifiers to assess if it is a good idea to rely on a log.
- We should probably define an error that indicates that a log was toggled into
read-only mode, in preparation of a complete shutdown.
