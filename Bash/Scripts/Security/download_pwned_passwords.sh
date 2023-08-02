#!/usr/bin/env bash
# § Victor-ray, S.
# This script downloads all the password hashes from 
# haveibeenpwned's API at https://api.pwnedpasswords.com 
# API documentation: https://haveibeenpwned.com/API/v3
# Takes a long time if you have a slow conection & CPU
# The final text file is around 23 GB in size

[[ "$#" -ne 0 ]] && {
    printf '%s\n' "Invalid number of arguments: $#/0"
}

run_script () {
	local -ar range=( 0 1 2 3 4 5 6 7 8 9 A B C D E F )
	( touch "$PWD"/password_hashes )
	(
		for i1 in "${range[@]}"
		do
			for i2 in "${range[@]}"
			do
				for i3 in "${range[@]}"
				do
					for i4 in "${range[@]}"
					do
						for i5 in "${range[@]}"
						do
							(
								curl --silent \
                     --location \
                     "https://api.pwnedpasswords.com/range/${i1}${i2}${i3}${i4}${i5}" >> \
                     "$PWD"/password_hashes &
								wait "$!"
								printf '%s' "·"
							)
						done
					done
				done
			done
		done
	)
  ( printf '\n' )
}

( run_script )
