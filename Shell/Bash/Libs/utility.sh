#!/usr/bin/env bash
# Victor-ray, S.

. ./calculus.sh
. ./docker.sh
. ./git.sh
. ./installation.sh
. ./json.sh
. ./network.sh
. ./tests.sh

# ------
# Colour
# ------

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
    local -r Z='\e[0m'
    local -r COLOUR=('\e[1;37m' '\e[1;36m' '\e[1;35m' '\e[1;34m' 
                     '\e[1;33m' '\e[1;32m' '\e[1;31m' '\e[1;30m' 
                     '\e[5m'    '\e[0m')
    local -r NAME=("WHITE"  "CYAN"  "PURPLE" "BLUE" 
                   "YELLOW" "GREEN" "RED"    "BLACK" 
                   "BLINK"  "RESET")
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
    [[ ! "$*" =~ ^[0-9*]$ ]] && { return 1; }
    printf '%d\n' "$*"
}

# Digit: Each argument on a new line
function println_digit {
    [[ ! "$*" =~ ^[0-9*]$ ]] && { return 1; }
    printf '%d\n' "$@"
}

# Integer: Arguments appended to one line
function print_int {
    [[ ! "$*" =~ ^[0-9*]$ ]] && { return 1; }
    printf '%i\n' "$*"
}

# Integer: Each argument on a new line
function println_int {
    [[ ! "$*" =~ ^[0-9*]$ ]] && { return 1; }
    printf '%i\n' "$@"
}

# Float: Arguments appended to one line
function print_float {
    printf '%f\n' "$*"
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

# -------
# Logging
# -------

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
        else log 2 "Invalid log level, valid: [-2|-1|0|1|2]"
             return 1
        fi
    else log 2 "Invalid number of arguments: $#"
         return 2 
    fi
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


# -----
# Other
# -----

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
# 2: Missing command(s): set, sed
function sed_environment {
    [[ "$#" -ne 0 ]] && { return 1; }
    ! has_cmd 'sed' || ! has_cmd 'set' && { log 2 "Missing command(s): set, sed"; return 2; }
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

# Get system information
# Return codes
# 1: Missing command: inxi
# 2: Invalid number of arguments
function system_info {
    [[ "$#" -ne 0 ]] && { log 2 "Invalid number of arguments: $#/0"; return 2; }
    ! has_cmd 'inxi' && { log 2 "Missing command: inxi"; return 1; }
    inxi -Fxzr
}

# Records the output of a command to a file.
# Return codes
# 1: Missing argument: Command to record
function record_command {
    [[ "$#" -eq 1 ]] && { log 2 "Requires: [Command to record]"; return 1; }
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
    grep -e '[#.*function.*}]' "$1"
}

# Returns the length or number of variables passed to function
# Return codes
# 1: Invalid nr of arguments
function get_length {
    [[ "$#" -lt 1 ]] && { log 2 "Invalid args: $#/1"; return 1; }
    local -r ARR=("$@")
    printf '%d\n' "${#ARR[@]}"
}


# ---------
# Processes
# ---------

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


# ----
# Time
# ----

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


# -----
# Files
# -----

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


# ----
# Text
# ----

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

# Replaces one pattern with another pattern using sed reading STDIN
# Return codes
# 1: Invalid number of arguments
# 2: Missing command: sed
function replace_in {
    [[ "$#" -ne 2 ]] && { return 1; }
    ! has_cmd 'sed' && { return 2; }
    [[ -p /dev/stdin ]] && {
        sed 's|'"$1"'|'"$2"'|g' /dev/stdin
    }
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


# ------------------------------------
# Passwords, cryptographic & encodings
# ------------------------------------

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



# --------------
# Users & groups
# --------------

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

