#!/usr/bin/env bash
# Victor-ray, S <12261439+ZendaiOwl@users.noreply.github.com>


function Print { printf '%s\n' "$@"; }

function clean {
    if [[ "${#SCRIPT_VARIABLES[@]}" -eq 0 ]]
    then unset SCRIPT_VARIABLES
    else unset "${SCRIPT_VARIABLES[@]}"
         unset SCRIPT_VARIABLES
    fi
}

function addVariables {
    if [[ -z "$#" ]]
    then return 1
    else SCRIPT_VARIABLES+=("$@")
    fi
}

declare -a SCRIPT_VARIABLES

trap 'clean' EXIT SIGHUP SIGINT SIGILL SIGABRT

# [[ "$#" -ne 3 ]] && exit 1

# if [[ -f "$1" ]]
# then FILE="$1"
# else exit 1
# fi

FILE="functions.json"

if [[ -n "$1" ]]
then KEY="$1"
fi

declare -a KEYS

mapfile -t KEYS < <(jq -r 'keys | .[]' "$FILE")

addVariables 'KEY' 'FILE' 'KEYS'

for K in "${KEYS[@]}"
do if [[ "$K" == "$KEY" ]]
   then jq -r '.'"$KEY"'' "$FILE" | base64 -d -i; break
   fi
done
