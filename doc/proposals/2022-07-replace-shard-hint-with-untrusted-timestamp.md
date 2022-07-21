# Proposal

Replace "shard_hint" with "untrusted_timestamp".

A log requires untrusted_timestamp to contain an integer, seconds
since epoch, in the span [now()-24h, now()] ie which is not in the
future and not older than 24h.

# Background

add-leaf's "shard_hint" argument protects against entries being
"replayed" between logs, notably including between two shards of a
given log, eg MyLog2022 and MyLog2023.

# Motivation

- The current design with shard hint makes it possible for anyone to
  replay entries in log A to log B at any time after they've been
  submitted to log A (assuming the two logs are configured with
  overlapping shard hint intervals).

- Bonus: Getting rid of the name "hint" which is not very intuitive.

# Rationale

- One problem with replayed entries is that anyone can consume a
  submitter's rate limit in another log long after it was actually
  submitted.

- Another problem with replayed entries which we do not address here
  is filling up a log operators disk. This is mitigated with stricter
  rate limiting, see "rate_limit".
