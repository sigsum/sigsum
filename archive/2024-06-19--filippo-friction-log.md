# Filippo's user-side friction log

> This is an unedited friction log of Filippo's experience using Sigsum to sign age releases, from the perspective of a new user.

Alright, someone asked me to sign age releases, I know just the tool.

Home page to Getting started guide, great.

Kinda wish there was a link to the source repository for the tools I am about to install.

Hmm, I can see the trust policy being a usability (and ecosystem) issue. "Not having a trust policy would be similar to not having a public key for digital signatures." But Sigsum also has public keys! Maybe we should have a default one more hidden from average users. Or maybe it should be more tied to the public key? This is a difficult UX/security choice.

Our user wants to sign something. They are familiar with PGP, maybe signify. "Log a signed checksum" doesn't say sign and "proof of logging" doesn't say signature.

It took even me a second to figure out what I should distribute on the age README and what with the releases. Do I need a checksums file? Do I need to compute checksums? (What is a checksum? might ask a less experienced user.) I think the answer is to log each release artifact and store the proof next to it, and put the public key in the README.

We need something that projects can link from READMEs to help end users verify releases.

Monitoring... running sigsum-monitor manually and figuring out what the checksums are is not going to happen. We need 1) a service for key owners that emails them if the key is used, maybe with affordances to map to GitHub Release artifacts and the like; 2) a tool for third parties to point to a folder (or a GitHub project and the like) and confirm that all logged checksums for a key match files in there.

^ the above maps neatly to Go sumdb tooling: 1 is gopherwatch.org and 2 is a tool we are building to compare sumdb entries to a local git repository tags.

it's checksum -> its, it’s public key -> its

Wish the Getting started page showed examples of each of the artifacts, since they are all textual!

Homebrew packaging (with a default trust policy maybe) would be nice.

`/etc/sigsum/trust_policy` is not a friendly path on macOS or for users without root. Use os.UserConfigDir().

I don't like unprotected key files! Can I use an SSH agent? (Other users might ask, can I use an existing key?) Then I realized I don't actually have readily available hardware storage for Ed25519 keys, alas.

"Try listing the public-key hash" wait, do I need it? There's a lot of hashing going around, let's not introduce the concept of key hash if we don't need it. We can show the public key instead.

"apply SHA256 twice in a row" also a lot of complexity. I realize now we'll probably need this for the monitor output, I would move the computation of both to the "Detect the signed checksum" section.

I passed multiple files to sigsum-submit, it would have been nice if the log output told me which one was being logged, and where the proof was being written, rather than just `2024/06/16 23:37:39 [INFO] Attempting submit to log: https://poc.sigsum.org/jellyfish` multiple times. The timestamped log is also inconsistent with the other tools outputs.

Each submission took exactly 30s. The guide says ~10s or so.

As I write the README section, I am growing convinced the trust policy should be in the same file as the public key.

"Silence is a good sign" users don't like that, and it's too easy to make a mistake when doing verification interactively, print something on stderr on success.

+1 for the monitoring tool above listing a directory. I would like to write a script/tool that reproduces the age builds (maybe a generic Go build!) and it would pair perfectly.

There should be a way to figure out what a proof is by opining. e.g. sigsum.org header and/or file(1) signature.

https://github.com/FiloSottile/age?tab=readme-ov-file#verifying-the-release-signatures yep, the trust policy is so much noise, there should be a pre-installed default, even bundled with the tools (with overrides of course)
