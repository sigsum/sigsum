# host/tkey protocol for the sign-if-logged-app

## Prototype protocol

The prototype (see https://git.glasklar.is/nisse/tkey-sigsum-apps)
uses the tkey framing protocol.

In all states, it accepts `DST_FW` messages and returns NOK response.

For `DST_SW` packets, it uses a protocol with the following states and
messages. The app crashes on any message not appropriate in that
state.

* `STATE_INIT` (initial state, obviously)

    - Accepts `CMD_INIT_POLICY` (0x01, len 32)
    
    The packet contains one byte with desired signature mechanism
    (Ed25519 or ECDSA, with or without touch), and two bytes
    (little-endian) with the size of the policy blob. Transitions to
    `STATE_RECV_POLICY`. Max blob size is 10000 bytes. 
    
    - Crashes if algorithm is unknown, or size is zero or too large.
    
* `STATE_RECV_POLICY`
    
    - Accepts `CMD_LOAD_POLICY`  (0x03, len 128)
    
    The data (up to 127 bytes) is copied into a buffer.
    When more data is needed, returns status byte 1 in response body,
    and remains in this state.
    
    When the blob buffer is filled (of size as specified in the
    `CMD_INIT_POLICY` packet), the blob is parsed. Its format is
    
        - one byte with number of submitter keys
        - followed by an array of 32 byte submitter pubkeys, which
          must be sorted by key hash.
        - followed by a compiled policy blob (starting with its 4-byte
          header), see
          https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2025-09-12-sketch-compiled-policy.md
        - there must be no left-over bytes.
        
    If parsing fails or sizes exceed app limits, the app crashes.
    
    On success, a signing key for the desired signature algorithm is
    derived, and the app returns a status byte of 0 in the response
    body. The key derivation depends on the algorithm type and the
    policy blob.
    
    The led color is switched from green to blue, and app transitions
    to state `STATE_READY`.
    
* `STATE_READY`

    - Accepts `CMD_GET_PUBKEY` (0x05, len 4)
    
    Responds with the public key, prepended with the type byte.
    Remains in this state.
    
    - Accepts `CMD_INIT_MSG` (0x07, len 32)
    
    The packet contains a 4-byte little-endian size for a proof +
    message blob. The app crashes if the size is outside of the range
    0 < size <= 10000 (same as for the policy blob). Transitions to
    the `STATE_RECV_MESSAGE` state.
    
* `STATE_RECV_MESSAGE`

    - Accepts `CMD_LOAD_MSG` (0x09, len 128)
    
    The blob is receieved in the same way as the policy blob,
    remaining in this state and returns status byte 1 in response
    body, until the blob is completely received.
    
    When the blob buffer is filled, the blob is parsed. It starts with
    a sigsum proof, in this format:
```
offset size value
 0   32 log_key_hash
32   32 submitter_key_hash
64   64 leaf_signature
128   8 tree size (little-endian)
136  32 root hash
168  64 log signature
232   8 leaf_index (little-endian)
240   1 cosignature count
241   1 path length
242 ---------------------
 Followed by cosignatures, each
  0   8 timestamp
  8  32 key_hash
 40  64 signature
104 ---------------------
 And path, each 32 bytes.

 Total max size: 178 + 16*104 + 63*32 = 3858
```
    The message to be signed is everything between the end of this
    proof, and the end of the blob. The app crashes if parsing fails.
    
    Next, the app hashes the message once, and attempts to verify the
    proof using the previously configured submitter keys and policy.
    
    If verification fails, a status byte of 0xff is returned in the
    response body, and the app transitions back to state
    `STATE_READY`.
    
    If verification succeeds, the app returns a status byte 0 in the
    response body, and transitions to `STATE_SIGNING`.
    
* `STATE_SIGNING`

    - Accepts `CMD_GET_SIG` (0x08, len 4)
    
    The app waits for a touch event if that is required for the
    configured signature type. On timeout (or other signature failure)
    it remains in this state and returns a status byte 1 in the
    response body.
    
    On success, the response is a status byte 0 followed by the
    signature. The app transitions back to state `STATE_READY`.

## Desired improvements

### Error handling

The app should not crash on all invalid or unexpected input, but
instead return an error response to the host.

It would be nice with a more structured error handling, and a
convention for returning an error message to the host.

### State machine

Should the `STATE_READY` accept a new `CMD_INIT_POLICY`? That would
then wipe both the current policy and the derived key, and return to
`STATE_INIT`.

Should it be possibly to abort the load operations, by sending a
different command than `CMD_LOAD_POLICY` and `CMD_LOAD_MSG` ?

It would be nice with a way for the host to query the current state,
and maybe also query the current policy (or at least a hash of the
policy)?

Should we have a timeout, returning to an initial state if host stays
silent for a long time? It would be nice to have some kind of recovery
(besides removing the tkey and reinserting it) if host and device get
out of sync, e.g., because the host program crashes in the middle of a
message.
