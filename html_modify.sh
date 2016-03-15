#/bin/bash

src=$1
style="style.css"
favicon="favicon.ico"
index="index.html"
wiki="wiki.html"

while [ "`dirname ${src}`" != "." ]
do
    style=../${style}
    favicon=../${favicon}
    index=../${index}
    wiki=../${wiki}
    src=`dirname ${src}`
done

# modify stylesheet to relative path
sed -i -e "s#style.css#${style}#g" $1
# modify favicon to relative path
sed -i -e "s#favicon\.ico#${favicon}#g" $1
# modify html to relative path
sed -i -e "s#index\.html#${index}#g" $1
sed -i -e "s#wiki\.html#${wiki}#g" $1
# remove links of <hn> title in toc
sed -i -e "s#\(<h. id=\".\+\">\)<a href=\"\#.\+\">\(.\+\)</a>#\1\2#g" $1
exit 0
