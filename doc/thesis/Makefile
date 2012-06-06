
all: thesis

thesis: figures
	latex thesismain
	bibtex thesismain
	latex thesismain
	latex thesismain
	dvipdfmx thesismain

%.eps: %.pdf
	pdf2ps $< $*.ps
	ps2eps -B -f $*.ps

figures: figures/hwoverview.eps

clean:
	rm -f *.aux *.lof *.lot *.toc *.log *.bbl *.blg
	rm -f figures/hwoverview.eps

