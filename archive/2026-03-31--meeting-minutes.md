# Sigsum weekly

  - Date: 2026-03-31 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: nisse
  - Secretary: elias

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - rgdd
  - elias
  - tta
  - filippo
  - nisse
  - florolf

## Status round

  - rgdd: poc.rgdd.se upgrade to ansible v1.6.0; and now also v1.7.0 even though those changes should affect my deploy (and worked as expected).
  - rgdd: new tlog-cosignature release
    - https://C2SP.org/tlog-cosignature@v1.0.1
  - rgdd: new tlog-witness release
    - https://C2SP.org/tlog-witness@v1.0.0
  - rgdd: new 100qps-40klogs staging list in witness network
    - https://staging.witness-network.org/log-list-100qps-40klogs.1
    - 1) call for witnesses that can configure this list
    - 2) lists are meant to be non-overlapping
      - witnesses configure the union of lists they can support
      - start with lower performance profiles and move upwards
    - 3) context for the above: getting several 1qps participating requests
      - so we needed something that doesn't congest the 10qps list too quickly
    - More details: https://github.com/transparency-dev/witness-network/pull/37/commits/756da52c519a33bc1b1138ecb13616e55ad2cab4
  - rgdd: some yubihsm and tkey Ed25519 signatures/s pointers in other sect
    - thanks sasko & elias!
  - rgdd: related to the above benchmarks, ongoing discuss if/how we could support a cluster of TKeys or YubiHSMs to get up the signatures/s. See:
    - https://github.com/FiloSottile/torchwood/issues/66
    - thanks nisse!
  - rgdd: if anyone else has input on selection of Go version, input is appreaciated
    - https://git.glasklar.is/sigsum/project/documentation/-/work_items/96
  - rgdd: reminder that the current roadmap ends mid april
    - i'd like to get a new roadmap decided april 21
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/142/diffs
    - ^: added a placeholder for this based on where we're at right now
    - (Also discussed briefly with nisse on priority log-signer vs witness-signer; that we will maybe need some TKey like key-mgmt docs/tooling once we have a signer we want to support; and a bit about witness-signer design trade-off.)
      - Few words about this
  - nisse, rgdd: tlog-policy @ c2sp is now brewing (ben reached out to us)
    - https://github.com/C2SP/C2SP/issues/226
    - filippo: I think there are already two implementations of that (sigsum policy but with vkeys):
      - tessera
      - torchwood
      - there is also the implementation by ben (in rust, for project oak)
      - filippo: I think "tlog-policy" is a better name
        - rgdd: oh, but that is the suggestion
        - rgdd: it should be called "tlog-policy"
  - elias: sigsum ansible v1.7.0 released:
      - https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-announce@lists.sigsum.org/thread/7NSJW7SSAWNS5HPUXCQF3FL22QWKMPYD/
      - includes option for installing yubihsm-connector through a .deb file
  - tta: still in the process of figuring out how "archive transparency" can work
    - looks like sigsum can be used
  - florolf: 
  - nisse: worked on adding ssh signature support in sign-if-logged
  - filippo: conference went pretty well
  - filippo: interesting things from the transparency side
    - gave a lightning talk, it's recorded, on youtube
      - https://www.youtube.com/watch?v=8NzsrVR2gMo
      - tlogs for AT-proto collections
        - data of a certain type owned by a certain user
        - can tlog information related to that
        - expect more apålications to be built on top of AT-proto
        - nice if tlog functionality is available
        - funding can come from bluesky
      - second thing: had conversations with people who were interested in tlogs
        - there might be academic institutions in Europe who might want to run witnesses because of identity mechanism used by bluesky
        - bluesky is a company
      - MLDSA cosignatures
      - a useful thing to be aware of:
        - two new papers related to quantum computing
          - https://arxiv.org/abs/2603.28627
          -  https://research.google/blog/safeguarding-cryptocurrency-by-disclosing-quantum-vulnerabilities-responsibly/
          - looks like quantum computers are coming
      - a very common thing you end up needing is: some way of putting a hash in the merkle tree leaf for anti-poisoning
        - you want to put something behind a hash so that you can redact it without killing the whole tree
        - it would be nice to have reusable tooling
          - rgdd: more about this in the Other section?
          - tta: i have brain worms related to this when working on archive trans
  - florolf: started to look at the sign-if-logged code, will look more later
  - florolf: I setup a litebastion and used it for something else (not a witness)
    - it's working
    - one surprising thing was that there was a limit at 10 kBytes per request
      - could make sense to have that configurable
    - rgdd: regarding sign-if-logged, it's about to be tagged now

## Decisions

  - None

  (meeting next week will happen as usual)

## Next steps

  - filippo: get nisse's outstanding tlog-proof MR merged
    - https://github.com/C2SP/C2SP/pull/193
    - anything else that should be ported to tlog-proof?
    - context: rgdd would like to see this move forward before next roadmap update
  - filippo: take a look at accepting tlog-policy as a c2sp spec
  - filippo: ML-DSA cosignature, draft + circle
  - filippo: tlog.directory page (erik's TODO)
  - rgdd: possibly work on a blog post about sign-if-logged with nisse
  - nisse: more work on sign-if-logged and tlog-policy spec
  - nisse: first draft on tlog-policy
  - elias: per-log bastions for glasklar logs

## Other

  - nisse: fyi: Another rust implementation of sigsum-ish policy
    - https://github.com/project-oak/oak/blob/main/tr/c2sp/policy.rs
  - >1 yubihsm / tkey etc support in litewitness? Discuss?
    - nisse: we would like to be able to do several signing operations in parallel
    - nisse: the ssh agent protocol should support this, pipelining
    - nisse: ssh agent just requires that responses are returned in order
      - filippo: thinking about where that change could be done and how disruptive it would be
      - nisse: currently there is a lock
      - filippo: so in theory we could change it to use pipelining
      - filippo: do you know that the yubihsm can do this?
      - filippo: do you know that the time for each signature is reliable enough?
        - rgdd: reliable, deterministic, but you have to properly load-balance it
      - rgdd: if we get this working it could work for both yubihsm and tkeys
      - filippo: do you min opening an issue in the Go issue tracker about pipelining, and adding me and Nicola (@drakkan)?
        - https://github.com/golang/go/issues
        - then we can think about how much work it would require

### Some performance numbers for TKey and YubiHSM

Quick benchmarks for TKey (Sasko), YubiHSM (elias), and YubiHSM (yubico website).

#### TKey Castor (ssh sign app)

```
Summary
-------
Total measured operations : 100
Total elapsed time        : 30.903831 s
Average latency           : 308.927742 ms
Median latency            : 308.738313 ms
Min latency               : 307.728750 ms
Max latency               : 317.956000 ms
Stddev                    : 1.081018 ms
Signatures per second     : 3.235845
```

#### TKey Bellatrix (ssh sign app)

```
Summary
-------
Total measured operations : 100
Total elapsed time        : 46.563787 s
Average latency           : 465.533175 ms
Median latency            : 465.503438 ms
Min latency               : 464.614667 ms
Max latency               : 466.873792 ms
Stddev                    : 0.243327 ms
Signatures per second     : 2.147592
```


#### YubiHSM (get the same checkpoint cosigned again with new timestamp)

TL;DR: ~9.5 cosignatures/s

See:

https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2026-03-26-witness-performance-test.md?ref_type=heads

### YubiHSM 2 docs

TL;DR: 8-9 Ed25519 signatures/s for the message sizes we're interested in.

https://support.yubico.com/s/article/YubiHSM-2--A-load-balanced-design-for-heavy-traffic-environments
