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

# tikz
TIKZDIR=img/tikz
TIKZ=$(wildcard $(TIKZDIR)/*.tikz)

# static img
STATICDIR=img/static
STATICIMG=$(wildcard $(STATICDIR)/*)

# tex
TEX=thesis.tex $(shell find tex -type f -name "*.tex") 
BIB=$(wildcard bib/*.bib)
IMG=$(TIKZ) $(STATICIMG)
TEXAUX=$(shell awk '/#end clean/{p=0} {if (p) print} /#begin clean/{p=1}' .gitignore)
TEXAUXDIR=. $(shell find tex bib $(TIKZDIR) abstract -type d)
TEXAUXFILES=$(foreach d,$(TEXAUXDIR),$(foreach e,$(TEXAUX),$(wildcard $(d)/$(e))))

# make
SHELL=/usr/bin/zsh
LATEX=rubber --unsafe --pdf --synctex --module lualatex -W all

.DEFAULT_GOAL:= thesis
.PHONY: all thesis abstract defense
.PHONY: data
.PHONY: synctex verapdf
.PHONY: clean mostlyclean cleanimg cleanpdf cleanpy cleantex
.PHONY: help echoes 

all: thesis abstract defense ## compile everything

thesis: thesis.pdf ## compile thesis
abstract: abstract.pdf ## compile abstract
defense: defense.pdf ## compile defense

data:
	$(MAKE) -C $(DATADIR) out

verapdf: thesis
	curl https://cuni.cz/UK-7987-version1-custom8.xml > /tmp/verapdf_profile
	verapdf -p /tmp/verapdf_profile thesis.pdf | grep "<validationReport"

see: thesis ## open with synctex enabled
	synctex-forward --servername $(NVIMSERVER) thesis.pdf $(STXLINE) $(STXCOL) $(STXFILE)

# cleaning
clean: cleantex cleanpdf cleandata ## clean everything
mostlyclean: cleanaux cleanpdf ## clean but not images 
cleanpdf: ## clean output pdfs
	rm -f thesis.pdf abstract.pdf
cleantex: ## clean latex auxiliary files
	rm -f $(TEXAUXFILES) 
cleandata: ## clean compiled images
	rm -f $(DATAOUT)

# concrete recipes
thesis.pdf: $(TEX) thesis.xmpdata mffthesis.cls $(BIB) $(IMG) data
	$(LATEX) thesis.tex

abstract.pdf: abstract/abstract.tex abstract/abstract.xmpdata
	$(LATEX) abstract/abstract.tex

# help
echoes: ## echo make variables
	$(info version = $(VERSION))
	$(info aux = $(AUX))
	$(info auxfiles = $(AUXFILES))
	$(info pyimg = $(PYIMG))
	$(info tex = $(TEX))
	$(info latex = $(LATEX))
	$(info nvimserver = $(NVIMSERVER))

help: # http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -P '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":[^:]*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
