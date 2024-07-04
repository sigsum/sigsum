Sigsum brings transparency to the way in which signing keys are used.  No
signature that an end-user accepts as valid goes unnoticed because it is
included in a public log.

> Wait a second, I did not sign anything in the middle of the night.  My key
> must be compromised.

The ability to say with confidence what signatures exist makes Sigsum a useful
_building block_.  For example, consider an open-source software project that
claims there are no secret releases.  By incorporating the use of Sigsum, any
release not listed on the project website can be detected.

> You claimed each release would be listed on the project website.  Where is the
> release for signature 7d86...7730 that appeared in the public log?  As you can
> see it was created using your release key.

For security, Sigsum's transparency has been designed to resist a powerful
attacker that controls:

  - The signer's secret key and distribution infrastructure
  - The public log, including its hosting infrastructure and secret key
  - A threshold of so called witnesses that call out if a log fails

Why not give Sigsum a try?  There is a [getting started](/getting-started) demo
on key-usage transparency.
