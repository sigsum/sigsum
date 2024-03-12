# Sigsum Witness Protocol

**Status:** In development protocol moving towards consensus. Checkpoint
submission is likely stable. Monitor access may change.

## 1 — Overview

Logs produce self-contained proofs that can be verified offline by clients. To
do this they need to obtain and include in the proof cosignatures on the tree
head produced by a quorum of witnesses trusted by the client. When producing a
new tree head, the log reaches out to witnesses to request cosignatures over
it, providing a consistency proof. Witnesses verify that the tree head is
consistent with the previous state of the tree, and return a timestamped
signature.

A witness is an entity exposing an HTTP service identified by a name and a
public key. Each witness is configured with a list of supported tree public
keys. For each tree, the witness keeps only track of the latest tree head it
observed and verified, and the timestamp of its latest cosignature.

Clients are not expected to communicate directly with the witnesses, logs and
(sometimes) monitors are, but there is no authentication beyond the validation
of the signature on the tree head.

Witnesses need to be operated by trusted, reliable entities with minimal churn.
Log deployments pick a witness trust policy that gets deployed into clients and
might be difficult or impossible to change. Developing a healthy ecosystem of
witnesses might be the biggest hurdle to widespread tlog success. It’s
impractical to build a separate witness ecosystem for each application, so it’s
important that witnesses be public, interoperable, and scalable. As for
quantity, there should be more than a few, but once reached a critical mass each
additional witness has sharply diminishing marginal value. Additional log
deployments, on the other hand, don’t have diminishing returns and are a
desirable goal. Because of this, witnesses are designed to scale well with a
large number of rarely active logs, and to support diverse log designs,
including low-latency and "serverless" logs.

## 2 — Primitives

Witnesses deal in [checkpoints][checkpoint], accepting checkpoints signed by the
log, and returning cosignatures as additional special note signature lines.

Per the [signed note format][note], a note signature line is

    — <name> base64(32-bit key hash || signature)

where the name is arbitrary, and the key hash and signature are specified by the
signing algorithm.

A v1 witness cosignature is a note signature added to a log-issued checkpoint by
a witness to attest that the log respected its append-only requirements.

Semantically, a v1 cosignature is a statement that, as of the given time, the
*consistent* tree head *with the largest size* the witness has observed for the
log identified by that key has the specified hash.

The signature is performed over a message composed of newline-terminated lines:

 1. one line with the fixed string "cosignature/v1", to provide domain
    separation
 2. one line with the fixed string `time`, a single space (`0x20`), and a
    timestamp representing the number of seconds since the UNIX epoch (January
    1, 1970 00:00 UTC) as an ASCII decimal with no leading zeroes
 3. the checkpoint body as signed by the log, including any extension lines

Note that even though they are part of the signed message, a v1 cosignature has
no meaning in relation to the extension lines. In particular, clients shouldn't
expect extension lines to be discoverable, or for a concensus between witnesses
to exist on the extension lines for a given tree size.

Example serialization:

    cosignature/v1
    time 1679315147
    example.com/a-fancy-log
    15368405
    31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=

To cosign a tree head, a witness signs this serialization directly using Ed25519
according to [RFC 8032][]. It then encodes the 72-byte note format signature as
the concatenation of the timestamp as an 8-byte big-endian uint64 and the
64-byte Ed25519 signature.

To produce a note signature line, the resulting signature is encoded along with
the witness name and key ID according to the note spec.

The key ID is defined as the first four bytes (interpreted in big-endian order)
of the SHA-256 hash of the following sequence: the key name, a newline, the
signature type identifier byte `0x04`, and the 32-byte RFC 8032 encoding of the
public key.

[checkpoint]: https://github.com/C2SP/C2SP/blob/filippo/tlogs/checkpoint.md
[note]: https://github.com/C2SP/C2SP/blob/filippo/tlogs/note.md
[RFC 8032]: https://www.rfc-editor.org/rfc/rfc8032.html

## 3 — Public endpoints

This section specifies the public HTTP(S) endpoints exposed by a witness.

Witnesses might choose to implement request rate-limits per source IPv4 or IPv6
prefix. Implementing rate-limits based on log key hashes is discouraged as the
resources required to properly attribute a request to a log (checking the
signature, and whether the tree head is novel) are equivalent to those required
to service it. Witnesses may choose to exempt or partition successful
`add-checkpoint` requests from the rate-limit, to avoid affecting high frequency
logs.

Witnesses should support keep-alive HTTP connections to reduce latency and load
due to connection establishment.

If exposing the machine holding the witness key material to the Internet is
undesirable, operators may choose to operate a "bastion" host that is exposed to
the Internet, and proxies the requests to a reverse connection established from
the actual witness to the bastion.

### 3.1 — add-checkpoint

Provides a new signed tree head for the witness to cosign, along with a
consistency proof from the latest tree head known to the witness.

```
POST <witness URL>/add-checkpoint
```

The input is a sequence of newline-terminated lines:

- one line starting with the string `old` followed by a space and the size of
  the previous tree head the consistency proof is built from, encoded as an
  ASCII decimal number
- zero or more hashes representing the consistency proof, base64-encoded one per
  line, in RFC 6962 order
- one empty line
- a checkpoint, which includes the log's origin, the tree size, the root hash,
  and the log signature

    old 15368377
    PlRNCrwHpqhGrupue0L7gxbjbMiKA9temvuZZDDpkaw=
    jrJZDmY8Y7SyJE0MWLpLozkIVMSMZcD5kvuKxPC3swk=
    5+pKlUdi2LeF/BcMHBn+Ku6yhPGNCswZZD1X/6QgPd8=
    /6WVhPs2CwSsb5rYBH5cjHV/wSmA79abXAwhXw3Kj/0=

    sigsum.org/v1/a275973457e5a8292cc00174c848a94f8f95ad0be41b5c1d96811d212ef880cd
    15368405
    31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=

    — sigsum.org/v1/a275973457e5a8292cc00174c848a94f8f95ad0be41b5c1d96811d212ef880cd 5+z2z6ylAOChjVZMtCHXjq+7r8dFdMWiB6LbJXNksbGCvxcQE6ZbPcHFxFqwb7mfPflQMOjiPl2bvmXvKhQBzM4pq/I=

The list of hashes is empty (that is, the empty line comes immediately after the
`old` line) if and only if the `old` size is `0` or if it matches the size in
the checkpoint.

HTTP error codes on failure:
- 400 Bad request if the `old` size is higher than checkpoint size.
- 409 Conflict if the `old` size does not match the latest tree head known by the
  witness. (See below for the response body.)
- 403 Forbidden if the checkpoint signature doesn't verify against the public
  key(s) known for the log's origin.
- 404 Not Found if the log's origin is not known.
- 422 Unprocessable entity if the hash list does not prove consistency from the
  old tree head known to the witness to the new one.

On a 409 Conflict failure, the response body will contain the tree size known to
the witness in decimal, followed by a newline. The response will have a
`Content-Type` of `text/x.tlog.size`. The client can use this to send a new
`add-checkpoint` request with the correct `old` size. If a client doesn't have
(or doesn't keep) information on the size known by the witness, it can initially
submit the checkpoint with an `old` size of `0`, which requires no consistency
proof and will cause a 409 response with the known size.

On success, the response body is a sequence of one or more cosignature lines
from the witness key(s) on the checkpoint, each starting with the `—` character
and ending with a newline.

To parse the response, the client may concatenate it to the checkpoint, and use
a note verification function with the witness keys it expects. If that call
succeeds, it can move the valid signatures to its own view of the checkpoint.

The witness must persist the new tree head before returning the cosignature.
Note that checking the `old` size against the previous tree head and persisting
the new tree head must be performed atomically: otherwise the following race can
occur.

1. Request A with size N is checked for consistency.
2. Request B with size N+K is checked for consistency.
3. The stored size is updated to N+K for request B.
4. A cosignature for N+K is returned to request B.
5. The stored size is updated to N for request A, **rolling back K leaves**.
6. A cosignature for N is returned to request A.

If the log is known, and the signature is valid, the witness should log
the request even if the consistency proof doesn't verify (but must not cosign
it) as it might suggest log misbehavior.

Note that the client can't request an `old` size lower than the latest known to
the log. This means witnesses are expected not to ever sign a tree head with
size N+K at T and N at T+D (with K and D > 0) for the same log.

A log with strict latency goals may choose to issue `add-checkpoint` requests to
all witnesses in parallel, and to start serving the cosigned tree head once a
threshold of cosignatures are obtained, without waiting for the slowest
witnesses.

### 3.2 — Roster

Returns the list of the latest tree head witnessed for each known log.

Note that this endpoint may be served from a different base URL than the
`add-checkpoint` endpoint, to reflect the fact that this endpoint serves a
different set of clients with potentially different rate limits, and to
facilitate delegating it to a static hosting service.

```
GET <roster URL>
```

The response is a [note][] signed by the witness key(s). The note body is a
sequence of newline-terminated lines:

- one line with the fixed string `roster/v1`, for domain separation
- one line starting with the string `time` followed by a space and the time at
  which this roster was generated in seconds since the UNIX epoch, encoded as an
  ASCII decimal number
- for each known log that submitted at least one checkpoint (in an unspecified
  order) the first three lines of the latest witnessed checkpoint

    roster/v1
    time 1679315147
    sigsum.org/v1/a275973457e5a8292cc00174c848a94f8f95ad0be41b5c1d96811d212ef880cd
    15368405
    31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=
    example.com/footree
    8923847
    9gPZU/wiV/idmMaBmkF8s+S6mNWW7zyBAT0Rordygf4=
    sigsum.org/v1/6a04bb2889667e322c5818fc10c57ab7e8095527b505095dbbdec478066df4a2
    99274999
    jIKavLHDS5/ygY56ZVObZYPz5CS+ejR0fl6VacWMvmw=

    — witness.example.com/w1 jWbPPwAAAABkGFDLEZMHwSRaJNiIDoe9DYn/zXcrtPHeolMI5OWXEhZCB9dlrDJsX3b2oyin1nPZ\nqhf5nNo0xUe+mbIUBkBIfZ+qnA==

Witnesses must commit to the period at which they update the roster, and make
sure that any caching system won't interfere with the roster URL response
visibly updating at least every period.

This endpoint is provided for the benefit of monitors. By obtaining a recent
roster from a quorum of witnesses and comparing the tree head in the roster with
that in the most recent checkpoint, a monitor can ensure the "freshness" of the
tree head it is inspecting, as well as ensure it was not partitioned on a split
view. Otherwise, a log could hide entries from a monitor by pretending it has
stopped issuing tree heads, or by showing different views to different subsets
of witnesses. TODO(filippo): elaborate on when, how, and why monitors need to
use rosters to defend against split view attacks.
