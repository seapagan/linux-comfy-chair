#!/usr/bin/env bash
# cleanup.sh
# any last tidy and config changes to be done

echo ""
echo "---------------------------------------------------------------"
echo "| Performing Clean-up tasks.                                  |"
echo "---------------------------------------------------------------"
echo ""

# copy a basic .gitconfig if we have it...
if [ -f "$THISPATH/support/.gitconfig" ] ; then
  cat "$THISPATH/support/.gitconfig" >> ~/.gitconfig
fi

# add the .local/bin to the path if it isn't already there...
if ! grep -qc '/.local/bin' "$shell_rc" ; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$shell_rc"
fi
# run the above locally to use in this shell
export PATH="$HOME/.local/bin:$PATH"
