# Bridging Sigsum's IRC/Matrix with transparency.dev's slack

## Background

Sigsum has two chat rooms that are bridged:

  - `#sigsum` on OFTC.net
  - `#sigsum` on matrix.org

Both rooms are public.  Messages sent in the IRC channel are made available in
the Matrix room and vice versa.  End-to-end encryption on Matrix is disabled,
because otherwise it is not possible to bridge the public room with IRC.

## Proposal

Experiment with a bridge from the transparency.dev slack to Sigsum's Matrix
room.  If it works well enough UX-wise we keep it as an unofficial way to
interact with Sigsum folks.  If UX (or other issues) are found we disable it.

We continue to only advertise Sigsum's IRC/Matrix on our website.

## Discussion

A concern is that slack might do something we don't like, or try to force us to
do something we don't like as a result of this bridge integration.  If this
turns out to be the case we simply disable the bridge integration.  Overall it's
a good thing if we can make it easier for us and others to interact via chat.

It is worth noting that the bridge between IRC and Matrix are sometimes a bit
buggy.  The slack bridge would likely suffer from the same problem?  The "bug"
is that sometimes (not very often) the bridge stops working and it takes a
little bit of time before it recovers automatically.  During this time messages
are not relayed correctly to and from the bridge, and it is hard to detect this
without having a user on both IRC and Matrix.  The bridge seems to fix itself
though -- we never did any manual debugging or fixing to resolve issues.

It is unclear who would work on getting this integration done right now.  But
if someone is willing to put in the work to experiment with it, please do!  This
would likely start with a quick assessment of if the UX will be good enough (to
be tested), and whether the transparency.dev admins are OK with the permissions
needed for bridging (if rgdd recalls correctly it wasn't bad on matrix's end).
