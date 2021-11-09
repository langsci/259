chapternumber=0 
offset=$1
author=$2
offset=$(($offset-1))
old=1
workingdirectory=`pwd`
prefix=`basename $workingdirectory`
for pagenumber in `cat cuts.txt`
do
new=$(($pagenumber+offset))
echo $old-$(($new-1))
difference=$(($new-$old))
if [[ $difference == 2 ]]; then
    echo " skipping part. No partial pdf generated"
    old=$new
    continue
fi
pdftk main.pdf cat $old-$(($new-1)) output $prefix-$author-`date +"%Y"`-$chapternumber.pdf
old=$new
chapternumber=$(($chapternumber+1))
done
