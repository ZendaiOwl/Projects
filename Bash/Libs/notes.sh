#!/usr/bin/env bash

for LINE in $(./getFunctions.sh etc/library.sh); do
  if ! has_text "$LINE" '_'; then
    echo "$LINE";
  fi
done
