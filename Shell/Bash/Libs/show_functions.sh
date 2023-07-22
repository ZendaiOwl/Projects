#!/usr/bin/env bash
# Victor-ray, S <12261439+ZendaiOwl@users.noreply.github.com>
# Shows the functions of a script file provided as agument $1
[[ "$#" -ne 1 ]] && {
    printf '%s\n' "Invalid number of arguments: $#/1"
    exit 1
}
if [[ -f "$1" ]]
then
  (
    # shellcheck disable=SC1090
    source "$1" &>/dev/null
    declare -f | grep ' ()' | awk '{ print $1 }'
  )
else
  printf '%s\n' "Not a file: $1"
  exit 1
fi
