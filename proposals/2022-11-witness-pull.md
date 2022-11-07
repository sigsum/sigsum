# Witness communication patterns

## Background

Logs produce self-contained proofs that can be verified offline by clients. To do this they need to obtain and include in the proof co-signatures on the tree head produced by a quorum of witnesses trusted by the client.

Witnesses need to be operated by trusted, reliable entities with minimal churn. Log deployments pick a witness trust policy that gets deployed into clients and might be difficult or impossible to change. Developing a healthy ecosystem of witnesses might be the biggest hurdle to widespread tlog success. It’s impractical to build a separate witness ecosystem for each application, so it’s important that witnesses be public, interoperable, and scalable. As for quantity, there should be more than a few, but once reached a critical mass (maybe 10?) each additional witness has sharply diminishing marginal value.

Logs, on the other hand, should be possible to tailor to the application. There will be low-latency, highly scalable logs like the Go Checksum Database; offline logs such as a hypothetical Debian tlog; public logs like Sigsum. Additional log deployments don’t have diminishing returns, and are a desirable goal.

Clients never communicate directly with the witnesses, logs do. This document explores two different ways that communication channel can be structured, and their trade-offs.

## The push model

In the _push_ model, witnesses are configured with a list of log keys and publicly reachable endpoints. They periodically retrieve the latest (pending?) tree head, verify a consistency proof, and upload a co-signature to the log.

This is the current model employed by Sigsum.

### Pros

Witnesses don’t need to expose a public endpoint, which simplifies deployment, and makes it easier for smaller organizations to run a witness.

### Cons

Logs need to have a reachable public endpoint, meaning they can’t be operated from a CI system, or through a cronjob. This would rule out deployments like the hypothetical Debian tlog, or small self-managed deployments for rarely produced artifacts, like firmware images.

The log entry leaf insertion latency is dominated by the period between producing a new STH and waiting for enough witnesses to reach out and return a co-signature. Concretely, this will be in the order of 1-5 minutes, ruling out any low-latency use case.

Witnesses have to make a request per log per period, regardless of whether the log is actively producing new STHs or not. This reduces how many logs a witness can service, assuming most logs are not very active.

## The pull model

In the _pull_ model, a witness exposes a single HTTP endpoint, where it accepts a signed tree head along with a consistency proof, and provides a co-signature in the response after persisting the new STH.

### Pros

This enables low-latency and offline logs, as detailed above.

### Cons

The witness needs a public HTTPS endpoint. Note that the endpoint is extremely simple: the size of the body and the request duration can be strictly limited and processing a request requires very little resources. It’s also acceptable for the overall system security goals if the witness endpoint uses a centralized DDoS protection service: the data and metadata exchanged is not private, and is signed by pre-established keys.

## The trade-off

Fundamentally, this is a balance between making it easier to run a log or making it easier to run a witness.

Witnesses need to be easy enough to run that a healthy ecosystem can be built, but don’t need to be any easier than that: more witnesses don’t unlock more use cases.

Instead, if running a log doesn’t require a public endpoint, or if low-latency operation is possible, it becomes possible to use tlogs for more and more applications.
