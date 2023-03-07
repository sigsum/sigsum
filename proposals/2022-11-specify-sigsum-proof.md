Proposal to specify what a "sigsum proof" is, and how it can be
represented.

# Sigsum proof

Our current docs don't specify what a sigsum proof is. The rough idea
is that one party, the *submitter*, interacts with the log to submit
a message, and collect related inclusion proof and cosignatures. This
is packaged, together with message and any associated data to a
*verifier*, e.g., a software update client that uses this information
to decide whether or not an update should be installed.

We need terminology for this, so let's call the package a "sigsum
proof". We can think about it as a proof of public logging, and it can
be verified offline.

# Syntax/serialization

In principle, each application can choose it's own representation,
e.g., if a proof is incorporated inside a future version of a binary
debian package. But it's desirable to specify a concrete format, to
make it easier to reason about the contents, and have something that
the sigsum command line tools can work with.

## Ascii representation

Building on the ascii format used on the wire when interacting with a
sigsum log, a proof can use the following format, which is essentially
a log and version id, a leaf (but with truncated checksum) + cosigned
tree head + inclusion proof, with an empty line (i.e., double newline
character) separating these parts.

```
version=0
log=KEYHASH
leaf=SHORT-CHECKSUM KEYHASH SIGNATURE

tree_size=NUMBER
root_hash=HASH
signature=SIGNATURE
cosignature=KEYHASH TIMESTAMP SIGNATURE
cosignature=...

leaf_index=NUMBER
node_hash=HASH
node_hash=...
```

The version line specifies the version of the proof format, and will
be incremented as the format is changed or extended. The `log` line
identifies the sigsum log. In the next line, `leaf` is similar to the
response to get-leaves, but the checksum is truncated to only the
first 16 bits (4 hex digits); full checksum must be derived from other
context.

The last two blocks are verbatim responses from get-tree-head-cosigned
and get-inclusion proof (in the corner case `tree_size` = 1, the last
part is omitted, since it is implied that `leaf_index` = 0, and there
is no inclusion path).

# Verifying a proof

To verify a sigsum proof, as defined above, the verifier needs
additional information.

1. It needs to know the message being logged. Typically, this is the
   hash of some file, and that file is distributed together with the
   proof. Then `message = H(file)`. The verifier must compute
   `checksum = H(message)`, and check that it matches the truncated
   checksum on the leaf line. (This check serves to detect accidental
   mismatch between message and proof).
   
2. It needs to know the submitter's public key. Verififier must check
   that the leaf signature (with `checksum` computed as above) is valid.
   
4. It needs to know the log's public key. Verifier must check that the
   log's tree head signature is valid.
   
5. It must know the public keys of some the witnesses, and verify
   corresponding cosignatures. Policy determines how many valid
   cosignatures are deemed to be sufficient.
   
6. Verifier must check that the inclusion proof is valid. The leaf
   hash must be reconstructed from the leaf line and the computed
   `checksum`.
      
## Policy

Verification is subject to client "policy". Policy includes the
configuration of public keys for submitter, log and witnesses
(together with respective role). Policy must also specify which
subsets of witnesses are considered strong enough, the details are out
of scope for this proposal, but, e.g., one could use an n-of-k policy
or something a bit more expressive.

# Appendices

These are related features, not part of this proposal, but they may be
subject of later extensions to the proof format.

## Offline revocation

This is somewhat orthogonal to the sigsum service itself, and not part
of this proposal, but I think it is important to have some way to act
when a monitor discovers an unexpected signature log. The basic idea
is based on SPKI revalidation, see [SPKI structure
draft](https://theworld.com/~cme/spki.txt).

Let's define a revocation authority as follows: The authority
maintains a list of revoked items. Anyone can submit a query "is this
item revoked?", and if it is not, the authority responds with a signed
statement with the claim "as of time ..., item ... is not revoked".

In the sigsum context, it would make some sense to have a revocation
authority close to the monitor. A monitor follows a sigsum log (it
retrieves all leaves, taking consistency with signed tree heads into
account, and filters out the ones with a keyhash of interest). When it
finds a signature that shouldn't be there, it can add the
corresponding checksum to its revocation list.

To make use of this, client policy should require that, in addition to
the sigsum proof, there should also be signed statement from the
appropriate revocation authority saying that the checksum is not
revoked, and that statement must be recent (one could have an expiry
time in the statement, but I think it makes more sense to let that be
part of client policy).

I imagine that the submitter will not be the one querying the
revocation authority, instead, it will be the job of the system
distributing the sigsum proof and associated data to the client that
will be responsible for retrieving the "not revoked" statement and
attach it to the package, close in time to actual delivery to the
client. For this to work with a minimum of configuration, it might
make sense to put an id (url + public key?) of the revocation
authority inside or nearby the sigsum proof.

## Timestamp constraints

One might want to reject too old proofs, e.g., to avoid installing
obsolete updates. One might also want to reject or postpone very new
proofs, to give monitors some time to detect and take action on
unexpected signatures.

To support this, a sigsum proof needs to provide two cosigned tree
heads. A newer tree head, to which the inclusion proof applies, and an
older tree with size <= the leaf index for the inclusion proof. This
proves that the checksum was published by the log during the time interval
bounded by the cosignature timestamps on those two tree heads.
