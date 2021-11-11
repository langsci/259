# specify thh main file and all the files that you are including
SOURCE=  main.tex $(wildcard local*.tex) $(wildcard chapters/*.tex) 

# specify your main target here:
pdf: main.bbl main.pdf  #by the time main.pdf, bib assures there is a newer aux file
 
complete: index main.pdf

index:  main.snd
 
main.pdf: main.aux
	xelatex main 

main.aux: $(SOURCE)
	xelatex -no-pdf main 

#create only the book
main.bbl:  $(SOURCE) localbibliography.bib  
	xelatex -no-pdf main 
	biber   main 


main.snd: main.bbl
	touch main.adx main.sdx main.ldx
	sed -i s/.*\\emph.*// main.adx #remove titles which biblatex puts into the name index
	sed -i 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' main.sdx # ordering of references to footnotes
	sed -i 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' main.adx
	sed -i 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' main.ldx
	sed -i 's/.*Office.*//' main.adx
	sed -i 's/.*Team.*//' main.adx
	sed -i 's/.*Bureau.*//' main.adx
	sed -i 's/.*Organisation.*//' main.adx
	sed -i 's/.*Organization.*//' main.adx
	sed -i 's/.*Embassy.*//' main.adx
	sed -i 's/.*Association.*//' main.adx
	sed -i 's/.*Commission.*//' main.adx
	sed -i 's/.*committee.*//' main.adx
	sed -i 's/.*government.*//' main.adx
	sed -i 's/\\MakeCapital//' main.adx
	python3 fixindex.py
	mv mainmod.adx main.adx
	makeindex -o main.and main.adx
	makeindex -o main.lnd main.ldx
	makeindex -o main.snd main.sdx 
	xelatex main 
 

#create a png of the cover
cover: FORCE
	convert main.pdf\[0\] -quality 100 -background white -alpha remove -bordercolor "#999999" -border 2  cover.png
	cp cover.png googlebooks_frontcover.png
	convert -geometry 50x50% cover.png covertwitter.png
	convert main.pdf\[0\] -quality 100 -background white -alpha remove -bordercolor "#999999" -border 2  -resize x495 coveromp.png
	display cover.png

openreview: openreview.pdf
	
openreview.pdf: 
	pdftk main.pdf multistamp orstamp.pdf output openreview.pdf 

proofreading: proofreading.pdf
	
githubrepo: localmetadata.tex proofreading versions.json
	grep lsID localmetadata.tex |egrep -o "[0-9]*" > ID	
	git clone https://github.com/langsci/`cat ID`.git
	cp proofreading.pdf Makefile versions.json `cat ID`
	mv `cat ID` ..
	
versions.json: 
	grep "^.title{" localmetadata.tex|grep -o "{.*"|egrep -o "[^{}]+">title
	grep "^.author{" localmetadata.tex|grep -o "{.*"|egrep -o "[^{}]+" |sed 's/ and/"},{"name":"/g'>author
	echo '{"versions": [{"versiontype": "proofreading",' >versions.json
	echo -n '		"title": "' >>versions.json
	echo -n `cat title` >> versions.json
	echo  '",' >> versions.json
	echo -n  '		"authors": [{"name": "'>> versions.json
	echo -n `cat author` >> versions.json 
	echo  '"}],' >> versions.json 
	echo  '	"license": "CC-BY-4.0",'>> versions.json
	echo -n '	"publishedAt": "' >> versions.json
	echo -n `date --rfc-3339=s|sed s/" "/T/|sed s/+.*/.000Z/` >> versions.json
	echo -n '"'>> versions.json
	echo  '}'>> versions.json
	echo  '	]'>> versions.json
	echo  '}'>> versions.json
	rm author title
	
paperhive:  proofreading.pdf versions.json README.md
	(git commit -m 'new README' README.md && git push) || echo "README up to date" #this is needed for empty repositories, otherwise they cannot be branched
	git checkout gh-pages || git branch gh-pages; git checkout gh-pages
	git add proofreading.pdf versions.json
	git commit -m 'prepare for proofreading' proofreading.pdf versions.json
	git push origin gh-pages
	sleep 3
	curl -X POST 'https://paperhive.org/api/document-items/remote?type=langsci&id='`basename $(pwd)`
	git checkout main
	git commit -m 'new README' README.md
	git push
		
firstedition:
	git checkout gh-pages
	git pull origin gh-pages
	basename `pwd` > ID
	python getfirstedition.py  `cat ID`
	git add first_edition.pdf 
	git commit -am 'provide first edition'
	git push origin gh-pages 
	git checkout main 
	curl -X POST 'https://paperhive.org/api/document-items/remote?type=langsci&id='`cat ID`
	
	
proofreading.pdf:
	pdftk main.pdf multistamp prstamp.pdf output proofreading.pdf 
	
	
chop:  
	egrep -o "\{[0-9]+\}\{chapter\.[0-9]+\}" main.toc| egrep -o "[0-9]+\}\{chapter"|egrep -o [0-9]+ > cuts.txt
	egrep -o "\{chapter\}\{Index\}\{[0-9]+\}\{section\*\.[0-9]+\}" main.toc| grep -o "\..*"|egrep -o [0-9]+ >> cuts.txt
	bash chopchapters.sh `grep "mainmatter starts" main.log|grep -o "[0-9]*" $1 $2`
	
chapternames:
	egrep -o "\{chapter\}\{\\\numberline \{[0-9]+}[A-Z][^\}]+\}" main.toc | egrep -o "[[:upper:]][^\}]+" > chapternames	
	
#housekeeping	
clean:
	rm -f *.bak *~ *.backup *.tmp \
	*.adx *.and *.idx *.ind *.ldx *.lnd *.sdx *.snd *.rdx *.rnd *.wdx *.wnd \
	*.log *.blg *.ilg \
	*.aux *.toc *.cut *.out *.tpm *.bbl *-blx.bib *_tmp.bib *bcf \
	*.glg *.glo *.gls *.wrd *.wdv *.xdv *.mw *.clr *.pgs\
	main.run.xml\
	chapters/*aux chapters/*~ chapters/*.bak chapters/*.backup\
	langsci/*/*aux langsci/*/*~ langsci/*/*.bak langsci/*/*.backup

realclean: clean
	rm -f *.dvi *.ps *.pdf

chapterlist:
	grep chapter main.toc|sed "s/.*numberline {[0-9]\+}\(.*\).newline.*/\\1/" 


barechapters:
	cat chapters/*tex | detex > barechapters.txt

languagecandidates:
	grep -ohP "(?<=[a-z]|[0-9])(\))?(,)? (\()?[A-Z]['a-zA-Z-]+" chapters/*tex| grep -o  [A-Z].* |sort -u >languagelist.txt


FORCE:

README.md: 
	echo `grep title localmetadata.tex|sed "s/\\\\\title{\(.*\)}/\# \1/"` > README.md
	echo '## Publication Info' >> README.md
	echo -n '- Authors: ' >> README.md
	echo `grep author localmetadata.tex|sed "s/\\\\\author{\(.*\)}/\1/"` >> README.md
	echo "- Publication Date: not yet published" >> README.md
	echo -n "- Series: " >> README.md
	echo `grep "lsSeries}" localmetadata.tex|sed "s/.*lsSeries}{\(.*\)}/\1/"` >> README.md
	echo "## Description" >> README.md
	echo -n "[Book page on langsci-press.org](http://langsci-press.org/catalog/book/" >> README.md
	echo  `grep lsID localmetadata.tex|sed "s/.*lsID\}{\(.*\)}/\1)/"` >> README.md 
	echo "## License" >> README.md
	echo "Copyright: (c) 2017, the authors." >> README.md
	echo "All data, code and documentation in this repository is published under the [Creative Commons Attribution 4.0 Licence](http://creativecommons.org/licenses/by/4.0/) (CC BY 4.0)." >> README.md

	
supersede: convert cover.png -fill white -colorize 60%  -pointsize 64 -draw "gravity center fill red rotate -45  text 0,12 'superseded' "  superseded.png; display superseded.png


wikicite: 
	echo '<ref name="abc">{{Cite book' > wiki
	echo -n "| vauthors = " >>wiki; echo `grep author localmetadata.tex|sed "s/\\\\\author{\(.*\)}/\1/"`  >>wiki
	echo -n "| title =" >>wiki; echo `grep title localmetadata.tex|sed "s/\\\\\title{\(.*\)}/\1/"` >>wiki
	echo    "| place = Berlin" >>wiki 
	echo    "| publisher = Language Science Press" >>wiki
	echo    "| date = 2018" >>wiki
	echo    "| format = pdf" >>wiki
	echo -n "| url = http://langsci-press.org/catalog/book/"  >>wiki; echo `grep lsID localmetadata.tex|sed "s/.*lsID\}{\(.*\)}/\1/"` >>wiki
	echo -n "| doi =" >>wiki; echo `cat doi` >>wiki
	echo    "| doi-access=free" >>wiki
	echo -n "| isbn = " >>wiki;  echo `grep lsISBNdigital localmetadata.tex|sed "s/.*lsISBNdigital\}{\(.*\)}/\1)/"` >>wiki
	echo "}}" >>wiki
	echo " </ref>" >>wiki
	more wiki
