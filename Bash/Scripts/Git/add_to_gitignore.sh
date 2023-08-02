#!/usr/bin/env bash 
# This script adds a directory or file to the .gitignore file

function print_err {
    ( printf '\e[1;31m%s\e[0m %s\n' "ERROR" "$*" )
}

[[ "$#" -eq 0 ]] && { print_err "Invalid number of arguments: $#/1+"; exit 1; }
[[ ! -e "$PWD"/.gitignore ]] && { print_err "File not found: .gitignore"; exit 2; }
[[ ! -w "$PWD"/.gitignore ]] && { print_err "No write permissions to: .gitignore"; exit 3; }

function add_to_gitignore {
    for i in "$@"
    do
        printf '%s\n' "$i" >> "$PWD"/.gitignore
    done
}

add_to_gitignore "$@"

exit 0
