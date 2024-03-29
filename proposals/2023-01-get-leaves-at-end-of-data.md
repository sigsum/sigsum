Proposal to not refuse get-leaves requests where the `end_index` of
the request exceeds the current tree size, or `start_index` equals the
current tree size.

# Motivation

The internal get-leaves endpoint is used by the log secondary to
"tail" a log, i.e., periodically poll for new leaves added to the
tree, independently from querying for tree heads. It depends on the
log to not reject get-leaves requests with end-index beyond the end of
the tree, and instead just have the end index clamped to the end.

This approach might make sense also for the external get-leaves
endpoint, to improve consistency.

And there may be additional usecases. E.g., a monitor organized as one
component reading all leaves, and independently reconstructing the
tree, and a separate component retrieving cosigned tree heads.

# Request validity

Request validity depends on three non-negative numbers: the
`start_index`, and `end_index` of the request, and the current tree
`size`. Tree size here means the tree that the log is committed to
publishing (not necessarily part of a publicly advertised tree head
yet, but if not, irrevocably in the process to get into an advertised
tree head, e.g, being distributed to witnesses for cosigning).

The proposed validation conditions are:

1. `start_index < end_index`
   
2. `start_index <= size`

If these conditions are not satisfied, the log responds with 400 Bad
Request. 

# Log server behavior for valid requests

The case of `start_index == size` is special. In this case, the
log must respond with HTTP status 404 Not Found, and no response
body. 

For all other valid requests, the response should be status 200
Success and a response body with at least one leaf (except for
unexpected error conditions, like 500 Internal Server Error).

In case `end_index > size`, the log will simply clamp to `size`. (In
the case `start_index == size`, we always get `start_index ==
end_index` after clamping. That's not an error, it's still the 404
case, even though that range would be invalid (400) if it occured
before clamping).

# Backwards compatibility

Adopting this proposal only changess the meaning of certain requests
that currently are invalid. So it should be doable without a need to
change the protocol version or introduce a new endpoint name.

# Tailing a log

Tailing operation is then rather easy. Assume that a client already
has a partial local copy of the log's tree, and want to extend the
local copy as the log grows.

The client then repeatedly sends get-leaves request. In each request,
the `start_index` is the size of a local copy, `end_index` is the same
size plus some batch size constant, e.g, always `start_index + 100`.
If the log's response is 200, the client adds the received leaves to
the local copy and starts over with a new request. If the log's
response is 404, the copy is (temporarily) complete, and the client
should sleep for some period of time, before repeating. If the log's
response status is anything else, that indicates an error, handling of
which is out of scope for this note.

# Replication by the secondary node

The secondary node would tail the primary log just like above, with
only one difference: The secondary needs to get also leaves that the
primary has not yet committed to publishing. It will therefore need to
use the internal version of the get-leaves endpoint. In the log
server, the only difference (just like in the current implementation)
is the tree size used. 

Request validation and handling should use a different notion of tree
size, that includes all non-committed leaves that the primary wants
the secondary to replicate.

The replication has now been reworked in this way, enabling deletion
of the internal endpoint `get-tree-head-unsigned`.
