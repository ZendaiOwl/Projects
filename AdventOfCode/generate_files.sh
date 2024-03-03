#!/usr/bin/env bash
# § Victor-ray, S.

function generate {
    local PATH="$1" BASE='/run/current-system/sw/bin'
    
    if [[ ! -e "$PATH" ]]
    then
        "$BASE"/printf '%s\n' "No such path"
        exit 1
    fi
    
    for i in {01..25}
    do
        "$BASE"/mkdir -p "./${PATH}/Day${i}"
        "$BASE"/touch "./${PATH}/Day${i}/Day${i}.txt"
        "$BASE"/touch "./${PATH}/Day${i}/input.txt"
    done

}


generate "$1"

exit 0
