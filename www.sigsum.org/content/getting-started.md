# Getting started

This is a demo of key-usage transparency.  You will create a signing key-pair,
log a signed checksum, offline-verify a signed checksum, and detect that a
signature is available for the generated public key.

## Install

Install the [Go toolchain][].  You will need at least Go version 1.23.  If you
would like to run a few optional debug commands, also ensure that `sha256sum`,
`cut`, and `basenc` are installed on the system.

Install the following Sigsum tools:

    $ go install sigsum.org/sigsum-go/cmd/sigsum-key@v0.13.1
    $ go install sigsum.org/sigsum-go/cmd/sigsum-policy@v0.13.1
    $ go install sigsum.org/sigsum-go/cmd/sigsum-submit@v0.13.1
    $ go install sigsum.org/sigsum-go/cmd/sigsum-verify@v0.13.1
    $ go install sigsum.org/sigsum-go/cmd/sigsum-monitor@v0.13.1

`sigsum-key` will be used to generate a public key-pair.

`sigsum-policy` will be used to show information about the trusted logs and
witnesses.

`sigsum-submit` will be used to sign a checksum, submit it to a log, and collect
its proof of logging.

`sigsum-verify` will be used to verify the gathered proof of logging.

`sigsum-monitor` will be used to detect that the generated signing key was used
with Sigsum.

Check that the installation worked by running one of the tools with the
`--version` option:

    $ sigsum-key --version
    sigsum-key (sigsum-go module) v0.13.1

[Go toolchain]: https://go.dev/doc/install

## Decide which trust policy to use

Transparency log solutions depend on [trust policies][] being correctly configured
in user software and monitors.  Not having a trust policy would be similar to
not having a public key for digital signatures.

The Sigsum tools allow you to specify which policy to use by giving either a
policy file or a policy name.  Here we will use a test policy that is built into
Sigsum's tooling under the name `sigsum-test1-2025`.

    $ sigsum-policy show sigsum-test1-2025
    log 4644af2abd40f4895a003bca350f9d5912ab301a49c77f13e5b6d905c20a5fe6 https://test.sigsum.org/barreleye

    witness poc.sigsum.org/nisse         1c25f8a44c635457e2e391d1efbca7d4c2951a0aef06225a881e46b98962ac6c
    witness rgdd.se/poc-witness          28c92a5a3a054d317c86fc2eeb6a7ab2054d6217100d0be67ded5b74323c5806
    witness witness1.smartit.nu/witness1 f4855a0f46e8a3e23bb40faf260ee57ab8a18249fa402f2ca2d28a60e1a3130e

    group quorum-rule 2 poc.sigsum.org/nisse rgdd.se/poc-witness witness1.smartit.nu/witness1
    quorum quorum-rule

The first line declares a Sigsum log, its public key, and its API URL.  This is
required to interact with a log.

The next three lines declare witnesses and their public keys.  Witnesses
verify cryptographically that logs only append new entries.  This helps you
know that you see the same logs as everyone else.

The final two lines define a quorum rule saying that at least two witnesses must have
verified that the log is append-only in order for us to trust it.

[trust policies]: https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/policy.md

## Generate a signing key-pair

All signatures in the Sigsum system use Ed25519.  Create a new signing key-pair:

    $ sigsum-key generate -o submit-key

You should see that the files `submit-key` and `submit-key.pub` were created.
These files follow the SSH key-file format.

Try listing the public-key hash:

    $ sigsum-key to-hash -k submit-key.pub
    cd53cb536660a52a95f0a46d822612b71b26bcfc1831e4bec1e55b14af9baa93

Now that we decided on a trust policy and generated a signing key-pair we can
start using Sigsum.

## Start the monitor

A monitor downloads signed checksums from the logs listed in our trust policy.

Start the monitor and print all signed checksums for your public key:

    $ sigsum-monitor --interval 10s -P sigsum-test1-2025 submit-key.pub

Since you have not signed and logged any checksums yet, only debug
output on the form `New <log> leaves, count 0, total processed <N>` is
to be expected.

Leave the monitor running in a separate terminal for now.  We will come back to
it later.

## Log a signed checksum

Let's create a hello-world script and get its checksum signed and logged.

Create `hello.py`:

    $ cat << EOF > hello.py
    #!/usr/bin/env python3
    
    print("Hello, world!")
    EOF

We will sign and submit a checksum of this file.  If you
would like to compute the same checksum manually for debugging purposes only
(optional), apply SHA256 twice in a row:

    $ sha256sum hello.py | cut -d' ' -f1 | basenc --base16 -d | sha256sum
    7138d30e618745ee20d3e09b81ca45cfbf3a7db0eb526557a04d34e2ef2a5039

Sign and submit for logging using the key generated earlier:

    $ sigsum-submit -P sigsum-test1-2025 -k submit-key hello.py
    2025/12/12 16:15:35 [INFO] Found builtin policy '"sigsum-test1-2025"'
    2025/12/12 16:15:35 [INFO] Attempting to submit checksum#1 to log: https://test.sigsum.org/barreleye

It takes around 10 seconds to get back a proof of logging that satisfies the
`sigsum-test1-2025` policy.  Expect a file named `hello.py.proof` to appear with
the proof encoded as plaintext.

## Verify the proof of logging

Verifying a proof of logging is like verifying a signature.  No outbound
network connections are needed. Verify:

    $ sigsum-verify -k submit-key.pub -P sigsum-test1-2025 hello.py.proof <hello.py
    [INFO] Found builtin policy '"sigsum-test1-2025"'

No more output is expected if all went well and the exit code is zero:

	$ echo $?
	0

Try changing `hello.py` and verify again.  Verification should fail.
You can also try failing the verification by removing the witness
`cosignature` lines in `hello.py.proof`, or changing one of the log's
`node_hash` lines.

## Detect the signed checksum

Now head over to the monitor we set up to run earlier.  You should see that a new
entry has been printed:

    index 1292 keyhash cd53cb536660a52a95f0a46d822612b71b26bcfc1831e4bec1e55b14af9baa93 checksum 7138d30e618745ee20d3e09b81ca45cfbf3a7db0eb526557a04d34e2ef2a5039

This is indeed the public key-hash we listed earlier as well as the checksum
we manually computed for `hello.py`.  (Your output should match the output of
your invocation of `sigsum-key to-hash`, not this example.) The signature is not
shown in the output since the monitor already verified it.

## Debrief

You successfully logged and verified a signed checksum for a trust policy of
your choice.  You also detected that your signing key was used with Sigsum by
running a monitor that printed the event.

For security, you depended on:

  - Two witnesses to verify that the log shows the same signed checksums to
    everyone
  - Your monitor to be up-and-running (or that it eventually makes a correct run
    somewhere)
  - The integrity and effective access restrictions of the chosen trust policy

Ready to move beyond testing?  Either bring your own policy or take a look at
`sigsum-policy list` and the `sigsum-generic-*` policy.  The latter is a sane
default [maintained][] by the Sigsum project.

[maintained]: https://git.glasklar.is/sigsum/project/documentation/-/blob/main/policy-maintenance.md
