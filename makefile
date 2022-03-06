LATEX=latexmk --pdf
THESIS=thesis.pdf
ABSTRACT=abstract/abstract.pdf
TEMPLATE=template/blank.tex

template: template/blank.tex template/mffthesis.cls
	$(LATEX) $(TEMPLATE)
	zathura blank.pdf

all: $(THESIS) $(ABSTRACT) ## compile everything
see: thesis ## update and see thesis
	zathura $(THESIS)

$(THESIS): $(THESIS:.pdf=.tex) $(THESIS:.pdf=.xmpdata)
	$(LATEX) $(THESIS:.pdf=.tex)

$(ABSTRACT): $(ABSTRACT:.pdf=.tex) $(ABSTRACT:.pdf=.xmpdata)
	$(LATEX) $(ABSTRACT:.pdf=.tex)

thesis: $(THESIS) ## compile thesis

abstract: $(ABSTRACT) ## compile abstract

clean: ## clean latex auxiliary files as well as pdf output
	rm -f *.log *.dvi *.aux *.toc *.lof *.lot *.out *.bbl *.blg *.xmpi *.fdb_latexmk *.fls
	rm -f thesis.pdf abstract.pdf

help: # http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -P '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
.PHONY: help
