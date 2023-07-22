#!/usr/bin/env bash
# Victor-ray, S.

. ./tests.sh
. ./utility.sh

# ------------
# Installation
# ------------

# Update apt list and packages
# Return codes
# 0: install_pkg completed
# 1: Coudn't update apt list
# 2: Invalid number of arguments
# 3: Missing command: apt | apt-get
function update_apt {
    ! has_cmd 'apt' || \
    ! has_cmd 'apt-get' && { return 3; }
    [[ "$#" -ne 0 ]] && {
        log 2 "Invalid number of arguments: $#/0"
        return 2
    }
    local -r OPTIONS=(
        --quiet
        --assume-yes
        --no-show-upgraded
        --auto-remove=true
        --no-install-recommends
    )
    local -r SUDO_UPDATE=(sudo apt-get "${OPTIONS[@]}" update)
    local -r ROOT_UPDATE=(apt-get "${OPTIONS[@]}" update)
    if [[ "$EUID" -eq 0 ]]; then
        log -1 "Updating apt lists"
        if "${ROOT_UPDATE[@]}" &>/dev/null; then
            log 0 "Apt list updated"
        else
            log 2 "Couldn't update apt lists"
            return 1
        fi
    else
        log -1 "Updating apt lists"
        if "${SUDO_UPDATE[@]}" &>/dev/null; then
            log 0 "Apt list updated"
        else
            log 2 "Couldn't update apt lists"
            return 1
        fi
    fi
}

# Install package(s) using the package manager and pre-configured options
# Return codes
# 0: install_pkg completed
# 1: Error during installation
# 2: Missing package argument
# 3: Missing command: apt | apt-get
function install_package {
    ! has_cmd 'apt' || \
    ! has_cmd 'apt-get' && { return 3; }
    [[ "$#" -eq 0 ]] && { log 2 "Invalid number of arguments: $#/1+"; return 2; }
    local -r OPTIONS=(
        --quiet
        --assume-yes
        --no-show-upgraded
        --auto-remove=true
        --no-install-recommends
    )
    local -r SUDO_INSTALL=(sudo apt-get "${OPTIONS[@]}" install)
    local -r ROOT_INSTALL=(apt-get "${OPTIONS[@]}" install)
    if [[ "$EUID" -eq 0 ]]; then
        log -1 "Installing: $*"
        if DEBIAN_FRONTEND=noninteractive "${ROOT_INSTALL[@]}" "$@"; then
            log 0 "Installation complete"
            return 0
        else
            log 2 "Something went wrong during installation"
            return 1
        fi
    else
        log -1 "Installing: $*"
        if DEBIAN_FRONTEND=noninteractive "${SUDO_INSTALL[@]}" "$@"; then
            log 0 "Installation complete"
            return 0
        else
            log 2 "Something went wrong during installation"
            return 1
        fi
    fi
}
