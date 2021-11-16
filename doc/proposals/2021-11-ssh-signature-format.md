Should Sigsum adopt the signature format used by SSH?

The signature format used by Sigsum is close to what is used by
SSH. If we were to change our formats to match SSH's format our
Signers, Logs and Witnesses could benefit from existing SSH tooling,
most notably ssh-agent and its support for PKCS#11 providers.

This proposal suggests that we change what we're signing both for tree
heads and signer's statements (in tree leaves) to use SSH's signing
format with the hash being a hash over our current data structures
(struct tree_head and struct statment).

This proposal notably does not suggest any changes to Sigsum's lack of
crypto agility, i.e. whether we should support signing with any other
key types than ed25519, most notably RSA keys or NIST curves. Same is
true for hash algorithms, ie whether anything else than sha256 for
hashing the message should be supported.


# What do we sign?

https://git.sigsum.org/sigsum/tree/doc/api.md

## Tree leaves

Tree leaves contain a signer's statement, a signature and a key hash.

Statements are signed by Signers.
Statements are verified by Verifiers and Monitors.

    u64 shard_hint;
    u8 checksum[32];


## Tree heads

Tree heads are signed by Logs and Witnesses.
Tree heads are verified verified by Verifiers, Witnesses and Monitors.

	u64 timestamp;
	u64 tree_size;
	u8 root_hash[32];
	u8 key_hash[32];


# What does ssh-agent sign?

https://github.com/openssh/openssh-portable/blob/master/PROTOCOL.sshsig

    #define MAGIC_PREAMBLE "SSHSIG"

    byte[6]   MAGIC_PREAMBLE
    string    namespace
    string    reserved
    string    hash_algorithm
    string    H(message)

The string data type is represented as a uint32 in network byte order
followed by that many octets of data (RFC4251, section 5).

## The namespace field

A context string is what in the SSH signature format documentation is
called namespace. Requiring a context string that is unique per
"interpretation domain" stops cross-protocol attacks where the same
key is used for multiple applications.

Sigsum would use statement-v0@sigsum.org and treehead-v0@sigsum.org
for namespace.

## The reserved field

Sigsum would ignore this field.

## The hash_algorithm field

Sigsum would use "sha256".

## The H(message) field

This is the SHA256 or SHA512 hash of the message to be signed.

Sigsum would use sha256(struct tree_head) and sha256(struct
statement).


# SSH wire format

Header = "-----BEGIN SSH SIGNATURE-----"
Data = Base64-encoded data described below
Footer = "-----END SSH SIGNATURE-----"

The data part is first encoded as a string (uint32 + data) and then
Base64-encoded, broken up with newlines every 76:th octet.

Data:

    #define MAGIC_PREAMBLE "SSHSIG"
    #define SIG_VERSION    0x01

    byte[6]   MAGIC_PREAMBLE
    uint32    SIG_VERSION
    string    publickey
    string    namespace
    string    reserved
    string    hash_algorithm
    string    signature

The publickey field contains the public key corresponding to the
secret key making the signature, serialised according to SSH
serialisation rules. Note that the signature algorithm is NOT encoded
in the publickey field and need to be communicated elsewhere.

The namespace field is the same as above (section "What does ssh-agent sign?").

The hash_algorithm field is one of "sha256" and "sha512".

The signature field contains the signature over what's described above
(section "What does ssh-agent sign?") using the private key
corresponding to the publickey field, encoded according to SSH
encoding rules.

# Related questions

- Adding a length field, even indirectly through a type field
  determining length, opens up for a class of attacks iff the data is
  controlled by the attacker _and_ needs to be parsed. Note that
  verifying a signature requires the message to be serialised, not
  necessarily parsed.

- hash algorithms: sha256, sha512
  currently: sha256

- RSA, yes no?
  - currently: no, signature fields are fixed at 64 bytes
  - variable length signature fields would be necessary, or using a
    fixed sized field of 512 bytes (for allowing keys up to 4096 bits
    in size)

- More curves, ie NIST?
