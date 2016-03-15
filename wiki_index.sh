#/bin/bash

srcs=`find wiki -name "*.markdown" | sort -r`

touch cat1 cat2
echo "<!---title:Wiki-->" > wiki.markdown
echo "<!---tags:wiki-->" >> wiki.markdown
echo >> wiki.markdown
for s in ${srcs}
do
    category=`sed -n -e "s/<\!---category:\(.\+\)-->/\1/p" ${s}`
    case $category in
        个人原创)
            echo "* `sed -n -e "s/<\!---time:\(.\+\)-->/\1/p" ${s}` [`sed -n -e "s/<\!---title:\(.\+\)-->/\1/p" ${s}`](`echo ${s} | sed -n -e "s/markdown$/html/p"`) `sed -n -e "s/<\!---tags:\(.\+\)-->/\1/p" ${s}`" >> cat1
            ;;

        网络收藏)
            echo "* `sed -n -e "s/<\!---time:\(.\+\)-->/\1/p" ${s}` [`sed -n -e "s/<\!---title:\(.\+\)-->/\1/p" ${s}`](`echo ${s} | sed -n -e "s/markdown$/html/p"`) `sed -n -e "s/<\!---tags:\(.\+\)-->/\1/p" ${s}`" >> cat2
            ;;

        *)
            echo "${s} does not in known categories."
            ;;
    esac
done
echo "## 个人原创" >> wiki.markdown
cat cat1 >> wiki.markdown
echo >> wiki.markdown
echo "## 网络收藏" >> wiki.markdown
cat cat2 >> wiki.markdown
rm -f cat1 cat2

exit 0
