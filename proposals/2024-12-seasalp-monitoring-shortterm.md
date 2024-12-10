# Proposal to implement simple monitoring for the seasalp log

author: elias

# Background

For maintenance of the seasalp log service it would help if we had a
monitoring solution, especially now that Christmas holidays are
approaching.

The idea with this proposal is to do something simple enough so that
we can realistically implement it before Christmas. This proposal is
mainly about interfaces between the monitoring solution and other
systems/actors.

# Proposal

Create a monitoring system that regularly performs submissions to the
log and has input and output as described below.

## Input

Input to the monitoring system:

- Current configuration of the seasalp log, as determined for example
  by reading input files.

- Current behavior of the seasalp log, as determined by regularly
  probing https://seasalp.glasklar.is/get-tree-head and any other
  relevant endpoints.

- Results from regular submissions to the log as described under
  "Heartbeat submissions" below.

## Heartbeat submissions

Every 3 hours, make a submission to the log and verify that it works
as expected. Store results from these submissions.

## Output

Output from the monitoring system:

- Alert emails sent to sysadmin team when problems are
  detected. Problems that should be detected include failure of
  heartbeat submissions, unexpected behavior of the log size (it
  should grow at least due to the heartbeat submissions), and changes
  in the number of cosignatures.

- Stretch goal: A public web page where current status information is shown, showing
  both some information about the current configuration and the
  current behavior. The number of configured witnesses is shown, as
  well as the current size and the current number of cosignatures, and
  some history of this such as a table showing how those numbers have
  changed over the past few days.

## Timeframe

This should be done before Christmas, so that the monitoring can be in
place to help ensure that seasalp works well during Christmas holidays.
