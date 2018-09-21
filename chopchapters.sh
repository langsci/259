chapternumber=0 
offset=$1
offset=$(($offset-1))
old=1
for pagenumber in `cat cuts.txt`
do 
new=$(($pagenumber+offset))
echo $i $old-$(($new-1))
pdftk main.pdf cat $old-$(($new-1)) output chapter-pdfs/$chapternumber.pdf 
old=$new
chapternumber=$(($chapternumber+1))
done
