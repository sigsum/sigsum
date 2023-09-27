# Would Mandos help protecting the passphrase for signing operations?

2023-09-27, Linus

The question of how to protect the passphrase needed to get a
signature from a YubiHSM was being discussed in Stockholm last week,
by Rasmus, Nisse and Linus. One idea was that Mandos might be useful.

I think that Mandos might have some value for a witness running on a
small device, like an RPI, in an environment where it might get
physically stolen and carried away.

## Reasoning

  - https://www.recompile.se/mandos
  - motivation: protecting the passphrase for key signing, considering
    both witnesses and log servers
  - mandos design: there's one (or more, for availability) mandos
    servers, handing out a passphrase (encrypted in a pgp key) to
    clients authenticated with x509 client certs, over TLS, iff the
    client wasn't offline (checked using ssh-keyscan by default) for
    too long
  - benefit: theft of the physical computer does not result in access
    to a signing oracle
  - questions: does mandos server have to be local LAN? how is that
    being enforced? A: IPv6 link-local addresses and Zeroconf
  - integration alt. 1: store the key signing passphrase in a file on
    an encrypted device and let cryptsetup start mandos plugin-runner
    by means of the crypttab(5); optionally unmount encrypted file
    system once the passphrase has been read by ssh-agent (NOTE: would
    need new mount whenever the ssh-agent is being restarted)
  - integration alt. 2: use mandos-client directly for retrieving the
    (encrypted) key signing passphrase from a mandos server, when
    adding the key to ssh-agent from a systemd service unit
  - security benefits: both alternatives protect against a scenario
    where the physical machine is being seized and separated from the
    mandos server for more than, say, fifteen minutes
  - conclusion: not worth the hassle for log servers in data centres;
    possibly interesting for smaller witnesses in less secure
    environments
