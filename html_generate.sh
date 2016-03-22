#/bin/bash

mark=$1
html=$2

lang="en_US"
author="qianngchn"
date=`date +%F`
style="style.css"
favicon="favicon.ico"
title="Arcman"
keywords="arcman"

index="index.html"
wiki="wiki.html"

stitle=`sed -n '1,4s/^<\!---title:\(.*\)-->$/\1/p' $mark`
scategory=`sed -n '1,4s/^<\!---category:\(.*\)-->$/\1/p' $mark`
scategorylink=`echo $scategory | tr -d [:punct:] | tr [:upper:] [:lower:] | tr [=' '=] -`
stags=`sed -n '1,4s/^<\!---tags:\(.*\)-->$/\1/p' $mark`
sdate=`sed -n '1,4s/^<\!---date:\(.*\)-->$/\1/p' $mark`

flag+=" --variable=lang:$lang"
flag+=" --metadata=author:$author"
flag+=" --metadata=date:$date"
flag+=" --highlight-style=haddock"
flag+=" --css=style.css"
flag+=" --include-in-header temp_in_header.html"
flag+=" --include-before-body temp_before_body.html"
flag+=" --table-of-contents"
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
    echo "<h1>$stitle</h1>" >> temp_before_body.html
    echo "<code>Category: <a href=\"$wiki#$scategorylink\">$scategory</a> | Tags: $stags ----------> <a href="$wiki">Back to Wiki</a></code>" >> temp_before_body.html
    echo "<code>Author: $author | Date: $sdate ----------> <a href="#">Go to Top</a></code>" >> temp_after_body.html
fi
pandoc $flag $mark -o $html
rm -f temp_in_header.html temp_before_body.html temp_after_body.html

# then fix path in html
src=$html
while [ "`dirname ${src}`" != "." ]
do
    style=../${style}
    favicon=../${favicon}
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
