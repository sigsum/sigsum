# A few words on configuring logs and witnesses by rgdd

See the concluding-remarks section for the proposed next step.  Appendix A is
only included as food for thought on where we might want to go in the future.

## Background

A log that wants to collect cosignatures from a witness needs to be configured
with:

  - A witness name (to validate that cosignature lines are valid)
  - A witness public key (to validate that cosignatures are valid)
  - A witness URL (to send add-checkpoint requests)

A witness that wants to cosign a log needs to be configured with:

  - Log origin (used as a long-term identifier, must be unique)
  - Log public key (to authenticate add-checkpoint requests)

At the time of writing, the above configuration is communicated via email and
then manually configured.  Various formats are used to express configuration,
such as Sigsum's [policy-format][] lines or TrustFabric's [vkeys][].

[policy-format]: https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/policy.md
[vkeys]: https://pkg.go.dev/golang.org/x/mod/sumdb/note

## Challenges

  1. Logs and witnesses need to "find" and configure each other.  Right now this
     is ad-hoc and, e.g., done by one of the parties emailing the other party.
  2. We don't have a common format for sharing the necessary configuration.
     This makes our email conversations harder than they need to be.
  3. We don't have a best practise for what to say in addition to "here is my
     configuration".  I.e., things that help guide if configuration makes sense.
  4. A witness that happily configures every log on request will be subject to
     DoS, e.g., the required storage will grow towards infinity and depending on
     the expected add-checkpoint volumes the load will eventually be too large.
  5. A log that happily configures every witness on request will be subject to
     DoS, e.g., the `GET /checkpoint` endpoint then becomes increasingly heavy.
  6. Multi-log systems (such as Sigsum) benefit from having the same witnesses
     configured, because trust policies that want to use all logs for increased
     reliability can only pick-and-chose from commonly configured witnesses.

## Discussion

Unlike (2) and (3), none of (1), (4), (5), and (6) are problems right now.  But
we anticipate that they might become problems as the community grows larger.  If
we are a bit proactive here we can hopefully avoid some future headaches.

Related to (3), it would be good if logs and witnesses self-declared what to
expect from their operations.  So others can make decisions based on that.
Including things like contact information in case problems/abuse is detected.

It seems unlikely that (4) becomes a major problem from a storage perspective
anytime soon.  E.g., 16GiB storage is enough for around 67.1M logs (calculated
based on 256 bytes of storage per log -- to store both state and configuration).
Having this many transparency-log use-cases would be a good problem to have.

(16GiB storage is a modest assumption in many environments.  But not all?  If,
e.g., a TKey can't handle enough logs we can likely find OK workarounds.  One
way would be to authenticate the larger state with a log-like data structure.)

It seems more likely that cosignatures/s becomes the bottleneck for a witness,
as well as the number of "please configure me requests" if each such request
requires a bit of assessing on the operator's end (whether to configure or not).

It would be good if a witness operator knows how much load it can handle over
time (cosignatures/s), and that the log declares how much it expects to require.
A witness might remove a log that significantly exceeds the declared rate.

It seems more likely that (5) becomes a problem for logs that generate new
checkpoints often, e.g., every 1-10s.  This type of load should likely be
discouraged unless it is a public log that is used by a larger community.

It is not obvious if (6) is a per-community thing, or if it is a cross-community
thing as long as the log(s) don't want to be very opinionated on which witnesses
to configure.  One way to find out is to start resolving this in a single
community (e.g., Sigsum) and then see if it is also useful for others after.

## Concluding remarks

When starting to type up this document the intent was to start a discussion on
how to, e.g., maintain a list of logs that witnesses might want to configure (in
order to make it easier for witness operators to apply a default configuration
that a few trusted community members maintain for everyone that wants it).  This
has been moved to Appendix A because it is not the next natural step *yet*.

Suggested next step (and a bit of motivation why):

  - **Refine the adhoc email process**.  Basically a guideline on what to share
    when asking the other party to apply a witness/log configuration.  This
    includes formats and other information that is important to make the
    decision as easy as possible.  Agreeing on how to do this will make it
    possible to later create a service and associated automation (Appendix A).

We might also want to work on the below before (or in parallel) to Appendix A.

  - **Tools to performance-test a witness**.  Because understanding how much
    load can be handled is important when processing "configure me" requests.
    If we want to have a service that maintains a list of logs that witnesses
    can cosign (Appendix A), then we will likely have to make some assumptions
    about what we intent to help configure to do it reliably.  For example, "we
    maintain this list of logs that want to be cosigned for witnesses that have
    at least X storage and which is able to process Y cosignatures/s over time".

# Appendix A

This appendix is intentionally brief on technical details because (i) it is not
the next immediate step to work more on this, and (ii) when we start working on
this we first need to agree on what we want to do on a high level.  I.e., then
we can make informed decisions on how to satisfy the system properties we want.

## Idea (sketch)

Reduce configuration overhead for logs and witnesses by centrally maintaining:

  - One or more lists of logs that want to be witnessed.
  - One or more lists of witnesses that want to cosign logs.

This allows logs and witnesses to use the centrally maintained lists as sane
default configurations.  For example, a witness baked into sunlight could use
the list of logs so that the logs need not reach out to the sunlight operator.

If the centrally maintained lists don't serve an operator's interests, then a
few additions and removals on top of the default configuration can be applied by
the operator.  It's paramount that an operator can override the defaults, and
that it is true that if the default configuration goes haywire it is noticed.

There are several ways an operator could use the centrally maintained lists,
e.g., ranging from looking at them manually to software that uses the lists
automatically (or perhaps ansible downloads and refreshes them periodically).

## Discussion

To reduce the impact when the central party gets compromised, we could have a
few safeguards/claims specified like "we will never remove configuration", "we
will not add INF numbers of new configurations over night", etc.  These type of
safeguards can help operators reject obviously wrong configurations early.  The
impact of getting a few dummy logs or witnesses configured is relatively small:
the worst impact would likely be that the origin namespace gets a bit polluted.

The central party could in practise be a few different community members, each
of which can update the lists of logs and witnesses on request.  It is important
to articulate the selection criteria, both so that the community members with
"privilege" here provide the same service; and so that operators that want to
depend on the shared configuration can understand what to expect from the lists.
The idea is that an operator should be able to say: "great, I would have done
the same thing otherwise.  Let's use the list that someone else vetted for me."

If the central party is >1 community member, it seems essential to be able to
say who added which configuration in case that issues are found after the fact.

We could make all list updates transparent, so that the central party can be
held accountable and in the worst case be replaced if they do a poor job.  If we
go down this route (signatures and/or transparency log) we need a trust policy.

It seems likely that a few different central lists might emerge.  E.g., a list
of logs that targets witnesses with a certain performance profile (X storage and
Y cosignatures/s).  It is also worth noting that a centrally maintained list of
logs that wants to be witnessed and a centrally maintained list of witnesses
that want to cosign logs are _different services_.  So let's ensure that we
don't merge this into a single service in an awkward way.

It is desirable that others can copy-paste our setup.  So that it is easy to
replace us if we do a poor job, or if we are not fulfilling a community need.

When it comes to lists of witnesses that logs want to ask for cosignatures: this
seems applicable for multi-log systems or single-log systems that doesn't want
to be too opinionated on which witnesses users can use in their trust policies.

Configuring a single log that is trust-policy opinionated is ~low overhead for
the log operator (something that's done ~once and rarely updated after that).

It seems easier to have a list of logs that witnesses want to cosign, because it
doesn't really matter if a witness applies a configuration and then the log
never asks for cosignatures.  The opposite is more awkward (i.e., a log that
repeatedly asks a witness for cosignatures if it doesn't want to be asked).

We need to discuss what to put in the item of each log/witness list.  The
essential things like origin line, public key, etc., are a given.  What else?
Information like "this is a high-frequency log", "this is a low-frequency log",
etc., would be helpful to detect possible abuse / unexpected use.

## Appendix B (misc summary by rgdd when talking to Al)

Some more comments / thinking-out-loud related to Appendix A (it's a slightly
edited version of what rgdd replied to Al in an email thread.)

The opportunity I see is to make it as easy as possible to operate a witness
(and to get a log configured by witnesses).  If we can provide a service that
relieves the witness from being contacted by every log -> win.  This
approximately sounds like a list of vkeys that is made available on one or more
well-known URLs, as well as a place for logs to interact with us so we can add
them to the list.  The only metadata I've been able to think of so far is
expected add-checkpoint rate and the log's contact information.  Which would
likely be useful for the witness operator in case of problems/abuse.  I don't
have strong opinions on the format, but I would be surprised if this list
becomes so complicated it can't just be line-separated.

The other opportunity I see is to help logs discover witnesses that they may
choose from.  I don't think this needs to be machine readable, but if that is
useful for a particular subset of the community I think they can roll their own
machine-readable list.  Or we can do this later on, but it's not the lowest
hanging fruit imo.  Note: this is less of a technical problem.  I'd like to
help by providing guidelines on what information a witness should share.  From
this information I would expect those that have opinions on trust policies to
derive the ones that make sense to them.

Anyway, I don't think the central service / vantage point should (or needs to)
have an opinion on witness groups and trust policies.  So at a first stage this
might just boil down to a markdown table with two columns: a name and a URL to
read more about the witness' ops.

## Appendix C (misc comments)

We don't seem to think that the policy-file format is great fit for
configuring logs/witnesses.  It's a trust policy format for users/monitors.

---

On witness groups: When the same party operates multiple witnesses, I think
that should be documented in the witness listing

I think it could makes sense that witness listing includes (or references) the
operator's advice on how to depend the operator's group of witnesses.

I totally agree that maintenance of any suggested trust policy should be kept
separate from the list of witnesses. Mainly to reduce the responsibilities and
required due diligence of witness list maintenance.

We can provide guidelines and good examples of how to document "this is what to
expect from my witness". Including things like how to get in touch (contact
info), hardware, software, key management, operational setup, how much of a
priority it is to fix issues if they do happen, etc.

We can link to the information the witness has self-declared, then it is up to
the party that wants to depend on the witness to assess if they have the
information they need to determine if they are honest and capable (I like this
distinction elias). Any help/guidelines/examples we can give to make these self
declarations as good and useful as possible as operators are onboarded to the
system -> win.

So in scope here is: to help with discovery but not to have an opinion on how
to group in trust policies. You can view this as helping with the "inputs" to
think about trust policies.

Yep, so each witness operator has some kind of "about me" page/document.

---

If an operator uses a centrally managed list automatically, even removing
things automatically when the centrally managed list says so, then whoever
manages that central list has the power to cause lots of damage?

Maybe then it would make sense to (1) discourage automatic use of centrally
managed list and/or (2) discourage removal of things based on centrally managed
lists unless the removal has been carefully considered, because removals are
potentially more dangerous than additions.

Yes, +1. A lot less worried about adding compared to removing and/or updating.

## Appendix D

What about shared formats for system logs and monitoring metrics?  Not covered
in these notes.  See:

https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2024-11-26--meeting-minutes.md?ref_type=heads#other

Somewhat orthogonal to what we're trying to achieve here (which is to make it
easier to configure logs and witnesses for *log and witness operators*; and to
discover the *inputs* to trust policies).

But, e.g., having a way to signal planned downtime -> that seems useful as
*input* to those that construct reliable trust policies.  So may fit here.

Could, e.g., fit into what most operators do as a best practise, and document
that they're publishing such information in a common way.
