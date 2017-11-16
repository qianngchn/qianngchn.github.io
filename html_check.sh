#!/usr/bin/env bash
set -o errexit
set -o nounset

src="$1"
dirname=$(dirname "$src")
inlinelinks+=$(sed -n 's/.*\[.*\](\(.*\)).*/\1/p' "$src" | awk '{printf " %s\n", $1}' | grep -v "http" | grep -v "mailto" || true)
inlinelinks+=$(sed -n 's/.*\[.*\]:\(.*\).*/\1/p' "$src" | awk '{printf " %s\n", $1}' | grep -v "http" | grep -v "mailto" || true)

echo "Checking $src"
for inlinelink in $inlinelinks
do
    if [ ! -f "$dirname/$inlinelink" ]; then
        echo "$dirname/$inlinelink does not exsit."
        exit 1
    fi
done
exit 0
