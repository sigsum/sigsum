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

   Returning all cosignatures in a single API call avoids extra complexity in
   log implementations that need to obtain cosignatures of multiple versions.

2. The encoding of a cosignature is changed from its current three
   space-separated fields to four, where the first is currently always `v1`, but
   may be any string of non-space printable ASCII characters.

   `v1 dcce98012388f1b7a92973ba153b295d5f259097896871cb836066a37c9bf1e3 1679315147 1d765c6306fe124f388b0a6544c449e947b4f7db6c76fb0067be5a8f992460e4e1c286dfae825582f212d7d419a9fe89bcb19a23dc8d09d6ccd167b719e03b66`

   This avoids having to do trial verifications to recognize supported
   cosignatures, which would hide legitimate verification errors. For example, a
   log that only supports v1 and v2 couldn't distinguish a witness that supports
   v2 and v3 from one that supports v1 and v2 but is producing invalid v1
   cosignatures.

Logs and clients must ignore cosignatures the version of which they don't support.
