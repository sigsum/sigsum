# Proposal

In api.md, §3.2:

  - Permit that "key_hash" and "cosignature" are omitted by the log when there
    are no witness cosignatures to set in the response.

# Motivation

It should be possible to return success on the get-tree-head-cosigned endpoint
even if no witness provided a co-signature for the current to-cosign tree head.

This change makes it possible to return 200 OK without witnesses.
