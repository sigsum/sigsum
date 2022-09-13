# Proposal

Rename the following endpoints:

  - s/get-tree-head-to-cosign/get-untrusted-tree-head/
  - s/get-tree-head-cosigned/get-tree-head/
  - s/get-leaves/get-entries/
  - s/add-leaf/add-entry/

Rename the following ASCII keys:

  - s/start_size/start_index/
  - s/end_size/end_index/

(Reminder: specify zero-based index.)

# Motivation

Improve readability of api.md, especially for those that skim it quickly.  For
example, "untrusted-tree-head" is a very strong signal for what you don't want,
and it should be easier to relate to the term "entry" rather than a "leaf".

The renamed ASCII keys better reflect the text that describes them.
