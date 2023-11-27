# Proposal: rename `add-tree-head` to `add-checkpoint`

In the protocol described by option 2 of proposals/2023-08-witness-apis, rename
the `add-tree-head` endpoint to `add-checkpoint`.

We are aligning with other implementations around the name checkpoint, which
is/will be a well-specified format for a tree head, and the endpoint accepts
specifically a signed checkpoint, so it makes sense to be specific.
