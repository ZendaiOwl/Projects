#!/usr/bin/env bash
# =======================
# Author § Victor-ray, S.
# -----------------------


# Displays 8 × 16-bit ANSI bold colours and a blinking effect
# \e[0;34m = Normal
# \e[1;34m = Bold
# \e[2;34m = Light
# \e[3;34m = Italic
# \e[4;34m = Underlined
# \e[5;34m = Blinking
# \e[6;34m = Blinking
# \e[7;34m = Background/Highlighted
# \e[8;34m = Blank/Removed
# \e[9;34m = Crossed over
# \e[K     = Expand background
# These can be combined, ex.
# \e[1;5;m = Blinking Bold
function colour {
    local -r Z='\e[0m'
    local -r COLOUR=('\e[1;37m' '\e[1;36m' '\e[1;35m' '\e[1;34m' 
                     '\e[1;33m' '\e[1;32m' '\e[1;31m' '\e[1;30m' 
                     '\e[5m'    '\e[0m' '\e[1;104m\e[K')
    local -r NAME=("WHITE"  "CYAN"  "PURPLE" "BLUE" 
                   "YELLOW" "GREEN" "RED"    "BLACK" 
                   "BLINK"  "RESET" "EXPAND")
    local -r LENGTH="${#NAME[@]}"
    for (( C = 0; C < "$LENGTH"; C++ ))
    do printf "${COLOUR[$C]}%s${Z} \t%s\n" "${NAME[$C]}" "${COLOUR[$C]}"
    done
}

# -----
# Print
# -----

# Prints a line using printf instead of using echo
# For compatibility and reducing unwanted behaviour
# String: Arguments appended to one line
function print {
    printf '%s\n' "$*"
}

# String: Each argument on a new line
function println {
    printf '%s\n' "$@"
}

# Digit: Arguments appended to one line
function print_digit {
    [[ ! "$*" =~ ^[[:space:][:digit:]]*$ ]] && { return 1; }
    printf '%d' "$@"
    printf '\n'
}

# Digit: Each argument on a new line
function println_digit {
    [[ ! "$*" =~ [[:space:][:digit:]]* ]] && { return 1; }
    printf '%d\n' "$@"
}

# Integer: Arguments appended to one line
function print_int {
    [[ ! "$*" =~ ^[[:space:][:digit:]]*$ ]] && { return 1; }
    printf '%i' "$@"
    printf '\n'
}

# Integer: Each argument on a new line
function println_int {
    [[ ! "$*" =~ ^[[:space:][:digit:]]*$ ]] && { return 1; }
    printf '%i\n' "$@"
}

# Float: Arguments appended to one line
function print_float {
    printf '%f' "$@"
    printf '\n'
}

# Float: Each argument on a new line
function println_float {
    printf '%f\n' "$@"
}

# -----
# Error
# -----

# With timestamp
function print_err {
    log 2 "$(date +%c) $*"
}

# Prints an error log to a given file with timestamp
function err_log {
    if [[ -f "$1" ]]
    then
        log 2 "$(date +%c) ${*:2}" >> "$1"
    else
        log 2 "$(date +%c) ${*:2}" > "$1"
    fi
}

# A log that uses log levels for logging different outputs
# Return codes
# 1: Invalid log level
# 2: Invalid number of arguments
# Log level   | colour
# -2: Debug   | CYAN='\e[1;36m'
# -1: Info    | BLUE='\e[1;34m'
#  0: Success | GREEN='\e[1;32m'
#  1: Warning | YELLOW='\e[1;33m'
#  2: Error   | RED='\e[1;31m'
function log {
    if [[ "$#" -gt 0 ]]; then
        if [[ "$1" =~ [(-2)-2] ]]; then
            case "$1" in
                -2) printf '\e[1;36mDEBUG\e[0m %s\n'   "${*:2}" 1>&2 ;;
                -1) printf '\e[1;34mINFO\e[0m %s\n'    "${*:2}"      ;;
                 0) printf '\e[1;32mSUCCESS\e[0m %s\n' "${*:2}"      ;;
                 1) printf '\e[1;33mWARNING\e[0m %s\n' "${*:2}"      ;;
                 2) printf '\e[1;31mERROR\e[0m %s\n'   "${*:2}" 1>&2 ;;
            esac
        else log 2 "Invalid log level, use: -2|-1|0|1|2"
             return 1
        fi
    else log 2 "Invalid number of arguments: $#/2+"
         return 2 
    fi
}

# -----
# Tests
# -----

# Checks if a given variable is an array or not
# Return codes
# 0: Variable is an array
# 1: Variable is not an array
# 2: Invalid number of arguments
function is_array {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$(declare +a "$1" &>/dev/null; print_int "$?")" -eq 0 ]]
}

# Checks if a given variable contains only digits (positive integers)
function is_digit {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$1" =~ ^[[:digit:]]*$ ]]
}

# Checks if given path is a directory 
# Return codes
# 0: Is a directory
# 1: Not a directory
# 2: Invalid number of arguments
function is_directory {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -d "$1" ]]
}

# Checks if 2 given digits are equal
# Return codes
# 0: Is equal
# 1: Not equal
# 2: Invalid number of arguments
function is_equal {
    [[ "$#" -ne 2 ]] && { return 2; }
    [[ "$1" -eq "$2" ]]
}

# Checks if the first given digit is greater than or equal to the second digit
# Return codes
# 0: Is greater than or equal
# 1: Not greater than or equal
# 2: Invalid number of arguments
function is_equal_or_greater {
    [[ "$#" -ne 2 ]] && { return 2; }
    [[ "$1" -ge "$2" ]]
}

# Checks if a given path is an executable file
# 0: Is executable
# 1: Not executable
# 2: Invalid number of arguments
function is_executable {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -x "$1" ]]
}

# Checks if a given path is a regular file
# 0: Is a file
# 1: Not a file
# 2: Invalid number of arguments
function is_file {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -f "$1" ]]
}

# Test if a function() is available
# Return codes
# 0: Available
# 1: Unvailable
# 2: Too many/few arguments
function is_function {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$(declare -F "$1" &>/dev/null; print_int "$?")" -eq 0 ]]
}

# Checks if the first given digit is greater than the second digit
# Return codes
# 0: Is greater
# 1: Not greater
# 2: Invalid number of arguments
function is_greater {
    [[ "$#" -ne 2 ]] && { return 2; }
    [[ "$1" -gt "$2" ]]
}

# Checks if the first given digit is less than the second digit
# Return codes
# 0: Is less
# 1: Not less
# 2: Invalid number of arguments
function is_less {
    [[ "$#" -ne 2 ]] && { return 2; }
    [[ "$1" -lt "$2" ]]
}

# Checks if 2 given String variables match
# Return codes
# 0: Is a match
# 1: Not a match
# 2: Invalid number of arguments
function is_match {
    [[ "$#" -ne 2 ]] && { return 2; }
    [[ "$1" == "$2" ]]
}

# Checks if a given user is a member of a given group
# Return codes
# 1: Not a user
# 2: Invalid number of arguments
function is_member {
    [[ "$#" -ne 2 ]] && { return 2; }
    ! is_user "$1"   && { return 1; }
    [[ "$(id --groups --name "$1")" == *"$2"* ]]
    
}

# Checks if a given path to a file exists
# Return codes
# 0: Path exist
# 1: No such path
# 2: Invalid number of arguments
function is_path {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -e "$1" ]]
}

# Checks if given path is a named pipe
# Return codes
# 0: Is a named pipe
# 1: Not a named pipe
# 2: Invalid number of arguments
function is_pipe {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -p "$1" ]]
}

# Checks if a given variable is a positive integer
function is_positive_int {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$1" -gt 0 ]]
}

# Checks if a given path is a readable file
# 0: Is readable
# 1: Not readable
# 2: Invalid number of arguments
function is_readable {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -r "$1" ]]
}

# Checks if a given variable has been set and is a name reference
# Return codes
# 0: Is set name reference
# 1: Not set name reference
# 2: Invalid number of arguments
function is_reference {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -R "$1" ]]
}

# Check if user ID executing script is 0 or not
# EUID = Executing User ID
# Return codes
# 0: Is root
# 1: Not root
function is_root {
    [[ "$EUID" -eq 0 ]]
}

# Checks if a given variable has been set and assigned a value.
# Return codes
# 0: Is set
# 1: Not set 
# 2: Invalid number of arguments
function is_set {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -v "$1" ]]
}

# Checks if a given path is a socket
# Return codes
# 0: Is a socket
# 1: Not a socket
# 2: Invalid number of arguments
function is_socket {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -S "$1" ]]
}

# Checks what type a given variable is of:
# alias, keyword, function, builtin, file or ''
# Return codes
# 0: Invalid number of arguments
# 1: Alias
# 2: Builtin
# 3: File
# 4: Function
# 5: Keyword
# 6: Unknown
function is_type {
    [[ "$#" -ne 1 ]] && { return 0; }
    case "$(type -t "$1")" in
           'alias') { return 1; } ;;
         'builtin') { return 2; } ;;
            'file') { return 3; } ;;
        'function') { return 4; } ;;
         'keyword') { return 5; } ;;
                 *) { return 6; } ;;
    esac
}

# Checks if a user exists
# Return codes
# 0: Is a user
# 1: Not a user
# 2: Invalid number of arguments
function is_user {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$(id --user "$1" &>/dev/null; print_int "$?")" -eq 0 ]]
}

# Checks if a given path is a writable file
# 0: Is writable
# 1: Not writable
# 2: Invalid number of arguments
function is_writable {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -w "$1" ]]
}

# Checks if a given String is zero
# Return codes
# 0: Is zero or ""
# 1: Not zero
# 2: Invalid number of arguments
function is_zero {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -z "$1" ]]
}

# Checks if 2 given digits are not equal
# Return codes
# 0: Not equal
# 1: Is equal
# 2: Invalid number of arguments
function not_equal {
    [[ "$#" -ne 2 ]] && { return 2; }
    [[ "$1" -ne "$2" ]]
}

# Checks if 2 given String variables do not match
# Return codes
# 0: Not a match
# 1: Is a match
# 2: Invalid number of arguments
function not_match {
    [[ "$#" -ne 2 ]] && { return 2; }
    [[ "$1" != "$2" ]]
}

# Checks if a given String is not zero
# Return codes
# 0: Not zero
# 1: Is zero
# 2: Invalid number of arguments
function not_zero {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -n "$1" ]]
}

# Checks if a given pattern in a String
# Return codes
# 0: Has String pattern
# 1: No String pattern
# 2: Invalid number of arguments
# $1: [Pattern]
# $2: [String]
# Pattern has to be the right-hand variable in the test expression
function has_text {
    [[ "$#" -ne 2 ]] && { return 2; }
    [[ "$2" == *"$1"* ]]
}

# Checks if a command exists on the system
# Return status codes
# 0: Command exists on the system
# 1: Command is unavailable on the system
# 2: Invalid argument(s)
# $1: Command
function has_cmd {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$(command -v "$1" &>/dev/null; print_int "$?")" -eq 0 ]]
}

#function is_email_html5_standard {
#    [[ "$1" =~ ^([a-zA-Z0-9.!#$%&\'*+/=?^_\`{|}~-]+@[a-zA-Z0-9])$ ]]
#}


# --------
# Calculus
# --------

# Calculation using bc
function bC {
    (
        printf '%s\n' "$*" | bc -l
    )
}

# Calculation using awk
function Calc {
    (
        awk "BEGIN{print $*}"
    )
}

# Arithmetic Addition
# Only integers are acceptable for Bash arithmetic expansion.
# Decimals or numbers of type double/float does not work.
# Return codes
# 0: Success
# 1: Invalid number of arguments
# 2: Invalid values: Not digits
# 3: Error: Not an integer
function Addition {
    [[ "$#" -eq 2 ]] && {
        ! is_digit "$1" || ! is_digit "$2" && { return 2; }
        [[ "$1" == *[.]* || "$2" == *[.]* ]] && { return 3; }
        print_int "$(( "$1" + "$2" ))"
    }
}

# Arithmetic Subtraction
# Only integers are acceptable for Bash arithmetic expansion.
# Decimals or numbers of type double/float does not work.
# Return codes
# 0: Success
# 1: Invalid number of arguments
# 2: Error: Not an integer
function Subtraction {
    [[ "$#" -ne 2 ]] && { return 1; }
    [[ "$1" == *[.]* || "$2" == *[.]* ]] && { return 2; }
    print_int "$(( "$1" - "$2" ))"
}

# Arithmetic Multiplication
# Only integers are acceptable for Bash arithmetic expansion.
# Decimals or numbers of type double/float does not work.
# Return codes
# 0: Success
# 1: Invalid number of arguments
# 2: Error: Not an integer
function Multiplication {
    [[ "$#" -ne 2 ]] && { return 1; }
    [[ "$1" == *[.]* || "$2" == *[.]* ]] && { return 2; }
    print_int "$(( "$1" * "$2" ))"
}

# Arithmetic Division
# Only integers are acceptable for Bash arithmetic expansion.
# Decimals or numbers of type double/float does not work.
# Return codes
# 0: Success
# 1: Invalid number of arguments
# 2: Error: Not an integer
# 3: Error: Attempted division by zero
function Division {
    [[ "$#" -ne 2 ]] && { return 1; }
    [[ "$1" == *[.]* || "$2" == *[.]* ]] && { return 2; }
    [[ "$1" == 0 || "$2" == 0 ]] && { return 3; }
    print_int "$(( "$1" / "$2" ))"
}

# Arithmetic Exponential
# Only integers are acceptable for Bash arithmetic expansion.
# Decimals or numbers of type double/float does not work.
# Return codes
# 0: Success
# 1: Invalid number of arguments
# 2: Error: Not an integer
function Exponential {
    [[ "$#" -ne 2 ]] && { return 1; }
    [[ "$1" == *[.]* || "$2" == *[.]* ]] && { return 2; }
    print_int "$(( "$1" ** "$2" ))"
}

# ---------
# Financial
# ---------

# Calculates the price difference and the percentile increase/decrease
# Return codes
# 1: Invalid number of arguments, requires two: [Old price] and [New price]
# 2: Error: Division by zero attempted
# 3: Failed to calculate the price difference
# 4: Failed to calculate the percentile difference in decimal
# 5: Failed to calculate percentile difference from percentile decimal
function price_diff {
    [[ "$#" != 2 ]] && { return 1; }
    [[ "$1" == 0 || "$2" == 0 ]] && { return 2; }
    println "[ $1 ] Old" \
            "[ $2 ] New" \
            "[ $(Calc "$2"-"$1") ] Difference" \
            "[ $(Calc "$(Calc "$2"-"$1")"/"$1") ] Decimal" \
            "[ $(Calc "$(Calc "$(Calc "$2"-"$1")"/"$1")"*100)% ] Percentile" 
}

# Calculates the percentile a value is of another value
function percentile {
    [[ "$#" != 2 ]] && { return 1; }
    [[ "$1" == 0 || "$2" == 0 ]] && { return 2; }
    println "[ $1 ] Whole" \
            "[ $2 ] Part" \
            "[ $(Calc "$2"/"$1") ] Decimal" \
            "[ $(Calc "$(Calc "$2"/"$1")"*100)% ] Percentage"
}

# TODO A function that calculates compound interest
# on principal with recurring contributions with varying compounding periods



# ---
# Git
# ---

# Updates a Git repository in the current working directory and 
# signs the commit using GPG key before pushing with a message
# Return codes
# 0: Success
# 1: Not a Git repository in the current working directory
# 2: Missing argument(s): Commit message
function Git {
    if [[ "$#" -lt 1 ]]
    then
        log 2 "No commit message provided"
        return 2
    elif [[ ! -e "$PWD/.git" ]]
    then
        log 2 "Not a Git repository"
        return 1
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
    fi
}

function initiate_git {
    ! has_cmd 'git' && { return 1; }
    (
        git init "$PWD"
        [[ -f "$HOME"/Templates/Licenses/2023/MIT ]] && {
            cp -n "$HOME"/Templates/Licenses/2023/MIT "${PWD}/LICENSE"
        }
        [[ -f "$HOME"/Templates/Text/README.md ]] && {
            cp -n "$HOME"/Templates/Text/README.md "${PWD}/README.md"
        }
        [[ -f "$HOME"/Templates/Code/Git/.gitignore ]] && {
            cp -n "$HOME"/Templates/Code/Git/.gitignore "${PWD}/.gitignore"
        }
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

# -------
# Utility
# -------

# Create a tar.xz archive from a directory
# Return codes
# 1: No such PATH to directory exists
# 2: Invalid number of arguments
# 3: Missing command: tar
function create_archive {
    ! has_cmd 'tar' && { log 2 "Missing command: tar"; return 3; }
    [[ "$#" -ne 2 ]] && { return 2; }
    [[ ! -e "$2" ]] && { return 1; }
    local -r ARCHIVE_FILE="$1"
    local -r DIRECTORY="$2"
    tar --verbose \
        --create \
        --use-compress-program="xz --threads=$(nproc)" \
        --file="$ARCHIVE_FILE".tar.xz "$DIRECTORY"
}

# Sorting function
# Return codes
# 1: Invalid number of arguments
function sorting {
    [[ "$#" -eq 0 ]] && { return 1; }
    printf '%s\n' "$@" | sort --dictionary-order
}

# Return codes
# 1: Invalid number of arguments
function sed_environment {
    [[ "$#" -ne 0 ]] && { return 1; }
    set | sed -n '1,/.* () .*/ {
        /.* ().*/n
        p
    }'
}

# Shows the current environment
# Return codes
# 1: Invalid number of arguments
# 2: Missing command: env, printenv & sed
function show_environment {
    [[ "$#" -ne 0 ]] && { return 1; }
    if has_cmd 'env'
    then env
    elif has_cmd 'printenv'
    then printenv
    elif has_cmd 'sed'
    then
        set | sed -n '1,/ () / {
            / () /n
            p
        }'
    else { log 2 "Missing command: env, printenv & sed"; return 2; }
    fi
}


# Removes dangling temporary .bash_history file(s) in the HOME directory
# Return codes
# 0: Temporary .bash_history file(s) have been removed
# 1: No temporary .bash_history file(s) to remove
function clean-up_bash-history {
    for i in "$HOME"/.bash_history-*
    do [[ -f "$i" ]] && { rm "$i"; }
    done
}

# Get system information
# Return codes
# 1: Missing command: inxi
# 2: Invalid number of arguments
function system_info {
    [[ "$#" -ne 0 ]] && { log 2 "Invalid number of arguments: $#/0"; return 2; }
    ! has_cmd 'inxi' && { log 2 "Missing command: inxi"; return 1; }
    inxi -Fxzr
}

# Get filesystem information
# Return codes
# 1: Missing command: inxi
# 2: Invalid number of arguments
function filesystem_info {
    [[ "$#" -ne 0 ]] && { log 2 "Invalid number of arguments: $#/0"; return 2; }
    ! has_cmd 'df' && { log 2 "Missing command: df"; return 1; }
    df --print-type --human-readable
}

# Records the output of a command to a file.
# Return codes
# 1: Missing argument: Command to record
function record_command {
    [[ "$#" -eq 1 ]] && { log 2 "Invalid number of arguments: $#/1"; return 1; }
    local -r LOGFILE='log.txt'
    if [[ -f "$LOGFILE" ]]
    then 
        log -1 "$LOGFILE exists, appending to existing file"
        echo "Appending new output from $1" | tee -a "$LOGFILE"
        bash -c "$1" | tee -a "$LOGFILE"
    else 
        touch "$LOGFILE"; bash -c "$1" | tee -a "$LOGFILE"
        log 0 "Command output recorded to $LOGFILE"
    fi
}

# Checks for a running process
# Return codes
# 0: Running process exists
# 1: No such running process
# 2: Missing argument: process
# 3: Missing command: pgrep
function find_process {
    [[ "$#" -ne 1 ]]  && { log 2 "Invalid number of arguments: $#/1"; return 2; }
    ! has_cmd 'pgrep' && { log 2 "Missing command: pgrep"; return 3; }
    [[ "$(pgrep "$1" &>/dev/null; print_int "$?")" -eq 0 ]]
}

# Checks for a running process by fullname
# Return codes
# 0: Running process exists
# 1: No such running process
# 2: Missing argument: process
# 3: Missing command: pgrep
function find_process_fullname {
    [[ "$#" -ne 1 ]]  && { log 2 "Invalid number of arguments: $#/1"; return 2; }
    ! has_cmd 'pgrep' && { log 2 "Missing command: pgrep"; return 3; }
    [[ "$(pgrep --full "$1" &>/dev/null; print_int "$?")" -eq 0 ]]
}

# Gets processes
# Return codes
# 1: Missing command: ps
function get_processes {
    ! has_cmd 'ps' && { log 2 "Missing command: ps"; return 1; }
    ps -A
}

# Checks running processes
function get_running_processes {
    ! has_cmd 'jobs' && { log 2 "Missing command: jobs"; return 1; }
    jobs -r
}

# Gets the current time in UNIX & regular time (human-readable format)
# Return codes
# 1: Error: Too many arguments provided
function get_time {
    [[ "$#" -gt 0 ]] && { log 2 "Invalid number of arguments: $#/0"; return 1; }
    printf '%s\n' "Regular: $(date -d @"$(date +%s)")" \
                  "Unix: $(date +%s)" \
                  "Date by locale: $(date +%x)" \
                  "Time by locale: $(date +%X)"
}

# Converts UNIX timestamps to regular human-readable timestamp
# Return codes
# 1: Missing argument: UNIX Timestamp
function unix_to_regular_time {
    [[ "$#" -ne 1 ]] && { log 2 "Invalid number of arguments: $#/1"; return 1; }
    println "$(date -d @"$1")"
}

# Gets the time by locale's definition
# Return codes
# 1: Invalid number of arguments
function get_locale_time {
    [[ "$#" -gt 0 ]] && { log 2 "Invalid number of arguments: $#/0"; return 1; }
    date +%X
}

# Gets the date by locale's definition
# Return codes
# 1: Invalid number of arguments
function get_locale_date {
    [[ "$#" -gt 0 ]] && { log 2 "Invalid number of arguments: $#/0"; return 1; }
    date +%x
}

# Uses $(<) to read a file to STDOUT, supposedly faster than cat.
# Return codes
# 0: Success
# 1: Not a file
# 2: Invalid number of arguments
# 2: Missing argument: File
function read_file {
    [[ "$#" -eq 0 ]] && { log 2 "Mising argument: File"; return 3; }
    [[ "$#" -gt 1 ]] && { log 2 "Invalid number of arguments: $#/1"; return 2; }
    [[ ! -f "$1" ]]  && { log 2 "Not a file: $1"; return 1; }
    println "$(<"$1")"
}

# Shows the files in the current working directory's directory & all its sub-directories excluding hidden directories.
# Return codes
# 1: Error: Arguments provided when none required
function show_directory_files {
    [[ "$#" -gt 0 ]] && { log 2 "Invalid number of arguments: $#/0"; return 1; }
    local -r ARGS=(--recursive --files-with-matches --exclude-dir=".*")
    grep "${ARGS[@]}" .
}

# Prints a function() to STDOUT
# Return codes
# 1: Not a function: $1
# 2: Invalid number of arguments
function show_function {
    [[ "$#" -ne 1 ]] && { return 2; }
    ! is_function "$1" && { return 1; }
    local -f "$1"
}

# Show functions and their comments from a script file using 
# grep & a regex pattern
# Return codes
# 1: Missing command: grep
# 2: Invalid number of arguments
# 3: Not a file: $1
function grep_functions {
    ! has_cmd 'grep' && { return 1; }
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ ! -f "$1" ]] && { return 3; }
    grep -e '[#.*function.*.*} ]' "$1"
}

# Counts the number of files recursively from current working directory
# Return codes
# 1: Error: Arguments provided when none required
function count_directory_files {
    [[ "$#" -ne 0 ]] && { log 2 "Invalid number of arguments: $#/0"; return 1; }
    local -r ARGS=(--recursive --files-with-matches --exclude-dir=".*")
    # shellcheck disable=SC2126
    grep "${ARGS[@]}" . | wc --lines
}

# Use sed to count the lines of a file
# Return codes
# 1: No such file: $1
# 2: Invalid number of arguments
function count_lines {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ ! -f "$1" ]]  && { return 1; }
    sed -n '$=' "$1"
}

# Gets the name at the end of a path string after stripping the path
# Return codes
# 1: No such path exists
# 2: Missing argument: Path
function get_path_name {
    [[ "$#" -ne 1 ]] && { log 2 "Invalid number of arguments: $#/1"; return 2; }
    [[ ! -e "$1" ]]  && { log 2 "No such path: $1"; return 1; }
    println "${1##*/}"
}

# Converts a String to uppercase
# Return codes
# 1: Missing argument: String
function upper_case {
    [[ "$#" -eq 0 ]] && { log 2 "Requires: $#/1+ [ String(s) ]"; return 1; }
    println "${*^^}"
}

# Converts the first letter of a String to upper case
# Return codes
# 1: Missing argument: String
function upper_first_letter {
    [[ "$#" -eq 0 ]] && { log 2 "Requires: $#/1+ [ String(s) ]"; return 1; }
    println "${*^}"
}

# Converts a String to lower case
# Return codes
# 1: Missing argument: String
function lower_case {
    [[ "$#" -eq 0 ]] && { log 2 "Requires: $#/1+ [ String(s) ]"; return 1; }
    println "${*,,}"
}

# Converts a String to lower case
# Return codes
# 1: Missing argument: String
function lower_first_letter {
    [[ "$#" -eq 0 ]] && { log 2 "Requires: $#/1+ [ String(s) ]"; return 1; }
    println "${*,}"
}

# Search for a pattern recursively in files of current directory and its sub-directories
# Return codes
# 1: Missing argument: String
# 2: Missing command: grep
function search {
    [[ "$#" -eq 0 ]] && { log 2 "Requires: $#/1+ [ Pattern(s) ]"; return 1; }
    ! has_cmd 'grep' && { log 2 "Missing command: grep"; return 2; }
    local -r ARGS=(--recursive --exclude-dir=".*")
    grep "${ARGS[@]}" "$*" 2>/dev/null
}

# Search for pattern in a specific file
# Return codes
# 1: Not a file
# 2: Missing arguments: String, File
# 3: Missing command: grep
function find_text {
    ! has_cmd 'grep' && { log 2 "Missing command: grep"; return 3; }
    [[ "$#" -ne 2 ]] && { log 2 "Requires: [ Pattern to find ] [ File to search ]"; return 2; }
    [[ ! -f "$2" ]]  && { log 2 "Not a file: $2"; return 1; }
    grep "$1" "$2"
}

# Search for pattern in a specific file
# Return codes
# 1: Not a file
# 2: Missing arguments: String, File
# 3: Missing command: sed
function find_pattern {
    ! has_cmd 'sed'  && { log 2 "Missing command: sed"; return 3; }
    [[ "$#" -ne 2 ]] && { log 2 "Requires: [ Pattern to find ] [ File to search ]"; return 2; }
    [[ ! -f "$2" ]]  && { log 2 "Not a file: $2"; return 1; }
    sed -n '/'"$1"'/p' "$2"
}

# Search for files with pattern(s) recursively
# Return codes
# 1: Missing argument: String
# 2: Command not found: grep
function get_files_with_text {
    ! has_cmd 'grep' && { log 2 "Command not found: grep"; return 2; }
    [[ "$#" -eq 0 ]] && { log 2 "Requires: [ Pattern(s) to locate ]"; return 1; }
    local -r ARGS=(--recursive --files-with-matches --exclude-dir=".*")
    grep "${ARGS[@]}" "$*" 2>/dev/null
}

# Replaces a text pattern in a file with new text
# Return codes
# 1: Not a file
# 2: Missing arguments: String, String, File
# 3: Missing command: sed
function replace_text {
    ! has_cmd 'sed'  && { log 2 "Missing command: sed"; return 3; }
    [[ "$#" -ne 3 ]] && { log 2 "Requires: [ Text to replace ] [ New text ] [ File ]"; return 2; }
    [[ ! -f "$3" ]]  && { log 2 "Not a file: $3"; return 1; }
    sed -i "s|$1|$2|g" "$3"
}

# Replaces given text pattern with a new one in all files recursively from current working directory
# Return codes
# 1: Missing arguments: String, String
# 2: Missing command: sed
function replace_all_text {
    ! has_cmd 'sed'  && { log 2 "Missing command: sed"; return 2; }
    [[ "$#" -ne 2 ]] && { log 2 "Requires: [ Text to replace ] [ New text ]"; return 1; }
    for F in $(get_files_with_text "$1")
    do sed -i "s|$1|$2|g" "$F"
    done
}

# Makes all matching text patterns into camel case String in a file
# Return codes
# 1: Not a file
# 2: Missing arguments: String, File
# 3: Missing command: sed
function make_camel_case {
    ! has_cmd 'sed'  && { log 2 "Missing command: sed"; return 3; }
    [[ "$#" -ne 2 ]] && { log 2 "Requires: [ Text pattern ] [ File ]"; return 2; }
    [[ ! -f "$2" ]]  && { log 2 "Not a file: $2"; return 1; }
    sed -i "s|$1|${1,}|g" "$2"
}

# Makes all matching text patterns into camel case String in a file
# Return codes
# 1: Not a file
# 2: Missing arguments: String, File
# 3: Missing command: sed
function make_snake_case {
    ! has_cmd 'sed'  && { log 2 "Missing command: sed"; return 3; }
    [[ -p /dev/stdin ]] && {
        sed 's/[A-Z]/_\l&/g' /dev/stdin
        return 0
    }
    [[ "$#" -ne 1 ]] && { log 2 "Invalid number of arguments"; return 2; }
    [[ ! -f "$1" ]]  && { log 2 "Not a file: $1"; return 1; }
    sed -i 's/[A-Z]/_\l&/g' "$1"
}

# Makes all matching text patterns into camel case String recursively in all files from current working directory
# Return codes
# 1: Missing argument: String
# 2: Missing command: sed
function make_all_camel_case {
    ! has_cmd 'sed'  && { log 2 "Missing command: sed"; return 2; }
    [[ "$#" -ne 1 ]] && { log 2 "Requires: [ Text pattern ]"; return 1; }
    for F in $(get_files_with_text "$1")
    do sed -i "s|$1|${1,}|g" "$F"
    done
}

# Appends text after line number
# Return codes
# 1: Not a positive integer digit
# 2: Not a file
# 3: Missing arguments: Integer, String, File
# 4: Missing command: sed
function append_at_line {
    ! has_cmd 'sed'  && { log 2 "Missing command: sed"; return 4; }
    [[ "$#" -ne 3 ]] && { log 2 "Requires: Line number, Text to append, File"; return 3; }
    [[ ! -f "$3" ]]  && { log 2 "Not a file: [ $3 ]"; return 2; }
    [[ "$1" -lt 0 ]] && { log 2 "Not a positive integer digit: $1"; return 1; }
    sed -i ''"$1"'a '"$2"'' "$3"
}

# Appends text after matching text pattern
# Return codes
# 1: Not a file
# 2: Missing arguments: String, String, File
# 3: Missing command: sed
function append_at_pattern {
    ! has_cmd 'sed'  && { log 2 "Missing command: sed"; return 3; }
    [[ "$#" -ne 3 ]] && { log 2 "Requires: Locate string, Append string, File"; return 2; }
    [[ ! -f "$3" ]]  && { log 2 "Not a file: $3"; return 1; }
    sed -i '/'"$1"'/a '"$2"'' "$3"
}

# Appends text after the last line
# Return codes
# 1: Not a file
# 2: Missing arguments: String, File
# 3: Missing command: sed
function append_at_last_line {
    ! has_cmd 'sed'  && { log 2 "Missing command: sed"; return 3; }
    [[ "$#" -ne 2 ]] && { log 2 "Requires: Text to append, File"; return 2; }
    [[ ! -f "$2" ]]  && { log 2 "Not a file: $2"; return 1; }
    sed -i '$a '"$1"'' "$2"
}

# Insert text before line number
# Return codes
# 1: Not a file
# 2: Not a positive integer digit
# 3: Missing arguments: Integer, String, File
# 4: Missing command: sed
function insert_at_line {
    ! has_cmd 'sed'  && { log 2 "Missing command: sed"; return 4; }
    [[ "$#" -ne 3 ]] && { log 2 "Requires: Line number, Text to insert, File"; return 3; }
    [[ "$1" -lt 0 ]] && { log 2 "Not a positive integer digit: $1"; return 2; }
    [[ ! -f "$3" ]]  && { log 2 "Not a file: $3"; return 1; }
    sed -i ''"$1"'i '"$2"'' "$3"
}

# Insert text before matching text pattern
# Return codes
# 1: Not a file
# 2: Missing arguments: String, String, File
# 3: Missing command: sed
function insert_at_pattern {
    ! has_cmd 'sed'  && { log 2 "Missing command: sed"; return 3; }
    [[ "$#" -ne 3 ]] && { log 2 "Requires: Text pattern, Text to insert, File"; return 2; }
    [[ ! -f "$3" ]]  && { log 2 "Not a file: $3"; return 1; }
    sed -i '/'"$1"'/i '"$2"'' "$3"
}

# Inserts text before the last line
# Return codes
# 1: Not a file
# 2: Missing arguments: String, File
# 3: Missing command: sed
function insert_at_last_line {
    ! has_cmd 'sed'  && { log 2 "Missing command: sed"; return 3; }
    [[ "$#" -ne 2 ]] && { log 2 "Requires: Text to insert, File"; return 2; }
    [[ ! -f "$2" ]]  && { log 2 "Not a file: $2"; return 1; }
    sed -i '$i '"$1"'' "$2"
}

# Deletes a specified line in a file
# Return codes
# 1: Not a file
# 2: Not a positive integer digit
# 3: Missing arguments: Integer, File
# 4: Missing command: sed
function delete_line {
    ! has_cmd 'sed'  && { log 2 "Missing command: sed"; return 4; }
    [[ "$#" -ne 2 ]] && { log 2 "Requires: Line number, File"; return 3; }
    [[ "$1" -lt 0 ]] && { log 2 "Not a positive integer digit: $1"; return 2; }
    [[ ! -f "$2" ]]  && { log 2 "Not a file: $2"; return 1; }
    sed -i ''"$1"'d' "$2"
}

# Deletes a specified line in a file
# Return codes
# 1: Not a file
# 2: Missing arguments: File
# 3: Missing command: sed
function delete_last_line {
    ! has_cmd 'sed'  && { log 2 "Missing command: sed"; return 3; }
    [[ "$#" -ne 1 ]] && { log 2 "Requires: [ File ]"; return 2; }
    [[ ! -f "$2" ]]  && { log 2 "Not a file: $2"; return 1; }
    sed -i '$d' "$2"
}

# Deletes a specified range in a file
# Return codes
# 1: Not a file
# 2: Not a positive integer digit range
# 3: Missing arguments: Integer, Integer, File
# 4: Missing command: sed
function delete_range {
    ! has_cmd 'sed'  && { log 2 "Missing command: sed"; return 4; }
    [[ "$#" -ne 3 ]] && { log 2 "Requires: Start, End, File"; return 3; }
    [[ ! -f "$3" ]]  && { log 2 "Not a file: $3"; return 2; }
    [[ "$1" -lt 0 || "$2" -lt 0 ]] && { log 2 "Not a positive integer digit range: $1 & $2"; return 1; }
    sed -i ''"$1"','"$2"'d' "$3"
}

# Returns the length or number of variables passed to function
# Return codes
# 1: Invalid nr of arguments
function get_length {
    [[ "$#" -lt 1 ]] && { log 2 "Invalid args: $#/1"; return 1; }
    local -r ARR=("$@")
    printf '%d\n' "${#ARR[@]}"
}

# Returns the length of a string
# Return codes
# 1: Invalid nr of arguments
function string_length {
    [[ "$#" -lt 1 ]] && { log 2 "Invalid number of arguments: $#/1+"; return 1; }
    local -r STR="$*"
    printf '%d\n' "${#STR}"
}

# This function() uses /dev/urandom to generate a password randomly.
# Default length is 36, another length can be specified by 1st argument value
# Ex. This one below uses the most commonly allowed password characters
# < /dev/urandom tr -dc 'A-Z-a-z-0-9' | head -c${1:-32};echo;
# 
# Patterns ex.
# 1: 'A-Za-z0-9'
# 2: 'A-Za-z0-9{[#$@]}'
# 3: 'A-Z a-z0-9{[#$@*-+/]}'
# 4: 'A-Z a-z0-9<{[|?!~$#*-+/]}>'
# 5: 'A-Z a-z0-9<{[|:?!#$@%+*^.~=,-]}>'
# 6: 'A-Z a-z0-9<{[|:?!#$@%+*^.~,=()/\\;]}>'
# 7: 'A-Z a-z0-9<{[|:?!#$@%+*^.~,-()/;]}>'
# 8: 'A-Z a-z0-9<{[|:?!#$@%+*^.~,=()/\\;]}>'
# 9: 'A-Z a-z0-9<{[|:?!#$@%+*^.~,-()/;/=]}>'
# # # # # # # # # # # # # # # # # # # # # # #
#< /dev/urandom tr -dc 'A-Z a-z0-9{[|:?!#$@%+*^.~,=()/\\;]}' | head -c"${1:-36}"; printf '\n';
function gen_passwd {
    < /dev/urandom tr -dc 'A-Za-z0-9{[#$@]}' | head -c"${1:-36}"; printf '\n'
}

# Generates a password using OpenSSL, default length is 36.
# Return codes
# 1: Missing command: openssl
function gen_ssl_passwd {
    ! has_cmd 'openssl' && { log 2 "Missing command: OpenSSL"; return 1; }
    openssl rand -base64 "${1:-36}"
}

# Encrypts a file using GPG2
function encrypt_file {
    [[ "$#" -ne 1 ]] && exit 1
    [[ ! -e "$1" && ! -f "$1" ]] && exit 2
    ! has_cmd 'gpg2' && exit 3
    gpg2 -c "$1"
}

# Decrypts a file using GPG2
function decrypt_file {
    [[ "$#" -ne 1 ]] && exit 1
    [[ ! -e "$1" && ! -f "$1" ]] && exit 2
    ! has_cmd 'gpg2' && exit 3
    gpg2 -d "$1"
}

# Encrypts a String with a password
# Return codes
# 1: Missing command: openssl
# 2: Invalid number of arguments
function crypt_string {
    [[ "$#" -ne 2 ]]    && { return 2; }
    ! has_cmd 'openssl' && { return 1; }
    printf '%s\n' "$1" | openssl enc -aes-256-cbc -md sha512 -a -pbkdf2 -iter 10000 -salt -pass pass:"$2"
}

# Decrypts a String with a password
# Return codes
# 1: Missing command: openssl
# 2: Invalid number of arguments
function decrypt_string {
    [[ "$#" -ne 2 ]]    && { return 2; }
    ! has_cmd 'openssl' && { return 1; }
    printf '%s\n' "$1" | openssl enc -aes-256-cbc -md sha512 -a -d -pbkdf2 -iter 10000 -salt -pass pass:"$2"
}

# Retrieves the members of a group
# Return codes
# 1: Missing argument: Group name
function get_group_members {
    [[ "$#" -eq 1 ]] && { log 2 "Requires: Group name"; return 1; }
    mapfile -d ',' -t GROUP_USERS < <(awk -F':' '/'"$1":'/{printf $4}' /etc/group)
    println "${GROUP_USERS[*]}"
    unset GROUP_USERS
}

# Retrieves the groups a user is a member of
# 0: User exists, show group membership
# 1: No such user exists
function get_user_groups {
    ! is_user "$1" && { log 2 "No such user: $1"; return 1; }
    groups "$1"
}

# Retrieves the group IDs a user is a member of
# 0: Show group membership
# 1: No such user exists
# 2: Invalid number of arguments
function get_user_groups_id {
    [[ "$#" -ne 1 ]] && { log 2 "Invalid number of arguments: $#/1"; return 2; }
    ! is_user "$1"   && { log 2 "No such user: $1"; return 1; }
    id --groups "$1"
}

# -------
# Network
# -------


# Test if a port is open or closed on a remote host
# Exit codes
# 1: Open
# 2: Closed
# 3: Invalid number of arguments
function test_remote_port {
    [[ "$#" -eq 2 ]] && { log 2 "[ $#/2 ] Requires: HOST, PORT"; return 2; }
    if timeout 2.0 bash -c "true &>/dev/null>/dev/tcp/${1}/${2}"
    then log -1 "Open"
    else log -1 "Closed"; return 1
    fi
}

# Queries DNS record of a domain
# Return codes
# 1: Invalid number of arguments
# 2: Missing argument(s): Domain, Optional Domain Record
function get_dns_record {
    [[ "$#" -eq 0  || "$#" -gt 2 ]] && { log 2 "Invalid number of arguments: $#/1-2"; return 1; }
    [[ "$#" -eq 2 ]] && { dig "$1" "$2" +short; }
    [[ "$#" -eq 1 ]] && { dig "$1" +short; }
}

# Gets the public IP for the network
# Return codes
# 1: Missing command: curl
function get_all_public_ip {
    ! has_cmd 'curl' && { log 2 "Missing command: curl"; return 1; }
    local -r URLv4="https://ipv4.icanhazip.com" \
               URLv6="https://ipv6.icanhazip.com" \
               ARGS=(--silent --max-time 4)
    curl "${ARGS[@]}" --ipv4 "$URLv4" 2>/dev/null || println 'N/A'
    curl "${ARGS[@]}" --ipv6 "$URLv6" 2>/dev/null || println 'N/A'
}

# Gets the public IP for the network
# Return codes
# 1: Fail - No public IPv4
# 2: Missing command: curl
function get_public_ipv4 {
    ! has_cmd 'curl' && { log 2 "Missing command: curl"; return 2; }
    local -r URLv4="https://ipv4.icanhazip.com" \
               ARGS=(--silent --max-time 4)
    curl "${ARGS[@]}" --ipv4 "$URLv4" 2>/dev/null || return 1
}

# Gets the public IP for the network
# Return codes
# 1: Fail - No public IPv6
# 2: Missing command: curl
function get_public_ipv6 {
    ! has_cmd 'curl' && { log 2 "Missing command: curl"; return 2; }
    local -r URLv6="https://ipv6.icanhazip.com" \
               ARGS=(--silent --max-time 4)
    curl "${ARGS[@]}" --ipv6 "$URLv6" 2>/dev/null || return 1
}

# Tests for Public IPv4
# Return codes
# 0: Public IPv4 Available
# 1: Public IPv4 Unavailable
# 2: Missing command: curl
function test_public_ipv4 {
    ! has_cmd 'curl' && { log 2 "Missing command: curl"; return 2; }
    local -r URL="https://ipv4.icanhazip.com" \
             ARGS=(--silent --max-time 4 --ipv4)
    if curl "${ARGS[@]}" "$URL" &>/dev/null
    then log -1 "Available"
    else log -1 "Unavailable"; return 1
    fi
}

# Tests for Public IPv6
# Return codes
# 0: Public IPv6 Available
# 1: Public IPv6 Unavailable
# 2: Missing command: curl
function test_public_ipv6 {
    ! has_cmd 'curl' && { log 2 "Missing command: curl"; return 2; }
    local -r URL="https://ipv6.icanhazip.com" \
             ARGS=(--silent --max-time 4 --ipv6)
    if curl "${ARGS[@]}" "$URL" &>/dev/null
    then { log -1 "Available"; return 0; }
    else { log -1 "Unavailable"; return 1; }
    fi
}

# Gets the local IP assigned to the WiFi card for the device
# IPv4, IPv6 & Link-local
function get_local_ip {
    if has_cmd 'jq'
    then ip -j address | jq -r '.[].addr_info[] as $i |
        if $i.scope == "global"
        then
            if $i.family == "inet6"
            then
                if $i.label?
                then "IPv6 " + $i.local + " (" + $i.label  + ")"
                else "IPv6 " + $i.local
                end
            else
                if $i.label?
                then "IPv4 " + $i.local + " (" + $i.label  + ")"
                else "IPv4 " + $i.local
                end
            end
        else empty
        end'
    else ip a | grep 'scope global' | awk '{print $2}' | head -2 | sed 's|/.*||g'
    fi
}

# Gets all the local IP-addresses on the device
function get_all_local_ip {
    if has_cmd 'jq'
    then ip -j address | jq -r '.[].addr_info[].local'
    else ip a | grep 'inet' | awk '{print $2}' | sed 's|/.*||g'
    fi
}

# Get device IP information
# Return codes
# 1: Invalid number of arguments
function get_ip_info {
    [[ "$#" -gt 0 ]] && { log 2 "Invalid number of arguments: $#/0"; return 1; }
    if has_cmd 'jq'
    then ip -j address | jq '.'
    else ip address
    fi
}

# Gets the listening ports on the system
# Return codes
# 1: Missing command: grep
# 2: Missing command: lsof
# 3: No root privileges
function get_listening_services {
    ! has_cmd 'lsof' && { log 2 "Missing command: lsof"; return 2; }
    ! has_cmd 'grep' && { log 2 "Missing command: grep"; return 1; }
    if is_root
    then grep 'LISTEN' <(lsof -i -P -n)
    elif has_cmd 'sudo'
    then sudo lsof -i -P -n | grep 'LISTEN'
    else log 2 "No root privileges"; return 3
    fi
}

# Gets the services running on the network interfaces
# Return code
# 1: Missing command: lsof
# 2: Missing command: sudo (No root privileges)
function network_interface_services {
    ! has_cmd 'lsof' && { log 2 "Missing command: lsof"; return 1; }
    if is_root
    then lsof -n -P -i
    elif has_cmd 'sudo'
    then sudo lsof -n -P -i
    else { log 2 "No root privileges"; return 2; }
    fi
}

# Gets the HTML code for a URL with Bash TCP
# Reuires the host TCP server to listen on HTTP, not HTTPS, it'a a plain HTTP request
# Return codes
# 1: Arguments error, requires: Host, Port
function get_url {
    [[ "$#" -ne 2 ]] && { log 2 "[ $#/2 ] Requires: HOST, PORT"; return 1; }
    exec 5<>/dev/tcp/"$1"/"$2"
    echo -e "GET / HTTP/1.1\r\nHost: ${1}\r\nConnection: close\r\n\r" >&5
    cat <&5
    
}

# Loops through HTML elements that are fed into the function through a pipe via STDIN
function html_next {
    local IFS='>'
    # shellcheck disable=SC2034
    read -r -d '<' TAG VALUE
}

# ------
# Crypto
# ------

# Fetches the current price of Bitcoin in Euro € from Binance
# Return codes
# 1: Missing command: curl
function get_btc {
    ! has_cmd 'curl' && { log 2 "Missing command: curl"; return 1; }
    local -r URL="https://api.binance.com/api/v3/ticker/price?symbol=BTCEUR" \
               ARGS=(--silent --location)
    if ! has_cmd 'jq'
    then curl "${ARGS[@]}" "$URL"
    else curl "${ARGS[@]}" "$URL" | jq '.'
    fi
}

# Checks and tests so the commands for the BTC functions are present
function check_btc_query_commands {
    if ! has_cmd 'curl' || ! has_cmd 'jq'
    then
        return 1
    else
        return 0
    fi
}

# API information from BTC.com to query the Bitcoin blockchain
# Source: https://explorer.btc.com/btc/adapter?type=api-doc
# Source: https://www.blockchain.com/explorer/api/blockchain_api
function btc_query {
    if [[ "$#" -ne 1 ]] || ! check_btc_query_commands
    then
        return 1
    fi
    local DATA_ADDRESS DATA_TX
    DATA_ADDRESS="$(btc_query_address "$1")"
    DATA_TX="$(btc_query_balance "$1")"
    if is_json_object "$DATA_ADDRESS"
    then
        json_read "$DATA_ADDRESS"
    fi
    if is_json_object "$DATA_TX"
    then
        json_read "$DATA_TX"
    fi
}

# Checks the data for a given BTC address
function btc_address {
    if [[ "$#" -ne 1 ]] || ! check_btc_query_commands
    then
        return 1
    fi
    local -r URL="https://blockchain.info/rawaddr/$1"
    local DATA
    DATA="$(curl --silent --location "$URL")"
    if [[ "$DATA" ]]
    then
        json_read "$DATA"
    else
        return 2
    fi
}

# Checks the data for a given BTC transaction
function btc_transaction {
    if [[ "$#" -ne 1 ]] || ! check_btc_query_commands
    then
        return 1
    fi
    local -r URL="https://blockchain.info/rawtx/$1"
    local DATA
    DATA="$(curl --silent --location "$URL")"
    if [[ "$DATA" ]]
    then
        json_read "$DATA"
    fi
}

# Checks the current balance for a BTC wallet address
function btc_balance {
    if ! check_btc_query_commands
    then
        return 1
    fi
    local -r URL="https://blockchain.info/balance?active=$1"
    local DATA
    DATA="$(curl --silent --location "$URL")"
    if [[ "$DATA" ]]
    then
        json_read "$DATA"
    else
        return 2
    fi
}

# Checks the balance or the remainder of unspent BTC on a given wallet address
function btc_address_unspent {
    if ! check_btc_query_commands
    then
        return 1
    fi
    local -r URL="https://blockchain.info/unspent?active=$1"
    local DATA
    DATA="$(curl --silent --location "$URL")"
    if [[ "$DATA" ]]
    then
        json_read "$DATA"
    fi
}

# Checks a given BTC block
function btc_block {
    if [[ "$#" -ne 1 ]] || ! check_btc_query_commands
    then
        return 1
    fi
    local URL="https://blockchain.info/rawblock/$1"
    local DATA
    DATA="$(curl --silent --location "$URL")"
    if [[ "$DATA" ]]
    then
        json_read "$DATA"
    fi
}

# Generate RPC authentication credentials for the Bitcoin Client
function btc_rpc_auth {
    if [[ "$#" -ne 1 ]] || ! check_btc_query_commands || ! has_cmd 'python3'
    then
        return 1
    fi
    curl -sSL "https://raw.githubusercontent.com/bitcoin/bitcoin/master/share/rpcauth/rpcauth.py" \
    | python3 - "$1"
}

# -----
# Audio
# -----

# Converts an MP4 audio file to WAV audio format
# $1: Input MP4 audio file
# $2: Output name for WAV audio file
function mp4_to_wav {
    [[ "$#" -ne 2 ]] && return 2
    [[ ! -f "$1" ]] && return 1
    ffmpeg -i "$1" -ac 2 -f wav "$2"
}

# -----------
# Permissions
# -----------


# Changes permissions on a given file
# 0: Success
# 1: Failed to change permissions
# 2: No root privileges
# 3: Not a file: $2
# 4: Invalid number of arguments
function set_owner {
    not_equal "$#" 2 && { return 4; }
    ! is_path "$2"   && { return 3; }
    if is_root
    then chown "$1" "$2" || { return 1; }
    elif has_cmd 'sudo'
    then sudo chown "$1" "$2" || { return 1; }
    else return 2
    fi
}

# Changes permissions on a given file
# 0: Success
# 1: Failed to change permissions
# 2: No root privileges 
# 3: Not a file: $2
# 4: Invalid number of arguments
function set_owner_recursive {
    not_equal "$#" 2 && { return 4; }
    ! is_path "$2"   && { return 3; }
    if is_root
    then chown --recursive "$1" "$2" || { return 1; }
    elif has_cmd 'sudo'
    then sudo chown --recursive "$1" "$2" || { return 1; }
    else return 2
    fi
}

# Changes permissions on a given file
# 0: Success
# 1: Failed to change permissions
# 2: No root privileges
# 3: Not a digit: $1
# 4: Not a path: $2
# 5: Invalid number of arguments
function set_permissions {
    not_equal "$#" 2 && { return 5; }
    ! is_path "$2"   && { return 4; }
    ! is_digit "$1"  && { return 3; }
    if is_root
    then chmod "$1" "$2" || { return 1; }
    elif has_cmd 'sudo'
    then sudo chmod "$1" "$2" || { return 1; }
    else return 2
    fi
}

# Changes permissions on a given file
# 0: Success
# 1: Failed to change permissions
# 2: No root privileges 
# 3: Not a digit: $1
# 4: Not a path: $2
# 5: Invalid number of arguments
function set_permissions_recursive {
    not_equal "$#" 2 && { return 5; }
    ! is_path "$2"   && { return 4; }
    ! is_digit "$1"  && { return 3; }
    if is_root
    then chmod --recursive "$2" "$1" || { return 1; }
    elif has_cmd 'sudo'
    then sudo chmod --recursive "$2" "$1" || { return 1; }
    else return 2
    fi
}

# Makes a file executable
# Return status codes
# 1: Failed to make file executable
# 2: Missing root privileges: sudo
# 3: Not a file: $1
# 4: Invalid number of arguments
function make_executable {
    not_equal "$#" 1 && { return 4; }
    ! is_file "$1"   && { return 3; }
    if is_root; then
        chmod +x "$1" || { return 1; }
    elif has_cmd 'sudo'
    then sudo chmod +x "$1" || { return 1; }
    else return 2
    fi
}

# Make files executable recursively
# Return status codes
# 1: Failed to make files executable
# 2: No root privileges
# 3: Not a file or directory: $1
# 4: Invalid number of arguments
function make_executable_recursive {
    not_equal "$#" 1 && { return 4; }
    ! is_path "$1"   && { return 3; }
    if is_root; then
        chmod --recursive +x "$1" || { return 1; }
    elif has_cmd 'sudo'
    then sudo chmod --recursive +x "$1" || { return 1; }
    else return 2
    fi
}

# ------
# Docker
# ------
# Template
# Return codes
# 0: 
# 1:
# 2:
# 3:


# Get the images names, tag & repository
# Return codes
# 1: Command not found: docker
# 2: Command not found: awk
# 3: Invalid number of arguments
function get_images {
    ! has_cmd 'docker' && { return 2; }
    ! has_cmd 'sed'    && { return 1; }
    docker images | sed -n 's|/*||p' | tail -n +2
}

# Get the Container ID & Name of running containers
# Return codes
# 1: Command not found: docker
# 2: Command not found: awk
# 3: Invalid number of arguments
function get_containers {
    ! has_cmd 'docker' && { return 2; }
    ! has_cmd 'sed'    && { return 1; }
    docker ps | sed -n 's|/*||p' | tail -n +2
}

# Get the Container ID of all running containers
# Return codes
# 1: Command not found: docker
# 2: Command not found: awk
# 3: Invalid number of arguments
function container_id_all {
    not_equal "$#" 0   && { return 3; }
    ! has_cmd 'awk'    && { return 2; }
    ! has_cmd 'docker' && { return 1; }
    docker ps | awk '{print $1}' | tail -n +2
}

# Gets the latest Container ID of the running containers
# Return codes
# 1: Command not found: awk
# 2: Command not found: docker
# 3: Invalid number of arguments
function container_id_latest {
    not_equal "$#" 0   && { return 3; }
    ! has_cmd 'docker' && { return 2; }
    ! has_cmd 'awk'    && { return 1; }
    docker ps | awk '{print $1}' | tail -n +2 | head -1
}

# Checks if the executing user is a member of the docker group
# 0: Is a member of group: docker
# 1: Not a member of group: docker
# 2: Invalid number of arguments
# shellcheck disable=SC2120
function in_docker_group {
    not_equal "$#" 0 && { return 2; }
    if is_member "$EUID" 'docker'
    then return 0
    else return 1
    fi
}

# Removes the latest Docker image
function remove_latest_image {
    ! has_cmd 'docker' && { return 2; }
    ! has_cmd 'awk'    && { return 1; }
    if is_root || in_docker_group
    then docker rmi "$(docker images | awk '{print $3}' | tail -n +2 | head -1)"
    else sudo docker rmi "$(sudo docker images | awk '{print $3}' | tail -n +2 | head -1)"
    fi
}

# ----
# JSON
# ----

# Tests a given variable what JQ recognizes it as by type: Object or String 
function test_json {
    [[ "$#" -ne 1 ]] && return 4
    if jq 'type' <<<"$1" &>/dev/null
    then
        case $(jq 'type' <<<"$1") in
            '"object"')
                return 0
            ;;
            '"string"')
                return 1
            ;;
            *)
                return 2
            ;;
        esac
    else
        return 3
    fi
}

# Checks if a given variable is a valid JSON format
function is_json {
    ! has_cmd 'jq' && return 1
    case "$#" in
        1)
            [[ "$(jq --null-input "$1" &>/dev/null; print_digit "$?")" -eq 0 ]]
        ;;
        *)
            print_err "Invalid nr of arguments: $#/1"
            return 2
        ;;
    esac
}

# Checks if a given variable is a JSON file
function is_json_file {
    ! has_cmd 'jq' && return 1
    case "$#" in
        1)
            [[ -f "$1" && "$(jq < "$1" &>/dev/null; print_digit "$?")" -eq 0 ]]
        ;;
        *)
            print_err "Invalid nr of arguments: $#/1"
            return 2
        ;;
    esac
}

# Checks if a given variable is a JSON object
function is_json_object {
    case "$#" in
        1)
            [[ "$(test_json "$1"; print_digit "$?")" -eq 0 ]]
        ;;
        *)
            print_err "Invalid nr of arguments: $#/1"
            return 2
        ;;
    esac
}

# Checks if a given variable is a JSON string
function is_json_string {
    case "$#" in
        1)
            [[ "$(test_json "$1"; print_digit "$?")" -eq 1 ]]
        ;;
        *)
            print_err "Invalid nr of arguments: $#/1"
            return 2
        ;;
    esac
}

# Checks & prints the keys for a given JSON object
function json_keys {
    ! has_cmd 'jq' && return 1
    case "$#" in
        1)
            if is_json_file "$1" || is_json "$1"
            then
                jq 'keys' "$1"
            else
                print_err "Invalid: $1"
                return 1
            fi
        ;;
        2)
            if is_json_file "$2" || is_json "$2"
            then
                if [[ "$1" == .* ]]
                then
                    jq ''"$1"' | keys' "$2"
                else
                    jq '.'"$1"' | keys' "$2"
                fi
            else
                print_err "Invalid: $1"
                return 1
            fi
        ;;
        *)
            print_err "Invalid nr of arguments: $#/1|2"
            return 1
        ;;
    esac
}

# Checks & prints the length of a JSON object
function json_length {
    ! has_cmd 'jq' && return 1
    case "$#" in
        1)
            if is_json_file "$1"
            then
                jq 'length' "$1"
            elif is_json "$1"
            then
                jq 'length' <<<"$1"
            else
                print_err "Invalid: $1"
                return 1
            fi
        ;;
        2)
            if is_json_file "$2"
            then
                if [[ "$1" == .* ]]
                then
                    jq ''"$1"' | length' "$2"
                else
                    jq '.'"$1"' | length' "$2"
                fi
            elif is_json "$2"
            then
                if [[ "$1" == .* ]]
                then
                    jq ''"$1"' | length' <<<"$2"
                else
                    jq '.'"$1"' | length' <<<"$2"
                fi
            else
                print_err "Invalid: $1"
                return 1
            fi
        ;;
        *)
            print_err "Invalid nr of arguments: $#/1|2"
            return 1
        ;;
    esac
}

# Reads a JSON object, string or file
function json_read {
    ! has_cmd 'jq' && return 1
    case "$#" in
        0)
            [[ -p /dev/stdin ]] && { jq < /dev/stdin; }
        ;;
        1)
            if [[ ! -f "$1" ]]
            then
                if is_json "$1"
                then
                    jq '.' <<<"$1"
                else
                    if [[ -p /dev/stdin ]]
                    then
                        if [[ "$1" == .* ]]
                        then
                            jq ''"$1"'' < /dev/stdin
                        else
                            jq '.'"$1"'' < /dev/stdin
                        fi
                    else
                        print_err "Invalid input: $1"
                        return 2
                    fi
                fi
            else
                if [[ -p /dev/stdin ]]
                then
                    if [[ "$1" == .* ]]
                    then
                        jq ''"$1"'' < /dev/stdin
                    else
                        jq '.'"$1"'' < /dev/stdin
                    fi
                else
                    jq '.' "$1"
                fi
            fi
        ;;
        2)
            if [[ ! -f "$2" ]]
            then
                if is_json "$2"
                then
                    if [[ "$1" == .* ]]
                    then
                        jq ''"$1"'' <<<"$2"
                    else
                        jq '.'"$1"'' <<<"$2"
                    fi
                else
                    print_err "Invalid input: $2"
                    return 2
                fi
            else
                if [[ "$1" == .* ]]
                then
                    jq ''"$1"'' "$2"
                elif [[ "$1" == -* ]]
                then
                    jq "$1" '.' "$2"
                else
                    jq '.'"$1"'' "$2"
                fi
            fi
        ;;
        3)
            if [[ ! -f "$3" ]]
            then
                if is_json "$3"
                then
                    if [[ "$2" == .* ]]
                    then
                        jq "$1" ''"$2"'' <<<"$3"
                    else
                        jq "$1" '.'"$2"'' <<<"$3"
                    fi
                else
                    print_err "Invalid input: $3"
                    return 2
                fi
            else
                if [[ "$2" == .* ]]
                then
                    jq "$1" ''"$2"'' "$3"
                else
                    jq "$1" '.'"$2"'' "$3"
                fi
                
            fi
        ;;
        *)
            print_err "Nr of arguments are invalid: $#/1|2|3"
            return 3
        ;;
    esac
}

# Creates a JSON object from a given variable
function json_new {
    ! has_cmd 'jq' && return 1
    case "$#" in
        0)
            [[ -p /dev/stdin ]] && { jq < /dev/stdin; }
        ;;
        1)
            if is_json "$1"
            then
                if [[ -p /dev/stdin ]]
                then
                    jq "$1" < /dev/stdin
                else
                    jq --null-input "$1"
                fi
            else
                print_err "Invalid input: $1"
                return 2
            fi
        ;;
        2)
            if is_json "$2"
            then
                jq "$1" <<<"$2"
            elif is_json_file "$2"
            then
                jq "$1" "$2"
            else
                print_err "Invalid input: $2"
                return 2
            fi
        ;;
        3)
            if is_json "$3"
            then
                if [[ "$2" == .* ]]
                then
                    jq "$1" ''"$2"'' <<<"$3"
                else
                    jq "$1" '.'"$2"'' <<<"$3"
                fi
            elif is_json_file "$3"
            then
                if [[ "$2" == .* ]]
                then
                    jq "$1" ''"$2"'' "$3"
                else
                    jq "$1" '.'"$2"'' "$3"
                fi
            else
                print_err "Invalid input: $3"
                return 2
            fi
        ;;
        *)
            print_err "Invalid nr of arguments: $#/STDIN(0)|1|2|3"
            return 3
        ;;
    esac
}

# WiP - Work-in-Progress
# Intended to build a JSON object using variables and argument options, incomplete
function json_create_object {
    local ARGS=("$@") KEYS=() VALUES=() OBJECT DIGIT
    for (( X = 0; X < "${#@}"; X += 1 ))
    do
        case "${ARGS[$X]}" in
            -k|--key)
                DIGIT=$(( "$X" + 1 ))
                KEYS+=("${ARGS[$DIGIT]}")
            ;;
            -v|--value)
                DIGIT=$(( "$X" + 1 ))
                VALUES+=("${ARGS[$DIGIT]}")
            ;;
            *)
                if is_json_object "${ARGS[$X]}"
                then
                    VALUES+=("${ARGS[$X]}")
                else
                    continue
                fi
            ;;
        esac
    done
    [[ "${#VALUES[@]}" -ne "${#KEYS[@]}" ]] && {
        print "Keys and values don't match"
    }
    print "Keys: ${KEYS[*]}"
    print "Values: ${VALUES[*]}"
    for (( Y = 0; Y < "${#KEYS[@]}"; Y += 1 ))
    do
        if [[ "$Y" -eq $(("${#KEYS[@]}" - 1)) ]]
        then
            if is_json "${VALUES[$Y]}"
            then
                OBJECT+='{"'"${KEYS[$Y]}"'":'"${VALUES[$Y]}"'}'
            else
                OBJECT+='{"'"${KEYS[$Y]}"'":"'"${VALUES[$Y]}"'"}'
            fi
        else
            OBJECT+='{"'"${KEYS[$Y]}"'":"'"${VALUES[$Y]}"'"},'
        fi
    done
    json_new "[$OBJECT]"
    #json_add "[]" "[$OBJECT]"
}

# Creates a JSON array object from given argument variables
function json_create_array {
    local STR='[' COUNT=0
    for X in "$@"
    do
        COUNT=$(("$COUNT" + 1))
        if [[ ! "$X" =~ ^\".*\"$ && ! "$X" =~ [0-9*] ]]
        then
            if [[ "$COUNT" -eq "$#" ]]
            then
                STR+="\"$X\""
            else
                STR+="\"$X\","
            fi
        elif [[ "$X" =~ [0-9*] ]]
        then
            if [[ "$COUNT" -eq "$#" ]]
            then
                STR+="$X"
            else
                STR+="$X,"
            fi
        else
            if [[ "$COUNT" -eq "$#" ]]
            then
                STR+="$X"
            else
                STR+="$X,"
            fi
        fi
    done
    STR+=']'
    print "$STR"
}

# Updates the value of a given key in a JSON object
function json_update {
    case "$#" in
        3)
            json_set "$@"
        ;;
        4)
            if [[ "${1,,}" =~ ^(-w|--w)$ ]]
            then
                local DATA
                DATA="$(json_set "${@:2}" | jq -ac)"
                print "$DATA" > "$4"
                print "File updated: $4"
            else
                print_err "Invalid option: $1"
                return 1
            fi
        ;;
        *)
            print_err "Invalid number of arguments: $#/3|4"
            return 1
        ;;
    esac
}

# $1: File or JSON Object
# $2: New JSON value to set
# $3: Path to JSON key for the new value
function json_setpath {
    ! has_cmd 'jq' && return 1
    case "$#" in
        [3-9*]|[1-9*][1-9*])
            if is_json_file "$1" || is_json "$1"
            then
                if [[ "$2" =~ ^\".*\"$ ]]
                then
                    jq 'setpath('"$(json_create_array "${*:3}")"'; '"$2"')' "$1"
                else
                    jq 'setpath('"$(json_create_array "${*:3}")"'; "'"$2"'")' "$1"
                fi
            else
                print_err "Invalid file/json: $1"
                return 1
            fi
        ;;
        *)
            print_err "Invalid number of arguments: $#"
            return 1
        ;;
    esac
}

# Sets the value of a given key in a JSON object
function json_set {
    ! has_cmd 'jq' && return 1
    case "$#" in
        2)
            if ! is_json "$1"
            then
                print_err "Invalid value, not a JSON object: $1"
                return 3
            fi
            if [[ ! -f "$2" ]]
            then
                if ! is_json "$2"
                then
                    print_err "Invalid input, not a JSON object or a file: $2"
                    return 3
                elif ! jq --argjson value "$1" '. = $value' <<<"$2" &>/dev/null
                then
                    print_err "Mismatched values cannot be added together, ex. array to object or object to array"
                    return 1
                else
                    jq --argjson value "$1" '. = $value' <<<"$2"
                fi
            else
                if ! jq --argjson value "$1" '. = $value' "$2" &>/dev/null
                then
                    print_err "Mismatched values cannot be added together, ex. array to object or object to array"
                    return 1
                else
                    jq --argjson value "$1" '. = $value' "$2"
                fi
            fi
        ;;
        3)
            local JSON="$2"
            if ! is_json "$JSON" \
            && ! is_json "\"$JSON\""
            then
                print_err "Invalid value: $JSON"
                return 2
            elif is_json "\"$JSON\""
            then
                JSON="\"$JSON\""
            fi
            if [[ -f "$3" ]]
            then
                if [[ "$1" == .* ]]
                then
                    if ! jq --argjson value "$JSON" ''"$1"' = $value' "$3" &>/dev/null
                    then
                        print_err "Mismatched values cannot be added together, ex. array to object or object to array"
                        return 1
                    else
                        jq --argjson value "$JSON" ''"$1"' = $value' "$3"
                    fi
                else
                    if ! jq --argjson value "$JSON" '.'"$1"' = $value' "$3" &>/dev/null
                    then
                        print_err "Mismatched values cannot be added together, ex. array to object or object to array"
                        return 1
                    else
                        jq --argjson value "$JSON" '.'"$1"' = $value' "$3"
                    fi
                fi
            elif is_json "$3"
            then
                if [[ "$1" == .* ]]
                then
                    if ! jq --argjson value "$JSON" ''"$1"' = $value' <<<"$3" &>/dev/null
                    then
                        print_err "Mismatched values cannot be added together, ex. array to object or object to array"
                        return 1
                    else
                        jq --argjson value "$JSON" ''"$1"' = $value' <<<"$3"
                    fi
                else
                    if ! jq --argjson value "$JSON" '.'"$1"' = $value' <<<"$3" &>/dev/null
                    then
                        print_err "Mismatched values cannot be added together, ex. array to object or object to array"
                        return 1
                    else
                        jq --argjson value "$JSON" '.'"$1"' = $value' <<<"$3"
                    fi
                fi
            else
                print_err "Invalid: $3"
                return 2
            fi
        ;;
        *)
            print_err "Nr of arguments are invalid: $#"
            return 4
        ;;
    esac
}

# Adds a value to a given key in a JSON object
function json_add {
    case "$#" in
        2)
            json_append "$@"
        ;;
        3)
            json_append "$@"
        ;;
        4)
            if [[ "${1,,}" =~ ^(-w|--w)$ ]]
            then
                if [[ -f "$4" ]]
                then
                    local DATA
                    DATA="$(json_append "${@:2}" | jq -ac)"
                    print "$DATA" > "$4"
                    print "File updated: $4"
                else
                    print_err "Invalid: $4"
                    return 3
                fi
            else
                print_err "Invalid option: $1"
                return 2
            fi
        ;;
        *)
            print_err "Invalid number of arguments: $#"
            return 1
        ;;
    esac
}

# Appends a value to a given key in a JSON object
function json_append {
    ! has_cmd 'jq' && return 2
    case "$#" in
        2)
            if is_json "$1"
            then
                if [[ ! -f "$2" ]]
                then
                    if is_json "$2"
                    then
                        if ! jq --argjson value "$1" '. += $value' <<<"$2" &>/dev/null
                        then
                            print_err "Mismatched values cannot be added together, ex. array to object or object to array"
                            return 1
                        else
                            jq --argjson value "$1" '. += $value' <<<"$2"
                        fi
                    fi
                else 
                    if ! jq --argjson value "$1" '. += $value' "$2" &>/dev/null
                    then
                        print_err "Mismatched values cannot be added together, ex. array to object or object to array"
                        return 1
                    else
                        jq --argjson value "$1" '. += $value' "$2"
                    fi
                fi
            else
                print_err "Invalid value: $1"
                return 1
            fi
        ;;
        3)
            if is_json "$2"
            then
                if [[ -f "$3" ]]
                then
                    if [[ "$1" == .* ]]
                    then
                        if ! jq --argjson value "$2" ''"$1"' += $value' "$3" &>/dev/null
                        then
                            print_err "Mismatched values cannot be added together, ex. array to object or object to array"
                            return 1
                        else
                            jq --argjson value "$2" ''"$1"' += $value' "$3"
                        fi
                    else
                        if ! jq --argjson value "$2" '.'"$1"' += $value' "$3" &>/dev/null
                        then
                            print_err "Mismatched values cannot be added together, ex. array to object or object to array"
                            return 1
                        else
                            jq --argjson value "$2" '.'"$1"' += $value' "$3"
                        fi
                    fi
                elif is_json "$3"
                then
                    if [[ "$1" == .* ]]
                    then
                        if ! jq --argjson value "$2" ''"$1"' += $value' <<<"$3" &>/dev/null
                        then
                            print_err "Mismatched values cannot be added together, ex. array to object or object to array"
                            return 1
                        else
                            jq --argjson value "$2" ''"$1"' += $value' <<<"$3"
                        fi
                    else
                        if ! jq --argjson value "$2" '.'"$1"' += $value' <<<"$3" &>/dev/null
                        then
                            print_err "Mismatched values cannot be added together, ex. array to object or object to array"
                            return 1
                        else
                            jq --argjson value "$2" '.'"$1"' += $value' <<<"$3"
                        fi
                    fi
                else
                    print_err "Invalid: $3"
                fi
            else
                print_err "Invalid: $2"
            fi
        ;;
        *)
            print_err "Nr of arguments are invalid: $#"
            return 4
        ;;
    esac
}

# Deletes a value of a given key in a JSON object
function json_delete {
    ! has_cmd 'jq' && return 1
    case "$#" in
        2)
            if [[ -f "$2" ]]
            then
                if [[ "$1" == .* ]]
                then
                    jq 'del('"$1"')' "$2"
                else
                    jq 'del(.'"$1"')' "$2"
                fi
            else
                if is_json "$2"
                then
                    if [[ "$1" == .* ]]
                    then
                        jq 'del('"$1"')' "$2"
                    else
                        jq 'del(.'"$1"')' "$2"
                    fi
                else
                    print_err "Invalid input, neither file nor JSON: $2"
                    return 1
                fi
            fi
        ;;
        3)
            if [[ "${1,,}" =~ ^(-w|--w)$ ]]
            then
                local DATA
                if [[ -f "$3" ]]
                then
                    if [[ "$2" == .* ]]
                    then
                        DATA="$(jq -ac 'del('"$2"')' "$3")"
                    else
                        DATA="$(jq -ac 'del(.'"$2"')' "$3")"
                    fi
                    print "$DATA" > "$3"
                    print "File updated: $3"
                else
                    if is_json "$3"
                    then
                        if [[ "$2" == .* ]]
                        then
                            jq -ac 'del('"$2"')' "$3"
                        else
                            jq -ac 'del(.'"$2"')' "$3"
                        fi
                    else
                        print_err "Invalid input, neither file nor JSON: $3"
                        return 1
                    fi
                fi
            else
                print_err "Invalid option: $1"
                return 1
            fi
        ;;
        *)
            print_err "Nr of arguments are invalid: $#"
            return 3
        ;;
    esac
}

function json_key_rename {
    [[ "$#" -eq 2 && -p /dev/stdin ]] && {
        jq 'with_entries(
            if .key | contains("'"$1"'")
            then .key |= sub("'"$1"'";"'"$2"'")
            else . end
        )' /dev/stdin
    }
    [[ "$#" -eq 3 && -f "$3" ]] && {
        jq 'with_entries(
            if .key | contains("'"$1"'")
            then .key |= sub("'"$1"'";"'"$2"'")
            else . end
        )' "$3"
    }
}

# -------------------
# Encoding / Decoding
# -------------------

# Shows URL encoding equivalent for listed characters
function show_url_encoding {
    local -A dictionary
    dictionary=(
        [',']='%C2'       [';']='%3B'    [':']='%3A'
        ['*']='%2A'       ['?']='%3F'    ['+']='%2B'
        ['/']='%2F'       [' ']='%20'    ['=']='%3D'
        ['{']='%7B'       ['}']='%7D'    ['(']='%28'
        [')']='%29'       ['[']='%5B'    [']']='%5D'
        ['&']='%26'       ["'"]='%27'    ['"']='%22'
        [\\]='%5C'        ['^']='%5E'    ['$']='%24'
        ['`']='%60'       ['#']='%23'    ['@']='%40'
        ['!']='%21'       ['%']='%25'    [' ']='%20'
        ['å']='%C3%A5'    ['ä']='%C3%A4' ['ö']='%C3%B6'
        ['Å']='%C3%85'    ['Ä']='%C3%84' ['Ö']='%C3%96'
        ['€']='%E2%82%AC'
    )
    for c in "${!dictionary[@]}"
    do
        printf '[ %s ]: %s\n' "$c" "${dictionary[$c]}"
    done
}

# URL encodes the characters of a given string
function url_encode {
	[[ "$#" -ne 1 ]] && { return 1; }
    local -A dictionary
    dictionary=(
        [',']='%C2'       [';']='%3B'    [':']='%3A'
        ['*']='%2A'       ['?']='%3F'    ['+']='%2B'
        ['/']='%2F'       [' ']='%20'    ['=']='%3D'
        ['{']='%7B'       ['}']='%7D'    ['(']='%28'
        [')']='%29'       ['[']='%5B'    [']']='%5D'
        ['&']='%26'       ["'"]='%27'    ['"']='%22'
        [\\]='%5C'        ['^']='%5E'    ['$']='%24'
        ['`']='%60'       ['#']='%23'    ['@']='%40'
        ['!']='%21'       ['%']='%25'    [' ']='%20'
        ['å']='%C3%A5'    ['ä']='%C3%A4' ['ö']='%C3%B6'
        ['Å']='%C3%85'    ['Ä']='%C3%84' ['Ö']='%C3%96'
        ['€']='%E2%82%AC'
    )
	local text="$*"
	for (( x = 0; x < "${#text}"; x += 1 ))
    do
		if [[ "${dictionary[${text:x:1}]}" ]]
        then
            printf '%s' "${dictionary[${text:x:1}]}"
        else
            printf '%s' "${text:$x:1}"
        fi
	done
}

# Decodes a URL encoded string
function url_decode {
    local -A dictionary
    dictionary=(
        ['%C2']=','       ['%3B']=';'    ['%3A']=':'
        ['%2A']='*'       ['%3F']='?'    ['%2B']='+'
        ['%2F']='/'       ['%20']=' '    ['%3D']='='
        ['%7B']='{'       ['%7D']='}'    ['%28']='('
        ['%29']=')'       ['%5B']='['    ['%5D']=']'
        ['%26']='&'       ['%27']="'"    ['%22']='"'
        ['%5C']=\\        ['%5E']='^'    ['%24']='$'
        ['%60']='`'       ['%23']='#'    ['%40']='@'
        ['%21']='!'       ['%25']='%'    ['%20']=' '
        ['%C3%A5']='å'    ['%C3%A4']='ä' ['%C3%B6']='ö'
        ['%C3%85']='Å'    ['%C3%84']='Ä' ['%C3%96']='Ö'
        ['%E2%82%AC']='€'
    )
	local text="$*" count=0
	for (( x = 0; x < "${#text}"; x += 1 ))
    do
        if [[ "${dictionary[${text:x:3}]}" ]]
        then
            printf '%s' "${dictionary[${text:x:3}]}"
            count=2
        elif [[ "${dictionary[${text:x:6}]}" ]]
        then
            printf '%s' "${dictionary[${text:x:6}]}"
            count=5
        elif [[ "${dictionary[${text:x:9}]}" ]]
        then
            printf '%s' "${dictionary[${text:x:9}]}"
            count=8
        else
            if [[ "$count" -gt 0 ]]
            then
                count=$(( "$count" - 1 ))
            else
                printf '%s' "${text:x:1}"
            fi
        fi
	done
}

# 256 symbols
function show_hex {
    local -r A=(
        {0..9}
        {a..f}
    )
    for X in "${A[@]}"
    do
        for I in "${A[@]}"
        do
            printf '%s ' "${X}${I}"
        done
        printf '\n'
    done
}

function show_pattern {
    if [[ "$#" -gt 0 ]]
    then
        # 1024 symbols
        local -r A=(
            {0..9}
            {a..v}
        )
        for X in "${A[@]}"
        do
            for I in "${A[@]}"
            do
                printf '%s ' "${X}${I}"
            done
            printf '\n'
        done
    else
        # 1296 symbols
        local -r A=(
            {0..9}
            {a..z}
        )
        for X in "${A[@]}"
        do
            for I in "${A[@]}"
            do
                printf '%s ' "${X}${I}"
            done
            printf '\n'
        done
    fi
}

# Encodes a set of character according to an assigned array.
function encode_char {
    local -A dictionary
    dictionary=(
        ['0']='00' ['1']='01' ['2']='02' ['3']='03' ['4']='04' ['5']='05' ['6']='06'
        ['7']='07' ['8']='08' ['9']='09' ['A']='0a' ['B']='0b' ['C']='0c' ['D']='0d'
        ['E']='0e' ['F']='0f' ['G']='0g' ['H']='0h' ['I']='0i' ['J']='0j' ['K']='0k'
        ['L']='0l' ['M']='0m' ['N']='0n' ['O']='0o' ['P']='0p' ['Q']='0q' ['R']='0r'
        ['S']='0s' ['T']='0t' ['U']='0u' ['V']='0v' ['W']='10' ['X']='11' ['Y']='12'
        ['Z']='13' ['Å']='14' ['Ä']='15' ['Ö']='16' ['a']='17' ['b']='18' ['c']='19'
        ['d']='1a' ['e']='1b' ['f']='1c' ['g']='1d' ['h']='1e' ['i']='1f' ['j']='1g'
        ['k']='1h' ['l']='1i' ['m']='1j' ['n']='1k' ['o']='1l' ['p']='1m' ['q']='1n'
        ['r']='1o' ['s']='1p' ['t']='1q' ['u']='1r' ['v']='1s' ['w']='1t' ['x']='1u'
        ['y']='1v' ['z']='20' ['å']='21' ['ä']='22' ['ö']='23' ['?']='24' ['!']='25'
        ['+']='26' ['=']='27' ['#']='28' ['%']='29' ['&']='2a' ['@']='2b' ['"']='2c'
        ["'"]='2d' ['-']='2e' ['_']='2f' ['/']='2g' ['|']='2h' [\\]='2i'  [' ']='2j'
        [':']='2k' [';']='2l' [',']='2m' ['.']='2n' ['^']='2o' ['*']='2p' ['¡']='2q'
        ['¤']='2r' ['(']='2s' [')']='2t' ['{']='2u' ['}']='2v' ['[']='30' [']']='31'
        ['<']='32' ['>']='33' ['~']='34' ['`']='35' ['´']='36' ['$']='37' ['€']='38'
        ['¥']='39' ['£']='3a' ['₿']='3b' 
    )
    local -r args="$*"
    for (( I = 0; I < "${#args}"; I += 1 ))
    do
        [[ "${dictionary[${args:I:1}]}" ]] && {
            printf '%s' "${dictionary[${args:I:1}]}"
        }
    done
    printf '\n'
}

# Decodes a set of character according to an assigned array.
function decode_char {
    local -A dictionary
    dictionary=(
        ['00']='0' ['01']='1' ['02']='2' ['03']='3' ['04']='4' ['05']='5' ['06']='6'
        ['07']='7' ['08']='8' ['09']='9' ['0a']='A' ['0b']='B' ['0c']='C' ['0d']='D'
        ['0e']='E' ['0f']='F' ['0g']='G' ['0h']='H' ['0i']='I' ['0j']='J' ['0k']='K'
        ['0l']='L' ['0m']='M' ['0n']='N' ['0o']='O' ['0p']='P' ['0q']='Q' ['0r']='R'
        ['0s']='S' ['0t']='T' ['0u']='U' ['0v']='V' ['10']='W' ['11']='X' ['12']='Y'
        ['13']='Z' ['14']='Å' ['15']='Ä' ['16']='Ö' ['17']='a' ['18']='b' ['19']='c'
        ['1a']='d' ['1b']='e' ['1c']='f' ['1d']='g' ['1e']='h' ['1f']='i' ['1g']='j'
        ['1h']='k' ['1i']='l' ['1j']='m' ['1k']='n' ['1l']='o' ['1m']='p' ['1n']='q'
        ['1o']='r' ['1p']='s' ['1q']='t' ['1r']='u' ['1s']='v' ['1t']='w' ['1u']='x'
        ['1v']='y' ['20']='z' ['21']='å' ['22']='ä' ['23']='ö' ['24']='?' ['25']='!'
        ['26']='+' ['27']='=' ['28']='#' ['29']='%' ['2a']='&' ['2b']='@' ['2c']='"'
        ['2d']="'" ['2e']='-' ['2f']='_' ['2g']='/' ['2h']='|' ['2i']=\\  ['2j']=' '
        ['2k']=':' ['2l']=';' ['2m']=',' ['2n']='.' ['2o']='^' ['2p']='*' ['2q']='¡'
        ['2r']='¤' ['2s']='(' ['2t']=')' ['2u']='{' ['2v']='}' ['30']='[' ['31']=']'
        ['32']='<' ['33']='>' ['34']='~' ['35']='`' ['36']='´' ['37']='$' ['38']='€'
        ['39']='¥' ['3a']='£' ['3b']='₿' 
    )
    local -r args="$*"
    for (( I = 0; I < "${#args}"; I += 2 ))
    do
        [[ "${dictionary[${args:I:2}]}" ]] && {
            printf '%s' "${dictionary[${args:I:2}]}"
        }
    done
    printf '\n'
}

function replace_in {
    [[ "$#" -ne 2 ]] && { return 1; }
    [[ -p /dev/stdin ]] && {
        sed 's|'"$1"'|'"$2"'|g' /dev/stdin
    }
}

# ---------------------------
# Riksdagen - Document Search
# Swedish Law
# ---------------------------

# Sends a search query for Swedish legal documents (SFS) 
function lag {
	[[ "$#" -ne 1 ]] && { return 1; }
	! has_cmd 'jq' && { return 2; }
	local SEARCH 
	SEARCH="$(url_encode "$1")"
	local -r URL="https://data.riksdagen.se/dokumentlista/?sok=${SEARCH}&doktyp=SFS&utformat=json"
	curl --silent --location "$URL" | jq '.'
}

# Fetches an SFS document
function sfs_dokument {
	[[ "$#" -ne 1 ]] && { return 1; }
	! has_cmd 'jq' && { return 2; }
	local -r URL="https://data.riksdagen.se/dokument/$1"
	# curl --silent --location "$URL" | jq '.'
	curl --silent --location "$URL"
}

# ----------
# Dictionary
# ----------

# Queries a word for the dictionary definition
function dictionary {
	[[ "$#" -ne 1 ]] && { return 1; }
	! has_cmd 'curl' || ! has_cmd 'jq' && { return 2; }
    local -r base_url="https://api.dictionaryapi.dev/api/v2/entries/en/$1"
    curl --silent --location "$base_url" | jq
}
