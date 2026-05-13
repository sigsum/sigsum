Work in progress -- let's see if this is useful to continue working on.

# Beyond testing

Ready to move beyond testing but is unsure where to start?  This document
aims to help you forward by going through a few important considerations
while also linking to relevant HOW-TO documentation.

Please help us extend this page with more relevant sections and HOW-TO guides.

## Select which logs and witnesses to depend on

The Sigsum project maintains a default policy named `sigsum-generic`.  Logs and
witnesses are selected based on [a number of criteria][criteria].  The short
summary is that the participating parties have committed publicly to not
discontinue their operations without first providing a one year heads up.

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
down.  To detect issues, 2-of-3 witnesses must follow protocol.

<!---Worth calling out, or better to keep this brief?
(Your observation that `sigsum-generic-2025-1` would benefit from further
organizational diversity is correct.  Iterations of `sigsum-generic` are
expected once other operators commit to stable services.)
--->

If you have a different set of logs or witnesses that you prefer to use, please
feel free to define your own custom policy.  Still unsure about which policy to
select? See [contact info][] on how to reach out.

**Note:** production logs typically apply rate-limits.  See the [rate-limit
HOW-TO][] for pointers.

[rate-limit HOW-TO]: /how-to/rate-limits

[contact info]: /contact

[criteria]: TO-BE-ADDED

## Generate one or more signing key-pairs

You will need at least one long-term signing key-pair that the Sigsum tools can
access using the SSH agent protocol.  You already tried this in the [getting
started guide][] using a [soft key][].  If you prefer to use a hardware-backed
key, you might find any of the following HOW-TO documents helpful.

* HOW-TO: [YubiHSM 2](/how-to/yubihsm2)
* HOW-TO: [TKey](/how-to/tkey)

[getting started guide]: /getting-started
[soft key]: /how-to/soft-key

## Communicate submitter keys and trust policy

Sigsum does not come with its own opinionated public-key infrastructure (PKI).
Therefore, you will need to bring your own PKI.  In some cases, this might be as
simple as publishing the appropriate keys and corresponding policy file in a
README.  This is how [trust is established for the encryption-tool age][age].
In other cases, it might be more reasonable to embed the appropriate keys and
corresponding policy file directly into the verifying software.  For example,
this would be [easy to integrate in an automatic updater like the one in Tor
Browser][tb].  What makes the most sense varies depending on the application.

Take a look if any of the HOW-TO documents on this topic help you forward.

* HOW-TO: [Use a README file](/how-to/trust/readme)
* HOW-TO: [Embed in the verifying software](/how-to/trust/embedded)

[age]: TODO-LINK
[tb]: TODO-LINK

## Communicate what your claims are

The point of using a transparency log like Sigsum is to detect unwanted events.
Another way to describe the point of using a transparency log is to make a claim
about what you're doing.  Thanks to the added transparency, these claims can be
discovered so that others can try *falsify* them.


[claimant model]: TODO-LINK

If you're unable to describe what unwanted event you want to detect (e.g., "I
want a ping every time my signing key is used because *I will know* if I didn't
click the sign button") or which claim can be falsified (e.g., "the signed data
is available at `example.org/<checksum>` or perhaps "the signed binary can be
reproduced from source at `git@git.example.org/source`"), then odds are that the
value you're able to extract from using a transparency log is limited.

An exercise that can be helpful here is to figure out what notification you
would like to receive if an interesting event occurs.  In the reproducible
builds example, it could be an issue being filed that the signed binary everyone
agrees on (thanks to transparency) doesn't build reproducibly.  Or even worse,
the inputs to start the build are completely missing.  Both of these events
would be fantastic to detect.

Take a look if any of the user contributed HOW-TO documents help you forward.

* HOW-TO: [unexpected signature](/how-to/claims/unwanted-signature)
* HOW-TO: [data is published](/how-to/claims/published-data)
* HOW-TO: [thing is reproducible](/how-to/claims/rb)
* HOW-TO: [backup sysadmin behaved](/how-to/claims/backup-sysadmin)

We recommend that you write down your claims and/or what you're able to get out
of using a transparency log somewhere.  If you start simple and just type this
in a README you will be ahead of most other users of transparency!

**Note:** the [claimant model][] by Martin Hutchinson is a great resource on
this topic.
