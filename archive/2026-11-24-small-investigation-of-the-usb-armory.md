
# Intro

The USB Armory variant we got: https://github.com/usbarmory/usbarmory/wiki/Mk-II-LAN

I saw `Product: SE Blank 6UL` in dmesg, so it is probably the MX6UL at 528MHz
with CAAM and with some more security feature. Not the MX6ULL/MXULZ (900MHz
with DCP). https://github.com/usbarmory/usbarmory/wiki/Hardware-security-features-(Mk-II))

Main source of docs is the project's github wiki: https://github.com/usbarmory/usbarmory/wiki/


# Launching a program on Armory & writing to its storage

In this I'm trying to get a Debian image onto the Armory, learning things on
the way. In the end I find out that the current official Debian image does not
support the LAN-variant we have.

[armory-usb](https://github.com/usbarmory/armory-ums#executing) is a program
(built on Tamago unikernel, no Linux) that exposes the removable microSD-card
and onboard-eMMC over UMS (USB Mass Storage).

Pre-compiled `armory-ums.imx` binaries here: https://github.com/usbarmory/armory-ums/releases

Such an .idx image can be launched on the Armory by the
[armory-boot-usb](https://github.com/usbarmory/armory-boot#serial-download-protocol-utility)
tool, using SDP (Serial Download Protocol)

The LAN-variant does not have any microSD slot, so storage is only the on-board
16 GB eMMC. The "boot switch" is accessible on the bottom of case. To set the
mode, push the switch:

- towards the RJ45 connector: boot **only** over SDP
- towards the USB-C connector: boot eMMC with fallback to SDP

So push it towards the RJ45 to be sure it will boot over SDP. To then launch
the `armory-ums.imx` (downloaded from the armory-ums/release page above),
follow this procedure:

```
git clone https://github.com/usbarmory/armory-boot
make -C armory-boot armory-boot-usb
sudo ./armory-boot/armory-boot-usb -i ./usb-armory.imx
```

If successful, an exposed microSD (attempted first) is indicated by leds on the
Armory turning white. Exposed eMMC is indicated by leds turning blue. A new
node should appear in `/dev/`.

Given access to the eMMC you can for example flash the Debian trixie image:
https://github.com/usbarmory/usbarmory-debian-base_image/releases

```
dd if=usbarmory-mark-two-emmc-debian_trixie-base_image-20260904.raw of=/dev/SDZ bs=1M conv=fsync
```

Then push the boot switch towards USB-C, for eMMC-boot ("towards usb-**C** for
emm-**C**"), and power cycle the Armory. It does seem to boot something up, and
then the blue/white leds flicker a little (they are apparently configured to
reflect CPU load average).

But, according to Andrej Rosano, the Debian image does not support this
variant's LAN-interface. I'm guessing USB-ethernet is only supported on the
USB-C plug of other variants (if at all), not on the receptacle of this
variant.

Some references:
- https://github.com/usbarmory/usbarmory-debian-base_image
- https://github.com/usbarmory/usbarmory/wiki/Host-communication

A lot about boot modes, SDP and flashing:
https://github.com/usbarmory/usbarmory/wiki/Boot-Modes-(Mk-II)


# Running the tamago-example

I also tried building and launching https://github.com/usbarmory/tamago-example
(`make imx`). Again over SDP using `armory-boot-usb -i example.imx`. Something
worked, partly.

After armory-boot-usb finished, the white and blue leds turned on (or got
brighter, not flashing), and a new network interface using cdc_ether appeared
on my laptop (running `dmesg -w`). Bringing it up according to the repo's
README (here using the specific MAC-based altname of the specimen I'm testing):

```
ip addr add 10.0.0.2/24 dev enx1a5589a26942
ip link set up dev enx1a5589a26942
```

I can now ping the Armory over the USB-cable at `10.0.0.1`, and also ssh to
port 22.

Beware of your OS/networking setup deciding it wants manage the new interface
automatically, and suddenly removing the manually added IP from it. For
`NetworkManager`, the following can be placed in a file
`/etc/NetworkManager/conf.d/99-unmanaged-devices.conf`:
```
[device-usbarmory-unmanaged]
match-device=mac:1A:55:89:A2:69:42
managed=0
```
Then `systemctl restart NetworkManager`, and when the interface appears run
`nmcli device status` to verify STATE==unmanaged.

I also tried plugging the Armory's RJ45 into my laptop, by way of a
RJ45-USB-dongle. After bringing up 10.0.0.2 on the dongle interface, the Armory
can be now accessed in the same way, but over the TP-cable.

I also learned that it should be possible to write a .imx directly to the eMMC
at offset 1024, and to have the firmware boot it. After launching
armory-ums.imx to access the eMMC from the laptop as mass storage:

```
dd if=example.imx of=/dev/SDZ bs=512 seek=2 conv=fsync
```

But this did not seem to boot the tamago-example (which had bright blue/white
leds, stable orange LAN-led). Was there something leftover from my attempt to
boot the Debian image? But I did first write some MBs of /dev/zero to offset 0
on the eMMC.


# Vitrum on the Armory LAN-variant?

Vitrum is made to run on the standard USB Armory Mk II with i.MX6ULZ. This has
a microSD-card slot, and apparently comes with Linux dist pre-installed on
eMMC. The LAN-variant has no microSD-card slot.

There is a long provisioning procedure, which involves the Linux dist on eMMC,
setting up HAB (High Assurance Boot, hardware support for something like Secure
Boot), preparing the microSD-card, provisioning RPMB (Replay Protected Memory
Block), and so on. The dist on eMMC is bootable until the HAB has been
"closed".

Vitrum will eventually be run from the microSD-card, with storage on card, tied
to RPMB (Replay Protected Memory Block) on the on-board eMMC. "an authenticated
blob on microSD whose generation and digest are anchored in eMMC RPMB"; read
more in the repo's [README](https://github.com/cpu/vitrum#vitrum).

The whole design relies on this setup, and therefor it does not seem feasible
to run it on a USB Armory that has not microSD-card slot.
