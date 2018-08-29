# specify thh main file and all the files that you are including
SOURCE=  main.tex $(wildcard local*.tex) $(wildcard chapters/*.tex) \
langsci/langscibook.cls

# specify your main target here:
pdf:  main.bbl main.pdf  #by the time main.pdf, bib assures there is a newer aux file

all: pod cover

complete: index main.pdf

index:  main.snd



main.pdf: $(SOURCE)
	xelatex -no-pdf main
	biber main
	xelatex -no-pdf main
	sed -i.backup s/.*\\emph.*// main.adx #remove titles which biblatex puts into the name index
	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' main.sdx # ordering of references to footnotes
	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' main.adx
	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' main.ldx
# 	python3 fixindex.py
# 	mv mainmod.adx $*.adx
	makeindex -o main.and main.adx
	makeindex -o main.lnd main.ldx
	makeindex -o main.snd main.sdx 
	xelatex main

stable.pdf: main.pdf
	cp main.pdf stable.pdf


# 
lexicon.pdf: stable.pdf
	pdftk stable.pdf cat 49-88 output lexicon.pdf


evolution.pdf: stable.pdf
	pdftk stable.pdf cat 19-46 output evolution.pdf

# Stefan's chapter on order
order.pdf: stable.pdf
	pdftk stable.pdf cat 161-191 output order.pdf

agreement.pdf: agreement.pdf
	pdftk stable.pdf cat 93-115 output agreement.pdf

arg-st.pdf: arg-st.pdf
	pdftk stable.pdf cat 145-184 output arg-st.pdf

case.pdf: stable.pdf
	pdftk stable.pdf cat 117-143 output case.pdf


processing.pdf: stable.pdf
	pdftk stable.pdf cat 261-281 output processing.pdf

# Stefan's chapter on cxg
cxg.pdf: stable.pdf
	pdftk stable.pdf cat 337-368 output cxg.pdf


sm-public: order.pdf cxg.pdf
	scp order.pdf hpsg.hu-berlin.de:public_html/Pub/constituent-order-hpsg.pdf
	scp cxg.pdf hpsg.hu-berlin.de:public_html/Pub/hpsg-cxg.pdf

#main.pdf: main.aux
#	xelatex main 

main.aux: $(SOURCE)
	xelatex -no-pdf main 

#create only the book
main.bbl:  $(SOURCE) localbibliography.bib  $(wildcard Bibliographies/*.bib)
	xelatex -no-pdf main 
	biber main


main.snd: FORCE
	touch main.adx main.sdx main.ldx
	sed -i.backup s/.*\\emph.*// main.adx #remove titles which biblatex puts into the name index
	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' main.sdx # ordering of references to footnotes
	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' main.adx
	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' main.ldx
# 	python3 fixindex.py
# 	mv mainmod.adx main.adx
	makeindex -o main.and main.adx
	makeindex -o main.lnd main.ldx
	makeindex -o main.snd main.sdx 
	xelatex main 


#create a png of the cover
cover: FORCE
	convert main.pdf\[0\] -quality 100 -background white -alpha remove -bordercolor "#999999" -border 2  cover.png
	cp cover.png googlebooks_frontcover.png
	convert -geometry 50x50% cover.png covertwitter.png
	display cover.png

googlebooks: googlebooks_interior.pdf

googlebooks_interior.pdf: complete
	cp main.pdf googlebooks_interior.pdf
	pdftk main.pdf cat 1 output googlebooks_frontcover.pdf 

openreview: openreview.pdf


openreview.pdf: main.pdf
	pdftk main.pdf multistamp orstamp.pdf output openreview.pdf 

proofreading: proofreading.pdf


proofreading.pdf: main.pdf
	pdftk main.pdf multistamp prstamp.pdf output proofreading.pdf 


paperhive: 
	git branch gh-pages
	git checkout gh-pages
	git add proofreading.pdf versions.json
	git commit -m 'prepare for proofreading' proofreading.pdf versions.json
	git push origin gh-pages
	git checkout master 
	echo "langsci.github.io/BOOKID"
	firefox https://paperhive.org/documents/new


blurb: blurb.html blurb.tex biosketch.tex biosketch.html


blurb.tex: blurb.md
	pandoc -f markdown -t latex blurb.md>blurb.tex

blurb.html: blurb.md
	pandoc -f markdown -t html blurb.md>blurb.html

biosketch.tex: blurb.md
	pandoc -f markdown -t latex biosketch.md>biosketch.tex

biosketch.html: blurb.md
	pandoc -f markdown -t html biosketch.md>biosketch.html

#housekeeping	
clean:
	rm -f *.bak *~ *.backup *.tmp \
	*.adx *.and *.idx *.ind *.ldx *.lnd *.sdx *.snd *.rdx *.rnd *.wdx *.wnd \
	*.log *.blg *.ilg \
	*.aux *.toc *.cut *.out *.tpm *.bbl *-blx.bib *_tmp.bib \
	*.glg *.glo *.gls *.wrd *.wdv *.xdv *.mw *.clr \
	*.run.xml \
	chapters/*aux chapters/*~ chapters/*.bak chapters/*.backup\
	langsci/*/*aux langsci/*/*~ langsci/*/*.bak langsci/*/*.backup


realclean: clean
	rm -f *.dvi *.ps *.pdf

chapterlist:
	grep chapter main.toc|sed "s/.*numberline {[0-9]\+}\(.*\).newline.*/\\1/"


FORCE:
