#!/usr/bin/env bash
# Victor-ray, S <12261439+ZendaiOwl@users.noreply.github.com>

############################
# Bash - Utility Functions #
############################

# Displays 8 × 16-bit ANSI bold and a blinking effect
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
function colour { declare -r Z='\e[0m' COLOUR=('\e[1;37m' '\e[1;36m' '\e[1;35m' '\e[1;34m' '\e[1;33m' '\e[1;32m' '\e[1;31m' '\e[1;30m' '\e[5m' '\e[0m') NAME=('WHITE' 'CYAN' 'PURPLE' 'BLUE' 'YELLOW' 'GREEN' 'RED' 'BLACK' 'BLINK' 'RESET'); declare -r LENGTH="${#NAME[@]}"; for (( C = 0; C < "$LENGTH"; C++ )); do printf "${COLOUR[$C]}%s${Z} \t%s\n" "${NAME[$C]}" "${COLOUR[$C]}"; done; }

# Prints a line using printf instead of using echo
# For compatibility and reducing unwanted behaviour
function Print { printf '%s\n' "$@"; }

# A log that uses log levels for logging different outputs
# Log levels  | colour
# -2: Debug   | CYAN='\e[1;36m'
# -1: Info    | BLUE='\e[1;34m'
#  0: Success | GREEN='\e[1;32m'
#  1: Warning | YELLOW='\e[1;33m'
#  2: Error   | RED='\e[1;31m'
function log { if [[ "$#" -gt 0 ]]; then if [[ "$1" =~ [(-2)-2] ]]; then case "$1" in -2) printf '\e[1;36mDEBUG\e[0m %s\n' "${*:2}" >&2 ;; -1) printf '\e[1;34mINFO\e[0m %s\n' "${*:2}" ;; 0) printf '\e[1;32mSUCCESS\e[0m %s\n' "${*:2}" ;; 1) printf '\e[1;33mWARNING\e[0m %s\n' "${*:2}" ;; 2) printf '\e[1;31mERROR\e[0m %s\n' "${*:2}" >&2 ;; esac; else printf '%s\n' "Invalid log level: [Debug: -2|Info: -1|Success: 0|Warning: 1|Error: 2]"; fi; fi; }

#########################
# Bash - Test Functions #
#########################

# Check if user ID executing script is 0 or not
# Return codes
# 0: Is root
# 1: Not root
# 2: Invalid number of arguments
function is_root { [[ "$#" -ne 0 ]] && return 2; [[ "$EUID" -eq 0 ]]; }

# Checks if a user exists
# Return codes
# 0: Is a user
# 1: Not a user
# 2: Invalid number of arguments
function is_user { [[ "$#" -ne 1 ]] && return 2; if id -u "$1" &>/dev/null; then log -1 "Is a user: $1"; return 0; else log -1 "Not a user: $1"; return 1; fi; }

# Checks if a given variable contains only digits
function is_digit { [[ "$#" -ne 1 ]] && return 2; [[ "$1" =~ ^[0-9*]$ ]]; }

# Checks if a given variable is a positive integer
function is_positive_int { [[ "$#" -ne 1 ]] && return 2; [[ "$1" -gt 0 ]]; }

# Checks if a given path to a file exists
# Return codes
# 0: Path exist
# 1: No such path
# 2: Invalid number of arguments
function is_path { [[ "$#" -ne 1 ]] && return 2; [[ -e "$1" ]]; }

# Checks if a given path is a regular file
# 0: Is a file
# 1: Not a file
# 2: Invalid number of arguments
function is_file { [[ "$#" -ne 1 ]] && return 2; [[ -f "$1" ]]; }

# Checks if a given path is a readable file
# 0: Is readable
# 1: Not readable
# 2: Invalid number of arguments
function is_readable { [[ "$#" -ne 1 ]] && return 2; [[ -r "$1" ]]; }

# Checks if a given path is a writable file
# 0: Is writable
# 1: Not writable
# 2: Invalid number of arguments
function is_writable { [[ "$#" -ne 1 ]] && return 2; [[ -w "$1" ]]; }

# Checks if a given path is an executable file
# 0: Is executable
# 1: Not executable
# 2: Invalid number of arguments
function is_executable { [[ "$#" -ne 1 ]] && return 2; [[ -x "$1" ]]; }

# Checks if given path is a directory 
# Return codes
# 0: Is a directory
# 1: Not a directory
# 2: Invalid number of arguments
function is_directory {
    [[ "$#" -ne 1 ]] && return 2
    [[ -d "$1" ]]
}

# Checks if given path is a named pipe
# Return codes
# 0: Is a named pipe
# 1: Not a named pipe
# 2: Invalid number of arguments
function is_pipe { [[ "$#" -ne 1 ]] && return 2; [[ -p "$1" ]]; }

# Checks if a given variable has been set and is a name reference
# Return codes
# 0: Is set name reference
# 1: Not set name reference
# 2: Invalid number of arguments
function is_reference { [[ "$#" -ne 1 ]] && return 2; [[ -R "$1" ]]; }

# Checks if a given path is a socket
# Return codes
# 0: Is a socket
# 1: Not a socket
# 2: Invalid number of arguments
function is_socket { [[ "$#" -ne 1 ]] && return 2; [[ -S "$1" ]]; }

# Checks if a given variable has been set and assigned a value.
# Return codes
# 0: Is set
# 1: Not set 
# 2: Invalid number of arguments
function is_set { [[ "$#" -ne 1 ]] && return 2; [[ -v "$1" ]]; }

# Checks if a given variable has been set and assigned a value.
# Return codes
# 0: Not set
# 1: Is set 
# 2: Invalid number of arguments
function notSet { [[ "$#" -ne 1 ]] && return 2; [[ ! -v "$1" ]]; }

# Checks if the first given digit is greater than the second digit
# Return codes
# 0: Is greater
# 1: Not greater
# 2: Invalid number of arguments
function is_greater { [[ "$#" -ne 2 ]] && return 2; [[ "$1" -gt "$2" ]]; }

# Checks if the first given digit is greater than or equal to the second digit
# Return codes
# 0: Is greater than or equal
# 1: Not greater than or equal
# 2: Invalid number of arguments
function is_greaterOrEqual { [[ "$#" -ne 2 ]] && return 2; [[ "$1" -ge "$2" ]]; }

# Checks if the first given digit is less than the second digit
# Return codes
# 0: Is less
# 1: Not less
# 2: Invalid number of arguments
function is_less { [[ "$#" -ne 2 ]] && return 2; [[ "$1" -lt "$2" ]]; }

# Checks if 2 given digits are equal
# Return codes
# 0: Is equal
# 1: Not equal
# 2: Invalid number of arguments
function is_equal { [[ "$#" -ne 2 ]] && return 2; [[ "$1" -eq "$2" ]]; }

# Checks if 2 given digits are not equal
# Return codes
# 0: Not equal
# 1: Is equal
# 2: Invalid number of arguments
function not_equal { [[ "$#" -ne 2 ]] && return 2; [[ "$1" -ne "$2" ]]; }

# Checks if 2 given String variables match
# Return codes
# 0: Is a match
# 1: Not a match
# 2: Invalid number of arguments
function is_match { [[ "$#" -ne 2 ]] && return 2; [[ "$1" == "$2" ]]; }

# Checks if 2 given String variables do not match
# Return codes
# 0: Not a match
# 1: Is a match
# 2: Invalid number of arguments
function not_match { [[ "$#" -ne 2 ]] && return 2; [[ "$1" != "$2" ]]; }

# Checks if a given String is zero
# Return codes
# 0: Is zero
# 1: Not zero
# 2: Invalid number of arguments
function is_zero { [[ "$#" -ne 1 ]] && return 2; [[ -z "$1" ]]; }

# Checks if a given String is not zero
# Return codes
# 0: Not zero
# 1: Is zero
# 2: Invalid number of arguments
function not_zero { [[ "$#" -ne 1 ]] && return 2; [[ -n "$1" ]]; }

# Checks if a given variable is an array or not
# Return codes
# 0: Variable is an array
# 1: Variable is not an array
# 2: Missing argument: Variable to check
function is_array { if [[ "$#" -ne 1 ]]; then printf '%s\n' "Requires: [The variable to check if it's an array or not]"; return 2; elif ! declare -a "$1" &>/dev/null; then printf '%s\n' "Not an array: $1"; return 1; else printf '%s\n' "Is an array: $1"; return 0; fi; }

# Test if a function() is available
# Return codes
# 0: Available
# 1: Unvailable
# 2: Too many/few arguments
function is_function {
    if [[ "$#" -eq 1 ]]
    then if declare -f "$1" &>/dev/null
         then printf '%s\n' "Available"; return 0
         else printf '%s\n' "Unavailable"; return 1
         fi
    else printf '%s\n' "Requires argument: [Function name]"; return 2
    fi
}

# Checks if a given pattern in a String
# Return codes
# 0: Has String pattern
# 1: No String pattern
# 2: Invalid number of arguments
function has_text {
    [[ "$#" -ne 2 ]] && return 2
    declare -r PATTERN="$1" STRING="$2"
    [[ "$STRING" == *"$PATTERN"* ]]
}

# Checks if a command exists on the system
# Return status codes
# 0: Command exists on the system
# 1: Command is unavailable on the system
# 2: Missing command argument to check
function has_cmd {
    if [[ "$#" -eq 1 ]]
    then if command -v "$1" &>/dev/null
         then printf '%s\n' "Available: $1"; return 0
         else printf '%s\n' "Unavailable: $1"; return 1
         fi
    else printf '%s\n' "Requires: [Command]"; return 2
    fi
}

# Checks if a package exists on the system
# Return status codes
# 0: Package is installed
# 1: Package is not installed but is available in apt
# 2: Package is not installed and is not available in apt
# 3: Missing package argument to check
function has_pkg {
    if [[ "$#" -eq 1 ]]
    then if dpkg-query --status "$1" &>/dev/null
         then printf '%s\n' "install_pkged"; return 0
         elif apt-cache show "$1" &>/dev/null
         then printf '%s\n' "Not installed, install available"; return 1
         else printf '%s\n' "Not installed, install unavailable"; return 2
         fi
    else printf '%s\n' "Requires: [Package name]"; return 3
    fi
}

############################
# Bash - install_pkg Functions #
############################

# update_pkg apt list and packages
# Return codes
# 0: install_pkg completed
# 1: Coudn't update apt list
# 2: Invalid number of arguments
function updatePKG { if [[ "$#" -ne 0 ]]; then printf '%s\n' "Invalid number of arguments, requires none"; return 2; else declare -r OPTIONS=(--quiet --assume-yes --no-show-upgraded --auto-remove=true --no-install-recommends); declare -r SUDOUPDATE=(sudo apt-get "${OPTIONS[@]}" update) ROOTUPDATE=(apt-get "${OPTIONS[@]}" update); if [[ "$EUID" -eq 0 ]]; then printf '%s\n' "Updating apt lists"; if "${ROOTUPDATE[@]}" &>/dev/null; then printf '%s\n' "Apt list updated"; else printf '%s\n' "Couldn't update apt lists"; return 1; fi; else printf '%s\n' "Updating apt lists"; if "${SUDOUPDATE[@]}" &>/dev/null; then printf '%s\n' "Apt list updated"; else printf '%s\n' "Couldn't update apt lists"; return 1; fi; fi; fi; }

# install_pkgs package(s) using the package manager and pre-configured options
# Return codes
# 0: install_pkg completed
# 1: Error during installation
# 2: Missing package argument
function installPKG { if [[ "$#" -eq 0 ]]; then printf '%s\n' "Requires: [PKG(s) to install]"; return 2; else declare -r OPTIONS=(--quiet --assume-yes --no-show-upgraded --auto-remove=true --no-install-recommends); declare -r SUDOINSTALL=(sudo apt-get "${OPTIONS[@]}" install) ROOTINSTALL=(apt-get "${OPTIONS[@]}" install); declare -a PKG=(); IFS=' ' read -ra PKG <<<"$@"; if [[ "$EUID" -eq 0 ]]; then printf '%s\n' "install_pkging ${PKG[*]}"; if DEBIAN_FRONTEND=noninteractive "${ROOTINSTALL[@]}" "${PKG[@]}"; then printf '%s\n' "install_pkgation complete"; return 0; else printf '%s\n' "Something went wrong during installation"; return 1; fi; else printf '%s\n' "install_pkging ${PKG[*]}"; if DEBIAN_FRONTEND=noninteractive "${SUDOINSTALL[@]}" "${PKG[@]}"; then printf '%s\n' "install_pkgation complete"; return 0; else printf '%s\n' "Something went wrong during installation"; return 1; fi; fi; fi; }

#########################
# Bash - Math Functions #
#########################

# Calculation using bc
function bCalc { printf '%s\n' "$*" | bc -l; }

# Calculation using awk
function Calc { awk "BEGIN{print $*}"; }

# Arithmetic Addition
# Arithmetic Addition
# Only integers.
# Decimals or numbers of type double does not work 
# Return codes
# 0: Success
# 1: Invalid number of arguments
function Addition { [[ "$#" -ne 2 ]] && return 1; printf '%s\n' "$(( "$1" + "$2" ))"; }

# Arithmetic Subtraction
# Only integers.
# Decimals or numbers of type double does not work 
# Return codes
# 0: Success
# 1: Invalid number of arguments
function Subtraction { [[ "$#" -ne 2 ]] && return 1; printf '%s\n' "$(( "$1" - "$2" ))"; }

# Arithmetic Multiplication
# Only integers.
# Decimals or numbers of type double does not work 
# Return codes
# 0: Success
# 1: Invalid number of arguments
function Multiplication { [[ "$#" -ne 2 ]] && return 1; printf '%s\n' "$(( "$1" * "$2" ))"; }

# Arithmetic Division
# Only integers.
# Decimals or numbers of type double does not work 
# Return codes
# 0: Success
# 1: Invalid number of arguments
function Division { [[ "$#" -ne 2 ]] && return 1; printf '%s\n' "$(( "$1" / "$2" ))"; }

# Arithmetic Exponential
# Only integers.
# Decimals or numbers of type double does not work 
# Return codes
# 0: Success
# 1: Invalid number of arguments
function Exponential { [[ "$#" -ne 2 ]] && return 1; printf '%s\n' "$(( "$1" ** "$2" ))"; }

############################
# Bash - Utility Functions #
############################

# Checks for a running process
# Return codes
# 0: Running process exists
# 1: No such running process
# 2: Missing argument: process
# 3: Missing command: pgrep
function findProcess { if command -v pgrep &>/dev/null; then if [[ "$#" -eq 1 ]]; then if pgrep "$1" &>/dev/null; then return 0; else return 1; fi; else printf '%s\n' "Requires argument: process"; return 2; fi; else printf '%s\n' "Command not found: pgrep"; return 3; fi; }

# Checks for a running process
# Return codes
# 0: Running process exists
# 1: No such running process
# 2: Missing argument: process
# 3: Missing command: pgrep
function findFullProcess { if command -v pgrep &>/dev/null; then if [[ "$#" -eq 1 ]]; then if pgrep --full "$1" &>/dev/null; then return 0; else return 1; fi; else printf '%s\n' "Requires argument: process"; return 2; fi; else printf '%s\n' "Command not found: pgrep"; return 3; fi; }

# Gets processes
# Return codes
# 1: Missing command: ps
function getProcesses { if command -v ps &>/dev/null; then ps -A; else printf e[1 "Missing command: ps"; return 1; fi; }

# Checks running processes
function getRunningProcesses { if command -v jobs &>/dev/null; then jobs -r; else printf '%s\n' "Missing command: jobs"; return 1; fi; }

# Get system information
# Return codes
# 0: Success
# 1: Missing command: inxi
# 2: Too many arguments provided
function getSystemInfo { if [[ "$#" -eq 0 ]]; then if command -v inxi &>/dev/null; then inxi -Fxzr; return 0; else printf '%s\n' "Missing command: inxi"; return 1; fi; else printf '%s\n' "Requires no arguments"; return 2; fi; }

# Records the output of a command to a file.
# Return codes
# 0: Success
# 1: Missing argument: Command to record output of
function recordCommand { if [[ "$#" -eq 1 ]]; then declare -r LOGFILE="log.txt"; if [[ -f "$LOGFILE" ]]; then printf '%s\n' "$LOGFILE exists, appending to existing file"; printf '%s\n' "Appending new output from $1" | tee -a "$LOGFILE"; bash -c "$1" | tee -a "$LOGFILE"; return 0; else touch "$LOGFILE"; bash -c "$1" | tee -a "$LOGFILE"; printf '%s\n' "Command output recorded to $LOGFILE"; return 0; fi; else printf '%s\n' "Requires: [Command to record output of]"; return 1; fi; }

# Gets the current time in UNIX & regular time (human-readable format)
# Return codes
# 0: Success
# 1: Error: Too many arguments provided
function getTime { if [[ "$#" -gt 0 ]]; then printf '%s\n' "No arguments required"; return 1; else printf '%s\n' "Regular: $(date -d @"$(date +%s)")" "Unix: $(date +%s)" "Date by locale: $(date +%x)" "Time by locale: $(date +%X)"; return 0; fi; }

# Converts UNIX timestamps to regular human-readable timestamp
# Return codes
# 0: Success
# 1: Missing argument: UNIX Timestamp
function unixTimeToRegular { if [[ "$#" -eq 1 ]]; then printf '%s\n' "$(date -d @"$1")"; return 0; else printf '%s\n' "Requires: [UNIX Timestamp]"; return 1; fi; }

# Gets the time by locale's definition
# Return codes
# 0: Success
# 1: Error: Too many arguments
function getLocaleTime { if [[ "$#" -eq 0 ]]; then date +%X; return 0; else printf '%s\n' "Requires no arguments"; return 1; fi; }

# Gets the date by locale's definition
# Return codes
# 0: Success
# 1: Error: Too many arguments
function getLocaleDate { if [[ "$#" -eq 0 ]]; then date +%x; return 0; else printf '%s\n' "Requires no arguments"; return 1; fi; }

# update_pkgs a Git repository directory and signs the commit before pushing with a message
# Return codes
# 0: Success
# 1: Ḿissing argument(s): Commit message
function updateGit { if [[ "$#" -lt 1 ]]; then printf '%s\n' "No commit message provided"; return 1; else declare -r MESSAGE="$*" GPG_KEY_ID="E2AC71651803A7F7" DIRECTORY="$PWD"; ( declare -r COMMITMESSAGE="࿓❯ ${MESSAGE[*]}"; declare -r GIT_COMMIT_ARGS=(--signoff --gpg-sign="$GPG_KEY_ID" --message="$COMMITMESSAGE"); git add "$DIRECTORY"; git commit "${GIT_COMMIT_ARGS[@]}"; git push; ); return 0; fi; }

# Uses $(<) to read a file to STDOUT, supposedly faster than cat.
# Return codes
# 0: Success
# 1: Not a file
# 2: Error: Too many arguments
# 2: Missing argument: File
function readFile { if [[ "$#" -eq 1 ]]; then if [[ -f "$1" ]]; then printf '%s\n' "$(<"$1")"; return 0; else printf '%s\n' "Not a file"; return 1; fi; elif [[ "$#" -gt 1 ]]; then printf '%s\n' "Too many arguments, only 1 required: [File]"; return 2; else printf '%s\n' "Requires argument: [File]"; return 3; fi; }

# Shows the files in the current working directory's directory & all its sub-directories excluding hidden directories.
# Return codes
# 0: Success
# 1: Error: Arguments provided when none required
function showDirectoryFiles { if [[ "$#" -eq 0 ]]; then declare -r ARGS=(--recursive --files-with-matches --exclude-dir=".*"); grep "${ARGS[@]}" .; return 0; else printf '%s\n' "Requires no arguments"; return 1; fi; }

# Counts the number of files recursively from current working directory
# Return codes
# 0: Success
# 1: Error: Arguments provided when none required
function countDirectoryFiles { if [[ "$#" -eq 0 ]]; then local -r ARGS=(--recursive --files-with-matches --exclude-dir=".*"); grep "${ARGS[@]}" . | wc --lines; return 0; else printf '%s\n' "Requires no arguments"; return 1; fi; }

# Gets the name at the end of a path string after stripping the path
# Return codes
# 0: Success
# 1: No such path exists
# 2: Missing argument: Path
function getPathName { if [[ "$#" -ne 1 ]]; then printf '%s\n' "Requires: [Path to get the name at the end of]"; return 2; elif [[ ! -e "$1" ]]; then printf '%s\n' "No such path: $1"; return 1; else printf '%s\n' "${1##*/}"; return 0; fi; }

# Converts a String to uppercase
# Return codes
# 0: Success
# 1: Missing argument: String
function upperCase { if [[ "$#" -gt 0 ]]; then printf '%s\n' "${*^^}"; return 0; else printf '%s\n' "Requires: [String(s) to make lowercase]"; return 1; fi; }

# Converts the first letter of a String to upper case
# Return codes
# 0: Success
# 1: Missing argument: String
function upperFirstLetter { if [[ "$#" -gt 0 ]]; then printf '%s\n' "${*^}"; return 0; else printf '%s\n' "Requires: [String(s) to make lowercase]"; return 1; fi; }

# Converts a String to lower case
# Return codes
# 0: Success
# 1: Missing argument: String
function lowerCase { if [[ "$#" -gt 0 ]]; then printf '%s\n' "${*,,}"; return 0; else printf '%s\n' "Requires: [String(s) to make lowercase]"; return 1; fi; }

# Converts a String to lower case
# Return codes
# 0: Success
# 1: Missing argument: String
function lowerFirstLetter { if [[ "$#" -gt 0 ]]; then printf '%s\n' "${*,}"; return 0; else printf '%s\n' "Requires: [String(s) to make lowercase]"; return 1; fi; }

# search for a pattern recursively in files of current directory and its sub-directories
# Return codes
# 0: Success
# 1: Missing argument: String
# 2: Missing command: grep
function search { if ! command -v grep &>/dev/null; then printf '%s\n' "Missing command: grep"; return 2; elif [[ "$#" -eq 0 ]]; then printf '%s\n' "Requires: [Pattern(s) to locate]"; return 1; else declare -r ARGS=(--recursive --exclude-dir=".*"); grep "${ARGS[@]}" "$*" 2>/dev/null; return 0; fi; }

# search for pattern in a specific file
# Return codes
# 0: Success
# 1: Not a file
# 2: Missing arguments: String, File
# 3: Missing command: grep
function findTextInFile { if ! command -v grep &>/dev/null; then printf '%s\n' "Missing command: grep"; return 3; elif [[ "$#" -ne 2 ]]; then printf '%s\n' "Requires: [Text pattern to find] [File to search]"; return 2; elif [[ ! -f "$2" ]]; then printf '%s\n' "Not a file: $2"; return 1; else grep "$1" "$2"; return 0; fi; }

# search for files with pattern(s) recursively
# Return codes
# 0: Success
# 1: Missing argument: String
# 2: Missing command: grep
function getFilesWithText { if command -v grep &>/dev/null; then if [[ "$#" -gt 0 ]]; then declare -r ARGS=(--recursive --files-with-matches --exclude-dir=".*"); grep "${ARGS[@]}" "$*" 2>/dev/null; return 0; else printf '%s\n' "Requires: [Pattern(s) to locate]"; return 1; fi; else printf '%s\n' "Missing command: grep"; return 2; fi; }

# Replaces a text pattern in a file with new text
# Return codes
# 0: Success
# 1: Not a file
# 2: Missing arguments: String, String, File
# 3: Missing command: sed
function replaceTextInFile { if ! command -v sed &>/dev/null; then printf '%s\n' "Missing command: sed"; return 3; elif [[ "$#" -ne 3 ]]; then printf '%s\n' "Requires: [Text to replace] [New text] [File]"; return 2; elif [[ ! -f "$3" ]]; then printf '%s\n' "Not a file: $3"; return 1; else sed -i "s|$1|$2|g" "$3"; return 0; fi; }

# Replaces given text pattern with a new one in all files recursively from current working directory
# Return codes
# 0: Success
# 1: Missing arguments: String, String
# 2: Missing command: sed
function replaceTextInAllFiles { if ! command -v sed &>/dev/null; then printf '%s\n' "Missing command: sed"; return 2; elif [[ "$#" -ne 2 ]]; then printf '%s\n' "Requires: [Text to replace] [New text]"; return 1; else for F in $(getFilesWithText "$FINDTEXT"); do sed -i "s|$1|$2|g" "$F"; done; return 0; fi; }

# Makes all matching text patterns into camel case String in a file
# Return codes
# 0: Success
# 1: Not a file
# 2: Missing arguments: String, File
# 3: Missing command: sed
function makeCamelCaseInFile { if ! command -v sed &>/dev/null; then printf '%s\n' "Missing command: sed"; return 3; elif [[ "$#" -ne 2 ]]; then printf '%s\n' "Requires: [Text pattern] [File]"; return 2; elif [[ ! -f "$2" ]]; then printf '%s\n' "Not a file: $2"; return 1; else sed -i "s|$1|${1,}|g" "$2"; return 0; fi; }

# Makes all matching text patterns into camel case String recursively in all files from current working directory
# Return codes
# 0: Success
# 1: Missing argument: String
# 2: Missing command: sed
function makeCamelCaseInAllFiles { if ! command -v  sed &>/dev/null; then printf '%s\n' "Missing command: sed"; return 2; elif [[ "$#" -ne 1 ]]; then printf '%s\n' "Requires: [Text pattern]"; return 1; else for F in $(getFilesWithText "$FINDTEXT"); do sed -i "s|$1|${1,}|g" "$F"; done; return 0; fi; }

# Appends text after line number
# Return codes
# 0: Success
# 1: Not a positive integer digit
# 2: Not a file
# 3: Missing arguments: Integer, String, File
# 4: Missing command: sed
function appendTextAtLine { if ! command -v sed &>/dev/null; then printf '%s\n' "Missing command: sed"; return 4; elif [[ "$#" -ne 3 ]]; then printf '%s\n' "Requires: [Line number] [Text to append] [File]"; return 3; elif [[ ! -f "$3" ]]; then printf '%s\n' "Not a file: $3"; return 2; elif [[ "$1" -lt 0 ]]; then printf '%s\n' "Not a positive integer digit: $1"; return 1; else sed -i ''"$1"'a '"$2"'' "$3"; return 0; fi; }

# Appends text after matching text pattern
# Return codes
# 0: Success
# 1: Not a file
# 2: Missing arguments: String, String, File
# 3: Missing command: sed
function appendTextAtPattern { if ! command -v sed &>/dev/null; then printf '%s\n' "Missing command: sed"; return 3; elif [[ "$#" -ne 3 ]]; then printf '%s\n' "Requires: [Locate String] [Append String] [File]"; return 2; elif [[ ! -f "$3" ]]; then printf '%s\n' "Not a file: $3"; return 1; else sed -i '/'"$1"'/a '"$2"'' "$3"; return 0; fi; }

# Appends text after the last line
# Return codes
# 0: Success
# 1: Not a file
# 2: Missing arguments: String, File
# 3: Missing command: sed
function appendTextAtLastLine { if ! command -v sed &>/dev/null; then printf '%s\n' "Missing command: sed"; return 3; elif [[ "$#" -ne 2 ]]; then printf '%s\n' "Requires: [Text to append] [File]"; return 2; elif [[ ! -f "$2" ]]; then printf '%s\n' "Not a file: $2"; return 1; else sed -i '$a '"$1"'' "$2"; return 0; fi; }

# Insert text before line number
# Return codes
# 0: Success
# 1: Not a file
# 2: Not a positive integer digit
# 3: Missing arguments: Integer, String, File
# 4: Missing command: sed
function insertTextAtLine { if ! command -v sed &>/dev/null; then printf '%s\n' "Missing command: sed"; return 4; elif [[ "$#" -ne 3 ]]; then printf '%s\n' "Requires: [Line number] [Text to insert] [File]"; return 3; elif [[ "$1" -lt 0 ]]; then printf '%s\n' "Not a positive integer digit: $1"; return 2; elif [[ ! -f "$3" ]]; then printf '%s\n' "Not a file: $3"; return 1; else sed -i ''"$1"'i '"$2"'' "$3"; return 0; fi; }

# Insert text before matching text pattern
# Return codes
# 0: Success
# 1: Not a file
# 2: Missing arguments: String, String, File
# 3: Missing command: sed
function insertTextAtPattern { if ! command -v sed &>/dev/null; then printf '%s\n' "Missing command: sed"; return 3; elif [[ "$#" -ne 3 ]]; then printf '%s\n' "Requires: [Text pattern] [Text to insert] [File]"; return 2; elif [[ ! -f "$3" ]]; then printf '%s\n' "Not a file: $3"; return 1; else sed -i '/'"$1"'/i '"$2"'' "$3"; return 0; fi; }

# Inserts text before the last line
# Return codes
# 0: Success
# 1: Not a file
# 2: Missing arguments: String, File
# 3: Missing command: sed
function insertTextAtLastLine { if ! command -v sed &>/dev/null; then printf '%s\n' "Missing command: sed"; return 3; elif [[ "$#" -ne 2 ]]; then printf '%s\n' "Requires: [Text to insert] [File]"; return 2; elif [[ ! -f "$2" ]]; then printf '%s\n' "Not a file: $2"; return 1; else sed -i '$i '"$1"'' "$2"; return 0; fi; }

# Deletes a specified line in a file
# Return codes
# 0: Success
# 1: Not a file
# 2: Not a positive integer digit
# 3: Missing arguments: Integer, File
# 4: Missing command: sed
function deleteLineInFile { if ! command -v sed &>/dev/null; then printf '%s\n' "Missing command: sed"; return 4; elif [[ "$#" -ne 2 ]]; then printf '%s\n' "Requires: [Line number] [File]"; return 3; elif [[ "$1" -lt 0 ]]; then printf '%s\n' "Not a positive integer digit: $1"; return 2; elif [[ ! -f "$2" ]]; then printf '%s\n' "Not a file: $2"; return 1; else sed -i ''"$1"'d' "$2"; return 0; fi; }

# Deletes a specified range in a file
# Return codes
# 0: Success
# 1: Not a file
# 2: Not a positive integer digit range
# 3: Missing arguments: Integer, Integer, File
# 4: Missing command: sed
function deleteRangeInFile { if ! command -v sed &>/dev/null; then printf '%s\n' "Missing command: sed"; return 4; elif [[ "$#" -ne 3 ]]; then printf '%s\n' "Requires: [Start of range] [End of range] [File]"; return 3; elif [[ "$1" -lt 0 || "$2" -lt 0 ]]; then printf '%s\n' "Not a positive integer digit range: $1 & $2"; return 1; elif [[ ! -f "$3" ]]; then printf '%s\n' "Not a file: $3"; return 2; else sed -i ''"$1"','"$2"'d' "$3"; return 0; fi; }

# Gets the length of an array
# Return codes
# 0: Success
# 1: Not an array
# 2: Wrong nr of arguments, 1 required: Array to get length of
function arrayLength { if [[ "$#" -ne 1 ]]; then printf '%s\n' "Requires 1 argument: [Array]"; return 2; elif ! declare -a "$1" &>/dev/null; then printf '%s\n' "Not an array: $1"; return 1; else printf '%s\n' "${#1[@]}"; return 0; fi; }

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
function genPassword { < /dev/urandom tr -dc 'A-Za-z0-9{[#$@]}' | head -c"${1:-36}"; printf '\n'; return 0; }

# Generates a password using OpenSSL, default length is 36.
# Return codes
# 0: Success
# 1: Missing command: openssl
function genOpenSSLPassword { if command -v openssl &>/dev/null; then openssl rand -base64 "${1:-36}"; return 0; else printf '%s\n' "OpenSSL command not available"; return 1; fi; }

# Retrieves the members of a group
# Return codes
# 0: Success
# 1: Missing argument: Group name
function getGroupMembers { if [[ "$#" -eq 1 ]]; then mapfile -d ',' -t GROUP_USERS < <(awk -F':' '/'"$1":'/{printf $4}' /etc/group); printf '%s\n' "${GROUP_USERS[*]}"; unset GROUP_USERS; return 0; else printf '%s\n' "Requires: [Group name]"; return 1; fi; }

# Retrieves the groups a user is a member of
# 0: User exists, show group membership
# 1: No such user exists
function getUserGroups { if ! id --user "$1" &>/dev/null; then printf e[1 "No such user: $1"; return 1; else groups "$1"; return 0; fi; }

# Retrieves the group IDs a user is a member of
# 0: User exists, show group membership
# 1: No such user exists
# 2: Invalid number of arguments
function userGroupIDs { [[ "$#" -ne 1 ]] && printf '%s\n' "Invalid number of arguments"; return 2; if ! id --user "$1" &>/dev/null; then printf e[1 "No such user: $1"; return 1; else id --groups "$1"; return 0; fi; }

############################
# Bash - Network Functions #
############################


# Test if a port is open or closed on a remote host
# Exit codes
# 1: Open
# 2: Closed
# 3: Invalid number of arguments
function testRemotePort { if [[ "$#" -eq 2 ]]; then if timeout 2.0 bash -c "true &>/dev/null>/dev/tcp/${1}/${2}"; then printf '%s\n' "Open"; return 0; else printf '%s\n' "Closed"; return 1; fi; else printf '%s\n' "Requires: [HOST] [PORT]"; return 2; fi; }

# Queries DNS record of a domain
# Return codes
# 0: Success
# 1: Error: Too many arguments provided
# 2: Missing argument(s): Domain, Optional Domain Record
function getDNSRecord { if [[ "$#" -eq 2 ]]; then dig "$1" "$2" +short; return 0; elif [[ "$#" -eq 1 ]]; then dig "$1" +short; return 0; elif [[ "$#" -gt 2 ]]; then printf '%s\n' "Too many arguments provided"; return 1; else printf '%s\n' "No argument arguments provided"; return 2; fi; }

# Gets the public IP for the network
# Return codes
# 0: Success
# 1: Missing command: curl
function getPublicIP { if command -v curl &>/dev/null; then declare -r URLIPv4="https://ipv4.icanhazip.com" URLIPv6="https://ipv6.icanhazip.com" ARGS=(--silent --max-time 4); local IPv4 IPv6; IPv6="$(curl "${ARGS[@]}" --ipv6 "$URLIPv6" 2>/dev/null || echo 'N/A')"; IPv4="$(curl "${ARGS[@]}" --ipv4 "$URLIPv4" 2>/dev/null || echo 'N/A')"; printf '%s\n' "IPv4: $IPv4" "IPv6: $IPv6"; return 0; else printf '%s\n' "Missing command: curl"; return 1; fi; }

# Tests for Public IPv4
# Return codes
# 0: Public IPv4 Available
# 1: Public IPv4 Unavailable
# 2: Missing command: curl
function testPublicIPv4 { if command -v curl &>/dev/null; then declare -r URL="https://ipv4.icanhazip.com" ARGS=(--silent --max-time 4 --ipv4); if curl "${ARGS[@]}" "$URL" &>/dev/null; then printf '%s\n' "Available"; return 0; else printf '%s\n' "Unavailable"; return 1; fi; else printf '%s\n' "Missing command: curl"; return 2; fi; }

# Tests for Public IPv6
# Return codes
# 0: Public IPv6 Available
# 1: Public IPv6 Unavailable
# 2: Missing command: curl
function testPublicIPv6 { if command -v curl &>/dev/null; then declare -r URL="https://ipv6.icanhazip.com" ARGS=(--silent --max-time 4 --ipv6); if curl "${ARGS[@]}" "$URL" &>/dev/null; then printf '%s\n' "Available"; return 0; else printf '%s\n' "Unavailable"; return 1; fi; else printf '%s\n' "Missing command: curl"; return 2; fi; }

# Gets the local IP assigned to the WiFi card for the device
# IPv4, IPv6 & Link-local
function getLocalIP { if command -v jq &>/dev/null; then ip -j address | jq '.[2].addr_info' | jq -r '.[].local'; else ip a | grep 'scope global' | awk '{print $2}' | head -2 | sed 's|/.*||g'; fi; }

# Gets all the local IP-addresses on the device
function getAllLocalIP { if command -v jq &>/dev/null; then ip -j address | jq '.[].addr_info' | jq -r '.[].local'; else ip a | grep 'inet' | awk '{print $2}' | sed 's|/.*||g'; fi; }

# Get device IP information
function getIpInfo { if [[ "$#" -gt 0 ]]; then printf '%s\n' "No arguments required"; return 1; elif command -v jq &>/dev/null; then ip -j address | jq '.'; else ip address; fi; }

# Gets the listening ports on the system
# Return codes
# 1: Missing command: grep
# 2: Missing command: lsof
function getListeningPorts { if ! command -v lsof &>/dev/null; then printf '%s\n' "Missing command: lsof"; return 2; elif ! command -v grep &>/dev/null; then printf '%s\n' "Missing command: grep"; return 1; elif [[ "$EUID" -eq 0 ]]; then grep 'LISTEN' <(lsof -i -P -n); else sudo lsof -i -P -n | grep 'LISTEN'; fi; }

# Gets the services running on the network interfaces
# Return code
# 1: Missing command: lsof
function get_network_interface_services { if ! command -v lsof &>/dev/null; then printf '%s\n' "Missing command: lsof"; return 1; elif [[ "$EUID" -eq 0 ]]; then lsof -nP -i; else sudo lsof -nP -i; fi; }

# Gets the HTML code for a URL with Bash TCP
# Reuires the host TCP server to listen on HTTP, not HTTPS
# Return codes
# 0: Success
# 1: Arguments error, requires: Host, Port
function getURL { if [[ "$#" -eq 2 ]]; then exec 5<>/dev/tcp/"$1"/"$2"; echo -e "GET / HTTP/1.1\r\nHost: ${HOST}\r\nConnection: close\r\n\r" >&5; cat <&5; return 0; else printf '%s\n' "Requires: [HOST] [PORT]"; return 1; fi; }

# Fetches the current price of Bitcoin in Euro € from Binance
# Return codes
# 0: Success
# 1: Missing required command: curl
function getBTC { declare -r URL="https://api.binance.com/api/v3/ticker/price?symbol=BTCEUR" ARGS=(--silent --location); if command -v curl &>/dev/null; then if ! command -v jq &>/dev/null; then curl "${ARGS[@]}" "$URL"; return 0; else curl "${ARGS[@]}" "$URL" | jq '.'; return 0; fi; else printf '%s\n' "Missing command: curl"; return 1; fi; }


###############################
# Bash - Permission Functions #
###############################

# Set ownership permissions on a file
# Return status codes
# 0: Success
# 1: Failed to set ownership to file: $1:$2 $3
# 2: Command not found: sudo
# 3: Not a file: $3
# 4: Invalid number of arguments
function set_owner { if [[ "$#" -ne 3 ]]; then return 4; elif [[ ! -f "$3" ]]; then return 3; else; if [[ "$EUID" -eq 0 ]]; then if chown "$1":"$2" "$3"; then return 0; else return 1; fi; elif command -v sudo; then if sudo chown "$1":"$2" "$3"; then return 0; else return 1; fi; else return 2; fi; fi; }

# Set ownership permissions on a path recursively
# Return status codes
# 0: Success
# 1: Failed to set ownership to file: $1:$2 $3
# 2: Command not found: sudo
# 3: Not a file: $3
# 4: Invalid number of arguments
function set_owner_recursive { if [[ "$#" -ne 3 ]]; then return 4; elif [[ ! -e "$3" ]]; then return 3; else; if [[ "$EUID" -eq 0 ]]; then if chown --recursive "$1":"$2" "$3"; then return 0; else return 1; fi; elif command -v sudo; then if sudo chown --recursive  "$1":"$2" "$3"; then return 0; else return 1; fi; else return 2; fi; fi; }

# Changes permissions on a given file
# Checks for which argument is a file & a positive integer digit
# Return status codes
# 0: Success
# 1: Failed to change permissions on file: $1 or $2
# 2: Command not found: sudo
# 3: Not a file: $1 or $2
# 4: Not a positive integer digit: $1 or $2
# 5: Invalid number of arguments
function change_permissions { if [[ "$#" -ne 2 ]]; then return 5; else; if [[ ! "$1" =~ [0-9*] ]] && [[ ! "$2" =~ [0-9*] ]]; then return 4; elif [[ ! -f "$1" ]] && [[ ! -f "$2" ]]; then return 3; elif [[ "$1" =~ [0-9*] ]] && [[ -f "$2" ]]; then if [[ "$EUID" -eq 0 ]]; then if chmod "$1" "$2"; then return 0; else return 1; fi; else; if command -v sudo; then if sudo chmod "$1" "$2"; then return 0; else return 1; fi; else return 2; fi; fi; elif [[ "$2" =~ [0-9*] ]] && [[ -f "$1" ]]; then if [[ "$EUID" -eq 0 ]]; then if chmod "$2" "$1"; then return 0; else return 1; fi; else; if command -v sudo; then if sudo chmod "$2" "$1"; then return 0; else return 1; fi; else return 2; fi; fi; fi; fi; }

# Change permissions recursively on a given path
# Checks for which argument is a file & a positive integer digit
# Return status codes
# 0: Success
# 1: Failed to change permissions on file: $1 or $2
# 2: Command not found: sudo
# 3: Not a path: $1 or $2
# 4: Not a positive integer digit: $1 or $2
# 5: Invalid number of arguments
function change_permissions_recursively { if [[ "$#" -ne 2 ]]; then return 5; else; if [[ ! "$1" =~ [0-9*] ]] && [[ ! "$2" =~ [0-9*] ]]; then return 4; elif [[ ! -e "$1" ]] && [[ ! -e "$2" ]]; then return 3; elif [[ "$1" =~ [0-9*] ]] && [[ -e "$2" ]]; then if [[ "$EUID" -eq 0 ]]; then if chmod "$1" "$2"; then return 0; else return 1; fi; else; if command -v sudo; then if sudo chmod "$1" "$2"; then return 0; else return 1; fi; else return 2; fi; fi; elif [[ "$2" =~ [0-9*] ]] && [[ -f "$1" ]]; then if [[ "$EUID" -eq 0 ]]; then if chmod "$2" "$1"; then return 0; else return 1; fi; else; if command -v sudo; then if sudo chmod "$2" "$1"; then return 0; else return 1; fi; else return 2; fi; fi; fi; fi; }

# Changes owner of file
# Return status codes
# 0: Success
# 1: Failed to change owner of the file
# 2: Missing command: sudo
# 3: Not a file: $2
# 4: Not a user: $1
# 5: Invalid number of arguments
function change_owner { if [[ "$#" -ne 2 ]]; then return 5; else; if ! id -u "$1" &>/dev/null; then return 4; elif [[ -f "$2" ]]; then if [[ "$EUID" -eq 0 ]]; then if chown "$1":"$1" "$2"; then return 0; else return 1; fi; elif command -v sudo; then if sudo chown "$1":"$1" "$2"; then return 0; else return 1; fi; else return 2; fi; else return 3; fi; fi; }


# Changes owner of file/directory recursively
# Return status codes
# 0: Success
# 1: Failed to change owner of the file
# 2: Missing command: sudo
# 3: Not a file: $2
# 4: Not a user: $1
# 5: Invalid number of arguments
function change_owner_recursive { if [[ "$#" -ne 2 ]]; then return 5; else; if ! id -u "$1" &>/dev/null; then return 4; elif [[ -f "$2" ]]; then if [[ "$EUID" -eq 0 ]]; then if chown --recursive "$1":"$1" "$2"; then return 0; else return 1; fi; elif command -v sudo; then if sudo chown --recursive "$1":"$1" "$2"; then return 0; else return 1; fi; else return 2; fi; else return 3; fi; fi; }

# Makes a file executable
# Return status codes
# 0: Success
# 1: Failed to make file executable
# 2: Missing command: sudo
# 3: Not a file: $1
# 4: Invalid number of arguments
function make_executable { if [[ "$#" -ne 1 ]]; then return 4; else; if [[ -f "$1" ]]; then if [[ "$EUID" -eq 0 ]]; then if chmod +x "$1"; then return 0; else return 1; fi; elif command -v sudo &>/dev/null; then if sudo chmod +x "$1"; then return 0; else return 1; fi; else return 2; fi; else return 3; fi; fi; }

# Make files executable recursively
# Return status codes
# 0: Success
# 1: Failed to make files executable
# 2: Missing command: sudo
# 3: Not a file: $1
# 4: Invalid number of arguments
function make_executable_recurisve { if [[ "$#" -ne 1 ]]; then return 4; else; if [[ -f "$1" ]] || [[ -d "$1" ]]; then if [[ "$EUID" -eq 0 ]]; then if chmod --recursive +x "$1"; then return 0; else return 1; fi; elif command -v sudo &>/dev/null; then if sudo chmod --recursive +x "$1"; then return 0; else return 1; fi; else return 2; fi; else return 3; fi; fi; }

###########################
# Bash - Docker Functions #
###########################
# Template
# Return codes
# 0: Success
# 1:
# 2:
# 3:


# Get the Container ID & Name of running containers
# Return codes
# 0: Success
# 1: Command not found: docker
# 2: Command not found: awk
# 3: Invalid number of arguments
function get_containers { if [[ "$#" -ne 1 ]]; then return 3; elif [[ ! "$1" -gt 2 ]]; elif ! command -v awk &>/dev/null; then return 2; elif ! command -v docker &>/dev/null; then return 1; else docker ps | awk '{print $2,$1,$5,$4}' | tail -n +2; return 0; fi; }

# Get the Container ID of all running containers
# Return codes
# 0: Success
# 1: Command not found: docker
# 2: Command not found: awk
# 3: Invalid number of arguments
function get_all_container_ID { if [[ "$#" -ne 0 ]]; then return 3; elif ! command -v awk &>/dev/null; then return 2; elif ! command -v docker &>/dev/null; then return 1; else docker ps | awk '{print $1}' | tail -n +2; return 0; fi; }

# Gets the latest Container ID of the running containers
# Return codes
# 0: Success
# 1: Command not found: docker
# 2: Command not found: awk
# 3: Invalid number of arguments
function get_latest_container_ID { if [[ "$#" -ne 0 ]]; then return 3; elif ! command -v awk &>/dev/null; then return 2; elif ! command -v docker &>/dev/null; then return 1; else docker ps | awk '{print $1}' | tail -n +2 | head -1; return 0; fi; }

# Checks if a given user is a member of the docker group
# 0: Is a member of group: docker
# 1: Not a member of group: docker
# 2: Not a user: $1
# 3: Invalid number of arguments
function user_docker_group { if [[ "$#" -ne 1 ]]; then return 3; elif ! id -u "$1" &>/dev/null; then return 2; else declare -r -a GROUP_NAMES=("$(id --groups --name "$1")"); if [[ "${GROUP_NAMES[*]}" == *"docker"* ]]; then return 0; else return 1; fi; fi; }

# Checks if the executing user is a member of the docker group
# 0: Is a member of group: docker
# 1: Not a member of group: docker
# 2: Invalid number of arguments
function in_docker_group { if [[ "$#" -eq 0 ]]; then declare -r -a GROUP_NAMES=("$(id --groups --name "$EUID")"); if [[ "${GROUP_NAMES[*]}" == *"docker"* ]]; then return 0; else return 1; else return 2; fi; fi; }

function remove_latest_image { if command -v docker &>/dev/null && command -v awk &>/dev/null; then if [[ "$EUID" -eq 0 ]] || [[ "$(id --groups --name "$EUID")" == *"docker"* ]]; then docker rmi "$(docker images | awk '{print $3}' | tail -n +2 | head -1)"; else sudo docker rmi "$(sudo docker images | awk '{print $3}' | tail -n +2 | head -1)"; fi ; fi; }

