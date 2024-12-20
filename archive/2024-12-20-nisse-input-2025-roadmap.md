# Ideas for planning Sigsum work for 2025

author: nisse

# Suggested end-to-end usecase

Archiving monitor:

* Publisher provides policy (logs + witnesses), its submission key(s),
  and a url that can be used for checksum->data lookup. To avoid
  DoSing monitors, there should be at least a claim on some maximum
  size (per item and per time period).

* Monitor tails the log, downloads and archives the data for each
  checksum found. Warns if Sigsum log+witnesses misbehave, data is
  unavailable, or doesn't satisfy claims.

# Flesh out the byzantine-witnesses notes

Open issues:

* How to specify assumptions on how many compromised witnesses can/should be tolerated?

* Stricter analysis of hierarchical witness groups.

# Improve monitor

* Take witness cosignatures into account, and implement "dual policy"
  according to how that is defined above.

# Log server

* Add endpoints supporting checkpoint and tiles.

# Tooling

* See if we can define a sane "default policy" for available prod
  log(s) and witnesses.
