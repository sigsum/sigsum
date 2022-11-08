# Timestamped signatures and witness rosters

## Background

In the Sigsum design, tree heads include timestamps for two purposes: as a way to provide a trusted time range in which a leaf was added (timestamping), and as a way to show monitors that the progress of the tree is not being hidden from them (freshness).

For the freshness guarantee to work, the log has to keep producing tree heads, even if it is not extending the log. This might be undesirable, especially for lightweight trees that see very little traffic.

This also requires witnesses to refuse signing tree heads that are “too old”. How old is “too old” is problematic to determine, since different ecosystems will have different tightness requirements for both timestamping and freshness. It also presents operational complexity, because a log that fails to get a tree head signed for “too long” (for example because the witness temporarily went offline) will have to discard the tree head and produce a new one instead of continuing to retry.

## Timestamps as part of the signature

This proposal suggests making the timestamp a part of the witness co-signature instead of part of the tree head. This moves the decision of what is “too old” to the relying parties, which can be tailored to the ecosystem, and resolves the issue with stale tree heads.

A witness co-signature would consist of a timestamp at which the signature was produced, and a signature over both the tree head and the timestamp (for example, by placing the timestamp in a context field).

This also has the advantage of making it easier to switch to the “signed note” tree head format used by the Go Checksum Database and other deployments if desired in the future. The witnesses can produce both timestamped and non-timestamped signatures if necessary for backwards compatibility.

## Witnesses rosters

To simplify freshness checks and remove the requirement to keep producing tree heads, this proposal suggests making witnesses publish a roster: a list of log public keys and the last time at which a co-signature was produced for that log.

Monitors would check the roster of each witness they trust to ensure they are not being left behind. Since freshness is only a concern for monitors, clients would ignore the rosters.

Rosters don’t add significant operational overhead or risk for witnesses: the roster can be a static asset pushed to a static hosting service periodically, it would receive limited traffic as it’s only relevant to monitors, and it doesn’t have high availability requirements as only freshness checking is degraded if it goes offline.