# The Sigsum Project
Sigsum is a free and open source project that brings transparency logging to
**sig**ned check**sum**s.  Logging _sigsums_ and not a more concrete type like
_certificates_ keep the overall design simple and generally useful.

&#10004; Minimalistic design that simplifies log operations and usage\
&#10004; Centralised log operations but distributed trust assumptions\
&#10004; Discoverability of statements for data of your choice

A minimal statement encodes the following claim: the data has cryptographic hash
X.  You can add additional meaning to each statement.  For example, you may use
a sigsum log to claim that
	_everyone gets the same news articles_,
	_software package X builds reproducibly_, or
	_a list of key-value pairs is maintained with policy Y_.

Sigsum logging makes it reasonable to believe your claims by adding enough
discoverability to verify them.

## Join the conversation
- IRC: \#sigsum @ oftc.net
- Matrix: [#sigsum:matrix.org](https://app.element.io/#/room/#sigsum:matrix.org)

## Useful links
- Go implementation of a sigsum log: [sigsum-log-go](https://github.com/sigsum/sigsum-log-go)
- Python implementation of a sigsum witness: [sigsum-witness-py](https://github.com/sigsum/sigsum-witness-py)
- Design and API specifications: [documentation](https://github.com/sigsum/sigsum/tree/main/doc)
- Meeting minutes and persisted notes: [archive](https://github.com/sigsum/sigsum/tree/main/archive)
- Website
	- https://www.sigsum.org
	- https://er3n3jnvoyj2t37yngvzr35b6f4ch5mgzl3i6qlkvyhzmaxo62nlqmqd.onion
