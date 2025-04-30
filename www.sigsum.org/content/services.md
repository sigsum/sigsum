# Services

This page lists services related to the Sigsum project.

## Log servers

### seasalp -- stable log

One stable log is being operated by [Glasklar
Teknik](https://www.glasklarteknik.se/).  Public key and URL in [policy-file
format][]:

    log 0ec7e16843119b120377a73913ac6acbc2d03d82432e2c36b841b09a95841f25 https://seasalp.glasklar.is

[policy-file format]: https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/policy.md

### Test logs

Please note that the test logs are following the main branch of the
[log-go](https://git.glasklar.is/sigsum/core/log-go) repository.

They are intended for test and development only.
Also note that no [rate limiting](https://git.glasklar.is/sigsum/project/documentation/-/blob/main/log.md#4--rate-limiting)
is being enforced for the test logs.

#### barreleye -- test log

Test log `barreleye`.

Public key and HTTPS URL in [policy-file format][]:

    log 4644af2abd40f4895a003bca350f9d5912ab301a49c77f13e5b6d905c20a5fe6 https://test.sigsum.org/barreleye

Public key and onion URL:

    log 4644af2abd40f4895a003bca350f9d5912ab301a49c77f13e5b6d905c20a5fe6 http://eigepek6nl26cvk5sziwpyqkocazasy3dmibe3nc77f7s2awaijfyoyd.onion/barreleye

### Historic logs

The test log `jellyfish` with public key
`154f49976b59ff09a123675f58cb3e346e0455753c3c3b15d465dcb4f6512b0b` was
decommissioned on April 30, 2025.

## Witnesses

### Stable witnesses

A few stable witnesses are being operated. Names and public keys in policy-file format:

    witness witness.glasklar.is b2106db9065ec97f25e09c18839216751a6e26d8ed8b41e485a563d3d1498536
    witness witness.mullvad.net 15d6d0141543247b74bab3c1076372d9c894f619c376d64b29aa312cc00f61ad

See Glasklar's [witnessing][] repo for information on how `witness.glasklar.is` is being operated.

[witnessing]: https://git.glasklar.is/glasklar/services/witnessing

### Test witnesses

Names and public keys in policy-file format:

    witness poc.sigsum.org/nisse         1c25f8a44c635457e2e391d1efbca7d4c2951a0aef06225a881e46b98962ac6c
    witness rgdd.se/poc-witness          28c92a5a3a054d317c86fc2eeb6a7ab2054d6217100d0be67ded5b74323c5806
    witness witness1.smartit.nu/witness1 f4855a0f46e8a3e23bb40faf260ee57ab8a18249fa402f2ca2d28a60e1a3130e
