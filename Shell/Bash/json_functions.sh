#!/usr/bin/env bash

test_json () 
{ 
    [[ "$#" -ne 1 ]] && return 4;
    if jq 'type' <<< "$1" &> /dev/null; then
        case $(jq 'type' <<< "$1") in 
            '"object"')
                return 0
            ;;
            '"string"')
                return 1
            ;;
            *)
                return 2
            ;;
        esac;
    else
        return 3;
    fi
}

is_json () 
{ 
    ! have_cmd 'jq' && return 1;
    case "$#" in 
        1)
            [[ "$(jq --null-input "$1" &> /dev/null; print_digit "$?")" -eq 0 ]]
        ;;
        *)
            print_err "Invalid nr of arguments: $#/1";
            return 2
        ;;
    esac
}

is_json_file () 
{ 
    ! have_cmd 'jq' && return 1;
    case "$#" in 
        1)
            [[ -f "$1" && "$(jq < "$1" &> /dev/null; print_digit "$?")" -eq 0 ]]
        ;;
        *)
            print_err "Invalid nr of arguments: $#/1";
            return 2
        ;;
    esac
}

is_json_object () 
{ 
    case "$#" in 
        1)
            [[ "$(test_json "$1"; print_digit "$?")" -eq 0 ]]
        ;;
        *)
            print_err "Invalid nr of arguments: $#/1";
            return 2
        ;;
    esac
}

is_json_string () 
{ 
    case "$#" in 
        1)
            [[ "$(test_json "$1"; print_digit "$?")" -eq 1 ]]
        ;;
        *)
            print_err "Invalid nr of arguments: $#/1";
            return 2
        ;;
    esac
}

json_keys () 
{ 
    ! have_cmd 'jq' && return 1;
    case "$#" in 
        1)
            if is_json_file "$1" || is_json "$1"; then
                jq 'keys' "$1";
            else
                print_err "Invalid: $1";
                return 1;
            fi
        ;;
        2)
            if is_json_file "$2" || is_json "$2"; then
                if [[ "$1" == .* ]]; then
                    jq ''"$1"' | keys' "$2";
                else
                    jq '.'"$1"' | keys' "$2";
                fi;
            else
                print_err "Invalid: $1";
                return 1;
            fi
        ;;
        *)
            print_err "Invalid nr of arguments: $#/1|2";
            return 1
        ;;
    esac
}

json_length () 
{ 
    ! have_cmd 'jq' && return 1;
    case "$#" in 
        1)
            if is_json_file "$1"; then
                jq 'length' "$1";
            else
                if is_json "$1"; then
                    jq 'length' <<< "$1";
                else
                    print_err "Invalid: $1";
                    return 1;
                fi;
            fi
        ;;
        2)
            if is_json_file "$2"; then
                if [[ "$1" == .* ]]; then
                    jq ''"$1"' | length' "$2";
                else
                    jq '.'"$1"' | length' "$2";
                fi;
            else
                if is_json "$2"; then
                    if [[ "$1" == .* ]]; then
                        jq ''"$1"' | length' <<< "$2";
                    else
                        jq '.'"$1"' | length' <<< "$2";
                    fi;
                else
                    print_err "Invalid: $1";
                    return 1;
                fi;
            fi
        ;;
        *)
            print_err "Invalid nr of arguments: $#/1|2";
            return 1
        ;;
    esac
}

json_read () 
{ 
    ! have_cmd 'jq' && return 1;
    case "$#" in 
        0)
            [[ -p /dev/stdin ]] && { 
                jq < /dev/stdin
            }
        ;;
        1)
            if [[ ! -f "$1" ]]; then
                if is_json "$1"; then
                    jq '.' <<< "$1";
                else
                    if [[ -p /dev/stdin ]]; then
                        if [[ "$1" == .* ]]; then
                            jq ''"$1"'' < /dev/stdin;
                        else
                            jq '.'"$1"'' < /dev/stdin;
                        fi;
                    else
                        print_err "Invalid input: $1";
                        return 2;
                    fi;
                fi;
            else
                if [[ -p /dev/stdin ]]; then
                    if [[ "$1" == .* ]]; then
                        jq ''"$1"'' < /dev/stdin;
                    else
                        jq '.'"$1"'' < /dev/stdin;
                    fi;
                else
                    jq '.' "$1";
                fi;
            fi
        ;;
        2)
            if [[ ! -f "$2" ]]; then
                if is_json "$2"; then
                    if [[ "$1" == .* ]]; then
                        jq ''"$1"'' <<< "$2";
                    else
                        jq '.'"$1"'' <<< "$2";
                    fi;
                else
                    print_err "Invalid input: $2";
                    return 2;
                fi;
            else
                if [[ "$1" == .* ]]; then
                    jq ''"$1"'' "$2";
                else
                    if [[ "$1" == -* ]]; then
                        jq "$1" '.' "$2";
                    else
                        jq '.'"$1"'' "$2";
                    fi;
                fi;
            fi
        ;;
        3)
            if [[ ! -f "$3" ]]; then
                if is_json "$3"; then
                    if [[ "$2" == .* ]]; then
                        jq "$1" ''"$2"'' <<< "$3";
                    else
                        jq "$1" '.'"$2"'' <<< "$3";
                    fi;
                else
                    print_err "Invalid input: $3";
                    return 2;
                fi;
            else
                if [[ "$2" == .* ]]; then
                    jq "$1" ''"$2"'' "$3";
                else
                    jq "$1" '.'"$2"'' "$3";
                fi;
            fi
        ;;
        *)
            print_err "Nr of arguments are invalid: $#/1|2|3";
            return 3
        ;;
    esac
}

json_new () 
{ 
    ! have_cmd 'jq' && return 1;
    case "$#" in 
        0)
            [[ -p /dev/stdin ]] && { 
                jq < /dev/stdin
            }
        ;;
        1)
            if is_json "$1"; then
                if [[ -p /dev/stdin ]]; then
                    jq "$1" < /dev/stdin;
                else
                    jq --null-input "$1";
                fi;
            else
                print_err "Invalid input: $1";
                return 2;
            fi
        ;;
        2)
            if is_json "$2"; then
                jq "$1" <<< "$2";
            else
                if is_json_file "$2"; then
                    jq "$1" "$2";
                else
                    print_err "Invalid input: $2";
                    return 2;
                fi;
            fi
        ;;
        3)
            if is_json "$3"; then
                if [[ "$2" == .* ]]; then
                    jq "$1" ''"$2"'' <<< "$3";
                else
                    jq "$1" '.'"$2"'' <<< "$3";
                fi;
            else
                if is_json_file "$3"; then
                    if [[ "$2" == .* ]]; then
                        jq "$1" ''"$2"'' "$3";
                    else
                        jq "$1" '.'"$2"'' "$3";
                    fi;
                else
                    print_err "Invalid input: $3";
                    return 2;
                fi;
            fi
        ;;
        *)
            print_err "Invalid nr of arguments: $#/STDIN(0)|1|2|3";
            return 3
        ;;
    esac
}

json_object () 
{ 
    local ARGS=("$@") KEYS=() VALUES=() OBJECT DIGIT;
    for ((X = 0; X < "${#@}"; X += 1 ))
    do
        case "${ARGS[$X]}" in 
            -k | --key)
                DIGIT=$(( "$X" + 1 ));
                KEYS+=("${ARGS[$DIGIT]}")
            ;;
            -v | --value)
                DIGIT=$(( "$X" + 1 ));
                VALUES+=("${ARGS[$DIGIT]}")
            ;;
            *)
                continue
            ;;
        esac;
    done;
    OBJECT+='{';
    for ((Y = 0; Y < "${#KEYS[@]}"; Y += 1 ))
    do
        if [[ "$Y" -eq $(("${#KEYS[@]}" - 1)) ]]; then
            if is_json "${VALUES[$Y]}"; then
                OBJECT+='"'"${KEYS[$Y]}"'":'"${VALUES[$Y]}"'';
            else
                OBJECT+='"'"${KEYS[$Y]}"'":"'"${VALUES[$Y]}"'"';
            fi;
        else
            if is_json "${VALUES[$Y]}"; then
                OBJECT+='"'"${KEYS[$Y]}"'":'"${VALUES[$Y]}"',';
            else
                OBJECT+='"'"${KEYS[$Y]}"'":"'"${VALUES[$Y]}"'",';
            fi;
        fi;
    done;
    OBJECT+='}';
    if [[ "${#KEYS[@]}" -gt 1 && "${#VALUES[@]}" -gt 1 ]]; then
        json_new "${OBJECT[*]}";
    else
        json_new "${OBJECT[*]}";
    fi
}

json_objects () 
{ 
    local ARGS=("$@") KEYS=() VALUES=() OBJECT DIGIT;
    for ((X = 0; X < "${#@}"; X += 1 ))
    do
        case "${ARGS[$X]}" in 
            -k | --key)
                DIGIT=$(( "$X" + 1 ));
                KEYS+=("${ARGS[$DIGIT]}")
            ;;
            -v | --value)
                DIGIT=$(( "$X" + 1 ));
                VALUES+=("${ARGS[$DIGIT]}")
            ;;
            *)
                if is_json_object "${ARGS[$X]}"; then
                    VALUES+=("${ARGS[$X]}");
                else
                    continue;
                fi
            ;;
        esac;
    done;
    for ((Y = 0; Y < "${#KEYS[@]}"; Y += 1 ))
    do
        if [[ "$Y" -eq $(("${#KEYS[@]}" - 1)) ]]; then
            if is_json "${VALUES[$Y]}"; then
                OBJECT+='{"'"${KEYS[$Y]}"'":'"${VALUES[$Y]}"'}';
            else
                OBJECT+='{"'"${KEYS[$Y]}"'":"'"${VALUES[$Y]}"'"}';
            fi;
        else
            if is_json "${VALUES[$Y]}"; then
                OBJECT+='{"'"${KEYS[$Y]}"'":'"${VALUES[$Y]}"'},';
            else
                OBJECT+='{"'"${KEYS[$Y]}"'":"'"${VALUES[$Y]}"'"},';
            fi;
        fi;
    done;
    if [[ "${#KEYS[@]}" -gt 1 && "${#VALUES[@]}" -gt 1 ]]; then
        json_new "[${OBJECT[*]}]";
    else
        json_new "${OBJECT[*]}";
    fi
}

json_array () 
{ 
    local STR='[' COUNT=0;
    for X in "$@";
    do
        COUNT=$(("$COUNT" + 1));
        if [[ ! "$X" =~ ^\".*\"$ && ! "$X" =~ [0-9*] && ! "$X" =~ [{}] ]]; then
            if [[ "$COUNT" -eq "$#" ]]; then
                STR+="\"$X\"";
            else
                STR+="\"$X\",";
            fi;
        else
            if [[ "$X" =~ [0-9*] ]]; then
                if [[ "$COUNT" -eq "$#" ]]; then
                    STR+="$X";
                else
                    STR+="$X,";
                fi;
            else
                if [[ "$COUNT" -eq "$#" ]]; then
                    STR+="$X";
                else
                    STR+="$X,";
                fi;
            fi;
        fi;
    done;
    STR+=']';
    print "$STR"
}

json_update () 
{ 
    case "$#" in 
        3)
            json_set "$@"
        ;;
        4)
            if [[ "${1,,}" =~ ^(-w|--w)$ ]]; then
                local DATA;
                DATA="$(json_set "${@:2}" | jq -ac)";
                print "$DATA" > "$4";
                print "File updated: $4";
            else
                print_err "Invalid option: $1";
                return 1;
            fi
        ;;
        *)
            print_err "Invalid number of arguments: $#/3|4";
            return 1
        ;;
    esac
}

json_setpath () 
{ 
    ! have_cmd 'jq' && return 1;
    case "$#" in 
        [3-9*] | [1-9*][1-9*])
            if is_json_file "$1" || is_json "$1"; then
                if [[ "$2" =~ ^\".*\"$ ]]; then
                    jq 'setpath('"$(json_array "${*:3}")"'; '"$2"')' "$1";
                else
                    jq 'setpath('"$(json_array "${*:3}")"'; "'"$2"'")' "$1";
                fi;
            else
                print_err "Invalid file/json: $1";
                return 1;
            fi
        ;;
        *)
            print_err "Invalid number of arguments: $#";
            return 1
        ;;
    esac
}

json_set () 
{ 
    ! have_cmd 'jq' && return 1;
    case "$#" in 
        2)
            if ! is_json "$1"; then
                print_err "Invalid value, not a JSON object: $1";
                return 3;
            fi;
            if [[ ! -f "$2" ]]; then
                if ! is_json "$2"; then
                    print_err "Invalid input, not a JSON object or a file: $2";
                    return 3;
                else
                    if ! jq --argjson value "$1" '. = $value' <<< "$2" &> /dev/null; then
                        print_err "Mismatched values cannot be added together, ex. array to object or object to array";
                        return 1;
                    else
                        jq --argjson value "$1" '. = $value' <<< "$2";
                    fi;
                fi;
            else
                if ! jq --argjson value "$1" '. = $value' "$2" &> /dev/null; then
                    print_err "Mismatched values cannot be added together, ex. array to object or object to array";
                    return 1;
                else
                    jq --argjson value "$1" '. = $value' "$2";
                fi;
            fi
        ;;
        3)
            local JSON="$2";
            if ! is_json "$JSON" && ! is_json "\"$JSON\""; then
                print_err "Invalid value: $JSON";
                return 2;
            else
                if is_json "\"$JSON\""; then
                    JSON="\"$JSON\"";
                fi;
            fi;
            if [[ -f "$3" ]]; then
                if [[ "$1" == .* ]]; then
                    if ! jq --argjson value "$JSON" ''"$1"' = $value' "$3" &> /dev/null; then
                        print_err "Mismatched values cannot be added together, ex. array to object or object to array";
                        return 1;
                    else
                        jq --argjson value "$JSON" ''"$1"' = $value' "$3";
                    fi;
                else
                    if ! jq --argjson value "$JSON" '.'"$1"' = $value' "$3" &> /dev/null; then
                        print_err "Mismatched values cannot be added together, ex. array to object or object to array";
                        return 1;
                    else
                        jq --argjson value "$JSON" '.'"$1"' = $value' "$3";
                    fi;
                fi;
            else
                if is_json "$3"; then
                    if [[ "$1" == .* ]]; then
                        if ! jq --argjson value "$JSON" ''"$1"' = $value' <<< "$3" &> /dev/null; then
                            print_err "Mismatched values cannot be added together, ex. array to object or object to array";
                            return 1;
                        else
                            jq --argjson value "$JSON" ''"$1"' = $value' <<< "$3";
                        fi;
                    else
                        if ! jq --argjson value "$JSON" '.'"$1"' = $value' <<< "$3" &> /dev/null; then
                            print_err "Mismatched values cannot be added together, ex. array to object or object to array";
                            return 1;
                        else
                            jq --argjson value "$JSON" '.'"$1"' = $value' <<< "$3";
                        fi;
                    fi;
                else
                    print_err "Invalid: $3";
                    return 2;
                fi;
            fi
        ;;
        *)
            print_err "Nr of arguments are invalid: $#";
            return 4
        ;;
    esac
}

json_add () 
{ 
    case "$#" in 
        2)
            json_append "$@"
        ;;
        3)
            json_append "$@"
        ;;
        4)
            if [[ "${1,,}" =~ ^(-w|--w)$ ]]; then
                if [[ -f "$4" ]]; then
                    local DATA;
                    DATA="$(json_append "${@:2}" | jq -ac)";
                    print "$DATA" > "$4";
                    print "File updated: $4";
                else
                    print_err "Invalid: $4";
                    return 3;
                fi;
            else
                print_err "Invalid option: $1";
                return 2;
            fi
        ;;
        *)
            print_err "Invalid number of arguments: $#";
            return 1
        ;;
    esac
}

json_append () 
{ 
    ! have_cmd 'jq' && return 2;
    case "$#" in 
        2)
            if is_json "$1"; then
                if [[ ! -f "$2" ]]; then
                    if is_json "$2"; then
                        if ! jq --argjson value "$1" '. += $value' <<< "$2" &> /dev/null; then
                            print_err "Mismatched values cannot be added together, ex. array to object or object to array";
                            return 1;
                        else
                            jq --argjson value "$1" '. += $value' <<< "$2";
                        fi;
                    fi;
                else
                    if ! jq --argjson value "$1" '. += $value' "$2" &> /dev/null; then
                        print_err "Mismatched values cannot be added together, ex. array to object or object to array";
                        return 1;
                    else
                        jq --argjson value "$1" '. += $value' "$2";
                    fi;
                fi;
            else
                print_err "Invalid value: $1";
                return 1;
            fi
        ;;
        3)
            if is_json "$2"; then
                if [[ -f "$3" ]]; then
                    if [[ "$1" == .* ]]; then
                        if ! jq --argjson value "$2" ''"$1"' += $value' "$3" &> /dev/null; then
                            print_err "Mismatched values cannot be added together, ex. array to object or object to array";
                            return 1;
                        else
                            jq --argjson value "$2" ''"$1"' += $value' "$3";
                        fi;
                    else
                        if ! jq --argjson value "$2" '.'"$1"' += $value' "$3" &> /dev/null; then
                            print_err "Mismatched values cannot be added together, ex. array to object or object to array";
                            return 1;
                        else
                            jq --argjson value "$2" '.'"$1"' += $value' "$3";
                        fi;
                    fi;
                else
                    if is_json "$3"; then
                        if [[ "$1" == .* ]]; then
                            if ! jq --argjson value "$2" ''"$1"' += $value' <<< "$3" &> /dev/null; then
                                print_err "Mismatched values cannot be added together, ex. array to object or object to array";
                                return 1;
                            else
                                jq --argjson value "$2" ''"$1"' += $value' <<< "$3";
                            fi;
                        else
                            if ! jq --argjson value "$2" '.'"$1"' += $value' <<< "$3" &> /dev/null; then
                                print_err "Mismatched values cannot be added together, ex. array to object or object to array";
                                return 1;
                            else
                                jq --argjson value "$2" '.'"$1"' += $value' <<< "$3";
                            fi;
                        fi;
                    else
                        print_err "Invalid: $3";
                    fi;
                fi;
            else
                print_err "Invalid: $2";
            fi
        ;;
        *)
            print_err "Nr of arguments are invalid: $#";
            return 4
        ;;
    esac
}

json_delete () 
{ 
    ! have_cmd 'jq' && return 1;
    case "$#" in 
        2)
            if [[ -f "$2" ]]; then
                if [[ "$1" == .* ]]; then
                    jq 'del('"$1"')' "$2";
                else
                    jq 'del(.'"$1"')' "$2";
                fi;
            else
                if is_json "$2"; then
                    if [[ "$1" == .* ]]; then
                        jq 'del('"$1"')' "$2";
                    else
                        jq 'del(.'"$1"')' "$2";
                    fi;
                else
                    print_err "Invalid input, neither file nor JSON: $2";
                    return 1;
                fi;
            fi
        ;;
        3)
            if [[ "${1,,}" =~ ^(-w|--w)$ ]]; then
                local DATA;
                if [[ -f "$3" ]]; then
                    if [[ "$2" == .* ]]; then
                        DATA="$(jq -ac 'del('"$2"')' "$3")";
                    else
                        DATA="$(jq -ac 'del(.'"$2"')' "$3")";
                    fi;
                    print "$DATA" > "$3";
                    print "File updated: $3";
                else
                    if is_json "$3"; then
                        if [[ "$2" == .* ]]; then
                            jq -ac 'del('"$2"')' "$3";
                        else
                            jq -ac 'del(.'"$2"')' "$3";
                        fi;
                    else
                        print_err "Invalid input, neither file nor JSON: $3";
                        return 1;
                    fi;
                fi;
            else
                print_err "Invalid option: $1";
                return 1;
            fi
        ;;
        *)
            print_err "Nr of arguments are invalid: $#";
            return 3
        ;;
    esac
}

json_key_rename () 
{ 
    [[ "$#" -eq 2 && -p /dev/stdin ]] && { 
        jq 'with_entries(
            if .key | contains("'"$1"'")
            then .key |= sub("'"$1"'";"'"$2"'")
            else . end
        )' /dev/stdin
    };
    [[ "$#" -eq 3 && -f "$3" ]] && { 
        jq 'with_entries(
            if .key | contains("'"$1"'")
            then .key |= sub("'"$1"'";"'"$2"'")
            else . end
        )' "$3"
    }
}

