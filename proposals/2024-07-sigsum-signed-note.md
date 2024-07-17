# Proposal: Sigsum Signed Notes

This is a proposal that defines a serialization format to use Sigsum spicy
signature in signed notes.

## Background

We need a way to create signed document, i.e. bundle signed data with a Sigsum
spicy signature in the same document. E.g. this can be useful to sign documents
that are transferred over a protocol like HTTP.

TODO: terminology: attached signature? non-detached signature?

A [signed note][note] is a simple way to do this for text data which presents a
few nice properties:
- Both the data and the list of signature are in plain text, which makes it
  easier for debugging
- It is possible to attach more than one signature, which makes it a good fit
  for threshold signature schemes but also backward compatible changes (e.g.
  changing key, policy, or even this format).

## Format

The format is based on the [signed note specification][note] where a signature
is represented as:

```
— <key name> base64(32-bit key ID || signature)
```

For Sigsum signatures, we compute the key ID as recommended in the note spec
with a signature type of 0xff followed by the ascii representation of the
string "SIGSUMv1" and the submitter's public key:

```
key ID = SHA-256(key name || 0x0A || 0xFF || 'SIGSUMv1' || submitter's public key)[:4]
```

To serialize the transparency-logged signature, we use the following
format (described using [trunnel][trunnel]) with `spicy_signature` being used
as the note signature.

```trunnel
const SHA256_LEN = 32;
const ED25519SIG_LEN = 64;

struct hash {
  u8 hash[SHA256_LEN];
}

struct signature {
  u8 signature[ED25519SIG_LEN];
}

struct cosignature {
  struct hash keyhash;
  u64 timestamp;
  struct signature signature;
}

struct tree_head {
  struct hash log;
  u64 size;
  struct hash root_hash;
  struct signature signature;
  u8 cosignatures_len;
  struct cosignature cosignatures[cosignatures_len];
}

struct inclusion_proof {
  u64 leaf_index;
  u8 path_len;
  struct hash path[path_len];
}

struct spicy_signature {
    struct signature signature;
    struct inclusion_proof inclusion_proof;
    struct tree_head tree_head;
}
```

### Example

This is an example of the format, where the signed document is just the string
`Hello, spicy!\n` (that is the string `Hello, spicy` followed by a newline):

```
Hello, spicy!

— example.com/mykey ZXhhbf1+w+jm+PstL4e54D9KdSFSAsNFJCuRS9L5IVbwqR2hEdGreBdTYnvZl6/RJQGaU0OsuUZWKBtksltQNtk5kgwAAAAAAABuIAxkluM5V+cC5mzYU0RhmSYhqh28B4qF2C2cY7LyfaJqYzbbQvVArdD6jA/zn2L+Si/EX0eqjM20jz3/iAuT+QMqCzQ3wX7f7CI4NJ0gJaRUyWfiNnXWYmpaMFq44wSs7X2mXudMN08mG2o/dkjaRWhdrB9eoAqLaMWJx9zUVPh3//U3CtlRNCTT/WZ3YiHl2YmUEA9xpkFS+k4hLLX2bPBZLStVfwm1suMj9f5WgGJLTebNy2VAxpA4W0k+iwAusHeG97cVSSVf/I7FieozlXeAaPd/sFc7KnSRHFeryJp4zn64JWDLCUEskhNxHsnHqIKfANTuqa+GlW6Pd94UOkXySAv1Up8IMndkxp+7KIPoUwakMYfzh1va6DxVHwC74xw5DDzBKde2znSbd/KEOMB7B34Clhyi9YDqelW2kxiNunYIbKQf6VBX7u327ZftzlVf8gHPPf41+C53Fu7d7xPjySmvn2cx9jpJNmhif1iBDYktxR+Kocmk3hVzzT5R5i/J5SW5j0Eu3hhf8qxav3CSCi5jpq4xyIsROLhd4yhwawAAAAAAAG5QDhUpZc1gBZvgmtLNWPI6/EoOxrjCXedHtP/gI774a0YeOznUwJOsyGa+DMoAUYamCDjFeziAJQFzM9gspIvRsmol9fUSh42SKSG8IAzeYL33rVavABhmYM6Y6OCYSuEOAhyZcmHxbm6B0T9CCQCiVCpLagScLZljJO5dgqkMozYMAAAAAGaRM14J643k3rKdho+ZU5w44TVuIGibZVetMGXM8ZSWIFHH7yGMVmuwaMb8czCjT8elba4QaKXVg6mbpKZ1vzPlVf0NcLhhoBDyUDDeb/alJn4LlR5wwEsguko85B5/unubffwAAAAAZpEzXuFf7H3harVjj+gYxd8po44Vnn1yRkYYyzH4tjf0zKjvHfqzeyr0qSr1slbDGXJy1KzN/klyOitSzG93PrZc5ww=
```

## Alternatives considered

### Splitting the spicy signature in multiple signed notes

This combines the spicy-signature format presented at Real World Crypto 2024
with a regular ed25519 signed note:

```
<payload>

— leaf-submitter-name NnugSz[...]ZekRwNtIc=

index 73894
gSKyXoYZUgZ6jduWYrkDOARinOMGJveXjgMkBTcdP1Q=
B951Da8R831S8n0eG+o0buTxRKQTYFi//1U8anccXMA
EKNzoDWG8LGC0Yp9o+sv3qllpMP9uHQ9B20KNL+Q1zs=
RoopEkOdqkYqMB4MJXrbt/hMjOxsVn0IrWjpz1ZMMes
AHCioX9nLjsrse6YhjRRmk1WUEirVOLLROOQ6vf05vk=

example.com/fancylog
109482
sFodV/vSp508n9a8QpW6PRY97tfOSW5bsc2X1/EQ108

— example.com/fancylog hI2DJw[...]1roloI
— witnessl.example mJiriklj[...]qY9v2B/5bg==
— witness2.example TnKKVIILX [...] xwYwrSjgow==
— witness3.example S4X82uH5 [...]30ECROGLFQ
```

This format makes the transparency-logging very explicit. However we loose the
main benefits of the signed notes, as it makes it more difficult to have
multiple (spicy) signatures, and from the use-case perspective it makes the
signature more noisy and increases cognitive load.


[note]: https://github.com/C2SP/C2SP/blob/main/signed-note.md
[trunnel]: https://gitlab.torproject.org/tpo/core/trunnel/-/blob/main/doc/trunnel.md
