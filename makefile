LATEX=latexmk --pdf
VERSION=$(shell git tag | awk 'BEGIN{v=0;FIELDWIDTHS="1 2"}/^v[0-9]{2}/{vn=strtonum($$2);if(vn>v){v=vn}}END{v++; printf "v%02d",v}')
GITBRANCH=$(shell git branch --show-current)
GITSTATUS=$(shell git status -s)

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

version: ## release major version
ifeq ($(GITSTATUS),)
ifeq ($(GITBRANCH),master)
	echo "tag"
else
	echo "aborted, not on master branch"
endif
else
	echo "aborted, uncommited changes"
endif


thesis.pdf: thesis.tex thesis.xmpdata mffthesis.cls $(call rsuffixes,tex,tex) $(call rsuffixes,bib,bib)
	$(LATEX) thesis.tex

abstract.pdf: abstract/abstract.tex abstract/abstract.xmpdata
	$(LATEX) abstract/abstract.tex

help: # http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -P '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

echoes:
	echo $(VERSION)

.PHONY: help all see thesis abstract version clean mostlyclean cleanaux cleanimg

