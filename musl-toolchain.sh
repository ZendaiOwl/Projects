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
        LLVM_CLANG_TOOLCHAIN \
        LLVM_RELEASE_VERSION \
        PREFIX \
        CURRENT_DIRECTORY \
        WORKSPACE_DIRECTORY \
        KERNEL_DIRECTORY \
        BUILD_DIRECTORY \
        TOOLCHAIN_DIRECTORY \
        LLVM_DIRECTORY \
        LLVM_BUILD_DIRECTORY \
        LLVM_CLANG_DIRECTORY \
        QEMU_URL \
        QEMU_TAR \
        QEMU_DIRECTORY \
        QEMU_TARGET \
        QEMU_PREFIX \
        ANDROID_COMMON_DIRECTORY \
        ANDROID_COMMON_CHECKOUT \
        ANDROID_CONFIGS_DIRECTORY \
        ANDROID_CONFIGS_CHECKOUT \
        NAME_TOOLCHAIN \
        NAME_LLVM \
        NAME_QEMU
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
LLVM_CLANG_TOOLCHAIN='https://github.com/llvm/llvm-project'

#LLVM_RELEASE_VERSION='release/16.x'
LLVM_RELEASE_VERSION='release/10.x'

PREFIX='/opt/riscv64'
CURRENT_DIRECTORY="$PWD"
WORKSPACE_DIRECTORY="${CURRENT_DIRECTORY}/build"
BUILD_DIRECTORY="${WORKSPACE_DIRECTORY}/riscv64"
KERNEL_DIRECTORY="${WORKSPACE_DIRECTORY}/kernel"
TOOLCHAIN_DIRECTORY="${BUILD_DIRECTORY}/riscv-gnu-toolchain"

LLVM_DIRECTORY="${BUILD_DIRECTORY}/llvm-project"
LLVM_BUILD_DIRECTORY="${LLVM_DIRECTORY}/build"
LLVM_CLANG_DIRECTORY="${LLVM_DIRECTORY}/install/bin"

QEMU_URL='https://download.qemu.org/qemu-5.1.0.tar.xz'
QEMU_TAR='qemu-5.1.0.tar.xz'
QEMU_DIRECTORY="${BUILD_DIRECTORY}/qemu-5.1.0"

QEMU_TARGET='riscv64-softmmu'
QEMU_PREFIX='/opt/qemu'

ANDROID_COMMON_DIRECTORY="${KERNEL_DIRECTORY}/common"

ANDROID_COMMON_CHECKOUT='deprecated/android-5.4-stable'

ANDROID_CONFIGS_DIRECTORY="${KERNEL_DIRECTORY}/configs"

ANDROID_CONFIGS_CHECKOUT='android11-release'

NAME_TOOLCHAIN='RISC-V GNU Compiler Toolchain'
NAME_LLVM='LLVM/Clang Toolchain'
NAME_QEMU='QEMU'

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
       binfmt-support \
       binutils \
       clang \
       curl \
       flex \
       gawk \
       git \
       gperf \
       lld \
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
       libssl-dev \
       ninja-build \
       patchutils \
       python3 \
       texinfo \
       zlib1g-dev

# btrfs-progs dosfstools exfat-utils udisks2

debug "Installing required packages for build"

installPKG "${PACKAGES[@]}"

########################

########################
######## BUILD #########
########################

debug "Creating: $WORKSPACE_DIRECTORY"

mkdir --parents "$WORKSPACE_DIRECTORY"

########################

debug "Creating: $BUILD_DIRECTORY"

mkdir --parents "$BUILD_DIRECTORY"

########################

debug "Changing directory to: $BUILD_DIRECTORY"

cd "$BUILD_DIRECTORY" || exit 1

########################

########################
# RISC-V GNU TOOLCHAIN #
########################

debug "Cloning: $NAME_TOOLCHAIN"

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

sudo make musl -j "$(nproc)"

########################

debug "Exporting toolchain binary location to PATH"

debug 'export PATH="$PATH:/opt/riscv64/bin"'

export PATH="$PATH:/opt/riscv64/bin"

debug "Add to ~/.bashrc to make it consistent"

########################

debug "Testing toolchain"

if command -v riscv64-unknown-linux-musl-gcc &> /dev/null
then
  debug "Success! The toolchain is installed to: $PREFIX"
  debug 'Try it out with: riscv64-unknown-linux-musl-gcc -v' 
else
  debug "Fail! The command for the toolchain did not work, something went wrong .."
  exit 1
fi

########################

debug "Returning to build directory: "

cd "$BUILD_DIRECTORY" || exit 1

debug "$NAME_TOOLCHAIN build is completed"

########################

########################
# LLVM/CLANG TOOLCHAIN #
########################

debug "Starting next build step for: $NAME_LLVM"

########################

debug "Cloning: $LLVM_CLANG_TOOLCHAIN"

git clone "$LLVM_CLANG_TOOLCHAIN"

########################

debug "Moving into directory: $LLVM_DIRECTORY"

cd "$LLVM_DIRECTORY" || exit 1

########################

debug "Git checkout the version to build: $LLVM_RELEASE_VERSION"

git checkout "$LLVM_RELEASE_VERSION"

########################

debug "Creating build directory: $LLVM_BUILD_DIRECTORY"

mkdir --parents "$LLVM_BUILD_DIRECTORY"

########################

debug "Moving into directory: $LLVM_BUILD_DIRECTORY"

cd "$LLVM_BUILD_DIRECTORY" || exit 1

########################

debug "Starting build of: $NAME_LLVM"

debug "CMake"

cmake -G "Unix Makefiles" \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=../install \
-DLLVM_TARGETS_TO_BUILD="RISCV" \
-DLLVM_ENABLE_PROJECTS="clang;libcxx;libcxxabi" \
-DLLVM_DEFAULT_TARGET_TRIPLE="riscv64-unknown-linux-musl" \
../llvm

########################

debug "Make"

make -j "$(nproc)"

########################

debug "Make install"

make install

########################

debug "Testing so the built clang works"

../install/bin/clang -v

if command -v ../install/bin/clang &> /dev/null
then
  debug "Success! Exporting the built LLVM clang toolchain"
  export "$LLVM_CLANG_DIRECTORY:$PATH"
  export "${LLVM_CLANG_DIRECTORY}/clang:$PATH"
else
  debug "Fail!"
  exit 1
fi

########################

debug "Returning to: $BUILD_DIRECTORY"

cd "$BUILD_DIRECTORY" || exit 1

########################

########################
######## QEMU ##########
########################

debug "Starting build of: $NAME_QEMU"

wget "$QEMU_URL"

tar xvJf "$QEMU_TAR"

cd "$QEMU_DIRECTORY" || exit 1

./configure --target-list="$QEMU_TARGET" --prefix="$QEMU_PREFIX"

make -j "$(nproc)"

sudo make install

export PATH="/opt/qemu:$PATH"
export PATH="/opt/qemu/bin:$PATH"

qemu-system-riscv64 --version

########################
#### ANDROID KERNEL ####
########################

cd "$WORKSPACE_DIRECTORY" || exit 1

mkdir --parents "$KERNEL_DIRECTORY"

cd "$KERNEL_DIRECTORY" || exit 1

git clone https://android.googlesource.com/kernel/common

cd "$ANDROID_COMMON_DIRECTORY" || exit 1

git checkout "$ANDROID_COMMON_CHECKOUT"

cd "$KERNEL_DIRECTORY" || exit 1

git clone https://android.googlesource.com/kernel/configs

cd "$ANDROID_CONFIGS_DIRECTORY" || exit 1

git checkout "$ANDROID_CONFIGS_CHECKOUT"

cd "$ANDROID_COMMON_DIRECTORY" || exit 1

make ARCH=riscv distclean

git checkout "$ANDROID_COMMON_CHECKOUT"

ARCH=riscv scripts/kconfig/merge_config.sh arch/riscv/configs/defconfig ../configs/r/android-5.4/android-base.config

make ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-musl- -j "$(nproc)"


git clone https://gitee.com/aosp-riscv-bionic-porting/port_bionic

cd port_bionic/

git checkout develop

git submodule init

git submodule update --progress




########################
##### BUILD SYSTEM #####
########################

