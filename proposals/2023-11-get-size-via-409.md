# Proposal: replace `get-tree-size` with a 409 response

In the protocol described by option 2 of proposals/2023-08-witness-apis, remove
the `get-tree-size` endpoint, and instead specify that when a witness returns a
409 Conflict from `add-tree-head`/`add-checkpoint` because the old size is not
correct, the response body will contain the tree size known to the witness in
decimal, without leading zeroes, followed by a newline.

The response will have a `Content-Type` of `text/x.tlog.size`.

The response will be naturally non-cacheable because
`add-tree-head`/`add-checkpoint` is a POST.

`get-tree-size` was only necessary after a 409 response anyway, because usually
the entity submitting to a witness is the log, which keeps track of the last
view of the witness. If that view gets out of sync, a 409 will happen and the
correct size is necessary to recover. Returning that value with the 409 response
is more efficient, simplifies the API, and removes the use of query parameters.
