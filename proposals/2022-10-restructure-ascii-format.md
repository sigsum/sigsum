Proposal to restructure the ascii key-value representation of requests
and responses, with fixed order of keys, and with arrays of structs
represented using a single line per entry.

# Background

The current api specification allows keys to appear in any order.
Parsing gets simpler if order is fully specified. There are also some
messages with multiple repeated keys. E.g., the response to
`get-leaves` includes three keys that can be repeated. The current
specification, as I interpret it, says that the response is a sequence
of n `checksum` keys, ordered by leaf index, n `signature` keys, also
ordered by leaf index, etc, but the sequences may be interleaved in
any arbitrary way.

The objective of this proposal is to 

1. fully specify the order of keys, and 

2. allow at most one keyword per message to be repeated. 

I think this will be conceptually simpler, and also enable simpler
parsing code.

# Ascii key value format

Divide keys into two types. A "mandatory" key must occur exactly once,
and in the specified order for the message. The syntax for a message
may specify a single "repeated" key. A repeated key can be occur zero
or more times, after all mandatory keys. A key can carry multiple
values (but number of values is fixed for each key; one can think of
the value as representing a struct). When there are multiple values,
they are separated by a single space.

# Naming

Some of the names of keys are under discussion, but out of scope for
this proposal.

# Concrete changes to the api messages

This proposal changes the syntax of all requests and responses with
more than one key, since the each requests and response is now
required to list keys in the same order as they are listed in the api
specification. Below sections describes changes, beyond this ordering
requirement, that applies to each of the sigsum requests.

## get-tree-head-to-cosign

None.

## get-tree-head-cosigned

The keys `key_hash` and `cosignature` in the response are replaced by
a single repeated key, reusing the name `cosignature`.

The new cosignature key carries two values, the key hash and
signature, both hex-encoded
```
cosignature=<key_hash> <signature>
```

## get-inclusion-proof

It is required that `leaf_index` precedes the repeated key
`inclusion_path` in the response, but otherwise unchanged.

## get-consistency-proof

None.

## get-leaves

The response is changed to use a single repeated key, with
each line carrying all the information for a leaf:
```
leaf=<checksum> <key_hash> <signature>
```

## add-leaf

None.

## add-cosignature

The cosignature in the request is changed to single-line format:
```
cosignature=<key_hash> <signature>
```
This is done for consistency with the cosignature representation in
the `get-tree-head-cosigned` response. This is only mandatory key
with multiple values.

# Security considerations

The main security concern with designing the message format is attacks
that might use invalid or unusual inputs to trigger and exploit bugs
in parsing, and it is therefore important to keep down the complexity.
I think the restructured repeated fields in itself gives a very modest
reduction in implementation complexity, while the fixed order for all
fields gives a more significant reduction.

# Extensibility

This format can easily be extended with optional but non-repeated keys
if the need arises, but currently we don't have any optional keys.

Note that the name of keys is somewhat redundant in this proposal. The
names are kept for clarity, and to ensure that future extensions can
either be backwards compatible, or fail in an obvious way on version
mismatch.

# Key order

During sucussion of this proposal, it was suggested that keys should
be listed in alphabetic/lexicographic order. That would let a general
parser validate proper order, and populate an unordered map with keys
and values, without knowing the particular details of the message. Not
included in this proposal because:

* Repeated keys (always last) would appear out of order, which needs
further work to fit in this model.

* With the very small number of messages, we expect a parser function
for each message, with no need for an intermediate step to populate a
map with keys and values.
