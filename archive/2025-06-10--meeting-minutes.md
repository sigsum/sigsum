# Sigsum weekly

- Date: 2025-06-10 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- rgdd
- filippo

## Status round

- filippo: finnished patricia trie impl, sqlite backend. But current impl is way
  slower (see links below -- basically recursively requesting proofs), think
  have to do what akd does. When you want something at a certain depth, you
  request the 256 prefixies of the label and that's it.
  - rgdd: but at least learned stuff doing this
  - if it's fast, not as crucial to persist (or persist all the time directly)
  - so being fast would be nice
  - https://github.com/FiloSottile/torchwood/tree/341dc2f0f552a29816955d4834718cd741f1ca64/mpt/mptsqlite
- filippo: chatting with tf folks about web pki things
  - protocol for tlog mirroring, essentially for witnesses that will not cosign
    until they have replicated the entire content. Push protocol, filippo agrees
    with that. Asking mirror to fetch log over http -> can run into rate
    limitting. Now instead: here's a bunch of tiles, here's a checkpoint. Please
    cosign.
  - filippo think protocol can be simplified; first send right edge of merkle
    tree. This one = needed to check incl of each tile in checkpoint. Then send
    tiles, top to bottom. Left to right. Each tile can be verified against the
    hash above it or the checkpoint. So you can verify them while they are
    streamed in.
  - interesting question with multiple answers: should these cosignatures be
    different algorithm types (argued initially), or should there be a separate
    alg type with "extra guarantees" depending on what the witness is staking?
    Append-only = provable property, true or false. Availability is squizy. More
    of a side car promise. Got me thinking - is there a good reason to have
    different alg id for signature for log and witness?
  - mirror design, would be about ensuring mirroring have happened (so if e.g.
    CA messes up = things are not lost)
  - revoke by index would work if things are lost
  - if an ecosystem thinks they need a mirroring system, then they would need to
    bootstrap that themselves. I.e., not a general thing.
  - filippo think it is a reasonable think to spec, but not to provision for
    cross ecosystem
  - we know ecosystems will want to do cosignatures with other meanings, e.g.,
    KT already want say cloudflare to have 2x cosigners. Both witness, and a "i
    checked the transition patricia trie cosigner".
  - so main question is: do we need different cosignatures or not, how to we set
    the practises to express additional properties by a cosigner.
  - filippo can think of a number of answers and don't hate any of them
    - "its a cosignature, clients know what promises a certain vkey is
      associated with"
    - "each promise has its own signature algorithm code point, but they all use
      tlog/cosignature"
    - "we domain separate preimage, so it's not cosignature/v1 anymore. It's a
      different signed statement, but they all use the same signature algorithm"
      - probably better than the previous one, because doesn't lead to
        multiplcative expansion of key types and algorithm ids. Which so far we
        haven't been good at, e.g., Ed25519 algorithm have different id than log
        signature.
    - middle grounds of these: "we define a single domain separated preimage /
      alg id". Which means this is a cosignature with a side car promise that
      you need to know about.
      - filippo: feels redundant, might as well use a cosignature at this point?
    - what alg id is for = would be good to decide before folks take it in
      different directions
    - rgdd: unique origin line (no confused witnesses) and namespace (no cross
      protocol attacks) are the main things we've been very itentional about
      before that i can recall from top of head

## Decisions

- None

## Next steps

- filippo: need to catch up with what happened last two weeks wrt. web pki
  things
  - is anything blocked on me?
  - no
- filippo: might do the more efficient patricia trie fetch
- filippo: expect to do a run on specs soonish, then also wrap up vkey, spicy
  proof, etc. But maybe not this week.

## Other

- None
