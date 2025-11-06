# Procedure used for Sigsum builtin named policies

The Sigsum project maintains a set of named policies, currently named
as `sigsum-generic-YYYY-n` where `YYYY` is the year the policy was
released and `n` is a sequence number. Those policies are made
available in the form of builtin policies in the [Sigsum
tools](https://git.glasklar.is/sigsum/core/sigsum-go). This document
describes how these policies are maintained.

There are also builtin test policies, but the procedures described in
this document do not apply to them. Test policies should always have
"test" in the policy name, and should only be used for test and
development purposes.

## Policy name including year and sequence number

A builtin named policy should not change once it has been
released. Therefore, when a change is desired a new policy name is
used, based on the year and with a new sequence number. The first
policy in a given year gets the sequence number 1. As an example,
`sigsum-generic-2026-3` would mean the third `sigsum-generic-` policy
published during 2026.

## Purpose of the `sigsum-generic-*` sequence of named policies

There are several things that can be desirable for a policy, and there
can be tradeoffs between them. The following are some of the aspects
that matter:

- Security: it should be difficult for an adversary to perform a
  split-view attack.

- Availability: it should be possible to perform a Sigsum submission
  using this policy almost always.

- Longevity: the policy should remain useful over a significant time
  period.

Our aim for the `sigsum-generic-*` sequence of named policies is to be
generally useful; we aim for a balance between all the three aspects
above. The goal is to come up with a general purpose policies that can
be useful for many Sigsum users.

## Procedure used to define policy

To define a policy we need to decide a set of witnesses, a quorum
definition (defined via witness groups), and a set of logs. We do it
in this order:

- First decide a set of witnesses
- Then decide a quorum definition
- Then decide a set of logs

Each of those steps is described in detail below.

### Decide a set of witnesses

We select witnesses using a two-step procedure. The first step is to
define a list of candidates, including all witnesses we are aware of
that match a set of hard requirements. In the second step we decide
which of the candidates to include in the policy, taking into account
additional factors including to what extent the witnesses are
independent.

#### Hard requirements for witnesses

The following are hard requirements for witnesses:

- There must be an about page for the witness.

- The about page must contain a commitment to keep the witness
  available and supporting the appropriate versions of the relevant
  specifications for at least 12 months starting from the time when
  the policy is to be published.

#### Other factors considered for witnesses

Other factors considered when deciding whether to include a witness
are for example the following:

- Trustworthiness: are we convinced that the witness operator is who
  they say they are, and that they are honest in the information they
  are providing?

- Operational security: is the witness operated in a secure way? This
  includes considerations regarding management of signing keys and key
  backup.

- Independence in relation to other witnesses: is the witness
  independent from other witnesses in the policy in a meaningful way?
  Different kinds of dependencies between witnesses can be relevant
  here, see section "Independence of witnesses" below.

The main question we need to answer for a given witness, considering
the aspects above as well as any other relevant information, is: "will
adding this particular witness be an improvement of the policy,
compared to not adding this witness?"

#### Independence of witnesses

Ideally, we want the policy to be resilient against many different
kinds of events. For example:

- If a single actor (individual or organization) has the capability to
  compromise or take down several witnesses, then the policy is
  vulnerable. Therefore, if several of the witnesses in the policy are
  controlled by a single actor, the policy may be strengthened by
  adding witnesses that are operated outside of that actor's control.

- If several witnesses rely on the same kind of hardware device, then
  the policy may be vulnerable to a flaw in that hardware. In that
  case, the policy may be strengthened by adding witnesses that are
  operated in other ways, not relying on that kind of hardware.

- If several witnesses are physically located in the same place, for
  example in the same city, then the policy may be vulnerable with
  respect to something (e.g. natural disaster or other crisis)
  happening in that location. So, the policy may be strengthened by
  adding witnesses based in other locations.

- If several witnesses use the same software and if they all apply
  software upgrades automatically without review of individual witness
  operators, then the policy may be vulnerable with respect to flaws
  in updates to that software that could affect all those witnesses at
  the same time. The policy may be strengthened by adding witnesses
  using other software implementations, or witness operators
  independently reviewing software changes.

The above are just a few examples to illustrate that independence of
witnesses can be considered in a variety of different ways.

Some of the different aspects to consider are:

- Organization: which organization/individual is operating the witness

- Witnessing software

- Operating system

- Hardware (CPU manufacturer, kinds of HSM modules, etc)

- Physical location

- Jurisdiction

- Type of organization: (e.g. company vs non-governmental organization)

- Form of Internet access

### Decide quorum definition

Once a set of witnesses has been decided, consider how to group them
depending on dependencies between witnesses.

For example, several witnesses being tied to the same organization can
be a reason to place those witnesses in a group.

For each [witness group
definition](https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/policy.md#defining-a-witness-group),
the number `k` is decided in a way that balances security and
availability, taking into account all relevant information about the
witnesses and groups involved.

### Decide a set of logs

#### Hard requirements for logs

The following are hard requirements for logs:

- There must be an about page for the log.

- The about page must contain a commitment to keep the log
  available and supporting the appropriate versions of the relevant
  specifications for at least 12 months starting from the time when
  the policy is to be published.

- The log must be witnessed by all the witnesses needed for our
  policy.

- The log must be configured to request cosignatures from witnesses at
  least once every 10 seconds.

- If the log applies rate limiting then each submitter must be allowed
  to perform at least X (TODO) submissions per hour.

- The log must accept submissions from anyone that is able to control
  a DNS name as needed for rate limiting.

#### Other factors considered for logs

- Trustworthiness: are we convinced that the log operator is who they
  say they are, and that they are honest in the information they are
  providing?

- Reliability of operations: if there is a risk of significant
  downtime or even the log disappearing, then that log should not be
  included.

- Independence: it is preferable to have several independent log
  operators.

## Creating and publishing the policy file

When a set of witnesses, witness groups, quorum definition and logs
have been decided as described above, a corresponding policy file is
created.

For each witness and each log, carefully ensure that the correct
public key is used.

Add a comment line above each witness and each log with a link to the
corresponding about page.

Also add one or more comment lines above each witness group, briefly
explaining why those witnesses are grouped together.

The policy file is published in the form of a builtin named policy in
the `pkg/policy/builtin/` directory in the [sigsum-go git
repo](https://git.glasklar.is/sigsum/core/sigsum-go).
