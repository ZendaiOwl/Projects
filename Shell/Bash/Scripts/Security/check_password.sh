#!/usr/bin/env bash
# § Victor-ray, S.

[[ "$#" -ne 1 ]] && {
    printf '%s\n' "Invalid number of arguments: $#/1"
}

if ! command -v curl &> /dev/null; then
    printf '\e[1;31m%s\e[0m %s\n' "ERROR" "Missing command: curl"
fi

# Password check against haveibeenpwned API
function check_password {
    local PASS EXISTS
    PASS="$(printf '%s' "$1" | sha1sum | tr '[:lower:]' '[:upper:]' | awk '{ print $1}')"
    local -r URL="https://api.pwnedpasswords.com/range/${PASS:0:5}"
    local -a RESPONSE
    while read -rs LINE; do
    	RESPONSE+=( "$LINE" )
    done < <(curl --silent --location "$URL")
    printf '%s\n' "SHA1-Hash: ${PASS:0:5} ${PASS:5:40}"
    for i in "${RESPONSE[@]}"; do
        if [[ "${i:0:35}" == "${PASS:5:40}" ]]; then
            printf '\e[1;33m%s\e[0m %s\n' "WARNING" "Password is known, times used: ${i:36:50}"
            EXISTS=1
        fi
    done
    [[ -z "$EXISTS" ]] && {
      printf '\e[1;32m%s\e[0m %s\n' "OK" "Password is unknown"
    }
}

check_password "$1"

exit 0
