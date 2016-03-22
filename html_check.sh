#/bin/bash

src=$1

parent_path=`dirname $src`
locallinks=`sed -n 's/.*\[.*\](\(.*\)).*/\1/p' $src | grep -v "http" | grep -v "mailto"`
locallinks+=`sed -n 's/.*\[.*\]:\(.*\).*/\1/p' $src | grep -v "http" | grep -v "mailto"`

echo "Checking $src"
for link in $locallinks
do
    if [[ $link == */* ]] && [ ! -f "$parent_path/$link" ]; then
        echo "$parent_path/$link does not exsit."
        exit 1
    fi
done
exit 0
