_Table of Contents_

* TOC
{:toc}

---
*Nix*

My notes about NixOS & Nix

_From the manual_

Shebang

```sh
#! /usr/bin/env nix-shell
#! nix-shell -i python -p python pythonPackages.prettytable
#! nix-shell -i perl -p perl perlPackages.HTMLTokeParserSimple perlPackages.LWP
#! nix-shell -i bash -p "terraform.withPlugins (plugins: [ plugins.openstack ])"
```

**Note**: You must use double quotes (") when passing a simple Nix expression in a nix-shell shebang.

```shell
Options
•  --packages / -p packages…
        Set up an environment in which the specified packages are present.
        The command line arguments are interpreted as attribute names inside  
        the Nix Packages collection. Thus, nix-shell -p libjpeg openjdk will 
        start a shell in which the packages denoted by the attribute names 
        libjpeg and openjdk are present.

•  -i interpreter
          The chained script interpreter to be invoked by nix-shell. 
          Only applicable in shebang scripts #!-scripts
```

Execute `cargo` in NixOS

```sh
nix-shell -p gcc --command 'cargo build'
nix-shell -p gcc --command 'cargo check'
nix-shell -p gcc --command 'cargo update'
nix-shell -p gcc --command 'cargo run'
```

Use software or application that requires `cc` linker

```sh
nix-shell -p gcc --command ''
nix-shell -p musl --command ''
```

### Templates 

_Nix module template_

```nix
{ config, pkgs, ... }:

{
  imports =
    [ paths of other modules
    ];

  options = {
    option declarations
  };

  config = {
    option definitions
  };
}
```

_Devenv.yaml_

```nix
  inputs:
    myproject:
      url: github:myorg/myproject
  imports:
    - ./frontend
    - ./backend
    - myproject
```

_Rust Devenv.nix_

```nix
{ pkgs, ... }: {
    languages.rust = {
        enable = true;
        # https://devenv.sh/reference/options/#languagesrustversion
        version = "nightly";
    };
    
    pre-commit.hooks = {
        clippy.enable = true;
        rustfmt.enable = true;
    };
}
```

_Arion-pkgs.nix_

```nix
import <nixpkgs> { system = "x86_64-linux"; }
```

_Arion-compose.nix_

```nix
{
  project.name = "PROJECT_NAME";
  services.<PROJECT_NAME> = { pkgs, lib, ... }: {
    nixos.useSystemd = true;
    nixos.configuration.boot.tmp.useTmpfs = true;

    nixos.configuration = {
      services.<PROJECT_NAME>.enable = true;
    };

    # required for the service, arion tells you what is required
    service.capabilities.SYS_ADMIN = true;

    # required for network
    nixos.configuration.systemd.services.netdata.serviceConfig.AmbientCapabilities =
      lib.mkForce [ "CAP_NET_BIND_SERVICE" ];
    
    service.image = "alpine";

    # bind container local port to host port
    service.ports = [
      "8080:8080" # host:container
    ];
    
    #stop_signal = "SIGINT";
  };
}
```

_oci.nix_

```nix
{ pkgs ? import <nixpkgs> { }
, pkgsLinux ? import <nixpkgs> { system = "x86_64-linux"; }
}:

buildContainer {
  args = [
    (with pkgs;
      writeScript "run.sh" ''
        #!${bash}/bin/bash
        exec ${bash}/bin/bash
      '').outPath
  ];

  mounts = {
    "/data" = {
      type = "none";
      source = "/var/lib/mydata";
      options = [ "bind" ];
    };
  };

  readonly = false;
}
```

---

### NixOS

+ Lenovo config

`default.nix`

```
{
  imports = [ ../../common/pc/laptop ];
}
```

_Source:_ [NixOS Hardware](https://github.com/NixOS/nixos-hardware)

+ Enable openbox on nixos

If you're not using a custom xsession:

`services.xserver.windowManager.openbox.enable = true;`

And then choose openbox in lightdm

---

### Functions

***Calculus***

***Basic calculator***

```bash
# Calculation using bc
function bC {
    ( nix-shell --packages bc --command '( printf "%s\n" '"$*"' | bc -l )' )
}
```

***Awk***

```bash
# Calculation using awk
function Calc {
    ( nix-shell --packages gawk --command 'awk "BEGIN{print '"$*"'}"' )
}
```

---

***Git***

```bash
# Updates a Git repository in the current working directory and 
# signs the commit using GPG key before pushing with a message
# Return codes
# 0: Success
# 1: Not a Git repository in the current working directory
# 2: Missing argument(s): Commit message
function Git {
    if [[ "$#" -lt 1 ]]; then
        log 2 "No commit message provided"
        return 2
    elif [[ ! -e "$PWD"/.git ]]; then
        log 2 "Not a Git repository"
        return 1
    else
        (
            ( git_add )
            ( git_commit "$*" )
            ( git_push )
        )
    fi
}
```

```bash
# Initiates a repository in the current working directory
# Copies my license, readme & .gitignore templates over to the directory
# Adds them to the git history & commits them with a message
function initiate_git {
    (
        ( git_init )
        (
            nix-shell --packages 'coreutils' --command '
            [[ -f "$HOME"/Templates/Licenses/2023/MIT ]] && {
                cp -n $HOME/Templates/Licenses/2023/MIT ${PWD}/LICENSE
            }
            [[ -f "$HOME"/Templates/Text/README.md ]] && {
                cp -n $HOME/Templates/Text/README.md ${PWD}/README.md
            }
            [[ -f "$HOME"/Templates/Code/Git/.gitignore ]] && {
                cp -n $HOME/Templates/Code/Git/.gitignore ${PWD}/.gitignore
            }
            '
        )
        ( git_add )
        ( git_commit "First commit" )
    )
}
```

```bash
# Initiates the current working directory as a git repository
# Return codes
# 1: Missing command: git
# 2: Git repository exists in the current working directory
function git_init {
    ( nix-shell --packages git --command 'git init '"$PWD"'' )
}
```

```bash
# Adds any changed files
# Return codes
# 1: Missing command: git
# 2: No git repository in the current working directory
function git_add {
    [[ ! -e "$PWD/.git" ]] && { return 1; }
    ( nix-shell --packages git --command 'git add '"$PWD"'' )
}
```

```bash
# Checks the status of a given git repository path
# Return codes
# 1: No git repository in the given path
# 2: Failed to change directory to the given path
function git_status {
    [[ ! -e "$1/.git" && "$1" != *".git"* ]] && { return 1; }
    (
        nix-shell \
            --packages coreutils-full git \
            --command '(
                cd '"$1"' || return 2
                git status --short --porcelain
            )'
    )
}
```

```bash
function git_status_current_dir {
    [[ ! -e "$PWD"/.git ]] && { return 1; }
    ( nix-shell --packages git --command 'git status' )
}
```

```bash
# Pushes to a remote repository
# Return codes
# 1: Missing command: git
# 2: No git repository in the current working directory
function git_push {
    [[ ! -e "$PWD"/.git ]] && { return 2; }
    ( nix-shell --packages git --command 'git push' )
}
```

```bash
function git_pull {
    [[ ! -e "$PWD"/.git ]] && { return 2; }
    ( nix-shell --packages git --command 'git pull' )
}
```

```bash
# Signs & commits a Git change
# Return codes
# 1: No commit message provided
# 2: Not a Git repository in the current working directory
function git_commit {
    if [[ "$#" -lt 1 ]]; then
        log 2 "No commit message provided"
        return 1
    elif [[ ! -e "$PWD"/.git ]]; then
        log 2 "Not a git repository"
        return 2
    else
        (
            local -r KEY_ID="E2AC71651803A7F7"
            local -r MESSAGE="࿓❯ $*"
            nix-shell --packages git --command '
                git commit \
                    --signoff \
                    --gpg-sign='"$KEY_ID"' \
                    --message "'"$MESSAGE"'"
            ';
        )
    fi
}
```

```bash
# Cleans a Git repository
# Return codes
# 1: Not a Git repository in the current working directory
# 2: Invalid number of arguments
function git_clean {
    [[ ! -e "$PWD"/.git ]] && { return 1; }
    [[ "$#" -ne 0 ]] && { return 2; }
    ( nix-shell -p git --command 'git gc'; )
}
```

```bash
# Adds a remote repository to the git repository in the current working directory
# Return codes
# 1: Missing command: git
# 2: No git repository in the current working directory
# 3: Invalid number of arguments
function git_remote_add {
    [[ "$#" -ne 2 ]] && { return 1; }
    [[ ! -e "$PWD"/.git ]] && { return 2; }
    [[ "$#" -ne 2 ]] && { return 3; }
    ( nix-shell -p git --command 'git remote add -f '"$1"' '"$2"''; )
}
```

```bash
function git_last_commit {
    [[ "$#" -ne 1 ]] && { return 1; }
    [[ "$1" != *".git"* && ! -e "${1}/.git" ]] && { return 2; }
    if [[ -e "${1}/.git" ]]
    then
        ( nix-shell -p git --command 'git --git-dir '"${1}/.git"' log -1 --oneline'; )
    else
        ( nix-shell -p git --command 'git --git-dir '"$1"' log -1 --oneline'; )
    fi
}
```

```bash
function git_last_commit_current_directory {
    [[ ! -e "$PWD"/.git ]] && { return 1; }
    [[ "$#" -ne 0 ]] && { return 2; }
    ( nix-shell -p git --command 'git log -1 --oneline'; )
}
```

***Git Subtree***

```bash
# $1: Path
# $2: Repository
# $3: Branch
function subtree_add {
    [[ "$#" -eq 3 ]] && { return 1; }
    ( nix-shell -p git --command 'git subtree add --prefix='"$1"' '"$2"' '"$3"''; )
}
```

```bash
# $1: Path
# $2: Repository
# $3: Branch
function subtree_add_squash {
    [[ "$#" -eq 3 ]] && { return 1; }
    (
        nix-shell -p git --command '
            git subtree add --prefix='"$1"' '"$2"' '"$3"' --squash
        ';
    )
}
```

```bash
# 
# $1: Path to directory for subtree
# $2: Branch
# $3: Merge message
function subtree_merge {
    if [[ "$#" -eq 2 ]]; then
        (
            nix-shell -p git --command '
                git subtree merge \
                    --prefix='"$1"' '"$2"'
            ';
        )
    elif [[ "$#" -gt 2 ]]; then
        (
            nix-shell -p git --command '
                git subtree merge \
                    --prefix='"$1"' '"$2"' \
                    --message='"࿓❯ ${*:3}"'
            ';
        )
    else return 2
    fi
}
```

```bash
# $1: Path
# $2: Repository
# $3: Branch
# $4: Merge message
function subtree_pull {
    if [[ "$#" -eq 3 ]]; then
        (
            nix-shell -p git --command '
                git subtree pull --prefix='"$1"' '"$2"' '"$3"'
            ';
        )
    elif [[ "$#" -gt 3 ]]; then
        (
            nix-shell -p git --command '
                git subtree pull --prefix='"$1"' '"$2"' '"$3"' \
                --message='"࿓❯ ${*:4}"'
            ';
        )
    else return 2
    fi
}
```

```bash
# $1: Path
# $2: Repository
# $3: Branch
# $4: Merge message
function subtree_pull_squash {
    if [[ "$#" -eq 3 ]]; then
        (
            nix-shell -p git --command '
                git subtree pull \
                --squash \
                --prefix='"$1"' '"$2"' '"$3"'
            ';
        )
    elif [[ "$#" -gt 3 ]]; then
        (
            nix-shell -p git --command '
                git subtree pull \
                --squash \
                --prefix='"$1"' '"$2"' '"$3"' \
                --message='"࿓❯ ${*:4}"'
            ';
        )
    else return 2
    fi
}
```

```bash
# $1: Path
# $2: Repository
function subtree_split {
    [[ "$#" -ne 2 ]] && { return 1; }
    (
        nix-shell -p git --command '
            git subtree split --prefix='"$1"' '"$2"'
        ';
    )
}
```

***GitHub - Git Subtree***

```bash
function github_subtree_add {
    ! has_cmd 'git' && { return 1; }
    if [[ "$#" -eq 2 ]]; then
        (
            nix-shell -p 'git' --command '
                git subtree add --prefix='"$1"' git@github.com:ZendaiOwl/'"$1"' '"$2"'
            ';
        )
    elif [[ "$#" -eq 3 ]]; then
        (
            nix-shell -p 'git' --command '
                git subtree add --prefix='"$1"' git@github.com:ZendaiOwl/'"$2"' '"$3"'
            ';
        )
    
    else return 2
    fi
}
```

```bash
function github_subtree_pull {
    if [[ "$#" -eq 2 ]]; then
        (
            nix-shell -p 'git' --command '
                git subtree pull --prefix='"$1"' git@github.com:ZendaiOwl/'"$1"' '"$2"'
            ';
        )
    elif [[ "$#" -eq 3 ]]; then
        (
            nix-shell -p 'git' --command '
                git subtree pull --prefix='"$1"' git@github.com:ZendaiOwl/'"$2"' '"$3"'
            ';
        )
    elif [[ "$#" -gt 3 ]]; then
        (
            nix-shell -p 'git' --command '
                git subtree pull \
                --prefix='"$1"' git@github.com:ZendaiOwl/'"$2"' '"$3"' \
                --message='"࿓❯ ${*:4}"'
            ';
        )
    else return 2
    fi
}
```

```bash
function github_subtree_pull_squash {
    if [[ "$#" -eq 2 ]]
    then
        (
            nix-shell -p 'git' --command '
                git subtree pull --prefix='"$1"' git@github.com:ZendaiOwl/'"$1"' '"$2"' --squash
            ';
        )
    elif [[ "$#" -eq 3 ]]
    then
        (
            nix-shell -p 'git' --command '
                git subtree pull --prefix='"$1"' git@github.com:ZendaiOwl/'"$2"' '"$3"' --squash
            ';
        )
    elif [[ "$#" -gt 3 ]]
    then
        (
            nix-shell -p 'git' --command '
                git subtree pull \
                --squash \
                --prefix='"$1"' git@github.com:ZendaiOwl/'"$2"' '"$3"' \
                --message='"࿓❯ ${*:4}"'
            ';
        )
    else
        return 2
    fi
}
```

```bash
function github_subtree_push {
    if [[ "$#" -eq 2 ]]
    then
        (
            nix-shell -p 'git' --command '
                git subtree push --prefix='"$1"' git@github.com:ZendaiOwl/'"$1"' '"$2"'
            ';
        )
    elif [[ "$#" -eq 3 ]]
    then
        (
            nix-shell -p 'git' --command '
                git subtree push --prefix='"$1"' git@github.com:ZendaiOwl/'"$2"' '"$3"'
            ';
        )
    
    else
        return 2
    fi
}
```

```bash
function github_remote_add {
    (
        nix-shell -p 'git' --command '
            git remote add -f '"$1"' git@github.com:ZendaiOwl/'"$1"'.git
        ';
    )
}
```

---

***Utility***

```bash
# Create a tar.xz archive from a directory
# Return codes
# 1: No such PATH to directory exists
# 2: Invalid number of arguments
function create_archive {
    [[ "$#" -ne 2 ]] && { return 2; }
    [[ ! -e "$2" ]] && { return 1; }
    local -r ARCHIVE_FILE="$1"
    local -r DIRECTORY="$2"
    (
        nix-shell -p gnutar xz --command '
            tar --verbose \
                --create \
                --use-compress-program="xz --threads='"$(nproc)"'" \
                --file='"$ARCHIVE_FILE"'.tar.xz '"$DIRECTORY"'
        ';
    )
    
}
```

```bash
# Get system information
# Return codes
# 1: Invalid number of arguments
function system_info {
    [[ "$#" -ne 0 ]] && { log 2 "Invalid number of arguments: $#/0"; return 1; }
    ( nix-shell --packages 'inxi' --command 'inxi -Fxzr' )
}
```

```bash
# Gets the device ID for the VGA compatible controller
# Return codes
# 1: Invalid number of arguments
function gpu_id {
    [[ "$#" -ne 0 ]] && { log 2 "Invalid number of arguments: $#/0"; return 1; }
    ( nix-shell -p pciutils --run "lspci -nn | grep VGA" )
}
```

```bash
# Get filesystem information
# Return codes
# 1: Invalid number of arguments
function filesystem_info {
    [[ "$#" -ne 0 ]] && { ( log 2 "Invalid number of arguments: $#/0" ); return 1; }
    ( nix-shell --packages 'coreutils' --command 'df --print-type --human-readable' )
}
```

