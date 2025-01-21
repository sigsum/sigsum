# Sigsum weekly

  - Date: 2025-01-21 1215 UTC
  - Meet: https://meet.glasklar.is/sigsum
  - Chair: nisse
  - elias took notes

## Agenda

  - Hello
  - Status round
  - Decisions
  - Next steps
  - Other (after the meet if time permits)

## Hello

  - rgdd (async -- not here today)
  - nisse
  - elias
  - filippo
  - ln5

## Status round

  - rgdd: draft of a draft of updated roadmap, entering feedback/discuss phase
    - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/99
    - would like to move towards to decision in 2 weeks from now
    - would appreaciate if filippo resolves TODOs nearby his name, or at least thinks about them and follows up with me $somehow
  - rgdd, ln5: making progress on that witness about page.
    - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2025-01-21-example-witness-about.md
  - rgdd: I shared the above as an example of where we're at at yesterday's first monthly tdev community meet. I also shared the notes from our archive on "shared conf stuff", so that more people know there's some brainstorming progress on it; and that we've been discussing with Al/Martin. And that the current thing we're doing is some early stabs on about pages, which is one part (and it is likely also helpful to extrapolate some common things that maybe not every witness should have to do).
    - https://docs.google.com/document/d/1cQop8_p7-fV5CEO5ADyvLrDGDm8BR79MytMqc0MeAeY/edit
  - nisse: Added and reviewed updates to sigsum-go NEWS file.
  - nisse: Preparing fosdem slides, https://git.glasklar.is/nisse/fosdem-sigsum-2025/-/tree/main
  - nisse: Preparing for sigsum-go release, see https://git.glasklar.is/sigsum/core/sigsum-go/-/merge_requests/224
  - elias: want to solve "Primary is (sometimes) unable to collect cosignature from litebastion+litewitness" https://git.glasklar.is/sigsum/core/log-go/-/issues/101 -- "INTERNAL ERROR" messages
         - nisse says: Al posted a blog link that is possibly related (see issue).
         - TODO elias: add Milan witness to seasalp
  - filippo: pushed litebastion and litewitness v0.4.0
    - https://github.com/FiloSottile/litetlog/blob/main/NEWS.md#v040
  - filippo: discussed log/witness/monitor design with Cloudflare team, especially around Web Manifest Transparency
        - about how to apply in browser
        - hard problem in web setting
        - it must be possible to take over a domain, but old owner should get notified
        - encouraged them to write in transparency dev slack
  - ln5: no status updates

## Decisions

  - None

## Next steps

  - rgdd, ln5: try to push a witness about page towards decision @ glasklar
  - rgdd, ln5: copy-paste on witness about page + minior edits for seasalp log
  - ln5: get a witness up and running before next week's meeting
         - so that we have that done before FOSDEM
  - filippo: help debug log<->bastion errors
  - filippo: vkey spec
  - filippo: review TODOs on roadmap from rgdd
  - elias: add Milan witness to seasalp, maybe also other witnesses not using bastion
  - elias: try debugging log<->bastion errors
  - nisse: Get sigsum-go release out
  - nisse: possibly make log-go release soon also?
       - wait to see if debugging leads to changes in log-go
  
## Other

  - rgdd: thanks elias for looking at the (new?) litebastion issues so far, would be good if this progress doesn't halt. Any input/thoughts from filippo?
    - https://git.glasklar.is/sigsum/core/log-go/-/issues/101
    - nisse: If we don't expect this to be fixed on the bastion side fairly soon, we could consider fixes/workarounds on the log side (e.g., enable http2 keepalive, or close and reconnect on failure, or go all the way down to using http1 only).
  - nisse: go question: I'm confused by "go language version" (e.g., go 1.22) vs "go version" (e.g., go 1.22.2), and which one is supposed to go on the go line in go.mod. The docs seems to use language version everywhere, see https://go.dev/ref/mod#go-mod-file-go. But some modules, notably trillian, use "go 1.22.0", and this issue comment https://github.com/golang/go/issues/62278#issuecomment-1693538776 says that one must use three components on the go line, only exception being if there's also a toolchain line, in which case it's fine to have tree components for toolchain line and only two for the go line.
        - filippo: for a few releases, it was truncated at just the language version
        - filippo: then that was changed
        - filippo: so there was a transition period
        - filippo: if you want 1.23 then you put 1.23.0
        - filippo: we added an alias so that if you write 1.xx it means 1.xx.0
        - filippo: 1.22 was before that usability fix
        - filippo: it helps to think that it works just like a library
        - filippo: to disable toolchain fetching: go env -w GOTOOLCHAIN=local
    - My preference has been to have go.mod in our modules specify just language version but no toolchain version, using a go line like "go 1.22" and no toolchain line. Is that no longer possible/recommended usage? More context: https://github.com/google/trillian/issues/3689.
