# Proposal

A proposal to change the serialization of cosigned tree heads.

## Background

https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/30
outlines ideas on how to transition from Sigsum's current (co)signed tree head
formats to something that is semantically and cryptographically compatible with
other transparency logs like Go's checksum database which uses checkpoints.

We have [already decided][] to change the serialization of signed tree heads.
The next steps are to consider if further changes are needed to the
serialization of cosigned tree heads and/or the witness.md API.

This proposal only concerns the serialization of cosigned tree heads.

[already decided]: https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2023-03-28--meeting-minutes.md#decisions

## Description

Witnesses sign a message composed of one line spelling `cosignature v1`, one
line representing the current timestamp in seconds since the UNIX epoch, encoded
as an ASCII decimal with no leading zeroes, followed by the first three lines of
the note body (including the final newline).

Additional lines are excluded because current witnesses are not parsing them,
and can make no statements about their validity or global visibility.

**Example:** a witness named witness.example.com/w1 with key hash
`jWbPP4actZDz+uVvOT7qCd2Fdb8G4qcGc9jwh0w25iA=` wants to sign a tree head at size
`15368405` with hash `31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=`; the current
UNIX time is `1679315147`.  The witness Ed25519 key is used to produce a
signature over the following message (including the final newline).

    cosignature v1
    1679315147
    sigsum.org/v1/5+z2zyuRoW99pcVlMhSPL4npdw/U+no8o8Ekw8CHiHE=
    15368405
    31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=

No change in the Sigsum log API is needed; this is just a change in how the
cosigned tree head is serialized before signing.  Before a binary-encoding
was used with SSH namespace.  Here a line-based encoding is used, with a
namespace that is instead established with the "cosignature v1" line.

## Discussion

## Does the line-based format help wrt. compatibility? How?

Raised by nisse.

## Should all lines be cosigned, even if a witness doesn't understand them?

"They had a good argument for signing the whole note, including extension lines,
which I had not considered: if you set a policy of n-of-m where n > m/2, you get
basically consensus on the extension lines. Witnesses refuse to sign a tree head
that's smaller than the last they saw, so you can't get a majority of signatures
on two different tree heads for the same size. That feels worth signing the
whole note, even if still with the semantic of "at this signature version, we
are making no statement about the extension lines"

Raised by Trillian folks when filippo had a chat with them.
