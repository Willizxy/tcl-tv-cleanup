#!/usr/bin/env bash
# Build the cleanyourtv launcher, install it as Home (it disables Google TV's launcher only once the new one has
# started), push this repo's theme and switch the remote-key helper on (HomeKeyService: Netflix, Freeview Play
# -> Plex, gear -> quick panel). Android turns the helper off on every reinstall, so this does it each time.
#   TV_HOST=192.168.1.50 ./install.sh
# Needs JDK 17 and the Android SDK (platform 34, build-tools 34.0.0): set JAVA_HOME and ANDROID_HOME, or keep them
# in a toolchain/ folder next to this repo (toolchain/jdk-17*, toolchain/sdk).
# Only changed the dock, columns or wallpapers? Run ./theme.sh instead: no rebuild needed.
set -euo pipefail
source "$(dirname "$0")/_common.sh"
TC="$HERE/../toolchain"
if [ -z "${JAVA_HOME:-}" ] && ls -d "$TC"/jdk-17* >/dev/null 2>&1; then JAVA_HOME="$(cd "$(ls -d "$TC"/jdk-17* | head -n 1)" && { pwd -W 2>/dev/null || pwd; })"; fi
if [ -z "${ANDROID_HOME:-}" ] && [ -d "$TC/sdk" ]; then ANDROID_HOME="$(cd "$TC/sdk" && { pwd -W 2>/dev/null || pwd; })"; fi
export JAVA_HOME ANDROID_HOME
# Apply this repo's launcher patches to the cleanyourtv checkout. Running the script twice is safe:
# a patch already in place is detected by a reverse-apply dry-run and skipped.
for p in "$HERE"/patches/*.patch; do
  [ -f "$p" ] || continue
  if git -C "$CYT" apply --check --reverse "$p" >/dev/null 2>&1; then
    echo "patch $(basename "$p") already applied, skipping"
  else
    echo "applying patch $(basename "$p")"
    git -C "$CYT" apply "$p"
  fi
done
HOME_KEY_SERVICE=1 "$CYT/launcher/build-and-install.sh"
"$CYT/tools/theme.sh" "$HERE/theme"
TV "dumpsys activity activities | grep mFocusedApp; dumpsys accessibility | grep 'Bound services'"
echo "Home should be com.gathin.tvhome above. Now press the real Netflix, Freeview Play and gear buttons."
