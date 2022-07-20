# Proposal

Replace the "domain_hint" key in the input to the add-leaf endpoint with
"rate-limit".  The value associated with the "rate-limit" key is on the format:

    method:data

where the defined methods are:

  - dns: the exact same semantics as today's domain hint
  - token: a shared secret that is negotiated between submitter and the log
    operator out-of-band

Example of a rate-limit line using DNS:

    rate_limit=dns:_sigsum_v0.example.org

Example of a rate-limit line using token:

    rate_limit=token:xxxxxxxxxxxxxxxxxxxxxx

The "rate_limt" key must not be repeated.

The "rate_limit" key may be omitted.  It is then up to the log server to accept
or reject the user's requests.

# Motivation

There are more ways to establish something to rate-limit on than domain hints.
The name "domain_hint" is also not descrptive; it makes understanding harder.

It is also plausible that a log operator wants to run without a rate limit in
some environments.  The above change permits this as well.
