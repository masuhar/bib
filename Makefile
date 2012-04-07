BIBFILES	=	$(wildcard *.bib)
CITATIONS	= format
BBLFILE	= $(CITATIONS).bbl
TXTFILE	= $(CITATIONS).txt
AUXFILE	= $(CITATIONS).aux
CLEANER = cleaner.sed
HTMLFILE = $(CITATIONS).html
HTML_MAKER = bbl2html.rb

URLS	= urls.csv
RUBY = ruby1.9.1
BIBTEXOPTS = -min-crossrefs=99

# output in Kakenhi seika houkokusho
$(HTMLFILE):	$(BBLFILE) $(HTML_MAKER) $(URLS)
	$(RUBY) $(HTML_MAKER) $(URLS) $(BBLFILE) |tee $(HTMLFILE)

#$(TXTFILE):	$(BBLFILE) $(HTML_MAKER) $(URLS)
#	$(RUBY) $(HTML_MAKER) /dev/null $(BBLFILE) |tee $(TXTFILE)

#$(TXTFILE):	$(BBLFILE) $(CLEANER)
#	sed -f $(CLEANER) $(BBLFILE) > $(TXTFILE).new &&\
#	mv $(TXTFILE).new $(TXTFILE) &&\
#	cat $(TXTFILE)

$(BBLFILE):	$(AUXFILE) $(BIBFILES)
	jbibtex $(BIBTEXOPTS) $(CITATIONS)

clean:
	-rm *.aux *.log $(BBLFILE) $(TXTFILE)

%.aux:	%.tex
	platex $<
