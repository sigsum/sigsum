# Proposal

Rename the following endpoints:

  - s/get-tree-head-to-cosign/get-next-tree-head/
  - s/get-tree-head-cosigned/get-tree-head/

Rename the ASCII key:

  - s/tree_size/size/
  - s/inclusion_path/node_hash/
  - s/consistency_path/node_hash/
# Motivation

Improve readability of api.md, especially for those that skim it
quickly.

Stick to established "tree" / "leaf" terminology, to follow
conventions in documents on merkle trees and certificate transparency.

Changing to `size` is consistent with `new_size`/`old_size` in
description of consistency proof. The term "path" is somewhat
consistent with terminology in RFC 9162, but in the sigsum protocol,
each line represents the hash of a single node in the tree, not the
path as a whole.
