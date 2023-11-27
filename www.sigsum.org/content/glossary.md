# Glossary

This page describes terminology commonly used in the Sigsum system.

## Transparency

_Transparency_ in Sigsum can be thought of as social media for signing keys.
Anytime a signature is produced, it will be broadcast for everyone to see in
public.  This means that if an attacker manages to compromise a signing key and
produce a valid signature, it is easily [detected](#detectability) by the key's
owner.

> Wait a second,
> I did not sign a new software release in the middle of the night.

## Detection

_Detection_ is the ability to learn that an event occurred in a system.  For
example, an administrator might detect that a file system is unavailable due to
an email notification with a failed job.  While the email itself does not
[prevent](#prevent) the file system from becoming unavailable, it is the first
step towards getting the attention of someone that is able to debug the problem
and roll out a fix.

## Prevention

_Prevention_ is the ability to ensure that an event does not occur in a system.
For example, an unwanted event might be that a file system becomes unavailable.
If the main threat is a disk that fails, a sound prevention strategy could be to
configure the system with redundant disks to tolerate up to `k` failures.

## Trust policy

A _trust policy_ describes which [logs](#log) and [witnesses](#witness) to
depend on in order to achieve [transparency](#transparency) and [global
consistency](#global-consistency) within a use-case defined [threat
model](#threat-model).

The specified [logs](#log) describe where [monitors](#monitor) must look for
[logged entries](#tree-leaf).

The specified [witnesses](#witnesses) describe which entities to place _some_
[unconditional trust](#unconditional-trust) in.

A quorum rule defines the amount of [witnessing](#witnessing) (and thus the
degree of [decentralized trust](#decentralized-trust)) that is required to
achieve [global consistency](#global-consistency).  An [m-of-n
threshold](#m-of-n-threshold) would be one example of a quorum rule.

What keeps the trust policy free from malicious tampering will be the system's
[root of trust](#root-of-trust).


## Threat model

## Root of trust

A system's _root of trust_ is a trusted starting point that other components
assume "secure" in order to function as expected.  For example, the trust root
might be stored in a write-protected part of the system that is hard to tamper
with (or at least require special system privileges in order to update).

## Unconditional trust

## Decentralized trust

## m-of-n threshold

## Fail-close

A system is said to _fail-close_ if a verification error implies that the system
halts.  For example, web browsers fail-close on a website's TLS certificate
being signed by a trusted certificate authority.

## Fail-open

A system is said to _fail-open_ if a verification error is ignored in favor of
continuing to run the system.  For example, web browsers fail-open on TLS
certificates being accompanied by OCSP responses.

## Offline verifier

An _offline verifier_ is able to perform verification without ever making any
outbound network connections.  For example, a signature verification algorithm
can run as an offline verifier.

## Online verifier

An _online verifier_ is able to perform verification if outbound network
connections can be established.  State may need to be stored to tolerate and
recover from benign as well as malicious network issues.

## Proof of logging

A _proof of logging_ is the information an [offline verifier](#offline-verifier)
needs to assess whether a data object is considered transparent. A proof of
logging is composed of a [checksum signature](#signed-checksum), a [leaf
index](#leaf-index), an [inclusion proof](#inclusion-proof), and a [cosigned
tree head](cosigned-tree-head).  This is interchangeably referred to as a _proof
bundle_.

## Checksum
## Signed checksum
## Leaf index
## Inclusion proof
## Consistency proof
## Local consistency
## Global consistency
## Cosigned tree head
## Tree leaf
## Log
## Witness
## Monitor
