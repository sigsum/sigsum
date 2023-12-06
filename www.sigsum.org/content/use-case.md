XXX: wip, should probably break out the detailed description of how to setup the
"use-case" that we will improve on.  So that this page is very sigsum focused.

# Automatic updating of a script

This is a demo of layering an example use-case on top of Sigsum.  A bash script
is considered that automatically updates itself to a newer version if it is
signed.  The party signing the script claims that:

  1. There is exactly one script released for every version number 1,2,...
  2. New versions will only bump the information needed to receive updates.
  3. All releases are available on a release page that anyone can inspect.

The first part of the demo sets up a script that repeatedly downloads itself in
signed format.  The second part of the demo extends the script so that _the
above claims become verifiable_ with Sigsum.

## Install

Install the following tooling with your system's package manager:

  - `ssh-keygen`: will initially be used to generate a key pair, sign data, and
    verify data
  - `python3`: will be used to start a web server on localhost
  - `curl`: will be used to download signed updates of the script on localhost
  - `sed`, `cut`, `sha256sum`, `cat`, `echo`, `grep`: other help utilities used

Install the [Go toolchain][].  You will need at least Go version 1.19

Install the following Sigsum tooling:

    $ go install sigsum.org/sigsum-go/cmd/sigsum-submit@v0.6.2
    $ go install sigsum.org/sigsum-go/cmd/sigsum-verify@v0.6.2
    $ go install sigsum.org/sigsum-go/cmd/sigsum-monitor@v0.6.2

`sigsum-submit` will be used to sign a checksum, submit it to a log, and collect
its proof of logging.

`sigsum-verify` will be used to verify the gathered proof of logging.

`sigsum-monitor` will be used to try and falsify the above two claims.

[Go toolchain]: https://go.dev/doc/install

## The assumed setup

Suppose a bash script named `autoupdate` is made available on a release page.

Every release on the page is accompanied by a human-readable manifest:

    description: Example autoupdate script
    version: 2
    source: http://localhost:2009/releases/autoupdate_v2
    checksum: 9a3f7e32db97a57a0bb3c1007bcb5cbfabfe84bd20d74f34e90e1501c2108c31
    
    -----BEGIN SSH SIGNATURE-----
    U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgZYXfUrhuiizcik6pncxE4fld9E
    SBAzWcLj9XRTXTAJ0AAAAEZmlsZQAAAAAAAAAGc2hhNTEyAAAAUwAAAAtzc2gtZWQyNTUx
    OQAAAEB+pRn952nSKGb+OZLj97pnXuZ1roRYyHlUgw6DNOLaku4MuoCdXVu731ibuTLqXA
    1ea7F0QICY/6Rsc//SEaoB
    -----END SSH SIGNATURE-----

`description` is a human-readable description of the released software.

`version` is a monotonically increasing version number.

`source` is a URL specifying where the source code can be downloaded.

`checksum` is a SHA256 hash that corresponds to the downloaded source code.

`signature` is an Ed25519 signature in SSH format.  The signature is computed
with `ssh-keygen -Y` such that the first five lines in the manifest are used as
the input message.

You will be the one signing manifests and making releases of `autoupdate` on a
web server that runs on localhost in this demo.  Let's start by configuring a
working environment that Sigsum is later added to.

## Configure an auto-update environment

Create a working directory:

    $ mkdir -p sigsum-demo/{programmer,web-server,user}

`programmer/`: directory in which we will work on our `autoupdate` script.

`web-server/`: directory that a web server will serve updates from.

`user/`: directory in which we will be a user of `autoupdate`.

To denote which directory we are located in, all commands will be prefixed with
the respective directory names.  Throughout the entire demo, you will need one
terminal per directory.

### Generate a signing key-pair

Generate a signing key-pair and list the public key:

    programmer$ ssh-keygen -t ed25519 -f demo-key -C autoupdate@sigsum.org
    programmer$ cat demo-key.pub
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQ9qgb29KgcU5L2qSw5C9wV8lkKelDhjycvMxUssQLc autoupdate@sigsum.org

Now we can switch our attention to creating the `autoupdate` script.

### Create an auto-update script

At a glance, the `autoupdate` script should do the following:

  1. Download the latest manifest from a well-known URL.
  2. Verify that the manifest is signed by a trusted public key.
  3. Exit if the latest version is already being used, otherwise continue.
  4. Download the latest `autoupdate` script using the listed source URL.
  5. Check that its checksum matches what is listed in the manifest.
  6. Replace the current `autoupdate` script with the downloaded version.

Anytime the `autoupdate` script exits, it will automatically start itself
again.  This means that the script will continue running forever, either using
the same version or a newer version if one is available.

The complete script is listed below and should be self-explanatory.  Just
replace the `ALLOWED_SIGNER` variable to match the public key generated above,
then save as a file named `autoupdate`.

```
programmer$ cat autoupdate
#!/bin/bash

set -eu
trap respawn EXIT

BIN=$0 # Path to run this script again on exit
WAIT_S=3 # Seconds to wait before running again
URL=http://localhost:2009 # Where a web server responds to requests
VERSION=1 # Version of the autoupdate script (1, 2, 3, ...)
NAME=autoupdate@sigsum.org # ssh-keygen -t ed25519 -f key -C autoupdate@sigsum.org
ALLOWED_SIGNER="$NAME ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWF31K4boos3IpOqZ3MROH5XfREgQM1nC4/V0U10wCd"

function main() {
	download "$URL/manifest/latest" >manifest
	sed    '/^$/q'   manifest            > msg
	sed -n '/^$/,$p' manifest | sed '1d' > sig
	verify msg sig

	manifest_checksum=$(grep "checksum: " msg | cut -d' ' -f2)
	manifest_version=$(grep "version: "   msg | cut -d' ' -f2)
	manifest_url=$(grep "source: "        msg | cut -d' ' -f2)

	if [[ "$manifest_version" -le "$VERSION" ]]; then
		info "already up-to-date at version $VERSION"
		exit 0
	fi

	download "$manifest_url" >autoupdate_next || die "failed to HTTP GET $1"
	got=$(sha256sum autoupdate_next | cut -d' ' -f1)
	if [[ "$got" != "$manifest_checksum" ]]; then
		die "integrity of update at $next_url could not be verified"
	fi

	info "updating from version $VERSION to $manifest_version"
	mv autoupdate_next autoupdate
	chmod +x autoupdate
}

function download() {
	url=$1; shift
	curl -f $url 2>/dev/null || die "failed to HTTP GET $url"
}

function verify() {
	msg_file=$1; shift
	sig_file=$1; shift
	ssh-keygen -Y verify -f <(echo "$ALLOWED_SIGNER") -I "$NAME" -n file -s "$sig_file" <"$msg_file" >/dev/null || die "invalid signature"
}

function info() {
	echo  "INFO: $*" >&2
}

function die() {
	echo "ERROR: $*" >&2
	exit 1
}

function respawn() {
	sleep "$WAIT_S"
	exec "$BIN"
}

main $@
```

Try running the script.  It should fail because no web server serves a manifest
on the well-known URL yet.  Let's create a signed manifest and serve it on
`http://localhost:2009/manifest/latest`.

### Publish an initial auto-update script

The assumed setup described a demo manifest-format that `autoupdate` uses.
Below is a script that puts together the required information followed by
signing it.  The signed manifest as well as the source associated with that
version is deployed to what will soon become our web-server root.

```
programmer$ cat mkrelease
set -eu

url=$(grep "^URL="         autoupdate | cut -d'=' -f2 | cut -d' ' -f1)
version=$(grep "^VERSION=" autoupdate | cut -d'=' -f2 | cut -d' ' -f1)
checksum=$(sha256sum       autoupdate | cut -d' ' -f1)

echo "Adding source to release page"
cp autoupdate "../web-server/releases/autoupdate_v$version"

cat << EOF >manifest
description: Example autoupdate script
version: $version
source: $url/releases/autoupdate_v$version
checksum: $checksum

EOF
ssh-keygen -Y sign -f demo-key -I autoupdate@sigsum.org -n file manifest
cat manifest.sig >> manifest
rm -f manifest.sig

echo "Uploading manifest to release page"
cp manifest ../web-server/manifest/autoupdate_v$version
mv manifest ../web-server/manifest/latest
```

Try running the script.  You should see that the web-server directory was
populated.

    programmer$ ./mkrelease
    programmer$ tree ../web-server

Start serving the web-server directory root on localhost, port 2009:

    web-server$ python -m http.server 2009


### Run the auto-update script

Try downloading the latest signed manifest and its source code:

    user$ curl http://localhost:2009/manifest/autoupdate_v1
    user$ curl -o autoupdate http://localhost:2009/releases/autoupdate_v1

To keep the demo simple, we will not verify the initial signature.  All
subsequent updates will be verified against the script's embedded public key.

Run:

    user$ ./autoupdate

You should see that the script loops saying that it is already up-to-date.

### Publish an update

Prepare an update of the `autoupdate` script and release it.  Below, only the
version number is bumped without any other changes.

    programmer$ sed -i 's/VERSION=1/VERSION=2/' autoupdate
    programmer$ ./mkrelease

Now that a new update is available, the `auto-update` script that is already
running in a separate terminal should have found it and updated itself.

### Debrief
