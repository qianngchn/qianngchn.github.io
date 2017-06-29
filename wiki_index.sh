#!/usr/bin/env bash
set -o errexit
set -o nounset

srcs=$(find wiki -name "*.markdown" | sort -t/ -k2 -nr)
index="wiki.markdown"
title="Wiki"
tags="wiki"
author="Neal"
date=$(date +%F)

echo "Indexing $index"

echo "<!---title:${title}-->" > "$index"
echo "<!---tags:${tags}-->" >> "$index"
echo "<!---author:${author}-->" >> "$index"
echo "<!---date:${date}-->" >> "$index"
echo >> "$index"
echo "> 本页是基于Markdown + Pandoc + Github搭建的在线Wiki，我在这里记录知识，积累人生。" >> "$index"

i=1
recent=5
for s in $srcs
do
    scategory=$(sed -n '1,5s/^<!---category:\(.*\)-->$/\1/p' $s)
    stitle=$(sed -n '1,5s/^<!---title:\(.*\)-->$/\1/p' $s)
    stags=$(sed -n '1,5s/^<!---tags:\(.*\)-->$/\1/p' $s)
    sdate=$(sed -n '1,5s/^<!---date:\(.*\)-->$/\1/p' $s)
    shtml=$(echo $s | sed 's/markdown$/html/g')
    if [ $i -le $recent ]; then
        if [ $i -eq 1 ]; then
            echo >> "$index"
            echo "### 最新文章" >> "$index"
        fi
        echo "* $sdate [$stitle]($shtml) $stags" >> "$index"
        let i++
    fi
    touch "cat-$scategory"
    echo "* $sdate [$stitle]($shtml) $stags" >> "cat-$scategory"
done

categories=$(ls cat-*)
for category in $categories
do
    echo >> "$index"
    echo "### $category" | sed 's/cat-//g' >> "$index"
    cat "$category" >> "$index"
    rm -f "$category"
done

exit 0
