# Proposal

Require that Sigsum's ASCII parser uses case-insensitive hex, see [RFC 4648][].

[RFC 4648]: https://datatracker.ietf.org/doc/html/rfc4648#section-8

# Motivation

The requirement to use lower-case hex makes it harder to debug Sigsum logs on
the command line in some environments; some common library implementations
output either lower-case or upper-case hex while parsing is case-insensitive;
and even if no hex parser is available (so it must be implemented from scratch)
it is not much harder to implement as in [RFC 4648][].
