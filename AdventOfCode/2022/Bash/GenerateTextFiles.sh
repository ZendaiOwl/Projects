#!/usr/bin/env bash
set -euf -o pipefail

for i in {01..24}
do
  touch Day"$i".txt
done

set +euf -o pipefail

exit 0
