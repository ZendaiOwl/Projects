#!/usr/bin/env bash
# Victor-ray, S. <12261439+ZendaiOwl@users.noreply.github.com> https://github.com/ZendaiOwl
#
# RISC-V GNU Compiler Toolchain
# 

########################
####### CLEANUP ########
########################

function cleanup {
  unset RISCV_GNU_TOOLCHAIN \
        PREFIX \
        CURRENT_DIRECTORY \
        BUILD_DIRECTORY \
        TOOLCHAIN_DIRECTORY \
        NAME
}

########################
###### FUNCTIONS #######
########################

function debug {
  local -r BLUE='\e[1;34m' Z='\e[0m'
  printf "${BLUE}INFO${Z} %s\n" "${*}"
}

# Installs package(s) using the package manager and pre-configured options
# Return codes
# 0: Install completed
# 1: Coudn't update apt list
# 2: Error during installation
# 3: Missing package argument
function installPKG {
  if [[ "$#" -eq 0 ]]
  then
    log 2 "Requires: [PKG(s) to install]"
    return 3
  else
    local -r OPTIONS=(--quiet --assume-yes --no-show-upgraded --auto-remove=true --no-install-recommends)
    local -r SUDOUPDATE=(sudo apt-get "${OPTIONS[@]}" update) \
             SUDOINSTALL=(sudo apt-get "${OPTIONS[@]}" install) \
             ROOTUPDATE=(apt-get "${OPTIONS[@]}" update) \
             ROOTINSTALL=(apt-get "${OPTIONS[@]}" install)
    local PKG=()
    IFS=' ' read -ra PKG <<<"$@"
    if [[ ! "$EUID" -eq 0 ]]
    then
      if "${SUDOUPDATE[@]}" &> /dev/null
      then
        log 0 "Apt list updated"
      else
        log 2 "Couldn't update apt lists"
        return 1
      fi
      log -1 "Installing ${PKG[*]}"
      if DEBIAN_FRONTEND=noninteractive "${SUDOINSTALL[@]}" "${PKG[@]}"
      then
        log 0 "Installation completed"
        return 0
      else
        log 2 "Something went wrong during installation"
        return 2
      fi
    else
      if "${ROOTUPDATE[@]}" &> /dev/null
      then
        log 0 "Apt list updated"
      else
        log 2 "Couldn't update apt lists"
        return 1
      fi
      log -1 "Installing ${PKG[*]}"
      if DEBIAN_FRONTEND=noninteractive "${ROOTINSTALL[@]}" "${PKG[@]}"
      then
        log 0 "Installation completed"
        return 0
      else
        log 2 "Something went wrong during installation"
        return 1
      fi
    fi
  fi
}

function addPKG {
  if [[ "$#" -lt 1 ]]
  then
    log 2 "Missing package argument(s)"
    exit 1
  else
    local ADDPKG=()
    IFS=' ' read -ra ADDPKG <<<"$@"
    log -1 "Adding package(s) for installation: ${ADDPKG[*]}"
    for PKG in "${ADDPKG[@]}"
    do
      PACKAGES+=("$PKG")
    done
  fi
}

########################
###### VARIABLES #######
########################

RISCV_GNU_TOOLCHAIN='/home/zendai/Code/Build/RISC-V/GNU-Toolchain/musl-toolchain.sh'
PREFIX='/opt/riscv64'
CURRENT_DIRECTORY="$PWD"
BUILD_DIRECTORY="${CURRENT_DIRECTORY}/build-riscv64"
TOOLCHAIN_DIRECTORY="${BUILD_DIRECTORY}/riscv-gnu-toolchain"
NAME='RISC-V GNU Compiler Toolchain'

PACKAGES=()

########################

trap 'cleanup' EXIT SIGHUP SIGILL SIGABRT

########################

########################
##### INSTALLATION #####
########################

debug "Adding required packages for build"

addPKG autoconf \
       automake \
       autotools-dev \
       bc \
       bison \
       build-essential \
       curl \
       flex \
       gawk \
       git \
       gperf \
       libcxxopts-dev \
       libcxx-serial-dev \
       libcxxtools-dev \
       libexpat-dev \
       libfdt-dev \
       libglib2.0-dev \
       libgmp-dev \
       libmpc-dev \
       libmpfr-dev \
       libncurses5-dev \
       libncursesw5-dev \
       libpixman-1-dev \
       libtool \
       ninja-build \
       patchutils \
       python3 \
       texinfo \
       zlib1g-dev

debug "Installing required packages for build"

installPKG "${PACKAGES[@]}"

########################

debug "Creating: $BUILD_DIRECTORY"

mkdir --parents "$BUILD_DIRECTORY"

########################

debug "Changing directory to: $BUILD_DIRECTORY"

cd "$BUILD_DIRECTORY" || exit 1

########################

debug "Cloning: $NAME"

git clone "$RISCV_GNU_TOOLCHAIN"

########################

debug "Entering directory: $TOOLCHAIN_DIRECTORY"

cd "$TOOLCHAIN_DIRECTORY" || exit 1

########################

debug "Removing QEMU from Git"

git rm qemu

########################

debug "Updating sub-modules"

git submodule update --init --recursive

########################

debug "Configuring toolchain for output to: $PREFIX"

./configure --prefix="$PREFIX"

########################

debug "Making toolchain"

sudo make linux -j "$(nproc)"

########################

debug "Exporting toolchain binary location to PATH"

debug 'export PATH="$PATH:/opt/riscv64/bin"'

export PATH="$PATH:/opt/riscv64/bin"

debug "Add to ~/.bashrc to make it consistent"

########################

debug "Testing toolchain"

if command -v riscv64-unknown-linux-gnu-gcc &> /dev/null
then
  debug "Success! The toolchain is installed to: $PREFIX"
  debug 'Try it out with: riscv64-unknown-linux-gnu-gcc -v' 
else
  debug "Fail! The command for the toolchain did not work, something went wrong .."
  exit 1
fi

########################

debug "Returning to build directory: "

cd "$BUILD_DIRECTORY" || exit 1

debug "$NAME build is completed"

exit 0

