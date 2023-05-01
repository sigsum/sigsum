# Proposal

A proposal to change the signed data serialization of cosigned tree heads.

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

Witnesses sign a message composed of one line spelling `cosignature/v1`, one
line representing the current timestamp in seconds since the UNIX epoch, encoded
as an ASCII decimal with no leading zeroes and with the prefix `time `, followed
by the first three lines of the note body (including the final newline).

Semantically, a v1 co-signature is a statement that, as of the current time, the
*consistent* tree head **with the largest size** the witness has observed for
the log identified by the origin line has the specified hash. This means
witnesses are expected not to ever sign a tree head with size N+K at T and N at
T+D (with K and D ≠ 0) for the same log. Logs are identified only by their
origin line, and there can’t be two separate logs with the same origin line.
Tree heads for which consistency with the previously observed tree head(s) can’t
be verified should be logged but must not be co-signed.

Additional lines are excluded because current witnesses are not parsing them,
and can make no statements about their validity or global visibility. Note that
Sigsum logs never produce additional lines.

**Example:** a witness named witness.example.com/w1 with key hash
`jWbPP4actZDz+uVvOT7qCd2Fdb8G4qcGc9jwh0w25iA=` wants to sign a tree head at size
`15368405` with hash `31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=`; the current
UNIX time is `1679315147`.  The witness Ed25519 key is used to produce a
signature over the following message (including the final newline).

    cosignature/v1
    time 1679315147
    sigsum.org/v1/5+z2zyuRoW99pcVlMhSPL4npdw/U+no8o8Ekw8CHiHE=
    15368405
    31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=

No change in the Sigsum log API is needed; this is just a change in how the
cosigned tree head is serialized before signing.  Before, a binary encoding
was used with SSH namespaces.  Here a line-based encoding is used, with a
namespace that is instead established with the first line.
