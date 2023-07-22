#!/usr/bin/env bash
# Victor-ray, S.

. ./docker.sh
. ./git.sh
. ./installation.sh
. ./json.sh
. ./network.sh
. ./tests.sh
. ./utility.sh

# --------
# Calculus
# --------

# Calculation using bc
function bC {
    ! has_cmd 'bc' && { return 1; }
    printf '%s\n' "$*" | bc -l
}

# Calculation using awk
function Calc {
    ! has_cmd 'awk' && { return 1; }
    awk "BEGIN{print $*}"
}

# Arithmetic Addition
# Only integers.
# Decimals or numbers of type double does not work 
# Return codes
# 0: Success
# 1: Invalid number of arguments
# 2: Invalid values: Not digits
# 3: Error: Not an integer
function Addition {
    [[ "$#" -ne 2 ]] && { return 1; }
    ! is_digit "$1" || ! is_digit "$2" && { return 2; }
    [[ "$1" == *[.]* || "$2" == *[.]* ]] && { return 3; }
    print_int "$(( "$1" + "$2" ))"
}

# Arithmetic Subtraction
# Only integers.
# Decimals or numbers of type double does not work 
# Return codes
# 0: Success
# 1: Invalid number of arguments
# 2: Error: Not an integer
function Subtraction {
    [[ "$#" -ne 2 ]] && { return 1; }
    [[ "$1" == *[.]* || "$2" == *[.]* ]] && { return 2; }
    print_int "$(( "$1" - "$2" ))"
}

# Arithmetic Multiplication
# Only integers.
# Decimals or numbers of type double does not work 
# Return codes
# 0: Success
# 1: Invalid number of arguments
# 2: Error: Not an integer
function Multiplication {
    [[ "$#" -ne 2 ]] && { return 1; }
    [[ "$1" == *[.]* || "$2" == *[.]* ]] && { return 2; }
    print_int "$(( "$1" * "$2" ))"
}

# Arithmetic Division
# Only integers.
# Decimals or numbers of type double does not work 
# Return codes
# 0: Success
# 1: Invalid number of arguments
# 2: Error: Not an integer
# 3: Error: Attempted division by zero
function Division {
    [[ "$#" -ne 2 ]] && { return 1; }
    [[ "$1" == *[.]* || "$2" == *[.]* ]] && { return 2; }
    [[ "$1" == 0 || "$2" == 0 ]] && { return 3; }
    print_int "$(( "$1" / "$2" ))"
}

# Arithmetic Exponential
# Only integers.
# Decimals or numbers of type double does not work 
# Return codes
# 0: Success
# 1: Invalid number of arguments
# 2: Error: Not an integer
function Exponential {
    [[ "$#" -ne 2 ]] && { return 1; }
    [[ "$1" == *[.]* || "$2" == *[.]* ]] && { return 2; }
    print_int "$(( "$1" ** "$2" ))"
}

# ---------
# Financial
# ---------

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
    println "[ $1 ] Old" \
            "[ $2 ] New" \
            "[ $(Calc "$2"-"$1") ] Difference" \
            "[ $(Calc "$(Calc "$2"-"$1")"/"$1") ] Decimal" \
            "[ $(Calc "$(Calc "$(Calc "$2"-"$1")"/"$1")"*100)% ] Percentile" 
}

# Calculates the percentile a value is of another value
function percentile {
    [[ "$#" != 2 ]] && { return 1; }
    [[ "$1" == 0 || "$2" == 0 ]] && { return 2; }
    println "[ $1 ] Whole" \
            "[ $2 ] Part" \
            "[ $(Calc "$2"/"$1") ] Decimal" \
            "[ $(Calc "$(Calc "$2"/"$1")"*100)% ] Percentage"
}

# TODO A function that calculates compound interest
# on principal with recurring contributions with varying compounding periods
