Proposal to specify what a "sigsum proof" is, and how it can be
represented.

# Sigsum proof

Our current docs don't specify what a sigsum proof is. The rought idea
is tha one party, the *submitter*, interacts with the log to submit
a message, and collect related inclusion proof and cosignatures. This
is package, together with message and any associated data to a
*verifier*, e.g., a software update client that uses this information
to decide whether or not an update package should be installed.

We need terminology for this, so let's call the package a "sigsum
proof". We can think about it as a proof of public logging, and it can
be verified offline.

# Syntax/serialization

In principle, each application can choose it's own representation,
e.g., if a proof is incorporated inside a future version of a binary
debian package. But it's desirable to specify a conrete format, to
make it easier to reason about the contents, and have something that
the sigsum command line tools can work with.

## Ascii representation

Building on the ascii format used on the wire when interacting with a
sigsum log, a proof can use the following format, which is essentially
a leaf + cosigned tree head + inclusion proof, with an empty line
(i.e., double newline character) separating these parts.

```
version=0
log=KEYHASH

leaf=KEYHASH SIGNATURE

timestamp=NUMBER
tree_size=NUMBER
root_hash=HASH
signature=SIGNATURE
cosignature=KEYHASH SIGNATURE
cosignature=...

leaf_index=NUMBER
inclusion_path=HASH
inclusion_path=...
```

The version line specifies hte version of the proof format, and will
be incremented as the format is changed or extended. The `log` line
identifies the sigsum log.

In the next block, `leaf` is similar to the response to get-leaves, but
the checksum that is signed is omitted, and must be derived from other
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
   proof. Then message = H(file). The verifier must check that
   H(message) = CHECKSUM and that the submitter's signature is valid.
   
   Q: Checksum is redundant, if it's clear from context which
   file/message the proof applies to. So should we drop it from the
   proof?

2. It needs to know the log's public key. Verifier must check that the
   log's signature is valid.
   
   Q: Should we care about verifying signature? Or are witness
   signatures enough? If we only know the log's keyhash (effectively,
   the id of the log), that's bound to the tree via the tree head
   signed by witnesses.
   
3. Verifier must check that the inclusion proof is valid. No
   additional information is needed, but the leaf hash must be
   reconstructed from the proof.
   
4. It must know the public keys of some or all of the witnesses, and
   verify corresponding signatures.
   
## Policy

Verification is subject to client "policy". Policy includes the
configuration of public keys for submitter, log and witnesses
(together with respective role). Policy must also specify which
subsets of witnesses are considered strong enough, e.g., n-of-k policy
(it is likely that something a bit more expressive will be needed,
though, e.g, a partition of the witnesses into disjoint subsets, and a
separate n-of-k requirement for each such subset).

# Appendices

These are related features, not part of this proposal, but they may be
subject of later extensions to the proof format.

## Offline revocation

This is somewhat orthogonal to the sigsum service itself, and not part
of this proposal, but I think it is important to have some way to act
when a monitor discovers an unexpected signature log. The basic idea
is taken from a discussion in the spki context (but I can't find a
good reference).

Let's define a revocation authority as follows: The authority
maintains a list of revoked items. Anyone can submit a query "is this
item revoked?", and if it is not, the authority responds with a signed
statement with the claim "as of time ..., item ... is not revoked".

In the sigsum context, it would make some sense to have an revocation
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
proves that the checksum was added to the log during the time interval
bounded by the timestamps on those two tree heads.
