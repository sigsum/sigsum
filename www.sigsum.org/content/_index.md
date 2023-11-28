Sigsum logging brings transparency to signed checksums.  This makes it possible
to detect malicious and unintended key-usage.  In other words, no signature
accepted by an end-user goes unnoticed.

> A new signature made with my key was just logged.
> Was that signature expected?

Specific use-cases can be implemented on-top of the minimal building block that
Sigsum provides.  Examples include transparency for executable binaries, TPM
quotes, and onion address rulesets.

> Everyone gets the same binaries.
> Signed binary checksums become public in Sigsum logs.
> Each binary is locatable on a separate release page.
> An independent monitor can verify these claims.

Sigsum is designed to be secure against a powerful attacker that controls:

  - The signer's secret key and infrastructure
  - The log's secret key and infrastructure
  - A threshold of so-called witnesses that cosign the log

The Sigsum design aims for simplicity, both with regards to operations
and end-user verification.
