#!/usr/bin/env bash
set -euo pipefail

cd "$HOME/comfy-chair"

if [ "$#" -gt 0 ]; then
  exec "$@"
fi

if [ ! -t 0 ]; then
  exec /bin/bash -l
fi

while true; do
  echo
  echo "Choose a shell:"
  echo "  1) Bash"
  echo "  2) Zsh"
  read -r -p "> " choice

  case "$choice" in
    1 | bash | Bash | BASH)
      export SHELL=/bin/bash
      exec /bin/bash -l
      ;;
    2 | zsh | Zsh | ZSH)
      export SHELL=/bin/zsh
      exec /bin/zsh -l
      ;;
    *)
      echo "Please choose 1 or 2."
      ;;
  esac
done
