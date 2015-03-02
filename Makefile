

input=thesis.tex
output=.output
folders=$(shell ls -d */)

bib=biber
pdf_flags=--output-dir=$(output)
pre_flags=-draftmode
master_bibfile=/Users/malcolm/Honours/resources/crystal.bib
bibfile=bibliography/crystal.bib
abbrev=true


ifeq ($(bib), bibtex)
	bibcommand = ( cd $(output); $(bib) $(basename $(input)) )
else
	bibcommand = $(bib) $(output)/$(basename $(input))
endif

all: thesis.pdf

thesis.pdf: thesis.tex $(folders) $(bibfile) | $(output)
	pdflatex $(pre_flags) $(pdf_flags) $(input)
	$(bibcommand)
	pdflatex $(pre_flags) $(pdf_flags) $(input)
	pdflatex $(pdf_flags) $(input)
	mv $(output)/$(input:.tex=.pdf) .

$(bibfile): $(master_bibfile) bibliography/convert.py
	cp $< $@
	( cd bibliography; python convert.py $(abbrev))

.PHONY:clean
clean:
	-rm -rf $(output)
	-rm -f $(input:.tex=.pdf)
	-rm $(bibfile)

$(output):
	mkdir $(output)
	$(foreach f, $(folders), mkdir $(output)/$(f); )
