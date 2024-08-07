# Services

This page lists services that the Sigsum project are hosting.

## Log servers

One test log is being operated.  Public key and URL in policy-file format:

    log 154f49976b59ff09a123675f58cb3e346e0455753c3c3b15d465dcb4f6512b0b https://poc.sigsum.org/jellyfish

Note that `jellyfish` is a proof-of-concept log that follows the main branch of
the log-go repository.  It is intended for testing and development until a
stable log is deployed.  No rate-limits are enforced.

## Witnesses

Two test witnesses are operated and hooked-up to the proof-of-concept
`jellyfish` log.

Names and public keys in policy-file format:

    witness poc.sigsum.org/nisse 1c25f8a44c635457e2e391d1efbca7d4c2951a0aef06225a881e46b98962ac6c
    witness rgdd.se/poc-witness  28c92a5a3a054d317c86fc2eeb6a7ab2054d6217100d0be67ded5b74323c5806

A production witness that cosigns Sigsum logs as well as other logs will be
deployed in the future.
