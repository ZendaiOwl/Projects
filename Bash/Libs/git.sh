#!/usr/bin/env bash
# Victor-ray, S.

. ./tests.sh
. ./utility.sh

# ---
# Git
# ---

# Updates a Git repository in the current working directory and 
# signs the commit using GPG key before pushing with a message
# Return codes
# 0: Success
# 1: Missing argument(s): Commit message
# 2: Not a Git repository in the current working directory
function Git {
    if [[ "$#" -lt 1 ]]; then
        log 2 "No commit message provided"
        return 1
    elif [[ ! -e "$PWD/.git" ]]
    then
        log 2 "Not a Git repository"
        return 2
    else
        local -r GPG_KEY_ID="E2AC71651803A7F7"
        (
            local -r COMMIT_MESSAGE="࿓❯ $*"
            local -r GIT_COMMIT_ARGS=(
                --signoff
                --gpg-sign="$GPG_KEY_ID"
                --message="$COMMIT_MESSAGE"
            )
            git add "$PWD"
            git commit "${GIT_COMMIT_ARGS[@]}"
            git push
        )
        return 0
    fi
}

function initiate_git {
    ! has_cmd 'git' && { return 1; }
    (
        git init "$PWD"
        cp -n "$HOME"/Templates/Licenses/2023/MIT "$PWD"/LICENSE
        cp -n "$HOME"/Templates/Text/README.md \
              "$HOME"/Templates/Code/Git/.gitignore "$PWD"/
        git_add
        git_commit "First commit"
    )
}

function git_init {
    ! has_cmd 'git' && { return 1; }
    (
        git init "$PWD"
    )
}

function git_add {
    ! has_cmd 'git' && { return 1; }
    [[ ! -e "$PWD/.git" ]] && { return 2; }
    (
        git add "$PWD"
    )
}

function git_push {
    ! has_cmd 'git' && { return 1; }
    [[ ! -e "$PWD/.git" ]] && { return 2; }
    (
        git push
    )
}

# Signs & commits a Git change
# Return codes
# 1: No commit message provided
# 2: Not a Git repository in the current working directory
function git_commit {
    if [[ "$#" -lt 1 ]]
    then
        log 2 "No commit message provided"
        return 1
    elif [[ ! -e "$PWD/.git" ]]
    then
        log 2 "Not a Git repository"
        return 2
    else
        (
            local -r GPG_KEY_ID="E2AC71651803A7F7"
            local -r GIT_COMMIT_ARGS=(
                --signoff
                --gpg-sign="$GPG_KEY_ID"
                --message="࿓❯ $*"
            )
            git commit "${GIT_COMMIT_ARGS[@]}"
        )
    fi
}

# Cleans a Git repository
# Return codes
# 1: Not a Git repository in the current working directory
# 2: Invalid number of arguments
function git_clean {
    [[ ! -e "$PWD/.git" ]] && { return 1; }
    [[ "$#" -ne 0 ]] && { return 2; }
    (
        git gc "$PWD"
    )
}

function git_remote_add {
    ! has_cmd 'git' && { return 1; }
    [[ "$#" -ne 2 ]] && { return 2; }
    (
        git remote add -f "$1" "$2"
    )
}

# -----------
# Git Subtree
# -----------

# $1: Path
# $2: Repository
# $3: Branch
function subtree_add {
    ! has_cmd 'git' && { return 1; }
    if [[ "$#" -eq 3 ]]
    then
        (
            git subtree add --prefix="$1" "$2" "$3"
        )
    else
        return 2
    fi
}

# $1: Path
# $2: Repository
# $3: Branch
function subtree_add_squash {
    ! has_cmd 'git' && { return 1; }
    if [[ "$#" -eq 3 ]]
    then
        (
            git subtree add --prefix="$1" "$2" "$3" --squash
        )
    else
        return 2
    fi
}

# 
# $1: Path to directory for subtree
# $2: Branch
# $3: Merge message
function subtree_merge {
    ! has_cmd 'git' && { return 1; }
    if [[ "$#" -eq 2 ]]
    then
        (
            git subtree merge --prefix="$1" "$2"
        )
    elif [[ "$#" -gt 2 ]]
    then
        (
            git subtree merge --prefix="$1" "$2" \
                --message="࿓❯ ${*:3}"
        )
    else
        return 2
    fi
}

# $1: Path
# $2: Repository
# $3: Branch
# $4: Merge message
function subtree_pull {
    ! has_cmd 'git' && { return 1; }
    if [[ "$#" -eq 3 ]]
    then
        (
            git subtree pull --prefix="$1" "$2" "$3"
        )
    elif [[ "$#" -gt 3 ]]
    then
        (
            git subtree pull --prefix="$1" "$2" "$3" \
                --message="࿓❯ ${*:4}"
        )
    else
        return 2
    fi
}

# $1: Path
# $2: Repository
# $3: Branch
# $4: Merge message
function subtree_pull_squash {
    ! has_cmd 'git' && { return 1; }
    if [[ "$#" -eq 3 ]]
    then
        (
            git subtree pull \
                --squash \
                --prefix="$1" "$2" "$3"
        )
    elif [[ "$#" -gt 3 ]]
    then
        (
            git subtree pull \
                --squash \
                --prefix="$1" "$2" "$3" \
                --message="࿓❯ ${*:4}"
        )
    else
        return 2
    fi
}

# $1: Path
# $2: Repository
function subtree_split {
    ! has_cmd 'git' && { return 1; }
    (
        git subtree split --prefix="$1" "$2"
    )
}

# WiP ------------------------ WiP
# function git_subtree_pull {
#     ! has_cmd 'git' && { return 1; }
#     local OPTIND p r b m OPTION PTH REPO BRANCH MESSAGE
#     while getopts 'p:r:b:m:h:' OPTION
#     do
#         case "$OPTION" in
#             p)
#                 PTH="${OPTARG}"
#             ;;
#             r)
#                 REPO="${OPTARG}"
#             ;;
#             b)
#                 BRANCH="${OPTARG}"
#             ;;
#             m)
#                 MESSAGE="${OPTARG}"
#             ;;
#             h)
#                 printf '%s\n' "Usage:  [-p|-r|-b|-m|-h]"
#                 printf '\t%s\n' "[-p]: Path to subtree directory (*)" \
#                                 "[-r]: Repository name (*)" \
#                                 "[-b]: Branch name (*)" \
#                                 "[-m]: Merge message" \
#                                 "[-h]: Help - Shows this message" \
#                                 "* = Required"
#                 return 0
#             ;;
#             :)
#                 return 1
#             ;;
#             ?)
#                 return 1
#             ;;
#         esac
#     done
#     if [[ -z "$PTH" ]] || [[ -z "$REPO" ]] || [[ -z "$BRANCH" ]]
#     then
#         printf '%s\n' "Missing argument"
#         return 1
#     fi
#     if [[ -n "$MESSAGE" ]]
#     then
#         (
#             git subtree pull \
#                 --squash \
#                 --prefix="$PTH" \
#                 git@github.com:ZendaiOwl/"$REPO" "$BRANCH" \
#                 --message="࿓❯ $MESSAGE"
#         )
#     else
#         (
#             git subtree pull \
#                 --squash \
#                 --prefix="$PTH" \
#                 git@github.com:ZendaiOwl/"$REPO" "$BRANCH"
#         )
#     fi
#     shift "$(($OPTIND -1))"
# }
# WiP ------------------ WiP

# ----------------------
# GitHub - Git & Subtree
# ----------------------

function github_subtree_add {
    ! has_cmd 'git' && { return 1; }
    if [[ "$#" -eq 2 ]]
    then
        (
            git subtree add --prefix="$1" git@github.com:ZendaiOwl/"$1" "$2"
        )
    elif [[ "$#" -eq 3 ]]
    then
        (
            git subtree add --prefix="$1" git@github.com:ZendaiOwl/"$2" "$3"
        )
    
    else
        return 2
    fi
}

function github_subtree_pull {
    ! has_cmd 'git' && { return 1; }
    if [[ "$#" -eq 2 ]]
    then
        (
            git subtree pull --prefix="$1" git@github.com:ZendaiOwl/"$1" "$2"
        )
    elif [[ "$#" -eq 3 ]]
    then
        (
            git subtree pull --prefix="$1" git@github.com:ZendaiOwl/"$2" "$3"
        )
    elif [[ "$#" -gt 3 ]]
    then
        (
            git subtree pull \
                --prefix="$1" git@github.com:ZendaiOwl/"$2" "$3" \
                --message="࿓❯ ${*:4}"
        )
    else
        return 2
    fi
}

function github_subtree_pull_squash {
    ! has_cmd 'git' && { return 1; }
    if [[ "$#" -eq 2 ]]
    then
        (
            git subtree pull --prefix="$1" git@github.com:ZendaiOwl/"$1" "$2" --squash
        )
    elif [[ "$#" -eq 3 ]]
    then
        (
            git subtree pull --prefix="$1" git@github.com:ZendaiOwl/"$2" "$3" --squash
        )
    elif [[ "$#" -gt 3 ]]
    then
        (
            git subtree pull \
                --squash \
                --prefix="$1" git@github.com:ZendaiOwl/"$2" "$3" \
                --message="࿓❯ ${*:4}"
        )
    else
        return 2
    fi
}

function github_subtree_push {
    ! has_cmd 'git' && { return 1; }
    if [[ "$#" -eq 2 ]]
    then
        (
            git subtree push --prefix="$1" git@github.com:ZendaiOwl/"$1" "$2"
        )
    elif [[ "$#" -eq 3 ]]
    then
        (
            git subtree push --prefix="$1" git@github.com:ZendaiOwl/"$2" "$3"
        )
    
    else
        return 2
    fi
}

function github_remote_add {
    ! has_cmd 'git' && { return 1; }
    (
        git remote add -f "$1" git@github.com:ZendaiOwl/"$1".git
    )
}
