Proposal to restructure the ascii key-value representation of requests
and responses, with fixed order of keys, ant with arrays of structs
represented using a single line per entry.

# Background

The current api specification include some messages with multiple
repeated keys. E.g., the response to `get-leaves` includes four keys
(reduced to 3 when `shard_hint` is eliminated) that can be repeated.
The current specification, as I interpret it, says that the response
is a sequence of n `checksum` keys, ordered by leaf index, n
`signature` keys, also ordered by leaf index, etc, but the sequences
can then be interleaved in any arbitrary way.

The objective of this proposal is to have at most one keyword per
message that may be repeated, to avoid order dependencies between
distinct keys. I think this will be conceptually simpler, even though
I don't expect any major simplification in implementation.

To further reduce parsing complexity, also require a fix order of all
keys.

# Ascii key value format

Divide keys into two types. A "regular" key has a single value, must
occur exactly once. Regular keys must occur in the specified order for
the message. The syntax for a message type may specify a single
"repeated" key. A repeated key can occur zero or more times, it must
be after all regular keys. A repeated key can carry multiple values
(but number of values is fixed for each message type; one can think of
the value as representing a struct). When there are multiple value,
they are separated by comma.

Note that the name of the repeated key is redundant in this proposal,
which relates to the lack of support for optional keys, in order to
keep down parsing complexity. If at some point we want to introduce
optional keys, it cold be extended, e.g., by placing optional keys
between regular and repeated, but we then need a clear way to identify
the start of repeated keys.

We could also consider adding an expliit separator, e.g., an empty
line, between regular and repated keys, and then we could drop the key
part from the repeated lines without any ambiguity.

# Naming

Some of the names of keys are under discussion, but out of scope for
this proposal.

# Concrete changes to the api messages

## get-tree-head-to-cosign

Unchanged.

## get-tree-head-cosigned

The keys `key_hash` and `cosignature` in the response are replaced by
a single repeated key, reusing the name `cosignature`.

The new cosignature key carries two values, the key hash and
signature, both hex-encoded
```
cosignature=<key_hash>,<signature>
```

## get-inclusion-proof

It is required that `leaf_index` precedes the repeated key
`inclusion_path` in the response, but otherwise unchanged.

## get-consistency-proof

Unchanged.

## get-leaves

The response is changed, to use a single repeated key, with
each line carrying all the information for a leaf:
```
leaf=<checksum>,<key_hash>,<signature>,<shard_hint>
```

## add-leaf

Unchanged.

## add-cosignature

Unchanged. 

There is a slight inconsistency here, in that a cosignature is
represented with two keys in this request, but with a single
(repeated) key in the response to get-tree-head-cosigned. One could
consider using a single (regular) key with two values, but I lean
towards restricting regular keys to a single value, and accept that
representation is different in this request.

# Security considerations

Main security concern with designing the message format is attacks
that might use invalid or unusual inputs to trigger and exploit bugs
in parsing, and it is therefore important to keep down the complexity.
I think the restructured repeated fields in itself gives a very modest
reduction in implementation complexity, but fixed order of all fields
should have a more significant impact.
