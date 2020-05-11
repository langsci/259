# to produce the externalized figures:
# delete everyting! 
# do make brutal-clean
# go to ../localcommands.tex and comment \tikzexternalize
# do make all
# go to ../localcommands.tex and comment \tikzexternalize
# do \rm *.pdf; make all


all: properties.pdf evolution.pdf formal-background.pdf lexicon.pdf understudied-languages.pdf\
	agreement.pdf case.pdf np.pdf arg-st.pdf order.pdf clitics.pdf complex-predicates.pdf\
	control-raising.pdf udc.pdf relative-clauses.pdf islands.pdf coordination.pdf idioms.pdf\
	negation.pdf ellipsis.pdf binding.pdf\
	morphology.pdf semantics.pdf information-structure.pdf\
	processing.pdf cl.pdf pragmatics.pdf sign-lg.pdf gesture.pdf\
	minimalism.pdf cg.pdf lfg.pdf dg.pdf cxg.pdf


%.pdf: %.tex 
	xelatex -shell-escape $*


#housekeeping	
clean:
	rm -f *.bak *~ *.backup \
	*.adx *.and *.idx *.ind *.ldx *.lnd *.sdx *.snd *.rdx *.rnd *.wdx *.wnd \
	*.log *.blg *.bcf *.aux.copy *.auxlock *.ilg \
	*.aux *.toc *.cut *.out *.tpm *.bbl *-blx.bib *_tmp.bib \
	*.glg *.glo *.gls *.wrd *.wdv *.xdv *.mw *.clr \
	*.run.xml 

git-add:
	git add hpsg-handbook.for.dir/*.pdf
	git add hpsg-handbook.for


cleanmemo:
	rm -f hpsg-handbook.mmz hpsg-handbook.memo.dir/*

brutal-clean: realclean cleanmemo


realclean: clean
	rm -f *.dvi *.ps *.pdf
