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

sfilename=$(basename "$markdown")
stitle=$(sed -n '1,5s/^<!---title:\(.*\)-->$/\1/p' "$markdown")
scategory=$(sed -n '1,5s/^<!---category:\(.*\)-->$/\1/p' "$markdown")
scategorylink=$(echo "$scategory" | tr -d [:punct:] | tr [:upper:] [:lower:] | tr [=' '=] -)
stags=$(sed -n '1,5s/^<!---tags:\(.*\)-->$/\1/p' "$markdown")
sauthor=$(sed -n '1,5s/^<!---author:\(.*\)-->$/\1/p' "$markdown")
sdate=$(sed -n '1,5s/^<!---date:\(.*\)-->$/\1/p' "$markdown")
sdescription=$(sed -n '1,9s/^\([^<].*\)$/\1/p' "$markdown")

flag+=" --variable=lang:zh-cmn-Hans"
flag+=" --variable=favicon:$favicon"
flag+=" --variable=index:$index"
flag+=" --variable=wiki:$wiki"
flag+=" --css=$css"
flag+=" --highlight-style=haddock"
flag+=" --include-in-header temp_in_header.html"
flag+=" --include-before-body temp_before_body.html"
flag+=" --table-of-contents"
flag+=" --toc-depth=4"
flag+=" --include-after-body temp_after_body.html"
flag+=" --template=pandoctpl.html"
flag+=" --tab-stop=4"
flag+=" --from=markdown --to=html5"

echo "Generating $html"
# pandoc markdown to html
touch temp_in_header.html temp_before_body.html temp_after_body.html
echo "<title>$stitle</title>" >> temp_in_header.html
echo "<meta name=\"keywords\" content=\"$stags\" />" >> temp_in_header.html
echo "<meta name=\"author\" content=\"$sauthor\" />" >> temp_in_header.html
echo "<meta name=\"date\" content=\"$sdate\" />" >> temp_in_header.html
echo "<meta name=\"description\" content=\"$sdescription\" />" >> temp_in_header.html
if [[ "$html" = *wiki/* ]]; then
    echo "<h2>$stitle</h2>" >> temp_before_body.html
    echo "<code style=\"background-color:white\">Category: <a href=\"../wiki.html#$scategorylink\">$scategory</a> | Tags: $stags | Source: <a href=\"$sfilename\">Markdown</a> ----------&gt; <a href="../wiki.html">Back to Wiki</a></code>" >> temp_before_body.html
    echo "<code style=\"background-color:white\">Author: $sauthor | Date: $sdate ----------&gt; <a href="#">Go to Top</a></code>" >> temp_after_body.html
fi
pandoc $flag "$markdown" -o "$html"
rm -f temp_in_header.html temp_before_body.html temp_after_body.html

# then remove links of <hn> title in toc
sed -i 's/\(<h. id=".*">\)<a href="#.*">\(.*\)<\/a>/\1\2/g' "$html"

exit 0
