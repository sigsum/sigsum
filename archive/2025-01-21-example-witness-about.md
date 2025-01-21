DRAFT / EXAMPLE -- please read with s/GLASKLAR/EXAMPLE. I.e., this is what rgdd
and ln5 are iterating on and it is neither ready nor decided at glasklar.

# About GLASKLAR-WITNESS-1

This document describes configuration and operational aspects of
[Glasklar Teknik]'s transparency-log witness GLASKLAR-WITNESS-1.

## Changes to this document

The complete history of this document is available at:

- https://git.glasklar.is/glasklar/services/TO-BE-ADDED

Non-trivial changes are announced via email at:

- https://lists.glasklarteknik.se/TO-BE-ADDED

## Funding and discontinuation

Operation of GLASKLAR-WITNESS-1 depends on funding from FIXME.

Any plans to discontinue GLASKLAR-WITNESS-1 or to change the implemented
specifications will be [announced] at least FIXME-TIME-UNITS in advance.

## Interoperability

The following specifications are implemented:

- https://c2sp.org/https-bastion (version 1)
- https://c2sp.org/tlog-cosignature (version 1)
- https://c2sp.org/tlog-witness (version 1)

## Availability

Operational issues are tended to during regular working hours. This means ~8-17
CE(S)T, Monday--Friday, unless it is an official [Swedish holiday]. In addition
to this, issues may be fixed on a best-effort level outside of the regular
working hours.

How to report an operational issue:

- https://git.glasklar.is/glasklar/services/TO-BE-ADDED
- `glasklar-services-TO-BE-ADDED-issues (at) incoming.glasklar.is`

Where to find past operational issues:

- LINK-TO-BE-ADDED

Planned maintenance is [announced] FIXME-TIME-UNITS in advance.

Other noteworthy events are [announced] as soon as possible.

## Operations

- **Hardware:** Raspberry Pi 4b with a PoE HAT.
- **System software:** [Custom-made], based on Debian 12 (Bookworm).
  - Automatic updates are enabled, checking once per hour.
  - System is rebooting automatically into new kernel.
  - System time is synchronized with 2.debian.pool.ntp.org, using chrony.
  - Validating DNS resolver running locally.
- **Witness software:** [litewitness ansible role]
  - Versions are bumped manually after review.
- **Key management:** Key is kept in a YubiHSM2.
  - https://git.glasklar.is/sigsum/core/key-mgmt/-/blob/main/docs/key-management.md
  - https://git.glasklar.is/glasklar/trust/audit-log
- **Physical access:** Employees at [Glasklar Teknik] (Sweden).
- **Remote access:** Sysadmin team at [Glasklar Teknik].
  - sk-ssh-ed25519@openssh.com keys only, no passwords.
- **Service redundancy:** None.
  - Power and internet connectivity outages will render the service unavailable.
    - Hardware failures will render the service unavailable.
- **Key redundancy:** Yes. -
  https://git.glasklar.is/sigsum/core/key-mgmt/-/blob/main/docs/key-management.md
- **Availability monitoring:** End-to-end [checker jobs].

## How to request witnessing of a log

Send an email to:

- `witness-registry (at) glasklarteknik (dot) se`

Specify:

- The log's [verification key]
  - The key name should be a [schema-less URL]
  - The key name should be the same as the log's [origin line]
- Some "proof" that you're authorized to use the verification-key name
  - E.g., serve the verification key under a page for the same domain
  - Self-authenticated key-names are exempted from this (e.g., Sigsum logs)
- How often the log is expected to submit `add-checkpoint` requests
- Contact information to someone responsible for the log's operations

Expect a response within a couple of working days.

Also expect that the witness-registry inbox is non-public.

## Configuration for log operators

- **Verification key**: `GLASKLAR-WITNESS-1+33f20420+AR..[FIXME]..qC`.
- **Bastion host:** `git.glasklar.is`, key hash `0123..[FIXME]..cdef`

## Configuration for trust policies

Use the verification key that is listed above.

You may find [sigsum-key] helpful for conversions between various
verification-key formats.

[announced]: https://lists.glasklarteknik.se/TO-BE-ADDED
[checker jobs]: https://git.glasklar.is/sigsum/admin/checker/-/tree/sigsum
[custom-made]: TO-BE-ADDED
[glasklar teknik]: https://www.glasklarteknik.se/
[litewitness ansible role]: https://git.glasklar.is/sigsum/admin/ansible/-/tree/main/roles/litewitness
[mullvad vpn]: https://www.mullvad.net/
[origin line]: https://github.com/C2SP/C2SP/blob/main/tlog-checkpoint.md#note-text
[schema-less url]: https://github.com/C2SP/C2SP/blob/main/signed-note.md#signatures
[sigsum-key]: https://git.glasklar.is/sigsum/core/sigsum-go/-/tree/main/cmd/sigsum-key
[swedish holiday]: TODO-NC-LINK
[verification key]: https://pkg.go.dev/golang.org/x/mod/sumdb/note#hdr-Verifying_Notes
