# Design of a validating witness proxy

author: nisse (based on lunch discussion the other day)

## Using a bastion

The reason a witness may want to use a bastion is to avoid having
an open and publicly visible address on the Internet. To avoid DoS
attacks or worse, and making the witness simpler to operate.

Using a per-log bastion is attractive, since that means that only
configured logs will be able to contact the witness at all, and if a
log's bastion misbehaves in any way (perhaps the bastion endpoint is
inadvertently exposed to the Internet and spammed), the witness can
disconnect from that bastion, and keep serving other logs.

The drawback with per-log bastion is that in some cases it is a
potential scalability problem. If the witness wants to serve a huge
number of logs, but each log asking for cosignatures rarely, then
maintaining open connections to one bastion per log may be a
significant overhead.

Using a third-party bastion, like bastion.glasklar.is is more
scalable, but with the current bastion server, it doesn't provide much
protection for the witness. The bastion is open to the Internet, and
anyone can send arbitrary HTTP requests to the bastion which will
happily forward them back to the target witness.

## Can the witness delegate more of DoS protection to the bastion?

It's possible to extend bastion protocol to let a witness configure
communication limits, e.g., saying how much traffic it is willing to
accept, and allow-list/ban-list of IP address ranges. We quickly get
into general DoS-protection territory.

## Witness proxy

We could do better if the bastion acts not only as a HTTP proxy, but
as a proxy for the witness protocol. If we explore this direction, the
proxy should do everything a witness does, except for the actual
signing. It could work like this:

The proxy has little persistent configuration, basically it needs the
public keys of the witnesses it wants to serve (same as current
bastion server).

When the witness connects to the proxy, it tells the proxy its config
and state: For each log the witness is willing to cosign, it tells the
proxy

* the log's origin line and public key,

* how often (e.g., at most once every 10 s) the witness is willing to
  cosign that log,

* the witness' current state for that log, i.e., size and root hash.

The proxy then starts receiving requests on the witness' behalf, just
like a bastion. But unlike the current bastion, it doesn't simply pass
on all requests. It first validates each request, by checking the
log's signature and consistency proof, and applying rate limits. The
proxy responds with 403, 404, 422, 429 as appropriate. Only requests
that pass validation are passed back to the witness for cosigning, and
the proxy updates its corresponding state for the log based on the
response from the witness.

One potential problem that may pass validation is add-checkpoint
requests with unchanged size, since anyone that gets a log's current
checkpoint can produce valid such requests and attempt to spam
proxies.

## Deployment

Ideally, a witness proxy could be implemented as some kind of
application plugin to a more general purpose proxy intended for
DoS-protection. A witness operator could arrange (or buy) service from
several public public proxy servers, in the same way as it could use a
third-party bastion. Logs would need to know all proxies for the
witness, to get robustness in case some of the proxies are down. This
could be handled with a single witness URL and DNS-based
redirection/load-balancing, with a domain name controlled by the
witness operator, and multiple A/AAAA/SRV-records pointing to all
configured proxies for that witness.
