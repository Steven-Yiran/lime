setwd('~/dev/lime')

library(text2vec)
library(xgboost)
library(lime)

#source("R/tweet_shiny.R")

load("data/covid_tweets/train_tweets.Rda")
load("data/covid_tweets/test_tweets.Rda")

get_matrix <- function(text) {
    it <- itoken(text, progressbar = FALSE)
    create_dtm(it, vectorizer = hash_vectorizer())
}

train_text <- get_matrix(train_tweets$text)
dtrain <- xgb.DMatrix(train_text, label = train_tweets$text.class)

xgb_model <- xgb.train(list(max_depth = 7, eta = 0.1, objective = "binary:logistic",
                            eval_metric = "error", nthread = 2),
                       dtrain,
                       nrounds = 50)

explainer <- lime(train_sentences$text, xgb_model, get_matrix)

interactive_text_explanations(explainer)

