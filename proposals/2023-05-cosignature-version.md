# Versioned cosignatures

Cosignatures already include a version field in their signed data serialization.

    cosignature/v1
    time 1679315147
    sigsum.org/v1/tree/3620c0d515f87e60959d29a4682fd1f0db984704981fda39b3e9ba0a44f57e2f
    15368405
    31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=

The version defines the semantics of the witness signature.

It's desirable for it to be possible to roll out new cosignature versions
without coordination across the ecosystem. For example we want witnesses to be
able to start producing v2 cosignatures (in parallel with v1 cosignatures)
without waiting for all logs to support them, and we want logs to be able to
support v1 and v2 clients simultaneously.

To enable this, we propose the following changes:

1. The `cosignature` key in the output of the witness `add-tree-head` API is
   changed to a repeated key.

   Different entries can have different key hashes, to enable witness key
   rotation. Clients are expected to ignore unrecognized key hashes.

2. The encoding of a cosignature is changed from its current three
   space-separated fields to four, where the first is currently always `v1`, but
   may be any string of non-space printable ASCII characters.

   `v1 dcce98012388f1b7a92973ba153b295d5f259097896871cb836066a37c9bf1e3 1679315147 1d765c6306fe124f388b0a6544c449e947b4f7db6c76fb0067be5a8f992460e4e1c286dfae825582f212d7d419a9fe89bcb19a23dc8d09d6ccd167b719e03b66`

Logs and clients must ignore cosignatures the version of which they don't support.

## Alternatives considered

1. Returning different cosignatures from different witness API endpoints,
   instead of returning multiple cosignatures from `add-tree-head`.

   This would require witness clients (i.e. logs) that want to serve multiple
   versions of cosignatures to carefully serialize multiple `add-tree-head`
   requests, the first with size > old_size and the following with size =
   old_size. Also, if the size of the log known to the witness were to grow
   between the requests, the client would have to re-issue the previous ones.

2. Return multiple cosignatures without a version field, and expect clients to
   perform trial verifications.

   Trial verification obscures the difference between "this is not a cosignature
   I understand" and "this is an invalid cosignature" which can hide complex
   system failures because it requires silently dropping invalid cosignatures
   instead of reporting an error.

3. Tie the cosignature version to the witness key.

   Introducing a new cosignature version with the current proposal requires only
   a gradual rollout of updated software, while adding a new key requires
   reconfiguring witnesses, logs, and client policies.

4. Do nothing.

   While many parts of the Sigsum ecosystem are self-contained (that is, they
   only serve other Sigsum ecosystem components) and don't need fine-grained
   versioning, witnessing and cosignatures will be a broader ecosystem, with
   different players that might need to evolve and add capabilities on different
   timelines. The capability of supporting multiple versions/semantics smoothly
   avoids deadlocks and splits.

   For example, we might want to add support for additional structure checks by
   the witnesses, or for a new design that is however backwards compatible. That
   would require signing statements from the witness that have different
   semantics from a cosignature/v1, probably including checkpoint extension lines.
