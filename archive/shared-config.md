# More notes on shared configuration

Just some notes by rgdd, not a concrete proposal.  Read format things with a
pinch of salt -- the goal here is just to convey bits that seem necessary.

## Hi I'm a log and I want to be witnessed

Provide the witness operator with the following line:

    RATE VKEY ABOUT_URL [ORIGIN]

`RATE` is how often the log wants to be able to ask for witness cosignatures.
E.g., "1/s", "10/s", "4/d", "16/m", "68/y".  Or whatever is a good "/" syntax.
Easily selected for high-frequency logs, and low-frequency logs should specify
the rate they need to feel sufficiently safe in case they need to do bursts.

(The other option would be to also have a `BURST` toggle, but I think it amounts
to basically the same thing: a very infrequent `RATE` and then a sufficiently
large `BURST`, i.e., that would then be mostly the same as just `BURST`/unit.)

`VKEY` is the log's (Ed25519) key in note-verifier format.  Used for
add-checkpoint requests.  If the key name is not the same as the log origin, the
optional `[ORIGIN]` string must be specified as well (spans until end of line).

`ABOUT_URL` links to a page summarizing what's important to know about the log.

### Discussion

What would one do as a witness operator if the above request comes from a random
stranger on the internet?  Assumption is you want to help witness others' logs.

  1. Do I have the information needed to configure the log?  Yes, `VKEY` (and
     possibly `ORIGIN`) is sufficient.

  2. Do I have capacity to witness this log?  This can be assessed from `RATE`.

     If abuse is detected (e.g., too many new checkpoints), rate-limits could
     kick in or the log might be dropped from the witness' configuration.  How
     the witness deals with "abuse" should likely be documented separately.

  3. Do the resources I will spend on being a witness seem proportional to the
     benefit?  Both "machine resources" and "human resources" matter here.

     Machine resources can be determined from `RATE`.  Benefit could be
     determined from a good `ABOUT_URL` page.  Unclear if that's an efficient
     spam-protection mechanism though / how much time it takes to assess.
     Exactly how important it is to assess the benefit is related to `RATE`
     *and* how much capacity the witness wants to reserve/spend.

     If a different witness that does a bit of "vetting" configured a log, then
     that might be a signal to other witnesses that they want to configure too?
     This suggest that a form of "one or a few party vetts" is quite natural.

     If we can document what the witness is (not) expected to engage in after
     configuration I think that would be helpful to get more clarify here, i.e.,
     the most expensive part is "human resources".  And it would be good if we
     had a write-up on how that is ~constant for k logs?  (Is this statement
     true, and under which corner-cases does it fall apart?)

  4. Does the log understand what it can expect from the witness' operations?
     
     In an email conversation, a URL to the witness' `ABOUT_URL` would likely be
     shared when saying that the log's configuration has been applied.  And the
     witness would assume that the log's users also become aware of this info.

Knowing what the log is about seems more important if it consumes more resources
(high frequency).  And what one wants to be convinced of then is probably that
the log is part of a community that seems to do *something for someone*.

Starting to know things about low-frequency logs comes into play if the witness'
spending budget is limited so that spam requests risk filling it up too quickly.
Storage doesn't seem to be a major issue, but what about estimates from `RATE`?
100k logs at 30 requests/month (is that low/high enough?) is ~11.6 requests/s.
Part of what's tricky here without both "expected rate" and "required burst for
safety reasons" is that not all 100k logs are likely to burst at the same time.
Exactly how a witness thinks about resource allocation matters for reliability.

What do we do when there are 10k spam requests? 100k? Seems like this is when
there needs to be more interaction (or convincing work from the requester) to
get legitimate logs configured.  Is `ABOUT_PAGE` enough to thwart this threat?

If not, what is?

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

## About page for logs?

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

