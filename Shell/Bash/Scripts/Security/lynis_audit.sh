#!/usr/bin/env bash
# § Victor-ray, S.


# If you want to run the software as root (or sudo), 
# we suggest changing the ownership of the files. 
# Use chown -R 0:0 to recursively alter the owner and 
# group and set it to user ID 0 (root). 
# Otherwise Lynis will warn you about the file permissions. 
# After all, you are executing files owned by a non-privileged user.

trap '
[[ -e "$HOME"/tmp ]] && {
    if ! rm --recursive --force "$HOME"/tmp; then
        printf "%s\n" "Failed to remove temporary directory"
    fi
} 
[[ -e ../tmp ]] && {
    if ! cd ..; then
        printf "%s\n" "Failed to change directory one level up"
    fi
    if ! rm --recursive --force "$PWD"/tmp; then
        printf "%s\n" "Failed to remove temporary directory"
    fi
} 
exit "$?"' EXIT ERR SIGTERM SIGABRT

function print_err {
    ( printf '\e[1;31m%s\e[0m %s\n' "ERROR" "$*" )
}

if ! command -v git &>/dev/null; then
    ( print_err "Missing command: git" )
    exit 1
fi

[[ "$#" -ne 0 ]] && {
    ( print_err "Invalid number of arguments: $#/0" )
    exit 2
}

function run_audit {
    local -r TEMPORARY_DIRECTORY="$HOME/tmp"
    if ! ( git clone "https://github.com/CISOfy/lynis" "$TEMPORARY_DIRECTORY" ); then
        ( print_err "Failed to clone git repository" )
        exit 3
    fi
    if ! cd "$TEMPORARY_DIRECTORY"; then
        ( print_err "Failed to change directory to temporary directory" )
        exit 4
    fi
    if [[ -e ./lynis ]]; then
        ( ./lynis audit system )
    else
        ( print_err "Missing file: lynis" )
        exit 5
    fi
}

( run_audit )

exit 0
