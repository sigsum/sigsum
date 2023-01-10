# Bastion API v0

**Warning.**
This is a work-in-progress document that may be moved or modified.

## 1 — Overview

In order to be available to logs that are ephemeral, batch-processed, or low latency, witnesses need to expose public HTTP endpoints. However, it might be desirable to run a witness in an environment without a publicly reachable address. This document specifies bastions, services that act as reverse proxies accepting connections from both clients and witnesses and routing requests from one to the other.

The design requires no changes in the client, and can be implemented as an abstraction or even a separate service on the witness side with no changes to the API.

Note that while the design is tailored to witnesses, it doesn’t actually hardcode anything about the witness API. This ensures the API can evolve without waiting for the bastion to update. It also potentially exposes bastions to abuse. It is recommended that bastions apply an allowlisting or registration policy to the witness keys they will serve.

The bastion is in the position of observing and blocking the witness’ traffic, but can’t manipulate it or undetectably block or delay it (due to the timestamps in witness co-signatures and rosters).

## 2 — API

At a high level, witnesses connect to the bastion authenticating with their Ed25519 key and start serving HTTP/2 on that connection. The bastion then proxies all requests that include the witness key in the path to that connection.

This documents uses the same key encoding and hash as the [log API document](https://git.sigsum.org/sigsum/tree/doc/api.md).

### 2.1 — Witness to bastion connection

A witness connects to the bastion’s witness endpoint with TLS 1.3, specifying the ALPN protocol `bastion/0`. Other TLS versions must be rejected, as only TLS 1.3 hides client certificates from network observers. The witness presents as its client certificate a self-signed Ed25519 certificate containing the witness public key. The witness verifies the bastion’s TLS certificate chain like usual. The bastion checks the witness public key against an allow list.

After opening the connection, the witness starts serving HTTP/2 traffic on it as if it was a client-initiated connection. HTTP/2’s multiplexing allows serving multiple parallel requests on a single connection efficiently. None of the witness API is modified, except observing the `X-Forwarded-For` header.

Appendix A presents an example Go adapter that turns a regular witness server into a bastion client.

### 2.2 — Client to bastion requests

The bastion accepts HTTP requests at

```
https://bastion_host/key_hash/path
```

where `key_hash` is the hex-encoded hash of a witness key.

If the witness key doesn’t correspond to any open witness connection, it serves a 502 Bad Gateway response.

Otherwise, the bastion removes _all_ `X-Forwarded-For` headers from the request, adds a single `X-Forwarded-For` header with the IP address of the client, and proxies the request as `/path` over the witness connection. Note that the `key_hash` portion of the path is trimmed.

All caching directives are ignored by the bastion.

## Appendix A — Example Go adapter

```go
func connectAndServe(host string, handler http.Handler, key ed25519.PrivateKey) {
	log.Printf("Connecting to bastion...")
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	conn, err := (&tls.Dialer{
		Config: &tls.Config{
			Certificates: []tls.Certificate{{
				Certificate: [][]byte{selfSignedCertificate(key)},
				PrivateKey:  key,
			}},
			MinVersion: tls.VersionTLS13,
			MaxVersion: tls.VersionTLS13,
		},
	}).DialContext(ctx, "tcp", host)
	if err != nil {
		log.Printf("Failed to connect to bastion: %v", err)
		return
	}

	log.Printf("Connected to bastion. Serving connection...")
	(&http2.Server{}).ServeConn(conn, &http2.ServeConnOpts{
		Handler: handler,
	})
}

func selfSignedCertificate(key ed25519.PrivateKey) []byte {
	tmpl := &x509.Certificate{
		SerialNumber: big.NewInt(1),
		Subject:      pkix.Name{CommonName: "Witness"},
		NotBefore:    time.Now().Add(-1 * time.Hour),
		NotAfter:     time.Now().Add(24 * time.Hour),
		KeyUsage:     x509.KeyUsageDigitalSignature,
		ExtKeyUsage:  []x509.ExtKeyUsage{x509.ExtKeyUsageClientAuth},
	}
	cert, err := x509.CreateCertificate(rand.Reader, tmpl, tmpl, key.Public(), key)
	if err != nil {
		log.Fatalf("Failed to generate self-signed certificate: %v", err)
	}
	return cert
}
```

## Appendix B — Security analysis of reusing the witness key

This design reuses the witness key for a TLS 1.3 client certificate. If domain separation between the handshake signatures and the witness protocol signatures can’t be ensured, there’s a risk of cross-protocol attacks.

TLS 1.3 handshake signatures for client certificates are always applied on messages starting with 64 ASCII spaces followed by the string `TLS 1.3, client CertificateVerify` (see RFC 8446, Section 4.4.3). X.509 signatures are performed over the TBSCertificate ASN.1 STRUCTURE which encoded with DER always starts with 0x30 (`0` in ASCII). The witness protocol universally uses SSH signatures, which format signed messages with the prefix `SSHSIG`. This guarantees domain separation.
