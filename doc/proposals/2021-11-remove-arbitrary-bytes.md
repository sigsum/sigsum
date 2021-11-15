# Remove arbitrary bytes
A leaf's checksum is currently an opaque array of 32 arbitrary bytes.  We would
like to change this to H(checksum), so that no logged bytes are arbitrary.  As a
result, the threat of log poisoning goes from unlikely to very unlikely.

## Details
New leaf:
- Shard hint
- H(checksum), was "just checksum"
- Signature
- H(public key)

A signer's signed statement must be for H(checksum), not checksum.  In other
words, a signer basically signs H(H(data)), then checksum<-H(data) is submitted
on our current add-leaf endpoint.  The log computes H(checksum) for incoming
add-leaf requests.  No other changes are required for the log's leaf endpoints.

Monitors locate data externally based on H(checksum), not checksum.  Note that
monitors can verify observed signatures as before without locating the data.
This is important so that we can be sure a signing operation actually happened.

Verifiers need the same (meta)data distributed, but in the verification step
H(checksum) must be computed to verify signatures and inclusion proofs.

Witnesses are not affected by this change.

## Other
A different approach would be to submit data and let the log hash that.  Not
letting the log see data is a feature:
- The data cannot be analyzed by the log unless its location is known
- The data cannot be expected to be stored in the future
- Each logging request becomes cheaper
