BIBTOOL=bibtool-Mac

stmue.bib: ../../../Bibliographien/biblio.bib
	$(BIBTOOL) -r ../../hpsg/.bibtool77-no-comments ../../../Bibliographien/biblio.bib -o stmue.bib.tmp
	../../hpsg/make_bib_header
	cat bib_header.txt ../../../Bibliographien/bib-abbr.bib stmue.bib.tmp > stmue.bib
