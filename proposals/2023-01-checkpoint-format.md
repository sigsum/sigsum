A proposal to adopt a signature format that can be defined in terms of the checkpoint format to increase interoperability with the Omniwitness ecosystem and to eventually support key rotation.

## Background

The Go Checksum Database and a few other logs use [the checkpoint format](https://github.com/transparency-dev/formats/blob/main/log/README.md#checkpoint-format) for their signed tree heads. A checkpoint looks like this: one arbitrary line that specifies the log identity, log size, tree head, and zero or more arbitrary lines, followed by one or more signatures.

```
go.sum database tree
15368405
/g9am3I6YWNKaZX/jkne1fqd9zEyjss+JXyPXG0WfkY=
optional unspecified line, not actually in use
optional unspecified line, not actually in use

— sum.golang.org Az3grqJGUaSGukG9p8nI2vKgiFn7qGHxn0W+mrwyI6Gz3F0t1J3LzmWk/p96Ybf295EjwdSwlzgijq5WA9d1Ded7owM=
```

Conversely, Sigsum doesn’t currently specify a signed tree head encoding format, but conveys them as a sequence of `size`, `root_hash`, `signature`, and `cosignature` parameters, where `signature` signs `size` and `root_hash`, while `cosignature` also signs the log key hash and a timestamp.

Adopting a signing format based on the checkpoint encoding would allow Sigsum logs to be more easily cosigned by witnesses in the Omniwitness ecosystem (and vice versa), as the algorithm can be specified in terms of a [note.Signer](https://pkg.go.dev/golang.org/x/mod@v0.9.0/sumdb/note#Signer). Note that Sigsum logs don’t need to actually serialize data as checkpoints, because likewise the algorithm can be specified in terms of an encoding for the message fed into SSH signatures.

As a reminder, the signed data of OpenSSH signatures is as follows. `namespace` is defined below, `hash_algorithm` is `sha256`, and `message_hash` is the SHA-256 hash of the message defined below.

```
struct signed_data {
	u8 magic[6] = "SSHSIG";
	uint32 namespace_len;
	u8 namespace[namespace_len];
	uint32 reserved = 0;
	uint32 hash_algorithm_len;
	u8 hash_algorithm[hash_algorithm_len];
	uint32 message_hash_len;
	u8 message_hash[message_hash_len];
}
```

Moreover, the checkpoint format natively allows [key rotation](https://git.glasklar.is/sigsum/project/documentation/-/issues/26) thanks to the identity line (if changes to log identity are adopted).

## Proposal

The serialization format of the messages signed by log and witness keys, currently `signed_tree_head` and `cosigned_tree_head` respectively, is replaced by a format defined based on to the [checkpoint specification](https://github.com/transparency-dev/formats/blob/main/log/README.md#checkpoint-format) and the [signed note specification](https://pkg.go.dev/golang.org/x/mod/sumdb/note).

Signatures are produced as namespaced OpenSSH Ed25519 signatures, according to Section 2.1 of log.md, like other Sigsum tooling. Other ecosystems don’t need to depend on OpenSSH tooling and can instead reproduce the simple signed data encoding as a fixed prefix.

### Checkpoint fields

As the origin line, Sigsum logs would currently use the Base64 encoding (for consistency with the tree head line) of the log key hash. This doesn’t lead to smooth key rotation, but this proposal focuses on incrementally adopting the new encoding format without changing semantics. A following proposal may introduce the concept of log identities separate from the log key.

The log size and tree head lines would have the same semantic meaning as both in current Sigsum and in the checkpoint format, as the two ecosystems both follow RFC 6962, and are encoded according to the checkpoint specification: ASCII decimal for the log size and Base64 for the tree head.

### Log signatures

Logs sign the whole note body with OpenSSH namespace `checkpoint:v0`.

The signature output is encoded directly as the `signature` field of `get-tree-head` API requests in the Sigsum ecosystem.

To produce signed notes compatible with the Omniwitness ecosystem, these signatures are encoded according to the note specification with the Base64 encoding of the key hash as the key Name, and the first 4 bytes of the key hash as the KeyHash. This is redundant, but it encodes the current 1:1 mapping of key to log identity of Sigsum logs into the more flexible checkpoint ecosystem.

**Discussion point**: instead of reusing the key hash as the key name, should we just call it a more readable `self` and rely on the uint32 key hash to avoid accidental collisions? I can’t quite imagine how this would break but it feels uncomfortable. On the other hand, as specified checkpoints are pretty unreadable.

#### Example

A log with key hash `5+z2zyuRoW99pcVlMhSPL4npdw/U+no8o8Ekw8CHiHE=` signs a tree head with size 15368405 and hash `31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=`.

In Sigsum terms, the key is used to produce a signature over the following message (including the final newline) with namespace `checkpoint:v0`.

```
5+z2zyuRoW99pcVlMhSPL4npdw/U+no8o8Ekw8CHiHE=
15368405
31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=
```

If not using the OpenSSH signature format, the signed data can also be described as the following fixed prefix followed by the SHA-256 hash of the message above.

```
SSHSIG\x00\x00\x00\x0Dcheckpoint:v0\x00\x00\x00\x00\x00\x00\x00\x06sha256\x00\x00\x00\x20
```

The signature is then used as-is for Sigsum APIs. To produce a signed checkpoint, it’s encoded as follows.

```
5+z2zyuRoW99pcVlMhSPL4npdw/U+no8o8Ekw8CHiHE=
15368405
31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=

— 5+z2zyuRoW99pcVlMhSPL4npdw/U+no8o8Ekw8CHiHE= 5+z2z6ylAOChjVZMtCHXjq+7r8dFdMWiB6LbJXNksbGCvxcQE6ZbPcHFxFqwb7mfPflQMOjiPl2bvmXvKhQBzM4pq/I=
```

### Witness signatures

Witnesses sign with namespace `timestamped-checkpoint:v0` a message composed of one line representing the current timestamp in seconds since the UNIX epoch, encoded as an ASCII decimal with no leading zeroes, followed by the first three lines of the note body (including the final newline).

Additional lines are excluded because current witnesses are not parsing them, and can make no statements about their validity or global visibility.

The signature output is encoded directly as the third field (and the signed timestamp as the second field) of `cosignature` parameters in the Sigsum ecosystem.

To produce signed notes compatible with the Omniwitness ecosystem, these signatures are encoded as a `timestamped_signature` and then according to the signed note specification, with the witness name as the key Name, and the first 4 bytes of the witness key hash as the KeyHash.

```
struct timestamped_signature {
	u64 timestamp;
	u8 signature[64];
}
```

#### Example

A witness named `witness.example.com/w1` with key hash `jWbPP4actZDz+uVvOT7qCd2Fdb8G4qcGc9jwh0w25iA=` signs the tree head from the previous example at UNIX time 1679315147.

In Sigsum terms, the key is used to produce a signature over the following message (including the final newline) with namespace `timestamped-checkpoint:v0`.

```
1679315147
5+z2zyuRoW99pcVlMhSPL4npdw/U+no8o8Ekw8CHiHE=
15368405
31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=
```

If not using the OpenSSH signature format, the signed data can also be described as the following fixed prefix followed by the SHA-256 hash of the message above.

```
SSHSIG\x00\x00\x00\x19timestamped-checkpoint:v0\x00\x00\x00\x00\x00\x00\x00\x06sha256\x00\x00\x00\x20
```

The cosignature for Sigsum API looks like follows.

```
8d66cf3f869cb590f3fae56f393eea09dd8575bf06e2a70673d8f0874c36e620 1679315147 119307c1245a24d8880e87bd0d89ffcd772bb4f1dea25308e4e59712164207d765ac326c5f76f6a328a7d673d9aa17f99cda34c547be99b2140640487d9faa9c
```

To produce a signed checkpoint, it’s encoded as follows.

```
5+z2zyuRoW99pcVlMhSPL4npdw/U+no8o8Ekw8CHiHE=
15368405
31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=

— 5+z2zyuRoW99pcVlMhSPL4npdw/U+no8o8Ekw8CHiHE= 5+z2z6ylAOChjVZMtCHXjq+7r8dFdMWiB6LbJXNksbGCvxcQE6ZbPcHFxFqwb7mfPflQMOjiPl2bvmXvKhQBzM4pq/I=
— witness.example.com/w1 jWbPPwAAAABkGFDLEZMHwSRaJNiIDoe9DYn/zXcrtPHeolMI5OWXEhZCB9dlrDJsX3b2oyin1nPZ\nqhf5nNo0xUe+mbIUBkBIfZ+qnA==
```
