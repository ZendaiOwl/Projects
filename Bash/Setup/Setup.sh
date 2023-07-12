#!/usr/bin/env bash
# Victor-ray, S <12261439+ZendaiOwl@users.noreply.github.com>

# prtlns a line using printf instead of using echo, for compatibility and reducing unwanted behaviour
function prtln {
    printf '%s\n' "$@"
}

# A log that uses log levels for logging different outputs
# Log levels  | Colour
# -2: Debug   | CYAN='\e[1;36m'
# -1: Info    | BLUE='\e[1;34m'
#  0: Success | GREEN='\e[1;32m'
#  1: Warning | YELLOW='\e[1;33m'
#  2: Error   | RED='\e[1;31m'
function log {
    if [[ "$#" -gt 0 ]]
    then if [[ "$1" =~ [(-2)-2] ]]
         then case "$1" in
                  -2) printf '\e[1;36mDEBUG\e[0m %s\n'   "${*:2}" >&2 ;;
                  -1) printf '\e[1;34mINFO\e[0m %s\n'    "${*:2}"     ;;
                   0) printf '\e[1;32mSUCCESS\e[0m %s\n' "${*:2}"     ;;
                   1) printf '\e[1;33mWARNING\e[0m %s\n' "${*:2}"     ;;
                   2) printf '\e[1;31mERROR\e[0m %s\n'   "${*:2}" >&2 ;;
              esac
         else log 2 "Invalid log level: [Debug: -2|Info: -1|Success: 0|Warning: 1|Error: 2]"
         fi
  fi
}

# Check if user ID executing script is 0 or not
# Return codes
# 0: Is root
# 1: Not root
# 2: Invalid number of arguments
function isRoot {
    [[ "$#" -ne 0 ]] && return 2
    [[ "$EUID" -eq 0 ]]
}

# Test for root permissions, exit if not available
if ! isRoot
then printf '\e[1;31mSTOP\e[0m %s\n' "Please run the script as root or with sudo"; exit 1
fi

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
  printf '\t%s\n' "${HELPTEXT[@]:1}"; exit 0
}

# See if curl exists else install it
function testForCurl {
    printf '\e[1;34mINFO\e[0m %s\n' "Test if curl is installed"
    if ! command -v curl &> /dev/null
    then local -r OPTIONS=(--assume-yes --quiet --no-show-upgraded --auto-remove=true --no-install-recommends)
         printf '\e[1;34mINFO\e[0m %s\n' "Installing: curl"
         apt update --assume-yes
         if DEBIAN_FRONTEND=noninteractive apt install "${OPTIONS[@]}" curl
         then printf '\e[1;33mSUCCESS\e[0m %s\n' "Installed: curl"
         else printf '\e[1;31mERROR\e[0m %s\n' "Something went wrong during installation"; exit 1
         fi
    else printf '\e[1;34mINFO\e[0m %s\n' "Already installed"
    fi
}

# Sets development installation: yes or no
function setDevelopment {
    if [[ "$#" -ne 1 ]]
    then log 2 "Missing argument(s)"; exit 1
    else local -r OPT="$1"
         if [[ "${OPT,,}" == "yes" ]]
         then log -1 "Development installation: Yes"
             DEVELOPMENT="yes"
         elif [[ "${OPT,,}" == "no" ]]
         then log -1 "Development installation: No"
              DEVELOPMENT="no"
         else log 2 "Invalid option for development installation: $OPT"
              printf '\t%s\n' "Option must be: 'Yes' or 'No'"; exit 1
         fi
    fi
}

# Sets the functions library file 
function setLibrary {
    if [[ ! -e "$1" ]]
    then log 2 "No such path: $1"; exit 1
    elif [[ ! -f "$1" ]]
    then log 2 "Not a file: $1"; exit 1
    else LIBRARY="$1"
    fi
}

# Adds packages for installation
function addPackages {
    if [[ "$#" -lt 1 ]]
    then log 2 "Missing package argument(s)"; exit 1
    else local ADDPKG=()
         IFS=' ' read -ra ADDPKG <<<"$@"
         log -1 "Adding package(s) for installation: ${ADDPKG[*]}"
         for PKG in "${ADDPKG[@]}"
         do PACKAGES+=("$PKG")
         done
    fi
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
    echo "deb [arch=$ARCH signed-by=$GPGKEY] $URL $RELEASE stable" | tee "$LIST" > /dev/null
    log 0 "Docker repository sources list is created: $LIST"
}

function installDockerCredentialPass {
    local -r URL='https://github.com/docker/docker-credential-helpers/releases/download/v0.7.0/docker-credential-pass-v0.7.0.linux-amd64' \
             DCPLONG='docker-credential-pass-v0.7.0.linux-amd64' \
             NAME='docker-credential-pass' 
    local -r USR_PATH="/usr/local/bin/$NAME" \
             ROOT_PATH="/usr/bin/$NAME"

    log -1 "Installing: $NAME"
    wget "$URL"
    chmod +x "$DCPLONG"
    mv    "$DCPLONG"  "$USR_PATH"
    chown "$USER"     "$USR_PATH"
    cp    "$USR_PATH" "$ROOT_PATH"
    chown root        "$ROOT_PATH"
    
    # Test so it works
    if ! hasCMD docker-credential-pass &> /dev/null
    then log 2 "Installation failed: ${NAME^}"; exit 1
    else log 0 "Installed: ${NAME^}"
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
  then log 2 "Installation failed: ${NAME^}"; exit 1
  else log 0 "Installed: ${NAME^}"
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
  then log 2 "Installation failed: ${NAME^}"; exit 1
  else log 0 "Installed: ${NAME^}"
  fi
}

function installDeta {
    local -r URL='https://get.deta.dev/space-cli.sh' \
             ARGS=(--fail --silent --show-error --location) \
             NAME='Deta Space CLI' \
             CONFIGBASHRC='
if [[ -d "$HOME"/.detaspace/bin ]]
then PATH="$HOME/.detaspace/bin:$PATH"
     export PATH
fi
'

    curl "${ARGS[@]}" "$URL" | sh
    
    cat "$CONFIGBASHRC" >> "$HOME/.bashrc"
    
    # shellcheck disable=SC1090
    source "$HOME/.bashrc"
    
    if ! hasCMD space &> /dev/null
    then log 2 "Installation failed: $NAME"; exit 1
    else log 0 "Installed: $NAME"
    fi
}

function installGitHubCLI {
    local -r URL='https://cli.github.com/packages/githubcli-archive-keyring.gpg' \
             GPGKEYRING='/usr/share/keyrings/githubcli-archive-keyring.gpg' \
             PKGURL='https://cli.github.com/packages' \
             GHSOURCES='/etc/apt/sources.list.d/github-cli.list' \
             ARGS=(--fail --silent --show-error --location) \
             NAME='GitHub CLI'
    local ARCH
    ARCH="$(dpkg --print-architecture)"
    log -1 "Installing: gh"
    curl "${ARGS[@]}" "$URL" \
         | dd of="$GPGKEYRING" \
         && chmod go+r "$GPGKEYRING" \
         && echo "deb [arch=$ARCH signed-by=$GPGKEYRING] $PKGURL stable main" \
         | tee "$GHSOURCES" > /dev/null \
         && apt update \
         && apt install gh --assume-yes
    if ! hasCMD gh &> /dev/null
    then log 2 "Installation failed: $NAME"; exit 1
    else log 0 "Installed: $NAME"
    fi
}

function installFly {
    local -r URL='https://fly.io/install.sh' \
             ARGS=(--fail --silent --show-error --location) \
             NAME='Flyctl' \
             CONFIGBASHRC='
if [[ -d "$HOME"/.fly ]]
then export FLYCTL_INSTALL="$HOME/.fly"
     PATH="$FLYCTL_INSTALL/bin:$PATH"
     export PATH
fi
'

    curl "${ARGS[@]}" "$URL" | sh
    
    cat "$CONFIGBASHRC" >> "$HOME/.bashrc"
    
    # shellcheck disable=SC1090
    source "$HOME/.bashrc"
    
    if ! hasCMD flyctl &> /dev/null
    then log 2 "Installation failed: $NAME"; exit 1
    else log 0 "Installed: $NAME"
    fi
}

function installGolang {
    local -r URL='https://go.dev/dl/go1.19.5.linux-amd64.tar.gz' \
             NAME='Go'
             DIR='/usr/local' \
             GODIR='/usr/local/go' \
             GOTAR='go1.19.5.linux-amd64.tar.gz' \
             CONFIGBASHRC='
if [[ -d /usr/local/go ]]
then PATH="/usr/local/go/bin:$PATH"
     export PATH
fi
'

    log -1 "Installing: $NAME"
    
    wget "$URL"
    rm --recursive --force "$GODIR" \
       && tar -C "$DIR" -xzf "$GOTAR" \
       && rm "$GOTAR"
    
    cat "$CONFIGBASHRC" >> "$HOME/.bashrc"
    source "$HOME/.bashrc"
    
    if ! hasCMD go &> /dev/null
    then log 2 "Installation failed: $NAME"; exit 1
    else log 0 "Installed: $NAME"
    fi
}

function installStarship {
    local -r URL='https://starship.rs/install.sh' \
             CONFIG='https://raw.githubusercontent.com/ZendaiOwl/Build/master/Bash/Setup/starship.toml' \
             ARGS=(--silent --show-error) \
             NAME='Starship'
    log -1 "Installing: $NAME"
    curl --silent --show-error "$URL" | sh
    
    if [[ -d "$HOME/.config" ]]
    then cat <(curl "${ARGS[@]}" "$CONFIG") > "$HOME/.config/starship.toml"
    else mkdir --parents "$HOME/.config"
        cat <(curl "${ARGS[@]}" "$CONFIG") > "$HOME/.config/starship.toml"
    fi
    
    if [[ -f "$HOME/.bashrc" ]]
    then cat 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
    else cat 'eval "$(starship init bash)"' > "$HOME/.bashrc"
    fi
    
    # shellcheck disable=SC1090
    source "$HOME/.bashrc"
    log 0 "Installed: $NAME"
}

function installNode {
    local -r URL='https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh'
    log -1 "Installing: nvm & node.js LTS"
    curl -o- "$URL" | bash
    if ! hasCMD nvm &> /dev/null
    then if [[ -f "$HOME/.bashrc" ]]
         then # shellcheck disable=SC1090
              source "$HOME/.bashrc"
              if hasCMD nvm &> /dev/null
              then nvm install --lts
              else export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
              [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
                  if hasCMD nvm &> /dev/null
                  then nvm install --lts
                  else log 2 "Couldn't initiate nvm and isntall node.js"; exit 1
                  fi
              fi
         else export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
              [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
              if hasCMD nvm &> /dev/null
              then nvm install --lts
              else log 2 "Couldn't initiate nvm and isntall node.js"; exit 1
              fi
         fi
    else nvm install --lts
    fi
    log 0 "Installed: nvm & node.js LTS"
}

function installSDKMan {
    local -r URL='https://get.sdkman.io' \
             ARGS=(--fail --silent --show-error --location) \
             NAME='sdk'
    log -1 "Installing: $NAME"
    curl "${ARGS[@]}" "$URL" | bash
    
    # shellcheck disable=SC1090
    source "$HOME/.bashrc"
    
    if ! hasCMD sdk &> /dev/null
    then log 2 "Installation failed: $NAME"; exit 1
    else log 0 "Installed: $NAME"
    fi
}

function getSDK {
    local -r NAME='sdk' \
            SDKs=(java kotlin groovy http4k micronaut 'java 22.3.r19-grl')
    if ! hasCMD sdk &> /dev/null
    then log 2 "Command not available: $NAME"; exit 1
    else log -1 "Installing SDK's: ${SDKs[*]}"
         for SDKLANGUAGE in "${SDKs[@]}"
         do if sdk install "$SDKLANGUAGE"
            then log 0 "Installed: $SDKLANGUAGE"
            else log 2 "Installation failed: $SDKLANGUAGE"
            fi
         done
    fi
    log 0 "Installed SDK's: ${SDKs[*]}"
}

function setGitConfigurations {
    local -r NAME='Victor-ray, S' \
             EMAIL='12261439+ZendaiOwl@users.noreply.github.com' \
             PULL='pull.rebase false' \
             GITNAME=(git config --global user.name "$NAME") \
             GITEMAIL=(git config --global user.email "$EMAIL") \
             GITPULL=(git config --global "$PULL")
    log -1 "Setting up Git configurations"
    
    log -1 "Name: $NAME"
    "${GITNAME[@]}"
    
    log -1 "Email: $EMAIL"
    "${GITEMAIL[@]}"
    
    log -1 "Pull: $PULL"
    "${GITPULL[@]}"
    
    log 0 "Git name, email & pull is configured"
}

trap 'unsetSetupVariables' EXIT SIGHUP SIGILL SIGABRT

########################
#### SOURCE LIBRARY ####
########################

# See if curl exists else install it
testForCurl

if [[ -f "$LIBRARY" ]]
then # shellcheck disable=SC1090
     source "$LIBRARY"
else # shellcheck disable=SC1090
     source <(curl --silent --location "$GH_LIB")
fi

########################
#### INSTALLATION ######
########################

while getopts "${OPTSTRING}" ARG
do case "$ARG" in
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

if [[ "$DEVELOPMENT" == "yes" ]]
then # Development packages
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
                 zlib1g-dev
fi

installPKG "${PACKAGES[@]}"

########################
####### DOCKER #########
########################

log -1 "Installing Docker"

if [[ ! -d '/etc/apt/keyrings' ]]
then log -1 "Creating keyrings directory: /etc/apt/keyrings"
     mkdir --parents /etc/apt/keyrings
fi

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

# Adds USER to Docker group
usermod --append --groups docker "$USER"

# Installs docker-credential-pass
# Needs to be initiated with a GPG key by user
installDockerCredentialPass

########################
######## MICRO #########
########################

installMicro

########################
######## EGET ##########
########################

installEget

########################
##### DETA SPACE #######
########################

installDeta

########################
##### GITHUB CLI #######
########################

installGitHubCLI

########################
####### FLYCTL #########
########################

installFly

########################
####### GOLANG #########
########################

installGolang

########################
###### STARSHIP ########
########################

installStarship

########################
####### NODE.JS ########
########################

installNode

########################
####### SDKMAN #########
########################

installSDKMan

getSDK

########################
##### CONFIGURE ########
########################

setGitConfigurations

########################

log 0 "$0 has completed"

exit 0
