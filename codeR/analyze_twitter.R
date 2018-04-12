###################################################################################
# PUBLIC PRESIDENCY: Initially prepared for quanteda workshop
# Explore @realDonaldTrump tweets
# 1. Read in data, explore metadata
# 2. Create corpus and docvars
# 3. Working with a corpus: subset, rehape
# 4. Operations on a corpus: kwic, complexity 
# 5. Document feature matrix (dfm): bag-of-words, frequencies, clouds
# 6. Comparisons on a dfm: comparison clouds, relative frequencies, keyness, similarity
# 7. Dictionary methods: sentiment
# 8. Feature co-occurrence matrix: semantic networks
# Michele Claibourn (mclaibourn@virginia.edu)
# April 4, 2018, mpc
# Updated: April 10, 2018 
###################################################################################

rm(list=ls())
library(quanteda)
library(tidyverse)
library(RJSONIO) # didn't mention this one in email (but you don't need it)
library(scales)
library(RColorBrewer) # didn't to mention this one in email!

setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/trumptwitter/")


###################################################################################
# 1. Read in data, explore metadata
###################################################################################
setwd("tweets/")
# List of json files
files <- dir(pattern=".json") # vector of all json file names

# Read in JSON files and create dataframe of tweets
tw_list <- map(files, fromJSON) # read in
tw <-  map_df(tw_list, bind_rows) # convert list of dfs into one df
setwd("../")
###################################################################################
# Save the twitter data frame
save(tw, file = "tw.RData")
# load("tw.RData") # read in the twitter data frame
###################################################################################
# encoding errors? Try
# 

# Create date variable
tw$date <- paste0(str_sub(tw$created_at, 5, 10), ",", str_sub(tw$created_at, 27,30))
tw$date <- as.Date(tw$date, "%b %d,%Y") # format as date

# Tweet source
table(tw$source)
# Create binary variable: iphone or not
tw <- tw %>% mutate(iphone = ifelse(source == "Twitter for iPhone", "iphone", "not_iphone"))

# Retweets/Favorites
summary(tw[,c("retweet_count", "favorite_count")])
# Most favorited
tw %>% slice(which.max(favorite_count)) %>% select(text)

# Number of tweets by day
# simple version
ggplot(tw, aes(x=date, color=iphone)) + geom_point(stat="count")

# prettier version
# Create date breaks to get chosen tick marks on graph
date.vec <- seq(from=as.Date("2017-01-20"), to=as.Date("2018-04-13"), by="weeks") # update to Friday after last story
ggplot(tw, aes(x=date, color=iphone)) + geom_point(stat="count") + 
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) + 
  scale_color_manual(values=c("orange3","blue3"), name="Source") +
  labs(title = "Number of Trump Tweets", 
       subtitle = "January 20, 2017 to February 28, 2018", 
       x="Date", y="Tweet Count") +
  theme(axis.text.x=element_text(angle=90, size=8), 
        plot.title = element_text(face="bold", size=18, hjust=0), 
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(),
        legend.position="bottom")


###################################################################################
# 2. Create corpus and docvars
###################################################################################
# function: corpus
twcorpus <- corpus(tw, docid_field = "id_str", text_field = "text")
twcorpus
summary(twcorpus, 10) # only show first 10 documents

?corpus # source can be character vector, data frame, kwic object, tm=created corpus
# view/extract the document text
# helper function: texts
texts(twcorpus)[1] # first document

# add number of tokens and sentence length to initial data frame for later
tw$nword <- ntoken(twcorpus)
tw$nsentence <- nsentence(twcorpus)
# also: nytpe(), ndoc(), nfeat()

###################################################################################
# 3. Work with a corpus 
###################################################################################
# a. Subset a corpus: select documents based on document variables
# function: corpus_subset
twcorpusi <- corpus_subset(twcorpus, iphone == "iphone")
twcorpusi

# b. Reshape/change units of a corpus: use sentence as unit
# function: corpus_reshape
twcorpus_sent <- corpus_reshape(twcorpus, to = "sentences")
twcorpus_sent


###################################################################################
# 4. Operations on a corpus: kwic, complexity 
###################################################################################
# a. key words in context
# function: kwic
kwicwin <- kwic(twcorpus, "win*")
kwic(twcorpus, "immig*", window = 3)

# b. readability statistics
# function: textstat_readability
read <- textstat_readability(twcorpus, measure = "Flesch.Kincaid")
tw$readFK <- read$Flesch.Kincaid # add to initial data frame to visualize
# to generate measure directly in corpus
docvars(twcorpus, "readFK") <- textstat_readability(twcorpus, measure = "Flesch.Kincaid")$Flesch.Kincaid
summary(twcorpus, 5)

# Plot
ggplot(tw, aes(x = date, y = readFK)) + 
  geom_point(aes(color=iphone), alpha=0.5, size=2) +
  geom_smooth(aes(color=iphone)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) + 
  labs(title = "'Readability' of Trump Tweets",
       subtitle = "Flesch Kincaid Readability Index",
       y = "Grade level", x = "Date") +
  scale_color_manual(values=c("orange3","blue3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=18, hjust=0),
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(), legend.position = c(0.9,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

# Which documents are the "simplest"?
tw %>% 
  filter(readFK <= 1) %>% 
  select("date", "source", "readFK", "text")
# to retrieve the simplest tweet document directly from the corpus
texts(twcorpus)[docvars(twcorpus, "readFK") <= 1]


###################################################################################
# 5. Document feature matrix (dfm): bag-of-words, frequencies, clouds
###################################################################################
# a. create a document feature matrix from a corpus or a tokens object
# function: dfm
tw_dfm <- dfm(twcorpus, remove_punct = TRUE, remove_numbers = TRUE, 
              remove_url = TRUE, tolower = TRUE, remove = stopwords("english"),
              verbose = TRUE)
tw_dfm
# generates same dfm as: tw_dfm <- dfm(twtokens) 
#    on which we already removed punctuation, numbers, stopwords, and made lowercase
# additional arguments: stem, ngrams
#    and accepts additional arguments to tokens, i.e., remove_hyphens, 
#    remove_twitter [@, #], remove_separators [http://www.fileformat.info/info/unicode/category/index.htm]

# list most frequent words
topfeatures(tw_dfm, 50) 

# b. wordcloud of most frequent words
# function: texplot_wordcloud
textplot_wordcloud(tw_dfm)
# fancier wordcloud
pal1 <- brewer.pal(9, "Oranges") # define a color palette
textplot_wordcloud(tw_dfm, max_words = 150, 
                   color = pal1, rotation = 0.25) 

# c. plot of most frequent words
# function: textstat_frequency
tw_freq <- textstat_frequency(tw_dfm, n = 100)
ggplot(tw_freq, aes(x = reorder(feature, frequency), y = frequency)) + 
  geom_point() + 
  labs(title = "Most Frequently Tweeted Words", 
       subtitle = "@realDonaldTrump January 20, 2017 to April 9, 2018", 
       x = NULL, y = "Frequency") +
  theme_minimal() + coord_flip()


###################################################################################
# 6. Comparisons on a dfm: comparison clouds, relative frequencies, keyness, similarity
###################################################################################
# a. comparison cloud
# compare groups: groups arugment to dfm
# function: textplot_wordcloud
dfm(twcorpus, groups = "iphone", remove_punct = TRUE, remove_numbers = TRUE,
    tolower = TRUE, remove_url = TRUE, remove = stopwords("english")) %>% 
  textplot_wordcloud(comparison = TRUE, max_words = 200,
                     color = c("orange3", "blue3"),
                     min_size = .3, max_size = 3, labelsize = 1)

# b. relative frequencies by group
# function: textstat_frequency
# for relative frequency plots, (word count divided by the length of doc) 
#   weight the dfm
tw_dfm_prop <- dfm_weight(tw_dfm, scheme = "prop")
# calculate relative frequency by a document variable
tw_relfreq <- textstat_frequency(tw_dfm_prop, n = 20, groups = "iphone")

ggplot(tw_relfreq, aes(x = nrow(tw_relfreq):1, y = frequency)) +
  geom_point() + facet_wrap(~ group, scales = "free") +
  scale_x_continuous(breaks = nrow(tw_relfreq):1,
                     labels = tw_relfreq$feature) +
  labs(x = NULL, y = "Relative frequency") +
  coord_flip() 

# c. keyness: differential association of keywords in a target and reference group
# function: textstat_keyness, textplot_keyness
twsource_key <- dfm(twcorpus, groups = "iphone", remove_punct = TRUE, 
                    remove_numbers = TRUE, tolower = TRUE, remove_url = TRUE, 
                    remove = stopwords("english")) %>% 
  textstat_keyness(target = "iphone")

textplot_keyness(twsource_key)

# d. similarity
# function: textstat_dist
# stem words
tw_dfm_stem <- dfm(twcorpus, remove_punct = TRUE, remove_numbers = TRUE,
                  tolower = TRUE, remove_url = TRUE, remove = stopwords("english"),
                  stem = TRUE, verbose = TRUE)
# trim dfm (only words that occur at least three times in corpus and in at least three documents)
tw_dfm_stem <- dfm_trim(tw_dfm_stem, min_count = 3, min_docfreq = 3)
# get distances on normalized dfm
tw_dist <- textstat_dist(dfm_weight(tw_dfm_stem, "prop"))
# hiearchical clustering of the distance object
tw_cluster <- hclust(tw_dist)
# label with document names
tw_cluster$labels <- docvars(tw_dfm_stem, "date")
# plot as a dendrogram
plot(tw_cluster, xlab = "", main = "Euclidean Distance on Normalized Token Frequency",
     sub = "", cex = 0.5)


###################################################################################
# 7. Dictionary methods: sentiment
###################################################################################
# a. apply dictionary, lexicon frequency
# function: dictionary
# quanteda contains the Lexicoder Sentiment Dictionary 
#   created by Young and Soroka (2012), http://www.lexicoder.com/index.html
lengths(data_dictionary_LSD2015)
data_dictionary_LSD2015$negative
# but one could use other available dictionaries, or corpus-specific dictionaries

# apply dictionary to sentences
tw_dfm_lsd <- dfm(twcorpus, dictionary = data_dictionary_LSD2015[1:2], 
               remove_punct = TRUE, tolower = TRUE)

# turn this into a dataframe, add to existing dataframe
tw_df_lsd <- as.data.frame(tw_dfm_lsd, row.names = tw_dfm_lsd@Dimnames$docs)

# add to iniital dataframe
tw[,ncol(tw)+1:2] <- tw_df_lsd[,2:3]
summary(tw[,13:14])

# some manipulation to generate document scores
tw <- tw %>% mutate(posprop = positive/nword,
                    negprop = negative/nword,
                    tone = positive - negative)

# tone by source
tw %>% group_by(iphone) %>% summarize(tone = mean(tone))

# tone by date
# Plot
ggplot(tw, aes(x = date, y = tone)) + 
  geom_point(aes(color=iphone), alpha=0.25, size=2) +
  geom_smooth(aes(color=iphone)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) + 
  labs(title = "'Tone' of Trump Tweets",
       subtitle = "Tone = proportion positive words - proportion negative words",
       y = "Tone", x = "Date") +
  scale_color_manual(values=c("orange3","blue3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=18, hjust=0),
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(), legend.position = c(0.9,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

# Which tweet is the most negative?
tw %>% 
  slice(which.min(tone)) %>% 
  select("date", "text")


###################################################################################
# 8. Feature co-occurrence matrix: semantic networks
###################################################################################
# a. feature co-occurrence matrix, co-occurrences of tokens
tw_dfm_trim <- dfm_trim(tw_dfm, min_count = 5) # reduce dfm
tw_fcm <- fcm(tw_dfm_trim)  # generate feature co-occurrence
feat <- names(topfeatures(tw_fcm, 100)) # list of most frequently co-occurring words
tw_fcm <- fcm_select(tw_fcm, feat) # select these features from fcm
# visualize semantic network
size <- log(colSums(dfm_select(tw_dfm_trim, feat))) # scale for vertices
textplot_network(tw_fcm, min_freq = 0.75, vertex_size = size / max(size) * 3)

# co-occuring hashtags 
tag_dfm <- dfm_select(tw_dfm, ('#*')) # extract hashtags
tag_fcm <- fcm(tag_dfm) # generate feature co-occurrence
top_tags <- names(topfeatures(tag_dfm, 100)) # most frequently occurring tags
head(top_tags, 10)
tag_fcm <- fcm_select(tag_fcm, top_tags) # select these from fcm
textplot_network(tag_fcm, min_freq = 0.1, edge_color = 'blue3', 
                 edge_alpha = 0.8, edge_size = 5) 

# co-occuring usernames
user_dfm <- dfm_select(tw_dfm, ('@*')) # extract users
user_fcm <- fcm(user_dfm) # generate feature co-occurrence
topuser <- names(topfeatures(user_dfm, 100)) # most frequently occurring users
head(topuser)
user_fcm <- fcm_select(user_fcm, topuser) # select these from fcm
textplot_network(user_fcm, min_freq = 0.1, edge_color = 'orange3', 
                 edge_alpha = 0.8, edge_size = 5)


###################################################################################
# things that didn't make sense with this corpus, but are cool
#   lexical dispersion, correspondence analysis/scaling methods

# more complex things you can do starting with quanteda 
#   collocation analysis (find n-grams, generate compound tokens), example below
#   feed a fcm into text2vec for word embeddings
#   feed a dfm into topicmodel or stm for topic modeling
###################################################################################

# Save all of the work
save.image("trumptwitter.RData")
# load("trumptwitter.RData")


###################################################################################
# string-of-words and collocation example
###################################################################################
# a. Tokenize a corpus: segment by word boundaries 
# function: tokens
twtokens <- tokens(twcorpus) 
head(twtokens[[1]], 10) # first 10 tokens in 1st document

# b. remove punctuation, numbers, 
twtokens <- tokens(twcorpus, remove_numbers = TRUE, remove_punct = TRUE)
head(twtokens[[1]], 10) 
# additional arguments: remove_hyphens, remove_separators [http://www.fileformat.info/info/unicode/category/index.htm]
#   remove_url [http(s)], remove_twitter [@, #]

# c. collocation analysis, finding multi-word expressions
# function: textstat_collocations
# first remove stopwords, but keep spaces to preserve non-adjacency
stopwords("english") # what are stopwords
twtokens <- tokens_remove(twtokens, stopwords("en"), padding = TRUE) 
head(twtokens[[1]], 10) 
# change all tokens to lower case
twtokens <- tokens_tolower(twtokens)
head(twtokens[[1]], 10) 
# generate collocations
tw_col <- textstat_collocations(twtokens, min_count = 10, tolower = FALSE)
head(tw_col, 50)

# d. retain important multi-word expressions
# function: tokens_compound
tw_ctokens <- tokens_compound(twtokens, tw_col[c(1,6,8,11,15,27,30,34)])
head(twtokens[[300]],20) # before compounding
head(tw_ctokens[[300]],20) # after compounding

# function: token_ngrams generates all n-grams or skip-grams
# can call "kwic" on a tokens object as well


