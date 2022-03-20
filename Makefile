# git
VERSION=$(shell git tag | awk -v FIELDWIDTHS="1 2" '/^v[0-9]{2}/{vn=$$2;if(vn>v){v=vn}}END{v++; printf "v%02d",v}')
GITBRANCH=$(shell git branch --show-current)
GITSTATUS=$(shell git status -s)

# tex
TEX=$(wildcard *.tex) $(shell find tex -type f -name "*.tex") 
BIB=$(wildcard bib/*.bib)
AUX=$(shell awk '/#end clean/{p=0} {if (p) print} /#begin clean/{p=1}' .gitignore)
AUXDIR=. $(shell find tex bib abstract -type d)
AUXFILES=$(foreach d,$(AUXDIR),$(foreach e,$(AUX),$(wildcard $(d)/$(e))))

# nvim
NVIMSERVER=$(shell awk -F= '/let[ \t]+SynctexServerName[ \t]*=/{gsub("[\"'\'']","",$$2); print $$2}' .nvimrc)

# py
PYDIR=img/py
PY=$(wildcard $(PYDIR)/*.py)
PYIMG=$(foreach f,$(shell awk '/^## makes /{sub("^## makes ","",$$0);print}' $(PY)),$(PYDIR)/$(f))
PYMAKE=$(PYDIR)/makefile

# make
.DEFAULT_GOAL:= thesis
SHELL=/usr/bin/zsh
LATEX=latexmk -pdf -pdflatex="pdflatex -synctex=1"
.PHONY: help echoes all see thesis abstract defense version clean mostlyclean cleanaux cleanimg cleanpdf
include $(PYMAKE)

all: thesis abstract defense ## compile everything

thesis: thesis.pdf ## compile thesis
abstract: abstract.pdf ## compile abstract
defense:

see: thesis ## see thesis
	synctex-forward --servername $(NVIMSERVER) thesis.pdf

version: thesis ## *release major version
	if [ ! $(GITSTATUS) =  ]; then \
		echo "aborted: uncommited changes!"; exit 1; \
	elif [ ! $(GITBRANCH) = "master" ]; then \
		echo "aborted: not on master branch!"; exit 1; \
	else \
		cp thesis.pdf version/DP_Wohlrath_$(VERSION).pdf; \
		git add version/DP_Wohlrath_$(VERSION).pdf; \
		git commit -m "$(VERSION) release"; \
		git tag -a $(VERSION) -m "$(VERSION) release"; \
	fi

# cleaning
clean: cleanaux cleanimg cleanpdf ## clean everything
mostlyclean: cleanaux cleanpdf ## clean but not images 
cleanaux: ## clean auxiliary files
	rm -f $(AUXFILES) 
cleanimg: ## clean compiled images
	rm -f $(PYIMG)
	rm -f $(PYMAKE)
cleanpdf: ## clean output pdfs
	rm -f thesis.pdf abstract.pdf


# concrete recipes
thesis.pdf: $(TEX) thesis.xmpdata mffthesis.cls $(BIB) $(PYIMG)
	$(LATEX) thesis.tex

abstract.pdf: abstract/abstract.tex abstract/abstract.xmpdata
	$(LATEX) abstract/abstract.tex

$(PYMAKE): $(PY)
	awk '/^## makes /{for(i=3;i<=NF;i++){dep=dep sprintf("img/py/%s ",$$i)}} \
	ENDFILE{printf "%s: %s\n\t(cd img/py && python %s)\n\n", \
	substr(dep,1,length(dep)-1), FILENAME, substr(FILENAME,8,length(FILENAME)); dep=""}' \
	$(PY) > $(PYMAKE)

# help
echoes: ## echo make variables
	$(info version = $(VERSION))
	$(info aux = $(AUX))
	$(info auxfiles = $(AUXFILES))
	$(info pyimg = $(PYIMG))
	$(info tex = $(TEX))
	$(info pymake = $(PYMAKE))
	$(info latex = $(LATEX))
	$(info nvimserver = $(NVIMSERVER))

help: # http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -P '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":[^:]*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
