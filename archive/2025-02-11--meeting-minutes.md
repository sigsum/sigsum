# Sigsum weekly

  - Date: 2025-02-11 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: elias
  - Notetaker: ln5

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - elias
  - CC
  - nisse
  - filippo
  - ln5

## Status round

  - elias: looking for feedback on preliminary thoughts on trust policy management
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/elias/2025-02-01-trust-policy-thoughts/archive/2025-02-01-elias-trust-policy-notes.md
  - recording from nisse's fosdem talk has been published
	  - https://video.fosdem.org/2025/ub4132/fosdem-2025-5661-sigsum-detecting-rogue-signatures-through-transparency.av1.webm (also .mp4, and some mirror system)
  - elias: Suggestion for how to add incident info in seasalp timeline
    - https://git.glasklar.is/glasklar/services/sigsum-logs/-/merge_requests/3
  - nisse: Looking into sigsum-logged "OS packages" (aka ST images),
    to be implemented in ST after ongoing release work
	- nisse: Considering playing a bit with Elixir (a "modern"
      language on top of the Erlang VM) for a third implementation of
      witness and/or second implementation of bastion.
  - ln5: witness.g.is cleanup and docu (almost done!)
     - pubkey still needs to be published
  - filippo: had a chat w/ TF the other day and I think that we should
    become better at communicating "the Sigsum abstraction" -- that
    each submission key kinda builds its own tlog; 
	- perhaps improve the age release documentation
    - the design notes from CATS might have some text
    - the latest libtasn release, by jas, might help too
    - checksum says what is being logged, while the submission key says who logged it
    - "multiplexing" might be a useful word
    - would be valuable with some text and perhaps a picture or diagram to go with that

## Decisions

  - DECISION: Next weekly, on the 18th, is canceled due to the
    February Sigsum/ST meetup in Stockholm happening then.

## Next steps

  - filippo: a few maintenance items on litewitness and litewitness
  - filippo: trust policies
    - when changing the trust policy, should proofs be regenerated?
    - how do we rotate trust policies? create new proofs? or just new
      witness cosignatures? We need to document these things.
    - there could be a test witness policy
  - filippo: age, make that ready as an example of how to use sigsum
  - elias: incident info in seasalp
  - ln5: last touch on witness.gi.s docu
  - ln5: look harder at litewitness /logz

## Other

  - litetlog issues -- status?
     - litewitness: SIGSEGV: segmentation violation: https://github.com/FiloSottile/litetlog/issues/24
       - nisses PR looks like it might be the right approach
     - litebastion: "HTTP/2 transport error" with type=recv_rststream_INTERNAL_ERROR - https://github.com/FiloSottile/litetlog/issues/23
     - litebastion and litewitness: need a way to disable logs exposed at /logz endpoint - https://github.com/FiloSottile/litetlog/issues/22
       - will be redacting IP addresses, pls speak up if you know of any other sensitive content that should be redacted as well
       - litewitness is not meant for being run anonymously
       - avoid surprise for operators is important, so documenting expectations is needed
       - ln5 will look closer at a log and think about the implications, from an operator pov
       - /logz contains the same data as the journal at debug level
  - elias: discuss trust policy management? see https://git.glasklar.is/sigsum/project/documentation/-/blob/elias/2025-02-01-trust-policy-thoughts/archive/2025-02-01-elias-trust-policy-notes.md
	  - nisse: Some items to keep in mind
			* We need robustness to both witnesses becoming compromised, and witnesses being offline. Our docs are not very clear on how a single threshold is intended to cover these two cases.
			  - elias: perhaps there is an advantage in not separating those cases, for simplicity? either a witness is up and honest, or not? I'm not sure.
			* A compromised witness has incentive to stay online, but may be signing additional inconsistent views.
			* A witness that appears offline may be used to *honestly* sign a different view, inconsistent with ours. 
			* I.e., a split view attack will involve a compromised log, any compromised witnesses, as well as the *honest* witnesses, each assigned by the attacker to cosign attacker's choice of view.
    - the meeting concludes that the description and reasoning make general sense
    - there are many diversity dimensions, like geographic and legaslitive regions, operating systems, witness implementations
    - "fail close" systems require stable availability over time above all
  - elias: should we announce more clearly that new people are welcome to join these meetings?
    - sigsum homepage says it's an open meeting but we could mention it when sending reminders to the room/channel
  - there's age in browsers now/soon: https://github.com/FiloSottile/typage/pull/28
