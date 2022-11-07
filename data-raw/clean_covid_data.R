library(readxl)
library(tidyverse)
library(stringi)

setwd("~/dev/lime/")
raw_data <- read_excel("data-raw/CovidTweetsCorpus/1000samples.xlsx")
# label 1: negative 2: positive
# new label 0: negative 1: positive

clean_line <- function(string) {
    temp <- tolower(string)
    # remove all non letter words
    temp <- stringr::str_replace_all(temp,"[^a-zA-Z\\s]", " ")
    # standardize space
    temp <- stringr::str_replace_all(temp,"[\\s]+", " ")
    # Split it
    temp <- stringr::str_split(temp, " ")[[1]]
    # delete trailing spaces
    indexes <- which(temp == "")
    if(length(indexes) > 0){
        temp <- temp[-indexes]
    }
    temp <- paste(temp, sep = "", collapse = " ")
    return(temp)
}

text_list <- map(raw_data$text, clean_line) %>% unlist()
class_list <- raw_data$polarity
df <- data.frame(text=text_list, text.class=class_list)

# change text label
df <- df %>% mutate(text.class = text.class - 1)

# train, text split
indexes <- sample(c(TRUE, FALSE), nrow(df), replace=TRUE, prob=c(0.7,0.3))

train_tweets <- df[indexes,]
test_tweets <- df[!indexes,]

DATA_DIR <- "data/covid_tweets"
save(train_tweets, file=file.path(DATA_DIR, "train_tweets.Rda"))
save(test_tweets, file=file.path(DATA_DIR, "test_tweets.Rda"))

print(paste("data saved at", DATA_DIR))


