LATEX=latexmk --pdf


rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d)) #https://blog.jgc.org/2011/07/gnu-make-recursive-wildcard-function.html
allsuffix=$(foreach dir,$1,$(call rwildcard,$(dir),$(foreach ext,$2,*.$(ext)))) $(wildcard $(foreach ext,$2,*.$(ext)))



all: thesis abstract ## compile everything
see: thesis ## see thesis
	zathura thesis.pdf

thesis: thesis.pdf ## compile thesis
abstract: abstract.pdf ## compile abstract

cleanaux: ## clean auxiliary files
	rm -f $(call allsuffix,tex bib img abstract template,log dvi aux toc lof lot out bbl blg xmpi synctex.gz fdb_latexmk fls bcf run.xml)

cleanimg: ## clean compiled images
cleanpdf: ## clean output pdfs
	rm -f thesis.pdf abstract.pdf
mostlyclean: ## clean but not images 
clean: cleanaux cleanpdf ## clean everything


thesis.pdf: thesis.tex thesis.xmpdata mffthesis.cls $(call rsuffixes,tex,tex) $(call rsuffixes,bib,bib)
	$(LATEX) thesis.tex

abstract.pdf: abstract/abstract.tex abstract/abstract.xmpdata
	$(LATEX) abstract/abstract.tex

help: # http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -P '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: help all see thesis abstract clean mostlyclean cleanaux cleanimg

