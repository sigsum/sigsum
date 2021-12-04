**Title**: Remove arbitrary bytes </br>
**Date**: 2021-12-04 </br>
**State**: Aborted </br>

# Summary
A leaf's checksum is currently an opaque array of 32 arbitrary bytes.  We would
like to change this to H(checksum), so that no logged bytes are arbitrary.  As a
result, the threat of log poisoning goes from unlikely to very unlikely.

# Detailed description
New leaf:
- Shard hint
- H(checksum), was "just checksum"
- Signature
- H(public key)

A signer's signed statement would be for shard hint and H(checksum), not shard
hint and checksum.  The same inputs are provided to the log for add-leaf
submissions.  The log hashes the submitted checksum and then does all
verification as before.  The hashed checksum is stored in the log's leaf.  As
such, it becomes computationally expensive to craft many arbitrary leaf bytes.

Monitors locate data externally based on H(checksum), not checksum.  Note that
monitors can verify observed signatures as before without locating the data.
This is important so that we can be sure a signing operation actually happened.

Verifiers need the same (meta)data distributed, but in the verification step
H(checksum) must be computed to verify signatures and inclusion proofs.

Witnesses are not affected by this change.

Note: a different approach would have been to submit data and let the log hash
that.  Not letting the log see data is a feature:
- The data cannot be analyzed by the log unless its location is known
- The data cannot be expected to be stored in the future
- Each logging request becomes cheaper
