#/bin/bash

srcs=`find wiki -name "*.markdown" | sort -r`
index="wiki.markdown"
cats=("Notes" "Life")

for((i=0; i<${#cats[@]}; i++))
do
    touch cat$i
done

echo "Generating wiki.markdown"
echo "<!---title:Wiki-->" > $index
echo "<!---tags:wiki-->" >> $index
echo >> $index
for s in $srcs
do
    category=`sed -n -e 's/<\!---category:\(.\+\)-->/\1/p' $s`
    for((i=0; i<${#cats[@]}; i++))
    do
        if [ "$category" == "${cats[$i]}" ]; then
            echo "* `sed -n -e 's/<\!---time:\(.\+\)-->/\1/p' $s` [`sed -n -e 's/<\!---title:\(.\+\)-->/\1/p' $s`](`echo $s | sed -n -e 's/markdown$/html/p'`) `sed -n -e 's/<\!---tags:\(.\+\)-->/\1/p' $s`" >> cat$i
        fi
    done
done
for((i=0; i<${#cats[@]}; i++));
do
    echo "## ${cats[$i]}" >> $index
    cat cat$i >> $index
    echo >> $index
    rm -f cat$i
done
sed -i '$d' $index

exit 0
