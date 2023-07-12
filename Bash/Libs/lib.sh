#!/usr/bin/env bash
# Victor-ray, S <12261439+ZendaiOwl@users.noreply.github.com>

# [[ "$(; printf '%i\n' "$?")" -eq 0 ]]
# [[ "$(; printf '%i\n' "$?")" -ne 0 ]]

############################
# Bash - Utility Functions #
############################

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
# These can be combined, ex.
# \e[1;5;m = Blinking Bold
function colour {
    declare -r Z='\e[0m' \
               COLOUR=('\e[1;37m' '\e[1;36m' '\e[1;35m' '\e[1;34m' '\e[1;33m' '\e[1;32m' '\e[1;31m' '\e[1;30m' '\e[5m' '\e[0m') \
               NAME=("WHITE" "CYAN" "PURPLE" "BLUE" "YELLOW" "GREEN" "RED" "BLACK" "BLINK" "RESET")
    declare -r LENGTH="${#NAME[@]}"
    for (( C = 0; C < "$LENGTH"; C++ ))
    do printf "${COLOUR[$C]}%s${Z} \t%s\n" "${NAME[$C]}" "${COLOUR[$C]}"
    done
}

# Prints a line using printf instead of using echo
# For compatibility and reducing unwanted behaviour
# String: Arguments appended to one String
function print {
    printf '%s\n' "$*"
}

# Digit: Each argument as a String
function print_digit {
    printf '%d\n' "$*"
}

# Float: Each argument as a String
function print_float {
    printf '%f\n' "$*"
}

# Integer: Arguments appended to one String
function print_int {
    printf '%i\n' "$*"
}

# String: Each argument as a String
function println {
    printf '%s\n' "$@"
}

# Digit: Each argument as a String
function println_digit {
    printf '%d\n' "$@"
}

# Float: Each argument as a String
function println_float {
    printf '%f\n' "$@"
}

# Integer: Each argument as a String
function println_int {
    printf '%i\n' "$@"
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
                -2) printf '\e[1;36mDEBUG\e[0m %s\n'   "${*:2}" >&2 ;;
                -1) printf '\e[1;34mINFO\e[0m %s\n'    "${*:2}"     ;;
                 0) printf '\e[1;32mSUCCESS\e[0m %s\n' "${*:2}"     ;;
                 1) printf '\e[1;33mWARNING\e[0m %s\n' "${*:2}"     ;;
                 2) printf '\e[1;31mERROR\e[0m %s\n'   "${*:2}" >&2 ;;
            esac
        else log 2 "Invalid log level: [ Debug: -2|Info: -1|Success: 0|Warning: 1|Error: 2 ]"
             return 1
        fi
    else log 2 "Invalid number of arguments: [ $#/1+ ]"
         return 2 
    fi
}

#########################
# Bash - Test Functions #
#########################

# Checks if a given variable is an array or not
# Return codes
# 0: Variable is an array
# 1: Variable is not an array
# 2: Invalid number of arguments
function is_array {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$(declare +a "$1" &>/dev/null; print_int "$?")" -eq 1 ]]
}

# Checks if a given variable contains only digits (positive integers)
function is_digit {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$1" =~ ^[0-9*]$ ]]
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
    [[ "$#" -ne 1 ]] && { log 2 "Invalid number of arguments"; return 0; }
    case "$(type -t "$1")" in
           'alias') { println "alias";    return 1; } ;;
         'builtin') { println "builtin";  return 2; } ;;
            'file') { println "file";     return 3; } ;;
        'function') { println "function"; return 4; } ;;
         'keyword') { println "keyword";  return 5; } ;;
                 *) { println "unknown";  return 6; } ;;
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
# 0: Is zero
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

# Checks if a package is already installed on the system with dpkg
# Return status codes
# 0: Is installed
# 1: Not installed
# 2: Invalid number of arguments
function has_pkg {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$(dpkg-query --status "$1" &>/dev/null; print_int "$?")" -eq 0 ]]
}

# Checks if a package exists in the cached apt list
# Return status codes
# 0: Is available in apt
# 1: Not available in apt
# 2: Invalid number of arguments
function has_apt_package {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$(apt-cache show "$1" &>/dev/null; print_int "$?")" -eq 0 ]]
}

# Checks if a package exists on the system
# Return status codes
# 0: Package is installed
# 1: Package is not installed but is available in apt
# 2: Package is not installed and is not available in apt
# 3: Missing package argument to check
function check_package {
    [[ "$#" -ne 1 ]]     && { log  2 "Invalid number of arguments: $#/1"; return 3; }
    has_pkg "$1"         && { log -1 "Installed: $1"; return 0; }
    has_apt_package "$1" && { log -1 "Install available: $1"; return 1; }
    log -1 "Not found: $1"
    return 2
}

############################
# Bash - Install Functions #
############################

# Update apt list and packages
# Return codes
# 0: install_pkg completed
# 1: Coudn't update apt list
# 2: Invalid number of arguments
function update_apt {
    [[ "$#" -ne 0 ]] && {
        log 2 "Invalid number of arguments: $#/0"
        return 2
    }
    declare -r OPTIONS=(--quiet --assume-yes --no-show-upgraded --auto-remove=true --no-install-recommends)
    declare -r SUDOUPDATE=(sudo apt-get "${OPTIONS[@]}" update) \
               ROOTUPDATE=(apt-get "${OPTIONS[@]}" update)
    if [[ "$EUID" -eq 0 ]]; then
        log -1 "Updating apt lists"
        if "${ROOTUPDATE[@]}" &>/dev/null; then
            log 0 "Apt list updated"
        else
            log 2 "Couldn't update apt lists"
            return 1
        fi
    else
        log -1 "Updating apt lists"
        if "${SUDOUPDATE[@]}" &>/dev/null; then
            log 0 "Apt list updated"
        else
            log 2 "Couldn't update apt lists"
            return 1
        fi
    fi
}

# Install package(s) using the package manager and pre-configured options
# Return codes
# 0: install_pkg completed
# 1: Error during installation
# 2: Missing package argument
function install_package {
    [[ "$#" -eq 0 ]] && { log 2 "Requires: [ PKG(s) ]"; return 2; }
    declare -r OPTIONS=(--quiet --assume-yes --no-show-upgraded --auto-remove=true --no-install-recommends)
    declare -r SUDOINSTALL=(sudo apt-get "${OPTIONS[@]}" install) \
               ROOTINSTALL=(apt-get "${OPTIONS[@]}" install)
    if [[ "$EUID" -eq 0 ]]; then
        log -1 "Installing: $*"
        if DEBIAN_FRONTEND=noninteractive "${ROOTINSTALL[@]}" "$@"; then
            log 0 "Installation complete"
            return 0
        else
            log 2 "Something went wrong during installation"
            return 1
        fi
    else
        log -1 "Installing: $*"
        if DEBIAN_FRONTEND=noninteractive "${SUDOINSTALL[@]}" "$@"; then
            log 0 "Installation complete"
            return 0
        else
            log 2 "Something went wrong during installation"
            return 1
        fi
    fi
}

# update_pkgs a Git repository directory and signs the commit before pushing with a message
# Return codes
# 0: Success
# 1: Ḿissing argument(s): Commit message
function Git {
    if [[ "$#" -lt 1 ]]; then
        log 2 "No commit message provided"
        return 1
    else
        declare -r GPG_KEY_ID="E2AC71651803A7F7" DIRECTORY="$PWD"
        (
            declare -r COMMIT_MESSAGE="࿓❯ $*"
            declare -r GIT_COMMIT_ARGS=(--signoff --gpg-sign="$GPG_KEY_ID" --message="$COMMIT_MESSAGE")
            git add "$DIRECTORY"
            git commit "${GIT_COMMIT_ARGS[@]}"
            git push
        )
        return 0
    fi
}

#########################
# Bash - Math Functions #
#########################

# Calculation using bc
function bC {
    println "$*" | bc -l
}

# Calculation using awk
function Calc {
    awk "BEGIN{print $*}"
}

# Arithmetic Addition
# Arithmetic Addition
# Only integers.
# Decimals or numbers of type double does not work 
# Return codes
# 0: Success
# 1: Invalid number of arguments
function Addition {
    [[ "$#" -ne 2 ]] && { return 1; }
    print_int "$(( "$1" + "$2" ))"
}

# Arithmetic Subtraction
# Only integers.
# Decimals or numbers of type double does not work 
# Return codes
# 0: Success
# 1: Invalid number of arguments
function Subtraction {
    [[ "$#" -ne 2 ]] && { return 1; }
    print_int "$(( "$1" - "$2" ))"
}

# Arithmetic Multiplication
# Only integers.
# Decimals or numbers of type double does not work 
# Return codes
# 0: Success
# 1: Invalid number of arguments
function Multiplication {
    [[ "$#" -ne 2 ]] && { return 1; }
    print_int "$(( "$1" * "$2" ))"
}

# Arithmetic Division
# Only integers.
# Decimals or numbers of type double does not work 
# Return codes
# 0: Success
# 1: Invalid number of arguments
function Division {
    [[ "$#" -ne 2 ]] && { return 1; }
    print_int "$(( "$1" / "$2" ))"
}

# Arithmetic Exponential
# Only integers.
# Decimals or numbers of type double does not work 
# Return codes
# 0: Success
# 1: Invalid number of arguments
function Exponential {
    [[ "$#" -ne 2 ]] && { return 1; }
    print_int "$(( "$1" ** "$2" ))"
}

############################
# Bash - Utility Functions #
############################

# Checks for a running process
# Return codes
# 0: Running process exists
# 1: No such running process
# 2: Missing argument: process
# 3: Missing command: pgrep
function find_process {
    [[ "$#" -ne 1 ]]  && { log 2 "Requires argument: process"; return 2; }
    ! has_cmd 'pgrep' && { log 2 "Command not found: pgrep"; return 3; }
    [[ "$(pgrep "$1" &>/dev/null; print_int "$?")" -eq 0 ]]
}

# Checks for a running process
# Return codes
# 0: Running process exists
# 1: No such running process
# 2: Missing argument: process
# 3: Missing command: pgrep
function find_full_process {
    [[ "$#" -ne 1 ]]  && { log 2 "Requires argument: process"; return 2; }
    ! has_cmd 'pgrep' && { log 2 "Command not found: pgrep"; return 3; }
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

# Get system information
# Return codes
# 1: Missing command: inxi
# 2: Too many arguments provided
function system_info {
    [[ "$#" -ne 0 ]] && { log 2 "Requires no arguments"; return 2; }
    ! has_cmd 'inxi' && { log 2 "Missing command: inxi"; return 1; }
    inxi -Fxzr
}

# Records the output of a command to a file.
# Return codes
# 1: Missing argument: Command to record output of
function rec_cmd {
    [[ "$#" -eq 1 ]] && { log 2 "Requires: [Command to record output]"; return 1; }
    declare -r LOGFILE='log.txt'
    if [[ -f "$LOGFILE" ]]
    then log -1 "$LOGFILE exists, appending to existing file"
         echo "Appending new output from $1" | tee -a "$LOGFILE"
         bash -c "$1" | tee -a "$LOGFILE"
    else touch "$LOGFILE"; bash -c "$1" | tee -a "$LOGFILE"
         log 0 "Command output recorded to $LOGFILE"
    fi
}

# Gets the current time in UNIX & regular time (human-readable format)
# Return codes
# 1: Error: Too many arguments provided
function get_time {
    [[ "$#" -gt 0 ]] && { log 2 "No arguments required"; return 1; }
    printf '%s\n' "Regular: $(date -d @"$(date +%s)")" \
                  "Unix: $(date +%s)" \
                  "Date by locale: $(date +%x)" \
                  "Time by locale: $(date +%X)"
}

# Converts UNIX timestamps to regular human-readable timestamp
# Return codes
# 1: Missing argument: UNIX Timestamp
function unix_to_regular_time {
    [[ "$#" -ne 1 ]] && { log 2 "Requires: [ UNIX Timestamp ]"; return 1; }
    println "$(date -d @"$1")"
}

# Gets the time by locale's definition
# Return codes
# 1: Error: Too many arguments
function get_locale_time {
    [[ "$#" -eq 0 ]] && { log 2 "Requires no arguments"; return 1; }
    date +%X
}

# Gets the date by locale's definition
# Return codes
# 1: Error: Too many arguments
function get_locale_date {
    [[ "$#" -ne 0 ]] && { log 2 "Requires no arguments"; return 1; }
    date +%x
}

# Uses $(<) to read a file to STDOUT, supposedly faster than cat.
# Return codes
# 0: Success
# 1: Not a file
# 2: Error: Too many arguments
# 2: Missing argument: File
function read_file {
    [[ "$#" -eq 0 ]] && { log 2 "Requires argument: [ File ]"; return 3; }
    [[ "$#" -gt 1 ]] && { log 2 "Too many arguments, only 1 required: [ File ]"; return 2; }
    [[ ! -f "$1" ]]  && { log 2 "Not a file: $1"; return 1; }
    println "$(<"$1")"
}

# Shows the files in the current working directory's directory & all its sub-directories excluding hidden directories.
# Return codes
# 1: Error: Arguments provided when none required
function show_directory_files {
    [[ "$#" -ne 0 ]] && { log 2 "Requires no arguments"; return 1; }
    declare -r ARGS=(--recursive --files-with-matches --exclude-dir=".*")
    grep "${ARGS[@]}" .
}

# Prints a function() to STDOUT
# Return codes
# 1: Not a function: $1
# 2: Invalid number of arguments
function show_function {
    [[ "$#" -ne 1 ]]   && { return 2; }
    ! is_function "$1" && { return 1; }
    declare -f "$1"
}

# Counts the number of files recursively from current working directory
# Return codes
# 1: Error: Arguments provided when none required
function count_directory_files {
    [[ "$#" -ne 0 ]] && { log 2 "Requires no arguments"; return 1; }
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
    [[ "$#" -ne 1 ]] && { log 2 "Requires: [ Path ]"; return 2; }
    [[ ! -e "$1" ]]  && { log 2 "No such path: $1"; return 1; }
    println "${1##*/}"
}

# Converts a String to uppercase
# Return codes
# 1: Missing argument: String
function upper_case {
    [[ "$#" -eq 0 ]] && { log 2 "Requires: [ String(s) ]"; return 1; }
    println "${*^^}"
}

# Converts the first letter of a String to upper case
# Return codes
# 1: Missing argument: String
function upper_first_letter {
    [[ "$#" -ge 0 ]] && { log 2 "Requires: [ String(s) ]"; return 1; }
    println "${*^}"
}

# Converts a String to lower case
# Return codes
# 1: Missing argument: String
function lower_case {
    [[ "$#" -eq 0 ]] && { log 2 "Requires: [ String(s) ]"; return 1; }
    println "${*,,}"
}

# Converts a String to lower case
# Return codes
# 1: Missing argument: String
function lower_first_letter {
    [[ "$#" -eq 0 ]] && { log 2 "Requires: [ String(s) ]"; return 1; }
    println "${*,}"
}

# search for a pattern recursively in files of current directory and its sub-directories
# Return codes
# 1: Missing argument: String
# 2: Missing command: grep
function search {
    [[ "$#" -eq 0 ]] && { log 2 "Requires: [ Pattern(s) ]"; return 1; }
    ! has_cmd 'grep' && { log 2 "Missing command: grep"; return 2; }
    declare -r ARGS=(--recursive --exclude-dir=".*")
    grep "${ARGS[@]}" "$*" 2>/dev/null
}

# search for pattern in a specific file
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

# search for pattern in a specific file
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

# search for files with pattern(s) recursively
# Return codes
# 1: Missing argument: String
# 2: Command not found: grep
function get_files_with_text {
    ! has_cmd 'grep' && { log 2 "Command not found: grep"; return 2; }
    [[ "$#" -eq 0 ]] && { log 2 "Requires: [ Pattern(s) to locate ]"; return 1; }
    declare -r ARGS=(--recursive --files-with-matches --exclude-dir=".*")
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
    [[ "$#" -ne 3 ]] && { log 2 "Requires: [ Line number ] [ Text to append ] [ File ]"; return 3; }
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
    [[ "$#" -ne 3 ]] && { log 2 "Requires: [ Locate String ] [ Append String ] [ File ]"; return 2; }
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
    [[ "$#" -ne 2 ]] && { log 2 "Requires: [ Text to append ] [ File ]"; return 2; }
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
    [[ "$#" -ne 3 ]] && { log 2 "Requires: [ Line number ] [ Text to insert ] [ File ]"; return 3; }
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
    [[ "$#" -ne 3 ]] && { log 2 "Requires: [ Text pattern ] [ Text to insert ] [ File ]"; return 2; }
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
    [[ "$#" -ne 2 ]] && { log 2 "Requires: [ Text to insert ] [ File ]"; return 2; }
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
    [[ "$#" -ne 2 ]] && { log 2 "Requires: [ Line number ] [ File ]"; return 3; }
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
    [[ "$#" -ne 3 ]] && { log 2 "Requires: [ Start ] [ End ] [ File ]"; return 3; }
    [[ ! -f "$3" ]]  && { log 2 "Not a file: $3"; return 2; }
    [[ "$1" -lt 0 || "$2" -lt 0 ]] && { log 2 "Not a positive integer digit range: $1 & $2"; return 1; }
    sed -i ''"$1"','"$2"'d' "$3"
}

# Gets the length of an array
# Return codes
# 1: Not an array
# 2: Wrong nr of arguments, 1 required: Array to get length of
function array_length {
    [[ "$#" -ne 1 ]] && { log 2 "Requires 1 argument: [ Array ]"; return 2; }
    ! is_array "$1"  && { log 2 "Not an array: $1"; return 1; }
    println "${#1[@]}"
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
    ! has_cmd 'openssl' && { log 2 "OpenSSL not available"; return 1; }
    openssl rand -base64 "${1:-36}"
}

# Encrypts a String with a password
# Return codes
# 1: Command not found: openssl
# 2: Invalid number of arguments
function crypt_string {
    [[ "$#" -ne 2 ]]    && { return 2; }
    ! has_cmd 'openssl' && { return 1; }
    printf '%s\n' "$1" | openssl enc -aes-256-cbc -md sha512 -a -pbkdf2 -iter 10000 -salt -pass pass:"$2"
}

# Decrypts a String with a password
# Return codes
# 1: Command not found: openssl
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
    [[ "$#" -eq 1 ]] && { log 2 "Requires: [ Group name ]"; return 1; }
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
    [[ "$#" -ne 1 ]] && { log 2 "Invalid number of arguments"; return 2; }
    ! is_user "$1"   && { log 2 "No such user: $1"; return 1; }
    id --groups "$1"
}

############################
# Bash - Network Functions #
############################


# Test if a port is open or closed on a remote host
# Exit codes
# 1: Open
# 2: Closed
# 3: Invalid number of arguments
function test_remote_port {
    [[ "$#" -eq 2 ]] && { log 2 "Requires: [ HOST ] [ PORT ]"; return 2; }
    if timeout 2.0 bash -c "true &>/dev/null>/dev/tcp/${1}/${2}"
    then log -1 "Open"
    else log -1 "Closed"; return 1
    fi
}

# Queries DNS record of a domain
# Return codes
# 1: Error: Too many arguments provided
# 2: Missing argument(s): Domain, Optional Domain Record
function get_dns_record {
    [[ "$#" -eq 0 ]] && { log 2 "No argument arguments provided"; return 2; }
    [[ "$#" -gt 2 ]] && { log 2 "Too many arguments provided"; return 1; }
    [[ "$#" -eq 2 ]] && { dig "$1" "$2" +short; }
    [[ "$#" -eq 1 ]] && { dig "$1" +short; }
}

# Gets the public IP for the network
# Return codes
# 1: Missing command: curl
function get_all_public_ip {
    ! has_cmd 'curl' && { log 2 "Missing command: curl"; return 1; }
    declare -r URLv4="https://ipv4.icanhazip.com" \
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
    declare -r URLv4="https://ipv4.icanhazip.com" \
               ARGS=(--silent --max-time 4)
    curl "${ARGS[@]}" --ipv4 "$URLv4" 2>/dev/null || return 1
}

# Gets the public IP for the network
# Return codes
# 1: Fail - No public IPv6
# 2: Missing command: curl
function get_public_ipv6 {
    ! has_cmd 'curl' && { log 2 "Missing command: curl"; return 2; }
    declare -r URLv6="https://ipv6.icanhazip.com" \
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
    declare -r URL="https://ipv4.icanhazip.com" \
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
    declare -r URL="https://ipv6.icanhazip.com" ARGS=(--silent --max-time 4 --ipv6)
    if curl "${ARGS[@]}" "$URL" &>/dev/null
    then log -1 "Available"
    else log -1 "Unavailable"; return 1
    fi
}

# Gets the local IP assigned to the WiFi card for the device
# IPv4, IPv6 & Link-local
function get_local_ip {
    if has_cmd 'jq'
    then ip -j address | jq '.[2].addr_info' | jq -r '.[].local'
    else ip a | grep 'scope global' | awk '{print $2}' | head -2 | sed 's|/.*||g'
    fi
}

# Gets all the local IP-addresses on the device
function get_all_local_ip {
    if has_cmd 'jq'
    then ip -j address | jq '.[].addr_info' | jq -r '.[].local'
    else ip a | grep 'inet' | awk '{print $2}' | sed 's|/.*||g'
    fi
}

# Get device IP information
# Return codes
# 1: Invalid number of arguments
function get_ip_info {
    [[ "$#" -gt 0 ]] && { log 2 "No arguments required"; return 1; }
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
# 2: Missing command: No root privileges
function network_interface_services {
    ! has_cmd 'lsof' && { log 2 "Missing command: lsof"; return 1; }
    if is_root
    then lsof -n -P -i
    elif has_cmd 'sudo'
    then sudo lsof -n -P -i
    else log 2 "No root privileges"; return 2
    fi
}

# Gets the HTML code for a URL with Bash TCP
# Reuires the host TCP server to listen on HTTP, not HTTPS
# Return codes
# 1: Arguments error, requires: Host, Port
function get_url {
    [[ "$#" -ne 2 ]] && log 2 "Requires: [ HOST ] [ PORT ]"; return 1
    exec 5<>/dev/tcp/"$1"/"$2"
    echo -e "GET / HTTP/1.1\r\nHost: ${1}\r\nConnection: close\r\n\r" >&5
    cat <&5
    
}

# Fetches the current price of Bitcoin in Euro € from Binance
# Return codes
# 1: Missing required command: curl
function get_btc {
    ! has_cmd 'curl' && { log 2 "Missing command: curl"; return 1; }
    declare -r URL="https://api.binance.com/api/v3/ticker/price?symbol=BTCEUR" \
               ARGS=(--silent --location)
    if ! has_cmd 'jq'
    then curl "${ARGS[@]}" "$URL"
    else curl "${ARGS[@]}" "$URL" | jq '.'
    fi
}


##########################
# Bash - Audio Functions #
##########################

function mp4_to_wav {
    [[ "$#" -ne 2 ]] && return 2
    [[ ! -f "$1" ]] && return 1
    ffmpeg -i "$1" -ac 2 -f wav "$2"
}

###############################
# Bash - Permission Functions #
###############################


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
    then chown "$1" "$2"      || { return 1; }
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
    then chown --recursive "$1" "$2"      || { return 1; }
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
    then chmod "$1" "$2"      || { return 1; }
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
    then chmod --recursive "$2" "$1"      || { return 1; }
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
    if is_root
    then chmod +x "$1"      || { return 1; }
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
    if is_root
    then chmod --recursive +x "$1"      || { return 1; }
    elif has_cmd 'sudo'
    then sudo chmod --recursive +x "$1" || { return 1; }
    else return 2
    fi
}

###########################
# Bash - Docker Functions #
###########################
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
function in_docker_group {
    not_equal "$#" 0 && { return 2; }
    if is_member "$EUID" 'docker'
    then return 0
    else return 1
    fi
}

function remove_latest_image {
    ! has_cmd 'docker' && { return 2; }
    ! has_cmd 'awk'    && { return 1; }
    if is_root || in_docker_group
    then docker rmi "$(docker images | awk '{print $3}' | tail -n +2 | head -1)"
    else sudo docker rmi "$(sudo docker images | awk '{print $3}' | tail -n +2 | head -1)"
    fi
}
