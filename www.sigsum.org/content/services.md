# Services

This page lists services that the Sigsum project are hosting.

## Log servers

### seasalp

One stable log is being operated by [Glasklar
Teknik](https://www.glasklarteknik.se/).  Public key and URL in [policy-file
format][]:

    log 0ec7e16843119b120377a73913ac6acbc2d03d82432e2c36b841b09a95841f25 https://seasalp.glasklar.is

### jellyfish

One test log is also being operated.  Public key and URL in [policy-file format][]:

    log 154f49976b59ff09a123675f58cb3e346e0455753c3c3b15d465dcb4f6512b0b https://poc.sigsum.org/jellyfish

Please note that `jellyfish` is a test log following the main branch of the
[log-go](https://git.glasklar.is/sigsum/core/log-go) repository.
In other words, it is intended for testing and development only.
Also note that no
[rate limiting](https://git.glasklar.is/sigsum/project/documentation/-/blob/main/log.md#4--rate-limiting)
is being enforced for `jellyfish`.

[policy-file format]: https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/policy.md

## Witnesses

Three test witnesses are being operated.

Names and public keys in policy-file format:

    witness poc.sigsum.org/nisse         1c25f8a44c635457e2e391d1efbca7d4c2951a0aef06225a881e46b98962ac6c
    witness rgdd.se/poc-witness          28c92a5a3a054d317c86fc2eeb6a7ab2054d6217100d0be67ded5b74323c5806
    witness witness1.smartit.nu/witness1 f4855a0f46e8a3e23bb40faf260ee57ab8a18249fa402f2ca2d28a60e1a3130e
