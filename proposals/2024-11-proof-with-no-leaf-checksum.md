Proposal to drop the "short checksum" from a sigsum proof

# Background

When the sigsum proof format was designed (see
https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/909033a4d43e8f6c204ab546660d3abab8156286/doc/sigsum-proof.md
and proposal
https://git.glasklar.is/sigsum/project/documentation/-/blob/main/proposals/2022-11-specify-sigsum-proof.md,
it defined a leaf line like
```
leaf=SHORT-CHECKSUM KEYHASH SIGNATURE
```

The only purpose of the short checksum is to enable a clearer error
message if by accident a proof file is applied to the wrong data blob.

This benefit is not that great. Without the short checksum the error
message in this situation would instead be "leaf signature not valid".

The cost is not that great either, but it implies one more thing to
explain to users, and we can foresee some usecases where this field is
more questionable, for example, in the context of data formats where
the signed data and a sigsum proof are bundled in the same file.

# Proposal

## New version of the proof format

Define a sigsum proof version 2, where the only change is the format
of the leaf line, which should then be
```
leaf=KEYHASH SIGNATURE
```

## Relax requirements when processing a version 1 proof

In addition, allow an implementation to ignore the short checksum when
processing a version 1 proof.

Such an implementation would first process the version line of the
proof. If the version is 1, it reads a leaf line according to the
version 1 specification (where the short checksum is required to be 4
hex digits), but then discards the short checksum with no further
processing.

In the library package `sigsum.org/sigsum-go/pkg/proof`, the
corresponding field `ShortChecksum` in the `ShortLeaf` type should be
deleted. Maybe the type should be renamed as well.

# Other changes for a sigsum proof version=2?

Is there anything else we'd like to change when bumping proof version?
Radical changes, like moving to checkpoint representation of the tree
head, will likely not be a version 2 or 3 of the sigsum proof format,
but identified differently. And we will not make such radical changes
in the near future.

One fairly simple thing we could do to improve alignment is to replace
the `log=KEYHASH` with `log=ORIGIN`. For a sigsum v1 log, that just
adds a fix string between the equals sign and the hash, but it could
make this format work better for other logs.
