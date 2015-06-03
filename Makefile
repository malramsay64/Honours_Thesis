

input=thesis.tex
output=.output
folders=$(shell ls -d */)

bib=biber
pdf_flags=--output-dir=$(output) --shell-escape
pre_flags=-draftmode
master_bibfile:=/Users/malcolm/Honours/resources/crystal.bib
master_bibfile:=$(shell if [ -e $(master_bibfile) ]; then echo $(master_bibfile); fi)
bibfile=bibliography/crystal.bib
abbrev=true

empty=
space=$(empty) $(empty)

ifeq ($(bib), bibtex)
	bibcommand = ( cd $(output); $(bib) $(basename $<) )
else
	bibcommand = $(bib) $(output)/$(basename $<)
endif

all: thesis.pdf

pres: pres.pdf

thesis: thesis.pdf

bib: $(bibfile)

.PHONY: thesis.pdf
thesis.pdf: thesis.tex $(folders) $(bibfile) | $(output)
	$(shell export TEXINPUTS=.:$(subst $(space),:,$(folders)))
	pdflatex $(pre_flags) $(pdf_flags) $(input)
	$(bibcommand)
	pdflatex $(pre_flags) $(pdf_flags) $(input)
	pdflatex $(pdf_flags) $(input)
	mv $(output)/$@ .

pres.pdf: pres.tex $(folders) $(bibfile) | $(output)
	$(shell export TEXINPUTS=.:$(subst $(space),:,$(folders)))
	pdflatex $(pre_flags) $(pdf_flags) $<
	$(bibcommand)
	pdflatex $(pre_flags) $(pdf_flags) $<
	pdflatex $(pdf_flags) $<
	mv $(output)/$@ .

$(bibfile): $(master_bibfile) bibliography/convert.py bibliography/journals.txt
	cp $< $@
	( cd bibliography; python convert.py $(abbrev))

.PHONY:clean
clean:
	-rm -rf $(output)
	-rm -f $(input:.tex=.pdf)
	-rm $(bibfile)

clean-pres:
	-rm -rf $(output)/pres*

clean-cache:
	rm -rf $$(biber --cache)

$(output):
	mkdir $(output)
	$(foreach f, $(folders), mkdir $(output)/$(f); )
