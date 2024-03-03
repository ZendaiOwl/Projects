#!/usr/bin/env bash

grep 'function .* {' "$HOME"/.library.sh | awk '{ print $2 }'

# Test
#grep 'function .* {' "$HOME"/.library.sh | awk '{ print $2 }' | tail -n 190 | head -n 31

exit 0
