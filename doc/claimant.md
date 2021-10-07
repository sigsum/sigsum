# Use-case specific claimant models
Sigsum logs can be used for a variety of use-cases.  One way to describe your
use-case is with the
	[claimant model](https://github.com/google/trillian/blob/master/docs/claimantmodel/CoreModel.md).
You will realize that verifiers must see the same signed statements as believers.
Sigsum solves that.

XXX: add more examples.

## **System<sup>RB</sup>**:
System<sup>RB</sup> is about the claims made by a _software publisher_ that
makes reproducible builds available.
* **Claim<sup>RB</sup>**:
	_I, software publisher, claim that the data_:
	1. has cryptographic hash X
	2. is the output of a reproducible build for which the source and relevant
	build-info information can be located in repository Y using X as an identifier
* **Statement<sup>RB</sup>**: Statement<sup>CHECKSUM</sup><br>
	The signed statement encodes a cryptographic hash X.
* **Claimant<sup>RB</sup>**: software publisher<br>
	The software publisher is a party that wants to publish a reproducible
	build.
* **Believer<sup>RB</sup>**: end-user<br>
	The end-user is a party that wants to run an executable binary if it
	builds reproducibly.
* **Verifier<sup>RB</sup>**: any interested party<br>
	These parties try to verify the above claims.  For example:
	* the software publisher itself (_"has my identity been compromised?"_)
	* rebuilders that check for locatability and reproducibility
* **Arbiter<sup>RB</sup>**:<br>
    There's no official body.  Invalidated claims would affect reputation.
