library(readxl)
library(tidyverse)
library(stringi)

raw_data <- read_excel("data-raw/CovidTweetsCorpus/1000samples.xlsx")

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
df <- data.frame(text_list, class_list)

indexes <- sample(c(TRUE, FALSE), nrow(df), replace=TRUE, prob=c(0.7,0.3))

train <- df[indexes,]
test <- df[!indexes,]

save(train,file="data/covid_tweets/train_tweets.Rda")
save(test,file="data/covid_tweets/test_tweets.Rda")




