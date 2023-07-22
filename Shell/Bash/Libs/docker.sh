#!/usr/bin/env bash
# Victor-ray, S.

. ./calculus.sh
. ./git.sh
. ./installation.sh
. ./json.sh
. ./network.sh
. ./tests.sh
. ./utility.sh


# ------
# Docker
# ------
# Template
# Return codes
# 0: 
# 1:
# 2:
# 3:


# Get the images names, tag & repository
# Return codes
# 1: Command not found: docker
# 2: Command not found: awk
# 3: Invalid number of arguments
function get_images {
    ! has_cmd 'docker' && { return 2; }
    ! has_cmd 'sed'    && { return 1; }
    docker images | sed -n 's|/*||p' | tail -n +2
}

# Get the Container ID & Name of running containers
# Return codes
# 1: Command not found: docker
# 2: Command not found: awk
# 3: Invalid number of arguments
function get_containers {
    ! has_cmd 'docker' && { return 2; }
    ! has_cmd 'sed'    && { return 1; }
    docker ps | sed -n 's|/*||p' | tail -n +2
}

# Get the Container ID of all running containers
# Return codes
# 1: Command not found: docker
# 2: Command not found: awk
# 3: Invalid number of arguments
function container_id_all {
    not_equal "$#" 0   && { return 3; }
    ! has_cmd 'awk'    && { return 2; }
    ! has_cmd 'docker' && { return 1; }
    docker ps | awk '{print $1}' | tail -n +2
}

# Gets the latest Container ID of the running containers
# Return codes
# 1: Command not found: awk
# 2: Command not found: docker
# 3: Invalid number of arguments
function container_id_latest {
    not_equal "$#" 0   && { return 3; }
    ! has_cmd 'docker' && { return 2; }
    ! has_cmd 'awk'    && { return 1; }
    docker ps | awk '{print $1}' | tail -n +2 | head -1
}

# Checks if the executing user is a member of the docker group
# 0: Is a member of group: docker
# 1: Not a member of group: docker
# 2: Invalid number of arguments
function in_docker_group {
    not_equal "$#" 0 && { return 2; }
    if is_member "$EUID" 'docker'
    then return 0
    else return 1
    fi
}

# Removes the latest Docker image
function remove_latest_image {
    ! has_cmd 'docker' && { return 2; }
    ! has_cmd 'awk'    && { return 1; }
    if is_root || in_docker_group
    then docker rmi "$(docker images | awk '{print $3}' | tail -n +2 | head -1)"
    else sudo docker rmi "$(sudo docker images | awk '{print $3}' | tail -n +2 | head -1)"
    fi
}
