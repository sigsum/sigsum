# 2023-04-14, 1215-1300 UTC

Unsorted notes from an ad-hoc proposals chat.

## Hello

  - rgdd
  - nisse

## Agenda

Continued discussion about serialization of signed stuff.

## Reading list

Come prepared by (re)reading and thinking about the following:

  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/30
  - https://git.glasklar.is/sigsum/project/documentation/-/merge_requests/32
  - https://git.glasklar.is/sigsum/project/documentation/-/issues/30

## Running notes

BYTE ARRAY: sigsum.org/v1/leafNUL
BYTE ARRAY: <checksum>

where checksum := H(message), where message = H(data) and is the thing that is
submitted to the log.  Concatenate the two fixed-size arrays before signing.

Do something similar for token.

sigsum.org/v1/<SOMETHING>/<log keyhash in hex> for the namespacing we have in
tree heads?  Nisse will think about <SOMETHING>, and flesh out the above as a
proposal.
