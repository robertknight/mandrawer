#!/bin/bash

function repeat() {
  local cmd=$1
  local iterations=$2

  for _ in $(seq 1 "$iterations"); do
    # Run the command, discarding the command's output and keeping just the
    # last three lines containing real, user and sys timings.
    /usr/bin/time -p $cmd 2>&1 | tail -n3 | grep "real" | egrep -o "[0-9.]+"
  done
}

iterations=$1
shift
cmd=$*

repeat "$cmd" "$iterations"
