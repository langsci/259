chapternumber=0 
offset=$1
offset=$(($offset-1))
old=1
prefix="0"
for pagenumber in `cat cuts.txt`
do 
new=$(($pagenumber+offset))
if [ $chapternumber -eq 10 ]; then
  prefix=""
fi
echo $prefix$chapternumber $old-$(($new-1))

pdftk main.pdf cat $old-$(($new-1)) output chapters-pdfs/$prefix$chapternumber.pdf 
old=$new
chapternumber=$(($chapternumber+1))
done
