#!/usr/bin/env bash
# § Victor-ray, S
# § <12261439+ZendaiOwl@users.noreply.github.com>

[[ "$#" -ne 2 ]] && {
  printf '\e[1;31m%s\e[0m %s\n' "ERROR" "Invalid number of arguments: $#/2"
  exit 1
}

create_signature () {
  local -r NAME="$1" EMAIL="$2"
  ( printf '%s\n' "Signed-off-by: $NAME $EMAIL" )
}

( create_signature "$1" "$2" )

exit 0
