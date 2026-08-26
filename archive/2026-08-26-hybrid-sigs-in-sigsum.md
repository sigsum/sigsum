# Using hybrid signatures in Sigsum?

author: nisse

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

Let's see how this could be applied in Sigsum, with the cases in
increasing difficulty.

## Witness signatures

This is easy. A checkpoint can carry multiple cosignature lines from
the same witness, with different algorithms, and policy can express
that both are required. Current Sigsum format don't support
non-Ed25519 signatures at all, but once that is added (possibly based
on the C2SP checkpoint and tlog-proof specs), representing hybrid
signatures as policy should work fine.

## Log signatures

A checkpoint can carry multiple log signature lines (same origin
line/keyname, different keyid). But we'd need a way to specify
multiple keys for the same log, plus a way to say that both are
required (separating the hybrid signature case from key rotation).
This would be more or less the same thing as a new key type
representing the hybrid combination.

## Leaf signatures

Here, I see three main options:

1. Submit the same item twice, using different signing keys, and
   distribute two proofs. Verifier would need a kind of meta-policy,
   with one "normal" Sigsum policy for each algorithm, and a
   requirement that an item must come with a set of proofs such that
   both policies can be satisfied.

2. Add support for multiple signatures in the leaf format, with
   independent key ids that can be monitored independently. This might
   be generally useful, e.g., for key-rotation or k-of-n signatures on
   the submitter side, even though that goes against Sigsum's aim of
   being minimalistic. But to use such multiple signatures as *hybrid*
   signatures (in contrast to key rotation), verifier policy would
   need a key type representing a hybrid combination, similar to log
   keys.

3. Keep only a single signature field in the leaf format, but
   introduce a hybrid signature type that can be inserted there.
   Monitoring is based on the id of the combined hybrid key.

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
