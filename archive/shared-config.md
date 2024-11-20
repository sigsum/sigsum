# More notes on shared configuration

Just some notes by rgdd, not a concrete proposal.  Read format things with a
pinch of salt -- the goal here is just to convey bits that seem necessary.

## Hi I'm a log and I want to be witnessed

Provide the witness operator with the following line:

    VKEY AVG_RATE BURST ABOUT_URL [ORIGIN]

`VKEY` is the log's (Ed25519) key in note-verifier format.  Used for
add-checkpoint requests.  If the key name is not the same as the log origin, the
optional `[ORIGIN]` string must be specified as well (spans until end of line).

`AVG_RATE` is how often the log usually creates new checkpoints (seconds).

`BURST` is the maximum number of extra checkpoints the log may create in a short
period of time.  Mainly useful for low frequency logs that have a very low
`AVG_RATE`.  But to not DoS itself, the log wants the freedom to do a burst.

`ABOUT_URL` links to a page summarizing what's important to know about the log.

### Discussion

What would one do as a witness operator if the above request comes from a random
stranger on the internet?  Assumption is you want to help witness others' logs.

  1. Do I have the information needed to configure the log?  Yes, `VKEY` and
     `ORIGIN` is sufficient.

  2. Do I have capacity to witness this log?  Yes, we can assess this from
     `RATE` and `BURST`.

     If abuse is detected (e.g., too many new checkpoints), rate-limits could
     kick in *or* the log might be dropped from the witness' configuration.  How
     the witness deals with abuse would likely be documented separately.

  3. Does the resources I will spend on cosigning seem proportional to the
     benefit?  This is a function of the specified rate, and how easy it is to
     see that the log seems "real enough" from the log's `ABOUT_URL`.  And the
     risk of the witness having to engage in abuse/debug/updates after config.

     It might make the decision easier if the log is already cosigned by other
     witnesses that the witness operator knows do due diligence before config.
     This suggests that a service that does such due diligence is *helpful*.

     If we can document what the witness is (not) expected to engage in after
     configuration I think that would be helpful to get more clarify here.

  4. Does the log understand what it can expect from the witness' operations?
     
     In an email conversation, a URL to the witness' `ABOUT_URL` would likely be
     shared when saying that the log's configuration has been applied.  And the
     witness would assume that the log's users also become aware of this info.

What would we recommend to have on the log's about page?

  - contact information (e.g., email in case that abuse is detected)
  - origin line and how it was selected ("I'm confident it should be unique")
  - vkey(s): at minimum the key used when interacting with witnesses. If
    different keys are used, make it clear which key is used for what.
  - purpose: why does the log exist / what problem does it solve. A few sentences.
  - read more: links to anything that shows this is a "real log" with plans to
    do verification. Otherwise it is pretty moot to do witnessing of this log.

From the witness' perspective it doesn't seem relevant to know more about how
the log is operated.  But it likely makes sense to also put this on the page,
because it is also a sign that the log put in some work typing up the page.

## Hi I'm a witness and I'd be happy to cosign logs

Provide the following line:

    NAME ABOUT_URL

`NAME` is the name used in cosignature lines (should be a schema-less URL).

`ABOUT_URL` is a browsable URL that documents how the witness is operated.
Includes other essential information like public key.

Ideas what to put on the witness' about page:

  - contact info (e.g., email)
  - service info (ongoing incidents, history of incidents)
  - vkey(s): should match what the witness puts as cosignature lines.
  - what hardware
  - what software
  - estimated capacity (handles up to X logs and Y cosignatures/s)
  - how to get a log configured (e.g., send an email with info X; or we
    configure logs that the people over there have vetted for us; etc.)
  - XXX: continue here, so far just dumping and not done.
