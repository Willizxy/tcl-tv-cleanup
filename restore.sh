#!/usr/bin/env bash
# Put the TV back to stock: Private DNS back to automatic, key helper off, theme removed, every package in lists/
# enabled again (newest batch first) and Home handed back to Google TV's launcher.
#   TV_HOST=192.168.1.50 ./restore.sh [--uninstall-launcher]
# Run it before a factory reset: the setup wizard (batch 6) must be enabled for one.
set -euo pipefail
source "$(dirname "$0")/_common.sh"
echo "== Private DNS back to automatic";   TV "settings put global private_dns_mode opportunistic"
echo "== Remote-key helper off";           TV "settings put secure enabled_accessibility_services ''; settings put secure accessibility_enabled 0"
echo "== Launcher theme removed";          "$CYT/tools/theme.sh" --reset || true
# cleanyourtv's restore.sh uses the record disable.sh saved before each batch, or enables the whole list without one.
for f in $(ls "$HERE"/lists/*.txt | sort -r); do
  echo "== Re-enabling $(basename "$f")"; "$CYT/tools/restore.sh" "$f" "$STOCK"
done
TV "pm enable --user 0 $STOCK"
TV "cmd package set-home-activity --user 0 $STOCK/.home.HomeActivity"
if [ "${1:-}" = --uninstall-launcher ]; then TV "pm uninstall com.gathin.tvhome"; fi
echo "== Home now:"; TV "cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME" | tail -n 1
echo "== Still disabled (Stan, au.com.stan.and, came disabled from the factory):"; TV "pm list packages -d"
