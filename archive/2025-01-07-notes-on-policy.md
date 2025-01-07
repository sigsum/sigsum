A few half baked ideas / notes by rgdd on trust policies and named trust
policies.

---

Suppose each trust policy says which index (per log) it starts from.

```
policy.1  # FROM_INDEX=100
policy.2  # FROM_INDEX=200
policy.3  # FROM_INDEX=300
policy.4  # FROM_INDEX=450
```

And we have some proofs with these indices:

```
PROOF.103  # index 103
PROOF.204  # index 204
PROOF.504  # index 504
```

For each proof:

- Find all policies that list the log PROOF is valid for
- Select the *first policy* where .INDEX >= .FROM_INDEX

Example:

- For .103 -> use .Q1
- For .204 -> use .Q2
- For .504 -> use .Q4

Configure which policy to use:

```
sigsum_policy="...syntax to name policies" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM1WpnEswJLPzvXJDiswowy48U+G+G1kmgwUE2eaRHZG
sigsum_policy="...syntax to name policies" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAz2WM5CyPLqiNjk7CLl4roDXwKhQ0QExXLebukZEZFS
```

And sigsum-verify (or other things that read these keys) know how to locate
trust policies based on the passed names/syntax.

---

```
log VKEY FROM_SIZE URL

witness VKEY_X1 witness VKEY_X2 witness VKEY_X3 group X-witnesses 2 VKEY_X1
VKEY_X2 VKEY_X3

witness VKEY_Y1 witness VKEY_Y2 witness VKEY_Y3 group Y-witnesses any VKEY_Y1
VKEY_Y2 VKEY_Y3

group X-and-Y all X-witnesses Y-witnesses quorum X-and-Y
```
