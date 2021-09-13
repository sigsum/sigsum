# The Sigsum Project
Sigsum is a free and open source project that brings transparency logging to
**sig**ned check**sum**s.  Logging _sigsums_ and not a more concrete type like
_certificates_ keeps the overall design simple and generally useful.

&#10004; Minimalistic design that simplifies log operations and usage\
&#10004; Centralised log operations but distributed trust assumptions\
&#10004; Discoverability of statements for data of your choice

A minimal statement encodes the following claim: the data has cryptographic hash
X.  You can add additional meaning to each statement.  For example, you may use
a sigsum log to claim that

- everyone gets the same news articles,
- software package X builds reproducibly, or
- a list of key-value pairs is maintained with policy Y.

Sigsum logging makes it reasonable to believe your claims by adding enough
discoverability to verify them.

## Join the conversation
- IRC: \#sigsum @ [OFTC.net](https://oftc.net/)
- Matrix: [#sigsum:matrix.org](https://app.element.io/#/room/#sigsum:matrix.org)

## Useful links
- Go implementation of a sigsum log: [sigsum-log-go](https://git.sigsum.org/sigsum-log-go)
- Python implementation of a sigsum witness: [sigsum-witness-py](https://git.sigsum.org/sigsum-witness-py)
- Design and API specifications: [documentation](https://git.sigsum.org/sigsum/tree/doc)
- Meeting minutes and persisted notes: [archive](https://git.sigsum.org/sigsum/tree/archive)
- Website
	- https://www.sigsum.org/
	- https://er3n3jnvoyj2t37yngvzr35b6f4ch5mgzl3i6qlkvyhzmaxo62nlqmqd.onion/

## Sponsors
- [Mullvad VPN](https://mullvad.net/), financial sponsor
- [DFRI](https://www.dfri.se/), mailing list sponsor
