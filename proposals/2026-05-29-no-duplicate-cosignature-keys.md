# Proposal to reject cosignature lists with duplicate key hashes

## Duplicates according to the current specs

The current [log api][] defines the response for the `get-tree-head`
end point, but it does not say explicitly that there can't be multiple
cosignature lines with the same key hash, although I think the
intention to not have multiple signatures by the same key.

Then a [Sigsum proof][] includes a cosigned tree head, including
cosignatures, and the `sigsum-submit` tool essentially copies these
verbatim from the `get-tree-head` response (even though filtering the
list to remove some cosignature lines have been under consideration).

Handling of any duplicates is also not explicitly described, but I
think the reasonable interpretation (and current implementation)
considers a known witness to have cosigned the check point if there is
at least one csignature line with that witness' key hash and a
signature that is valid.

[log api]: ../log.md
[Sigsum proof]: https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/sigsum-proof.md

## Duplicates according to the current implementation

In `sigsum-go` currently represents the set of cosignatures in a
`CosignedTreeHead`as a `map[crypto.Hash]Cosignature`, and the
corresponding parsing functions already fail on duplicates,
```
if _, ok := cosignatures[keyHash]; ok {
	return nil, false, fmt.Errorf("duplicate cosignature keyhash")
}
cosignatures[keyHash] = cs
```

## Semantics of duplicate cosignatures

Multiple cosignature lines with unknown key hashes or known key hashes
but invalid signatures could be silently ignored with no semantic
subtleties.

But if there are multiple valid cosignatures by the same witness, we
get additional "accidental" semantics. Seeing two valid cosignatures
for same tree head and same witness would mean that the tree head was
the latest seen by a witness as of time T1, but in addition, witness says
it was unchanged since time T2, with T2 < T1.

It will cause additional complexity and confusion when reasoning about
timestamps, e.g., to aggregate available witness timestamp based on
the quorum definition, as was discussed at
https://github.com/florolf/sigmon/pull/10.

## Risks

I see no significant risks; I'm not aware of anything using or
depending on duplicate cosignatures.

One possible complication is compatibility with
https://github.com/C2SP/C2SP/blob/main/tlog-proof.md and
https://github.com/C2SP/C2SP/blob/main/tlog-checkpoint.md. Ideally,
those specs could be amended to say that duplicates (which I think
would mean "same witness name and same key id") are invalid. Less
clear if it makes sense to try to propagate that all the way back to
https://github.com/C2SP/C2SP/blob/main/signed-note.md.
