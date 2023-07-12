#!/usr/bin/env bash
# Victor-ray, S <12261439+ZendaiOwl@users.noreply.github.com>

# Test for root permissions, exit if not available
if [[ ! "$EUID" -eq 0 ]]; then
  printf '\e[1;31mSTOP\e[0m %s\n' "Please run the script as root or with sudo"; exit 1; fi

########################
####### Cleanup ########
########################

# A cleanup function for the variables used
function unsetSetupVariables {
  log -1 "Cleaning up variables"
  unset RAW_URL OWNER REPO BRANCH SCRIPT_PATH GH_LIB \
        LIBRARY DEVELOPMENT PACKAGES OPTSTRING
  log 0 "Done!"
}

########################
###### VARIABLES #######
########################

RAW_URL='https://raw.githubusercontent.com'
OWNER="${OWNER:-ZendaiOwl}"
REPO="${REPO:-Build}"
BRANCH="${BRANCH:-master}"
SCRIPT_PATH="${SCRIPT_PATH:-Bash/Libs/lib.sh}"
GH_LIB="${RAW_URL}/${OWNER}/${REPO}/${BRANCH}/${SCRIPT_PATH}"
LIBRARY="${LIBRARY:-../Libs/lib.sh}"
DEVELOPMENT="${DEVELOPMENT:-no}"
PACKAGES=()
OPTSTRING=":d:h:l:p"

########################
###### FUNCTIONS #######
########################

# Shows options/usage
function usage {
  local HELPTEXT=("./$(basename "$0") [OPTIONS]")
        HELPTEXT+=("OPTIONS")
        HELPTEXT+=("No options: Installs with default configuration")
        HELPTEXT+=("-h) Shows this help message")
        HELPTEXT+=("-d) Development installation [yes|default=no], can also be set with a DEVELOPMENT environment variable")
        HELPTEXT+=("-l) Path to library functions location")
        HELPTEXT+=("-p) Package(s) to add for installation, use \"\" for more than one package")
  printf '\e[1;34mINFO\e[0m %s\n' "${HELPTEXT[0]}"
  printf '\t%s\n' "${HELPTEXT[@]:1}"
  exit 0
}

# See if curl exists else install it
function testForCurl {
  printf '\e[1;34mINFO\e[0m %s\n' "Test if curl is installed"
  if ! command -v curl &> /dev/null; then
    local -r OPTIONS=(--assume-yes --quiet --no-show-upgraded --auto-remove=true --no-install-recommends)
    printf '\e[1;34mINFO\e[0m %s\n' "Installing: curl"
    apt update --assume-yes
    if DEBIAN_FRONTEND=noninteractive apt install "${OPTIONS[@]}" curl; then
      printf '\e[1;33mSUCCESS\e[0m %s\n' "Installed: curl"
    else printf '\e[1;31mERROR\e[0m %s\n' "Something went wrong during installation"; exit 1; fi
  else printf '\e[1;34mINFO\e[0m %s\n' "Already installed"; fi
}

# Sets development installation: yes or no
function setDevelopment {
  if [[ "$#" -ne 1 ]]
  then
    log 2 "Missing argument(s)"
    exit 1
  else
    local -r OPT="$1"
    if [[ "${OPT,,}" == "yes" ]]
    then
      log -1 "Development installation: Yes"
      DEVELOPMENT="yes"
    elif [[ "${OPT,,}" == "no" ]]
    then
      log -1 "Development installation: No"
      DEVELOPMENT="no"
    else
      log 2 "Invalid option for development installation: $OPT"
      printf '\t%s\n' "Option must be: 'Yes' or 'No'"
      exit 1
    fi
  fi
}

# Sets the functions library file 
function setLibrary {
  if [[ ! -e "$1" ]]; then
    log 2 "No such path: $1"; exit 1
  elif [[ ! -f "$1" ]]; then log 2 "Not a file: $1"; exit 1
  else LIBRARY="$1"; fi
}

# Adds packages for installation
function addPackages {
  if [[ "$#" -lt 1 ]]; then
    log 2 "Missing package argument(s)"; exit 1
  else declare -x -a PACKAGES+=("$@")
       #IFS=' ' read -ra ADDPKG <<<"$@"
       log -1 "Adding package(s) for installation: ${PACKAGES[*]}"
       #for PKG in "${ADDPKG[@]}"; do
       #  PACKAGES+=("$PKG")
       #done; fi
}

function getDockerGPGKey {
  local -r URL='https://download.docker.com/linux/debian/gpg' \
           LOCATION='/etc/apt/keyrings/docker.gpg'
  log -1 "Fetching Docker repository's GPG key"
  curl --fail --silent --location --show-error "$URL" | gpg --dearmor -o "$LOCATION"
}

function setupDockerSourcesList {
  local -r GPGKEY="/etc/apt/keyrings/docker.gpg" \
           URL="https://download.docker.com/linux/debian" \
           LIST='/etc/apt/sources.list.d/docker.list'
  local ARCH RELEASE
  ARCH="$(dpkg --print-architecture)"
  RELEASE="$(lsb_release -cs)"
  log -1 "Creating Docker repository sources list: $LIST"
  printf '%s\n' "deb [arch=$ARCH signed-by=$GPGKEY] $URL $RELEASE stable" | tee "$LIST" > /dev/null
  log 0 "Docker repository sources list is created: $LIST"
}

function generate_docker-compose
{
  declare -r -x -g COMPOSE_FILE="${1:-/var/www/compose.yml}"
  cat > "$COMPOSE_FILE" <<'EOF'
version: '3.7'
services:
  db:
    image: mariadb:10.5
    restart: always
    command: --transaction-isolation=READ-COMMITTED --log-bin=mysqld-bin --binlog-format=ROW
#    network_mode: bridge
#    networks:
#      - dual-stack
    volumes:
      - db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD"
      - MYSQL_PASSWORD="$MYSQL_PASSWORD"
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud

  app:
    image: nextcloud:fpm-alpine
    restart: always
    links:
      - db
#    network_mode: bridge
#    networks:
#      - dual-stack
    volumes:
      - nextcloud:/var/www/html
    environment:
      - MYSQL_PASSWORD="$MYSQL_PASSWORD"
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_HOST=db
      # See: https://hub.docker.com/_/nextcloud/
      - APACHE_DISABLE_REWRITE_IP=1
      # See: https://github.com/nextcloud/documentation/issues/7005
      # and: https://old.reddit.com/r/NextCloud/comments/s3skdn/nextcloud_behind_caddy_as_a_reverse_proxy_using/hsnj5wh/
      - TRUSTED_DOMAINS="$IP"
#     - TRUSTED_DOMAINS="$WEB-IP"
      - TRUSTED_DOMAINS="$DOMAIN"
      - TRUSTED_PROXIES="$DOCKER-GATEWAY"
      - TRUSTED_PROXIES=127.0.0.1
      - TRUSTED_PROXIES=web
    links:
      - db

    # see: https://github.com/nextcloud/documentation/blob/master/admin_manual/configuration_server/reverse_proxy_configuration.rst  
    labels:
      # caddy: 192.xx.xxx.xx:8080
      caddy.reverse_proxy: "{{upstreams}}"
      # see: https://github.com/lucaslorentz/caddy-docker-proxy/issues/114
      caddy.header: /*
      # see: https://docs.nextcloud.com/server/23/admin_manual/installation/harden_server.html#enable-http-strict-transport-security
      caddy.header.Strict-Transport-Security: '"max-age=15552000;"'
      # see: https://docs.nextcloud.com/server/23/admin_manual/issues/general_troubleshooting.html#service-discovery
      # https://github.com/lucaslorentz/caddy-docker-proxy/issues/222
      caddy.rewrite_0: /.well-known/carddav /remote.php/dav
      caddy.rewrite_1: /.well-known/caldav /remote.php/dav

  web:
    image: zendai/caddy:2.6.2
    ports:
#      - 80:80
#      - 443:443
      - 8080:80
      - 8443:443
    links:
      - app
#    network_mode: bridge
#    networks:
#      - dual-stack
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy_data:/data
#      - /var/run/docker.sock:/var/run/docker.sock
    volumes_from:
      - app
    restart: always

#networks:
#  dual-stack:
#    external: true

volumes:
  db:
  nextcloud:
  caddy_data: {}

EOF

}

function generate_Caddyfile
{
  declare -r -x -g CADDYFILE="${1:-/var/www/Caddyfile}"
  cat > "$CADDYFILE" <<'EOF'
{
	# email 
	# http_port 80
	# https_port 443
	# skip_install_trust
	# debug
  local_certs
	# auto_https off
  # Development certificates from letsencrypt, not as rate-limited as the regular one
	acme_ca https://acme-staging-v02.api.letsencrypt.org/directory
	log {
		format json {
			message_key msg
			level_key level
			time_key ts
			name_key name
		}
	}
  servers {
    protocols h1 h2 h2c h3
    strict_sni_host insecure_off
  }
}

:80 {
	redir /.well-known/carddav /remote.php/dav 301
	redir /.well-known/caldav /remote.php/dav 301

	header {
		# enable HSTS
		# Strict-Transport-Security max-age=31536000;
	}

	# .htaccess / data / config / ... shouldn't be accessible from outside
	@forbidden {
		path /.htaccess
		path /data/*
		path /config/*
		path /db_structure
		path /.xml
		path /README
		path /3rdparty/*
		path /lib/*
		path /templates/*
		path /occ
		path /console.php
	}
	respond @forbidden 404

	root * /var/www/html
	php_fastcgi app:9000
	file_server
}

# For local IP to work with HTTPS & HSTS,
# the local IP of the device & the IP of the Docker container,
# is required to be added after the port ':443'
:443 192.168.178.12 172.12.1.4 {
	redir /.well-known/carddav /remote.php/dav 301
	redir /.well-known/caldav /remote.php/dav 301

	header {
		enable HSTS
		Strict-Transport-Security max-age=15552000;
		# Strict-Transport-Security max-age=31536000;
	}

	# .htaccess / data / config / ... shouldn't be accessible from outside
	@forbidden {
		path /.htaccess
		path /data/*
		path /config/*
		path /db_structure
		path /.xml
		path /README
		path /3rdparty/*
		path /lib/*
		path /templates/*
		path /occ
		path /console.php
	}
	respond @forbidden 404

	root * /var/www/html
	php_fastcgi app:9000
	file_server
}
EOF
}

function generate_environment_file
{
  declare 
}

function setup_bashrc_root
{
  cat > /root/.bashrc <<'EOF'
# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "$(dircolors)"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'


function getDockerGPGKey {
  local -r URL='https://download.docker.com/linux/debian/gpg' \
           LOCATION='/etc/apt/keyrings/docker.gpg'
  log -1 "Fetching Docker repository's GPG key"
  curl --fail --silent --location --show-error "$URL" | gpg --dearmor -o "$LOCATION"
}

function setupDockerSourcesList {
  local -r GPGKEY="/etc/apt/keyrings/docker.gpg" \
           URL="https://download.docker.com/linux/debian" \
           LIST='/etc/apt/sources.list.d/docker.list'
  local ARCH RELEASE
  ARCH="$(dpkg --print-architecture)"
  RELEASE="$(lsb_release -cs)"
  log -1 "Creating Docker repository sources list: $LIST"
  printf '%s\n' "deb [arch=$ARCH signed-by=$GPGKEY] $URL $RELEASE stable" | tee "$LIST" > /dev/null
  log 0 "Docker repository sources list is created: $LIST"
}


EOF

}

function runDockerInDocker
{
  # /my/own/var-lib-docker:/var/lib/docker
  docker run --privileged --name dind -v /var/lib/docker:/var/lib/docker -d docker:dind
}

function installDockerCredentialPass {
  local -r URL='https://github.com/docker/docker-credential-helpers/releases/download/v0.7.0/docker-credential-pass-v0.7.0.linux-amd64' \
           DCPLONG='docker-credential-pass-v0.7.0.linux-amd64' \
           NAME='docker-credential-pass' 
  local -r USR_PATH="/usr/local/bin/$NAME" ROOT_PATH="/usr/bin/$NAME"
  log -1 "Installing: $NAME"
  wget "$URL"
  chmod +x "$DCPLONG"
  mv    "$DCPLONG"  "$USR_PATH"
  chown "$USER"     "$USR_PATH"
  cp    "$USR_PATH" "$ROOT_PATH"
  chown root        "$ROOT_PATH"

  # Test so it works
  if ! hasCMD docker-credential-pass &> /dev/null
  then
    log 2 "Installation failed: ${NAME^}"
    exit 1
  else
    log 0 "Installed: ${NAME^}"
    log 1 "Don't forget to init pass with a gpg key"
  fi
}

function installMicro {
  local -r URL='https://getmic.ro' \
           USR_PATH='/usr/local/bin' \
           ROOT_PATH='/usr/bin' \
           NAME='micro'
  log -1 "Installing: $NAME"
  curl "$URL" | bash
  mv micro "$USR_PATH"/"$NAME"
  chown "$USER" "$USR_PATH"/"$NAME"
  cp "$USR_PATH"/"$NAME" "$ROOT_PATH"/"$NAME"
  chown root "$ROOT_PATH"/"$NAME"
  if ! hasCMD micro &> /dev/null
  then
    log 2 "Installation failed: ${NAME^}"
    exit 1
  else
    log 0 "Installed: ${NAME^}"
  fi
}

function installEget {
  local -r URL='https://zyedidia.github.io/eget.sh' \
           NAME='eget' \
           USR_PATH='/usr/local/bin' \
           ROOT_PATH='/usr/bin' \
           SCRIPT='eget.sh'
  curl -o "$SCRIPT" "$URL"
  bash "$SCRIPT"
  
  mv eget "$USR_PATH"/"$NAME"
  chown "$USER" "$USR_PATH"/"$NAME"
  
  cp "$USR_PATH"/"$NAME" "$ROOT_PATH"/"$NAME"
  chown root "$ROOT_PATH"/"$NAME"

  rm "$SCRIPT"

  if ! hasCMD eget &> /dev/null
  then
    log 2 "Installation failed: ${NAME^}"
    exit 1
  else
    log 0 "Installed: ${NAME^}"
  fi
}

# shellcheck disable=SC2016
function installGolang {
  local -r URL='https://go.dev/dl/go1.19.5.linux-amd64.tar.gz' \
           NAME='Go'
           DIR='/usr/local' \
           GODIR='/usr/local/go' \
           GOTAR='go1.19.5.linux-amd64.tar.gz' \
           CONFIGBASHRC='
if [[ -d /usr/local/go ]]
then
  PATH="/usr/local/go/bin:$PATH"
  export PATH
fi
'

  log -1 "Installing: $NAME"
  
  wget "$URL"
  rm --recursive --force "$GODIR" \
     && tar -C "$DIR" -xzf "$GOTAR" \
     && rm "$GOTAR"
  
  cat "$CONFIGBASHRC" >> "$HOME/.bashrc"
  # shellcheck disable=SC1090
  source "$HOME/.bashrc"

  if ! hasCMD go &> /dev/null; then log 2 "Installation failed: $NAME"; exit 1
  else log 0 "Installed: $NAME"; fi
}

trap 'unsetSetupVariables' EXIT SIGHUP SIGILL SIGABRT

########################
#### SOURCE LIBRARY ####
########################

# See if curl exists else install it
testForCurl

# shellcheck disable=SC1090
if [[ -f "$LIBRARY" ]]; then source "$LIBRARY"
else source <(curl --silent --location "$GH_LIB"); fi

########################
#### INSTALLATION ######
########################

while getopts "${OPTSTRING}" ARG; do
  case "$ARG" in
    d) setDevelopment "$OPTARG" ;;
    h) usage                    ;;
    l) setLibrary     "$OPTARG" ;;
    p) addPackages    "$OPTARG" ;;
    :) log 2 "$0: No argument provided to -$OPTARG" >&2 && exit 1 ;;
    ?) log 2 "Invalid option: $OPTARG" && exit 2 ;;
  esac
done

########################
### DEFAULT PACKAGES ###
########################

# Default packages
addPackages apt-utils \
            apt-transport-https \
            binutils \
            ca-certificates \
            gawk \
            git \
            gnupg \
            inxi \
            jq \
            lsb-release \
            pass \
            pbzip2 \
            procps \
            psmisc \
            ssh \
            texinfo \
            unzip \
            wget \
            xz-utils \
            zip
            
########################
# DEVELOPMENT PACKAGES #
########################

# Development packages
if [[ "$DEVELOPMENT" == "yes" ]]; then
    addPackages autoconf \
                automake \
                autotools-dev \
                bc \
                binfmt-support \
                bison \
                build-essential \
                clang \
                cross-config \
                debootstrap \
                debootstick \
                fakeroot \
                fakeroot-ng \
                flex \
                gawk \
                gcc \
                gperf \
                g++ \
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
                libssl-dev \
                libtool \
                lld \
                make \
                ninja-build \
                patchutils \
                qemu \
                qemu-system \
                qemu-user-static \
                zlib1g-dev; fi

installPKG "${PACKAGES[@]}"

########################
####### DOCKER #########
########################

log -1 "Installing Docker"

if [[ ! -d '/etc/apt/keyrings' ]]
then log -1 "Creating keyrings directory: /etc/apt/keyrings"
     mkdir --parents /etc/apt/keyrings; fi

# Gets GPG key for the Docker repository
getDockerGPGKey

# Setup the Docker repository sources list
setupDockerSourcesList

# Update APT with new sources
apt-get update --assume-yes

# Install Docker
installPKG docker-ce \
           docker-ce-cli \
           containerd.io \
           docker-compose-plugin

groupadd docker

# Adds USER to Docker group
usermod --append --groups docker "$USER"
usermod --append --groups docker www-data

# Installs docker-credential-pass
# Needs to be initiated with a GPG key by user
installDockerCredentialPass

########################
######## MICRO #########
########################

installMicro

########################
##### CONFIGURE ########
########################


########################

log 0 "$0 has completed"

exit 0
