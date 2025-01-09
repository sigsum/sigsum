# More notes on shared configuration

By rgdd, much less perfect than I'd hoped. But better to commit and push!

## Dear witness, I'm a log and would like to collect cosignatures from you

The log operator then provides the witness operator with this information:

    RATE VKEY [ORIGIN]

`RATE` is how often the log wants to be able to ask for witness cosignatures.
E.g., "1/s", "10/s", "4/d", "16/m", "68/y".  Or whatever is a good "/" syntax.
Easily selected for high-frequency logs, and low-frequency logs should specify
the rate they need to feel sufficiently safe in case they need to do bursts.

(The other option would be to also have a `BURST` toggle, but I think it amounts
to basically the same thing: a very infrequent `RATE` and then a sufficiently
large `BURST`, i.e., that would then be mostly the same as just `BURST`/unit.)

`VKEY` is the log's (Ed25519) key in note-verifier format.  Used for
add-checkpoint requests.

`ORIGIN` is an optional origin-line, only needed if the origin is different than
the vkey name.

### Discussion

What would one do as a witness operator if the above request comes from a random
stranger on the internet?  Assumption is you want to help witness others' logs.

  1. **Do I have the information needed to configure the log?**

     Yes, `VKEY` (and possibly `ORIGIN`) is sufficient.

  2. **Do I have capacity to witness this log?**

     This can be assessed from `RATE`, assuming the operator knows how much load
     it can handle.

     If abuse is detected (e.g., too many new checkpoints), rate-limits could
     kick in or the log might be dropped from the witness' configuration.  How
     the witness deals with "abuse" should likely be documented separately.

  3. **Does the log understand what it can expect from the witness'
     operations?**
     
     In an email conversation, a URL to the witness' `ABOUT_URL` would likely be
     shared when saying that the log's configuration has been applied.  And the
     witness would assume that the log's users also become aware of this info.

  4. **Does it make sense to witness this log? Is it a real log with
     verification?**

     Softer criteria.  Basically about not wanting to waste resources.  In an
     email conversation you would likely infer this based on how well they wrote
     the initial email and/or answers some basic follow-up questions.  Sharing
     an ABOUT_URL for the log might further help assess this.  The main worry
     here is that such "assessing" may become heavy on the witness operator.
     Especially if there are many "configure me" requests.  It seems quite
     natural that a trusted 3rd party helps with such "assesing", as a service
     to witness operators that helps them not configure too many dummy logs.

     Another obvious "ani-spam" to run a very reliable witness that isn't
     flooded/worried by too many configuration requests: charge money for it.

  5. **Is the origin reasonable for this request?**  Some kind of weak
     authentication.

     Maybe linking to an about page for the log on that origin?  This 5th point
     was added on 2025-01-09 based on Nisse's comment in
     https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/97.

     Nisse also raises: it would be good to document where the witness'
     responsibility begins and ends wrt. "weakly verifying" the origin; maybe
     with some form of best practise.  And also to clarify that if this weak
     authentication fails -> don't draw the picture that the witness operator is
     bad -- what they sign up for is to only sign locally consistent tree heads.


XXX: applying rate limits as a witness is a bit troublesome if anyone can submit
add-checkpoint requests.  I.e., then easy to drain someone's limit.  This would
be a lot easier to deal with if each log had its own bastion that the witness
connects to (and only the log can talk via the bastion).

XXX: for low-frequency logs it is less clear how to assess how much resources
they will actually use (if RATE overshoots for reliability).  Does it make sense
to assume the worst case (aka what's said in RATE)?

XXX: what `RATE` would one want to set for a low frequency log?  Helps inform
how to think about how many such logs are "easy" and "not risky" to configure.

XXX: it would be a good exercise to have an answer for "10k configuration
requests just arrived. Now what?"

XXX: another parameter related to capacity is "human resources".  Is it true
that witnessing k and k+1 logs is roughly the same burden?  We should write down
an argument for this / what we (don't) expect of witnesses.  And then try to
think of how that argument may break in practise.  E.g., "my log asks the
witness for cosignatures; the witness is alive; there's no split-view; yet the
witness is not cosigning".  (Has happened recently.)

XXX: do we ever anticipate that the witness operator needs to contact the log
operator?  I'd like to say no, but not sure if it is too wishful thinking.

---

From a configuration-overhead perspective we can probably think of a request to
update an existing configuration roughly the same as a request to add a new log.

## Concluding remarks

My initial plan was to type up both what to share (and why) for:

  1. A log that wants to be cosigned by a witness
  2. A witness that wants to cosign a log

With the thinking that an `ABOUT_URL` for both the log and the witness is a
crucial part of the configuration request.  (I think for (2), it is basically
what one would share as a witness that wants to start cosigning a log.  And it
is also the essential information needed when constructing trust policies.)

I only started with (1) so far, and have more questions than answers.  But:
working on what should be on a witness' `ABOUT_URL` page seems essential for
both (1) and (2).  So I'd like to continue there.  If we typed up "Glasklar's"
and "TrustFabric's" `ABOUT_URL` pages -> we can learn from each other, and type
up a general guideline that then points at our pages for inspiration / examples.

The other thing I think we need to debunk more is: where a witness'
responsibilities start and end.  A bit related to the above exercise.

It also seems to me like a primary function of a 3rd party that maintains shared
configuration is: it helps with anti-spam / vetting of if it is "really real
logs" and whether applying configuration is safe from a reliability perspective.
