Proposal to restructure the ascii key-value representation of requests
and responses, with arrays of structs represented using a single line
per entry.

# Background

The current api specification include some messages with multiple
repeated keys. E.g., the response to `get-leaves` includes four keys
(reduced to 3 when `shard_hint` is eliminated) that can be repeated.
The curent specification, as I interpret it, says that the response is
a sequence of n `checksum` keys, ordered by leaf index, n `signature`
keys, also ordered by leaf index, etc, but the sequences can be
interleaved in any arbitrary way.

The objective of this proposal is to have at most one keyword per
message that may be repeated, to avoid order dependencies between
distinct keys. I thnk this will be conceptually simpler, even though I
don't expect any major simplification in implementation.

# Ascii key value format

Divide keys into two types. A "regular" key has a single value, and
must occur exactly one time, and regular keys can occur in any order.
The syntax for a message may specify a single "repeated" key. A
repeated key can occur zero or more times, it must be after all
regular keys. A repeated key can carry multiple values (but number of
values is fixed for each message type; one can think of the value as
representing a struct). When there are multiple value, they are
separated by comma.

This format can easily be extended with regular but optional keys if
the need arises, but currently we don't have any optional keys.

Note that the name of the repeated key is somewhat redundant in this
proposal, the only reason we need key + equals character on the lines
carrying the repeated key is to make it obvious where the regular keys
end and the lines with the repeated data starts. If we used a
different way to indicate this (e.g., empty line), we could drop the
"key" part from the repeated lines. That way, we would get structure
more similar to headers + body as found in http and smtp.

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
I think the proposal gives a very modest reduction in implementation
complexity.
