#housekeeping	
clean:
	rm -f *.bak *~ *.backup \
	*.adx *.and *.idx *.ind *.ldx *.lnd *.sdx *.snd *.rdx *.rnd *.wdx *.wnd \
	*.log *.blg *.bcf *.aux.copy *.ilg \
	*.aux *.toc *.cut *.out *.tpm *.bbl *-blx.bib *_tmp.bib \
	*.glg *.glo *.gls *.wrd *.wdv *.xdv *.mw *.clr \
	*.run.xml 


cleanfor: # These files are precious, as it takes a long time to produce them all.
	rm -f *.for *.for.tmp hpsg-handbook.for.dir/*


realclean: clean
	rm -f *.dvi *.ps *.pdf
