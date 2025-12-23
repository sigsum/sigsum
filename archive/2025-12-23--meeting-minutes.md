# Sigsum weekly

  - Date: 2025-12-23 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: filippo
  - Secretary: florolf

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - gregoire
  - filippo
  - florolf
  - rgdd

## Status round

  - filippo: Published "Building a transparent key server" blogpost
     - https://words.filippo.io/keyserver-tlog/
     - tlog-proof v0 landed for this
        - http://c2sp.org/tlog-proof
    - nice story: tessera, VRFs, witness network
    - feedback from andrew ayer (https://transparency-dev.slack.com/archives/C05VB0YG8SW/p1766174959540959?thread_ts=1766153964.377389&cid=C05VB0YG8SW)
    - no freshness checks - because of the incremental approach taken in the post
    - minority policies
    - we really need to figure out fetching checkpoints from witnesses too
       - or have the log collect signatures
    - somewhat decent HN discussion: https://news.ycombinator.com/item?id=46326506
    - sigsum/tessera policy parser in torchwood (with vkeys)
      - https://github.com/FiloSottile/torchwood/pull/34
      - some trickiness involved with making sure checkpoint origins match what is expected from the policy
  - gregoire: some work on per-log bastions
  - gregoire: some progress on rust implementation, can now parse policies
  - florolf: wrote generator for compiled prolicy/proof formats
    - https://github.com/florolf/spic/tree/master/doc
    - smaller formats for microcontroller-like scenarios
  - rgdd: review and rubber-ducking, not much else

## Decisions

(none)

## Next steps

  - filippo: add read API to tlog-witness
  - rgdd: Holiday, progress on the witness blog post, redeploy witness using new Ansible with per log bastion support
  - florolf: verifier for the compiled format
  - florolf: blog post for SSH transparency presented at tdev summit
  - gregoire/william: Maybe some work on per log bastion. Rasmus will also sync with William about this

## Other

  - Reminder: Next two meetings have been canceled! Next meeting: 2026-01-13
  - litebastion: allow listening on !localhost https://github.com/FiloSottile/torchwood/issues/42
    - This was intentional originally to avoid exposing non-TLS. But might not be too dangerous though.
  - litebastion: allow starting without witness: https://github.com/FiloSottile/torchwood/pull/43
    - Merged already!
  - litebastion: bring-your-own-cert? (Issue TBD)
    - ACME client doesn't run when started in a particular way
      - https://github.com/FiloSottile/torchwood/issues/47
    - Mullvad uses dns-01 for everything else so injecting a cert externally would be helpful
      - No strong preference here and litebastion needs TLS exposed anyway for bastion ALPN stuff
    - IP allowlisting interferes with LE
