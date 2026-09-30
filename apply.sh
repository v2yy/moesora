#!/usr/bin/env bash
# Replay v2yy customizations onto an extracted moesora theme dir.
# Usage: ./apply.sh <path-to-theme-dir>   (dir contains templates/)
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
TARGET="${1:?usage: apply.sh <theme-dir>}"
[ -d "$TARGET/templates" ] || { echo "not a theme dir (no templates/): $TARGET" >&2; exit 1; }

mkdir -p "$TARGET/templates/modules"
cp "$HERE/custom/templates/modules/navbar.html" "$TARGET/templates/modules/navbar.html"
cp "$HERE/custom/templates/modules/drawer.html" "$TARGET/templates/modules/drawer.html"
cp "$HERE/custom/templates/bangumis.html"       "$TARGET/templates/bangumis.html"
cp "$HERE/custom/templates/psn.html"            "$TARGET/templates/psn.html"

echo "customized $TARGET:"
echo "  - navbar/drawer menu status->spec fallback patch"
echo "  - bangumis.html (plugin-bilibili-bangumi)"
echo "  - psn.html (PluginPsn)"
echo "settings snapshot: $HERE/custom/theme-settings-20260930.json (replay via console json-config API)"
