# The Sigsum Project
Sigsum is a free and open source project that brings transparency logging to
**sig**ned check**sum**s.  Logging sigsums and not a more concrete type like
TLS certificates keeps the overall design simple and generally useful.

- [x] Minimalistic design that simplifies log operations and usage
- [x] Centralised log operations but distributed trust assumptions
- [x] Discoverability of statements for the data of your choice

A minimal statement encodes the following claim: the right data has a
certain cryptographic hash.  You can add additional meaning to each
statement.  For example, you may use a sigsum log to claim things like
(i) everyone gets the same executable binaries,
(ii) a domain does not serve malicious javascript, or
(iii) a list of key-value pairs is maintained with policy Y.

Sigsum logging makes it reasonable to believe a claim by adding enough
discoverability to facilitate verification.

Please refer to the
[design document](https://git.sigsum.org/sigsum/tree/doc/design.md), the
[API specification](https://git.sigsum.org/sigsum/tree/doc/api.md), and the
[log prototype](https://git.sigsum.org/sigsum-log-go/tree/README.md)
to learn more.

## Services
Sigsum is self-hosting all services required to function as a software project.
Each service is operated on a best-effort level that is good enough for sigsum to
rely upon.  Please report any issues to the sigsum team via chat or email.

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
