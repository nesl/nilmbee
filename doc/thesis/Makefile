
all: thesis

thesis:
	latex thesismain
	bibtex thesismain
	latex thesismain
	latex thesismain
	dvipdfmx thesismain

clean:
	rm -f *.aux *.lof *.lot *.toc *.log *.bbl *.blg

