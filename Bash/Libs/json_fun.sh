#!/usr/bin/env bash
# Victor-ray, S <12261439+ZendaiOwl@users.noreply.github.com>

# Extract functions
# jq -r '.shebang' functions.json | base64 -d -i

function Print { printf '%s ' "$@"; }

function clean {
    if [[ "${#SCRIPT_VARIABLES[@]}" -eq 0 ]]
    then unset SCRIPT_VARIABLES
    else unset "${SCRIPT_VARIABLES[@]}"
         unset SCRIPT_VARIABLES
    fi
}

function addVariables {
    if [[ -z "$#" ]]
    then return 1
    else SCRIPT_VARIABLES+=("$@")
    fi
}

declare -a SCRIPT_VARIABLES

trap 'clean' EXIT SIGHUP SIGINT SIGILL SIGABRT

# [[ "$#" -ne 3 ]] && exit 1

# if [[ -f "$1" ]]
# then FILE="$1"
# else exit 1
# fi

FILE="functions.json"

# if [[ -n "$1" ]]
# then ID="$1"
# fi
# 
# # ID="is_user"
# 
# if [[ -n "$2" ]]
# then CONTENT="$2"
# fi

#declare -a B64
#declare -a JSON_OBJECT
declare -a NAME
# declare -a INPUT

for L in $(grep 'function ' lib_minimal.sh | awk '{print $2}')
do NAME+=("$L")
done

LENGTH="${#NAME[@]}"

for (( i = 0; i < "$LENGTH"; i++ ))
do #JSON_OBJECT+=('{"'"$(printf '%s' "${NAME[$i]}")"'":"'"$(printf '%s' "$(grep "function ${NAME[$i]}" lib_minimal.sh | base64 -w0)")"'"}')
   JSON_OBJECT='{"'"$(printf '%s' "${NAME[$i]}")"'":"'"$(printf '%s' "$(grep "function ${NAME[$i]}" lib_minimal.sh | base64 -w0)")"'"}'
   NEW="$(jq -jc ". += $JSON_OBJECT" "$FILE")"
   printf '%s\n' "$NEW" > "$FILE"
done

addVariables 'ID' 'CONTENT' 'FILE' 'JSON_OBJECT' 'B64' 'INPUT' 'LENGTH'

# for X in "${JSON_OBJECT[@]}"
# do NEW="$(jq -jc ". += $X" "$FILE")"
#    printf '%s\n' "$NEW" > "$FILE"
# done

#for L in $(printf '%s\n' "$2" | base64)
#do B64+=("$L")
#done

B64="$(printf '%s\n' "$2" | base64 -w0)"

# JSON_OBJECT='{"'"$1"'":"'"${B64[*]}"'"}'
#JSON_OBJECT='{"'"$1"'":"'"$B64"'"}'

# JSON_OBJECT='{"'"$ID"'":"'"$B64"'"}'

#jq -njc ". += $JSON_OBJECT"

#NEW="$(jq -jc ". += $JSON_OBJECT" "$FILE")"

addVariables 'NEW'

#Print "$NEW" > "$FILE"
