#!/usr/bin/env bash
# Victor-ray, S.

. ./utility.sh

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
# 3: Missing command: dpkg-query
function has_pkg {
    ! has_cmd 'dpkg-query' && { return 3; }
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$(dpkg-query --status "$1" &>/dev/null; print_int "$?")" -eq 0 ]]
}

# Checks if a package exists in the cached apt list
# Return status codes
# 0: Is available in apt
# 1: Not available in apt
# 2: Invalid number of arguments
# 3: Missing command: apt-cache
function has_apt_package {
    ! has_cmd 'apt-cache' && { return 3; }
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$(apt-cache show "$1" &>/dev/null; print_int "$?")" -eq 0 ]]
}

# Checks if a package exists on the system using dpkg and apt
# Return status codes
# 0: Package is installed
# 1: Package is not installed but is available in apt
# 2: Package is not installed and is not available in apt
# 3: Missing package argument to check
# 4: Missing command: apt-cache
# 5: Missing command: dpkg-query
function check_package {
    [[ "$#" -ne 1 ]] && { log  2 "Invalid number of arguments: $#/1"; return 3; }
    if has_pkg "$1"
    then
        log -1 "Installed: $1"
        return 0
    elif [[ "$?" -eq 3 ]]
    then
        log -1 "Missing command: apt-cache"
        return 4
    else
        if has_apt_package "$1"
        then
            log -1 "Install available: $1"
            return 1
        elif [[ "$?" -eq 3 ]]
        then
            log -1 "Missing command: dpkg-query"
            return 5
        else
            log -1 "Not found: $1"
            return 2
        fi
    fi
}


function is_email_html5_standard {
    [[ "$1" =~ ^([a-zA-Z0-9.!#$%&\'*+/=?^_\`{|}~-]+@[a-zA-Z0-9])$ ]]
}
