# Sigsum weekly

- Date: 2025-08-12 1215 UTC
- Meet: https://meet.glasklar.is/sigsum
- Chair: rgdd

## Agenda

- Hello
- Status round
- Decisions
- Next steps
- Other (after the meet if time permits)

## Hello

- rgdd
- filippo

## Status round

- rgdd: paging in witness configuration that we sketched out before the holidays
  - litewitness, config of list could be a cronjob
  - subcommand of witnessctl, then run that command in cron job
- filippo: TDS program committee stuff, review
- filippo: thinking about entry points, spicy (going through RWC notes); and
  couple of interesting chats with Al. CT's dual role - is CT about capturing
  everything CAs may need to be held accountable, or capturing everything
  monitors might care about because they're trusted by clients.
  - Let's talk more about it in the other sect.
- filippo: also talked about how a tlog of git pushes would work if we tried to
  pitch that to the new code forges
  - also other sect topic
- filippo: optional additional reduced functions for verifiable indexes
  - also other sect topic

## Decisions

- None

## Next steps

- rgdd: witness configuration prototype
- rgdd: check what elias queued up as needing input while i was on vaccay
- filippo: checkout log list format (not set in stone)
  - https://git.glasklar.is/rgdd/witness-configuration-network/-/blob/main/docs/log-list-format.md
- rgdd: schedule virtual walk with filippo next week
- filippo: martin is blocked on me on generting proofs of inclusion for
  verifiable indexes, planning to contribute that.
- filippo: gophercon UK, probably won't have that much time this week
- filippo: merging the names tiles in sunlight
  - https://groups.google.com/a/chromium.org/g/ct-policy/c/5T0VUHVghuU
- filippo: TDS reach out based on program committee TODOs
- filippo: merge vkey signed-note PR

## Other

- Feedback from Tillitis on their experience of setting up a Sigsum Witness:
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2025-07-02-witness-setup-feedback.md
- Proposal about named policies:
  - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/proposals/2025-07-named-policies.md
- Would be nice to get vkey things merged in c2sp
  - https://github.com/C2SP/C2SP/pull/119/files
- CT names tiles
  - main reason want to try it: might take bandwidth below gbps threshold, makes
    it harder to get log operators. 1gbps is much cheaper than e.g. metered 10
    gbps.
  - if it's easy enough, people want to go straitgh to the source; instead of
    depending on a thing in the middle which might break or start charging.
- CT dual roles and refuse logs
  - endless debate, accept everything (cuz we want to look at it); or reject
    badly formatted certs. In this way clients will not trust them and
    everything is good.
  - people will point out some clients don't support CT...
  - CAs component not malicious...lots of different points
  - team maintaining forks of crypto x509 - behind 5 years on upstream
  - on the other hand, chrome wants to keep accepting sha1 signed certs; if ca
    signs something with sha1 we want to know
  - ...endless tension
  - let's split the baby?
  - we only log things that work with the x509 crypto lib (strict)
  - no fork at all, can remove flagged poisoned extensions as handled before
    invokving the verifier
  - it will still parse - and *details* ... don't need a fork
  - but loses visibility chrome cares about
  - everytime we reject a cert, we check if its valididly signed by any
    intermediates public key -> put it in a separate log, and it's only for root
    programs to look at.
  - if something bad ends up there -> log can just be rotated
  - that one we don't even use x509, we just carefully pull out the signature
    and issuer common name with the most lax asn1 parser we can find; and if the
    signature verifies off it goes.
  - rgdd: love that idea
  - should the other log be signed?
    - it's kind of like reporting something a user found to a trusted party
    - kind of want a "report to $trust party" function
    - doesn't necessarily have to be a tlog
  - maybe just don't produce tiles or anything, just a list of json lines single
    file and if it grows to big -> then worry about it
  - maybe rolling window for how long things are shown, configurable
  - maybe this is /trash endpoint, with latest entry and /trash/1, /trash/2
  - this is again a policy-less optional addition, just like names; you don't
    have to run it
  - bet we will find some stuff that's rejected even by the current lax code
  - this also becomes a place to send intermediates that have not been logged
    yet
  - philippe will write an email to discuss the problem of the fork, then
    filippo will scoop in
  - largest bucket of keys per common name?
    - 5 -> we're fine
    - 120 -> ehh maybe a bit risk of bad cert submit (malicious) -> consumes
      lots of resources for the log
  - intentionally incomplete chain -> could get into spam, risk. So we should
    automatically complete chains when necessary.
    - take a leaf
    - strip out the chain
    - send it to you
    - will you accept it for sct?
      - no, no chain
    - but certificate parsed, then why put it in the trash?
    - because e.g. sha1 = will still parse
    - server auth certificates helps a bit here to not get too much stuff in the
      trash
    - server auth only; with upstream verifier
      - pass => off it goes into ct log
    - then have to verify with same parser and same rules, but accepting any
      extended key usage (EKU) => passes -> neither in the trash nor in the ct
      log
      - means it's a known server auth certificate
      - problem: probably some intermediates that issues valid ct server auth
        certs, and email smime certs that contain gdpr private data
      - (not having this ins a tlog -> easier to correct in the future)
    - anything that fails that too -> then we apply the trash check
  - Filippo will think more about the details offline
- git pushes log
- Custome reduce functions for Verifiable Indexes
