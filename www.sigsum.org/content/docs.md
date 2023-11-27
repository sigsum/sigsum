## Documentation for users

Meant for users that want try Sigsum and understand how it works:

  - [Command-line tools][]: generate keys, sign, submit, and offline verify
  - [Monitor tooling][]: poll the logs to detect signatures produced by your keys

[Command-line tools]: https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/tools.md
[Monitor tooling]: https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/monitor.md

## Documentation for operators

Meant for operators that want to stand up logs and witnesses:

  - [Sigsum's log-go implementation][]: introduction to the implemented log architecture
  - [Sigsum's log-go ansible collection][]: detailed instructions to get log-go up-and-running
  - [Filippo's litetlog witness implementation][]: introduction on how to get a witness up-and-running

[Sigsum's log-go implementation]: https://git.glasklar.is/sigsum/core/log-go/-/blob/main/doc/readme.md
[Sigsum's log-go ansible collection]: https://git.glasklar.is/sigsum/admin/ansible/-/blob/main/README.md
[Filippo's litetlog witness implementation]: https://github.com/FiloSottile/litetlog#litewitness

## Documentation for contributors

Meant for contributors and others that follow the project in detail:

  - [Archive][]: various notes and weekly meeting minutes
  - [Proposals][]: supplementary material to push decisions forward

[Archive]: https://git.glasklar.is/sigsum/project/documentation/-/tree/main/archive
[Proposals]: https://git.glasklar.is/sigsum/project/documentation/-/tree/main/proposals

## Maintained specifications

Meant for implementers that need to know about bits and bytes:

  - [Log server protocol][]: stable v1 release
  - [Witness cosigning protocol][]: work in progress
  - [Bastion host protocol][]: work in progress
  - [Proof bundle format][]: work in progress
  - [Trust policy format][]: work in progress

[Log server protocol]: https://git.glasklar.is/sigsum/project/documentation/-/blob/log.md-release-v1.0.0/log.md
[Witness cosigning protocol]: https://git.glasklar.is/sigsum/project/documentation/-/blob/main/witness.md
[Bastion host protocol]: https://git.glasklar.is/sigsum/project/documentation/-/blob/main/bastion.md
[Proof bundle format]: https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/sigsum-proof.md
[Trust policy format]: https://git.glasklar.is/sigsum/core/sigsum-go/-/blob/main/doc/policy.md
