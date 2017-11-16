#!/usr/bin/env bash
set -o errexit
set -o nounset

markdown="$1"
html="$2"

favicon="favicon.ico"
css="style.css"
index="index.html"
wiki="wiki.html"
src="$html"
while [ "$(dirname "$src")" != "." ]
do
    favicon="../$favicon"
    css="../$css"
    index="../$index"
    wiki="../$wiki"
    src=$(dirname "$src")
done

filename=$(basename "$markdown")
title=$(sed -n '1,5s/^<!--title:\(.*\)-->$/\1/p' "$markdown")
category=$(sed -n '1,5s/^<!--category:\(.*\)-->$/\1/p' "$markdown")
categorylink=$(echo "$category" | tr -d [:punct:] | tr [:upper:] [:lower:] | tr [=' '=] -)
tags=$(sed -n '1,5s/^<!--tags:\(.*\)-->$/\1/p' "$markdown")
author=$(sed -n '1,5s/^<!--author:\(.*\)-->$/\1/p' "$markdown")
date=$(sed -n '1,5s/^<!--date:\(.*\)-->$/\1/p' "$markdown")
description=$(sed -n '1,9s/^\([^<].*\)$/\1/p' "$markdown")

flags+=" --variable=lang:zh-cmn-Hans"
flags+=" --variable=favicon:$favicon"
flags+=" --variable=index:$index"
flags+=" --variable=wiki:$wiki"
flags+=" --css=$css"
flags+=" --highlight-style=haddock"
flags+=" --include-in-header temp_in_header.html"
flags+=" --include-before-body temp_before_body.html"
flags+=" --table-of-contents"
flags+=" --toc-depth=4"
flags+=" --include-after-body temp_after_body.html"
flags+=" --template=pandoctpl.html"
flags+=" --tab-stop=4"
flags+=" --from=markdown --to=html5"

echo "Generating $html"
# pandoc markdown to html
touch temp_in_header.html temp_before_body.html temp_after_body.html
echo "<title>$title</title>" > temp_in_header.html
echo "<meta name=\"keywords\" content=\"$tags\" />" >> temp_in_header.html
echo "<meta name=\"author\" content=\"$author\" />" >> temp_in_header.html
echo "<meta name=\"date\" content=\"$date\" />" >> temp_in_header.html
echo "<meta name=\"description\" content=\"$description\" />" >> temp_in_header.html
if [[ "$html" = *wiki/* ]]; then
    echo "<h2>$title</h2>" > temp_before_body.html
    echo "<span style=\"font-family: Consolas, "Liberation Mono", Menlo, Courier, monospace; font-size: 0.9rem;\">Category: <a href=\"../wiki.html#$categorylink\">$category</a> | Tags: $tags | Source: <a href=\"$filename\">Markdown</a> ----------&gt; <a href="../wiki.html">Back to Wiki</a></span>" >> temp_before_body.html
    echo "<span style=\"font-family: Consolas, "Liberation Mono", Menlo, Courier, monospace; font-size: 0.9rem;\">Author: $author | Date: $date ----------&gt; <a href="#">Go to Top</a></span>" > temp_after_body.html
fi
pandoc $flags "$markdown" -o "$html"
rm -rf temp_in_header.html temp_before_body.html temp_after_body.html

# then remove links of <hn> title in toc
sed -i 's/\(<h. id=".*">\)<a href="#.*">\(.*\)<\/a>/\1\2/g' "$html"

exit 0
