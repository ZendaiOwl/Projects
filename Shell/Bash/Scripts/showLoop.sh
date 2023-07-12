#!/usr/bin/env bash
set -euo pipefail
# Depends on 'psmisc' package.
LOOP=$1
sudo fuser -c /dev/loop${LOOP} | grep [0123456789]
exit
