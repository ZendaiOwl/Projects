
* TOC
{:toc}

---

___Bash___

My notes about Bash & functions I've written and a bunch of other stuff

## Aliases

```bash
# Changes the scrolling direction on a laptop with a touchpad
alias change_scroll="synclient vertscrolldelta=-50"

# Rebuilds NixOS and switches to the new deriviation
alias rebuild="sudo nixos-rebuild switch";

# NixOS & Nix-store garbage collection
alias nix-clean="sudo nix-collect-garbage";

# Rebuilds NixOS and switches to the new deriviation then cleans up  
alias nix-new="sudo nixos-rebuild switch && sudo nix-collect-garbage";

# Executes a command using nix-shell & GCC as CC linker
alias cmd="nix-shell -p gcc --command";

# Cargo (Rust) with nix-shell
alias cargo_update="nix-shell -p gcc --command 'cargo update'";
alias cargo_check="nix-shell -p gcc --command 'cargo check'";
alias cargo_run="nix-shell -p gcc --command 'cargo run'";
alias cargo_build="nix-shell -p gcc --command 'cargo build'";
```

---

## Spider API

Spider a website and save the URL's to a file.

```bash
wget --spider --force-html -r -l5 "https://$DOMAIN_NAME" 2>&1 | \
grep '^--' | awk '{print $3}' > urls.txt
```

---

## /dev/tcp

Uses `/dev/tcp` to send a TCP request and see if there is a response or not. 

```bash
# Redirects both STDOUT & STDERR to /dev/null
if ( echo >/dev/tcp/"$HOST"/"$PORT" ) &>/dev/null
then echo "open"
else echo "closed"
fi

# No redirection
if ( true >/dev/tcp/"$HOST"/"$PORT" )
then echo "open"
else echo "closed"
fi

# Redirect STDERR to /dev/null for no error message
if ( true 2>/dev/null>/dev/tcp/"$HOST"/"$PORT" )
then echo "open"
else echo "closed"
fi
```

Ex.

```bash
# IPv4 at Google.com
if ( echo >/dev/tcp/ipv4.google.com/80 ) &>/dev/null
then echo "open"
else echo "closed"
fi

# IPv4 Loopback
if ( echo >/dev/tcp/127.0.0.1/80 ) &>/dev/null
then echo "open"
else echo "closed"
fi

# IPv6 at Google.com
if ( echo >/dev/tcp/ipv6.google.com/80 ) &>/dev/null
then echo "open"
else echo "closed"
fi

# IPv6 Loopback 
if ( true >/dev/tcp/::1/443 )
then echo "open"
else echo "closed"
fi

# Ex. Test IPv4 & IPv6 ports 80 & 443 at Google.com
# Note: The TCP device isn't really compatible with HTTPS, TLS & SSL
for i in 80 443
do
    ( true 2>/dev/null>/dev/tcp/ipv4.google.com/"$i" ) && {
	    echo "Port $i is open"
	}
    ( true 2>/dev/null>/dev/tcp/ipv6.google.com/"$i" ) && {
	    echo "Port $i is open"
	}
done
```

---

## Colour

_16-bit ANSI colour codes_

+ `\e[0;34m` = *Normal*
+ `\e[1;34m` = *Bold*
+ `\e[2;34m` = *Light*
+ `\e[3;34m` = *Italic*
+ `\e[4;34m` = *Underlined*
+ `\e[5;34m` = *Blinking*
+ `\e[6;34m` = *Blinking*
+ `\e[7;34m` = *Background/Highlighted*
+ `\e[8;34m` = *Blank/Removed*
+ `\e[9;34m` = *Crossed over*

These can be combined, ex. `\e[1;5;m` = Blinking Bold

```bash
# 16-bit colours
BLUE='\e[34m'              # Blue
GREEN='\e[32m'             # Green
YELLOW='\e[33m'            # Yellow
WHITE='\e[37m'             # White
DEFAULT_FOREGOUND='\e[39m' # Default foreground colour
RESET='\e[0m'              # Reset
# Other examples
# BOLD WHITE    \e[1;37m
# BOLD CYAN     \e[1;36m
# BOLD PURPLE   \e[1;35m
# BOLD BLUE     \e[1;34m
# BOLD YELLOW   \e[1;33m
# BOLD GREEN    \e[1;32m
# BOLD RED      \e[1;31m
# BOLD BLACK    \e[1;30m
# BLINK         \e[5m
# RESET         \e[0m
```

See more codes on [Wikipedia](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR) or this [Gist](https://gist.githubusercontent.com/fnky/458719343aabd01cfb17a3a4f7296797/raw/7e502a89d1fbe32927b570298555953a6912c1c5/ANSI.md).

An example for writing colored text with `echo`

`echo -e "\e[COLOR_CODEmSome Text\e[0m"`

Ex. `echo -e "\e[34mHello there, how are you?\e[0m"`

| Option        | Description                                |
| :-:           | :-:                                        |
| `-e`          | Enable interpretation of backslash escapes |
| `\e[`         | Begin the color modifications              |
| `COLOR_CODEm` | Color code + `m` at the end                |
| `\e[0m`       | End the color modifications                |

---

## Functions

### Log

Many of the functions listed here will use this `log` function for printing log messages.

```bash
# A log that uses log levels for logging different outputs
# Return codes
# 1: Invalid log level
# 2: Invalid number of arguments
# Log level   | colour
# -2: Debug   | BLUE='\e[1;34m'
# -1: Info    | CYAN='\e[1;36m'
#  0: Success | GREEN='\e[1;32m'
#  1: Warning | YELLOW='\e[1;33m'
#  2: Error   | RED='\e[1;31m'
function log {
    if [[ "$#" -gt 0 ]]; then
        if [[ "$1" =~ [(-2)-2] ]]; then
            if [[ "$#" -gt 1 ]]; then
                case "$1" in
                    -2) ( printf '\e[1;34m%s\e[0m %s\n' "DEBUG"   "${*:2}" 1>&2 ) ;;
                    -1) ( printf '\e[1;36m%s\e[0m %s\n' "INFO"    "${*:2}"      ) ;;
                     0) ( printf '\e[1;32m%s\e[0m %s\n' "SUCCESS" "${*:2}"      ) ;;
                     1) ( printf '\e[1;33m%s\e[0m %s\n' "WARNING" "${*:2}"      ) ;;
                     2) ( printf '\e[1;31m%s\e[0m %s\n' "ERROR"   "${*:2}" 1>&2 ) ;;
                esac
            else
                case "$1" in
                    -2) ( printf '\e[1;34m%s\e[0m\n' "DEBUG" 1>&2 ) ;;
                    -1) ( printf '\e[1;36m%s\e[0m\n' "INFO"       ) ;;
                     0) ( printf '\e[1;32m%s\e[0m\n' "SUCCESS"    ) ;;
                     1) ( printf '\e[1;33m%s\e[0m\n' "WARNING"    ) ;;
                     2) ( printf '\e[1;31m%s\e[0m\n' "ERROR" 1>&2 ) ;;
                esac
            fi
        else
            (
                ( log 2 "Invalid log-level, use: -2, -1, 0, 1 or 2" )
                ( log -1 "See with 'for x in -2 -1 0 1 2; do log \"\$x\"; done'" 1>&2 )
            ); return 1
        fi
    else ( log 2 "Invalid number of arguments: $#/1+" ); return 2 
    fi
}
```

---

### Print

Various printing functions using `printf` instead of using `echo` for compatibility and reducing unwanted behaviour

***String***

```bash
# Prints a line using printf instead of using echo
# For compatibility and reducing unwanted behaviour
# String: Arguments appended to one line
function print {
     ( printf "%s\n" "$*" )
}

# String: Each argument on a new line
function println {
    ( printf '%s\n' "$@" )
}
```

***Digit***

`%d` is a number or digit type format, it does not represent a `double` type

```bash
# Digit: Arguments appended to one line
function print_digit {
    [[ ! "$*" =~ ^[[:space:][:digit:]]*$ ]] && { return 1; }
    (
        ( printf '%d' "$@" )
        ( printf '\n' )
    )
}

# Digit: Each argument on a new line
function println_digit {
    [[ ! "$*" =~ [[:space:][:digit:]]* ]] && { return 1; }
    ( printf '%d\n' "$@" )
}
```

***Integer***

```bash
# Integer: Arguments appended to one line
function print_int {
    [[ ! "$*" =~ ^[[:space:][:digit:]]*$ ]] && { return 1; }
    (
        ( printf '%i' "$@" )
        ( printf '\n' )
    )
}

# Integer: Each argument on a new line
function println_int {
    [[ ! "$*" =~ ^[[:space:][:digit:]]*$ ]] && { return 1; }
    ( printf '%i\n' "$@" )
}
```

***Float***

```bash
# Float: Arguments appended to one line
function print_float {
    (
        ( printf '%f' "$@" )
        ( printf '\n' ) 
    )
}

# Float: Each argument on a new line
function println_float {
    ( printf '%f\n' "$@" )
}
```

***Error printing***

Uses the [log function](#log) to print error messages to `STDERR` or a file.

```bash
# With timestamp to STDERR
function print_err {
    ( log 2 "$(date +%c) $*" )
}

# With timestamp to a file
function err_log {
    if [[ -f "$1" ]]
    then
        ( log 2 "$(date +%c) ${*:2}" >> "$1" )
    else
        ( log 2 "$(date +%c) ${*:2}" > "$1" )
    fi
}
```

---

### Calculus

***Basic calculator***

```bash
# Calculation using bc
function bC {
    ( printf '%s\n' "$*" | bc -l )
}
```

***Awk***

```bash
# Calculation using awk
function Calc {
    ( awk "BEGIN{print $*}" )
}
```

***Addition***

```bash
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
        ( print_int "$(( "$1" + "$2" ))" )
    }
}
```

***Subtraction***

```bash
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
    ( print_int "$(( "$1" - "$2" ))" )
}
```

***Multiplication***

```bash
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
    ( print_int "$(( "$1" * "$2" ))" )
}
```

***Division***

```bash
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
    ( print_int "$(( "$1" / "$2" ))" )
}
```

***Exponential***

```bash
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
    ( print_int "$(( "$1" ** "$2" ))" )
}
```

---

### Finance

```bash
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
    (
        println "[ $1 ] Old" \
            "[ $2 ] New" \
            "[ $(Calc "$2"-"$1") ] Difference" \
            "[ $(Calc "$(Calc "$2"-"$1")"/"$1") ] Decimal" \
            "[ $(Calc "$(Calc "$(Calc "$2"-"$1")"/"$1")"*100)% ] Percentile"
    )
}
README```

```bash
# Calculates the percentile a value is of another value
function percentile {
    [[ "$#" != 2 ]] && { return 1; }
    [[ "$1" == 0 || "$2" == 0 ]] && { return 2; }
    (
        println "[ $1 ] Whole" \
            "[ $2 ] Part" \
            "[ $(Calc "$2"/"$1") ] Decimal" \
            "[ $(Calc "$(Calc "$2"/"$1")"*100)% ] Percentage"
    )
}
```

---

### Tests

```bash
# Checks if a given variable is an array or not
# Return codes
# 0: Variable is an array
# 1: Variable is not an array
# 2: Invalid number of arguments
function is_array {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$(declare +a "$1" &>/dev/null; print_int "$?")" -eq 0 ]]
}
```

```bash
# Checks if a given variable contains only digits (positive integers)
function is_digit {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$1" =~ ^[[:digit:]]*$ ]]
}
```

```bash
# Checks if given path is a directory 
# Return codes
# 0: Is a directory
# 1: Not a directory
# 2: Invalid number of arguments
function is_directory {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -d "$1" ]]
}
```

```bash
# Checks if 2 given digits are equal
# Return codes
# 0: Is equal
# 1: Not equal
# 2: Invalid number of arguments
function is_equal {
    [[ "$#" -ne 2 ]] && { return 2; }
    [[ "$1" -eq "$2" ]]
}
```

```bash
# Checks if the first given digit is greater than or equal to the second digit
# Return codes
# 0: Is greater than or equal
# 1: Not greater than or equal
# 2: Invalid number of arguments
function is_equal_or_greater {
    [[ "$#" -ne 2 ]] && { return 2; }
    [[ "$1" -ge "$2" ]]
}
```

```bash
# Checks if a given path is an executable file
# 0: Is executable
# 1: Not executable
# 2: Invalid number of arguments
function is_executable {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -x "$1" ]]
}
```

```bash
# Checks if a given path is a regular file
# 0: Is a file
# 1: Not a file
# 2: Invalid number of arguments
function is_file {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -f "$1" ]]
}
```

```bash
# Test if a function() is available
# Return codes
# 0: Available
# 1: Unvailable
# 2: Too many/few arguments
function is_function {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$(declare -F "$1" &>/dev/null; print_int "$?")" -eq 0 ]]
}
```

```bash
# Checks if the first given digit is greater than the second digit
# Return codes
# 0: Is greater
# 1: Not greater
# 2: Invalid number of arguments
function is_greater {
    [[ "$#" -ne 2 ]] && { return 2; }
    [[ "$1" -gt "$2" ]]
}
```

```bash
# Checks if the first given digit is less than the second digit
# Return codes
# 0: Is less
# 1: Not less
# 2: Invalid number of arguments
function is_less {
    [[ "$#" -ne 2 ]] && { return 2; }
    [[ "$1" -lt "$2" ]]
}
```

```bash
# Checks if 2 given String variables match
# Return codes
# 0: Is a match
# 1: Not a match
# 2: Invalid number of arguments
function is_match {
    [[ "$#" -ne 2 ]] && { return 2; }
    [[ "$1" == "$2" ]]
}
```

```bash
# Checks if a given user is a member of a given group
# Return codes
# 1: Not a user
# 2: Invalid number of arguments
function is_member {
    [[ "$#" -ne 2 ]] && { return 2; }
    ! is_user "$1"   && { return 1; }
    [[ "$(id --groups --name "$1")" == *"$2"* ]]
    
}
```

```bash
# Checks if a given path to a file exists
# Return codes
# 0: Path exist
# 1: No such path
# 2: Invalid number of arguments
function is_path {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -e "$1" ]]
}
```

```bash
# Checks if given path is a named pipe
# Return codes
# 0: Is a named pipe
# 1: Not a named pipe
# 2: Invalid number of arguments
function is_pipe {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -p "$1" ]]
}
```

```bash
# Checks if a given variable is a positive integer
function is_positive_int {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$1" -gt 0 ]]
}
```

```bash
# Checks if a given path is a readable file
# 0: Is readable
# 1: Not readable
# 2: Invalid number of arguments
function is_readable {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -r "$1" ]]
}
```

```bash
# Checks if a given variable has been set and is a name reference
# Return codes
# 0: Is set name reference
# 1: Not set name reference
# 2: Invalid number of arguments
function is_reference {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -R "$1" ]]
}
```

```bash
# Check if user ID executing script is 0 or not
# Return codes
# 0: Is root
# 1: Not root
function is_root {
    [[ "$EUID" -eq 0 ]]
}
```

```bash
# Checks if a given variable has been set and assigned a value.
# Return codes
# 0: Is set
# 1: Not set 
# 2: Invalid number of arguments
function is_set {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -v "$1" ]]
}
```

```bash
# Checks if a given path is a socket
# Return codes
# 0: Is a socket
# 1: Not a socket
# 2: Invalid number of arguments
function is_socket {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -S "$1" ]]
}
```

```bash
# Checks what type a given variable is of:
# alias, keyword, function, builtin, file or ''
# Return codes
# 1: Alias
# 2: Builtin
# 3: File
# 4: Function
# 5: Keyword
# 6: Unknown
# 7: Invalid number of arguments
function is_type {
    [[ "$#" -ne 1 ]] && { return 7; }
    case "$(type -t "$1")" in
           'alias') { return 1; } ;;
         'builtin') { return 2; } ;;
            'file') { return 3; } ;;
        'function') { return 4; } ;;
         'keyword') { return 5; } ;;
                 *) { return 6; } ;;
    esac
}
```

```bash
# Checks if a user exists
# Return codes
# 0: Is a user
# 1: Not a user
# 2: Invalid number of arguments
function is_user {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$(id --user "$1" &>/dev/null; print_int "$?")" -eq 0 ]]
}
```

```bash
# Checks if a given path is a writable file
# 0: Is writable
# 1: Not writable
# 2: Invalid number of arguments
function is_writable {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -w "$1" ]]
}
```

```bash
# Checks if a given String is zero
# Return codes
# 0: Is zero
# 1: Not zero
# 2: Invalid number of arguments
function is_zero {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -z "$1" ]]
}
```

```bash
# Checks if 2 given digits are not equal
# Return codes
# 0: Not equal
# 1: Is equal
# 2: Invalid number of arguments
function not_equal {
    [[ "$#" -ne 2 ]] && { return 2; }
    [[ "$1" -ne "$2" ]]
}
```

```bash
# Checks if 2 given String variables do not match
# Return codes
# 0: Not a match
# 1: Is a match
# 2: Invalid number of arguments
function not_match {
    [[ "$#" -ne 2 ]] && { return 2; }
    [[ "$1" != "$2" ]]
}
```

```bash
# Checks if a given String is not zero
# Return codes
# 0: Not zero
# 1: Is zero
# 2: Invalid number of arguments
function not_zero {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ -n "$1" ]]
}
```

```bash
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
```

```bash
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
```

```bash
# Checks if a package is already installed on the system with dpkg
# Return status codes
# 0: Is installed
# 1: Not installed
# 2: Invalid number of arguments
function has_pkg {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$(dpkg-query --status "$1" &>/dev/null; print_int "$?")" -eq 0 ]]
}
```

```bash
# Checks if a package exists in the cached apt list
# Return status codes
# 0: Is available in apt
# 1: Not available in apt
# 2: Invalid number of arguments
function has_apt_package {
    [[ "$#" -ne 1 ]] && { return 2; }
    [[ "$(apt-cache show "$1" &>/dev/null; print_int "$?")" -eq 0 ]]
}
```

```bash
# Checks if a package exists on the system
# Return status codes
# 0: Package is installed
# 1: Package is not installed but is available in apt
# 2: Package is not installed and is not available in apt
# 3: Missing package argument to check
function check_package {
    [[ "$#" -ne 1 ]] && { log 2 "Invalid number of arguments: $#/1"; return 3; }
    has_pkg "$1" && { log -1 "Installed: $1"; return 0; }
    has_apt_package "$1" && { log -1 "Install available: $1"; return 1; }
    log -1 "Not found: $1"
    return 2
}
```

---

### Installation

```bash
# Update apt list and packages
# Return codes
# 0: Update APT is done
# 1: Coudn't update apt list
# 2: Invalid number of arguments
function update_apt {
    [[ "$#" -ne 0 ]] && {
        ( log 2 "Invalid number of arguments: $#/0" )
        return 2
    }
    local -r OPTIONS=(
        --quiet
        --assume-yes
        --no-show-upgraded
        --auto-remove=true
        --no-install-recommends
    )
    local -r SUDO_UPDATE=(sudo apt-get "${OPTIONS[@]}" update)
    local -r ROOT_UPDATE=(apt-get "${OPTIONS[@]}" update)
    if [[ "$EUID" -eq 0 ]]; then
        ( log -1 "Updating apt lists" )
        if "${ROOT_UPDATE[@]}" &>/dev/null; then
            ( log 0 "Apt list updated" )
        else
            ( log 2 "Couldn't update apt lists" )
            return 1
        fi
    else
        ( log -1 "Updating apt lists" )
        if "${SUDO_UPDATE[@]}" &>/dev/null; then
            ( log 0 "Apt list updated" )
        else
            ( log 2 "Couldn't update apt lists" )
            return 1
        fi
    fi
}
```

```bash
# Install package(s) using the package manager and pre-configured options
# Return codes
# 0: Installation complete
# 1: Error during installation
# 2: Missing package argument
function install_package {
    [[ "$#" -eq 0 ]] && { log 2 "Invalid number of arguments: $#/1+ [ PKG(s) ]"; return 2; }
    local -r OPTIONS=(
        --quiet
        --assume-yes
        --no-show-upgraded
        --auto-remove=true
        --no-install-recommends
    )
    local -r SUDO_INSTALL=(sudo apt-get "${OPTIONS[@]}" install)
    local -r ROOT_INSTALL=(apt-get "${OPTIONS[@]}" install)
    if [[ "$EUID" -eq 0 ]]; then
        ( log -1 "Installing: $*" )
        if DEBIAN_FRONTEND=noninteractive "${ROOT_INSTALL[@]}" "$@"; then
            ( log 0 "Installation complete" )
            return 0
        else
            ( log 2 "Something went wrong during installation" )
            return 1
        fi
    else
        log -1 "Installing: $*"
        if DEBIAN_FRONTEND=noninteractive "${SUDO_INSTALL[@]}" "$@"; then
            ( log 0 "Installation complete" )
            return 0
        else
            ( log 2 "Something went wrong during installation" )
            return 1
        fi
    fi
}
```

---

### Git

```bash
# Updates a Git repository in the current working directory
# and signs the commit before pushing with a message
# Return codes
# 0: Success
# 1: Missing argument(s): Commit message
# 2: Missing .git directory in current directory
function Git {
    if [[ "$#" -lt 1 ]]; then
        ( log 2 "No commit message provided" )
        return 1
    elif [[ ! -e "$PWD"/.git ]]; then
        ( log 2 "No .git directory found in current directory" )
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
            ( git add "$PWD" )
            ( git commit "${GIT_COMMIT_ARGS[@]}" )
            ( git push )
        )
        return 0
    fi
}
```

Some of the more simpler and day-to-day actions in functions

```bash
# Signs a commit with a GPG key and then pushes to the remote repository
function git_commit {
    if [[ "$#" -lt 1 ]]; then
        ( log 2 "No commit message provided" )
        return 1
    else
        local -r GPG_KEY_ID="E2AC71651803A7F7"
        (
            local -r GIT_COMMIT_ARGS=(
                --signoff
                --gpg-sign="$GPG_KEY_ID"
                --message="࿓❯ $*"
            )
            ( git commit "${GIT_COMMIT_ARGS[@]}" )
        )
    fi
}
```

```bash
# Initiates a repository in the current working directory
# Copies my license, readme & .gitignore templates over to the directory
# Adds them to the git history & commits them with a message
function initiate_git {
    (
        ( git_init )
        (
            [[ -f "$HOME"/Templates/Licenses/2023/MIT ]] && {
                cp -n "$HOME"/Templates/Licenses/2023/MIT "$PWD"/LICENSE
            }
            [[ -f "$HOME"/Templates/Text/README.md ]] && {
                cp -n "$HOME"/Templates/Text/README.md "$PWD"/README.md
            }
            [[ -f "$HOME"/Templates/Code/Git/.gitignore ]] && {
                cp -n "$HOME"/Templates/Code/Git/.gitignore "$PWD"/.gitignore
            }
        )
        ( git_add )
        ( git_commit "First commit" )
    )
}
```

```bash
# Initiates the current working directory as a git repository
# Return codes
# 1: Missing command: git
# 2: Git repository exists in the current working directory
function git_init {
    ! has_cmd 'git' && { return 1; }
    [[ -e "$PWD"/.git ]] && {
        ( log 1 "Git repository exists in the current working directory" )
        return 2
    }
    ( git init "$PWD" )
}
```

```bash
# Adds any changed files
# Return codes
# 1: Missing command: git
# 2: No git repository in the current working directory
function git_add {
    ! has_cmd 'git' && { return 1; }
    [[ ! -e "$PWD"/.git ]] && { return 2; }
    ( git add "$PWD" )
}
```

```bash
# Checks the status of a given git repository path
# Return codes
# 1: No git repository in the given path
# 2: Failed to change directory to the given path
function git_status {
    [[ ! -e "$1/.git" && "$1" != *".git"* ]] && { return 1; }
    ( git --git-dir "$1" status --short --porcelain )
}
```

```bash
# Cleans a Git repository
# Return codes
# 1: Missing command: git
# 2: Not a Git repository in the current working directory
# 3: Invalid number of arguments
function git_clean {
    ! has_cmd 'git' && { return 1; }
    [[ ! -e "$PWD/.git" ]] && { return 2; }
    [[ "$#" -ne 0 ]] && { return 3; }
    ( git gc )
}
```

```bash
# Pushes to a remote repository
# Return codes
# 1: Missing command: git
# 2: No git repository in the current working directory
function git_push {
    ! has_cmd 'git' && { return 1; }
    [[ ! -e "$PWD"/.git ]] && { return 2; }
    ( git push )
}
```

```bash
# Adds a remote repository to the git repository in the current working directory
# Return codes
# 1: Missing command: git
# 2: No git repository in the current working directory
# 3: Invalid number of arguments
function git_remote_add {
    ! has_cmd 'git' && { return 1; }
    [[ ! -e "$PWD"/.git ]] && { return 2; }
    [[ "$#" -ne 2 ]] && { return 3; }
    ( git remote add -f "$1" "$2" )
}
```

***Git Subtree***

```bash
# $1: Path
# $2: Repository
# $3: Branch
function subtree_add {
    ! has_cmd 'git' && { return 1; }
    [[ ! -e "$PWD"/.git ]] && { return 2; }
    if [[ "$#" -eq 3 ]]
    then
        ( git subtree add --prefix="$1" "$2" "$3" )
    else
        return 3
    fi
}
```

```bash
# $1: Path
# $2: Repository
# $3: Branch
function subtree_add_squash {
    ! has_cmd 'git' && { return 1; }
    [[ ! -e "$PWD"/.git ]] && { return 2; }
    if [[ "$#" -eq 3 ]]
    then
        ( git subtree add --prefix="$1" "$2" "$3" --squash )
    else
        return 3
    fi
}
```

```bash
# $1: Path to directory for subtree
# $2: Branch
# $3: Merge message
function subtree_merge {
    ! has_cmd 'git' && { return 1; }
    [[ ! -e "$PWD"/.git ]] && { return 2; }
    if [[ "$#" -eq 2 ]]
    then
        ( git subtree merge --prefix="$1" "$2" )
    elif [[ "$#" -gt 2 ]]
    then
        ( git subtree merge --prefix="$1" "$2" --message="࿓❯ ${*:3}" )
    else
        return 3
    fi
}
```

```bash
# $1: Path
# $2: Repository
# $3: Branch
# $4: Merge message
function subtree_pull {
    ! has_cmd 'git' && { return 1; }
    [[ ! -e "$PWD"/.git ]] && { return 2; }
    if [[ "$#" -eq 3 ]]
    then
        ( git subtree pull --prefix="$1" "$2" "$3" )
    elif [[ "$#" -gt 3 ]]
    then
        ( git subtree pull --prefix="$1" "$2" "$3" --message="࿓❯ ${*:4}" )
    else
        return 3
    fi
}
```

```bash
# $1: Path
# $2: Repository
# $3: Branch
# $4: Merge message
function subtree_pull_squash {
    ! has_cmd 'git' && { return 1; }
    [[ ! -e "$PWD"/.git ]] && { return 2; }
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
        return 3
    fi
}
```

```bash
# $1: Path
# $2: Repository
function subtree_split {
    ! has_cmd 'git' && { return 1; }
    [[ ! -e "$PWD"/.git ]] && { return 2; }
    ( git subtree split --prefix="$1" "$2" )
}
```

***Subtree - GitHub***

```bash
# $1: GitHub username
# $2: Prefix to local directory || Repository
# $3: Branch || Repository
# $4: Branch
function github_subtree_add {
    ! has_cmd 'git' && { return 1; }
    [[ ! -e "$PWD"/.git ]] && { return 2; }
    if [[ "$#" -eq 3 ]]
    then
        ( git subtree add --prefix="$2" git@github.com:"$1"/"$2" "$3" )
    elif [[ "$#" -eq 4 ]]
    then
        ( git subtree add --prefix="$2" git@github.com:"$1"/"$3" "$4" )
    else
        return 3
    fi
}
```

```bash
function github_subtree_pull {
    ! has_cmd 'git' && { return 1; }
    [[ ! -e "$PWD"/.git ]] && { return 2; }
    if [[ "$#" -eq 3 ]]
    then
        ( git subtree pull --prefix="$2" git@github.com:"$1"/"$2" "$3" )
    elif [[ "$#" -eq 4 ]]
    then
        ( git subtree pull --prefix="$2" git@github.com:"$1"/"$3" "$4" )
    elif [[ "$#" -gt 4 ]]
    then
        (
            git subtree pull \
                --prefix="$2" git@github.com:"$1"/"$3" "$4" \
                --message="࿓❯ ${*:4}"
        )
    else
        return 3
    fi
}
```

```bash
function github_subtree_pull_squash {
    ! has_cmd 'git' && { return 1; }
    [[ ! -e "$PWD"/.git ]] && { return 2; }
    if [[ "$#" -eq 3 ]]
    then
        ( git subtree pull --prefix="$2" git@github.com:"$1"/"$2" "$3" --squash )
    elif [[ "$#" -eq 4 ]]
    then
        ( git subtree pull --prefix="$2" git@github.com:"$1"/"$3" "$4" --squash )
    elif [[ "$#" -gt 4 ]]
    then
        (
            git subtree pull \
                --squash \
                --prefix="$2" git@github.com:"$1"/"$3" "$4" \
                --message="࿓❯ ${*:5}"
        )
    else
        return 3
    fi
}
```

```bash
function github_subtree_push {
    ! has_cmd 'git' && { return 1; }
    [[ ! -e "$PWD"/.git ]] && { return 2; }
    if [[ "$#" -eq 2 ]]
    then
        ( git subtree push --prefix="$2" git@github.com:"$1"/"$2" "$3" )
    elif [[ "$#" -eq 4 ]]
    then
        ( git subtree push --prefix="$2" git@github.com:"$1"/"$3" "$4" )
    
    else
        return 3
    fi
}
```

```bash
function github_remote_add {
    ! has_cmd 'git' && { return 1; }
    [[ ! -e "$PWD"/.git ]] && { return 2; }
    ( git remote add -f "$1" git@github.com:"$2"/"$1".git )
}
```

---

### Utility

***Colour*** 

```bash
# Displays 8 × 16-bit ANSI bold colours and a blinking effect
function colour {
    local -r Z='\e[0m' \
               COLOUR=('\e[1;37m' '\e[1;36m' '\e[1;35m' '\e[1;34m' '\e[1;33m' '\e[1;32m' '\e[1;31m' '\e[1;30m' '\e[5m' '\e[0m') \
               NAME=("WHITE" "CYAN" "PURPLE" "BLUE" "YELLOW" "GREEN" "RED" "BLACK" "BLINK" "RESET")
    local -r LENGTH="${#NAME[@]}"
    for (( C = 0; C < "$LENGTH"; C++ ))
    do printf "${COLOUR[$C]}%s${Z} \t%s\n" "${NAME[$C]}" "${COLOUR[$C]}"
    done
}
```

***Sorting***

```bash
# Sorts the words provided as arguments
function sorting {
    [[ "$#" -eq 0 ]] && { log 2 "Invalid number of arguments: $#/0"; return 1; }
    ( printf '%s\n' "$@" | sort --dictionary-order )
}
```

***Environment***

```bash
# Shows the current environment
function show_environment {
    [[ "$#" -ne 0 ]] && { log 2 "Invalid number of arguments: $#/0"; return 2; }
    if has_cmd 'env'
    then env
    elif has_cmd 'printenv'
    then printenv
    elif has_cmd 'sed'
    then
        (
            set | sed -n '1,/ () / {
                / () /n
                p
            }'
        )
    else { ( log 2 "Missing commands" ); return 1; }
    fi
}
```

***System information***

```bash
# Get system information
# Return codes
# 1: Missing command: inxi
# 2: Too many arguments provided
function system_info {
    [[ "$#" -ne 0 ]] && { ( log 2 "Invalid number of arguments: $#/0" ); return 2; }
    ! has_cmd 'inxi' && { ( log 2 "Missing command: inxi" ); return 1; }
    ( inxi -Fxzr )
}
```

***Record command***

```bash
# Records the output of a command to a file.
# Return codes
# 1: Missing argument: Command to record output of
function rec_cmd {
    [[ "$#" -eq 1 ]] && { ( log 2 "Invalid number of commands" ); return 1; }
    local -r LOGFILE='log.txt'
    if [[ -f "$LOGFILE" ]]
    then
        (
            ( log -1 "$LOGFILE exists, appending to existing file" )
            ( echo "Appending new output from $1" | tee -a "$LOGFILE" )
            ( bash -c "$1" | tee -a "$LOGFILE" )
        )
    else
        (
            ( touch "$LOGFILE"; bash -c "$1" | tee -a "$LOGFILE" )
            ( log 0 "Command output recorded to $LOGFILE" )
        )
    fi
}
```

***Processes***

```bash
# Checks for a running process
# Return codes
# 0: Running process exists
# 1: No such running process
# 2: Missing argument: process
# 3: Missing command: pgrep
function find_process {
    [[ "$#" -ne 1 ]]  && { ( log 2 "Invalid number of arguments: $#/1" ); return 2; }
    ! has_cmd 'pgrep' && { ( log 2 "Command not found: pgrep" ); return 3; }
    [[ "$(pgrep "$1" &>/dev/null; print_int "$?")" -eq 0 ]]
}
```

```bash
# Checks for a running process
# Return codes
# 0: Running process exists
# 1: No such running process
# 2: Missing argument: process
# 3: Missing command: pgrep
function find_full_process {
    [[ "$#" -ne 1 ]]  && { ( log 2 "Invalid number of arguments: $#/1" ); return 2; }
    ! has_cmd 'pgrep' && { ( log 2 "Command not found: pgrep" ); return 3; }
    [[ "$(pgrep --full "$1" &>/dev/null; print_int "$?")" -eq 0 ]]
}
```

```bash
# Gets processes
# Return codes
# 1: Missing command: ps
function get_processes {
    ! has_cmd 'ps' && { ( log 2 "Missing command: ps" ); return 1; }
    ( ps -A )
}
```

```bash
# Checks running processes
function get_running_processes {
    ! has_cmd 'jobs' && { ( log 2 "Missing command: jobs" ); return 1; }
    ( jobs -r )
}
```

***Time***

```bash
# Gets the current time in UNIX & regular time (human-readable format)
# Return codes
# 1: Error: Too many arguments provided
function get_time {
    [[ "$#" -gt 0 ]] && { ( log 2 "Invalid number of arguments: $#/0" ); return 1; }
    (
        printf '%s\n' "Regular: $(date -d @"$(date +%s)")" \
                  "Unix: $(date +%s)" \
                  "Date by locale: $(date +%x)" \
                  "Time by locale: $(date +%X)"
    )
}
```

```bash
# Converts UNIX timestamps to regular human-readable timestamp
# Return codes
# 1: Missing argument: UNIX Timestamp
function unix_to_regular_time {
    [[ "$#" -ne 1 ]] && { ( log 2 "Invalid number of arguments: $#/1" ); return 1; }
    ( println "$(date -d @"$1")" )
}
```

```bash
# Gets the time by locale's definition
# Return codes
# 1: Invalid number of arguments
function get_locale_time {
    [[ "$#" -gt 0 ]] && { ( log 2 "Invalid number of arguments: $#/0" ); return 1; }
    ( date +%X )
}
```

```bash
# Gets the date by locale's definition
# Return codes
# 1: Invalid number of arguments
function get_locale_date {
    [[ "$#" -gt 0 ]] && { ( log 2 "Invalid number of arguments: $#/0" ); return 1; }
    ( date +%x )
}
```

***Files, Search, Replace, Insert & Delete***

```bash
# Uses $(<) to read a file to STDOUT, supposedly faster than cat.
# Return codes
# 0: Success
# 1: Invalid number of arguments
# 2: Not a file: $1
function read_file {
    [[ "$#" -ne 1 ]] && { ( log 2 "Invalid number of arguments: $#/1"; return 1; }
    [[ ! -f "$1" ]]  && { ( log 2 "Not a file: $1"; return 2; }
    ( println "$(<"$1")" )
}
```

```bash
# Shows the files in the current working directory's directory & all its sub-directories excluding hidden directories.
# Return codes
# 1: Error: Arguments provided when none required
function show_directory_files {
    [[ "$#" -gt 0 ]] && { ( log 2 "Invalid number of arguments: $#/0" ); return 1; }
    local -r ARGS=(--recursive --files-with-matches --exclude-dir=".*")
    ( grep "${ARGS[@]}" . )
}
```

```bash
# Counts the number of files recursively from current working directory
# Return codes
# 1: Error: Arguments provided when none required
function count_directory_files {
    [[ "$#" -ne 0 ]] && { ( log 2 "Invalid number of arguments: $#/0" ); return 1; }
    local -r ARGS=(--recursive --files-with-matches --exclude-dir=".*")
    # shellcheck disable=SC2126
    ( grep "${ARGS[@]}" . | wc --lines )
}
```

```bash
# Use sed to count the lines of a file
# Return codes
# 1: Invalid number of arguments
# 2: No such file: $1
function count_lines {
    [[ "$#" -ne 1 ]] && { return 1; }
    [[ ! -f "$1" ]]  && { return 2; }
    ( sed -n '$=' "$1" )
}
```

```bash
# Gets the name at the end of a path string after stripping the path
# Return codes
# 1: Invalid number of arguments
# 2: No such path exists
function get_path_name {
    [[ "$#" -ne 1 ]] && { ( log 2 "Invalid number of arguments: $#/1" ); return 1; }
    [[ ! -e "$1" ]]  && { ( log 2 "No such path: $1" ); return 2; }
    ( println "${1##*/}" )
}
```

```bash
# Search for a pattern recursively in files of current directory and its sub-directories
# Return codes
# 1: Invalid number of arguments
# 2: Missing command: grep
function search {
    [[ "$#" -eq 0 ]] && { ( log 2 "Invalid number of arguments: $#/1+" ); return 1; }
    ! has_cmd 'grep' && { ( log 2 "Missing command: grep" ); return 2; }
    local -r ARGS=(--recursive --exclude-dir=".*")
    ( grep "${ARGS[@]}" "$*" 2>/dev/null )
}
```

```bash
# Search for pattern in a specific file
# Return codes
# 1: Missing command: grep
# 2: Invalid number of arguments
# 3: Not a file: $2
function find_text {
    ! has_cmd 'grep' && { ( log 2 "Missing command: grep" ); return 1; }
    [[ "$#" -ne 2 ]] && { ( log 2 "Invalid number of arguments: $#/2" ); return 2; }
    [[ ! -f "$2" ]]  && { ( log 2 "Not a file: $2" ); return 1; }
    ( grep "$1" "$2" )
}
```

```bash
# Search for pattern in a specific file
# Return codes
# 1: Missing command: sed
# 2: Invalid number of arguments
# 3: Not a file
function find_pattern {
    ! has_cmd 'sed'  && { ( log 2 "Missing command: sed" ); return 1; }
    [[ "$#" -ne 2 ]] && { ( log 2 "Invalid number of arguments: $#/2" ); return 2; }
    [[ ! -f "$2" ]]  && { ( log 2 "Not a file: $2" ); return 2; }
    ( sed -n '/'"$1"'/p' "$2" )
}
```

```bash
# Search for files with pattern(s) recursively
# Return codes
# 1: Missing command: grep
# 2: Invalid number of arguments
function get_files_with_text {
    ! has_cmd 'grep' && { ( log 2 "Missing command: grep" ); return 1; }
    [[ "$#" -eq 0 ]] && { ( log 2 "Invalid number of arguments: $#/1" ); return 2; }
    local -r ARGS=(--recursive --files-with-matches --exclude-dir=".*")
    ( grep "${ARGS[@]}" "$*" 2>/dev/null )
}
```

```bash
# Replaces a text pattern in a file with new text
# Return codes
# 1: Missing command: sed
# 2: Invalid number of arguments
# 3: Not a file
function replace_text {
    ! has_cmd 'sed'  && { ( log 2 "Missing command: sed" ); return 1; }
    [[ "$#" -ne 3 ]] && { ( log 2 "Invalid number of arguments: $#/3" ); return 2; }
    [[ ! -f "$3" ]]  && { ( log 2 "Not a file: $3" ); return 3; }
    ( sed -i "s|$1|$2|g" "$3" )
}
```

```bash
# Replaces given text pattern with a new one in all files recursively from current working directory
# Return codes
# 1: Missing command: sed
# 2: Invalid number of arguments
function replace_all_text {
    ! has_cmd 'sed'  && { ( log 2 "Missing command: sed" ); return 1; }
    [[ "$#" -ne 2 ]] && { ( log 2 "Invalid number of arguments: $#/2" ); return 2; }
    (
        for F in $(get_files_with_text "$1")
        do ( sed -i "s|$1|$2|g" "$F" )
        done
    )
}
```

```bash
# Makes all matching text patterns into camel case String in a file
# Return codes
# 1: Missing command: sed
# 2: Invalid number of arguments
# 3: Not a file: $2
function make_camel_case {
    ! has_cmd 'sed'  && { ( log 2 "Missing command: sed" ); return 1; }
    [[ "$#" -ne 2 ]] && { ( log 2 "Invalid number of arguments: $#/2" ); return 2; }
    [[ ! -f "$2" ]]  && { ( log 2 "Not a file: $2" ); return 3; }
    ( sed -i "s|${1}|${1,}|g" "${2}" )
}
```

```bash
# Makes all matching text patterns into camel case String recursively in all files from current working directory
# Return codes
# 1: Missing command: sed
# 2: Invalid number of arguments
function make_all_camel_case {
    ! has_cmd 'sed'  && { ( log 2 "Missing command: sed" ); return 1; }
    [[ "$#" -ne 1 ]] && { ( log 2 "Invalid number of arguments: $#/1" ); return 2; }
    (
        for F in $(get_files_with_text "$1")
        do ( sed -i "s|$1|${1,}|g" "$F" )
        done
    )
}
```

```bash
# Appends text after line number
# Return codes
# 1: Missing command: sed
# 2: Invalid number of arguments
# 3: Not a file
# 4: Not a positive integer digit
function append_at_line {
    ! has_cmd 'sed'  && { ( log 2 "Missing command: sed" ); return 1; }
    [[ "$#" -ne 3 ]] && { ( log 2 "Invalid number of arguments: $#/3" ); return 2; }
    [[ ! -f "$3" ]]  && { ( log 2 "Not a file: $3" ); return 3; }
    [[ "$1" -lt 0 ]] && { ( log 2 "Not a positive integer digit: $1" ); return 4; }
    ( sed -i ''"$1"'a '"$2"'' "$3" )
}
```

```bash
# Appends text after matching text pattern
# Return codes
# 1: Missing command: sed
# 2: Invalid number of arguments
# 3: Not a file: $3
function append_at_pattern {
    ! has_cmd 'sed'  && { ( log 2 "Missing command: sed" ); return 1; }
    [[ "$#" -ne 3 ]] && { ( log 2 "Invalid number of arguments: $#/3" ); return 2; }
    [[ ! -f "$3" ]]  && { ( log 2 "Not a file: $3" ); return 3; }
    ( sed -i '/'"$1"'/a '"$2"'' "$3" )
}
```

```bash
# Appends text after the last line
# Return codes
# 1: Missing command: sed
# 2: Invalid number of arguments
# 3: Not a file
function append_at_last_line {
    ! has_cmd 'sed'  && { ( log 2 "Missing command: sed" ); return 1; }
    [[ "$#" -ne 2 ]] && { ( log 2 "Invalid number of arguments: $#/2" ); return 2; }
    [[ ! -f "$2" ]]  && { ( log 2 "Not a file: $2" ); return 3; }
    ( sed -i '$a '"$1"'' "$2" )
}
```

```bash
# Insert text before line number
# Return codes
# 1: Missing command: sed
# 2: Invalid number of arguments
# 3: Not a positive integer digit
# 4: Not a file
function insert_at_line {
    ! has_cmd 'sed'  && { ( log 2 "Missing command: sed" ); return 1; }
    [[ "$#" -ne 3 ]] && { ( log 2 "Invalid number of arguments: $#/3" ); return 2; }
    [[ "$1" -lt 0 ]] && { ( log 2 "Not a positive integer digit: $1" ); return 3; }
    [[ ! -f "$3" ]]  && { ( log 2 "Not a file: $3" ); return 4; }
    ( sed -i ''"$1"'i '"$2"'' "$3" )
}
```

```bash
# Insert text before matching text pattern
# Return codes
# 1: Missing command: sed
# 2: Invalid number of arguments
# 3: Not a file
function insert_at_pattern {
    ! has_cmd 'sed'  && { ( log 2 "Missing command: sed" ); return 3; }
    [[ "$#" -ne 3 ]] && { ( log 2 "Invalid number of arguments: $#/3" ); return 2; }
    [[ ! -f "$3" ]]  && { ( log 2 "Not a file: $3" ); return 1; }
    ( sed -i '/'"$1"'/i '"$2"'' "$3" )
}
```

```bash
# Inserts text before the last line
# Return codes
# 1: Missing command: sed
# 2: Invalid number of arguments
# 3: Not a file
function insert_at_last_line {
    ! has_cmd 'sed'  && { ( log 2 "Missing command: sed" ); return 1; }
    [[ "$#" -ne 2 ]] && { ( log 2 "Invalid number of arguments: $#/2" ); return 2; }
    [[ ! -f "$2" ]]  && { ( log 2 "Not a file: $2" ); return 3; }
    ( sed -i '$i '"$1"'' "$2" )
}
```

```bash
# Deletes a specified line in a file
# Return codes
# 1: Missing command: sed
# 2: Invalid number of arguments
# 3: Not a positive integer digit
# 4: Not a file
function delete_line {
    ! has_cmd 'sed'  && { ( log 2 "Missing command: sed" ); return 1; }
    [[ "$#" -ne 2 ]] && { ( log 2 "Invalid number of arguments: $#/2" ); return 2; }
    [[ "$1" -lt 0 ]] && { ( log 2 "Not a positive integer digit: $1" ); return 3; }
    [[ ! -f "$2" ]]  && { ( log 2 "Not a file: $2" ); return 4; }
    ( sed -i ''"$1"'d' "$2" )
}
```

```bash
# Deletes a specified line in a file
# Return codes
# 1: Missing command: sed
# 2: Invalid number of arguments
# 3: Not a file
function delete_last_line {
    ! has_cmd 'sed'  && { ( log 2 "Missing command: sed" ); return 1; }
    [[ "$#" -ne 1 ]] && { ( log 2 "Invalid number of arguments: $#/1" ); return 2; }
    [[ ! -f "$2" ]]  && { ( log 2 "Not a file: $2" ); return 3; }
    ( sed -i '$d' "$2" )
}
```

```bash
# Deletes a specified range in a file
# Return codes
# 1: Missing command: sed
# 2: Invalid number of arguments
# 3: Not a positive integer digit range
# 4: Not a file
function delete_range {
    ! has_cmd 'sed'  && { ( log 2 "Missing command: sed" ); return 1; }
    [[ "$#" -ne 3 ]] && { ( log 2 "Invalid number of arguments: $#/3" ); return 2; }
    [[ ! -f "$3" ]]  && { ( log 2 "Not a file: $3" ); return 3; }
    [[ "$1" -lt 0 || "$2" -lt 0 ]] && { ( log 2 "Not a positive integer digit range: $1 & $2" ); return 4; }
    ( sed -i ''"$1"','"$2"'d' "$3" )
}
```

```bash
function replace_in {
    [[ "$#" -ne 2 ]] && { return 1; }
    [[ -p /dev/stdin ]] && {
        ( sed 's|'"$1"'|'"$2"'|g' /dev/stdin )
    }
}
```

***Print a function***

```bash
# Prints a function() to STDOUT
# Return codes
# 1: Invalid number of arguments
function show_function {
    [[ "$#" -ne 1 ]] && { return 1; }
    ( local -f "$1" )
}
```

***Upper/Lower case***

```bash
# Converts a String to uppercase
# Return codes
# 1: Missing argument: String
function upper_case {
    [[ "$#" -eq 0 ]] && { ( log 2 "Invalid number of arguments: $#/1+" ); return 1; }
    ( println "${*^^}" )
}
```

```bash
# Converts the first letter of a String to upper case
# Return codes
# 1: Missing argument: String
function upper_first_letter {
    [[ "$#" -eq 0 ]] && { log 2 "Requires: $#/1+ [ String(s) ]"; return 1; }
    println "${*^}"
}
```

```bash
# Converts a String to lower case
# Return codes
# 1: Missing argument: String
function lower_case {
    [[ "$#" -eq 0 ]] && { log 2 "Requires: $#/1+ [ String(s) ]"; return 1; }
    println "${*,,}"
}
```

```bash
# Converts a String to lower case
# Return codes
# 1: Missing argument: String
function lower_first_letter {
    [[ "$#" -eq 0 ]] && { log 2 "Requires: $#/1+ [ String(s) ]"; return 1; }
    println "${*,}"
}
```

***Length or number of variables***

```bash
# Returns the length or number of variables passed to function
# Return codes
# 1: Invalid nr of arguments
function get_length {
    [[ "$#" -lt 1 ]] && { log 2 "[ $#/1 min ]"; return 1; }
    local -r ARR=("$@")
    printf '%d\n' "${#ARR[@]}"
}
```

***Password generation***

```bash
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
```

```bash
# Generates a password using OpenSSL, default length is 36.
# Return codes
# 1: Missing command: openssl
function gen_ssl_passwd {
    ! has_cmd 'openssl' && { log 2 "OpenSSL not available"; return 1; }
    openssl rand -base64 "${1:-36}"
}
```

***Encryption/Decryption***

```bash
# Encrypts a file using GPG2
function encrypt_file {
    [[ "$#" -ne 1 ]] && exit 1
    [[ ! -e "$1" && ! -f "$1" ]] && exit 2
    ! has_cmd 'gpg2' && exit 3
    gpg2 -c "$1"
}
```

```bash
# Decrypts a file using GPG2
function decrypt_file {
    [[ "$#" -ne 1 ]] && exit 1
    [[ ! -e "$1" && ! -f "$1" ]] && exit 2
    ! has_cmd 'gpg2' && exit 3
    gpg2 -d "$1"
}
```

```bash
# Encrypts a String with a password
# Return codes
# 1: Command not found: openssl
# 2: Invalid number of arguments
function crypt_string {
    [[ "$#" -ne 2 ]]    && { return 2; }
    ! has_cmd 'openssl' && { return 1; }
    printf '%s\n' "$1" | openssl enc -aes-256-cbc -md sha512 -a -pbkdf2 -iter 10000 -salt -pass pass:"$2"
}
```

```bash
# Decrypts a String with a password
# Return codes
# 1: Command not found: openssl
# 2: Invalid number of arguments
function decrypt_string {
    [[ "$#" -ne 2 ]]    && { return 2; }
    ! has_cmd 'openssl' && { return 1; }
    printf '%s\n' "$1" | openssl enc -aes-256-cbc -md sha512 -a -d -pbkdf2 -iter 10000 -salt -pass pass:"$2"
}
```

***Usergroup***

```bash
# Retrieves the members of a group
# Return codes
# 1: Missing argument: Group name
function get_group_members {
    [[ "$#" -eq 1 ]] && { log 2 "Requires: [ Group name ]"; return 1; }
    mapfile -d ',' -t GROUP_USERS < <(awk -F':' '/'"$1":'/{printf $4}' /etc/group)
    println "${GROUP_USERS[*]}"
    unset GROUP_USERS
}
```

```bash
# Retrieves the groups a user is a member of
# 0: User exists, show group membership
# 1: No such user exists
function get_user_groups {
    ! is_user "$1" && { log 2 "No such user: $1"; return 1; }
    groups "$1"
}
```

```bash
# Retrieves the group IDs a user is a member of
# 0: Show group membership
# 1: No such user exists
# 2: Invalid number of arguments
function get_user_groups_id {
    [[ "$#" -ne 1 ]] && { log 2 "[ $#/1 ] Invalid number of arguments"; return 2; }
    ! is_user "$1"   && { log 2 "No such user: $1"; return 1; }
    id --groups "$1"
}
```

---

### Network

```bash
# Test if a port is open or closed on a remote host
# Exit codes
# 1: Open
# 2: Closed
# 3: Invalid number of arguments
function test_remote_port {
    [[ "$#" -eq 2 ]] && { log 2 "[ $#/2 ] Requires: [ HOST ] [ PORT ]"; return 2; }
    if timeout 2.0 bash -c "true &>/dev/null>/dev/tcp/${1}/${2}"
    then log -1 "Open"
    else log -1 "Closed"; return 1
    fi
}
```

```bash
# Queries DNS record of a domain
# Return codes
# 1: Invalid number of arguments
# 2: Missing argument(s): Domain, Optional Domain Record
function get_dns_record {
    [[ "$#" -eq 0  || "$#" -gt 2 ]] && { log 2 "Invalid number of arguments: [ $#/1-2 ]"; return 1; }
    [[ "$#" -eq 2 ]] && { dig "$1" "$2" +short; }
    [[ "$#" -eq 1 ]] && { dig "$1" +short; }
}
```

```bash
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
```

```bash
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
```

```bash
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
```

```bash
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
```

```bash
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
```

```bash
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
```

```bash
# Gets all the local IP-addresses on the device
function get_all_local_ip {
    if has_cmd 'jq'
    then ip -j address | jq -r '.[].addr_info[].local'
    else ip a | grep 'inet' | awk '{print $2}' | sed 's|/.*||g'
    fi
}
```

```bash
# Get device IP information
# Return codes
# 1: Invalid number of arguments
function get_ip_info {
    [[ "$#" -gt 0 ]] && { log 2 "Invalid number of arguments: [ $#/0 ]"; return 1; }
    if has_cmd 'jq'
    then ip -j address | jq '.'
    else ip address
    fi
}
```

```bash
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
```

```bash
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
```

```bash
# Gets the HTML code for a URL with Bash TCP
# Reuires the host TCP server to listen on HTTP, not HTTPS, it'a a plain HTTP request
# Return codes
# 1: Arguments error, requires: Host, Port
function get_url {
    [[ "$#" -ne 2 ]] && { log 2 "[ $#/2 ] Requires: [ HOST ] [ PORT ]"; return 1; }
    exec 5<>/dev/tcp/"$1"/"$2"
    echo -e "GET / HTTP/1.1\r\nHost: ${1}\r\nConnection: close\r\n\r" >&5
    cat <&5
    
}
```

```bash
# Loops through HTML elements that are fed into the function through a pipe via STDIN
function html_next {
    local IFS='>'
    # shellcheck disable=SC2034
    read -r -d '<' TAG VALUE
}
```

---

### Crypto

```bash
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
```

```bash
# Checks and tests so the commands for the BTC functions are present
function check_btc_query_commands {
    if ! has_cmd 'curl' || ! has_cmd 'jq'
    then
        return 1
    else
        return 0
    fi
}
```

```bash
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
```

```bash
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
```

```bash
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
```

```bash
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
```

```bash
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
```

```bash
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
```

```bash
# Generate RPC authentication credentials for the Bitcoin Client
function btc_rpc_auth {
    if [[ "$#" -ne 1 ]] || ! check_btc_query_commands || ! has_cmd 'python3'
    then
        return 1
    fi
    curl -sSL "https://raw.githubusercontent.com/bitcoin/bitcoin/master/share/rpcauth/rpcauth.py" \
    | python3 - "$1"
}
```

---

### Audio

```bash
# Converts an MP4 audio file to WAV audio format
# $1: Input MP4 audio file
# $2: Output name for WAV audio file
function mp4_to_wav {
    [[ "$#" -ne 2 ]] && return 2
    [[ ! -f "$1" ]] && return 1
    ffmpeg -i "$1" -ac 2 -f wav "$2"
}
```

---

### Permissions

```bash
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
```

```bash
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
```

```bash
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
```

```bash
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
```

```bash
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
```

```bash
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
```

---

### JSON

```bash
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
```

```bash
# Checks if a given variable is a valid JSON format
function is_json {
    ! has_cmd 'jq' && return 1
    case "$#" in
        1)
            [[ "$(jq --null-input "$1" &>/dev/null; print_digit "$?")" -eq 0 ]]
        ;;
        *)
            print_err "Invalid nr of arguments: $#"
            return 2
        ;;
    esac
}
```

```bash
# Checks if a given variable is a JSON file
function is_json_file {
    ! has_cmd 'jq' && return 1
    case "$#" in
        1)
            [[ -f "$1" && "$(jq < "$1" &>/dev/null; print_digit "$?")" -eq 0 ]]
        ;;
        *)
            print_err "Invalid nr of arguments: $#"
            return 2
        ;;
    esac
}
```

```bash
# Checks if a given variable is a JSON object
function is_json_object {
    case "$#" in
        1)
            [[ "$(test_json "$1"; print_digit "$?")" -eq 0 ]]
        ;;
        *)
            print_err "Invalid nr of arguments: $#"
            return 2
        ;;
    esac
}
```

```bash
# Checks if a given variable is a JSON string
function is_json_string {
    case "$#" in
        1)
            [[ "$(test_json "$1"; print_digit "$?")" -eq 1 ]]
        ;;
        *)
            print_err "Invalid nr of arguments: $#"
            return 2
        ;;
    esac
}
```

```bash
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
            print_err "Invalid nr of arguments: $#"
            return 1
        ;;
    esac
}
```

```bash
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
            print_err "Invalid nr of arguments: $#"
            return 1
        ;;
    esac
}
```

```bash
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
            print_err "Nr of arguments are invalid: $#"
            return 3
        ;;
    esac
}
```

```bash
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
            print_err "Invalid nr of arguments: $#"
            return 3
        ;;
    esac
}
```

```bash
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
```

```bash
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
            print_err "Invalid number of arguments: $#"
            return 1
        ;;
    esac
}
```

```bash
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
```

```bash
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
```

```bash
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
```

```bash
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
```

```bash
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
```

```bash
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
```

---

### Encoding/Decoding

```bash
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
```

```bash
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
```

```bash
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
```

```bash
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
```

```bash
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
```

```bash
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
```

```bash
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
```

---

### Swedish Law

```bash
# Sends a search query for Swedish legal documents (SFS) 
function lag {
	[[ "$#" -ne 1 ]] && { return 1; }
	! has_cmd 'jq' && { return 2; }
	local SEARCH 
	SEARCH="$(url_encode "$1")"
	local -r URL="https://data.riksdagen.se/dokumentlista/?sok=${SEARCH}&doktyp=SFS&utformat=json"
	curl --silent --location "$URL" | jq '.'
}
```

```bash
# Fetches an SFS document
function sfs_dokument {
	[[ "$#" -ne 1 ]] && { return 1; }
	! has_cmd 'jq' && { return 2; }
	local -r URL="https://data.riksdagen.se/dokument/$1"
	# curl --silent --location "$URL" | jq '.'
	curl --silent --location "$URL"
}
```

---

### Dictionary

```bash
# Queries a word for the dictionary definition
function dictionary {
	[[ "$#" -ne 1 ]] && { return 1; }
	! has_cmd 'curl' || ! has_cmd 'jq' && { return 2; }
    local -r base_url="https://api.dictionaryapi.dev/api/v2/entries/en/$1"
    curl --silent --location "$base_url" | jq
}
```

---

### Docker

```bash
# Get the images names, tag & repository
# Return codes
# 1: Missing command: curl
# 2: Missing command: jq
# 3: Invalid number of arguments
function docker_GET {
    ! has_cmd 'curl' && { return 2; }
    ! has_cmd 'jq'    && { return 1; }
    curl --silent \
	     --unix-socket /var/run/docker.sock \
	     -H "Content-Type: application/json" \
	     "localhost/v1.42/${1}"
}
```

With `docker` CLI

```bash
# Get the images names, tag & repository
# Return codes
# 1: Missing command: docker
# 2: Missing command: sed
# 3: Invalid number of arguments
function get_images {
    ! has_cmd 'docker' && { return 2; }
    ! has_cmd 'sed'    && { return 1; }
    docker images | sed -n 's|/*||p' | tail -n +2
}
```

```bash
# Get the Container ID & Name of running containers
# Return codes
# 1: Command not found: docker
# 2: Command not found: sed
# 3: Invalid number of arguments
function get_containers {
    ! has_cmd 'docker' && { return 2; }
    ! has_cmd 'sed' && { return 1; }
    docker ps | sed -n 's|/*||p' | tail -n +2
}
```

```bash
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
```

```bash
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
```

```bash
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
```

```bash
# Removes the latest Docker image
function remove_latest_image {
    ! has_cmd 'docker' && { return 2; }
    ! has_cmd 'awk'    && { return 1; }
    if is_root || in_docker_group
    then docker rmi "$(docker images | awk '{print $3}' | tail -n +2 | head -1)"
    else sudo docker rmi "$(sudo docker images | awk '{print $3}' | tail -n +2 | head -1)"
    fi
}
```

---
