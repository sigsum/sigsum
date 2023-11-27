# Services

This page lists services that the Sigsum project are hosting.

## Log servers

Two test logs are being operated.  Public keys and URLs in policy-file format:

    log 80d115da542b67bb7a15448f50fe951e59cfa9db73807bfc12a2a4a981ba251e https://ghost-shrimp.sigsum.org
    log 154f49976b59ff09a123675f58cb3e346e0455753c3c3b15d465dcb4f6512b0b https://poc.sigsum.org/jellyfish

`jellyfish` is a proof-of-concept log that follows the main branch of the log-go
repository.  It is intended for testing and development.  No rate-limits are
enforced.  The log may be wiped at any time.

`ghost-shrimp` is a test log that follows the latest log server releases.
Deployment of a log with stronger commitment on availability and documented
security practises is coming sometime soon.

## Witnesses

Two test witnesses are operated and hooked-up to the proof-of-concept
`jellyfish` log.

Names and public keys in policy-file format:

    witness poc.sigsum.org/nisse 1c25f8a44c635457e2e391d1efbca7d4c2951a0aef06225a881e46b98962ac6c
    witness rgdd.se/poc-witness  28c92a5a3a054d317c86fc2eeb6a7ab2054d6217100d0be67ded5b74323c5806

A production witness that cosigns Sigsum logs as well as other logs will be
deployed in the future.
