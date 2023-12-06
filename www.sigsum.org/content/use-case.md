# Example use-case: transparent automatic updates

This is a demo of layering a use-case on top of Sigsum.  A program that
automatically updates itself is considered. The program's updates are downloaded
in signed format from a release page.  By incorporating Sigsum, the party
providing the updates can make falsifiable claims about them.

## Preliminaries

Complete the [getting-started](/getting-started) tutorial on key-usage
transparency.  Ensure that `sigsum-submit` and `sigsum-verify` are installed
before proceeding.  These tools will be needed later on in this tutorial.

Complete the [example setup](/autoupdate) of a program that updates itself.
The `autoupdate` bash script and the setup surrounding it will be used as a
starting point in this tutorial.  Only a brief recap is provided here.

## The assumed setup

Sum up where the reader left off while doing the autoupdate setup.  E.g., `tree`
to ensure the directory structure looks right and remind about the three
terminals.  And what the signed metadata format looks like.

## Articulating claims

XXX: describe that the point is to detect unwanted events / falsify claims.

The party providing the updates for this program claim that:

  1. All updates are available on a release page that anyone can inspect.
  2. There is exactly one update per monotonic version number 1,2,3...
  3. The program will not do anything else but update itself forever.  In other
     words, no matter how many updates are applied it remains a dummy program
     that wakes up, updates, and shuts down.


None of these claims are verifiable without Sigsum.  For example, a maliciously
signed update could be provided to some users without anyone knowing about it.

## A transparent auto-update program

Describe the diff, small.

## Detect unwanted events and falsify claims

Describe what a monitor would do here.  And how the user that runs the
`autoupdate` program could still be owned, but now we will know about it.

## Debrief

Summarize the lessons learned.
