#!/usr/bin/env bash
# Encrypts each readable family tree and writes the password-protected copy
# into this repo. The readable originals stay outside the repo.
#
# Usage: ./encrypt.sh
# Needs: Node.js (for npx) and a .staticrypt-password file in this folder.
set -euo pipefail
cd "$(dirname "$0")"

GENEALOGY="$HOME/Documents/GENEALOGY"
SITE_URL="https://dasloops.github.io/genealogy-research"

# One line per tree: "<readable source file>|<folder in this repo>"
TREES=(
  "$GENEALOGY/HOLBROOK:ELLIS:FREEMAN/Holbrook-Low-Colonial-Tree.html|holbrook-low"
)

if [[ ! -s .staticrypt-password ]]; then
  echo "Missing .staticrypt-password (put the password on a single line)." >&2
  exit 1
fi
export STATICRYPT_PASSWORD="$(tr -d '\n' < .staticrypt-password)"

for entry in "${TREES[@]}"; do
  src="${entry%%|*}"
  dest="${entry##*|}"
  [[ -f "$src" ]] || { echo "Source not found: $src" >&2; exit 1; }

  # StatiCrypt keeps the input file name, so stage it as index.html.
  rm -rf _build && mkdir -p _build
  cp "$src" _build/index.html

  npx --yes staticrypt@3 _build/index.html \
    --directory "$dest" \
    --short \
    --remember 365 \
    --template-title "Family Tree" \
    --template-instructions "Enter the family password to view this tree." \
    --template-button "Open" \
    --template-placeholder "Family password" \
    --template-error "That password didn't work. Please try again." \
    --template-remember "Remember me on this device" \
    --template-color-primary "#2c5c6c" \
    --template-color-secondary "#f3f5f2"
  rm -rf _build
  echo "Encrypted: $src -> $dest/index.html"

  # Separate call: with --share, StatiCrypt only prints the link (no encryption).
  echo "Share link (password built in):"
  npx --yes staticrypt@3 --short --share "$SITE_URL/$dest/" --share-remember | grep -o 'https://[^ ]*'
done
