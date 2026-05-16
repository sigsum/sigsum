# Beyond testing

Ready to move beyond testing but unsure where to start?  This document aims to
help you forward by going through a few important considerations while also
linking to relevant HOW-TO documentation.

Missing a section or HOW-TO guide?  Please let us know and/or help with a
contribution on your own.

## Table of contents

<!-- toc -->
- [Know what your claims are](#know-what-your-claims-are)
- [Know how a Sigsum signature works](#know-how-a-sigsum-signature-works)
- [Have a plan for your trust policy](#have-a-plan-for-your-trust-policy)
- [Select logs and witnesses to depend on](#select-logs-and-witnesses-to-depend-on)
- [Generate Ed25519 submission keys](#generate-ed25519-submission-keys)
<!-- /toc -->

## Know what your claims are

The point of using a transparency log like Sigsum is to detect *unwanted
events*.  An unwanted event could be that your signing key is used without your
participation, e.g., due to key compromise.

Another way to describe the point of using a transparency log like Sigsum is to
make a [claim][] about what you're doing.  Thanks to the added transparency, a
monitor can try to *falsify* these claims by enumerating the log and then
following your instructions on what to (not) expect.

An easy claim would be that the signed message can be retrieved at a well-known
URL.  For example, it is common to always publish the signed message at
`BASE-URL/<checksum>`.  Upon finding a new checksum in the log, the monitor can
fetch the message out of band and raise a flag if it's missing.

Another claim could be that the signing key is only used for signing binaries
that build reproducibly in a well-known repository.  Upon finding a new checksum
in the log, the monitor can check if there are any new releases of the software
and raise a flag if that's not the case or if the release doesn't rebuild.

If you're unable to describe what unwanted event you want to detect or which
claims can be falsified, then odds are that the value you'll be able to extract
from Sigsum is limited.  Therefore, we recommend that you think about which
notifications you would like to receive from a monitor as early as possible.

We have a few guides that might help you forward in this area.

* Guide: [unexpected signature event](/how-to/claims/unwanted-signature-event)
* Guide: [claim: data is published](/how-to/claims/claim-published-data)
* Guide: [claim: binary is reproducible](/how-to/claims/claim-rb)
* Guide: [claim: backup sysadmin behaved](/how-to/claims/claim-backup-sysadmin)

If you publish data for monitors that falsify claims, then we recommend that the
data is published *before* submission to a log.  This reduces the risk of data
loss, e.g., in case the submitter crashes.

We recommend that you publish what your unwanted events or claims are, e.g.,
nearby your trust policy.  In the future, we may provide further pointers on how
to tie this more strongly to a trust policy.

[claim]: TODO-ADD-LINK-CLAIMANT-MODEL

## Know how a Sigsum signature works

To be added ("Sigsum proof").

Make it super clear, traditional signature vs transparent signature.
Similarities and differences.

Link something that plays with invalidating a proof in detail?

## Have a plan for your trust policy

In Sigsum, the term *trust policy* typically refers to your submission keys and
which logs and witnesses to depend on.  It is helpful to think of your trust
policy as a regular key pair: it needs to be communicated to users and monitors.
Sometimes, an update may be necessary to bring keys in or out of the rotation.

Sigsum does not have an opinion on how you manage your trust policy over time.
This is because Sigsum is a *building block* that facilitates transparency for
key-usage; and the key management strategy that works well in one application
does not necessarily work as well in another setting.

To help with inspiration, we have documented a few approaches separately.

* Guide: [publish trust policy in a README file](/how-to/readme-trust-policy),
  e.g., used by the encryption tool `age`.
* Guide: [embed trust policy in the verifying software](/how-to/trust/embed-trust-policy),
  e.g., applicable in an automatic updater.

## Select logs and witnesses to depend on

The Sigsum project maintains a default policy named `sigsum-generic`.  Logs and
witnesses are selected based on [a number of criteria][criteria].  A short
summary would be that the participating parties have committed publicly to not
discontinue their operations without first providing a one year heads up.
This is meant to offer stability and continuity, giving you some time to evolve
the selected policy if needed.

Use `sigsum-policy` to list information about the latest
`sigsum-generic` policy.

    $ sigsum-policy list
    sigsum-generic-2025-1
    [snip]
    $ sigsum-policy show sigsum-generic-2025-1
    [snip]

You should see that there are two logs and three witnesses.  To reach a quorum,
two of the three witnesses need to provide valid cosignatures.  This means you
should be able to submit new signed checksums even if one log or witness is
down.  For security, 2-of-3 witnesses must follow protocol.

We recommend you keep an eye on the [sigsum-announce][] list to discover policy
changes.  Alternatively, you may subscribe directly to information from logs and
witnesses as specified in their about pages.

If you have a different set of logs or witnesses that you prefer to use, please
feel free to define your own custom policy.  Still unsure about which policy to
select? See [contact info][] on how to reach out.

**Note:** production logs typically apply rate-limits.  See the [rate-limit
HOW-TO][] for further pointers.

[criteria]: https://git.glasklar.is/sigsum/project/documentation/-/blob/main/policy-maintenance.md
[sigsum-announce]: https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-announce@lists.sigsum.org/
[contact info]: /contact
[rate-limit HOW-TO]: /how-to/rate-limits

## Generate Ed25519 submission keys

You will need at least one long-term Ed25519 submission key.  You already
generated a soft key-pair in the [getting started guide][].  If you prefer to
store your signing key on a hardware security module or a security key, refer to
the below HOW-TO guides.  Please help us document missing options that work.

* Guide: [Soft signing key](/how-to/soft-signing-key)
* Guide: [TKey signing key](/how-to/tkey-signing-key)
* Guide: [YubiHSM2 signing key](/how-to/yubihsm2-signing-key)
* Guide: [YubiKey signing key](/how-to/yubikey-signing-key)

Depending on how hard it is to recover from key loss, consider having a
secondary key-pair in a safe location.  If the secondary key is ever used, you
and others will know thanks to Sigsum's transparency.

Regardless of if you run with a soft key in a less protected environment (e.g.,
a CI pipeline) or a hardware-backed key, we recommend that you think about the
recovery procedure upfront.  The exact procedure will depend on your
application.  [See above](#have-a-plan-for-your-trust-policy) if you want
inspiration from a few examples.

TODO: say something about named policy + key on the same key line SSH format?

[getting started guide]: /getting-started
