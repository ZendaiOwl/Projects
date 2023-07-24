___Caddy___

_Random information about Caddy I've found and gathered_

* TOC
{:toc}

---

# xCaddy

_Build Caddy using xCaddy_

```bash
xcaddy build \
       --with github.com/greenpau/caddy-security \
       --with github.com/caddyserver/transform-encoder \
       --with github.com/mholt/caddy-webdav \
       --with github.com/hairyhenderson/caddy-teapot-module \
       --with github.com/abiosoft/caddy-json-parse \
       --with github.com/mastercactapus/caddy2-proxyprotocol \
       --with github.com/porech/caddy-maxmind-geolocation \
       --with github.com/gamalan/caddy-tlsredis \
       --with github.com/mholt/caddy-dynamicdns \
       --with github.com/caddy-dns/cloudflare \
       --with github.com/ggicci/caddy-jwt \
       --with github.com/ueffel/caddy-basic-auth-filter 
```

---

# Ban IP

## Read IP list from file to ban

```bash
while read LINE
do sudo ufw deny from "$LINE"
done < "$FILE"

# Example
while read LINE
do sudo ufw deny from "$LINE"
done < IP_list.txt
```

## Using AWK

```bash
# Syntax
awk '/search_pattern/ { action_to_take_on_matches; another_action; }' file_to_parse

# Examples
LOG_FILE="/var/log/caddy/caddy.log"
awk -F 'user authorization failed' '{print $2}' "$LOG_FILE"
awk -F 'authorization'             '{print $2}' "$LOG_FILE"
awk -F 'authorization failed'      '{print $2}' "$LOG_FILE"
awk -F 'failed'                    '{print $2}' "$LOG_FILE"
awk -F 'src_conn_ip'               '{print $2}' "$LOG_FILE"
awk -F 'src_ip'                    '{print $2}' "$LOG_FILE"
```

## Extract IP from caddy's logfile

```bash
LOG_FILE="/var/log/caddy/caddy.log"
cat "$LOG_FILE" | grep 'authorization failed' | awk '{print $5}' | cut -d"=" -f2 | sort | uniq -i | sed 's|,||g'
```

### Save to file

```bash
LOG_FILE="/var/log/caddy/caddy.log"
cat "$LOG_FILE" | grep 'authorization failed' | awk '{print $5}' | cut -d"=" -f2 | sort | uniq -i | sed 's|,||g' > IP_list.txt
```

## Lookup the IP-adress origin & write to a file

```bash
# New file
for i in $(cat ban.txt)
do whois "$i"
done > lookup.txt

# Append file
for i in $(cat ban.txt)
do whois "$i"
done >> lookup.txt

# Extract country
cat lookup.txt | grep 'country' | sort | awk '{print $2}' | uniq -c
```

---
