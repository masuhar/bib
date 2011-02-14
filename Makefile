BIBFILES	=	$(wildcard *.bib)
BASE	= format
BBLFILE	= $(BASE).bbl
AUXFILE	= $(BASE).aux
BIBTEXOPTS = -min-crossrefs=99

$(BBLFILE):	$(AUXFILE) $(BIBFILES)
	jbibtex $(BIBTEXOPTS) $(BASE)
	cat $(BBLFILE)
clean:
	-rm *.aux *.log $(BBLFILE)

%.aux:	%.tex
	platex $<
