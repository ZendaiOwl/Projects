#!/usr/bin/env bash
# × × × × × × × × × × × × × × × × × × #
# shellcheck disable=SC1073
# shellcheck disable=SC2188
# 
# [Modified the Musl-Cross-Make by Rich Felker](https://github.com/richfelker/musl-cross-make)
# This is the second generation of musl-cross-make, a fast, simple, but advanced makefile-based approach for producing musl-targeting cross compilers
#
# Victor-ray, S. <12261439+ZendaiOwl@users.noreply.github.com> https://github.com/ZendaiOwl
#

if [[ "$EUID" -ne 0 ]]
then
  debug "Please run as root or with sudo"
  exit 1
fi

function debug {
  local -r BLUE='\e[1;34m' Z='\e[0m'
  printf "${BLUE}INFO${Z} %s\n" "${*}"
}

########################
###### VARIABLES #######
########################

MUSL_CROSS_MAKE='https://github.com/richfelker/musl-cross-make'
TARGET='riscv64-linux-musl'
MUSL_NAME='musl-cross-make'
CONFIG_NAME='config.mak'
OUTPUT_NAME='output'
BUILD_NAME='build'
START_DIR='/home/owl/Code/Musl'
OPTDIR='/opt/riscv64'
CURRENT_DIRECTORY="$PWD"
CONFIG_MAKE_FILE="$CURRENT_DIRECTORY/$CONFIG_NAME"
BUILD_DIRECTORY="$CURRENT_DIRECTORY/$BUILD_NAME"
#OUTPUT_DIRECTORY="/opt/$OUTPUT_NAME"
MUSL_DIRECTORY="$BUILD_DIRECTORY/$MUSL_NAME"
OUTPUT_DIRECTORY="$MUSL_DIRECTORY/$OUTPUT_NAME"
LOCAL_CONFIG_MAKE="./$CONFIG_NAME"
CLONED_CONFIG_MAKE="./${CONFIG_NAME}.dist"

function cleanup {
  debug "Cleanup"
  debug "Removing: $BUILD_NAME"
  sudo rm -R "$BUILD_DIRECTORY"
  debug "Unset variables"
  unset MUSL_CROSS_MAKE \
        TARGET \
        CURRENT_DIRECTORY \
        BUILD_DIRECTORY \
        OUTPUT_DIRECTORY \
        CONFIG_MAKE_FILE \
        MUSL_DIRECTORY \
        LOCAL_CONFIG_MAKE \
        MUSL_NAME \
        CONFIG_NAME \
        OUTPUT_NAME \
        BUILD_NAME \
        CLONED_CONFIG_MAKE \
        START_DIR \
        OPTDIR
  debug "Done"
}

########################

trap 'cleanup' EXIT SIGHUP SIGILL SIGABRT

########################

if [[ "${PWD##*/}" -eq "$MUSL_NAME" ]]
then
  debug "Current directory is: $MUSL_NAME"
elif [[ -d "$PWD/$MUSL_NAME" ]]
then
  debug "Directory found: $MUSL_NAME"
else
  debug "Directory not found: $MUSL_NAME"
  debug "Cloning repository"
  
fi

debug "Creating: $BUILD_DIRECTORY"

mkdir --parents "$BUILD_DIRECTORY"

########################

debug "Changing directory to: $BUILD_DIRECTORY"

cd "$BUILD_DIRECTORY" || exit 1

########################

debug "Cloning: musl-cross-make"

git clone "$MUSL_CROSS_MAKE"

########################

debug "Copying: $CONFIG_MAKE_FILE to $MUSL_DIRECTORY"

cp "$CONFIG_MAKE_FILE" "$MUSL_DIRECTORY"

########################

debug "Changing directory to: $MUSL_DIRECTORY"

cd "$MUSL_DIRECTORY" || exit 1

debug "Removing: $CLONED_CONFIG_MAKE"

rm "$CLONED_CONFIG_MAKE"

########################

debug "Changing ISL mirror site to a responsive server"

sed -i 's|ISL_SITE = http://isl.gforge.inria.fr/|ISL_SITE = https://gcc.gnu.org/pub/gcc/infrastructure/|g' "./Makefile"

########################
# To compile, run 'make'. 
# To install to $(OUTPUT), run 'make install'.
# The default value for $(OUTPUT) is 'output'
# After installing here you can move the cross compiler toolchain to another location as desired.
########################

debug "Setting target architecture to: $TARGET"

sed -i '31a TARGET = '"$TARGET"'' "$LOCAL_CONFIG_MAKE"

########################

debug "Setting output directory to: $OUTPUT_DIRECTORY"

sed -i '32a OUTPUT = '"$OUTPUT_DIRECTORY"'' "$LOCAL_CONFIG_MAKE"

########################

debug "Make: musl-cross-compiler RISC-V64"

#make musl -j "$(nproc)"
make -j "$(nproc)"

debug "Done"

########################

debug "Install: musl-cross-compiler to $OUTPUT_DIRECTORY"

make -j "$(nproc)" install

debug "Done"

########################

debug "Moving toolchain to: $OPTDIR"

sudo mv "$OUTPUT_DIRECTORY" "$OPTDIR"

########################

debug "Returning to starting directory: $START_DIR"

cd "$START_DIR" || exit 1

########################

exit 0
