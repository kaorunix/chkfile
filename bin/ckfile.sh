#!/bin/bash

TARGET_DIR=$1
DELAY_MINUTES=$2

DATETIME=$(date "+%Y%m%d%H%M%S")
#FILETIME=$(ls -lD "%Y%m%d%H%M%S" | awk '{ print $6","$7 }')
DELAY_MINSEC=$(expr "$DELAY_MINUTES" "*" "60")

FILES=""

cd $TARGET_DIR
IFS=$'\n'
for line in $(ls -lD "%Y%m%d%H%M%S")
do
    #echo "line=$line"
    echo $line | grep -q total
    # echo "RET=${PIPESTATUS[1]}"
    RET=${PIPESTATUS[1]}
    if [ $RET = "0" ];then
	#echo "continue"
	continue
    fi
    IFS=, read FILETIME FILENAME _ <<< "$(echo $line | awk '{ print $6","$7 }')"
    #echo "FILETIME=$FILETIME DATETIME=$DATETIME FILENAME=$FILENAME DELAY_MINSEC=$DELAY_MINSEC"
    if [ $(expr "$DATETIME" - "$FILETIME" ) -gt $DELAY_MINSEC ]; then
	FILES=$(printf "%s\n%s" "$FILES" "$FILENAME $FILETIME")
    fi
done

if [ $FILES != "" ];then
    echo "Found files more than $DELAY_MINUTES minuts"
    echo $FILES
fi

