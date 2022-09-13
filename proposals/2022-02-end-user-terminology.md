# Background
We are not entirely happy with the terminology "signer" and "verifier", see
[earlier proposal][] and [meeting minutes][].  At a first glance "author" seemed
like a good abstract description.  More work was needed to replace "verifier".

[earlier proposal]: https://git.sigsum.org/sigsum/tree/doc/proposals/2022-01-author-reader-terminology
[meeting minutes]: https://git.sigsum.org/sigsum/tree/archive/2022-01-18--meeting-minutes

# Proposal
1. Keep the terminology "signer".
2. Replace "verifier" with "end-user"

The motivation for keeping "signer" is that it feels natural when we have
conversations about Sigsum.  The other natural term for the party which will use
the signed data in the end is "user".  We often say "end-user" for emphasis.

# Notes
Signer will continue to be overloaded.  We should be upfront about this where
there is risk for confusion (logs and witnesses are also signers of tree heads).

Not introducing abstract terminology unless it is needed is likely a win.
