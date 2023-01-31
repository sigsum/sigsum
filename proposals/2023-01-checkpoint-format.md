A proposal to adopt the checkpoint format to integrate with the Omniwitness ecosystem and to eventually support key rotation.

## Background

The Go Checksum Database, rekor, and a few other logs adopted [the checkpoint format](https://github.com/transparency-dev/formats/blob/main/log/README.md#checkpoint-format) for their signed tree heads. A checkpoint looks like this: one arbitrary line that specifies the log identity, the log size, and the tree head, followed by one or more signatures.

```
go.sum database tree
15368405
/g9am3I6YWNKaZX/jkne1fqd9zEyjss+JXyPXG0WfkY=

— sum.golang.org Az3grqJGUaSGukG9p8nI2vKgiFn7qGHxn0W+mrwyI6Gz3F0t1J3LzmWk/p96Ybf295EjwdSwlzgijq5WA9d1Ded7owM=
```

Conversely, Sigsum doesn’t currently specify a signed tree head encoding format, but conveys them as a sequence of `size`, `root_hash`, `signature`, and `cosignature` parameters, where `signature` signs `size` and `root_hash`, while `cosignature` also signs the log key hash and a timestamp.

Adopting the checkpoint format would allow Sigsum logs to be cosigned by witnesses in the Omniwitness ecosystem, with only minor changes necessary to support the respective signature schemes and HTTP APIs.

Moreover, the checkpoint format natively allows [key rotation](https://git.glasklar.is/sigsum/project/documentation/-/issues/26) if changes to log identity are adopted.

## Proposal

### Checkpoints

Logs would produce tree heads according to the [checkpoint format specification](https://github.com/transparency-dev/formats/blob/main/log/README.md#checkpoint-format) and the [signed note specification](https://pkg.go.dev/golang.org/x/mod/sumdb/note).

As the origin line, Sigsum logs would currently use the Base64 encoding (for consistency with the tree head line) of the log key hash. This doesn’t lead to smooth key rotation, but this proposal focuses on incrementally adopting the new encoding format without changing semantics. A following proposal may introduce the concept of log identities separate from the log key.

The log size and tree head lines would have the same meaning as both in current Sigsum and in the checkpoint format, as the two ecosystems both follow RFC 6962.

We define two new signature formats that are compatible with the current OpenSSH Ed25519 signatures produced by Sigsum tooling, according to Section 2.1 of log.md. Other ecosystems don’t need to depend on OpenSSH tooling and can instead reproduce their simple message encoding.

Logs sign the note body with namespace `checkpoint:v0`.

Witnesses sign with namespace `timestamped-checkpoint:v0` a message composed of one line representing the current timestamp in seconds since the UNIX epoch, encoded as an ASCII decimal with no leading zeroes, followed by the note body.

```
1675170805
go.sum database tree
15368405
/g9am3I6YWNKaZX/jkne1fqd9zEyjss+JXyPXG0WfkY=
```

Witness signatures are encoded as a `timestamped_signature` before being concatenated with the key hash and encoded as Base64 according to the note specification.

```
struct timestamped_signature {
	u64 timestamp;
	u8 signature[64];
}
```

The key name, key hash, and public key encoding are TBD, but will probably allocate a key type according to the note format for interoperability.

**Discussion point:** should we use a plain, non-OpenSSH signature format for OpenSSH, so that all witnesses can be more easily made to converge on a format? That would require taking care to ensure domain separation.

### APIs

The log’s `get-tree-head` endpoint is modified to return a single parameter, `checkpoint`, which is the hex encoding of a checkpoint, including signatures and co-signatures.

The witness’s `add-tree-head` endpoint is modified to accept three parameters:  `checkpoint`, as above, `old_size`, and `consistency_path`, as currently defined. On success, it returns one or more `cosignature` parameters which are the lines to add to the checkpoint. The full checkpoint is not echoed to prevent witnesses from potentially mangling the body.

```
cosignature=— witness.example.com Az3grqJGUaSGukG9p8nI2vKgiFn7qGHxn0W+mrwyI6Gz3F0t1J3LzmWk/p96Ybf295EjwdSwlzgijq5WA9d1Ded7owM=
cosignature=— witness.example.com Az3grt9nc1/mvF9CNywDDfNWY0kvIADFt5mrtpifPYPAsA71DQOLD6DQmal1lVnxBLoVl0t0Ria4H9dxX8CFeNsBtg8=
```

**Discussion point:** should these lines be hex-encoded?