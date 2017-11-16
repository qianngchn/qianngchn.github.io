#!/usr/bin/env bash
set -o errexit
set -o nounset

srcs=$(find wiki -name "*.markdown" | sort -t/ -k2 -nr)
index="wiki.markdown"

echo "Indexing $index"

echo "<!--title:Wiki-->" > "$index"
echo "<!--tags:wiki-->" >> "$index"
echo "<!--author:Neal-->" >> "$index"
echo "<!--date:$(date +%F)-->" >> "$index"
echo >> "$index"
echo "> 本页是基于Markdown + Pandoc + Github搭建的在线Wiki，我在这里记录知识，积累人生。" >> "$index"

i=1; recent=5
for src in $srcs
do
    category=$(sed -n '1,5s/^<!--category:\(.*\)-->$/\1/p' $src)
    title=$(sed -n '1,5s/^<!--title:\(.*\)-->$/\1/p' $src)
    tags=$(sed -n '1,5s/^<!--tags:\(.*\)-->$/\1/p' $src)
    date=$(sed -n '1,5s/^<!--date:\(.*\)-->$/\1/p' $src)
    html=$(echo $src | sed 's/markdown$/html/g')
    if [ $i -le $recent ]; then
        if [ $i -eq 1 ]; then
            echo >> "$index"
            echo "### 最新文章" >> "$index"
        fi
        echo "* $date [$title]($html) $tags" >> "$index"
        let i++
    fi
    touch "cat-$category"
    echo "* $date [$title]($html) $tags" >> "cat-$category"
done

categories=$(ls cat-*)
for category in $categories
do
    echo >> "$index"
    echo "### $category" | sed 's/cat-//g' >> "$index"
    cat "$category" >> "$index"
    rm -rf "$category"
done

exit 0
