#!/usr/bin/env bash
# 同步 web 构建产物到 Capacitor webDir（www/）
# 用法：先在 ../word-atlas 里 npm run build，再跑本脚本
set -euo pipefail
SRC="$(cd "$(dirname "$0")" 2>/dev/null && pwd)/../word-atlas/dist"
[ -d "$SRC" ] || SRC="/opt/projects/word-atlas/dist"
[ -d "$SRC" ] || { echo "dist 不存在，先去 word-atlas 构建一次"; exit 1; }
mkdir -p www
rm -rf www/*
cp -r "$SRC"/. www/
# 附加页：开源许可（履行 MIT/CC BY 4.0 的署名与声明义务）
HERE="$(cd "$(dirname "$0")" && pwd)"
cp "$HERE"/extra-web/LICENSES.html www/LICENSES.html
echo "www 同步完成: $(du -sh www | cut -f1)（含 LICENSES.html）"
