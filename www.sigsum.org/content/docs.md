## Documentation for users

Meant for users who want try Sigsum and understand how it works:

  - [Command-line tools][]: generate keys, sign, submit, and offline verify
  - [Getting started](/getting-started): step-by-step demo of key-usage transparency
  - [Monitor tooling][]: poll the logs to detect signatures produced by your keys

[Command-line tools]: https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/tools.md
[Monitor tooling]: https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/monitor.md

## Documentation for operators

Meant for operators who want to stand up bastions, logs, and witnesses:

  - [Filippo's litebastion implementation][]: introduction to the litebastion software
  - [Filippo's litewitness implementation][]: introduction to the litewitness software
  - [Sigsum's log-go implementation][]: introduction to the log server architecture
  - [Sigsum's log-go ansible collection][]: ansible for getting the log server software up and running
  - [Sigsum's litebastion ansible role][]: ansible for getting the litebastion software up and running
  - [How to install a witness][]: How-to guide for installing a witness

[Sigsum's log-go implementation]: https://git.glasklar.is/sigsum/core/log-go/-/blob/main/doc/readme.md
[Sigsum's log-go ansible collection]: https://git.glasklar.is/sigsum/admin/ansible
[Sigsum's litebastion ansible role]: https://git.glasklar.is/sigsum/admin/ansible/-/tree/main/roles/litebastion
[Filippo's litebastion implementation]: https://github.com/FiloSottile/litetlog#litebastion
[Filippo's litewitness implementation]: https://github.com/FiloSottile/litetlog#litewitness
[How to install a witness]: witness-installation

## Documentation for contributors

Meant for contributors and others who follow the project in detail:

  - [Archive][]: various notes and weekly meeting minutes
  - [C2SP][]: forum where the project collaborates on community specifications
  - [Design][]: notes and background on the Sigsum design
  - [Proposals][]: supplementary material to push decisions forward

[Archive]: https://git.glasklar.is/sigsum/project/documentation/-/tree/main/archive
[Proposals]: https://git.glasklar.is/sigsum/project/documentation/-/tree/main/proposals
[Design]: https://git.glasklar.is/nisse/cats-2023/-/blob/main/sigsum-design-cats-2023.pdf
[C2SP]: https://c2sp.org/

## Maintained specifications

Meant for implementers who need to know about bits and bytes:

  - [Bastion host protocol][]: release candidate
  - [Sigsum log server protocol][]: stable v1 release
  - [Sigsum proof bundle format][]: work in progress
  - [Sigsum trust policy format][]: work in progress
  - [Witness cosignature format][]: release candidate
  - [Witness cosigning protocol][]: release candidate

[Sigsum log server protocol]: https://git.glasklar.is/sigsum/project/documentation/-/blob/log.md-release-v1.0.0/log.md
[Witness cosignature format]: https://c2sp.org/tlog-cosignature
[Witness cosigning protocol]: https://c2sp.org/tlog-witness
[Bastion host protocol]: https://c2sp.org/https-bastion
[Sigsum proof bundle format]: https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/sigsum-proof.md
[Sigsum trust policy format]: https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/policy.md
