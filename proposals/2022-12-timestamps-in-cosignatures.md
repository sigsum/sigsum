Proposal to move timestamps from tree heads to co-signatures.

## Background

In the Sigsum design, tree heads include timestamps for two purposes: as a way to provide a trusted time range in which a leaf was added (timestamping), and as a way to show monitors that the progress of the tree is not being hidden from them (freshness).

This requires witnesses to refuse signing tree heads that are “too old”. How old is “too old” is problematic to determine, since different ecosystems will have different tightness requirements for both timestamping and freshness. It also presents operational complexity, because a log that fails to get a tree head signed for “too long” (for example because the witness temporarily went offline) will have to discard the tree head and produce a new one instead of continuing to retry.

## Timestamps as part of the signature

This proposal makes the timestamp a part of the witness co-signature instead of part of the tree head. This moves the decision of what is “too old” to the relying parties, which can be tailored to the ecosystem, and resolves the issue with stale tree heads.

A witness co-signature will consist of a timestamp at which the signature was produced, and a signature over both the tree head and the timestamp.

This also has the advantage of making it easier to switch to the “signed note” tree head format used by the Go Checksum Database and other deployments if desired in the future. The witnesses can produce both timestamped and non-timestamped signatures if necessary for backwards compatibility.

## signed_tree_head and cosigned_tree_head

After this change, logs and witnesses sign different messages.

A `signed_tree_head` is signed by the log, and it only includes size and Merkle root.

```
struct signed_tree_head {
	u64 size;
	u8 root_hash[32];
}
```

A `cosigned_tree_head` is signed by the witness, including the log key hash (to [bind
the co-signature to the log](https://git.sigsum.org/sigsum/tree/archive/2021-08-10-witnessing-broader-discuss#n95))
and the timestamp of the signature.

```
struct cosigned_tree_head {
	u64 tree_size;
	u8 root_hash[32];
	u8 key_hash[32];
	u64 timestamp;
}
```

## Co-signature format

An ASCII timestamp field is added to the co-signature, between the witness key hash and
the signature.