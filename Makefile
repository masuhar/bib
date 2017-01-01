BIBFILES	=	$(wildcard *.bib)
CITATIONS	= format
BBLFILE	= $(CITATIONS).bbl
TXTFILE	= $(CITATIONS).txt
AUXFILE	= $(CITATIONS).aux
CLEANER = cleaner.sed
HTMLFILE = $(CITATIONS).html
HTML_MAKER = bbl2html.rb
BIBTEX = pbibtex -kanji=jis

URLS	= urls.csv
#RUBY = /home/masuhara/.rvm/rubies/ruby-1.9.3-p0/bin/ruby
RUBY = ruby
BIBTEXOPTS = -min-crossrefs=99

all:	$(HTMLFILE) $(TXTFILE)

$(HTMLFILE):	$(BBLFILE) $(HTML_MAKER) $(URLS)
	$(RUBY) $(HTML_MAKER) --html $(URLS) $(BBLFILE) |tee $(HTMLFILE)

# output in Kakenhi seika houkokusho
$(TXTFILE):	$(BBLFILE) $(HTML_MAKER) $(URLS)
	$(RUBY) $(HTML_MAKER) --txt /dev/null $(BBLFILE) |tee $(TXTFILE)

#$(TXTFILE):	$(BBLFILE) $(CLEANER)
#	sed -f $(CLEANER) $(BBLFILE) > $(TXTFILE).new &&\
#	mv $(TXTFILE).new $(TXTFILE) &&\
#	cat $(TXTFILE)

$(BBLFILE):	$(AUXFILE) $(BIBFILES)
	-rm $(AUXFILE)
	platex -kanji=jis $(BBLFILE:%.bbl=%.tex)
	$(BIBTEX) $(BIBTEXOPTS) $(CITATIONS)

clean:
	-rm *.aux *.log $(BBLFILE) $(TXTFILE)

%.aux:	%.tex
	platex $<
