# Read txt file
words <- readLines("./data/words.txt")

# Count all letter freq
Letter_occuring <- unlist(strsplit(words, ""))

# table the freq
letter_frequency <- table(Letter_occuring)

# Store the results in the .tsv file
write.table(letter_frequency, "letter_frequency.tsv",
						sep = "\t", row.names = FALSE, quote = FALSE)