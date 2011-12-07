#!/bin/bash

set -e

tablist=""

files=$@

mkdir -p target/neaten

for file in $files
do
    generated='0'
    if [ ! -e $file ]
    then
        echo "$file does not exists."
        exit 1
    elif [ -e ${file%.java}.lex ]
    then
        generated='1'
    elif [ `egrep -l "[ 	]+$" $file` ]
    then
        echo "Removing trailing white space from $file."
        mv "$file" temp
        sed 's/[ 	]*$//' temp > "$file"
    fi
    if [ $generated -eq '0' ]
    then
        tablist="$tablist $file"  
    fi    
done
if [ "$tablist" != "" ]
then
	java -classpath target/depend/ostermillerutils/ostermillerutils.jar com.Ostermiller.util.Tabs -w 4 -tv $tablist
fi


touch target/neaten/neatened
