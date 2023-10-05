# Setting up a prototype witness (Go)

**Warning:** prototype instructions, not robust enough for production usage.

## Install

Install Go version 1.19 or later, then:

    $ go install filippo.io/litetlog/cmd/litewitness@18cd17e869aaf4fc96e4591aa3102a4ce2a96d69
    $ go install filippo.io/litetlog/cmd/witnessctl@18cd17e869aaf4fc96e4591aa3102a4ce2a96d69
    $ go install sigsum.org/sigsum-go/cmd/sigsum-key@v0.6.0

You will also need to install SSH agent for key management:

    # apt install openssh-client

## Create a working directory

    $ mkdir $HOME/witness
    $ cd $HOME/witness

It is assumed that all following commands are run in this directory.

## Generate witness signing key

    $ sigsum-key gen -o key
    $ cat key.pub
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICjJKlo6BU0xfIb8LutqerIFTWIXEA0L5n3tW3QyPFgG sigsum key

## Configure a new log to witness

Configure the log's public key in hex:

    $ witnessctl add-sigsum-log -db state.db -key 154f49976b59ff09a123675f58cb3e346e0455753c3c3b15d465dcb4f6512b0b
    2023/10/05 15:05:55 Added Sigsum log with public key 154f49976b59ff09a123675f58cb3e346e0455753c3c3b15d465dcb4f6512b0b.
    $ witnessctl list-logs -db state.db
    {"origin":"sigsum.org/v1/tree/c9e525b98f412ede185ff2ac5abf70920a2e63a6ae31c88b1138b85de328706b","size":0,"root_hash":"47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=","keys":["FU9Jl2tZ/wmhI2dfWMs+NG4EVXU8PDsV1GXctPZRKws="]}

Now the witness is configured with a public key and an empty Merkle tree for
the Sigsum project's [poc.sigsum.org/jellyfish][] log.

[poc.sigsum.org/jellyfish]: https://www.sigsum.org/services/

## Run the witness

Add the signing key to SSH agent:

    $ eval $(ssh-agent -s)
    Agent pid 1519723
    $ echo $SSH_AUTH_SOCK
    /tmp/ssh-onJWJk5JPIzx/agent.1519722
    $ ssh-add key
    Identity added: key (key)
    $ KEY_GRIP=$(sigsum-key hash -k key.pub)

Run the witness:

    $ litewitness -db state.db -key $KEY_GRIP -ssh-agent $SSH_AUTH_SOCK -listen 0.0.0.0:2009

Try requesting the size of jellyfish's Merkle tree from the witness' point of view.

    $ log_id=$(echo 154f49976b59ff09a123675f58cb3e346e0455753c3c3b15d465dcb4f6512b0b | sigsum-key hex-to-pub | sigsum-key hash)
    $ curl http://127.0.0.1:2009/sigsum/v1/get-tree-size/$log_id
    size=0

Or remotely, since we're listening on all possible IP addresses:

    $ curl http://witness.rgdd.se:2009/sigsum/v1/get-tree-size/$log_id
    size=0

## Configure more logs

While the witness is running, you can configure more logs.

    $ witnessctl add-sigsum-log -db state.db -key 80d115da542b67bb7a15448f50fe951e59cfa9db73807bfc12a2a4a981ba251e
    2023/10/05 16:05:33 Added Sigsum log with public key 80d115da542b67bb7a15448f50fe951e59cfa9db73807bfc12a2a4a981ba251e.
    $ witnessctl list-logs -db state.db
    {"origin":"sigsum.org/v1/tree/5955bfe2150ee2e667c4e418228f9ee89835d6990248aad9b39c0e2120c1b022","size":0,"root_hash":"47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=","keys":["gNEV2lQrZ7t6FUSPUP6VHlnPqdtzgHv8EqKkqYG6JR4="]}
    {"origin":"sigsum.org/v1/tree/c9e525b98f412ede185ff2ac5abf70920a2e63a6ae31c88b1138b85de328706b","size":0,"root_hash":"47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=","keys":["FU9Jl2tZ/wmhI2dfWMs+NG4EVXU8PDsV1GXctPZRKws="]}

Now the witness is also configured with a public key and an empty Merkle tree
for the Sigsum project's [ghost-shrimp.sigsum.org][] log.  Try poking:

    $ log_id=$(echo 80d115da542b67bb7a15448f50fe951e59cfa9db73807bfc12a2a4a981ba251e | sigsum-key hex-to-pub | sigsum-key hash)
    $ curl http://witness.rgdd.se:2009/sigsum/v1/get-tree-size/$log_id
    size=0

[ghost-shrimp.sigsum.org]: https://www.sigsum.org/services/

## Ask logs to configure your witness

Provide all log operators with your witness URL and public key.

  - Public key in hex: `sigsum-key hex -k key.pub`
  - Witness URL: if you listen on `http://example.com:1234`, then this
    implementation gives you URL `http://example.com:1234/sigsum/v1`.

## Remarks

  - A future note will show how to configure the witness with a bastion host,
    which means you will be able to run without a public-facing IP address.
  - If you do decide to run a witness without a bastion host as above, you
    should probably setup a reverse HTTPS proxy.  Not in-scope of this note.
  - The checked-out commit in the litetlog repository implements §3.1 and §3.2
    of [witness.md][], an interim version of the witness protocol that an
    [ongoing proposal][] will update sometime soon.  So, if you setup a
    prototype witness, be ready to also upgrade to a new commit/tag soon.

[witness.md]: https://git.glasklar.is/sigsum/project/documentation/-/blob/37854e39e210abb320cd9fd2d911478e00452aae/witness.md
[ongoing proposal]: https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/46
