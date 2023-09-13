# Three witness APIs

Unlike the log.md specification, which is free to target the closed Sigsum
ecosystem, the witness ecosystem will involve multiple players and the API
design might need to take this into account. In particular, the current API only
supports witnessing Sigsum logs, which is short of the interoperability goal of
the witness ecosystem.

(Specifically, the witness.md doesn't support arbitrary origin lines, and
extension lines in the checkpoint.)

This proposal presents three potential APIs for witness.md v1. They all expose
the same functionality: submitting a tree head for witnessing, getting the
current size of a log, and retrieving a signed roster.

(Note that the roster is being expanded to include both log size and tree head,
which is necessary for anti-split view for reasons beyond the scope of this
proposal. That change will be necessary regardless and will be documented elsewhere.)

These are not full fledged specifications, but just API overviews to help pick
an option.

## 1. log.md style API

This is the closest to the current API, adapted to support arbitrary
checkpoints and origin lines.

```
POST <witness URL>/add-tree-head

> origin=<hex encoded origin line>
> size=<ASCII-encoded decimal number>
> root_hash=<Merkle tree root hash, hex-encoded>
> signature=<log signature, hex-encoded>
> extra=<extension lines, concatenated then hex-encoded, can be empty>
> old_size=<ASCII-encoded decimal size>
> node_hash=<repeated key, hex encoded consistency proof>

< cosignature=<repeated key, v1 cosignature>
```

The extension lines are concatenated before encoding because only one key can
be repeated in this encoding.

```
GET <witness URL>/get-tree-size/<hex-encoded origin line>

< size=<ASCII-encoded decimal size>
```

The response must be non-cacheable.

```
GET <roster URL>

< <hex-encoded origin line>=<ASCII-encoded decimal size> <hex-encoded tree head hash>
< <hex-encoded origin line>=<ASCII-encoded decimal size> <hex-encoded tree head hash>
< <hex-encoded origin line>=<ASCII-encoded decimal size> <hex-encoded tree head hash>
< <hex-encoded origin line>=<ASCII-encoded decimal size> <hex-encoded tree head hash>
< key_hash=<witness key hash>
< timestamp=<ASCII-encoded decimal timestamp>
< signature=<witness signature over all the above with prefix, see witness.md>
```

The advantage of this API is that it resembles closely log.md. The disadvantage
is that it will be harder to get the whole ecosystem to adopt it, as it makes
encoding choices that are uncommon, even if simple, and mixes checkpoint
encoding and log.md encoding somewhat.

It also requires non-Sigsum clients to do a non-trivial change in cosignature
encoding to convert it to a note signature.

If the rest of the ecosystem doesn't adopt this API, and Sigsum logs wish to use
non-Sigsum witnesses (and vice versa), they will have to implement the
(non-)Sigsum API anyway, and implement the opposite conversion.

## 2. Checkpoint style API

This API is instead based on the checkpoint format,
and on github.com/transparency-dev/witness/api.

The names of the endpoints are picked to match the current witness.md, because
the transparency-dev/witness API has log IDs in the URL, which is a concept we'd
like to avoid and replace with origin lines.

```
POST <witness URL>/add-tree-head

> old 15368377
> PlRNCrwHpqhGrupue0L7gxbjbMiKA9temvuZZDDpkaw=
> jrJZDmY8Y7SyJE0MWLpLozkIVMSMZcD5kvuKxPC3swk=
> 5+pKlUdi2LeF/BcMHBn+Ku6yhPGNCswZZD1X/6QgPd8=
> /6WVhPs2CwSsb5rYBH5cjHV/wSmA79abXAwhXw3Kj/0=
>
> sigsum.org/v1/a275973457e5a8292cc00174c848a94f8f95ad0be41b5c1d96811d212ef880cd
> 15368405
> 31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=
>
> — sigsum.org/v1/a275973457e5a8292cc00174c848a94f8f95ad0be41b5c1d96811d212ef880cd 5+z2z6ylAOChjVZMtCHXjq+7r8dFdMWiB6LbJXNksbGCvxcQE6ZbPcHFxFqwb7mfPflQMOjiPl2bvmXvKhQBzM4pq/I=

< sigsum.org/v1/a275973457e5a8292cc00174c848a94f8f95ad0be41b5c1d96811d212ef880cd
< 15368405
< 31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=
<
< — sigsum.org/v1/a275973457e5a8292cc00174c848a94f8f95ad0be41b5c1d96811d212ef880cd 5+z2z6ylAOChjVZMtCHXjq+7r8dFdMWiB6LbJXNksbGCvxcQE6ZbPcHFxFqwb7mfPflQMOjiPl2bvmXvKhQBzM4pq/I=
< — witness.example.com/w1 jWbPPwAAAABkGFDLEZMHwSRaJNiIDoe9DYn/zXcrtPHeolMI5OWXEhZCB9dlrDJsX3b2oyin1nPZ\nqhf5nNo0xUe+mbIUBkBIfZ+qnA==
```

The input is formatted in line with how checkpoints are encoded, with the
old size on its own prefixed line, followed by the consistency proof,
one hash per line.

This format is similar to the Go Checksum Database lookup API output, e.g.
https://sum.golang.org/lookup/filippo.io/age@v1.0.0

To parse the output, the client uses note.Open with the witness keys it
expects, and if that call succeeds, moves the valid signatures to its
own view of the checkpoint, or extracts the signatures for the Sigsum format.

```
POST <witness URL>/get-tree-size

> sigsum.org/v1/tree/3620c0d515f87e60959d29a4682fd1f0db984704981fda39b3e9ba0a44f57e2f

< 15368405
```

This is a POST so that the origin line can be passed in the body, and also
so that the HTTP semantics are naturally non-cacheable.

```
GET <roster URL>

< roster/v1
< time 1679315147
< sigsum.org/v1/a275973457e5a8292cc00174c848a94f8f95ad0be41b5c1d96811d212ef880cd
< 15368405
< 31JQUq8EyQx5lpqtKRqryJzA+77WD2xmTyuB4uIlXeE=
< example.com/footree
< 8923847
< 9gPZU/wiV/idmMaBmkF8s+S6mNWW7zyBAT0Rordygf4=
< sigsum.org/v1/6a04bb2889667e322c5818fc10c57ab7e8095527b505095dbbdec478066df4a2
< 99274999
< jIKavLHDS5/ygY56ZVObZYPz5CS+ejR0fl6VacWMvmw=
<
< — witness.example.com/w1 jWbPPwAAAABkGFDLEZMHwSRaJNiIDoe9DYn/zXcrtPHeolMI5OWXEhZCB9dlrDJsX3b2oyin1nPZ\nqhf5nNo0xUe+mbIUBkBIfZ+qnA==
```

An advantage of this API is that the roster encoding is much more natural,
simply using a signed note with a header and a sequence of checkpoints. Also,
we don't introduce the concept of a hex-encoded origin line or checkpoint
anywhere, nor we introduce any checkpoint-unlike encoding.

## 3. Porque no los dos

Another option is to expose two add-tree-head endpoints, switched on path or
Content-Type, accepting one the current witness.md format, and one the
checkpoint-style API.

It allows our witnesses to serve Sigsum and Omniwitness clients easily, but if
a Sigsum client wishes to get cosignatures from a Omniwitness witness, it will
still need to implement two client-side APIs.
