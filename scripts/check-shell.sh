#!/usr/bin/env bash
set -euo pipefail

bash -n comfy-chair.sh modules/*.sh docker-shell.sh support/docker-entrypoint.sh

if command -v shellcheck > /dev/null; then
  shellcheck -ax --severity=warning \
    comfy-chair.sh docker-shell.sh support/docker-entrypoint.sh
else
  echo "shellcheck is not installed; skipping ShellCheck."
  echo "On Ubuntu, install it with: sudo apt install shellcheck"
fi
