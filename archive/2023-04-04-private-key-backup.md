# Private key backup

In Sigsum, a log's identity is its key. We can have a primary node and
one or more secondary nodes, with the intention that if the primary
node goes down, even in a catastrophic event (e.g., if the building
where it is located burns down), then one of the secondaries can be
promoted to primary, and the log can continue operating after only a
brief downtime.

But for this to work, the promoted secondary needs a copy of the log's
private key, previously used by the old, and now destroyed, primary
node.

# Hardware keys

To reduce risk of key exposure, we'd like to keep private keys in a
hardware device, e.g., a Tillitis key or a Yubico HSM (hardware
security module). The idea is that the device provides a signing
oracle, but no easy means to extract the private key. An attacker with
temporary physical or online access to the device can use it to create
signatures, but only as long as the attacker's access lasts.

Some ways of key extraction will always be possible, but ideally, the
easiest way should involve taking the device to the attacker's well
equipped lab and then spend a week or two taking it apart under an
electron microscope.

So how can we make backups, effectively cloning the device, without
also enabling key export on temporary access?

# Export only at key generation

One way may be to require that all setup of backups is done at key
generation time.

Assume we have a device that includes a key pair capable of encryption
(e.g., some variant of diffie-hellman based on curve25519), tied to a
builtin hard-to-extract secret, and a secure randomness generator.

Then it could have a function that takes as input n public keys (one
of them typically being its own), generates a random signing key, and
encrypts that signing key to each of the given public keys. It then
outputs the encrypted or "wrapped" signing key, and the corresponding
public key for verifying the signatures.

Now, anyone holding one of the corresponding private keys for the
wrapped key can use it to create signatures.

To use this for a Sigsum log, one would get as many devices as one
thinks will be needed for redundancy over the log instance's life
time. In some preferably secure and offline environment, collect the
public keys of each device, pass them to one of the devices for the
above key generation function. Keep the wrapped key in a safe backup
place (it doesn't have to be strictly confidential). Install one of
the devices at the primary node, and lock up the others at secure
offsite locations, for use whenever we need to promote one of the
seconday nodes.

# Later export?

Later reexport of the secret key is rather shaky. If the device is to
ever reencrypt the secret signing key to one more public key, it must
enforce some kind of certification that can distinguish an authorized
public key for a new backup device, from any random keypair generated
by the attacker.

It might make sense, e.g, to allow reexport if certified by k-of-n of
the previous backup devices, but rather unclear if that can be
achieved. E.g., which key could be trusted to sign a statement saying
which keys belong to those n previously authorized backup devices?

In addition, it would make sense to require that the signature on any
certification of a new backup device is publicly logged in some
specified Sigsum log.
