#/bin/bash

srcs=`find wiki -name "*.markdown" | sort -t'/' -k2 -nr`
index="wiki.markdown"
title="Wiki"
tags="wiki"
recent=5

echo "Generating $index"

echo "<!---title:${title}-->" > $index
echo "<!---tags:${tags}-->" >> $index

i=0
for s in $srcs
do
    scategory=`sed -n '1,5s/^<\!---category:\(.*\)-->$/\1/p' $s`
    stitle=`sed -n '1,5s/^<\!---title:\(.*\)-->$/\1/p' $s`
    stags=`sed -n '1,5s/^<\!---tags:\(.*\)-->$/\1/p' $s`
    sdate=`sed -n '1,5s/^<\!---date:\(.*\)-->$/\1/p' $s`
    shtml=`echo $s | sed 's/markdown$/html/g'`
    if [ $i -lt $recent ]; then
        if [ $i -eq 0 ]; then
            echo >> $index
            echo "### Recent" >> $index
        fi
        echo "* $sdate [$stitle]($shtml) $stags" >> $index
        let i++
    fi
    touch cat-$scategory
    echo "* $sdate [$stitle]($shtml) $stags" >> cat-$scategory
done

categories=`ls cat-*`
for category in $categories
do
    echo >> $index
    echo "### $category" | sed 's/cat-//g' >> $index
    cat $category >> $index
    rm -f $category
done

exit 0
