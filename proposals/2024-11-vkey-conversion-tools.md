# Conversion tools for vkey strings

As the community of operators of (general purpose) witnesses as well
as operators of various types of witnessed transparency logs grow,
sigsum users will need tools for conversion between various sigsum
conventions and the vkey format, that is the main pubkey exchange
format when handling [signed note][] objects.

The need for conversion tools has become very concrete when
configuring Sigsum logs to operate together with the armored witness
devices.

[signed note]: https://github.com/C2SP/C2SP/blob/main/signed-note.md

## The vkey format

A verifier key or "vkey" is a public key format used together with the
signed note format. It's described at
https://pkg.go.dev/golang.org/x/mod/sumdb/note.

It's a string of the form `<name>+<hash>+<keydata>` where `<name>` is
a human-readable string, `<hash>` is a hex-encoded 32-bit value
corresponding to the key id in a [signed note][] signature line, and
the `<keydata>` is a base64-encoded blob where the first byte is an
algorithm byte, and the remaining bytes are the public key, usually
ed25519. The algorithm bytes corresponding roughly to the signature
type in a signed note line (although that is not yet clearly
specified, e.g., we don't yet have a spec or consensus on what
algorithm byte is right for a vkey string for a witness key).

## Proposal

Add needed conversion functions to the `sigsum-key` tool. We can have

```
sigsum-key to-origin [-k file] [-o output]
  Reads public key from file (by default, stdin) and writes a
  checkpoint origin line for a Sigsum log to output (by default,
  stdout).

sigsum-key to-note-verifier [-n name] [-k file] [-t type] [-o output]
  Reads public key from file (by default, stdin) and writes a signed
  note verifier line. By defaults, uses the corresponding log origin
  as the key name. Possible types are "ed25519" and "cosignature".
```

For reading a vkey string, we can have

```
sigsum-key from-note-verifier [-k file] [-o output]
  Extracts the public key from a note verifier line.
```

Feedback on this interface is appreciated (see next section).

## Design questions

### The `sigsum-key to-*` commands

These are rather straight-forward, but a few design questions:

Maybe `to-origin` is redundant, since the origin is what you get if
you run `to-note-verifier` with default arguments, and cut at the
first `+` sign. Or `to-hex` and prepend a fix string. Depends on what
usecases we have for just outputting the origin line. Cost of
implementing and documenting `to-origin`is rather small.

Is it nice with a `-t type` option, or is it better with
`--cosignature` or `--witness` (and `--log` being the default)?

### The `sigsum-key from-note-verifier` command

Here, the proper design is a bit more open.

First question is the input, we can use -k for input (it still is a
kind of key, even if in different format than what other commands
expect).

Or should we take the verifier (which is a plain string, not even any
spaces) directly on the command line?

This most basic conversion, to get the public key, discards the other
info included in the vkey string. Potential additional features:

* Specify the expected key type (log or witness key), and fail if the
  key is of unexpected type.

* Configure if the tool should accept any keyid, or validate that the
  keyid is consistent with the name and keydata (for the key types we
  care about, the keyid should be computed from a hash of those
  values).
  
* Output additional information, like key name and key type, either as
  diagnostic messages on stderr, or in some more structured way.
  
* Output additional information in the comment field of the ssh pubkey
  format. Possibly with some configurability.

* Output a witness line in trust policy format, with name and pubkey
  extracted from the vkey.

* Should we have a way to process multiple vkeys, e.g., specifying
  multiple ones on the command line, or reading a file with a vkey per
  line? E.g., for the case of outputting a witness line in trust
  policy format for each vkey?

Taken to the extreme, we could have an option that accepts a format
string specifying which parts of the vkey should be output, and in
which order and format.

First implementation should naturally do only the most needed
conversion, but we should design it so that it's possible to extend
with more features, in a consistent way.

Or maybe there should be separate subcommands for each purpose, or
even a different tool, instead of baking it into sigsum-key?
