# Proposal: cosign the whole checkpoint

Currently, a cosignature is defined as the

> signature from the witness key of a message composed of one line spelling
> `cosignature/v1`, one line representing the current timestamp in seconds since
> the UNIX epoch encoded as an ASCII decimal with no leading zeroes and prefixed
> with the string `time` and a space (0x20), followed by the first three lines
> of the tree head encoded as a checkpoint (including the final newline)

This proposal would change that to

> signature from the witness key of a message composed of one line spelling
> `cosignature/v1`, one line representing the current timestamp in seconds since
> the UNIX epoch encoded as an ASCII decimal with no leading zeroes and prefixed
> with the string `time` and a space (0x20), followed by the whole checkpoint
> (including the final newline)

The semantics of a cosignature/v1 will not change, so this is exclusively an
encoding change. The advantage of not signing the extension lines (those after
the third line) is that it makes explicit in the cryptography layer that the
witness makes no statement on them, but that semantic can also be simply
documented.

The Omniwitness project expressed a preference for signing the whole checkpoint,
to record the whole artifact that the witness observed, and not to leave
unsigned text in the body.

Their implementation will include the following comment

    // While the witness signs all lines of the note, it's important to
    // understand that the witness is asserting observation of correct
    // append-only operation of the log based on the first three lines;
    // no semantic statement is made about any extra "extension" lines.

so again there is no semantic change.

Alignment is desirable to avoid interoperability issues.

Note that Sigsum logs and clients forbid the use of extension lines, so this
proposal only impacts how Sigsum witnesses sign the checkpoints of some
non-Sigsum logs.
