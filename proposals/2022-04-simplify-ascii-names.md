# Proposal

Update the following names in Sigsum's ASCII parsing:

  1. s/preimage/message/
  2. s/verification_key/public_key/
  3. s/Error/error/

# Motivation

In the same order as above:

  1. Preimage is a mathematical term.  When we talk about our design, we use the
     term "message" and say that it is usually H(data).  The original reason to
     call it preimage was that a Sigsum log computes H(H(data)), making the
     message that is sent on the wire a "preimage" for the log's hash operation.
     This terminology is not helpful.  Let's just call this "message" on the
     wire.  A log uses it to compute checksum<--H(message).  Checksum is logged.
  2. Verification key is also a mathematical term.  When we talk about our
     design, we use the term "public key" because it is more easily relatable.
  3. No other key has any capital letters.
