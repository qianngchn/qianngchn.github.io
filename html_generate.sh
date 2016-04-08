#/bin/bash

mark=$1
html=$2

favicon="favicon.ico"
style="style.css"
title="Arcman"
keywords="arcman"

index="index.html"
wiki="wiki.html"

stitle=`sed -n '1,5s/^<\!---title:\(.*\)-->$/\1/p' $mark`
scategory=`sed -n '1,5s/^<\!---category:\(.*\)-->$/\1/p' $mark`
scategorylink=`echo $scategory | tr -d [:punct:] | tr [:upper:] [:lower:] | tr [=' '=] -`
stags=`sed -n '1,5s/^<\!---tags:\(.*\)-->$/\1/p' $mark`
sauthor=`sed -n '1,5s/^<\!---author:\(.*\)-->$/\1/p' $mark`
sdate=`sed -n '1,5s/^<\!---date:\(.*\)-->$/\1/p' $mark`

flag+=" --variable=lang:en_US"
flag+=" --highlight-style=haddock"
flag+=" --css=style.css"
flag+=" --include-in-header temp_in_header.html"
flag+=" --include-before-body temp_before_body.html"
flag+=" --table-of-contents"
flag+=" --toc-depth=4"
flag+=" --include-after-body temp_after_body.html"
flag+=" --template=pandoctpl.html"
flag+=" --tab-stop=4"
flag+=" --from=markdown --to=html"

echo "Generating $html"
# pandoc markdown to html
touch temp_in_header.html temp_before_body.html temp_after_body.html
echo "<title>$stitle | $title</title>" >> temp_in_header.html
echo "<meta name=\"keywords\" content=\"$stags, $keywords\">" >> temp_in_header.html
if [[ $html == *wiki/* ]]; then
    echo "<h2>$stitle</h2>" >> temp_before_body.html
    echo "<code>Category: <a href=\"$wiki#$scategorylink\">$scategory</a> | Tags: $stags ----------> <a href="$wiki">Back to Wiki</a></code>" >> temp_before_body.html
    echo "<code>Author: $sauthor | Date: $sdate ----------> <a href="#">Go to Top</a></code>" >> temp_after_body.html
fi
pandoc $flag $mark -o $html
rm -f temp_in_header.html temp_before_body.html temp_after_body.html

# then fix path in html
src=$html
while [ "`dirname ${src}`" != "." ]
do
    favicon=../${favicon}
    style=../${style}
    index=../${index}
    wiki=../${wiki}
    src=`dirname ${src}`
done
sed -i -e "s#style.css#${style}#g" $html
sed -i -e "s#favicon\.ico#${favicon}#g" $html
sed -i -e "s#index\.html#${index}#g" $html
sed -i -e "s#wiki\.html#${wiki}#g" $html

# then remove links of <hn> title in toc
sed -i -e "s#\(<h. id=\".\+\">\)<a href=\"\#.\+\">\(.\+\)</a>#\1\2#g" $html

exit 0
