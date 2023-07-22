___Code___

_Table of Contents_

* TOC
{:toc}

---

# Nix

_From the manual_

Shebang

_Examples_

```sh
#! /usr/bin/env nix-shell
#! nix-shell -i python -p python pythonPackages.prettytable
#! nix-shell -i perl -p perl perlPackages.HTMLTokeParserSimple perlPackages.LWP
#! nix-shell -i bash -p "terraform.withPlugins (plugins: [ plugins.openstack ])"

Note: You must use double quotes (") when passing a simple Nix expression in a nix-shell shebang.
```

```sh
Options
•  --packages / -p packages…
          Set up an environment in which the specified packages are present.  The
          command line arguments are interpreted as attribute  names  inside  the
          Nix  Packages collection. Thus, nix-shell -p libjpeg openjdk will start
          a shell in which the packages denoted by the  attribute  names  libjpeg
          and openjdk are present.

•  -i interpreter
          The  chained script interpreter to be invoked by nix-shell. Only appli‐
          cable in #!-scripts (described below).
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

# Docker

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

# NixOS

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

# IP from 'messages' log

```bash
sudo cat /var/log/messages | awk '{print $12}' | cut -d"=" -f2
```

# Get IP from UFW log

```bash
sudo cat /var/log/ufw.log | cut -c 47-155

sudo awk '{print $12}' /var/log/ufw.log
```

---

# Redis Docker

```bash
docker run --detach \
           --rm \
           --name redis \
           --volume redis:/data \
           --volume "$PWD"/redis.conf:/usr/local/etc/redis/redis.conf \
           --volume /var/run/redis.sock:/var/run/redis.sock \
           redis:7-alpine

docker exec -it redis redis-server /usr/local/etc/redis/redis.conf
```

---

# Socat

Listen on local port

IPv4: `sudo socat - TCP4-LISTEN:"$PORT"`

IPv6: `sudo socat - TCP6-LISTEN:"$PORT"`

Ex.

```bash
sudo socat - tcp4-listen:8080 # IPv4
sudo socat - tcp6-listen:8080 # IPv6
```

```bash
socat TCP-CONNECT:$RHOST:$RPORT exec:/bin/sh,pty,stderr,setsid,sigint,sane

socat TCP-LISTEN:$LPORT,reuseaddr,fork EXEC:/bin/sh,pty,stderr,setsid,sigint,sane

socat TCP-LISTEN:12345,reuseaddr,fork EXEC:/usr/bin/bash,pty,stderr,setsid,sigint,sane

# Listen on port 8080 to STDIO
sudo socat STDIO TCP4-LISTEN:8080

# Pass the input to a script file as argument
./test.sh "$(sudo socat - TCP-LISTEN:8080)"
```

```bash
socat TCP-LISTEN:8080,reuseaddr,fork system:'ls'
socat - TCP-LISTEN:8080,reuseaddr,fork

socat FILE:`tty`,raw,echo=0 TCP:localhost:8080
socat system:'ls -a' TCP:localhost:8080
```

```bash
# Create a local UNIX socket file
socat - UNIX-LISTEN:$FILENAME,reuseaddr,fork

# Send a message through the UNIX socket
echo 'Hello, how are you?' | socat UNIX:$FILE_NAME -
```

---

# Regex

Hostnames Regex

```regex
(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$)
```

Hostname Regex TLD optional

```regex
(?=^.{1,253}$)(^(((?!-)[a-zA-Z0-9-]{1,63}(?<!-))|((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63})$)
```

Email address

```regex
/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?
(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
```

Source: https://html.spec.whatwg.org/multipage/forms.html#e-mail-state-(type=email)

---

# Nextcloud OCC command

```bash
# Start command with
sudo -u www-data php /var/www/nextcloud/occ

# Show a list of all available commands
sudo -u www-data php /var/www/nextcloud/occ list
```

---

# Process signals

In Docker make sure the Entrypoint handles the process signals.

_Can be viewed with `trap -l`_

<table>
    <tr>
        <th colspan="4" rowspan="1" align="left"><i>Process signals</i></th>
    </tr>
    <tr>
        <td><strong>1.</strong> SIGHUP</td>
        <td><strong>2.</strong> SIGINT</td>
        <td><strong>3.</strong> SIGQUIT</td>
        <td><strong>4.</strong> SIGILL</td>
    </tr>
    <tr>
        <td><strong>5.</strong> SIGTRAP</td>
        <td><strong>6.</strong> SIGABRT</td>
        <td><strong>7.</strong> SIGBUS</td>
        <td><strong>8.</strong> SIGFPE</td>
    </tr>
    <tr>
        <td><strong>9.</strong> SIGKILL</td>
        <td><strong>10.</strong> SIGUSR1</td>
        <td><strong>11.</strong> SIGSEGV</td>
        <td><strong>12.</strong> SIGUSR2</td>
    </tr>
    <tr>
        <td><strong>13.</strong> SIGPIPE</td>
        <td><strong>14.</strong> SIGALRM</td>
        <td><strong>15.</strong> SIGTERM</td>
        <td><strong>16.</strong> SIGSTKFLT</td>
    </tr>
    <tr>
        <td><strong>17.</strong> SIGCHLD</td>
        <td><strong>18.</strong> SIGCONT</td>
        <td><strong>19.</strong> SIGSTOP</td>
        <td><strong>20.</strong> SIGTSTP</td>
    </tr>
    <tr>
        <td><strong>21.</strong> SIGTTIN</td>
        <td><strong>22.</strong> SIGTTOU</td>
        <td><strong>23.</strong> SIGURG</td>
        <td><strong>24.</strong> SIGXCPU</td>
    </tr>
    <tr>
        <td><strong>25.</strong> SIGXFSZ</td>
        <td><strong>26.</strong> SIGVTALRM</td>
        <td><strong>27.</strong> SIGPROF</td>
        <td><strong>28.</strong> SIGWINCH</td>
    </tr>
    <tr>
        <td><strong>29.</strong> SIGIO</td>
        <td><strong>30.</strong> SIGPWR</td>
        <td><strong>31.</strong> SIGSYS</td>
        <td><strong>34.</strong> SIGRTMIN</td>
    </tr>
    <tr>
        <td><strong>35.</strong> SIGRTMIN+1</td>
        <td><strong>36.</strong> SIGRTMIN+2</td>
        <td><strong>37.</strong> SIGRTMIN+3</td>
        <td><strong>38.</strong> SIGRTMIN+4</td>
    </tr>
    <tr>
        <td><strong>39.</strong> SIGRTMIN+5</td>
        <td><strong>40.</strong> SIGRTMIN+6</td>
        <td><strong>41.</strong> SIGRTMIN+7</td>
        <td><strong>44.</strong> SIGRTMIN+10</td>
    </tr>
    <tr>
        <td><strong>42.</strong> SIGRTMIN+8</td>
        <td><strong>43.</strong> SIGRTMIN+9</td>
        <td><strong>45.</strong> SIGRTMIN+11</td>
        <td><strong>46.</strong> SIGRTMIN+12</td>
    </tr>
    <tr>
        <td><strong>47.</strong> SIGRTMIN+13</td>
        <td><strong>48.</strong> SIGRTMIN+14</td>
        <td><strong>49.</strong> SIGRTMIN+15</td>
        <td><strong>50.</strong> SIGRTMAX-14</td>
    </tr>
    <tr>
        <td><strong>51.</strong> SIGRTMAX-13</td>
        <td><strong>52.</strong> SIGRTMAX-12</td>
        <td><strong>53.</strong> SIGRTMAX-11</td>
        <td><strong>54.</strong> SIGRTMAX-10</td>
    </tr>
    <tr>
        <td><strong>55.</strong> SIGRTMAX-9</td>
        <td><strong>56.</strong> SIGRTMAX-8</td>
        <td><strong>57.</strong> SIGRTMAX-7</td>
        <td><strong>58.</strong> SIGRTMAX-6</td>
    </tr>
    <tr>
        <td><strong>59.</strong> SIGRTMAX-5</td>
        <td><strong>60.</strong> SIGRTMAX-4</td>
        <td><strong>61.</strong> SIGRTMAX-3</td>
        <td><strong>62.</strong> SIGRTMAX-2</td>
    </tr>
    <tr>
        <td><strong>63.</strong> SIGRTMAX-1</td>
        <td><strong>64.</strong> SIGRTMAX</td>
        <td></td>
        <td></td>
    </tr>
</table>

---

<!-- START OF LINKS -->

[home]: {{ site.url }}
[bash]: {{ site.url }}/page/code/bash
[caddy]: {{ site.url }}/page/code/caddy
[git]: {{ site.url }}/page/code/git
[python]: {{ site.url }}/page/code/python

<!-- END OF LINKS -->
