#!/usr/bin/env bash

PATH="$1"

if [[ ! -e "$PATH" ]]
then
    printf '%s\n' "No such path"
    exit 1
fi

for i in {01..24}
do
    /run/current-system/sw/bin/mkdir -p "./${PATH}/Day${i}"
    :> "./${PATH}/Day${i}/Day${i}.txt"
    :> "./${PATH}/Day${i}/input.txt"
done

exit 0
