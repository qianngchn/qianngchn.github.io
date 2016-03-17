#/bin/bash

mark=$1
html=$2
sitename="Arcman"
sitekeywords="arcman"
flag+=" --css=style.css"
flag+=" --template=pandoctpl.html"
flag+=" --tab-stop=4"
flag+=" --toc"
flag+=" --include-in-header temp_in_header.html"
flag+=" --include-before-body temp_before_body.html"
flag+=" --include-after-body temp_after_body.html"
flag+=" --from=markdown --to=html"

# pandoc markdown to html
touch temp_in_header.html temp_before_body.html temp_after_body.html
sed -n -e "s/<\!---title:\(.\+\)-->/<title>\1 | $sitename<\/title>/p" $mark >> temp_in_header.html
sed -n -e "s/<\!---tags:\(.\+\)-->/<meta name=\"keywords\" content=\"\1, $sitekeywords\">/p" $mark >> temp_in_header.html
sed -n -e 's/<\!---title:\(.\+\)-->/<h2>\1<\/h2>/p' $mark >> temp_before_body.html
echo "<code>" >> temp_before_body.html
sed -n -e 's/<\!---category:\(.\+\)-->/==<a href=\"wiki.html#\l\1\">\1<\/a>==/p' $mark >> temp_before_body.html
sed -n -e 's/<\!---tags:\(.\+\)-->/| \1/p' $mark >> temp_before_body.html
sed -n -e 's/<\!---time:\(.\+\)-->/| \1/p' $mark >> temp_before_body.html
echo "| `stat $mark | tail -n2 | head -n1 | cut -d'.' -f1`" >> temp_before_body.html
echo "</code>" >> temp_before_body.html
echo "<hr/>" >> temp_before_body.html
echo "<hr/>" >> temp_after_body.html
echo "<code>| Author: qianngchn | Index: <a href="#">$html</a></code>" >> temp_after_body.html
pandoc $flag $mark -o $html
rm -f temp_in_header.html temp_before_body.html temp_after_body.html

# then fix html
style="style.css"
favicon="favicon.ico"
index="index.html"
wiki="wiki.html"
src=$html

while [ "`dirname ${src}`" != "." ]
do
    style=../${style}
    favicon=../${favicon}
    index=../${index}
    wiki=../${wiki}
    src=`dirname ${src}`
done

# modify stylesheet to relative path
sed -i -e "s#style.css#${style}#g" $html
# modify favicon to relative path
sed -i -e "s#favicon\.ico#${favicon}#g" $html
# modify html to relative path
sed -i -e "s#index\.html#${index}#g" $html
sed -i -e "s#wiki\.html#${wiki}#g" $html
# remove links of <hn> title in toc
sed -i -e "s#\(<h. id=\".\+\">\)<a href=\"\#.\+\">\(.\+\)</a>#\1\2#g" $html

exit 0
