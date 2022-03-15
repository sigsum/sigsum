# A frequently asked question
We are frequently asked how Sigsum compares to Sigstore.  This document
highlights some technical similarities and differences as of March, 2022.

Sigstore's sub-project Rekor and Sigsum are both transparency log designs that
aim to make a signer's key-usage transparent.  By enabling end-users to verify
that signatures they trust are public, they are protected from accepting
malicious signatures that were created in secret (e.g., due to key compromise).

The following transparency log concepts are explored side-by-side:

  - Purpose of logging
  - What is logged
  - Auditing
  - Gossip
  - Anti-poison
  - Anti-spam
  - Privacy
  - API
  - Promises of future logging (SCTs)
  - Sharding

There is also an Appendix at the end with relevant code snippets.

## Purpose of logging

**Sigsum**

No signature that an end-user accepts as valid should go unnoticed by anyone who
inspects the log.

Sigsum is designed to be secure even if an attacker controls:

  - The signer's infrastructure and signing key
  - The log's infrastructure and signing key
  - A threshold of independent witnesses that cosign the log

The log operator is not trusted beyond being available at the time of logging.

**Sigstore/Rekor**

[Rekor's README][] says that the goal is to "[e]nable software maintainers and
build systems to record signed metadata to an immutable record", and that it
"fulfils the signature transparency role of sigstore's software signing
infrastructure".  [No threat model][] is available at the time of writing.

[Rekor's README]: https://github.com/sigstore/rekor/tree/6ace9fe63b072a3a7e8b544fcbf393d2aafe9ae5#readme
[No threat model]: https://web.archive.org/web/20220312143825/https://docs.sigstore.dev/security/

## What is logged

**Sigsum**

A shard hint, a SHA256 checksum, an Ed25519 signature, and a SHA256-hashed
public key.  The signed blob is based on the [SSH format][].  The logged
signatures are verifiable by anyone who knows the corresponding public keys.

[SSH format]: https://github.com/openssh/openssh-portable/blob/master/PROTOCOL.sshsig

**Sigstore/Rekor**

Signed manifests called [pluggable types][].  The rekord type allows signatures
based on Signify, Minisign, SSH, and PGP, as well as PKIX/X.509.  For example,
you could log a signature for a PGP email that was received in 2002.  There are
several other pluggable types with more to come.  Rekor is overall permissive.

Some pluggable type signatures are not verifiable in isolation for a monitor
that observes the log because to verify a signature data is needed that is not
included in the log and might be known only to the creator of the signature, see
"Example 1: unverifiable signatures" in the Appendix at the end.  This means
that it is impossible to distinguish between unverifiable log entries fabricated
by the log and log entries maliciously created with a signer's private key.

[pluggable types]: https://github.com/sigstore/rekor/blob/6ace9fe63b072a3a7e8b544fcbf393d2aafe9ae5/pkg/types/README.md

## Auditing
How will end-users verify that public logging took place?

**Sigsum**

End-users receive inclusion proofs and cosigned tree heads that can be verified
offline in the same way that data and signatures are currently delivered (a
website, a git repository, etc).  No other network communication is required.

This means that a sigsum log does not have to be available to the end-user after
logging succeeded to verify that public logging took place.

**Sigstore/Rekor**

End-users [query the log][] to check that a signature is included.  This means
the log needs to stay available to end-users at all times, also see "Privacy".

Alternatively, an end-user may trust a signed promise (SCT) from Rekor to
include a signature in the future, see "Promises of future log inclusion".

[query the log]: https://web.archive.org/web/20220312144545/https://www.sigstore.dev/how-it-works

## Gossip
A mechanism that ensures everyone observes the same append-only log.  A
transparency log without gossip requires trusting the log operator and the
integrity of the log's signing key.

**Sigsum**

Gossip is handled proactively using a simplified version of witness cosigning
([S&P 2016][]).  It can be thought of as a policy-based consensus mechanism:
m-of-n witnesses audit the log's consistency from their respective vantage
points.  The log distributes the witnesses' signatures, which end-users and
monitors make use of.  This ensures that a malicious sigsum log operator is
unable to fool even an offline verifier.

[S&P 2016]: https://arxiv.org/pdf/1503.08768.pdf

**Sigstore/Rekor**

Does not have gossip.  Sigstore proposes to instead use multiple independent
[full-fledged logs][].  Logs have more freedom to fool a verifier than cosigning
witnesses and are harder and more expensive to run.

Signers would have to take great care to submit the same entries to all the logs
and would have to monitor all of them.  End-users would have to contact and/or
trust multiple logs when verifying.

[full-fledged logs]: https://web.archive.org/web/20220312144801/http://web.archive.org/screenshot/https://docs.sigstore.dev/faq

## Anti-poison
A transparency log design must take caution to not include large amounts of
arbitrary data, as someone could submit information that is illegal to possess
or distribute. Because the log operator cannot selectively erase information
from the log without invalidating it, the operator may be compelled to shut down
the log, or simply choose to not operate a log in the first place.

**Sigsum**

Include as little arbitrary information as possible.  A log entry contains a
time value (a shard hint, in the interval `[shard_start, now()]`) of which the
least significant few bytes are arbitrary. The remaining content can only be
specified by brute forcing signatures or hashes so that parts of them contain
certain patterns.  This quickly becomes expensive.

**Sigstore/Rekor**

The pluggable type system allows logging of a wide variety of information.  The
rekord type for instance allows encoding an image, see "Example 2: logging JPG
images" in the Appendix at the end.  Other current and future pluggable types
might permit similar things but we have not looked into that further.

## Anti-spam
An approach to limit abusive logging requests that consume the log's capacity.

**Sigsum**

A logging request is only accepted if the involved public key is hashed into a
DNS TXT record.  So, rate limits can be based on DNS names.  This is similar to
the anti-spam mechanisms that CT relies on, where a certificate is not accepted
unless it chains up to a trusted CA.  Let's Encrypt [rate-limits via DNS][].

[rate-limits via DNS]: https://web.archive.org/web/20220312145502/https://letsencrypt.org/docs/rate-limits/

**Sigstore/Rekor**

Recently opened an issue about [needing rate-limits][].  It has since been added
to Sigstore's infrastructure setup based on IP addresses via Nginx.

[needing rate-limits]: https://github.com/sigstore/rekor/issues/637

## Privacy

**Sigsum**

For end-users, nothing changes with regard to privacy compared to signature
verification that does not make use of a transparency log.

A signer has to expose to the log operator a public key and a 32-byte preimage
([which should be a hash][]).

The signer's hashed public key is exposed in DNS, see "Anti spam".  Logs can be
be instructed to fetch such TXT resource records if they match `_sigsum_v0.*`.

Log entries consisting of a shard hint, hashes and signatures become public, see
"What is logged".

[which should be a hash]: https://git.sigsum.org/sigsum/tree/doc/design.md?id=741a65ab1894b35c9cc132d9b8401776c04fe1ce#n351

**Sigstore/Rekor**

End-users that query the log for entries they are interested in expose this
information to the log.

A signer's public key and data is exposed to the log operator.  The data may be
a hash if [using X.509/PKIX][] signatures and the "hashed rekord type".

Logs can be instructed to download arbitrary data from [specified URLs][].

The content of pluggable types become public, notably including public keys and
other data that may be encoded (which depends on the exact pluggable type).

[using X.509/PKIX]: https://github.com/sigstore/rekor/blob/6ace9fe63b072a3a7e8b544fcbf393d2aafe9ae5/types.md#hashed-rekord
[specified URLs]: https://github.com/sigstore/rekor/blob/6ace9fe63b072a3a7e8b544fcbf393d2aafe9ae5/openapi.yaml#L143

## API

**Sigsum**

Simple ASCII parsers are used to add input and get output from the log.  Binary
data is hex-encoded.  Data that is signed and/or logged can be (de)serialized
using Tor's easy wire-format, [Trunnel][].  The overall take of the API is to
keep it as simple as possible, and to nudge towards correct usage by design.

[Trunnel]: https://gitweb.torproject.org/trunnel.git/tree/doc/trunnel.md

**Sigstore/Rekor**

REST API with JSON, both for input and output as well as canonicalization of
data.  Some parts of the API are easily misused due to returning redundant
and/or unauthenticated data.  This happened [once][] and [twice][] already.

Other types of mis-usage are likely to be expected.  For example, the
availability of public keys makes it tempting to inappropriately use Rekor for
key discovery even though it is not designed to be a trustworthy source of keys.

The implementation complexity of Rekor's API is also relatively large.  Imports
contain much hidden complexity, in part due to pluggable types that involve PGP,
ASN.1, and such.  This has already lead to issues like Rekor starting to return
[YAML instead of JSON][]; JSON marshalling of tree leaves [not being canonical
enough][]; the [need of another PGP library][]; etc.  It will likely be hard to
understand, implement, and maintain Rekor compliant software in the long run.

[once]: https://github.com/sigstore/rekor/issues/200
[twice]: https://github.com/sigstore/rekor/pull/469
[YAML instead of JSON]: https://github.com/sigstore/rekor/issues/593
[not being canonical enough]: https://github.com/sigstore/rekor/pull/445
[need of another PGP library]: https://github.com/sigstore/rekor/issues/286

## Promises of future log inclusion (SCTs)
A construct that enables low-latency logging.  Certificate Transparency
introduced this to work with the existing TLS PKI during a gradual roll-out
scenario.  Nine years later such roll-outs are still in the earlier stages.

**Sigsum**

Does not support SCTs. Unlike the TLS case there is no existing system to be
compatible with and use-cases that cannot tolerate a few minutes of logging
latency are out-of-scope.  This is a trade-off that keeps the design simple.

**Sigstore/Rekor**

[Supports SCTs][]. If an entry (promised to be logged by an SCT) is not included
in the log in time the operator should not be trusted in the future.  This
places high requirements on uptime and availability, and on not losing the log
request between the time of issuing an SCT and inclusion in the log.  Rekor
avoids this by simply including the signature in the log [before issuing][] the
SCT. That however provides no latency reduction, making SCTs pointless.

The mere existence of SCTs also encourages their use, making users who rely on
them not receive the full benefits of using a transparency log.  We are not
aware of any clear plans specifying how Sigstore will solve SCT verification.
Without such plans, the log may deceive end-users by changing its history.

[Supports SCTs]: https://twitter.com/lorenc_dan/status/1388109774579982340
[before issuing]: https://github.com/sigstore/rekor/blob/a61d5f63843cbae4e5bf1f97d06628fa914a4435/openapi.yaml#L493

## Sharding
The practise of dividing a log into smaller independent partitions.  One of
Certificate Transparency's successes is [temporal sharding][] based on expiry
date to allow log rotation (helpful to make log life cycles more manageable).

[temporal sharding]: https://web.archive.org/web/20220312150931/https://googlechrome.github.io/CertificateTransparency/log_policy.html

**Sigsum**

Establishes shards based on shard hints in the interval `[shard_start, now()]`.
Shard hints are part of the signer's signing context and cannot be forged,
preventing past entries from being re-logged in a newer shard.  A log can also
cease its operations safely due to Sigsum's take on offline auditing.  This
gives a complete story for log life cycles without any expiration dates.

**Sigstore/Rekor**

Creates [virtual shards][], see also related [GitHub issues][].  The latest
virtual shard is active.  All other virtual shards are kept around but in
read-only mode.  If a virtual shard was to be deleted those entries can be
logged again.  As old virtual shards have to be saved, this gives a complicated
log configuration but does not provide any of the benefits of sharding.

[virtual shards]: https://docs.google.com/document/d/1QBTyK-wquplNdeUB5_aqztQHigJOepCvd-4FL4H-zl8/edit?resourcekey=0-grdVbSltkTvpNvhj03laCQ#
[GitHub issues]: https://github.com/sigstore/rekor/issues/353

# Appendix
## Example 1: Unverifiable signatures
The input to a signature verification is a public key, a message, and a
signature.  Rekor incorrectly assumes that the signed message ("artifact")
is always a hash.

First we demonstrate the issue using `signify`.

**Step 1 - Generate a key-pair**

    $ signify-openbsd -G -c "demo" -p example.pub -s example.sec
    passphrase:
    confirm passphrase:
    $ ls
    example.pub  example.sec

**Step 2 - Create something to sign**

    $ echo 'print("hello")' > hello.py
    $ sha256sum hello.py
    b80792336156c7b0f7fe02eeef24610d2d52a10d1810397744471d1dc5738180  hello.py
    $ ls
    example.pub  example.sec  hello.py

**Step 3 - Sign**

    $ signify-openbsd -Ss example.sec -m hello.py
    passphrase:
    $ ls
    example.pub  example.sec  hello.py  hello.py.sig

**Step 4 - Log**

The below uses Rekor on commit 6ace9fe63b072a3a7e8b544fcbf393d2aafe9ae5.

    $ rekor-cli upload \
          --artifact hello.py\
          --signature hello.py.sig\
          --pki-format=minisign\
          --public-key=example.pub\
          --rekor_server http://localhost:3000
    Created entry at index 99, available at: http://localhost:3000/api/v1/log/entries/bf5f87c83bfffc3b0d3d0151a6cfef836594dcd90ac286541b25856b7d6fd6b1
    $ rekor-cli get --log-index 99 --rekor_server http://localhost:3000
    LogID: e0f8a8ff472431bda298489c292f33f5d30363949df58d2e35c5195f915c7069
    Index: 99
    IntegratedTime: 2022-03-12T11:59:28Z
    UUID: bf5f87c83bfffc3b0d3d0151a6cfef836594dcd90ac286541b25856b7d6fd6b1
    Body: {
      "RekordObj": {
        "data": {
          "hash": {
            "algorithm": "sha256",
            "value": "b80792336156c7b0f7fe02eeef24610d2d52a10d1810397744471d1dc5738180"
          }
        },
        "signature": {
          "content": "dW50cnVzdGVkIGNvbW1lbnQ6ClJXVE9PWDNrMjE0L3VDR0VuQWtHaC9wOGxCK2o4ZlU0bzN2aFpzc3dud2RFeDE2M2REUHpReE1BVXdUcUFjK1ovaGdycGdISU5VNHlFbnhPOXNwSnkydmZmcHdWSUJIV3lnWT0=",
          "format": "minisign",
          "publicKey": {
            "content": "UldUT09YM2syMTQvdUg1RVhHbUFwdDZWSnhxVUlJZzIrWnMrajlFRDNTM1ZGOXBHSzZoWDRLSmM="
          }
        }
      }
    }

Let's understand the above in more detail.  Our public key and signature is in
the above output, but without the untrusted comment which is irrelevant.

    cat example.pub
    untrusted comment: demo public key
    RWTOOX3k214/uH5EXGmApt6VJxqUIIg2+Zs+j9ED3S3VF9pGK6hX4KJc
    $ echo UldUT09YM2syMTQvdUg1RVhHbUFwdDZWSnhxVUlJZzIrWnMrajlFRDNTM1ZGOXBHSzZoWDRLSmM= | base64 -d
    RWTOOX3k214/uH5EXGmApt6VJxqUIIg2+Zs+j9ED3S3VF9pGK6hX4KJc
    $
    $ cat hello.py.sig
    untrusted comment: verify with example.pub
    RWTOOX3k214/uCGEnAkGh/p8lB+j8fU4o3vhZsswnwdEx163dDPzQxMAUwTqAc+Z/hgrpgHINU4yEnxO9spJy2vffpwVIBHWygY=
    $ echo "dW50cnVzdGVkIGNvbW1lbnQ6ClJXVE9PWDNrMjE0L3VDR0VuQWtHaC9wOGxCK2o4ZlU0bzN2aFpzc3dud2RFeDE2M2REUHpReE1BVXdUcUFjK1ovaGdycGdISU5VNHlFbnhPOXNwSnkydmZmcHdWSUJIV3lnWT0=" | base64 -d
    untrusted comment:
    RWTOOX3k214/uCGEnAkGh/p8lB+j8fU4o3vhZsswnwdEx163dDPzQxMAUwTqAc+Z/hgrpgHINU4yEnxO9spJy2vffpwVIBHWygY=

Rekor also stored a SHA256 hash: 

    "RekordObj": {
      "data": {
        "hash": {
          "algorithm": "sha256",
          "value": "b80792336156c7b0f7fe02eeef24610d2d52a10d1810397744471d1dc5738180"
        }
      },

You might recognize it from step 2.  It is the output of `sha256sum hello.py`.
What is needed to do verification with the logged signature and public key is
the output of `cat hello.py`.  This is because signify signs those exact bytes
without doing any hashing (unlike other schemes that actually do sign a hash).

The impact is that you cannot know by observing the log if a real signature
operation happened (there is nothing to verify), or if the Rekor operator
fabricated an entry.  The signature would be verifiable if the data can be
located.  In the case of a malicious signature this might not be the case.

**The same issue in other places**

Minisign has the same issue, even with its pre-hashed mode because Minisign
[does not use SHA256][] which is what Rekor still stores.  The exact same issue
is also there for SSH signatures.  We did not dig into any other types.

[does not use SHA256]: https://github.com/sigstore/rekor/blob/6ace9fe63b072a3a7e8b544fcbf393d2aafe9ae5/pkg/pki/minisign/minisign.go#L109

## Example 2: Logging JPG images
As shown above Rekor scrubs some information that was submitted for logging.
Most likely to not accept arbitrary bytes, such as signify's untrusted comments.
To protect Rekor against logging of illegal content, each pluggable type needs
to be considered in more detail.  Below is an example that encodes a JPG image.

**Step 1 - Create an image**

    $ convert -size 16x16 xc:red red.jpg
    $ ls
    red.jpg

This also works with larger images, e.g., `-size 4096x4096`.

**Step 2 - Encode image in an X.509 configuration**

    $ echo "[ req ]" > crt.cnf
    $ echo "distinguished_name = dn" >> crt.cnf
    $ echo "x509_extensions = extensions" >> crt.cnf
    $ echo "prompt = no" >> crt.cnf
    $ echo "" >> crt.cnf
    $ echo "[ extensions ]" >> crt.cnf
    $ echo "1.2.3.4 = ASN1:UTF8String:$(base64 -w0 red.jpg)" >> crt.cnf
    $ echo "" >> crt.cnf
    $ echo "[ dn ]" >> crt.cnf
    $ echo "0.DC = com" >> crt.cnf
    $ echo "1.DC = example" >> crt.cnf
    $ echo "commonName = example.com" >> crt.cnf
    $ ls
    crt.cnf  red.jpg

Credit: [this post][] outlines how an X.509v3 extension can be prepared.

[this post]: https://serverfault.com/questions/1005029/error-when-trying-to-add-custom-extensions-to-x509-certificates-using-openssl

**Step 3 - Create X.509 certificate**

    $ openssl req -x509 -nodes\
            -newkey ec:<(openssl ecparam -name prime256v1)\
            -config crt.cnf\
            -keyout priv.pem\
            -out cert.pem
    Generating an EC private key
    writing new private key to 'priv.pem'
    -----
    $ ls
    cert.pem  crt.cnf  priv.pem  red.jpg

Note that we now have an X.509 certificate that encodes our image:

    $ openssl x509 -in cert.pem -text -noout
    Certificate:
        Data:
            Version: 3 (0x2)
            Serial Number:
                27:a5:0e:37:9c:3e:e1:0d:d7:a4:8f:10:ce:2d:09:35:40:9c:a8:1e
            Signature Algorithm: ecdsa-with-SHA256
            Issuer: DC = com, DC = example, CN = example.com
            Validity
                Not Before: Mar 12 13:46:06 2022 GMT
                Not After : Apr 11 13:46:06 2022 GMT
            Subject: DC = com, DC = example, CN = example.com
            Subject Public Key Info:
                Public Key Algorithm: id-ecPublicKey
                    Public-Key: (256 bit)
                    pub:
                        04:9d:2a:5d:4c:df:d4:fa:9a:76:32:59:96:3b:44:
                        12:00:03:3c:c0:d9:42:58:c1:fb:2a:ed:fb:0d:95:
                        d0:ce:7d:62:e6:f8:ae:be:76:6b:3b:0c:44:aa:ca:
                        43:57:cf:19:a3:c9:b1:cd:05:21:a2:b8:0c:50:13:
                        0c:d9:9f:8f:ea
                    ASN1 OID: prime256v1
                    NIST CURVE: P-256
            X509v3 extensions:
                1.2.3.4:
                    ..../9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAMCAgICAgMCAgIDAwMDBAYEBAQEBAgGBgUGCQgKCgkICQkKDA8MCgsOCwkJDRENDg8QEBEQCgwSExIQEw8QEBD/2wBDAQMDAwQDBAgEBAgQCwkLEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBD/wAARCAAQABADAREAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAj/xAAUEAEAAAAAAAAAAAAAAAAAAAAA/8QAFgEBAQEAAAAAAAAAAAAAAAAAAAcJ/8QAFBEBAAAAAAAAAAAAAAAAAAAAAP/aAAwDAQACEQMRAD8AnRDGqYAAD//Z
        Signature Algorithm: ecdsa-with-SHA256
             30:46:02:21:00:ee:ee:81:d6:1c:e8:a7:ca:dd:54:b5:82:fe:
             22:1d:94:1d:b1:31:91:d6:3e:68:99:f5:d5:da:c9:f4:bc:53:
             53:02:21:00:cd:08:98:c5:73:e8:a1:8f:8c:95:06:cc:5c:70:
             65:aa:dd:94:f0:38:59:ec:f7:c7:35:98:eb:75:5f:23:eb:c5

Compare the X.509v3 extensions to this:

    $ base64 red.jpg
    /9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAMCAgICAgMCAgIDAwMDBAYEBAQEBAgGBgUGCQgKCgkICQkKDA8MCgsOCwkJDRENDg8QEBEQCgwSExIQEw8QEBD/2wBDAQMDAwQDBAgEBAgQCwkLEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBD/wAARCAAQABADAREAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAj/xAAUEAEAAAAAAAAAAAAAAAAAAAAA/8QAFgEBAQEAAAAAAAAAAAAAAAAAAAcJ/8QAFBEBAAAAAAAAAAAAAAAAAAAAAP/aAAwDAQACEQMRAD8AnRDGqYAAD//Z

Now we need to get this X.509 certificate into Rekor.

**Step 4 - Sign something**

    $ openssl dgst -sha256 -sign priv.pem -out red.jpg.sig red.jpg
    $ ls
    cert.pem  crt.cnf  priv.pem  red.jpg  red.jpg.sig

**Step 5 - Log**

    $ rekor-cli upload \
            --artifact red.jpg\
            --signature red.jpg.sig\
            --pki-format=x509\
            --public-key=cert.pem\
            --rekor_server http://localhost:3000
    Created entry at index 102, available at: http://localhost:3000/api/v1/log/entries/688f817bb1e7cb1b28eadf173b0095724cce86ab0116b0df5a0c8e06c00e880c
    $
    $ rekor-cli get --log-index 102 --rekor_server http://localhost:3000
    LogID: e0f8a8ff472431bda298489c292f33f5d30363949df58d2e35c5195f915c7069
    Index: 102
    IntegratedTime: 2022-03-12T13:51:30Z
    UUID: 688f817bb1e7cb1b28eadf173b0095724cce86ab0116b0df5a0c8e06c00e880c
    Body: {
      "RekordObj": {
        "data": {
          "hash": {
            "algorithm": "sha256",
            "value": "4a837db6d6a21a9bdfccff6ca21f72d1d4a671b59a5df76158629ff5f6b22ddf"
          }
        },
        "signature": {
          "content": "MEYCIQD4HWtXfSDGpWUUmk1tWUP/V5MRUPgwrUMiiJB7miKZcQIhAJDYUO+lyGYKShCtt3AZZilZkoLEm9WAaXhlzGVwZMu6",
          "format": "x509",
          "publicKey": {
            "content": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURKakNDQXN1Z0F3SUJBZ0lVSjZVT041dys0UTNYcEk4UXppMEpOVUNjcUI0d0NnWUlLb1pJemowRUF3SXcKUkRFVE1CRUdDZ21TSm9tVDhpeGtBUmtXQTJOdmJURVhNQlVHQ2dtU0pvbVQ4aXhrQVJrV0IyVjRZVzF3YkdVeApGREFTQmdOVkJBTU1DMlY0WVcxd2JHVXVZMjl0TUI0WERUSXlNRE14TWpFek5EWXdObG9YRFRJeU1EUXhNVEV6Ck5EWXdObG93UkRFVE1CRUdDZ21TSm9tVDhpeGtBUmtXQTJOdmJURVhNQlVHQ2dtU0pvbVQ4aXhrQVJrV0IyVjQKWVcxd2JHVXhGREFTQmdOVkJBTU1DMlY0WVcxd2JHVXVZMjl0TUZrd0V3WUhLb1pJemowQ0FRWUlLb1pJemowRApBUWNEUWdBRW5TcGRUTi9VK3BwMk1sbVdPMFFTQUFNOHdObENXTUg3S3UzN0RaWFF6bjFpNXZpdXZuWnJPd3hFCnFzcERWODhabzhteHpRVWhvcmdNVUJNTTJaK1A2cU9DQVprd2dnR1ZNSUlCa1FZREtnTUVCSUlCaUF5Q0FZUXYKT1dvdk5FRkJVVk5yV2twU1owRkNRVkZCUVVGUlFVSkJRVVF2TW5kQ1JFRkJUVU5CWjBsRFFXZE5RMEZuU1VSQgpkMDFFUWtGWlJVSkJVVVZDUVdkSFFtZFZSME5SWjB0RFoydEpRMUZyUzBSQk9FMURaM05QUTNkclNrUlNSVTVFClp6aFJSVUpGVVVObmQxTkZlRWxSUlhjNFVVVkNSQzh5ZDBKRVFWRk5SRUYzVVVSQ1FXZEZRa0ZuVVVOM2EweEYKUWtGUlJVSkJVVVZDUVZGRlFrRlJSVUpCVVVWQ1FWRkZRa0ZSUlVKQlVVVkNRVkZGUWtGUlJVSkJVVVZDUVZGRgpRa0ZSUlVKQlVVVkNRVkZGUWtGUlJVSkVMM2RCUVZKRFFVRlJRVUpCUkVGU1JVRkJhRVZDUVhoRlFpODRVVUZHClVVRkNRVkZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVdvdmVFRkJWVVZCUlVGQlFVRkJRVUZCUVVGQlFVRkIKUVVGQlFVRkJRUzg0VVVGR1owVkNRVkZGUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVdOS0x6aFJRVVpDUlVKQgpRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZRTDJGQlFYZEVRVkZCUTBWUlRWSkJSRGhCYmxKRVIzRlpRVUZFCkx5OWFNQW9HQ0NxR1NNNDlCQU1DQTBrQU1FWUNJUUR1N29IV0hPaW55dDFVdFlMK0loMlVIYkV4a2RZK2FKbjEKMWRySjlMeFRVd0loQU0wSW1NVno2S0dQakpVR3pGeHdaYXJkbFBBNFdlejN4eldZNjNWZkkrdkYKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo="
          }
        }
      }
    }

Of interest here is the public key:

    $ echo "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURKakNDQXN1Z0F3SUJBZ0lVSjZVT041dys0UTNYcEk4UXppMEpOVUNjcUI0d0NnWUlLb1pJemowRUF3SXcKUkRFVE1CRUdDZ21TSm9tVDhpeGtBUmtXQTJOdmJURVhNQlVHQ2dtU0pvbVQ4aXhrQVJrV0IyVjRZVzF3YkdVeApGREFTQmdOVkJBTU1DMlY0WVcxd2JHVXVZMjl0TUI0WERUSXlNRE14TWpFek5EWXdObG9YRFRJeU1EUXhNVEV6Ck5EWXdObG93UkRFVE1CRUdDZ21TSm9tVDhpeGtBUmtXQTJOdmJURVhNQlVHQ2dtU0pvbVQ4aXhrQVJrV0IyVjQKWVcxd2JHVXhGREFTQmdOVkJBTU1DMlY0WVcxd2JHVXVZMjl0TUZrd0V3WUhLb1pJemowQ0FRWUlLb1pJemowRApBUWNEUWdBRW5TcGRUTi9VK3BwMk1sbVdPMFFTQUFNOHdObENXTUg3S3UzN0RaWFF6bjFpNXZpdXZuWnJPd3hFCnFzcERWODhabzhteHpRVWhvcmdNVUJNTTJaK1A2cU9DQVprd2dnR1ZNSUlCa1FZREtnTUVCSUlCaUF5Q0FZUXYKT1dvdk5FRkJVVk5yV2twU1owRkNRVkZCUVVGUlFVSkJRVVF2TW5kQ1JFRkJUVU5CWjBsRFFXZE5RMEZuU1VSQgpkMDFFUWtGWlJVSkJVVVZDUVdkSFFtZFZSME5SWjB0RFoydEpRMUZyUzBSQk9FMURaM05QUTNkclNrUlNSVTVFClp6aFJSVUpGVVVObmQxTkZlRWxSUlhjNFVVVkNSQzh5ZDBKRVFWRk5SRUYzVVVSQ1FXZEZRa0ZuVVVOM2EweEYKUWtGUlJVSkJVVVZDUVZGRlFrRlJSVUpCVVVWQ1FWRkZRa0ZSUlVKQlVVVkNRVkZGUWtGUlJVSkJVVVZDUVZGRgpRa0ZSUlVKQlVVVkNRVkZGUWtGUlJVSkVMM2RCUVZKRFFVRlJRVUpCUkVGU1JVRkJhRVZDUVhoRlFpODRVVUZHClVVRkNRVkZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVdvdmVFRkJWVVZCUlVGQlFVRkJRVUZCUVVGQlFVRkIKUVVGQlFVRkJRUzg0VVVGR1owVkNRVkZGUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVdOS0x6aFJRVVpDUlVKQgpRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZRTDJGQlFYZEVRVkZCUTBWUlRWSkJSRGhCYmxKRVIzRlpRVUZFCkx5OWFNQW9HQ0NxR1NNNDlCQU1DQTBrQU1FWUNJUUR1N29IV0hPaW55dDFVdFlMK0loMlVIYkV4a2RZK2FKbjEKMWRySjlMeFRVd0loQU0wSW1NVno2S0dQakpVR3pGeHdaYXJkbFBBNFdlejN4eldZNjNWZkkrdkYKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=" | base64 -d > logged-cert.pem
    $ diff cert.pem logged-cert.pem
    $

As you can see, it is the same certificate that contains our JPG image.  Any
other data could be encoded as well using the above trick.
