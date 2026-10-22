#!/usr/bin/env bash
# Disable the packages in lists/ in six batches (pm disable-user, never uninstall), with a screenshot of Home
# after each batch in shots/. Look at each one before you carry on.
#   TV_HOST=192.168.1.50 ./debloat.sh
# Batch 6 (Google TV's setup wizard) is skipped by cleanyourtv's disable.sh while the wizard owns the saved Wi-Fi
# network: forget the network and join it again in Settings first, then run this again. Undo with ./restore.sh.
set -euo pipefail
source "$(dirname "$0")/_common.sh"
cd "$HERE"; mkdir -p shots
for f in "$HERE"/lists/*.txt; do
  echo "== $(basename "$f")"
  "$CYT/tools/disable.sh" "$f"
  TV --screenshot "shots/after-$(basename "$f" .txt).png" HOME --wait 3 || true
  read -r -p "Check the screenshot and the TV, then press Enter for the next batch (Ctrl+C to stop) " _
done
