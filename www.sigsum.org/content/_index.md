Detecting whether a signing key has been compromised is hard.  For example, how
would the key's owner learn that a user somewhere in the world downloaded a
maliciously created signature?

Sigsum is a building block that brings transparency to the way in which signing
keys are used.  Think of it as social media for signing key operations, expect
that the social media platform is a transparency log.

> Wait a second, I did not sign anything in the middle of the night.  My key
> must be compromised.

The ability to say with confidence what valid signatures exist allows for
further layering on-top of Sigsum.  For example, a free and open-source software
project could commit to having a release page with all software artifacts.  To
convince users that there are no secret releases with backdoors, they can ensure
the builds are reproducible, signed, and Sigsum-logged so that a monitor can
verify this claim.

Example of detecting a secret release:

> You claimed each release would be on the release page.  Yet, there is a no
> sign of a release for checksum b5bb...944c.  As you can see it is signed by
> your key.  I found it in the logs.  Any explanation?

Example of detecting an invalid release claim:

> You claimed each release would be reproducible.  I located the source and its
> build instructions when checksum 7d86...7730 appeared in the logs.  I don't
> get a bit-for-bit identical output though.  Why?

For security, Sigsum's transparency has been designed to resist a powerful
attacker that controls:

  - The signer's secret key and infrastructure
  - The log's secret key and infrastructure
  - A threshold of so-called witnesses that cosign the log

Why not give it a try?  There is a [getting started](/getting-started) demo on
key-usage transparency.
