# git
VERSION=$(shell git tag | awk -v FIELDWIDTHS="1 2" '/^v[0-9]{2}/{vn=$$2;if(vn>v){v=vn}}END{v++; printf "v%02d",v}')
GITBRANCH=$(shell git branch --show-current)
GITSTATUS=$(shell git status -s)

# nvim
NVIMSERVER=$(shell awk -F= '/let[ \t]+g:SynctexServerName[ \t]*=/{gsub("[\"'\'']","",$$2); print $$2}' .nvimrc)

# synctex
STXLINE=
STXCOL=
STXFILE=

# data
DATADIR=data
PY=$(wildcard $(DATADIR)/*.py)
DATAMAKE=$(DATADIR)/makefile
MAKESMARK=\#\#MAKES
DATA=$(wildcard $(DATADIR)/out/*)

# tikz
TIKZDIR=img/tikz
TIKZ=$(wildcard $(TIKZDIR)/*.tikz)

# static img
STATICDIR=img/static
STATICIMG=$(wildcard $(STATICDIR)/*)

# tex
TEX=thesis.tex $(shell find tex -type f -name "*.tex") 
BIB=$(wildcard bib/*.bib)
IMG=$(PYIMG) $(TIKZ) $(STATICIMG)
TEXAUX=$(shell awk '/#end clean/{p=0} {if (p) print} /#begin clean/{p=1}' .gitignore)
TEXAUXDIR=. $(shell find tex bib $(TIKZDIR) abstract -type d)
TEXAUXFILES=$(foreach d,$(TEXAUXDIR),$(foreach e,$(TEXAUX),$(wildcard $(d)/$(e))))

# make
SHELL=/usr/bin/zsh
LATEX=latexmk -pdf -pdflatex="pdflatex -synctex=1"
include $(DATAMAKE)

.DEFAULT_GOAL:= thesis
.PHONY: all thesis abstract defense
.PHONY: synctex version 
.PHONY: clean mostlyclean cleanimg cleanpdf cleanpy cleantex
.PHONY: help echoes 

all: thesis abstract defense ## compile everything

thesis: thesis.pdf ## compile thesis
abstract: abstract.pdf ## compile abstract
defense: defense.pdf ## compile defense

synctex: thesis ## open with synctex enabled. spawns a unique instance of zathura. usage: "make see" or "make see STXLINE=1 STXCOL=1 STXFILE=thesis.tex"
	synctex-forward --servername $(NVIMSERVER) thesis.pdf $(STXLINE) $(STXCOL) $(STXFILE)


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
clean: cleantex cleanimg cleanpdf ## clean everything
mostlyclean: cleanaux cleanpdf ## clean but not images 
cleanimg: cleanpy
cleanpdf: ## clean output pdfs
	rm -f thesis.pdf abstract.pdf
cleantex: ## clean latex auxiliary files
	rm -f $(TEXAUXFILES) 
cleandata: ## clean compiled images
	rm -f $(DATA)
	rm -f $(DATAMAKE)
cleantikz:

# concrete recipes
thesis.pdf: $(TEX) thesis.xmpdata mffthesis.cls $(BIB) $(IMG)
	$(LATEX) thesis.tex

abstract.pdf: abstract/abstract.tex abstract/abstract.xmpdata
	$(LATEX) abstract/abstract.tex

$(PYMAKE): $(PY)
	awk '/^$(PYMAKEMARK)/{gsub("$(PYMAKEMARK)","",$$0);for(i=1;i<=NF;i++){dep=dep sprintf("img/py/%s ",$$i)}} \
	ENDFILE{printf "%s: %s\n\t(cd img/py && python %s)\n\n", \
	substr(dep,1,length(dep)-1), FILENAME, substr(FILENAME,8,length(FILENAME)); dep=""}' \
	$(PY) > $(PYMAKE)

# help
echoes: ## echo make variables
	$(info version = $(VERSION))
	$(info aux = $(AUX))
	$(info auxfiles = $(AUXFILES))
	$(info pyimg = $(PYIMG))
	$(info pymark = $(PYMAKEMARK))
	$(info tex = $(TEX))
	$(info pymake = $(PYMAKE))
	$(info latex = $(LATEX))
	$(info nvimserver = $(NVIMSERVER))
	$(info tikzmark = $(TIKZPREVMARK))

help: # http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -P '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":[^:]*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
