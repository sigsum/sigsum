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

Building on the ascii format used ont he wire when interacting with a
sigsum log, a proof can use the following format, which is essentially
a leaf + cosigned tree ehad + inclusion proof.

```
submitter: CHECKSUM KEYHASH SIGNATURE
log: TREE_SIZE ROOTHASH KEYHASH SIGNATURE
inclusion_path: HASH
inclusion_path: ...

witness: TIMESTAMP KEYHASH SIGNATURE
witness: ...
```

The submitter line corresponds to a leaf, as produced by the
getl-leaves request. CHECKSUM identifies the message that is logged,
KEYHASH identifies the submitter. They "identify" in that the values
are rather useless on there own, to make use of it, the corresponding
message and public key must be available by other means.

The log line represents a tree_head signed by the log, and the KEYHASH
acts as an identifier for the log. There should be a timestamp here as
well, if we don't move timestamps to the cosignature).

The inclusion path lines correspond to get-inclusion-proof, as an
ordered list of hashes of interior nodes. In the corner case of tree
size 1, list will be empty. Since ascii format specifies a single
repeated line, I've added an empty separator line before the witness
lines (there may well be a better way to organize this).

The witness lines correspond to cosignatures from
get-tree-head-cosigned, but the submitter is free to trim the list,
and include cosignatures only from witnesses it knows and expects the
verifier to know as well. The submitter should not inclue a witness
signature it wasn't able to verify.

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
(together with respective role). In addition, policy needs to specify

1. The number of witnesses required. In principle, one could also
   assign different weights to different witnesses, or list all
   subsets of witnesses considered strong enough, but I'd expect
   limited utility of such extensions.
   
2. Constraints on the timestamp. One might want to reject too old
   proofs, e.g., to avoid installing obsolete updates. One might also
   want to reject or postpone very new proofs, to give monitors some
   time to detect and take action on unexpected signatures.
   
3. Revocation (how to act when a monitor discovers that, e.g., a bad
   software update has been added to the log)? Or if there's risk that
   a particular witness' key has been compromised? See appendix.
   
# Appendix: Offline revocation

This is somewhat orthogonal to the sigsum service itself, and not part
of thi sproposal, but I think it is important to have some way to act
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
