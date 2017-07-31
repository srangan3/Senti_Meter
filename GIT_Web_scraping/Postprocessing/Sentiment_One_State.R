rm(list=ls())
setwd('--Set path--') # set the right path
cat('\014')

require(RCurl)
library(stringr)
library(tm)
library(dplyr)
library(plyr)
library(tm)
library(wordcloud)

# Read the csv file containing the scraped tweets for one person
data <- read.csv('--Specify the path for the csv file--',stringsAsFactors = FALSE)
head(data)

# List of positive and negative words
neg = scan("negative-words.txt", what="character", comment.char=";")
pos = scan("positive-words.txt", what="character", comment.char=";")
neg = c(neg, 'wtf','bridgegate')

# Create corpus
  corpus=Corpus(VectorSource(data$tweet_content))
# corpus=Corpus(VectorSource(pos))

# Convert to lower-case
corpus=tm_map(corpus,tolower)

# Remove stopwords
corpus=tm_map(corpus,function(x) removeWords(x,stopwords()))

x=as.list(corpus)
col=ifelse(x %in% neg,'#780000',ifelse(x %in% pos,'#0f5100','#000000')) 
wordcloud(corpus, min.freq=25, max.words=1000, scale=c(3,1),rot.per = 0.5,random.color=T, random.order=F,colors=col)
tweet=data$tweet_content
tweet_list=lapply(tweet, function(x) iconv(x, "latin1", "ASCII", sub=""))

tweet_list=lapply(tweet_list, function(x) gsub("htt.*",' ',x))

tweet=unlist(tweet_list)

data$tweet=tweet


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
score_gov=mean(score)

data$score=score

write.csv(data,"scores_gov.csv")

c1=data %>% group_by(score) %>% count()

barplot(prop.table(table(as.factor(score))),xlab=" ",main="Sentiment of sample tweets",border="black",col="skyblue",font.main = 30)