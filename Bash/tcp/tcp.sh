#!/usr/bin/env bash
# @author Victor-ray, S. <12261439+ZendaiOwl@users.noreply.github.com>
if test "$#" -eq 2
then
  HOST="$1"
  PORT="$2"
  timeout 2.0 bash -c "</dev/null>/dev/tcp/$HOST/$PORT" && echo "open" || echo "closed"
else
  printf '%s\n%s\n%s\n' "Requires 2 arguments: [HOST] [PORT]" "[HOST]: Can be FQDN, IPv4 or IPv6" "[PORT]: Can be any valid port integer"
fi
