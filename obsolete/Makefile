#
EBIBFILES =	masuhara.bib abcl.bib reflection.bib misc.bib
JJBIBFILES =	masuhara-jj.bib japanese-j.bib 
JEBIBFILES =	masuhara-je.bib japanese-e.bib
DOINCLUDE =	./doinclude

.SUFFIXES:	.b .bib

.b.bib:
	$(DOINCLUDE) $<

all:	$(EBIBFILES) $(JJBIBFILES) $(JEBIBFILES)

$(EBIBFILES) $(JJBIBFILES) $(JEBIBFILES): strings.bib
$(JJBIBFILES): strings-e.bib
$(JEBIBFILES): strings-j.bib	
