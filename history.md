# History
This is a living document that documents the history of the Sigsum project.

## 2019
Mullvad VPN announced a project named System Transparency
	[\[1\]](https://mullvad.net/en/blog/2019/6/3/system-transparency-future/).
System Transparency is a security architecture for bare-metal servers that aims
to make a system's boot chain remotely verifiable by any interested party
	[\[2\]](https://www.system-transparency.org/).

Fredrik Strömberg presented the System Transparency design at PUTS
	[\[3\]](https://petsymposium.org/2019/files/workshop/abstracts/PUT_2019_paper_32.pdf).
One part of the design included a Certificate Transparency log
	[\[4\]](https://mullvad.net/media/system-transparency-rev5.pdf).
Rasmus Dahlberg suggested use of a separate System Transparency log.

## 2020
In October, Fredrik Strömberg and Rasmus Dahlberg started focused design
iterations on a transparency log that would be better suited for the System
Transparency project
	[\[5\]](https://github.com/system-transparency/stfe/commit/40250377da81864e9e502b803c0543c48e4a0615).

## 2021
Linus Nordberg joined the System Transparency logging discussions in January.  A
few months later, drafts of the resulting design were presented at PADSEC
	[\[6\]](https://web.archive.org/web/20210427203606/https://hopin.com/events/padsec)
and SWITS
	[\[7,](https://web.archive.org/web/20210603112144/https://swits.hotell.kau.se/AnnualSeminars/SWITS%202021/SWITS_2021/SWITS2021_Programme.htm)
	[8\]](https://web.archive.org/web/20210923134324/https://swits.hotell.kau.se/AnnualSeminars/SWITS%202021/SWITS_2021/SWITS_2021_paper_17.pdf).

In June, Fredrik Strömberg, Rasmus Dahlberg, and Linus Nordberg decided to
rebrand System Transparency logging as a separate project that is funded but not
governed by Mullvad VPN
	[\[9\]](https://git.sigsum.org/sigsum/tree/archive/2021-06-21--meeting-minutes).

The Sigsum Project launched in October
	[\[10\]](https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-general@lists.sigsum.org/thread/ZCWCOWYTBQSVYWADEHBAWYEHNS3FJ6RK/).
It is managed by Rasmus Dahlberg (Mullvad VPN) and Linus Nordberg (independent).

## 2022

Since the project's inception most contributors have been employed by Mullvad
VPN AB.  During the fall, a new sister company named Glasklar Teknik AB
[\[11\]](https://www.glasklarteknik.se/) was created to house long-term
maintenance and development of Sigsum as well as System Transparency. Rasmus
Dahlberg and Niels Möller transitioned from Mullvad VPN to Glasklar Teknik.
Linus Nordberg and Fredrik Strömberg also became part of the team at Glasklar
Teknik.  The Sigsum project continues to be wholly funded but not governed by
Mullvad VPN.

Several new project contributors joined to further develop Sigsum's design and
prototype implementations throughout the year.  In addition to Niels Möller,
this included Grégoire Détrez (Mullvad VPN) and Filippo Valsorda (independent).

A talk on the Sigsum design was presented by Rasmus Dahlberg at the Open Source
Firmware Conference
    [\[12\]](https://www.osfc.io/2022/talks/using-sigsum-logs-to-detect-malicious-and-unintended-key-usage/).

Rasmus Dahlberg leads the project.

## 2023

In November, the Sigsum log server protocol v1 was announced
    [\[13\]](https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-general@lists.sigsum.org/thread/LX42ONBGWO4JMSMCDGS5Z7ORKJHFHQOO/).
Filippo Valsorda and Niels Möller also presented talks on why an interoperable
witness system is needed and how Sigsum was designed at CATS
    [\[14\]](https://catsworkshop.dev/program/).

## 2024

In January, it was
    [decided](https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2024-01-09--meeting-minutes.md#decisions)
that the Sigsum project would donate specifications that are useful outside of
the Sigsum system to maximize the probability that we end up with an
interoperable witnessing system
    [\[15\]](https://git.glasklar.is/sigsum/project/documentation/-/blob/main/proposals/2024-01-on-specifications-and-governance.md).
The
    HTTPS-bastion [\[16\]](https://c2sp.org/https-bastion).
    cosignature/v1 [\[17\]](https://c2sp.org/tlog-cosignature), and
    witness API [\[18\]](https://c2sp.org/tlog-witness)
specifications have therefore been moved to C2SP.org, where they are developed
and maintained together with other community members.

In April, Filippo Valsorda presented many of the modern transparency-log design
patterns that Sigsum is based on (such as witnessing and "spicy" signatures)
    [\[19\]](https://www.youtube.com/watch?v=SOfOe_z37jQ).

In October, Rasmus Dahlberg presented Sigsum's design and how to use it at the
transparency.dev summit
    [\[20\]](https://transparency.dev/summit2024/sigsum.html).
Several other project contributors also presented at the summit
    [\[21](https://www.youtube.com/watch?v=uZXESulUuKA),
    [22](https://www.youtube.com/watch?v=fY_v7yNrl2A),
    [23\]](https://www.youtube.com/watch?v=Lo0gxBWwwQE).

## 2025

In January, Glasklar Teknik announced that they operate a stable Sigsum log and
a stable cosigning witness
    [\[24](https://git.glasklar.is/glasklar/services/sigsum-logs/-/blob/main/instances/seasalp.md),
    [25\]](https://git.glasklar.is/glasklar/services/witnessing/-/blob/main/witness.glasklar.is/about.md).

In February, Niels Möller presented how to detect rogue signatures with Sigsum
at FOSDEM
    [\[26\]](https://fosdem.org/2025/schedule/event/fosdem-2025-5661-sigsum-detecting-rogue-signatures-through-transparency/).

In October, a witness network was launched to simplify configuration of witness
cosigning
    [\[27\]](https://witness-network.org/).
This community effort is maintained by Al Cutter and two Sigsum contributors:
Filippo Valsorda and Rasmus Dahlberg.

In October, Mullvad VPN announced that they operate a stable Sigsum log and a
stable cosigning witness.
    [\[28](https://witness.mullvad.net/about),
    [29\]](https://ginkgo.tlog.mullvad.net/about).
Tillitis also announced that they operate a stable cosigning witness
    [\[30\]](https://github.com/tillitis/tillitis.se-tillitis-witness-1/blob/main/about.md).

In October, several Sigsum contributors presented at the transparency.dev summit
    [\[31](https://www.youtube.com/watch?v=B-0ZW1ovPmk),
    [32](https://www.youtube.com/watch?v=eCMKjWDNHTQ),
    [33](https://www.youtube.com/watch?v=-5HtYd4O7vE),
    [34](https://www.youtube.com/live/QTVTFxkYOT8?si=r8hnKiY0LFSusMsn&t=8539),
    [35\]](https://www.youtube.com/live/QTVTFxkYOT8?si=f0P47aLS4VCWQRbW&t=9915).
Sigsum contributors Fredrik Strömberg and Rasmus Dahlberg were also part of
organizing the summit
    [\[36\]](https://transparency.dev/summit2025/organisation/).

In November, the donated C2SP.org specifications `tlog-cosignature` and
`tlog-checkpoint` reached v1
    [\[37](https://github.com/C2SP/C2SP/issues/176),
    [38\]](https://github.com/C2SP/C2SP/issues/177).
At the same time, `tlog-witness` reached release-candidate status
    [\[39\]](https://github.com/C2SP/C2SP/issues/175).

In December, the Sigsum project announced their first stable trust policy
    [\[40\]](https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-announce@lists.sigsum.org/thread/WOS6FHEQNIA5YFV3CZNITLHMGDCIH557/).

In December, a minor generalization of Sigsum's proof format landed in C2SP.org
    [\[41\]](https://github.com/C2SP/C2SP/pull/181).
Sigsum's trust policy format will likely be migrated as well because others
find it useful and deployed it throughout the year
    [\[42\]](https://github.com/transparency-dev/tessera/issues/800).

Several new contributors helped further Sigsum's design and use.  This notably
includes Simon Josefsson who packages Sigsum's tooling in Debian stable
    [\[43\]](https://packages.debian.org/trixie/sigsum-go),
Florian Larysch who develops a monitor
    [\[44\]](https://github.com/florolf/sigmon),
and Elias Rudberg.
