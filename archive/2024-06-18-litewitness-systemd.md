# Setup a prototype witness (extended)

Looking to setup a prototype witness?  First see the [manual setup notes][]
which are already in the archive.  Would you like to ensure the witness is
hooked up to a bastion host, surviving reboots, etc?  See hints below.

[manual setup notes]: https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2023-10-05-setup-prototype-witness-go.md

## /home/witness/witness/start.sh

Below is a start-up script.  Before running it, ensure that `key`, `key.pub`,
and `key.grip` has been generated (described in [manual setup notes][]).  You
will also need to configure the logs to witness with `witnessctl`.

```
#!/bin/bash

set -eu
cd "$(dirname "$0")"

KEY_FILE=key # Ed25519 key in SSH format
KEY_GRIP=$(cat key.grip) # key hash in hex
DATABASE=state.db
BASTION=bastion.glasklar.is:443

trap clean_up EXIT
function clean_up() {
    kill "$SSH_AGENT_PID"
    echo "clean_up: terminated ssh-agent with pid $SSH_AGENT_PID" >&2
}

eval $(ssh-agent -s)
ssh-add "$KEY_FILE"
export SSH_AUTH_SOCK

/home/witness/go/bin/litewitness -db "$DATABASE" -key "$KEY_GRIP" -ssh-agent "$SSH_AUTH_SOCK" -bastion "$BASTION"
```

To use Glasklar's bastion and be able to witness Glasklar's logs, register your
witness by sending an email to `witness-registry (at) glasklarteknik (dot) se`.

## /etc/systemd/system/litewitness.service

Below is a systemd configuration that will restart the witness if it stops.
For example, the witness might stop because its bastion host was restarted.

```
[Unit]
Description=litewitness service
After=network.target

StartLimitIntervalSec=72h
StartLimitBurst=4320

[Service]
Type=simple
User=witness
Restart=always
ExecStart=/bin/bash /home/witness/witness/start.sh
RestartSec=1m

[Install]
WantedBy=multi-user.target
```

**Hint:** `systemctl daemon-reload` after adding/modifying a `.service file`.
And `systemctl enable litewitness` to survive reboots.  To see how the witness
is doing, try `systemctl status litewitness` and `sudo -u witness journalctl -u
litebastion`.  The above assumes `litebastion` runs as the user `witness`.
