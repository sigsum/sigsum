# Sigsum weekly

  - Date: 2026-09-29 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: elias
  - Secretary: quite

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - <insert nickname here>
  - elias
  - gregoire
  - quite

## Status round

  - <insert status report here>
  - elias: new cert for Sigsum's onion website
    - linked at bottom of https://www.sigsum.org/
      - https://er3n3jnvoyj2t37yngvzr35b6f4ch5mgzl3i6qlkvyhzmaxo62nlqmqd.onion/ (use Tor browser)
  - elias: was at repro-builds summit last week, discussed transparency logging there
    - interest from Arch Linux folks related to their Signstar project
      - https://signstar-fda89a.archlinux.page/
      - https://gitlab.archlinux.org/archlinux/signstar
      - will be interesting to approach them further to discuss what tlogging of signing key usage can mean for them, and for people relying on signed artifacts.
      - they have used the term "attestation" but not entirely clear what they mean with that. can be comparable what a sigsum proof entails, given append-only witnessed log.
      - arch linux currently has a archlinux-keyring package installed on the systems, containing pubkeys of individual pkg maintainers that have signed distribution pkgs. There are updates now and then to this pkg. A transition to using sigsum proofs would mean that a sigsum policy would instead be packaged and used for verification of pkg proofs. The policy will still need to contain signing pubkeys (but they will probably be much fewer, due to their current redesign); the procedure for that is already there.
  - quite: have rewritten my stuff in litewitness, and got some things merged in sigsum-agent
    - regarding MLDSA signatures, possibly combined with parallel signing by multiple HSMs
    - next step is to deploy on a testing/staging witness
      - to test this, it would be neat to have a log which understands mldsa44 cosignatures. tessera is possibility. making adjustments to sigsum-go is another.

## Decisions

  - <insert proposed decision here>

## Next steps

  - <insert next steps here>
  - quite: will try to see how we can test out the mldsa changes
  - gregoire: sigsum verifier in Mullvad VPN apps, soon-ish
    - at first it will be fail-open
    - what is logged is (indirectly) like a hash of a timestamped vpn relay list

## Other

  - <insert other discuss topic here>
  - gregoire: is there something like a "fuzzer" (not exactly) that generates e.g. proofs that are slightly wrong, to test that verifier software works properly?
    - good question, something like that would be useful

