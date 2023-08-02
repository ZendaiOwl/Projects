#!/usr/bin/env bash
# § Victor-ray, S.
# § <12261439+ZendaiOwl@users.noreply.github.com>
# 
# Updates a Git repository in the current working directory and 
# signs the commit using GPG key before pushing with a message
# 
# Exit codes
# 0: Success
# 1: Missing command: git
# 2: Not a Git repository in the current working directory
# 3: Missing argument: commit message

trap 'exit "$?"' EXIT ERR SIGTERM SIGABRT

function print_err {
    ( printf '\e[1;31m%s\e[0m %s\n' "ERROR" "$*" )
}

if ! command -v 'git' &>/dev/null; then
  ( print_err "Missing command: git"; exit 1 )
fi

[[ "$#" -lt 1 ]] && {
  ( print_err "No commit message provided"; exit 2 )
}

[[ ! -e "$PWD"/.git ]] && {
  ( print_err "Not a Git repository"; exit 3 )
}

function Git {
    (
        ( git add "$PWD" )
        (
          local -r KEY_ID="E2AC71651803A7F7"
          local -r MESSAGE="࿓❯ $*"
          git commit \
              --signoff \
              --gpg-sign="$KEY_ID" \
              --message="$MESSAGE"
        )
        ( git push )
    )
}

Git "$*"

exit 0



