

input=thesis.tex
output=.output


all:
	pdflatex -draftmode --output-dir=.output $(input)
	biber .output/$(basename $(input))
	pdflatex -draftmode --output-dir=.output $(input)
	pdflatex --output-dir=.output $(input)
	mv .output/$(input:.tex=.pdf) .

.PHONY:clean
clean:
	-rm -f .output/*
	-rm -f $(input:.tex=.pdf)
