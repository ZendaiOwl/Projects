_Table of Contents_

* TOC
{:toc}

---

***Docker***

### Commands

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

### Check IP using Docker

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


### Multi-architecture

Install binaries

```bash
docker run --privileged --rm tonistiigi/binfmt --install all
```

### Enable IPv6 for Docker Engine

To get IPv6 to function you need to designate a subnet for the Docker Engine to use when assigning IPv6 addresses to the containers and creating a network.

Docker `daemon.json`

```json
{
  "default-address-pools": [
    {
      "base": "172.××.0.0/16",
      "size": 24
    },
    {
      "base": "××××:××××:××××:××××:1::/48",
      "size": 64
    },
    {
      "base": "××××:××××:××××:××××:2::/48",
      "size": 64
    },
    {
      "base": "××××:××××:××××:××××:3::/48",
      "size": 64
    },
    {
      "base": "××××:××××:××××:××××:4::/48",
      "size": 64
    },
    {
      "base": "××××:××××:××××:××××:5::/48",
      "size": 64
    },
    {
      "base": "××××:××××:××××:××××:6::/48",
      "size": 64
    }
  ],
  "features": {
    "buildkit": true
  },
  "ipv6": true,
  "fixed-cidr-v6": "××××:××××:××××:××××::/64"
}
```

Create a network from the available pool set in the `daemon.json` file

```bash
# IPv4 & IPv6 (dual-stack)
docker network create \
               --driver="bridge" \
               --subnet="172.××.0.0/16" \
               --gateway="172.××.0.1" \
               --ipv6 \
               --subnet="××××:××××:××××:××××::/64" \
               --gateway="××××:××××:××××:××××::1" \
               --ipam-driver="default" \
               --attachable \
               dual-stack

# IPv4 Network
docker network create \
               --driver bridge \
               --subnet="172.××.0.0/16" \
               --gateway="172.××.0.1" \
               --attachable \
               ipv4

# IPv6 Network
docker network create \
               --driver bridge \
               --ipv6 \
               --subnet="××××:××××:××××:××××:1a1a:/64" \
               --gateway="××××:××××:××××:××××:1a1a:1" \
               --ipam-driver="default" \
               --attachable \
               ipv6
```

---
