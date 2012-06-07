
all: thesis

thesis: figures
	latex thesismain
	bibtex thesismain
	latex thesismain
	latex thesismain
	dvipdfmx thesismain

%.eps: %.pdf
	pdftops -eps $< $*.eps

figures: figures/hwoverview.eps figures/eventdetect.eps figures/slots.eps figures/packet.eps 

clean:
	rm -f *.aux *.lof *.lot *.toc *.log *.bbl *.blg
	rm -f figures/hwoverview.eps figures/eventdetect.eps figures/slots.eps figures/packet.eps 

