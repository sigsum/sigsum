Title: SSH signature format
Date: 2021-11-30
Author: Linus Nordberg, Rasmus Dahlberg
State: New

# Summary

Should Sigsum adopt the signature format used by SSH?

The signature format used by Sigsum is close to what is used by
SSH. If we were to change our formats to match SSH's format our
Signers, Logs and Witnesses could benefit from existing SSH tooling,
most notably ssh-agent and its support for PKCS#11 providers.

This proposal suggests that we change what is being signed both for
tree heads and signer's statements (in tree leaves) to use SSH's
signing format with the message being a modified version of the
current data structures: `tree_leaf.statement.shard_hint` and
`tree_head.key_hash` are being moved to the namespace field of the SSH
format.

A side effect of this change is that we start signing a hash of
submitted checksums and can store hashes instead of checksums,
lowering the risk of poisoning even further.

It notably does not suggest any changes to Sigsum's lack of crypto
agility, i.e. whether we should support signing with any other key
types than ed25519 (RSA keys, NIST curves). Same is true for hash
algorithms, ie whether anything else than sha256 for hashing the
message should be supported.


# Background

## What do we sign today?

https://git.sigsum.org/sigsum/tree/doc/api.md

### Tree leaves

Tree leaves contain a signer's statement, a signature and a key hash.

Statements are signed by Signers.
Statements are verified by End-users and Monitors.

    u64 shard_hint;
    u8 checksum[32];

### Tree heads

Tree heads are signed by Logs and Witnesses.
Tree heads are verified verified by End-users, Witnesses and Monitors.

	u64 timestamp;
	u64 tree_size;
	u8 root_hash[32];
	u8 key_hash[32];


## What does ssh-agent sign?

https://github.com/openssh/openssh-portable/blob/master/PROTOCOL.sshsig

    #define MAGIC_PREAMBLE "SSHSIG"

    byte[6]   MAGIC_PREAMBLE
    string    namespace
    string    reserved
    string    hash_algorithm
    string    H(message)

The string data type is represented as a uint32 in network byte order
followed by that many octets of data (RFC4251, section 5).

### The namespace field

A context string is what in the SSH signature format documentation is
called namespace. Requiring a context string that is unique per
"interpretation domain" stops cross-protocol attacks where the same
key is used for multiple applications.

### The reserved field

Sigsum would ignore this field.

### The hash_algorithm field

Sigsum would use "sha256".

### The H(message) field

This is the SHA256 or SHA512 hash of the message to be signed.


## SSH wire format

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

This format is not expected to be used in Sigsum but documented here
for reference.

# Proposed changes

## Use the SSH signing format for tree leaves

For signing tree leaves, use the SSH signing format with message being
the signers checksum. The namespace field is set to
"`tree_leaf:v0:<shard_hint>@sigsum.org`" and hash_algorithm to
"`sha256`".

`<shard_hint>` is the shortest decimal ASCII representation of the
shard hint integer, i.e. without any leading zeroes.

Note that the shard hint is still stored in leaves. This is necessary
for the log to be able to build the tree.

## Store hashes of checksums in tree leaves

Redefine the tree leaf type to

```
struct tree_leaf {
    u64 shard_hint;
    u8 checksum_hash[32];
    u8 signature[64];
    u8 key_hash[32];
}
```

The `struct statement` is being removed and the current `checksum`
field becomes `checksum_hash`. The contents of the `signature` field
changes according to the description in "Use the SSH signing format
for tree leaves".

As a result of storing a hash of the signer's checksum rather than the
checksum itself, the threat of log poisoning goes from unlikely to
very unlikely.

## Use the SSH signing format for tree heads

For signing tree heads, use the SSH signing format with message being
`timestamp`, `tree_size` and `root_hash` serialised as a `struct
tree_head` without the `key_hash`.  The namespace field is set to
"`tree_head:v0:<key_hash>@sigsum.org`" and hash_algorithm to
"`sha256`".

`<key_hash>` is the log's hashed public key, encoded and hashed as
described in api.md section 2.3.1, then hex-encoded.

## OpenSSH tooling examples

### Tree leaf

Example of how to sign and verify `struct tree_leaf` using
`ssh-keygen(1)`. Here the signer's checksum is 315f..edd3 and the
shard hint is 1633039200.

```
$ echo 315f5bdb76d078c43b8ac0064e4a0164612b1fce77c869345bfc94c75894edd3 | hex --decode > checksum
$ ssh-keygen -Y sign -f submitkey -n "tree_leaf:v0:1633039200@sigsum.org" checksum
Signing file checksum
Write signature to checksum.sig
$ cat allowed-signers
submitter@someorg ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAvQ1gHVpfbVfGqSXxQQDGqov025vBamkc20R2y0pymn submitter@somehost
$ ssh-keygen -Y verify -f allowed-signers -I submitter@someorg -n "tree_leaf:v0:1633039200@sigsum.org" -s checksum.sig < checksum
Good "tree_leaf:v0:1633039200@sigsum.org" signature for submitter@someorg with ED25519 key SHA256:9hYsieq70B4LtR/n8yVp2icZFZLAeOy9lLoofEDY6Hc
```

### Tree head

Example of how to sign and verify `struct tree_head` using
`ssh-keygen(1)`. Here the timestamp is 1638258159, the tree size is
4711 and the tree's root hash is b5bb..944c. The hash of the log's
public verification key is 7d86..7730.

```
$ python3 -  1638258159 4711 b5bb9d8014a0f9b1d61e21e796d78dccdf1352f23cd32812f4850b878ae4944c << EOF > data
import struct, sys
roothash = bytes.fromhex(sys.argv[3])
assert(len(roothash) == 32)
sys.stdout.buffer.write(struct.pack('!QQ', int(sys.argv[1]), int(sys.argv[2])) + roothash)
EOF
$ hd data
00000000  00 00 00 00 61 a5 d5 ef  00 00 00 00 00 00 12 67  |....a..........g|
00000010  b5 bb 9d 80 14 a0 f9 b1  d6 1e 21 e7 96 d7 8d cc  |..........!.....|
00000020  df 13 52 f2 3c d3 28 12  f4 85 0b 87 8a e4 94 4c  |..R.<.(........L|
00000030
$ ssh-keygen -Y sign -f logkey -n "tree_head:v0:7d865e959b2466918c9863afca942d0fb89d7c9ac0c99bafc3749504ded97730@sigsum.org" data
Signing file data
Write signature to data.sig
$ cat allowed-signers
log@someorg ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILYXiEbqGLrf4iGX3PWIgxWBUVdfaoJthJgIAYus8zbB log@somehost
$ ssh-keygen -Y verify -f allowed-signers -I log@someorg -n "tree_head:v0:7d865e959b2466918c9863afca942d0fb89d7c9ac0c99bafc3749504ded97730@sigsum.org" -s data.sig < data
Good "tree_head:v0:7d865e959b2466918c9863afca942d0fb89d7c9ac0c99bafc3749504ded97730@sigsum.org" signature for log@someorg with ED25519 key SHA256:oIkC0rWfhw9ozi8STsqVhjXE6ZKaK3FqcxajharFNhY
```
