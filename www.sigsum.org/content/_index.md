Sigsum is a building block that brings transparency to the way in which signing
keys are used.  No signature that an end-user accepts as valid goes unnoticed
because it is included in a public log.

> Wait a second, I did not sign anything in the middle of the night.  My key
> must be compromised.

The ability to say with confidence what signatures exist further makes Sigsum a
useful _building block_.  For example, to convince the users of some software
that there are no secret releases with backdoors, the maintainers can ensure
everyone observes the same reproducible source code signed with Sigsum.

> You claimed each release would be reproducible.  I located the source and its
> build instructions when signed checksum 7d86...7730 appeared in the logs.  I
> don't get a bit-for-bit identical output.  Why?

For security, Sigsum's transparency has been designed to resist a powerful
attacker that controls:

  - The signer's secret key and infrastructure
  - The log's secret key and infrastructure
  - A threshold of so called witnesses that keep the log honest

Why not give it a try?  There is a [getting started](/getting-started) demo on
key-usage transparency.
