#!/bin/bash

infile=$1 # input pdf
outputdir=$2
prefix="0"

[ -e "$infile" -a -d "$outputdir" ] || exit 1 # Invalid args

pagenumbers=( $(pdftk "$infile" dump_data | \
                grep -A1 '^BookmarkLevel: 2' | grep '^BookmarkPageNumber: ' | cut -f2 -d' ' | uniq)
              end )


for ((i=1; i < ${#pagenumbers[@]}; ++i)); do
  a=${pagenumbers[i-1]} # start page number
  b=${pagenumbers[i]} # end page number
  [ "$b" = "end" ] || b=$[b-2]
  echo "$i: $a-$b"
  if [ $i -eq 10 ] 
  then
    prefix=""
  fi
  pdftk "$infile" cat $a-$b output "${outputdir}/${prefix}$i".pdf
done
