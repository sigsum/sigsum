Notes by nisse, after discussion with ln5.

# Question: What's the value of the log's tree head signature to verifiers?

Witnesses obviously have to verify the log's tree head signature
before cosigning (since it has no other indication that the log has
committed to publishing that tree head).

But what value is there in verifiers to check the log's signature?
After all, verifier's trust should be in witnesses, not logs? Can we
skip that? Then verifiers wouldn't even need to be configured with log
keys or other log identifiers.

Consider an attacker that wants to get a verifier to accept a rogue
update. The attacker somehow obtains a valid leaf signature for the
rogue update, and submits it to the log, where it will be properly
cosigned. Update will be accepted by the verifier, but a monitor will
be able to eventually detect the attack, via the entry in the log.

But if the verifier ignores log signature, then there's a variant of
this attack. Assume that the attacker is able to corrupt k out of n
witnesses. Then the attacker, in collusion with those witnesses, can
construct a new tree, add the leaf, and produce a valid sigsum proof
with a cosigned tree head + inclusion proofs. (The effect is the same
as if the verifier automatically trust any new log that witnesses
cosign).

This could be a big deal for monitors: in this variant of the attack,
the monitor will never see the rogue leaf, and the attack goes
undetected.

For this reason, it makes sense for verifiers to require that the log
entry is signed by a log known to be monitored by the relevant key
holder.

## Exactly what consequences do we expect if k of n witnesses are compromised?

Are there other (easier) attacks where compromise of witnesses
completely breaks detection of key misuse? If so, protection from
verifying the log signature still seems low.

# Conversely, what's the value of cosignatures to monitors?

By this argument, it also seems desirable that a monitor checks *all*
new leaves published by a log, and alert on unexpected signatures,
regardless of whether or not those leaves are cosigned by any witnesses.

It seems that monitors should depend on cosignatures exclusively for
freshness: When the monitor sees a tree head that is cosigned by a
configured quorum of witnesses, it can examine the timestamps. If the
timestamps say that tree head is too old, or too long time passes
before it sees the next properly cosigned tree head, it should alert
that log appears stale.
