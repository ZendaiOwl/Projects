#!/usr/bin/env bash
# Victor-ray, S <12261439+ZendaiOwl@users.noreply.github.com>
LIBRARY='./lib.sh'

# shellcheck disable=SC1090
source "$LIBRARY"

printf '%s\n' "#!/usr/bin/env bash"
printf '%s\n' "# Victor-ray, S <12261439+ZendaiOwl@users.noreply.github.com>"

printf '%s\n' "
############################
# Bash - Utility Functions
############################"

printf '%s\n' "
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
# \e[1;5;m = Blinking Bold"
declare -f colour

printf '%s\n' "
# A log function that uses log levels for logging different outputs
# Log levels
# -2: Debug
# -1: Info
#  0: Success
#  1: Warning
#  2: Error"
declare -f log

printf '%s\n' "
# Check if user ID executing script/function is 0 or not
# Return codes
# 0: User is root
# 1: User is not root"
declare -f is_root

printf '%s\n' "
# Check if user ID executing script/function is 0 or not
# Return codes
# 0: User is root
# 1: User is not root"
declare -f has_cmd

printf '%s\n' "
# Checks if a command exists on the system
# Return status codes
# 0: Command exists on the system
# 1: Command is unavailable on the system
# 2: Missing command argument to check"
declare -f has_pkg

printf '%s\n' "
# Checks if a package exists on the system
# Return status codes
# 0: Package is installed
# 1: Package is not installed but is available in apt
# 2: Package is not installed and is not available in apt
# 3: Missing package argument to check"
declare -f installPKG

printf '%s\n' "
# install_pkgs package(s) using the package manager and pre-configured options
# Return codes
# 0: install_pkg completed
# 1: Unable to update apt list
# 2: Error during installation
# 3: Missing package argument"
declare -f findProcess

printf '%s\n' "
# Checks for a running process
# Return codes
# 0: Running process exists
# 1: No such running process
# 2: Missing argument: process
# 3: Missing command: pgrep"
declare -f findFullProcess

printf '%s\n' "
# Gets processes"
declare -f getProcesses

printf '%s\n' "
# Get all processes"
declare -f getAllProcesses

printf '%s\n' "
# Checks running processes"
declare -f getRunningProcesses

printf '%s\n' "
# Get system information
# Return codes
# 0: Success
# 1: Missing command: inxi
# 2: Too many arguments provided"
declare -f getSystemInfo

printf '%s\n' "
# Records the output of a command to a file.
# Return codes
# 0: Success
# 1: Missing argument: Command to record output of"
declare -f recordCommand

printf '%s\n' "
# Checks if an argument parameter variable is an array or not
# Return codes
# 0: Variable is an array
# 1: Variable is not an array
# 2: Missing argument: Variable to check"
declare -f is_array

printf '%s\n' "
# Gets the current time in UNIX & regular time (human-readable format)
# Return codes
# 0: Success
# 1: Error: Too many arguments provided"
declare -f getTime

printf '%s\n' "
# Converts UNIX timestamps to regular human-readable timestamp
# Return codes
# 0: Success
# 1: Missing argument: UNIX Timestamp"
declare -f unixTimeToRegular

printf '%s\n' "
# Gets the time by locale´s definition
# Return codes
# 0: Success
# 1: Error: Too many arguments"
declare -f getLocaleTime

printf '%s\n' "
# Gets the date by locale´s definition
# Return codes
# 0: Success
# 1: Error: Too many arguments"
declare -f getLocaleDate

# printf '%s\n' "
# # update_pkgs a Git repository directory and signs the commit before pushing with a message
# # Return codes
# # 0: Success
# # 1: Ḿissing argument(s): Commit message"
# declare -f updateGit

printf '%s\n' '
# Uses $(<) to read a file to STDOUT, supposedly faster than cat.
# Return codes
# 0: Success
# 1: Not a file
# 2: Error: Too many arguments
# 2: Missing argument: File'
declare -f readFile

printf '%s\n' "
# Shows the files in the current working directory´s directory & all its sub-directories excluding hidden directories.
# Return codes
# 0: Success
# 1: Error: Arguments provided when none required"
declare -f showDirFiles

printf '%s\n' "
# Counts the number of files recursively from current working directory
# Return codes
# 0: Success
# 1: Error: Arguments provided when none required"
declare -f countDirFiles

printf '%s\n' "
# Gets the name at the end of a path string after stripping the path
# Return codes
# 0: Success
# 1: No such path exists
# 2: Missing argument: Path"
declare -f getPathName

printf '%s\n' "
# Converts a String to uppercase
# Return codes
# 0: Success
# 1: Missing argument: String"
declare -f upperCase

printf '%s\n' "
# Converts the first letter of a String to upper case
# Return codes
# 0: Success
# 1: Missing argument: String"
declare -f upperCaseFirstLetter

printf '%s\n' "
# Converts a String to lower case
# Return codes
# 0: Success
# 1: Missing argument: String"
declare -f lowerCase

printf '%s\n' "
# Converts a String to lower case
# Return codes
# 0: Success
# 1: Missing argument: String"
declare -f lowerCaseFirstLetter

printf '%s\n' "
# search for a pattern recursively in files of current directory and its sub-directories
# Return codes
# 0: Success
# 1: Missing argument: String
# 2: Missing command: grep"
declare -f searchText

printf '%s\n' "
# search for pattern in a specific file
# Return codes
# 0: Success
# 1: Not a file
# 2: Missing arguments: String, File
# 3: Missing command: grep"
declare -f findTextInFile

printf '%s\n' "
# search for files with pattern(s) recursively
# Return codes
# 0: Success
# 1: Missing argument: String
# 2: Missing command: grep"
declare -f getFilesWithText

printf '%s\n' "
# Replaces a text pattern in a file with new text
# Return codes
# 0: Success
# 1: Not a file
# 2: Missing arguments: String, String, File
# 3: Missing command: sed"
declare -f replaceTextInFile

printf '%s\n' "
# Replaces given text pattern with a new one in all files recursively from current working directory
# Return codes
# 0: Success
# 1: Missing arguments: String, String
# 2: Missing command: sed"
declare -f replaceTextInAllFiles

printf '%s\n' "
# Makes all matching text patterns into camel case String in a file
# Return codes
# 0: Success
# 1: Not a file
# 2: Missing arguments: String, File
# 3: Missing command: sed"
declare -f makeCamelCaseInFile

printf '%s\n' "
# Makes all matching text patterns into camel case String recursively in all files from current working directory
# Return codes
# 0: Success
# 1: Missing argument: String
# 2: Missing command: sed"
declare -f makeCamelCaseInAllFiles

printf '%s\n' "
# Appends text after line number
# Return codes
# 0: Success
# 1: Not a positive integer digit
# 2: Not a file
# 3: Missing arguments: Integer, String, File
# 4: Missing command: sed"
declare -f appendTextAtLine

printf '%s\n' "
# Appends text after matching text pattern
# Return codes
# 0: Success
# 1: Not a file
# 2: Missing arguments: String, String, File
# 3: Missing command: sed"
declare -f appendTextAtPattern

printf '%s\n' "
# Appends text after the last line
# Return codes
# 0: Success
# 1: Not a file
# 2: Missing arguments: String, File
# 3: Missing command: sed"
declare -f appendTextAtLastLine

printf '%s\n' "
# Insert text before line number
# Return codes
# 0: Success
# 1: Not a file
# 2: Not a positive integer digit
# 3: Missing arguments: Integer, String, File
# 4: Missing command: sed"
declare -f insertTextAtLine

printf '%s\n' "
# Insert text before matching text pattern
# Return codes
# 0: Success
# 1: Not a file
# 2: Missing arguments: String, String, File
# 3: Missing command: sed"
declare -f insertTextAtPattern

printf '%s\n' "
# Inserts text before the last line
# Return codes
# 0: Success
# 1: Not a file
# 2: Missing arguments: String, File
# 3: Missing command: sed"
declare -f insertTextAtLastLine

printf '%s\n' "
# Deletes a specified line in a file
# Return codes
# 0: Success
# 1: Not a file
# 2: Not a positive integer digit
# 3: Missing arguments: Integer, File
# 4: Missing command: sed"
declare -f deleteLineInFile

printf '%s\n' "
# Deletes a specified range in a file
# Return codes
# 0: Success
# 1: Not a file
# 2: Not a positive integer digit range
# 3: Missing arguments: Integer, Integer, File
# 4: Missing command: sed"
declare -f deleteRangeInFile

printf '%s\n' "
# Gets the length of an array
# Return codes
# 0: Success
# 1: Not an array
# 2: Wrong nr of arguments, 1 required: Array to get length of"
declare -f arrayLength

printf '%s\n' "
# This function uses /dev/urandom to generate a password randomly.
# Default length is 36, another length can be specified by 1st argument value
# Ex. This one below uses the most commonly allowed password characters
# < /dev/urandom tr -dc 'A-Z-a-z-0-9' | head -c${1:-32};printf '%s\n';
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
# < /dev/urandom tr -dc 'A-Z a-z0-9{[|:?!#$@%+*^.~,=()/\\;]}' | head -c\'${1:-36}\'; printf '%s\n'"
declare -f genPassword

printf '%s\n' "
# Generates a password using OpenSSL, default length is 36.
# Return codes
# 0: Success
# 1: Missing command: openssl"
declare -f genOpenSSLPassword

printf '%s\n' "
# Retrieves the members of a group
# Return codes
# 0: Success
# 1: Missing argument: Group name"
declare -f getGroupMembers

printf '%s\n' "
# Retrieves the groups a user is a member of
# 0: User exists, show group membership
# 1: No such user exists"
declare -f getUserGroups

printf '%s\n' "
# Retrieves the group IDs a user is a member of
# 0: User exists, show group membership
# 1: No such user exists"
declare -f getUserGroupsID

printf '%s\n' "
############################
# Bash - Network Functions
############################"

printf '%s\n' "
# Test if a port is open or closed on a remote host
# Return codes
# 1: Open
# 2: Closed
# 3: Invalid number of arguments"
declare -f testRemotePort

printf '%s\n' "
# Queries DNS record of a domain
# Return codes
# 0: Success
# 1: Error: Too many arguments provided
# 2: Missing argument(s): Domain, (Optional) Domain Record"
declare -f getDNSRecord

printf '%s\n' "
# Gets the public IP for the network
# Return codes
# 0: Success
# 1: Missing command: curl"
declare -f getPublicIP

printf '%s\n' "
# Tests for Public IPv4
# Return codes
# 0: Public IPv4 Available
# 1: Public IPv4 Unavailable
# 2: Missing command: curl"
declare -f testPublicIPv4

printf '%s\n' "
# Tests for Public IPv6
# Return codes
# 0: Public IPv6 Available
# 1: Public IPv6 Unavailable
# 2: Missing command: curl"
declare -f testPublicIPv6

printf '%s\n' "
# Gets the local IP assigned to the WiFi card for the device
# IPv4, IPv6 & Link-local"
declare -f getLocalIP

printf '%s\n' "
# Gets all the local IP-addresses on the device"
declare -f getAllLocalIP

printf '%s\n' "
# Get device IP information"
declare -f getIpInfo

printf '%s\n' "
# Gets the listening ports on the system
# Return codes
# 1: Missing command: grep
# 2: Missing command: lsof"
declare -f getListeningPorts

printf '%s\n' "
# Gets the services running on the network interfaces
# Return code
# 1: Missing command: lsof"
declare -f get_network_interface_services

printf '%s\n' "
# Gets the HTML code for a URL with Bash TCP
# Reuires the host TCP server to listen on HTTP, not HTTPS
# Return codes
# 0: Success
# 1: Requires arguments: [Host] [Port]"
declare -f getURL

printf '%s\n' "
# Fetches the current price of Bitcoin in Euro € from Binance
# Return codes
# 0: Success
# 1: Missing required command: curl"
declare -f getBTC

unset LIBRARY
