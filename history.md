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
	[\[10\]](https://lists.sigsum.org/sigsum-general/msg00001.html).
It is managed by Rasmus Dahlberg (Mullvad VPN) and Linus Nordberg (independent).

## 2022
In September, Rasmus Dahlberg presented the latest revision of the Sigsum design
on the Open Source Firmware Conference
    [\[11\]](https://www.osfc.io/2022/talks/using-sigsum-logs-to-detect-malicious-and-unintended-key-usage/).

In October, the project started to receive all its funding from a sister-company
of Mullvad VPN.  The new sister company is named Glasklar Teknik
    [\[12\]](https://www.glasklarteknik.se/).

Throughout the year, several new project contributors joined to further develop
Sigsum's design and prototype implementations.  This included Grégoire Détrez,
Niels Möller, and Filippo Valsorda.  Rasmus Dahlberg (Glasklar Teknik) manages
the project with consensus from the other project contributors on weekly meets.

## 2023
In November, the Sigsum log server protocol v1.0.0 was announced
    [\[13\]](https://lists.sigsum.org/mailman3/hyperkitty/list/sigsum-general@lists.sigsum.org/thread/LX42ONBGWO4JMSMCDGS5Z7ORKJHFHQOO/).
Filippo Valsardo and Niels möller also presented talks on why an interoperable
witness system is needed and how Sigsum was designed
    [\[14\]](https://catsworkshop.dev/program/).
