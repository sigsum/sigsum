# Log servers

Sigsum currently runs two log servers.

  - Proof-of-concept log, following the main branch of the log-go
    repository, intended for testing. Public key and url, in policy
    file format:
	`log 154f49976b59ff09a123675f58cb3e346e0455753c3c3b15d465dcb4f6512b0b https://poc.sigsum.org/jellyfish`

  - Test log, running the latest log server release. Public key and url:
    `log 80d115da542b67bb7a15448f50fe951e59cfa9db73807bfc12a2a4a981ba251e https://ghost-shrimp.sigsum.org`

We plan to deploy a production log, with stronger commitment on
availability and documented security practices.

# Witnesses

We plan to deploy a witness for cosigning both our own logs and
other's logs.

# Development infrastructure

Repositories for source code and documentation, issue trackers,
continuous testing, etc, runs at [our gitlab
instance](https://git.glasklar.is).
