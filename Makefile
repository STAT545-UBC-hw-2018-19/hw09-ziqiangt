all: data_dir report.html 

clean:
	rm -rf data results image report.md report.html *.png *.tsv README.md

# Store the results in different folder
data_dir:
	mkdir data
	mkdir results
	mkdir image

report.html: report.rmd histogram.tsv histogram.png \
						 letter_frequency.tsv letter_frequency.png \
						 makefile.png \
						 README.md
	Rscript -e 'rmarkdown::render("$<")'

histogram.png: histogram.tsv
	Rscript -e 'library(ggplot2); qplot(Length, Freq, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf

histogram.tsv: ./R/histogram.r ./data/words.txt
	Rscript $<

## Count the freuquency of the letter
letter_frequency.tsv: ./R/letter_frequency.r ./data/words.txt
	Rscript $<

## visualize the results in histogram form
letter_frequency.png: letter_frequency.tsv
	Rscript -e 'library(ggplot2); qplot(Letter_occuring, Freq, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf
	
	## move the results into thier own folder
	mv *.tsv results
	mv *.png image

## copy the words file in the working directory
./data/words.txt: /usr/share/dict/words
	cp $< $@

##Let's visualize the makefile structure
makefile.png: ./python/makefile2dot.py Makefile
	python $< <$(word 2, $^) |dot -Tpng > ./image/$@

README.md: README.rmd 
	Rscript -e 'rmarkdown::render("$<")'