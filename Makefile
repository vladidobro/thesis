SHELL=/bin/bash
LATEX=rubber --unsafe --pdf --synctex --module lualatex -W all

.DEFAULT_GOAL:= thesis
.PHONY: all thesis abstract defense
.PHONY: verapdf verapdf_update imgstatic_pdfa

all: thesis abstract defense

thesis:
	$(LATEX) thesis.text

abstract:
	$(LATEX) abstract/abstract.tex
	$(LATEX) abstract/abstract_EN.tex

defense: ## compile defense
	$(MAKE) -C defense all

imgstatic_pdfa:
	$(MAKE) -C img/static pdfa

verapdf_update:
	curl https://cuni.cz/UK-7987-version1-custom8.xml > utils/verapdf_profile.xml

verapdf: thesis
	verapdf -p utils/verapdf_profile.xml thesis.pdf
