# Sigsum weekly

    - Date: 2024-11-19 1215 UTC
    - Meet: https://meet.glasklar.is/sigsum
    - Chair: nisse
    - Notes: rgdd

## Agenda

    - Hello
    - Status round
    - Decisions
    - Next steps
    - Other (after the meet if time permits)

## Hello

    - rgdd
    - elias
    - nisse
    - ln5
    - filippo

## Status round

    - rgdd: first round of notes on shared configuration for logs/witnesses
        - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/93
        - input wanted, e.g., happy to take feedback in the other section today
    - rgdd: typed up a short proposal on bridging our matrix with a tdev slack room
        - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/92
        - please take a look, would like to work towards a decision *next weekly*
    - rgdd: tried to get a better feeling for ansible modules --
      "hello world" using python (which probably gives best
      portability?) that runs with molecule below.
        - https://git.glasklar.is/sigsum/admin/ansible/-/commit/e2283bc485b56d894a9e391567747586ba11100e
        - (I looked at this mostly out of curiousity, and because it
          feels like having a few sigsum modules for submit, publish,
          verify, and perhaps 'download + verify' could be interesting
          at some point in the future. It should be possible to write
          modules without python, but then binaries with the right
          interfaces need to be distributed. Not sure if that is much of
          an improvement compared to just writing ansible tasks that,
          e.g., use our Go tools via ansible.built.shell.  So, didn't
          dig further into that.)
    - rgdd: still looking for comments on things we would consider in a sigsum/v2
        - https://pad.sigsum.org/p/19fe-e132-b60b-7a47-7839-c8b9-96e3-52c9 (do not persist yet, still being circulated)
    - elias: started looking at and testing litewitness ansible role
    - ln5: hw for a seasalp witness is waiting for being picked up at the postal office
    - nisse: proposals (see below) and working on vkey converstions in tools
    - filippo: go freeze in two days, so been busy with $that (and
      that's what i've been focusing in the past weeks). So two days
      from today can switch back and pick up backlog here.
    - filippo: heard about trustfabric team's side on log of logs / witness configuration. Let's talk more in the other section.

## Decisions

    - Decision to not do at this point: Use log origin in sigsum proof
        - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/91
        - For discussion, I'd expect today's outcome to be either "no" or "further discussion".
        - rgdd: leans towards "no", see MR comment
        - filippo: agrees with rgdd, keep as is and consider c2sp in the future
    - Decision: Add vkey conversion tools
        - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/89
        - a bit fluffy, wrote it up to ge feedbackn user interface design
        - boiled down a bit to just start with from-vkey and to-vkey subcommands in sigsum-key
        - question: naming? "vkey" not in any normative text, just in code examples (as far as nisse has found). Is this the name we should be using?
        - filippo: scimmed through proposal, didn't have time to think
          through the names and operations. But generally seems like a
          good idea to have the tool. Would be best ot have a spec on
          vkey, but can probably happen in parallel. Decision to make?
          vkey for cosignature is regular ed25519 vkey, or if it embeds
          cosignature type. Prefer embedding cosignature type, but i
          know that might not be what the trustfabric team implemented.
          If we have a good argument for that we could implrement and
          then argue for them to switch.
        - filippo: everythiung is cleaning if the vkey contains / has
          the the keyid computed from the right alg. But you could have
          key id as "ed25519" when loading and "cosignature" when using
          it for an algorithm. Not a big fan of this though, but it's
          possible.
        - rgdd: what is the proposal?
        - nisse: what tools should we implemented and what should the names be?
        - nisse is happy to jus thave the feedback and move on
        - most of the details will be sorted out in later merge requests
        - on naming nisse thing vkey is short and nice in the ui
        - nisse would like to stick with longer note verifier in the code
        - **"to-vkey" and "from-vkey" sounds good to rgdd and filippo. This is the decision.**

## Next steps

    - rgdd: collect more input on my notes, and most likely start
      putting together something concrete based on the immediate next
      step (that's suggested in the notes)
    - elias: continue testing litewitness, hopefully get a test witness up and running
    - nisse: fix so that mic/video setup works when you're in the office (requested by rgdd, it's very spotty)
      - ln5 has suggested an office-wide solution to this but will not be able to implement it until next tuesday
    - ln5: decide what OS to run on the seasalp witness hw
    - nisse: get vkey conversion MR read for review
    - filippo: meta next-step is recover context and figure out what's
      blocked on me right now. The other thing is make sure that rgdd
      and trustfab talks about log-of-logs / witness configuration. So
      you're in sync.

## Other

    - follow up from last week's other section
        - https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2024-11-12--meeting-minutes.md?ref_type=heads#other
        - i.e., litetlog issues
        - i.e., nisse's measurements of missing cosignatures
          - nisse restarted for both poc and seasalp, leaving them running until the day after tomorrow.
    - input on the shared configuration notes?
        - trustfab basically asked the same thing -- do filippo have
          opinions on how it should work. And for names, opinions on
          what should go into the files / formats. Reputational units,
          grouping. There's a doc they've been hacking on. WOuld be good
          if you two read each other's docs. THey asked for name of
          repo. Filippo thinking "Public witness network". Filippo only
          provided feedback on scope. "How to configure publicly
          available witnesses".
    - filippo: https://www.ueber.net/who/mjl/blog/p/ysco-managed-automated-updates-for-go-services/ by https://github.com/mjl-
        - if a new version is available in the checksum database, then
          the binary updates itself. They're building an end2end story
          ontop of the checksum database. Would be nice to give feedback
          if we have it, and talk about map sandwishes. Filippo thinks
          they have the problem that the autoupdater can't prove that it
          has the latest version (only that it is newer).
        - does anyone know this person? maybe they want to work with $us on tlog things
        - rgdd: maybe invite him to come and say hi on this meeting?
          happy to talk about what he's up to in the other section to
          get to know each other more.
