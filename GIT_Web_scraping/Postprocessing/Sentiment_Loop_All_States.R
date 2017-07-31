rm(list=ls())
setwd('--Set Path--') # set the right path
cat('\014')

require(RCurl)
library(stringr)
library(tm)
library(dplyr)
library(plyr)
library(tm)
library(wordcloud)
library(gtools)
library(googleVis)

files=list.files(pattern='tweets_.*\\.csv', recursive=TRUE)
files=mixedsort(sort(files))

tally_gov <- data.frame(NULL)
for (f in files) {
print(f)
data <- read.csv(f,stringsAsFactors = FALSE)


tweet=data$tweet_content
tweet_list=lapply(tweet, function(x) iconv(x, "latin1", "ASCII", sub=""))

tweet_list=lapply(tweet_list, function(x) gsub("htt.*",' ',x))

tweet=unlist(tweet_list)

data$tweet=tweet

neg = scan("negative-words.txt", what="character", comment.char=";")
pos = scan("positive-words.txt", what="character", comment.char=";")
neg = c(neg, 'wtf')


# Function for sentiment analysis

score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
  
{
  scores = laply(sentences,
                 function(sentence, pos.words, neg.words)
                 {
                   # remove punctuation
                   sentence = gsub("[[:punct:]]", "", sentence)
                   # remove control characters
                   sentence = gsub("[[:cntrl:]]", "", sentence)
                   # remove digits
                   sentence = gsub('\\d+', '', sentence)
                   # define error handling function when trying tolower
                   tryTolower = function(x)
                     
                   {
                     # create missing value
                     y = NA
                     # tryCatch error
                     try_error = tryCatch(tolower(x), error=function(e) e)
                     # if not an error
                     if (!inherits(try_error, "error"))
                       y = tolower(x)
                     # result
                     return(y)
                   }
                   # use tryTolower with sapply
                   sentence = sapply(sentence, tryTolower)
                   # split sentence into words with str_split (stringr package)
                   word.list = str_split(sentence, "\\s+")
                   words = unlist(word.list)
                   # compare words to the dictionaries of positive & negative terms
                   pos.matches = match(words, pos.words)
                   neg.matches = match(words, neg.words)
                   pos.matches = !is.na(pos.matches)
                   neg.matches = !is.na(neg.matches)
                   # final score
                   score = sum(pos.matches) - sum(neg.matches)
                   return(score)
                 }, pos.words, neg.words, .progress=.progress )
  # data frame with scores for each sentence
  scores.df = data.frame(score=scores)
  return(scores.df)
}

score = as.integer(unlist(score.sentiment(tweet, pos, neg, .progress='text')))
score_gov_mean=mean(score)
score_gov_sd=sd(score)
score_gov_cv=score_gov_sd/score_gov_mean


data$score=score

hist(score,xlab=" ",main="Sentiment of sample tweets",border="black",col="skyblue")


tally_gov <- rbind(tally_gov, data.frame(f,score_gov_mean,score_gov_sd,score_gov_cv,dim(data)[1]))

} 
write.table(tally_gov,file="mean_senti_new.csv", sep=",",col.names=FALSE,row.names=FALSE) 

