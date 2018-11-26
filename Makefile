all: data_dir report.html

clean:
	rm -rf data *.tsv *.png report.md report.html

data_dir:
	mkdir data

report.html: report.rmd histogram.tsv histogram.png letter_frequency.tsv letter_frequency.png
	Rscript -e 'rmarkdown::render("$<")'

histogram.png: histogram.tsv
	Rscript -e 'library(ggplot2); qplot(Length, Freq, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf

histogram.tsv: ./R/histogram.r ./data/words.txt
	Rscript $<
	
letter_frequency.tsv: ./R/letter_frequency.r ./data/words.txt
	Rscript $<

./data/words.txt: /usr/share/dict/words
	cp $< $@

letter_frequency.png: letter_frequency.tsv
	Rscript -e 'library(ggplot2); qplot(Letter_occuring, Freq, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf
