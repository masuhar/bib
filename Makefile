BIBFILES	=	$(wildcard *.bib)
BASE	= format
BBLFILE	= $(BASE).bbl
TXTFILE	= $(BASE).txt
AUXFILE	= $(BASE).aux
SCRIPT = $(BASE).sed
HTMLFILE = $(BASE).html
HTML_MAKER = txt2html.rb

URLS	= urls.csv
RUBY = ruby1.9.1
BIBTEXOPTS = -min-crossrefs=99

$(HTMLFILE):	$(TXTFILE) $(HTML_MAKER) $(URLS)
	$(RUBY) $(HTML_MAKER) |tee $(HTMLFILE)

$(TXTFILE):	$(BBLFILE) $(SCRIPT)
	sed -f $(SCRIPT) $(BBLFILE) > $(TXTFILE).new &&\
	mv $(TXTFILE).new $(TXTFILE) &&\
	cat $(TXTFILE)

$(BBLFILE):	$(AUXFILE) $(BIBFILES)
	jbibtex $(BIBTEXOPTS) $(BASE)

clean:
	-rm *.aux *.log $(BBLFILE) $(TXTFILE)

%.aux:	%.tex
	platex $<
