Sigsum is a building block that brings transparency to the way in which signing
keys are used.  No signature that an end-user accepts as valid goes unnoticed
because it is included in a public log.

> Wait a second, I did not sign anything in the middle of the night.  My key
> must be compromised.

The ability to say with confidence what signatures exist allows for further
layering on-top of Sigsum.  For example, a free and open-source software project
could commit to having a release page with all software artifacts.  To convince
users that there are no secret releases with backdoors, they can ensure the
builds are reproducible and Sigsum logged so that an independent monitor can
verify their claims.

> You claimed each release would be reproducible.  I located the source and its
> build instructions when checksum 7d86...7730 appeared in the logs.  I don't
> get a bit-for-bit identical output though.  Why?

For security, Sigsum's transparency has been designed to resist a powerful
attacker that controls:

  - The signer's secret key and infrastructure
  - The log's secret key and infrastructure
  - A quorum of so-called witnesses that cosign the log

Why not give it a try?  There is a [getting started](/getting-started) demo on
key-usage transparency.
