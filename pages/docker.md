***Docker***

_Table of Contents_

* TOC
{:toc}

---

## Resources

*Documentation, articles & related projects*

+ **§** **!** [Docker Docs - Migrate to V2, no longer supporting V1](https://docs.docker.com/compose/migrate/)

+ **§** [Docker Docs - Best practice, Dockerfile](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)  
+ **§** [Docker Docs - Best practice, Development](https://docs.docker.com/develop/dev-best-practices/)  
+ **§** [Docker Docs - Best practice, Image-building](https://docs.docker.com/get-started/09_image_best/)  
+ **§** [Docker Docs - Build enhancements](https://docs.docker.com/develop/develop-images/build_enhancements/)  
+ **§** [Docker Docs - Choosing a build driver](https://docs.docker.com/build/building/drivers/)  
+ **§** [Docker Docs - Manage images](https://docs.docker.com/develop/develop-images/image_management/)  
+ **§** [Docker Docs - Create a base image](https://docs.docker.com/develop/develop-images/baseimages/)
+ **§** [Docker Docs - Multi-container apps](https://docs.docker.com/get-started/07_multi_container/)  
+ **§** [Docker Docs - Update the application](https://docs.docker.com/get-started/03_updating_app/)  
+ **§** [Docker Docs - Packaging your software](https://docs.docker.com/build/building/packaging/)  
+ **§** [Docker Docs - Multi-stage builds](https://docs.docker.com/build/building/multi-stage/)  
+ **§** [Docker Docs - Compose, Overview](https://docs.docker.com/compose/)  
+ **§** [Docker Docs - Reference, run command](https://docs.docker.com/engine/reference/run)  
+ **§** [Docker Docs - Specify a Dockerfile](https://docs.docker.com/engine/reference/commandline/build/#specify-a-dockerfile--f)
+ **§** [Docker Docs - Announcement, Compose V2](https://www.docker.com/blog/announcing-compose-v2-general-availability/)
+ **§** [Docker Docs - Deprecated Features](https://docs.docker.com/engine/deprecated/)
+ **§** [Docker Docs - Manage contexts](https://docs.docker.com/engine/reference/commandline/context/) 
+ **§** [Docker Docs - Docker Driver](https://docs.docker.com/build/building/drivers/docker/)
+ **§** [Docker Docs - Orchestration](https://docs.docker.com/get-started/orchestration/)
+ **§** [Docker Docs - Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
+ **§** [Docker Docs - Compose extend services](https://docs.docker.com/compose/extends/)
+ **§** [Docker Docs - Compose networking](https://docs.docker.com/compose/networking/)
+ **§** [Docker Docs - Compose in production](https://docs.docker.com/compose/production/)
+ **§** [Docker Docs - Compose FAQ](https://docs.docker.com/compose/faq/)

+ **§** [Google - Best practice, Building containers](https://cloud.google.com/architecture/best-practices-for-building-containers#signal-handling)
+ **§** [Google - Best practice, Operating containers](https://cloud.google.com/architecture/best-practices-for-operating-containers)

+ **§** [Red Hat Dev - Blog Post, Systemd in Containers](https://developers.redhat.com/blog/2019/04/24/how-to-run-systemd-in-a-container)

+ **§** [Nestybox](https://www.nestybox.com/)
+ **§** [Sysbox](https://github.com/nestybox/sysbox)

*Scripts*

+ **§** [Transforming Bash Script to Docker Compose](https://fiberplane.dev/blog/transforming-bash-scripts-into-docker-compose/)
+ **§** [Automatic Docker Container creation w/bash script](https://assistanz.com/automatic-docker-container-creation-via-linux-bash-script/)
+ **§** [Docker w/Shell script or Makefile](https://ypereirareis.github.io/blog/2015/05/04/docker-with-shell-script-or-makefile/)
+ **§** [Run scripts, Docker arguments](https://devopscube.com/run-scripts-docker-arguments/)
+ **§** [Run a scripts inside Docker container using Shell script](https://www.commands.dev/workflows/run_a_script_inside_a_docker_container_using_a_shell_script)
+ **§** [Run Script, with dev docker image](https://gist.github.com/austinhyde/2e39c01d6b0ebf4aef7409e129c47ea7)

*Docker images*

+ **§** [Nextcloud AIO](https://github.com/nextcloud/all-in-one)
+ **§** [Reverse proxy AIO](https://github.com/nextcloud/all-in-one/blob/main/reverse-proxy.md)
+ **§** [Nextcloud](https://hub.docker.com/_/nextcloud)
+ **§** [Linuxserver.io/Nextcloud](https://hub.docker.com/r/linuxserver/nextcloud)
+ **§** [MariaDB](https://hub.docker.com/_/mariadb)
+ **§** [MySQL](https://hub.docker.com/_/mysql)
+ **§** [PHP](https://hub.docker.com/_/php)
+ **§** [Debian](https://hub.docker.com/_/debian)
+ **§** [Alpine](https://hub.docker.com/_/alpine)
+ **§** [Bash](https://hub.docker.com/_/bash)
	+ Script shebang is recommended to be `#!/usr/bin/env bash` and not `#!/bin/bash`, to be compatible with the `bash` [docker image](https://hub.docker.com/_/bash) natively.
+ **§** [Curl](https://hub.docker.com/r/curlimages/curl)

## Commands

```bash
# Gets the ID-hash for all images present on the system
docker image ls | awk '(NR!=1) {print $3}'

# Attempts to remove all images present on the system
for I in $(docker image ls | awk '(NR!=1) {print $3}')
do
    docker rmi "$I"
done
```

A stupid but fun command

```bash
# Tries to run all images available on the system
for I in $(docker image ls | awk '(NR!=1) {print $3}')
do
    docker run --rm -it "$I"
done

# Same but detached and without removing containers as they exit
for I in $(docker image ls | awk '(NR!=1) {print $3}')
do
    docker run -d=true "$I"
done
```

## Check IP using Docker

```bash
# Public IPv4
docker run --rm -it curlimages/curl:latest -s -m4 -4 https://ipv4.icanhazip.com

# Public IPv6
docker run --rm -it curlimages/curl:latest -s -m4 -6 https://ipv6.icanhazip.com

# Local IPv4
ip -j address | docker run --rm -i zendai/jq:1 '.[1] | .addr_info | .[0].local'

# Local IPv6
ip -j address | docker run --rm -i zendai/jq:1 '.[1] | .addr_info | .[1].local'
```


## Multi-architecture

Install binaries

```bash
docker run --privileged --rm tonistiigi/binfmt --install all
```

## Enable IPv6 for Docker Engine

To get IPv6 to function you need to designate a subnet for the Docker Engine to use when assigning IPv6 addresses to the containers and creating a network.

Docker `daemon.json`

*The IP-addresses are examples for documentation in accordance with [RFC3849](https://datatracker.ietf.org/doc/rfc3849) & [RFC5737](https://datatracker.ietf.org/doc/rfc5737).*

```json
{
  "default-address-pools": [
    {
      "base": "192.0.2.0/16",
      "size": 16
    },
    {
      "base": "2001:DB8::1::/16",
      "size": 16
    },
    {
      "base": "2001:DB8::2::/16",
      "size": 16
    },
    {
      "base": "2001:DB8:3::/16",
      "size": 16
    },
    {
      "base": "2001:DB8::4::/16",
      "size": 16
    },
    {
      "base": "2001:DB8::5::/16",
      "size": 16
    },
    {
      "base": "2001:DB8::6::/16",
      "size": 16
    }
  ],
  "features": {
    "buildkit": true
  },
  "ipv6": true,
  "fixed-cidr-v6": "2001:DB8::/36"
}
```

Create a network from the available pool set in the `daemon.json` file

```bash
# IPv4 & IPv6 (dual-stack)
docker network create \
               --driver="bridge" \
               --subnet="192.0.2.0/16" \
               --gateway="192.0.2.12" \
               --ipv6 \
               --subnet="2001:DB8::/32" \
               --gateway="2001:DB8::1" \
               --ipam-driver="default" \
               --attachable \
               dual-stack

# IPv4 Network
docker network create \
               --driver bridge \
               --subnet="192.0.2.0/16" \
               --gateway="192.0.2.1" \
               --attachable \
               ipv4

# IPv6 Network
docker network create \
               --driver bridge \
               --ipv6 \
               --subnet="2001:DB8::/32" \
               --gateway="2001:DB8::1" \
               --ipam-driver="default" \
               --attachable \
               ipv6
```

---
