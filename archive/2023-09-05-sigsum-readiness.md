# Is Sigsum ready to be used?

On a scale 1-10:

      | no, first we need to invent sigsum
      |
      |           | yes, but expect some bumps
      v           v
    +-------------------------------+
    | 1  2  3  4  5  6  7  8  9  10 |
    +-------------------------------+
                                  ^
     yes, just refer to docs+code |

Before answering this question from a few different perspectives, the answer
would more confidently be "yes" if we started hosting a public production log
and a production witness. That would (1) serve as a public utility, and (2) be
evidence that Sigsum is in fact ready.

## Can a pilot user implement their own client verifier?

                              X
    +-------------------------------+
    | 1  2  3  4  5  6  7  8  9  10 |
    +-------------------------------+

    Needed involvement by us: LOW

The cryptographic design and all semantics are stable.  The log's API is stable.
We've implemented this in Go already, both libraries and command-line utilities.
See [sigsum-go][].  There's also a [Tillitis hackathon C implementation][].

Reference documentation:

  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/log.md
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/sigsum-proof.md
  - https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/policy.md

Command-line tools that implement client verifier, log submission, etc:

  - https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/tools.md

The main thing that's missing is explainer documentation.  In other words, the
above might be a heavy read without some existing transparency log knowledge.

We would likely need to provide some clarifications and answer questions in
IRC/Matrix, and/or have a meet or two to provide some initial guidance.
Implementing the client verifier should be easier than designing a use-case.

[sigsum-go]: https://git.glasklar.is/sigsum/core/sigsum-go
[Tillitis hackathon C implementation]: https://git.glasklar.is/nisse/tkey-sign-if-logged

## Can a pilot user run a production log?

                           X
    +-------------------------------+
    | 1  2  3  4  5  6  7  8  9  10 |
    +-------------------------------+

    Needed involvement by us: LOW

We encourage pilot user to get a log up and running, see:

  - https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-general@lists.sigsum.org/thread/3VBGVETN3Q44RFGVZJZDF4ZF4QLEMBC2/

The expectation is that we will provide well-documented upgrade paths between
releases.  Our next release brings up all aspects of the log software to v1.

Documentation of the log server architecture and ansible:

  - https://git.glasklar.is/sigsum/core/log-go/-/tree/main/doc
  - https://git.glasklar.is/sigsum/admin/ansible

We have not documented any detailed key management practises or recommended
hardware.  That might be an annoyance, or at least something that the operator
will have to figure out.  The operator will also have to figure out its own
uptime monitoring, and may be missing some prometheus (health) metrics.  The
Sigsum project is in the processes of figuring these type of things out for
ourselves, so expect that some operational things have room for improvement.

We would likely need to provide some clarifications and answer questions in
IRC/Matrix; and to some extend fix bugs and implement minor feature requests.

## Can a pilot user run a production witness?

                  X
    +-------------------------------+
    | 1  2  3  4  5  6  7  8  9  10 |
    +-------------------------------+

    Needed involvement by us: MEDIUM

While a [witness implementation][] exists, we are currently not releasing any
recommended software to be operated.  You will have to tinker yourself, and stay
up-to-date with what version of the witness you need to be running and why.  So,
this route will likely involve ping-pongs to understand where things are at.
And there will likely be bumps as the witness is being shaped towards readiness.

(Of note: these bumps will not be visible to an offline verifier.  There are no
planned changes to the cryptography or witnessing semantics.  What's not ready
is the exact details of the wire-bytes sent between logs and witnesses.  The
associated bastion host specification is similar not fully decided just yet.  It
is possible to run the witness without that on a public IP address, however.)

There's no documentation for how to get started, just a Go repository.  As for
the log software, we also have not documented key management and such.

Any pilot user that gets started with this right now would likely contribute to
our repositories to add missing documentation, fix bumps, and so forth.

[witness implementation]: https://github.com/FiloSottile/litetlog

## Can a pilot user run a production monitor and design for internal use?

                  X
    +-------------------------------+
    | 1  2  3  4  5  6  7  8  9  10 |
    +-------------------------------+

    Needed involvement by us: HIGH

We are in the process of implementing and documenting exactly this.  We can only
point to a [work-in-progress monitor][] at the moment without documentation.

Our required involvement would likely be significant right now, but low soon.

[work-in-progress monitor]: https://git.glasklar.is/sigsum/core/sigsum-go/-/tree/main/pkg/monitor
