# specify thh main file and all the files that you are including
SOURCE=  main.tex $(wildcard local*.tex) $(wildcard chapters/*.tex) $(wildcard Bibliographies/*.bib) \
langsci/langscibook.cls

# MacBook Pro 16" (2019) time make main.pdf  9:40 min  9:14 min                       554 sec
#                                           16:40 min 16:24 min (ohne Turboboost)     984 sec
# MacBook Pro 15" (2016) time make main.pdf 11:23 min                                 683 sec


# specify your main target here:
pdf:  main.bbl main.pdf  #by the time main.pdf, bib assures there is a newer aux file

all: pod cover

complete: index main.pdf

index:  main.snd



main.pdf: $(SOURCE)
	xelatex -no-pdf -shell-escape main
	biber main
	xelatex -no-pdf -shell-escape main
	sed -i.backup s/.*\\emph.*// main.adx #remove titles which biblatex puts into the name index
	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' main.sdx # ordering of references to footnotes
	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' main.adx
	sed -i.backup 's/hyperindexformat{\\\(infn {[0-9]*\)}/\1/' main.ldx
# 	python3 fixindex.py
# 	mv mainmod.adx $*.adx
	makeindex -o main.and main.adx
	makeindex -o main.lnd main.ldx
	makeindex -o main.snd main.sdx 
	xelatex -shell-escape main

stable.pdf: main.pdf
	cp main.pdf stable.pdf
	cp collection_tmp.bib chapters/collection.bib


chop: stable.pdf 
	egrep "contentsline \{chapter\}" main.toc | egrep -o "\{[0-9]+\}\{chapter\*\.[0-9]+\}" |  egrep -o "[0-9]+\}\{chapter"|egrep -o "[0-9]+" > cuts.txt
	egrep -o "\{chapter\}\{Indexes\}\{[0-9]+\}\{section\*\.[0-9]+\}" main.toc| egrep -o ".*\."|egrep -o "[0-9]+" >> cuts.txt
	bash chopchapters.sh 13 chapters main
# does not work on mac	
#	bash chopchapters.sh `grep "mainmatter starts" main.log|egrep -o "[0-9]*"`

commit-stable: chop 
	git commit -m "automatic creation of stable.pdf and chapters" stable.pdf chapters/collection.bib chapters-pdfs/
	git push -u origin

stable-commit: commit-stable



# prepublish.toc contains roman numbers this means we have to update main.pdf and take the numbers
# from main.toc. Takes a while ...
prepublish-pdfs: prepublish.pdf
	chopchapters-bookmarks.sh prepublish.pdf prepubs-chop-pdfs

prepublish-commit: prepublish-pdfs
	git commit -m "automatic creation of prepublish.pdf and chapters" prepubs-pdfs/
	git push -u origin



FINALIZED= chapters/evolution.tex chapters/lexicon.tex chapters/case.tex chapters/idioms.tex

prepubs-pdfs/evolution.pdf: chapters/evolution.tex
	xelatex -no-pdf -shell-escape prepublish
	biber prepublish
	xelatex -shell-escape prepublish
	chopchapters-bookmarks.sh prepublish.pdf prepubs-chop-pdfs
	cp prepubs-chop-pdfs/02.pdf prepubs-pdfs/evolution.pdf

prepubs-pdfs/lexicon.pdf: chapters/lexicon.tex
	xelatex -no-pdf -shell-escape prepublish
	biber prepublish
	xelatex -shell-escape prepublish
	chopchapters-bookmarks.sh prepublish.pdf prepubs-chop-pdfs
	cp prepubs-chop-pdfs/04.pdf prepubs-pdfs/lexicon.pdf

prepubs-pdfs/understudied-languages.pdf: chapters/understudied-langauges.tex
	xelatex -no-pdf -shell-escape prepublish
	biber prepublish
	xelatex -shell-escape prepublish
	chopchapters-bookmarks.sh prepublish.pdf prepubs-chop-pdfs
	cp prepubs-chop-pdfs/05.pdf prepubs-pdfs/understudied-languages.pdf

prepubs-pdfs/agreement.pdf: chapters/agreement.tex
	xelatex -no-pdf -shell-escape prepublish
	biber prepublish
	xelatex -shell-escape prepublish
	chopchapters-bookmarks.sh prepublish.pdf prepubs-chop-pdfs
	cp prepubs-chop-pdfs/06.pdf prepubs-pdfs/agreement.pdf

prepubs-pdfs/case.pdf: chapters/case.tex
	xelatex -no-pdf -shell-escape prepublish
	biber prepublish
	xelatex -shell-escape prepublish
	chopchapters-bookmarks.sh prepublish.pdf prepubs-chop-pdfs
	cp prepubs-chop-pdfs/07.pdf prepubs-pdfs/case.pdf

prepubs-pdfs/argument-structure.pdf: chapters/arg-st.tex
	xelatex -no-pdf -shell-escape prepublish
	biber prepublish
	xelatex -shell-escape prepublish
	chopchapters-bookmarks.sh prepublish.pdf prepubs-chop-pdfs
	cp prepubs-chop-pdfs/09.pdf prepubs-pdfs/argument-structure.pdf

prepubs-pdfs/relative-clauses.pdf: chapters/relative-clauses.tex
	xelatex -no-pdf -shell-escape prepublish
	biber prepublish
	xelatex -shell-escape prepublish
	chopchapters-bookmarks.sh prepublish.pdf prepubs-chop-pdfs
	cp prepubs-chop-pdfs/15.pdf prepubs-pdfs/relative-clauses.pdf

prepubs-pdfs/islands.pdf: chapters/islands.tex
	xelatex -no-pdf -shell-escape prepublish
	biber prepublish
	xelatex -shell-escape prepublish
	chopchapters-bookmarks.sh prepublish.pdf prepubs-chop-pdfs
	cp prepubs-chop-pdfs/16.pdf prepubs-pdfs/islands.pdf

prepubs-pdfs/idioms.pdf: chapters/idioms.tex
	xelatex -no-pdf -shell-escape prepublish
	biber prepublish
	xelatex -shell-escape prepublish
	chopchapters-bookmarks.sh prepublish.pdf prepubs-chop-pdfs
	cp prepubs-chop-pdfs/18.pdf prepubs-pdfs/idioms.pdf

prepubs-pdfs/negation.pdf: chapters/negation.tex
	xelatex -no-pdf -shell-escape prepublish
	biber prepublish
	xelatex -shell-escape prepublish
	chopchapters-bookmarks.sh prepublish.pdf prepubs-chop-pdfs
	cp prepubs-chop-pdfs/19.pdf prepubs-pdfs/negation.pdf


prepubs-pdfs/semantics.pdf: chapters/semantics.tex
	xelatex -no-pdf -shell-escape prepublish
	biber prepublish
	xelatex -shell-escape prepublish
	chopchapters-bookmarks.sh prepublish.pdf prepubs-chop-pdfs
	cp prepubs-chop-pdfs/23.pdf prepubs-pdfs/semantics.pdf

prepubs-pdfs/cl.pdf: chapters/cl.tex
	xelatex -no-pdf -shell-escape prepublish
	biber prepublish
	xelatex -shell-escape prepublish
	chopchapters-bookmarks.sh prepublish.pdf prepubs-chop-pdfs
	cp prepubs-chop-pdfs/28.pdf prepubs-pdfs/cl.pdf

prepubs-pdfs/hpsg-minimalism.pdf: chapters/minimalism.tex
	xelatex -no-pdf -shell-escape prepublish
	biber prepublish
	xelatex -shell-escape prepublish
	chopchapters-bookmarks.sh prepublish.pdf prepubs-chop-pdfs
	cp prepubs-chop-pdfs/32.pdf prepubs-pdfs/hpsg-minimalism.pdf

prepubs-pdfs/hpsg-categorial-grammar.pdf: chapters/cg.tex
	xelatex -no-pdf -shell-escape prepublish
	biber prepublish
	xelatex -shell-escape prepublish
	chopchapters-bookmarks.sh prepublish.pdf prepubs-chop-pdfs
	cp prepubs-chop-pdfs/33.pdf prepubs-pdfs/hpsg-categorial-grammar.pdf

prepubs-pdfs/hpsg-dg.pdf: chapters/dg.tex
	xelatex -no-pdf -shell-escape prepublish
	biber prepublish
	xelatex -shell-escape prepublish
	chopchapters-bookmarks.sh prepublish.pdf prepubs-chop-pdfs
	cp prepubs-chop-pdfs/33.pdf prepubs-pdfs/hpsg-dg.pdf

prepubs-pdfs/hpsg-cxg.pdf: chapters/cxg.tex
	xelatex -no-pdf -shell-escape prepublish
	biber prepublish
	xelatex -shell-escape prepublish
	chopchapters-bookmarks.sh prepublish.pdf prepubs-chop-pdfs
	cp prepubs-chop-pdfs/34.pdf prepubs-pdfs/hpsg-cxg.pdf



# the index is irrelevant so I removed index creation here
prepublish.pdf: $(SOURCE) prepublish.tex
	xelatex -no-pdf -shell-escape prepublish
	biber prepublish
	xelatex -no-pdf -shell-escape prepublish
	xelatex -shell-escape prepublish

prepubs-latex-cp: prepublish-pdfs
	cp prepubs-chop-pdfs/01.pdf prepubs-pdfs/basic-properties.pdf
	cp prepubs-chop-pdfs/02.pdf prepubs-pdfs/evolution.pdf
	cp prepubs-chop-pdfs/03.pdf prepubs-pdfs/formal-background.pdf
	cp prepubs-chop-pdfs/04.pdf prepubs-pdfs/lexicon.pdf
	cp prepubs-chop-pdfs/05.pdf prepubs-pdfs/understudied-languages.pdf
	cp prepubs-chop-pdfs/06.pdf prepubs-pdfs/agreement.pdf
	cp prepubs-chop-pdfs/07.pdf prepubs-pdfs/case.pdf
	cp prepubs-chop-pdfs/08.pdf prepubs-pdfs/nominal-structures.pdf
	cp prepubs-chop-pdfs/09.pdf prepubs-pdfs/argument-structure.pdf
	cp prepubs-chop-pdfs/10.pdf prepubs-pdfs/order.pdf
	cp prepubs-chop-pdfs/11.pdf prepubs-pdfs/clitics.pdf
	cp prepubs-chop-pdfs/12.pdf prepubs-pdfs/complex-predicates.pdf
	cp prepubs-chop-pdfs/13.pdf prepubs-pdfs/control-raising.pdf
	cp prepubs-chop-pdfs/14.pdf prepubs-pdfs/unbounded-dependencies.pdf
	cp prepubs-chop-pdfs/15.pdf prepubs-pdfs/relative-clauses.pdf
	cp prepubs-chop-pdfs/16.pdf prepubs-pdfs/islands.pdf
	cp prepubs-chop-pdfs/17.pdf prepubs-pdfs/coordination.pdf
	cp prepubs-chop-pdfs/18.pdf prepubs-pdfs/idioms.pdf
	cp prepubs-chop-pdfs/19.pdf prepubs-pdfs/negation.pdf
	cp prepubs-chop-pdfs/20.pdf prepubs-pdfs/ellipsis.pdf
	cp prepubs-chop-pdfs/21.pdf prepubs-pdfs/binding.pdf
	cp prepubs-chop-pdfs/22.pdf prepubs-pdfs/morphology.pdf
	cp prepubs-chop-pdfs/23.pdf prepubs-pdfs/semantics.pdf
	cp prepubs-chop-pdfs/24.pdf prepubs-pdfs/information-structure.pdf
	cp prepubs-chop-pdfs/25.pdf prepubs-pdfs/processing.pdf
	cp prepubs-chop-pdfs/26.pdf prepubs-pdfs/cl.pdf
	cp prepubs-chop-pdfs/27.pdf prepubs-pdfs/dialogue.pdf
	cp prepubs-chop-pdfs/28.pdf prepubs-pdfs/sign-languages.pdf
	cp prepubs-chop-pdfs/29.pdf prepubs-pdfs/gesture.pdf
	cp prepubs-chop-pdfs/30.pdf prepubs-pdfs/hpsg-minimalism.pdf
	cp prepubs-chop-pdfs/31.pdf prepubs-pdfs/hpsg-categorial-grammar.pdf
	cp prepubs-chop-pdfs/32.pdf prepubs-pdfs/hpsg-lfg.pdf
	cp prepubs-chop-pdfs/33.pdf prepubs-pdfs/hpsg-dependency-grammar.pdf
	cp prepubs-chop-pdfs/34.pdf prepubs-pdfs/hpsg-cxg.pdf


# 
prepublish: prepubs-latex-cp
# prepubs-pdfs/evolution.pdf prepubs-pdfs/lexicon.pdf prepubs-pdfs/agreement.pdf \
#             prepubs-pdfs/case.pdf prepubs-pdfs/relative-clauses.pdf prepubs-pdfs/islands.pdf prepubs-pdfs/idioms.pdf \
#             prepubs-pdfs/negation.pdf prepubs-pdfs/semantics.pdf prepubs-pdfs/hpsg-minimalism.pdf prepubs-pdfs/hpsg-dg.pdf prepubs-pdfs/hpsg-cxg.pdf
	rsync -a -e ssh prepubs-pdfs/ hpsg.hu-berlin.de:/var/www/html/Projects/HPSG-handbook/PDFs
	git commit -m "automatic creation of prepublished chapters" prepubs-pdfs/
	git push -u origin


#	scp prepubs-pdfs/32.pdf hpsg.hu-berlin.de:public_html/Pub/hpsg-minimalism.pdf


evolution.pdf: stable.pdf
	pdftk stable.pdf cat 19-46 output evolution.pdf

# Stefan's chapter on order
order.pdf: chop
	pdftk stable.pdf cat 161-191 output order.pdf

agreement.pdf: agreement.pdf
	pdftk stable.pdf cat 93-115 output agreement.pdf

arg-st.pdf: arg-st.pdf
	pdftk stable.pdf cat 145-184 output arg-st.pdf

case.pdf: stable.pdf
	pdftk stable.pdf cat 117-143 output case.pdf

islands.pdf: stable.pdf
	pdftk stable.pdf cat 231-279 output islands.pdf


processing.pdf: stable.pdf
	pdftk stable.pdf cat 261-281 output processing.pdf

gesture.pdf: stable.pdf
	pdftk stable.pdf cat 345-369 output gesture.pdf

# Stefan's chapter on cxg
cxg.pdf: stable.pdf
	pdftk stable.pdf cat 333-364 output cxg.pdf


#sm-public: order.pdf cxg.pdf
sm-public: chop
	scp chapters-pdfs/10.pdf hpsg.hu-berlin.de:public_html/Pub/constituent-order-hpsg.pdf
	scp chapters-pdfs/32.pdf hpsg.hu-berlin.de:public_html/Pub/hpsg-minimalism.pdf
	scp chapters-pdfs/36.pdf hpsg.hu-berlin.de:public_html/Pub/hpsg-cxg.pdf

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
	rm -f *.bak *~ *.backup \
	*.adx *.and *.idx *.ind *.ldx *.lnd *.sdx *.snd *.rdx *.rnd *.wdx *.wnd \
	*.log *.blg *.bcf *.aux.copy *.ilg \
	*.aux *.toc *.cut *.out *.tpm *.bbl *-blx.bib *_tmp.bib \
	*.glg *.glo *.gls *.wrd *.wdv *.xdv *.mw *.clr \
	*.run.xml \
	chapters/*.aux chapters/*.aux.copy chapters/*.old chapters/*~ chapters/*.bak chapters/*.backup chapters/*.blg\
	chapters/*.log chapters/*.out chapters/*.mw chapters/*.ldx  chapters/*.bbl chapters/*.bcf chapters/*.run.xml\
	chapters/*.blg chapters/*.idx chapters/*.sdx chapters/*.run.xml chapters/*.adx chapters/*.ldx\
	langsci/*/*.aux langsci/*/*~ langsci/*/*.bak langsci/*/*.backup \
	chapter-pdfs/* cuts.txt

cleanfor: # These files are precious, as it takes a long time to produce them all.
	rm -f *.for *.for.tmp hpsg-handbook.for.dir/*

realclean: clean
	rm -f *.dvi *.ps *.pdf

chapterlist:
	grep chapter main.toc|sed "s/.*numberline {[0-9]\+}\(.*\).newline.*/\\1/"


FORCE:
