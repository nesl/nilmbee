FIGURES = figures/hwoverview.eps \
          figures/eventdetect.eps \
          figures/slots.eps \
          figures/packet.eps \
          figures/algooverview.eps \
          figures/pwc.eps

all: thesis

thesis: figures
	latex thesismain
	bibtex thesismain
	latex thesismain
	latex thesismain
	dvipdfmx -o MS-thesis-Tianji.pdf thesismain

%.eps: %.pdf
	pdftops -eps $< $*.eps

figures: $(FIGURES)

clean:
	rm -f *.aux *.lof *.lot *.toc *.log *.bbl *.blg
	rm -f $(FIGURES)
	
	