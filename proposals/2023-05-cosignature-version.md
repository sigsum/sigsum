# Versioned cosignatures

Cosignatures already include a version field in their signed data serialization.

    cosignature/v1
    time 1679315147
    sigsum.org/v1/tree/3620c0d515f87e60959d29a4682fd1f0db984704981fda39b3e9ba0a44f57e2f
    15368405
    31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=

The version defines the semantics of the witness signature.

It's desirable for it to be possible to roll out new cosignature versions
without coordination across the ecosystem. We want witnesses to be able to start
producing v2 cosignatures (in parallel with v1 cosignatures) without waiting for
logs to necessarily support them.

To enable this, we propose the following changes:

1. The encoding of a cosignature is changed from its current three
   space-separated fields to four, where the first is currently always `v1`, but
   may be any string of non-space printable ASCII characters.

   `v1 dcce98012388f1b7a92973ba153b295d5f259097896871cb836066a37c9bf1e3 1679315147 1d765c6306fe124f388b0a6544c449e947b4f7db6c76fb0067be5a8f992460e4e1c286dfae825582f212d7d419a9fe89bcb19a23dc8d09d6ccd167b719e03b66`

2. The `cosignature` key in the output of the witness `add-tree-head` API is
   changed to a repeated key.

Logs should accept multiple cosignatures from their witnesses (up to a
reasonable limit) and serve them all to clients, even if they don't (yet)
understand the cosignature version.

Clients should disregard cosignatures the version of which they don't support.
