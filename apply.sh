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
cp "$HERE/custom/templates/modules/seo.html"   "$TARGET/templates/modules/seo.html"
cp "$HERE/custom/templates/bangumis.html"       "$TARGET/templates/bangumis.html"
cp "$HERE/custom/templates/psn.html"            "$TARGET/templates/psn.html"
cp "$HERE/custom/templates/psn_game.html"       "$TARGET/templates/psn_game.html"
cp "$HERE/custom/templates/modules/head.html"   "$TARGET/templates/modules/head.html"
cp "$HERE/custom/templates/modules/libs.html"   "$TARGET/templates/modules/libs.html"

# CSS patch: reduced-motion 下友链卡片不可见修复（.moe-link-item 入场动画 fill:forwards 被全局 animation:none 冻结在 opacity:0）
python3 - "$TARGET/templates/assets/dist/moesora.css" <<'PYEOF'
import sys
p = sys.argv[1]
s = open(p).read()
anchor = '@keyframes moe-link-in{0%{opacity:0;transform:translateY(16px)}to{opacity:1;transform:none}}'
fix = '@media (prefers-reduced-motion:reduce){.moe-link-item{opacity:1}}'
if fix in s:
    print('  css: reduced-motion link fix already present')
elif anchor in s:
    open(p, 'w').write(s.replace(anchor, anchor + fix, 1))
    print('  css: reduced-motion link fix inserted')
else:
    sys.exit('ERROR: moe-link-in keyframe anchor not found in ' + p)
PYEOF

echo "customized $TARGET:"
echo "  - navbar/drawer menu status->spec fallback patch"
echo "  - modules/seo.html list/collection/plugin-page canonical+title branches (v3)"
echo "  - bangumis.html (plugin-bilibili-bangumi)"
echo "  - psn.html (PluginPsn)"
echo "  - modules/head.html (css cache-bust v=1.1.9.r1)"
echo "settings snapshot: $HERE/custom/theme-settings-20260930.json (replay via console json-config API)"
