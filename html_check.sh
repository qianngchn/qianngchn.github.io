#/bin/bash

srcs=`find -name "*.markdown" | sort`

for s in ${srcs}
do
    echo "Checking ${s}"
    parent_path=`dirname ${s}`
    locallinks=`sed -n -e "s/\(.*\[.*\](\(.*\)).*\)/\2/p" $s | grep -v "http" | grep -v "mailto"`
    for link in ${locallinks}
    do
        if [ ! -f ${parent_path}/${link} ]; then
            echo "${parent_path}/${link} does not exsit."
    exit 1
        fi
    done
done
exit 0
