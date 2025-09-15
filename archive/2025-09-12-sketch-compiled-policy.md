# Sketch of a compiled Sigsum policy format

The aim of this format is that it should:

* Be pretty compact.
* Be easy to consume with a minimum of parsing and memory allocation.
* Be easy to apply to a Sigsum proof.
* Have a well defined bit-exact compilation from input ascii policy.

It is motivated mainly by use on small contrained devices.

For the case of the tkey, a device app may want to measure the policy,
and mix it into the key material use to construct its signing key.
Which is one reproducible compilation and a canonical representation
is valuable.

## Updated 2025-09-15

* Add prefix instructions, to not have a small limit on number of
  witnesses and groups.

* Define bytecode canonicalization to sort by size first, since that
  seems easier to implement efficiently.

## Limitations

To illustrate compactness, limit support to policies listing at most
256 logs, at most 256 witnesses, and not overly complex group and
quorum rules. Sizes and limits are very tentative, and need more
careful analysis before comitting to a format of this kind.

Format is byte oriented, so let's get down to what each byte is.

## Header

Use a four byte header

    version
    nlogs
    nwitnesses
    nquorum
    
Version is zero. `nlogs` and `nwitnesses` are maybe self explanatory;
the number of listed logs and witnesses, respectively. `nquorum` is
the size of the quorum byte code program, described below.

## Logs and witnesses

After the header comes all the log public keys, 32 * `nlogs` bytes.
These must be ordered lexicographically by log key *hash*. That ensures a
deterministic order, and enables binary search when the policy is
applied.

After the log key comes the witness keys, 32 * `nwitnesses` bytes.
These must also be ordered lexicographically by witness key *hash*.

## Quorum byte code

Finally, we have `nqorum` bytes that are interpreted as instructions
for a simple stack machine. When the machine runs, it has available as
input the set of witnesses for which a valid cosignature is seen. This
set could, e.g., be represented as a 64-bit word where bit `i` is set
if we have seen a valid cosignature from the witness who's key is number
`i` in the list.

There are three opcodes (two of which have an encoded immediate
argument). Opcodes are executed in sequence; there are no jump
instructions. The stack entries are unsigned bytes. When the machine
starts, stack is empty. If stack underflows during execution, or if
there isn't exactly one element on the top of stack when the progra
terminates, the program, and hence the policy, is invalid (and these
conditions are data independent). The opcodes are `X?`, `>=K` and
`ADD`. The immediate values `X` and `K` are 6 bits each. Semantics and
encoding as follows:

 * `X?`: Push 1 if we have a valid cosignature from witness `X`,
   otherwise push 0. Could be by extracting bit `X` of the input and
   push that. Encoding: `0x01xxxxxx`.
 * `ADD`: Pop two values, push their sum. On overflow, program is
   terminated and the policy is invalid. Encoding: `0b00000001`
 * `>=K`: Pop one value. Push 1 if that value is >= `K`, otherwise
   push 0. Encoding: `0b10kkkkkk`.

To allow larger immediates, also define a prefix instruction
`0b11pppppp`, with additinional high bits of an immediate value. E.g.,
`X?` with `X = 43981 = 0b1010 101111 001101` would be represented as
the three bytes `0b11001010 0b11101111 0b01001101`, and similarly for
`>=K` with large `K`. Unnecessary leading zeros are not allowed, i.e.,
a prefix sequence must not start with `0b11000000`.

A constrained implementation that supports at most 64 witnesses and
groups need not support the prefix instruction.

In a valid program, the last instruction must not be `ADD`. I think it
should be possible to check all program validity conditions without
feeding the machine any actual input, since it has such low
computational power, but that needs further analysis. It is less clear
how easy it is to check that a program is generated exactly
according to the algorithm described further down.

## Evaluation of the policy

The inputs to policy evaluation is a log keyhash and a cosigned tree
head (in this context, most likely represented in compact binary form,
not using the ascii formats of Sigsum and checkpoints). The steps
unrelated to the tree head (co)signatures, such as verifying the
Sigsum leaf signature and the inclusion proof, are out of scope for
these notes.

To verify a proof against the policy, the steps are:

0. Compute an array of key hashes for the logs and witnesses. If they
   are not lexicographically ordered, the policy is invalid. One could
   potentially truncate the computed key hashes to save storage space.

1. Look up the log key by the supplied key hash, fail if not found.
   Verify the log's signature.

2. Initialize the 64-bit witness word to all zeros. For each
   cosignature, look up the key hash. If it is found and the
   cosignature is valid, set corresponding bit in the witness word.

3. Run the quorum byte code. When done, there should be exactly one
   byte on the stack, and quorum is satisfied if that byte equals 1.

## Compiling the quorum

We assume that parsing of the input (ascii) policy file has produced a
properly sorted list of witnesses and a tree of witnesses and groups.
We compile this recursively top-down, starting with the witness or
group identified by the quorum line.

* To compile a witness, find the witness' index, `X` and emit an `X?`
  instruction.

* A group with a single member must have threshold = 1, and is
  trivial. It is compiled by compiling its only member.

* To compile a group with more than one member, first recursively
  compile each of the `n` members. Then sort the resulting byte code
  fragments, first by increasing size, and then lexicographically for
  fragments of the same size. Output the first fragment, then output
  remaining fragments, each followed by an `ADD` instruction. Finally,
  emit a `>=K` instruction, with `K` being the group's threshold.

If resulting byte code is larger than the maximum size of 255, policy
was too complex (unclear how likely this is to happen, and if it makes
sense to increase the maximum size).

## Alternative approach, based on suggestion by florolf

One could instead represent the quorum computation as a sequence of
bit masks. First, one would need to sort the groups topologically
(respecting dependency order, quorum being last), applying some
canonicalization rule to get a well-defined order.

Use a bitvector as state, where first `nwitnesses` bits correspond to
the listed witnesses, and are assigned according to seen cosignatures
before quorum evaluation starts. Allocate further bits, one per group,
in order.

We can then represent the quorum computation by deriving a pair
`(member_mask, k)` per group, and process them in order. The bits in
`member_mask` represents the group's members. For each group, do a
logical and between current state and the `member_mask`. Count the
number of set bits (taking advantage of the pop count instruction, if
available), compare to `k`, and use the result to assign the next bit in
the state vector. After processing the last group, which is the
quorum, policy is satisfied if the quorum bit is set.
