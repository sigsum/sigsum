# Hacky notes (2023-05-17)

By rgdd to see if we can get lite{bastion,witness} running.

## Configure litewitness (tee.sigsum.org)

Generate witness key:

    $ mkdir -p /home/rgdd/.config/litewitness
    $ cd /home/rgdd/.config/litewitness
    $ sigsum-key gen -o key
    $ sigsum-key hash -k key.pub > key.hash
    $ cat key.hash
    52f139f2823d04b5451e6d2c81c0bf17555b638bc399b6ba05d012222b68d2a9
    $ cat key.pub | sigsum-key hex
    73b6cbe5e3c8e679fb5967b78c59e95db2969a5c13b3423b5e69523e3d52f531

Add key to SSH agent (for the current session only):

    $ eval $(ssh-agent -s)
    $ echo $SSH_AUTH_SOCK
    $ ssh-add key

Add log keys (listed at https://www.sigsum.org/services/):

    $ witnessctl add-sigsum-log -db state -key 80d115da542b67bb7a15448f50fe951e59cfa9db73807bfc12a2a4a981ba251e
    $ witnessctl add-sigsum-log -db state -key 154f49976b59ff09a123675f58cb3e346e0455753c3c3b15d465dcb4f6512b0b
    $ witnessctl list-logs -db state
    {"origin":"sigsum.org/v1/tree/5955bfe2150ee2e667c4e418228f9ee89835d6990248aad9b39c0e2120c1b022","size":0,"root_hash":"47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=","keys":["gNEV2lQrZ7t6FUSPUP6VHlnPqdtzgHv8EqKkqYG6JR4="]}
    {"origin":"sigsum.org/v1/tree/c9e525b98f412ede185ff2ac5abf70920a2e63a6ae31c88b1138b85de328706b","size":0,"root_hash":"47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=","keys":["FU9Jl2tZ/wmhI2dfWMs+NG4EVXU8PDsV1GXctPZRKws="]}

## Run litebastion (poc.sigsum.org)

(Had some issues to get the below working, see questions below.)

    $ mkdir -p /home/rgdd/.config/litebastion
    $ litebastion\
        -backends 52f139f2823d04b5451e6d2c81c0bf17555b638bc399b6ba05d012222b68d2a9\
        -cache /home/rgdd/.config/litebastion\
        -email registry@glasklarteknik.se\
        -host bastion-prototype.sigsum.org\
        -listen 0.0.0.0:8443

Note: `-backend` is a comma-separated list of witness key hashes.

## Run litewitness (tee.sigsum.org)

In the same session that ssh-agent was started:

    $ litewitness -db state -key $(sigsum-key hash -k key.pub) -ssh-agent $SSH_AUTH_SOCK -bastion bastion-prototype.sigsum.org:8443

This should now be shown in litebastion:

    2023/05/17 17:58:57 52f139f2823d04b5451e6d2c81c0bf17555b638bc399b6ba05d012222b68d2a9: accepted new backend connection

## Configure log-go-primary (poc.sigsum.org)

Go to jellyfish's config directory (/var/sigsum/sigsum/.config/sigsum/jellyfish)

Create witness config:

    $ cat witness-config
    witness rgdd@tee.sigsum.org 73b6cbe5e3c8e679fb5967b78c59e95db2969a5c13b3423b5e69523e3d52f531 https://bastion-prototype.sigsum.org:8443/52f139f2823d04b5451e6d2c81c0bf17555b638bc399b6ba05d012222b68d2a9/sigsum/v1
    quorum none

The first hex-blob is tee's witness public key; the second hex blob is its hash.

Now specify the above policy file in the primary's config:

    ...
    [primary]
    max-range = 4096
    sth-file = "/var/sigsum/sigsum/.config/sigsum/jellyfish/sth"
    policy-file = "/var/sigsum/sigsum/.config/sigsum/jellyfish/witness-config"

(I.e., add the policy-file line.)

Hints:

  - `sudo -u sigsum vim /var/sigsum/sigsum/.config/sigsum/jellyfish/config.toml"
  - `sudo systemctl restart sigsum-log-primary@jellyfish.service`
  - `sudo systemctl status sigsum-log-primary@jellyfish.service`
  - `sudo journalctl`

Warning: the above is not persisted, ansible-pull will overwrite config.toml.

## Questions

1) Is `:443` in `-listen` option required for ACME to work?

	filippo: yes, to get an ACME certificate you need to either listen at port :80, or port :443, or have automated control over DNS records
	
2) Changing port to `:443` still doesn't seem to work if the specified hostname
is a CNAME record?

    # /home/rgdd/go/bin/litebastion -backends $(sigsum-key hash -k key.pub) -cache /home/rgdd/litewitness/acme -email registry@glasklarteknik.se -host bastion-prototype.sigsum.org -listen 0.0.0.0:443
    2023/05/17 14:42:01 http: TLS handshake error from [2001:67c:8a4:100::167]:48174: acme/autocert: host "poc.sigsum.org" not configured in HostWhitelist

Bolting in "poc.sigsum.org" with `:443` in `litebastion.go` gets this up and
running (yay!), but does however get two separately issued certificates
(bastion-prototype.sigsum.org and poc.sigsum.org).  So simply passing another
domain name in `HostPolicy` is probably not The Right Thing to do. :)

Now that I already have the certificate it works to run with `:8443` with
`-listen` though, but renewal would of course fail in ~3 months.

	filippo: ACME doesn't care about CNAMEs, what I think happened here is that something connected to litebastion calling it poc.sigsum.org because you took over port :443 and litebastion complained because it was not allowed to get a certificate for that, but you could have ignored the error and it should have worked fine when reached as bastion-prototype.sigsum.org.

Note: if :443 / :80 is required, then litebastion needs some more sparks so
that it can coexist with other web servers on the same system.  Or, another
trade-off would be to say either you have those ports available or have to
manage your own certificate.  What do you think?

	filippo: is adding a dedicated IPv4 and listening on that an option? Otherwise yeah you'll need manual certificate management but that is an increasingly legacy setup.

3) Where is the get-tree-size endpoint (Sect. 3.1 witness.md)?  We're unable to
use the litewitness without this.  (Sect. 3.3 is also not implemented.)

4) What happens if more logs are added with witnessctl while running
litewitness?  (I'm lazy and did not check the code in detail.)

	filippo: it works, litewitness has no in-process state, everything is stored in the WAL-mode SQLite database (you could even run mutliple litewitness instances off a single db, not that I recommend it)
	
## Other feedback

  - litewitness: listens on path "/sigsum/v1", but that is not specified anywhere
    in witness.md.  To be added or removed?
	    filippo: it's part of <witness URL>, if you deploy litewitness at example.com then the <witness URL> will be https://example.com/sigsum/v1
  - litebastion: we probably need a way to add new witnesses without restart?
  - lite{bastion,witness} are too silent; some debug/info output options would
    be good, and/or metrics which has already been mentioned as a TODO.
	    filippo: I generally believe in applications being silent when everything works, metrics are definitely on the TODO
  - `witnessctl list-tree-heads -db test.db -origin test`:
    `flag provided but not defined: -origin`
  - should all tools start with the same prefix "lite"?  A bit inconsistent to
    have litewitness and witnessctl.
	    filippo: I went back and forth but litewitnessctl is a mouthful, I'm justifying this as "litewitness and litebastion are the first-class components, and need a name to refer to them globally, while witnessctl is just a CLI tool"
  - litewitness: option -bastion: would it be a good idea to make this a list?
    I.e., I think it would be a good thing if a witness had multiple bastions.

(Note: I have not looked at any code in detail.)
