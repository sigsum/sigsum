# Claimant model
## **System<sup>CHECKSUM</sup>**
System<sup>CHECKSUM</sup> is about the claims made by a data publisher.
* **Claim<sup>CHECKSUM</sup>**:
	_I, data publisher, claim that the data_:
	1. has cryptographic hash X
	2. is produced by no-one but myself
* **Statement<sup>CHECKSUM</sup>**: signed checksum<br>
* **Claimant<sup>CHECKSUM</sup>**: data publisher<br>
	The data publisher is a party that wants to publish some data.
* **Believer<sup>CHECKSUM</sup>**: end-user<br>
	The end-user is a party that wants to use some published data.
* **Verifier<sup>CHECKSUM</sup>**: data publisher<br>
	Only the data publisher can verify the above claims.
* **Arbiter<sup>CHECKSUM</sup>**:<br>
    There's no official body.  Invalidated claims would affect reputation.

System<sup>CHECKSUM\*</sup> can be defined to make more specific claims.  Below
is a reproducible builds example.

### **System<sup>CHECKSUM-RB</sup>**:
System<sup>CHECKSUM-RB</sup> is about the claims made by a _software publisher_
that makes reproducible builds available.
* **Claim<sup>CHECKSUM-RB</sup>**:
	_I, software publisher, claim that the data_:
	1. has cryptographic hash X
	2. is the output of a reproducible build for which the source can be located
	using X as an identifier
* **Statement<sup>CHECKSUM-RB</sup>**: Statement<sup>CHECKSUM</sup>
* **Claimant<sup>CHECKSUM-RB</sup>**: software publisher<br>
	The software publisher is a party that wants to publish the output of a
	reproducible build.
* **Believer<sup>CHECKSUM-RB</sup>**: end-user<br>
	The end-user is a party that wants to run an executable binary that built
	reproducibly.
* **Verifier<sup>CHECKSUM-RB</sup>**: any interested party<br>
	These parties try to verify the above claims.  For example:
	* the software publisher itself (_"has my identity been compromised?"_)
	* rebuilders that check for locatability and reproducibility
* **Arbiter<sup>CHECKSUM-RB</sup>**:<br>
    There's no official body.  Invalidated claims would affect reputation.

## **System<sup>CHECKSUM-LOG</sup>**:
System<sup>CHECKSUM-LOG</sup> is about the claims made by a _log operator_.
It adds _discoverability_ into System<sup>CHECKSUM\*</sup>.  Discoverability
means that Verifier<sup>CHECKSUM\*</sup> can see all
Statement<sup>CHECKSUM</sup> that Believer<sup>CHECKSUM\*</sup> accept.

* **Claim<sup>CHECKSUM-LOG</sup>**:
	_I, log operator, make available:_
	1. a globally consistent append-only log of Statement<sup>CHECKSUM</sup>
* **Statement<sup>CHECKSUM-LOG</sup>**: signed tree head
* **Claimant<sup>CHECKSUM-LOG</sup>**: log operator<br>
   Possible operators might be:
	* a small subset of data publishers
	* members of relevant consortia
* **Believer<sup>CHECKSUM-LOG</sup>**:
	* Believer<sup>CHECKSUM\*</sup>
	* Verifier<sup>CHECKSUM\*</sup><br>
* **Verifier<sup>CHECKSUM-LOG</sup>**: third parties<br>
	These parties verify the above claims.  Examples include:
	* members of relevant consortia
	* non-profits and other reputable organizations
	* security enthusiasts and researchers
	* log operators (cross-ecosystem)
	* monitors (cross-ecosystem)
	* a small subset of data publishers (cross-ecosystem)
* **Arbiter<sup>CHECKSUM-LOG</sup>**:<br>
	There is no official body.  The ecosystem at large should stop using an
	instance of System<sup>CHECKSUM-LOG</sup> if cryptographic proofs of log
	misbehavior are preseneted by some Verifier<sup>CHECKSUM-LOG</sup>.
