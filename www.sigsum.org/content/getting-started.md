# Getting started

This is a demo of key-usage transparency.  You will create a signing key-pair,
log a signed checksum, offline-verify a signed checksum, and detect that a
signature is available for the generated public key.

## Install

Install the [Go toolchain][].  You will need at least Go version 1.22.  If you
would like to run a few optional debug commands, also ensure that `sha256sum`,
`cut`, and `base16` are installed on the system.

Install the following Sigsum tools:

    $ go install sigsum.org/sigsum-go/cmd/sigsum-key@v0.9.1
    $ go install sigsum.org/sigsum-go/cmd/sigsum-submit@v0.9.1
    $ go install sigsum.org/sigsum-go/cmd/sigsum-verify@v0.9.1
    $ go install sigsum.org/sigsum-go/cmd/sigsum-monitor@v0.9.1

`sigsum-key` will be used to generate a public key-pair.

`sigsum-submit` will be used to sign a checksum, submit it to a log, and collect
its proof of logging.

`sigsum-verify` will be used to verify the gathered proof of logging.

`sigsum-monitor` will be used to detect that the generated signing key was used
with Sigsum.

[Go toolchain]: https://go.dev/doc/install

## Create a trust policy

Transparency log solutions depend on trust policies being correctly configured
in user software and monitors.  Not having a trust policy would be similar to
not having a public key for digital signatures.

Create `~/.config/sigsum/trust_policy`:

    log 154f49976b59ff09a123675f58cb3e346e0455753c3c3b15d465dcb4f6512b0b https://poc.sigsum.org/jellyfish
    
    witness poc.sigsum.org/nisse 1c25f8a44c635457e2e391d1efbca7d4c2951a0aef06225a881e46b98962ac6c
    witness rgdd.se/poc-witness  28c92a5a3a054d317c86fc2eeb6a7ab2054d6217100d0be67ded5b74323c5806
    
    group  demo-quorum-rule any poc.sigsum.org/nisse rgdd.se/poc-witness
    quorum demo-quorum-rule

The first line declares a Sigsum log, it's public key, and API URL.  This is
needed to interact with a log.

The following two lines declare witnesses and their public keys.  Witnesses
verify cryptographically that the logs only append new entries.  This helps you
know you see the same logs as everyone else.

The final two lines define a quorum rule saying that any of the two witness must have
verified that the log is append-only in order for us to trust it.  This results
in a threat model where we can detect issues like a misbehaving log or a
compromise of our signing-key as long as a quorum of witnesses are benign.

## Generate a signing key-pair

All signatures in the Sigsum system use Ed25519.  Create a new signing key-pair:

    $ sigsum-key gen -o submit-key

You should see that `submit-key` and `submit-key.pub` were created.  These files
follow the SSH key-file format.

Try listing the public-key hash:

    $ sigsum-key hash -k submit-key.pub
    cd53cb536660a52a95f0a46d822612b71b26bcfc1831e4bec1e55b14af9baa93

Now that we have a trust policy and a signing key-pair we can start using
Sigsum.

## Start the monitor

A monitor downloads signed checksums from the logs listed in our trust policy.

Start the monitor and print all signed checksums for your public key:

    $ sigsum-monitor --interval 10s -p ~/.config/sigsum/trust_policy submit-key.pub

We have not signed and logged any checksum.  Therefore, no checksum output is
expected yet.

Leave the monitor running in a separate terminal for now.  We will come back to
it later.

## Log a signed checksum

Let's create a hello-world script and get it's checksum signed and logged.

Create `hello.py`:

    $ cat << EOF > hello.py
    #!/usr/bin/env python3
    
    print("Hello, world!")
    EOF

What we will sign and submit for logging is a checksum of this file.  If you
would like to compute the same checksum manually for debugging purposes only
(optional), apply SHA256 twice in a row:

    $ sha256sum hello.py | cut -d' ' -f1 | base16 -d | sha256sum
    7138d30e618745ee20d3e09b81ca45cfbf3a7db0eb526557a04d34e2ef2a5039

Sign and submit for logging using the key generated earlier:

    $ sigsum-submit -p ~/.config/sigsum/trust_policy -k submit-key hello.py
    2023/11/25 16:32:40 [INFO] Attempting submit to log: https://poc.sigsum.org/jellyfis 

It might take ~10s or so to get the signed checksum merged into the log so that
the specified trust policy is satisfied.  You should see the proof of logging
stored as plaintext in `hello.py.proof`.

## Verify the proof of logging

Verifying a proof of logging is like verifying a signature.  No outbound
network connections are needed:

    $ sigsum-verify -k submit-key.pub -p ~/.config/sigsum/trust_policy hello.py.proof <hello.py

Silence is a good sign, no output is expected if all went well.

Try changing `hello.py` and run again.  Verification should fail.  You can
also try failing the verification by dropping the witness cosignature lines or changing
one of the log's node hashes in `hello.py.proof`.

## Detect the signed checksum

Head over to the monitor we set up to run earlier.  You should see that a new
entry has been printed:

    index 1292 keyhash cd53cb536660a52a95f0a46d822612b71b26bcfc1831e4bec1e55b14af9baa93 checksum 7138d30e618745ee20d3e09b81ca45cfbf3a7db0eb526557a04d34e2ef2a5039

This is indeed the public key-hash we listed earlier, as well as the checksum
we manually computed for `hello.py`.  The signature is not shown in the output
because the monitor already verified it.

## Debrief

You successfully logged and verified a signed checksum for a trust policy of
your choice.  You also detected that your signing key was used with Sigsum by
running a monitor that printed the event.

For security, you depended on:

  - Two witnesses to verify that the log shows the same signed checksums to
    everyone
  - Your monitor to be up-and-running (or that it eventually makes a correct run
    somewhere)
  - The integrity and effective access restrictions of the trust-policy file
