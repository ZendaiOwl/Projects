#!/usr/bin/env bash

# Batch creation of NextcloudPi image
#
# Copyleft 2017 by Ignacio Nunez Hernanz <nacho _a_t_ ownyourbits _d_o_t_ com>
# GPL licensed (see end of file) * Use at your own risk!
#
# Usage: ./batch.sh <DHCP QEMU image IP>
#

function add_build_variables
{
  [[ "$#" -ne 0 ]] && return 1
  declare -x -a BUILDVARIABLES; BUILDVARIABLES+=("$@")
  if [[ "${BUILDVARIABLES[@]}" != *"BUILDVARIABLES"* ]]; then add_build_variables BUILDVARIABLES
  fi
}

if [[ -z "$DBG" ]]; then set -e; elif [[ -v "$DBG" ]]; then set -e"$DBG"; fi

declare -x -g BUILDLIBRARY="${BUILDLIBRARY:./buildlib.sh}"; add_build_variables BUILDLIBRARY
declare -x -g LIBRARY="${LIBRARY:./library.sh}"; add_build_variables LIBRARY

if [[ ! -f "$BUILDLIBRARY" ]]; then printf '\e[1;31mERROR\e[0m %s\n' "File not found: $BUILDLIBRARY"; exit 1; fi

# shellcheck disable=SC1090
source "$LIBRARY"
# shellcheck disable=SC1090
source "$BUILDLIBRARY"

export PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:$PATH"

log -1 "Build"

URL="https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2022-09-26/2022-09-22-raspios-bullseye-arm64-lite.img.xz"
SIZE=4G                     # Raspbian image size
#CLEAN=0                    # Pass this envvar to skip cleaning download cache
IMG="${IMG:-NextcloudPi_RPi_$( date  "+%m-%d-%y" ).img}"
TAR=output/"$( basename "$IMG" .img ).tar.bz2"
ROOTDIR='raspbian_root'
BUILD_DIR='tmp/ncp-build'
BOOTDIR='raspbian_boot'
DSHELL='/bin/bash'
add_build_variables URL SIZE IMG TAR ROOTDIR BOOTDIR BUILD_DIR DSHELL
##############################################################################

function clean_build_sd_rpi
{
  clean_chroot_raspbian
  unset "${BUILDVARIABLES[@]}"
}

##############################################################################

if isFile "$TAR"; then log 1 "File exists: $TAR"; exit 0; fi
if findFullProcess qemu-arm-static; then log 2 "qemu-arm-static already running"; exit 1; fi
if findFullProcess qemu-aarch64-static; then log 2 "qemu-aarch64-static already running"; exit 1; fi
## preparations

IMG=tmp/"$IMG"

trap 'clean_build_sd_rpi' EXIT SIGHUP SIGILL SIGABRT

# Directories: tmp cache output
prepare_dirs
# Raspberry Pi OS 64Bit-lite
download_raspbian "$URL" "$IMG"
# Change size of ISO image
resize_image      "$IMG" "$SIZE"
# PARTUUID has changed after resize
update_boot_uuid  "$IMG"

# Make sure we don't accidentally disable first run wizard
if isDirectory 'ncp-web'; then
  if isRoot; then rm --force ncp-web/{wizard.cfg,ncp-web.cfg}
  else sudo rm --force ncp-web/{wizard.cfg,ncp-web.cfg}; fi
fi
## BUILD NCP

prepare_chroot_raspbian "$IMG"

if isRoot; then mkdir "$ROOTDIR"/"$BUILD_DIR"
else sudo mkdir "$ROOTDIR"/"$BUILD_DIR"; fi

# if isRoot; then rsync -Aax --exclude-from .gitignore --exclude *.img --exclude *.bz2 . "$ROOTDIR"/"$BUILD_DIR"
# else sudo rsync -Aax --exclude-from .gitignore --exclude *.img --exclude *.bz2 . "$ROOTDIR"/"$BUILD_DIR"; fi

# dpkg --remove-architecture armhf

if isRoot; then PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' \
  chroot "$ROOTDIR" "$DSHELL" <<'EOFCHROOT'
    set -ex

    # To build without armhf or arm64
    # dpkg --remove-architecture armhf
    useradd --home-dir /var/www --create-home \
            --uid 33 --user-group \
            --shell /bin/bash www-data
    mkdir --parents /var/lib/www
    
    apt-get install --quiet \
                    --assume-yes \
                    --no-show-upgraded \
                    --auto-remove=true \
                    --no-install-recommends \
                    bash git wget curl gnupg \
                    lsb-release pbzip2 lbzip2 \
                    psmisc procps jq coreutils \
                    ca-certificates apt-utils \
                    apt-transport-https cgroupfs-mount apparmor

    url --location --silent https://raw.githubusercontent.com/ZendaiOwl/Build/master/Bash/Docker/Nextcloud/ncp/Build/library.sh > /var/lib/www/library.sh
    # shellcheck disable=SC1090
    source /var/lib/www/library.sh

    chmod -R 0750 /var/lib/www
    chown -R www-data:www-data /var/lib/www

    mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update --assume-yes
    apt-get install --quiet \
                    --assume-yes \
                    --no-show-upgraded \
                    --auto-remove=true \
                    --no-install-recommends docker-ce \
                                            docker-ce-cli \
                                            containerd.io \
                                            docker-buildx-plugin \
                                            docker-compose-plugin
    groupadd docker
    # usermod --append --groups docker "$USER"
    usermod --append --groups docker www-data
    
    # this image comes without resolv.conf ??
    echo 'nameserver 1.1.1.1' >> /etc/resolv.conf

    # install NCP
    # cd /tmp/ncp-build || exit 1
    systemctl daemon-reload
    # CODE_DIR="$PWD" bash install.sh

    # work around dhcpcd Raspbian bug
    # https://lb.raspberrypi.org/forums/viewtopic.php?t=230779
    # https://github.com/nextcloud/nextcloudpi/issues/938
    # apt-get update --assume-yes
    # apt-get install --quiet \
    #                 --assume-yes \
    #                 --no-show-upgraded \
    #                 --auto-remove=true \
    #                 --no-install-recommends haveged
    # systemctl enable haveged.service

    # harden SSH further for Raspbian
    # sed -i 's|^#PermitRootLogin .*|PermitRootLogin no|' /etc/ssh/sshd_config

    # cleanup
    # source etc/library.sh && run_app_unsafe post-inst.sh
    rm /etc/resolv.conf
    # rm -rf /tmp/ncp-build
EOFCHROOT
else log 2 "Must be root"; exit 1; fi

if isRoot; then log -1 "Image created: $(basename $IMG)"; basename "$IMG" | tee "$ROOTDIR"/usr/local/etc/ncp-baseimage
else log -1 "Image created: $(sudo basename $IMG)"; sudo basename "$IMG" | sudo tee "$ROOTDIR"/usr/local/etc/ncp-baseimage
fi

clean_build_sd_rpi

trap - EXIT SIGHUP SIGILL SIGABRT SIGINT

## Pack IMG
[[ "$*" =~ .*"--pack".* ]] && { log -1 "Packing image"; pack_image "$IMG" "$TAR"; }

log 0 "Build is complete"; exit 0

## test

#set_static_IP "$IMG" "$IP"
#test_image    "$IMG" "$IP" # TODO fix tests

# upload
#create_torrent "$TAR"
#upload_ftp "$( basename "$TAR" .tar.bz2 )"


# License
#
# This script is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This script is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this script; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place, Suite 330,
# Boston, MA  02111-1307  USA
