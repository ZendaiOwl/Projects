#!/usr/bin/env bash

git_status () 
{ 
    ! have_cmd 'git' && { 
        return 1
    };
    [[ ! -e "$1/.git" && "$1" != *".git"* ]] && { 
        return 2
    };
    ( cd "$1" || return 3;
    git status --short --porcelain )
}

git_commit () 
{ 
    ! have_cmd 'git' && { 
        return 1
    };
    if [[ "$#" -lt 1 ]]; then
        log 2 "No commit message provided";
        return 2;
    else
        if [[ ! -e "$PWD"/.git ]]; then
            log 2 "Not a git repository";
            return 3;
        else
            ( local -r KEY_ID="E2AC71651803A7F7";
            local -r MESSAGE="࿓❯ $*";
            git commit --signoff --gpg-sign="$KEY_ID" --message="$MESSAGE" );
        fi;
    fi
}

git_clean () 
{ 
    ! have_cmd 'git' && { 
        return 1
    };
    [[ ! -e "$PWD"/.git ]] && { 
        return 2
    };
    [[ "$#" -ne 0 ]] && { 
        return 3
    };
    ( git gc )
}

git_remote_add () 
{ 
    ! have_cmd 'git' && { 
        return 1
    };
    [[ "$#" -ne 2 ]] && { 
        return 2
    };
    [[ ! -e "$PWD"/.git ]] && { 
        return 3
    };
    ( git remote add -f "$1" "$2" )
}

git_last_commit () 
{ 
    ! have_cmd 'git' && { 
        return 1
    };
    [[ "$#" -ne 1 ]] && { 
        return 2
    };
    [[ "$1" != *".git"* && ! -e "${1}/.git" ]] && { 
        return 3
    };
    if [[ -e "${1}/.git" ]]; then
        ( git --git-dir "${1}/.git" log -1 --oneline );
    else
        ( git --git-dir "$1" log -1 --oneline );
    fi
}

git_last_commit_current_directory () 
{ 
    ! have_cmd 'git' && { 
        return 1
    };
    [[ "$#" -ne 0 ]] && { 
        return 2
    };
    [[ ! -e "$PWD"/.git ]] && { 
        return 3
    };
    ( git log -1 --oneline )
}

github_subtree_add () 
{ 
    ! have_cmd 'git' && { 
        return 1
    };
    local -r GH_USER="ZendaiOwl";
    if [[ "$#" -eq 2 ]]; then
        ( git subtree add --prefix="$1" git@github.com:"$GH_USER"/"$1" "$2" );
    else
        if [[ "$#" -eq 3 ]]; then
            ( git subtree add --prefix="$1" git@github.com:"$GH_USER"/"$2" "$3" );
        else
            return 2;
        fi;
    fi
}

github_subtree_pull () 
{ 
    ! have_cmd 'git' && { 
        return 1
    };
    local -r GH_USER="ZendaiOwl";
    if [[ "$#" -eq 2 ]]; then
        ( git subtree pull --prefix="$1" git@github.com:"$GH_USER"/"$1" "$2" );
    else
        if [[ "$#" -eq 3 ]]; then
            ( git subtree pull --prefix="$1" git@github.com:"$GH_USER"/"$2" "$3" );
        else
            if [[ "$#" -gt 3 ]]; then
                ( git subtree pull --prefix="$1" git@github.com:"$GH_USER"/"$2" "$3" --message="࿓❯ ${*:4}" );
            else
                return 2;
            fi;
        fi;
    fi
}

github_subtree_pull_squash () 
{ 
    ! have_cmd 'git' && { 
        return 1
    };
    local -r GH_USER="ZendaiOwl";
    if [[ "$#" -eq 2 ]]; then
        ( git subtree pull --prefix="$1" git@github.com:"$GH_USER"/"$1" "$2" --squash );
    else
        if [[ "$#" -eq 3 ]]; then
            ( git subtree pull --prefix="$1" git@github.com:"$GH_USER"/"$2" "$3" --squash );
        else
            if [[ "$#" -gt 3 ]]; then
                ( git subtree pull --squash --prefix="$1" git@github.com:"$GH_USER"/"$2" "$3" --message="࿓❯ ${*:4}" );
            else
                return 2;
            fi;
        fi;
    fi
}

github_subtree_push () 
{ 
    ! have_cmd 'git' && { 
        return 1
    };
    local -r GH_USER="ZendaiOwl";
    if [[ "$#" -eq 2 ]]; then
        ( git subtree push --prefix="$1" git@github.com:"$GH_USER"/"$1" "$2" );
    else
        if [[ "$#" -eq 3 ]]; then
            ( git subtree push --prefix="$1" git@github.com:"$GH_USER"/"$2" "$3" );
        else
            return 2;
        fi;
    fi
}

github_remote_add () 
{ 
    ! have_cmd 'git' && { 
        return 1
    };
    local -r GH_USER="ZendaiOwl";
    ( git remote add -f "$1" git@github.com:"$GH_USER"/"$1".git )
}

