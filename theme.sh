#!/usr/bin/env bash
# Push theme/ (dock, columns, wallpapers, look, remote buttons) to the launcher on the TV. No rebuild.
#   TV_HOST=192.168.1.50 ./theme.sh
set -euo pipefail
source "$(dirname "$0")/_common.sh"
"$CYT/tools/theme.sh" "$HERE/theme"
