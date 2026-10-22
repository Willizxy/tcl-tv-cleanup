# Shared setup for the scripts in this repo. They drive the TV with the tools from a cleanyourtv checkout
# (https://github.com/Gathin23/cleanyourtv), found next to this repo or wherever CLEANYOURTV points.
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CYT="${CLEANYOURTV:-$HERE/../cleanyourtv}"
[ -f "$CYT/tools/tv.py" ] || { echo "cleanyourtv not found at $CYT: clone https://github.com/Gathin23/cleanyourtv next to this repo, or set CLEANYOURTV=<path>" >&2; exit 1; }
CYT="$(cd "$CYT" && pwd)"
: "${TV_HOST:?set TV_HOST to the TV IP address, e.g. TV_HOST=192.168.1.50 $0}"
export TV_HOST
PY="$CYT/tools/venv/Scripts/python.exe"; [ -x "$PY" ] || PY="$CYT/tools/venv/bin/python"
[ -x "$PY" ] || { echo "set up cleanyourtv first: python3 -m venv tools/venv && tools/venv/bin/pip install -r tools/requirements.txt (in $CYT)" >&2; exit 1; }
TV() { "$PY" -I "$CYT/tools/tv.py" "$@"; }
STOCK=com.google.android.apps.tv.launcherx
