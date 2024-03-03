#!/usr/bin/env bash

is_array () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ "$(declare +a "$1" &> /dev/null; printf '%i' "$?")" -eq 0 ]]
}

is_digit () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ "$1" =~ ^[[:digit:]]*$ ]]
}

is_directory () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ -d "$1" ]]
}

is_equal () 
{ 
    [[ "$#" -ne 2 ]] && { 
        return 2
    };
    [[ "$1" -eq "$2" ]]
}

is_equal_or_greater () 
{ 
    [[ "$#" -ne 2 ]] && { 
        return 2
    };
    [[ "$1" -ge "$2" ]]
}

is_executable () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ -x "$1" ]]
}

is_file () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ -f "$1" ]]
}

is_function () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ "$(declare -F "$1" &> /dev/null; printf '%i' "$?")" -eq 0 ]]
}

is_greater () 
{ 
    [[ "$#" -ne 2 ]] && { 
        return 2
    };
    [[ "$1" -gt "$2" ]]
}

is_less () 
{ 
    [[ "$#" -ne 2 ]] && { 
        return 2
    };
    [[ "$1" -lt "$2" ]]
}

is_match () 
{ 
    [[ "$#" -ne 2 ]] && { 
        return 2
    };
    [[ "$1" == "$2" ]]
}

is_member () 
{ 
    [[ "$#" -ne 2 ]] && { 
        return 2
    };
    ! is_user "$1" && { 
        return 1
    };
    [[ "$(id --groups --name "$1")" == *"$2"* ]]
}

is_path () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ -e "$1" ]]
}

is_pipe () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ -p "$1" ]]
}

is_positive_int () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ "$1" -gt 0 ]]
}

is_readable () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ -r "$1" ]]
}

is_reference () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ -R "$1" ]]
}

is_root () 
{ 
    [[ "$EUID" -eq 0 ]]
}

is_set () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ -v "$1" ]]
}

is_socket () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ -S "$1" ]]
}

is_type () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    ( type -t "$1" )
}

is_user () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ "$(id --user "$1" &> /dev/null; printf '%i' "$?")" -eq 0 ]]
}

is_writable () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ -w "$1" ]]
}

is_zero () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ -z "$1" ]]
}

not_equal () 
{ 
    [[ "$#" -ne 2 ]] && { 
        return 2
    };
    [[ "$1" -ne "$2" ]]
}

not_match () 
{ 
    [[ "$#" -ne 2 ]] && { 
        return 2
    };
    [[ "$1" != "$2" ]]
}

not_zero () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ -n "$1" ]]
}

have_text () 
{ 
    [[ "$#" -ne 2 ]] && { 
        return 2
    };
    [[ "$2" == *"$1"* ]]
}

have_cmd () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ "$(command -v "$1" &> /dev/null; printf '%i' "$?")" -eq 0 ]]
}

can_execute () 
{ 
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ "$(type -p "$1" &> /dev/null; printf '%i' "$?")" -eq 0 ]]
}

