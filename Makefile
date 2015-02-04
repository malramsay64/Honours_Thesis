

input=thesis.tex
output=.output
folders=$(shell ls -d */)

bib=biber
pdf_flags=--output-dir=$(output)
pre_flags=-draftmode


all: | $(output)
	pdflatex $(pre_flags) $(pdf_flags) $(input)
	$(bib) $(output)/$(basename $(input))
	pdflatex $(pre_flags) $(pdf_flags) $(input)
	pdflatex $(pdf_flags) $(input)
	mv $(output)/$(input:.tex=.pdf) .

.PHONY:clean
clean:
	-rm -rf $(output)
	-rm -f $(input:.tex=.pdf)

$(output):
	mkdir $(output)
	$(foreach f, $(folders), mkdir $(output)/$(f); )
