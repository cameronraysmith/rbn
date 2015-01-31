.PHONY: default copybib clean cleanall test

#---------------------------------------------
# Define variables

# list of automatic variables
# http://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html#Automatic-Variables

PROJECTNAME = rbn2

TOPTEX = paper.tex

TOPPDFFILE = $(TOPTEX:.tex=.pdf)

TOPBBLFILE = $(TOPTEX:.tex=.bbl)

BIBFILES = bib/books.bib \
	   bib/papers.bib

TEMPLATE = plost2009.bst

FIGFILES = $(shell grep -v '^%' tex/*.tex | grep -ohP 'fig/.*(?=\})')

TEXFILES = $(shell ls tex/*.tex)

#---------------------------------------------
# Default target
# will run with
# >make
# alone

default: $(TOPPDFFILE)

#----------------------------------------------
# Additional targets

copybib:
	cp ~/Downloads/bibtex/theoreticalbiology.bib bib/papers.bib
	cp ~/Downloads/bibtex/books.bib bib/
	python bib/remove_url.py bib/papers.bib
	python bib/remove_url.py bib/books.bib

copydownloadsbib:
	cp ~/Downloads/bibtex/theoreticalbiology.bib ~/Downloads/bib/papers.bib
	cp ~/Downloads/bibtex/books.bib ~/Downloads/bib/
	python ~/Downloads/bib/remove_url.py ~/Downloads/bib/papers.bib
	python ~/Downloads/bib/remove_url.py ~/Downloads/bib/books.bib

linkbib:
	ln -s ~/Downloads/bib bib

dropbox:
	mkdir -p ~/Dropbox/sharelatex/$(PROJECTNAME)/tex
	mkdir -p ~/Dropbox/sharelatex/$(PROJECTNAME)/fig
	mkdir -p ~/Dropbox/sharelatex/$(PROJECTNAME)/bib
	cp $(TOPTEX) ~/Dropbox/sharelatex/$(PROJECTNAME)
	cp *header.tex ~/Dropbox/sharelatex/$(PROJECTNAME)
	cp *.bst ~/Dropbox/sharelatex/$(PROJECTNAME)
	cp $(TEXFILES) ~/Dropbox/sharelatex/$(PROJECTNAME)/tex
	cp $(FIGFILES) ~/Dropbox/sharelatex/$(PROJECTNAME)/fig
	cp bib/*.bib ~/Dropbox/sharelatex/$(PROJECTNAME)/bib

arxiv:
	latexpand $(TOPTEX) > combined.tex
	sed -i 's/\\makeatletter{}//g' combined.tex
	cp $(TOPBBLFILE) combined.bbl
	tar --transform='flags=r;s|combined.tex|paper.tex|' -cvzf arxiv`date +"%m%d%Y"`.tar.gz combined.tex combined.bbl $(FIGFILES)

$(BIBFILES):
	copybib

$(TEMPLATE):
	echo $(TEMPLATE)

$(TOPPDFFILE): $(TOPTEX) $(BIBFILES) $(TEMPLATE)
	if which latexmk > /dev/null 2>&1 ;\
	then latexmk -pdf $<;\
	else echo "Install latexmk"; fi

clean:
	rm -f *.aux *.bbl *.blg *.brf *.dvi *.fdb_latexmk *.fls *.lof *.log \
	      *.lot *.nav *.out *.pre *.snm *.synctex.gz *.toc *.dot *-dot2tex-*

cleanall: clean
	rm -f $(TOPPDFFILE)

test:
	echo $(TOPPDFFILE)

#---------------------------------------------
