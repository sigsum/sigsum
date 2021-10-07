# The Sigsum Project
Sigsum is a free and open-source project that brings transparency logging to
**sig**ned check**sum**s.  The overall design is kept general by not logging
a more concrete data structure like TLS certificates or Go modules.

- [x] Discoverability of signed checksums for the data of your choice
- [x] Centralised log operations but distributed trust assumptions
- [x] Minimalistic design that simplifies log operations and usage

Sigsum logging can be used to make a signer's key-usage transparent.  For
example, malicious and unintended key-usage can be detected.  Transparent
key-usage also facilitates verification of falsifiable claims.

Examples include:

- Everyone gets the same executable binaries
- A domain does not serve malicious javascript
- A list of key-value pairs is maintained with a certain policy

Please refer to the sigsum logging
[design document](https://git.sigsum.org/sigsum/tree/doc/design.md),
[API specification](https://git.sigsum.org/sigsum/tree/doc/api.md), and
[public prototype](https://git.sigsum.org/sigsum-log-go/tree/README.md)
to learn more.

## Services
Sigsum is self-hosting all services required to function as a software project.
Each service is operated on a best-effort level that is good enough for Sigsum
to rely upon.  Please report any issues to the Sigsum team via chat or email.

### Chat
Chat with users and developers on IRC or Matrix. The rooms
are bridged so it does not matter which one you choose.

- IRC: \#sigsum @ [OFTC.net](https://oftc.net/)
- Matrix: [#sigsum:matrix.org](https://app.element.io/#/room/#sigsum:matrix.org)

There are open video/voice meeting on Tuesdays at 1100 UTC, in the 'sigsum' room.

- Jitsi: [meet.sigsum.org/sigsum](https://meet.sigsum.org/sigsum)

### Email
Subscribe to the sigsum-general [mailing list](https://lists.sigsum.org/) by
sending an empty email to

    sigsum-general+subscribe@lists.sigsum.org

and follow the instructions received in response. To unsubscribe, send
an empty email to


    sigsum-general+unsubscribe@lists.sigsum.org

To retrieve help on how to manage your subscription further, send an
empty email to

    sigsum-general+help@lists.sigsum.org

You can provide feedback, report issues, and submit patches by sending an email
to sigsum-general@lists.sigsum.org.

### Other
- Source: [git.sigsum.org](https://git.sigsum.org/)
- Pads: [pad.sigsum.org](https://pad.sigsum.org/)
- Website: [www.sigsum.org](https://www.sigsum.org/)
- Onions: can be discovered for all services via [Onion-Location](https://community.torproject.org/onion-services/advanced/onion-location/).

## Sponsors
- [Mullvad VPN](https://mullvad.net/), financial sponsor
- [DFRI](https://www.dfri.se/), mailing list sponsor
