Proposal to change convention for get-leaves arguments to half-open
convention, i.e., `get-leaves/start_index/end_index` asks for the
range of leaves with indices `start_index <= i < end_index`

# Motivation

1. This is how many programming languages (including python and go)
   define ranges, and for good reason. See
   https://www.cs.utexas.edu/users/EWD/ewd08xx/EWD831.PDF for a
   detailed argument.
   
2. For consistency with get-consistency-proof: If you then use the
   same start and end parameters for get-leaves and for
   get-consistency proof, you should get precisely the leaves that are
   present in the new tree but not in the old.

# Corner case at the maximum size and index.

Numbers in the ascii encoding are limited to the range `0 <= i <
2^63`, so the maximum tree size is `2^63 - 1`, and hence maximum leaf
index is `2^63 - 2`. The old conventions makes it possible to ask for
a leaf with index `2^63 - 1` (which can't exist), new convention
removes this possibility.
