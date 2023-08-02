#!/usr/bin/env sh
# § Victor-ray, S.
# POSIX script to check if a password is 
# found in a database of known leaked passwords

trap 'exit "$?"' EXIT ERR SIGTERM SIGABRT

print_err () {
    ( printf '\e[1;31m%s\e[0m %s\n' "ERROR" "$*" )
}

test "$#" -ne 1 && {
    print_err "Invalid number of arguments: $#/1"
    exit 1
}

check_password () {
	(
    	PASS="$(printf '%s' "$1" | sha1sum | tr '[:lower:]' '[:upper:]' | awk '{ print $1}')"
    	URL="https://api.pwnedpasswords.com/range/${PASS:0:5}"
    	# shellcheck disable=SC2046
    	set -- $(curl --silent --location "$URL")
    	printf '%s\n' "SHA1-Hash: ${PASS:0:5} ${PASS:5:40}"
    	for i in "$@"; do
        	if [ "${i:0:35}" = "${PASS:5:40}" ]; then
            	printf '\e[1;33m%s\e[0m %s\n' "WARNING" "Password is known, times used: ${i:36:50}"
            	EXISTS=1
        	fi
    	done
    	[ -z "$EXISTS" ] && {
      		printf '\e[1;32m%s\e[0m %s\n' "OK" "Password is unknown"
    	}
    )
}

( check_password "$1" )
