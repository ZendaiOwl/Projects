#!/usr/bin/env bash
# 
# Victor-ray, S. <12261439+ZendaiOwl@users.noreply.github.com> https://github.com/ZendaiOwl
# 
# GNU Toolchain for RISC-V architecture
# 
# WARNING: git clone takes around 6.65 GB of disk and download size
# 
######################## (Debian)
#
# autoconf automake autotools-dev
# libmpc-dev libmpfr-dev libgmp-dev
# libtool zlib1g-dev libexpat-dev
# curl python3 gawk build-essential
# bison flex texinfo gperf patchutils bc
#
########################
#
# If you have started a new GitHub Codespace container, run the command below to successfully complete the build.
# sudo apt-get update -y && sudo apt-get install autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev
#
########################

function debug {
  local -r BLUE='\e[1;34m' Z='\e[0m'
  printf "${BLUE}INFO${Z} %s\n" "${*}"
}

function cleanup {
  unset CURRENT_DIR \
        BUILD_DIR \
        PATH_BINARY \
        TOYBOX BINARY_RISCV64_CROSS BINARY_RISCV64_NATIVE
}

########################
###### VARIABLES #######
########################

# LDFLAGS="--static" CROSS_COMPILE=riscv64-unknown-linux-musl- make defconfig toybox

# LDFLAGS="--static" CROSS_COMPILE=riscv64-linux-musl- make defconfig toybox

# PREFIX="$PWD/root/riscv64/fs/bin" make install_flat

# make root PREFIX="$PWD/root/riscv64/fs/bin" CROSS_COMPILE=riscv64-unknown-linux-musl- LINUX=./linux
# make root CROSS_COMPILE=riscv64-unknown-linux-musl- LINUX="$PWD/linux"

# make root PREFIX="$PWD/root/riscv64/fs/bin" CROSS_COMPILE=riscv64-linux-musl- LINUX=./linux ARCH=riscv
# make root PREFIX="$PWD/root/riscv64/fs/bin" CROSS_COMPILE=riscv64-linux-musl-
# make root CROSS_COMPILE=riscv64-linux-musl- CROSS=riscv64
# make root CROSS_COMPILE=riscv64-linux-musl- LINUX="$PWD/linux"

# make root PREFIX="$PWD/root/riscv64/fs/bin" LDFLAGS="--static" CROSS_COMPILE=riscv64-linux-musl- LINUX=./linux ARCH=riscv

# scripts/mkroot.sh CROSS=riscv64
# scripts/mkroot.sh CROSS=riscv64 LINUX=./linux dropbear
# scripts/mkroot.sh CROSS_COMPILE=riscv64-unknown-linux-musl- CROSS=riscv64 LINUX=./linux dropbear
# scripts/mkroot.sh CROSS_COMPILE=riscv64-linux-musl- CROSS=riscv64 LINUX=./linux dropbear

# LDFLAGS="--static" ARCH=riscv CROSS_COMPILE=riscv64-linux-musl- LINUX=./linux make defconfig toybox
# LDFLAGS="--static" ARCH=riscv CROSS_COMPILE=riscv64-linux-musl- LINUX=./linux make toybox -j "$(nproc)"
# LDFLAGS="--static" ARCH=riscv CROSS_COMPILE=riscv64-linux-musl- LINUX=./linux make install toybox -j "$(nproc)"

# LDFLAGS="--static" CROSS_COMPILE=riscv64-linux-musl- make

# CROSS_COMPILE=riscv64-linux-musl- LINUX=./linux PREFIX=./root/riscv64/fs/bin make install_flat

# CROSS_COMPILE=riscv64-linux-musl- PREFIX=./root/riscv64/fs/bin make install_flat

# LDFLAGS="--static" CROSS_COMPILE=riscv64-linux-musl- make defconfig
# LDFLAGS="--static" CROSS_COMPILE=riscv64-linux-musl- make -j "$(nproc)"
# LDFLAGS="--static" CROSS_COMPILE=riscv64-linux-musl- make install -j "$(nproc)"

# make -j "$(nproc)" root PREFIX="$PWD/root/riscv64/fs/bin" CROSS_COMPILE=riscv64-linux-musl- LINUX=./linux

# sudo CROSS_COMPILE=riscv64-linux-musl- LDFLAGS=--static make -C toybox/ install CONFIG_PREFIX=../rootfs
# sudo CROSS_COMPILE=riscv64-unknown-linux-musl- LDFLAGS=--static make -C toybox/ install CONFIG_PREFIX=../rootfs

# sudo CROSS_COMPILE=riscv64-linux-gnu- LDFLAGS=--static make -C busybox-1.36.0/ install CONFIG_PREFIX=../rootfs

# qemu-system-riscv64 -nographic -machine virt -kernel linux/arch/riscv/boot/Image -append "root=/dev/vda ro console=ttyS0" -drive file=box,format=raw,id=hd0 -device virtio-blk-device,drive=hd0 -netdev user,id=eth0 -device virtio-net-device,netdev=eth0

# sudo apt-get install build-essential g++ git autoconf automake autotools-dev texinfo bison xxd curl flex gawk gdisk gperf libgmp-dev libmpfr-dev libmpc-dev libz-dev libssl-dev libncurses-dev libtool patchutils python3 screen texinfo unzip zlib1g-dev libyaml-dev wget cpio bc dosfstools mtools device-tree-compiler libglib2.0-dev libpixman-1-dev kpartx
# libncurses-dev libssl-dev bc flex bison gcc-riscv64-linux-gnu build-essential ccache cpio fakeroot flex git kmod libelf-dev libncurses5-dev libssl-dev lz4 qtbase5-dev rsync schedtool wget zstd pahole dwarves

# CROSS_COMPILE=riscv64-riscv64-unknown-linux-musl- LDFLAGS=--static make defconfig
# CROSS_COMPILE=riscv64-unknown-linux-musl- LDFLAGS=--static make -j$(nproc)

# CROSS_COMPILE=riscv64-linux-musl- LDFLAGS=--static make defconfig
# CROSS_COMPILE=riscv64-linux-musl- LDFLAGS=--static make -j$(nproc)

# ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-musl- make defconfig -j "$(nproc)"
# ARCH=riscv CROSS_COMPILE=riscv64-linux-musl- make defconfig -j "$(nproc)"
# make ARCH=riscv CROSS_COMPILE=

# ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-musl- make defconfig -j "$(nproc)"
# ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-musl- make -j "$(nproc)"
# ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-musl- make install -j "$(nproc)"

# ARCH=riscv CROSS_COMPILE=riscv64-linux-musl- make defconfig -j "$(nproc)"
# ARCH=riscv CROSS_COMPILE=riscv64-linux-musl- make -j "$(nproc)"
# ARCH=riscv CROSS_COMPILE=riscv64-linux-musl- make install -j "$(nproc)"

# binutils	2.38
# gcc	11.3.0
# gdb	11.2
# linux-headers	5.4.212
# musl	1.2.3

# https://toolchains.bootlin.com/downloads/releases/toolchains/riscv64-lp64d/tarballs/riscv64-lp64d--musl--stable-2022.08-1.tar.bz2

CURRENT_DIR="$PWD"
BUILD_DIR="${CURRENT_DIR}/toybox"
PATH_BINARY="${BUILD_DIR}/ccc/riscv64/bin"
TOYBOX='https://github.com/landley/toybox'
BINARY_RISCV64_CROSS='https://musl.cc/riscv64-linux-musl-cross.tgz'
BINARY_RISCV64_NATIVE='https://musl.cc/riscv64-linux-musl-native.tgz'

#export PATH="${PATH_BINARY}:${PATH}"

########################

trap 'cleanup' EXIT SIGHUP SIGILL SIGABRT

#######################################################################
# WARNING: 'git clone' takes around 6.65 GB of disk and download size #
#######################################################################

debug "Cloning Toybox"

git clone "$TOYBOX"

########################

debug "Changing directory to $BUILD_DIR"

cd "$BUILD_DIR" || exit 1

########################
# Use Source Tree Other Than riscv-gnu-toolchain
# https://github.com/riscv-collab/riscv-gnu-toolchain#use-source-tree-other-than-riscv-gnu-toolchain
# 
# riscv-gnu-toolchain also support using out-of-tree source to build toolchain, there is couple configure option to specify the source tree of each submodule/component.
# For example you have a gcc in $HOME/gcc, use --with-gcc-src can specify that:
# 
# ./configure --with-gcc-src=$HOME/gcc
#
########################
# Here is the list of configure option for specify source tree:
# 
# --with-gcc-src
# --with-binutils-src
# --with-newlib-src
# --with-glibc-src
# --with-musl-src
# --with-gdb-src
# --with-linux-headers-src
# --with-qemu-src
# --with-spike-src
# --with-pk-src
#
########################
# make musl = Musl libc 
# make linux = GNU glibc
########################
# ../riscv64/bin/riscv64-unknown-linux-musl-gcc
# riscv64-unknown-linux-musl

mkdir --parents ccc

cd ccc || exit 1

wget "$BINARY_RISCV64_CROSS"

wget "$BINARY_RISCV64_NATIVE"


########################

debug "Finished"

########################

