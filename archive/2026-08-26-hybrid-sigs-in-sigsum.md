# Using hybrid signatures in Sigsum?

author: nisse
date: 2026-08-26, updated 2026-09-03

## Intro

A "hybrid signature" is a signature using two separate algorithms
(e.g., Ed25519 + ML-DSA), with the understanding that *both* signatures
must validate for the signed item to be accepted. This provides some
protection in case the adversary gets the ability to break one of the
algorithms, but not both.

This is relevant when (i) signatures are going to be verified in the
future, (ii) verifier policy is set now and hard to update. (It may
also be of some importance for how long we expect the adversary to
keep their new cryptographic abilities secret).

So this is different from merely transitioning to a new algorithm,
where we can have a mix of verifier policies knowing only the old
algorithm, only the new algorithm, or accepting a signature by either
algorithm.

Let's see how this could be applied in Sigsum (i.e., assuming we make
necessary changes to depart from the original ED25519-only design),
with the cases in increasing difficulty.

## Witness signatures

This is easy. A checkpoint can carry multiple cosignature lines from
the same witness, with different algorithms, and policy can express
that both are required. Current Sigsum format don't support
non-Ed25519 signatures at all, but once that is added (possibly based
on the C2SP checkpoint and tlog-proof specs), representing hybrid
signatures as policy should work fine.

Note that there's flexibility in how to structure the policy. The
maybe most obvious way is to define one "all" group for each witness,
listing both Ed25519 and ML-DSA keys, and then define the rest of the
policy in terms of those groups. Alternatively, one could define one
group tree involving only Ed25519 keys, and a similar second group
tree (with more or less the same witnesses and thresholds) but listing
the ML-DSA keys. And then at top level have an all group listing those
two as members.

## Log signatures

A checkpoint can carry multiple log signature lines (same origin
line/keyname, different keyid). But we'd need a way to specify
multiple keys for the same log, plus a way to say that both are
required (separating the hybrid signature case from key rotation).
This would be more or less the same thing as a new key type
representing the hybrid combination.

## Leaf signatures

Here, there is are many different options.

1. Submit the same item twice, using different signing keys, and
   distribute two proofs. Verifier would need a kind of meta-policy,
   with one "normal" Sigsum policy for each algorithm, and a
   requirement that an item must come with a set of proofs such that
   both policies can be satisfied.

2. Add support for multiple signatures in the leaf format, with
   independent key hashes that can be monitored independently. This
   might be generally useful, e.g., for key-rotation or k-of-n
   signatures on the submitter side, even though that goes against
   Sigsum's aim of being minimalistic. But to use such multiple
   signatures as *hybrid* signatures (in contrast to key rotation),
   verifier policy would need a key type representing a hybrid
   combination, similar to log keys.

3. Keep only a single signature field in the leaf format, but
   introduce a hybrid signature type that can be inserted there.
   Monitoring is based on the hash of the combined hybrid pubkey.

4. Use a hybrid construction of one transparent signature and one
   non-transparent one. I.e., when signing an artifact, sign using
   both Ed25519 and ML-DSA, but submit only one of them (say, the
   Ed25519 one) to Sigsum. Verifier would then require a Sigsum proof
   based on the Ed25519 submit key, *and* a separate signature using
   ML-DSA.

   This achieves discoverability in the sense that every signed
   artifact is visible in the log. But what happens if the adversary
   has a quantum computer and can break Ed25519? In case policy only
   requires Ed25519 signatures from witnesses, discoverability is
   completely broken. So assume witness signatures use some algorithm
   that isn't compromised by the adversary. Then the attacker can
   forge valid Ed25519 signatures and submit any data to the log. When
   this is discovered, we get ourselves in a somewhat uncertain
   situation. We don't know whether or not the adversary also has
   compromised the ML-DSA key. *If* the adversary has compromised that
   key, then submitting the Ed25519 signature to the log lets the
   adversary distribute artifacts that will be accepted by verifiers.
   If the adversary has *not* compromised the ML-DSA, then verifiers
   are still safe, but we can't know. So we would have to either
   rotate both keys (and preferably, take Ed25519 out of the picture),
   or keep trusting the ML-DSA key, but then we no longer get any
   transparency.

5. Add additional key hashes and signature hashes to the leaf, as
   opaque data, not verified by the log. This can provide
   discoverability of additional signatures, but with the drawback
   that in case the opaque signature can't be verified, a monitor or
   verifier can't know if the submitter logged an invalid signature,
   or if the log is is misbehaving and put something different than
   the submitter's valid signature into the log.

## Other conservative options

The perceived need for hybrid signatures comes from doubts on the
security of ML-DSA (or lattice-based systems in general), or
skepticism that plain old Ed25519 is at real risk. Debates are likely
to go on for some more time.

A different way to avoid putting all eggs in the ML-DSA basket would
be to add support for some other, more conservative, post-quantum
signature algorithm, e.g., SLH-DSA. This could make sense in
particular if a verification policy is expected to live for a long
time and be hard to update.

To me, adopting a very conservatively designed signature algorithm
seems more sane, and a better use of development time, than
implementing a hybrid combination of two algorithms, each of which is
debatable when used for long-term security.

## Tentative recommendations

1. For witnesses, strongly recommend that they provide cosignatures
   using both Ed25519 and ML-DSA. Recommend that policies require
   both, wherever possible.

2. For logs, recommend that they provide signatures using both Ed25519
   and ML-DSA. But don't prioritize work to add hybrid semantics at
   the verifier side. After all, the Sigsum threat model allows the
   adversary to compromise the log, and given that witnesses stay
   secure, log key compromise lets the attacker mount a DoS attack at
   worst.

3. For log leaves, stick to the model of one key hash, one signature,
   but open for other signature algorithms than Ed25519. Users not
   happy with a transparent Ed25519 or a transparent ML-DSA signature
   will have to use a "full hybrid" signature scheme with its one
   serialization of public keys and signatures. If there's popular
   demand, hopefully someone else can sort out those details, and all
   we need is a code point identifying the new type when submitted to
   the log.

4. Be prepared to add support for SLH-DSA, if/when users ask for that.
   I think it makes most sense to use the "s" flavors with smaller
   signatures; this prefers smaller signatures and faster verification
   at the cost of slower signing.
