###################################################################################
# PUBLIC PRESIDENCY: Initially prepared for quanteda workshop
# Explore Presidential Documents, created in process_presdoc.R
# 1. Read in data, explore metadata
# 2. Create corpus and docvars
# 3. Working with a corpus: subset, rehape
# 4. Operations on a corpus: kwic, complexity 
# 5. Document feature matrix (dfm): bag-of-words, frequencies, clouds
# 6. Operations on a dfm: comparisons via relative frequencies, comparison clouds, keyness, similarity
# 7. More operations on a dfm: dictionaries, sentiment
# 8. Yet more quanteda can do...
# Michele Claibourn (mclaibourn@virginia.edu)
# April 4, 2018, mpc
# Updated: April 8, 2018 
###################################################################################

rm(list=ls())
library(quanteda)
library(stringr)
library(tidyverse)
library(scales)
library(lubridate) # forgot to mention this one in email!
library(RColorBrewer)

setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/presdoc") 
# load("process_presdoc.RData") # for mpc workflow


###################################################################################
# 1. Explore metadata
###################################################################################
# Read in csv file
presdocuments <- read.csv("presdocuments.csv", stringsAsFactors = FALSE)
# reformat date as a date
presdocuments$date <- as.Date(presdocuments$date, "%Y-%m-%d")

# Type of documents
table(presdocuments$type)

# That "Proclamation" and "Order" are going to bug me, so let's fix them
presdocuments <- presdocuments %>% 
  mutate(type = recode(type, "Proclamation" = "Proclamations",
                       "Order" = "Orders"))

# Let's combine these into written communications (written), scripted spoken communications (script), and unscripted spoken communications (unscript)
presdocuments <- presdocuments %>% 
  mutate(type3 = ifelse(type %in% c("Addresses and Remarks", "Addresses to the Nation"), "script", 
                        ifelse (type %in% c("Interviews With the News Media", "Meetings With Foreign Leaders and International Officials", "Appointments and Nominations"), "unscript", 
                        "written")))
table(presdocuments$type3)

# Number of documents by day
# simple version
ggplot(presdocuments, aes(x=date, color=type3)) + geom_point(stat="count")

# prettier version
# Create date breaks to get chosen tick marks on graph
date.vec <- seq(from=as.Date("2017-01-20"), to=as.Date("2018-03-02"), by="weeks") # update to Friday after last story
ggplot(presdocuments, aes(x=date, color=type3)) + geom_point(stat="count") + 
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) + 
  labs(title = "Number of Presidential Documents", 
       subtitle = "From the Daily Compilation: January 20, 2017 to February 28, 2018", 
       x="Date", y="Number of Documents") +
  theme(axis.text.x=element_text(angle=90, size=8), 
        plot.title = element_text(face="bold", size=18, hjust=0), 
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(),
        legend.position="bottom")


###################################################################################
# 2. Create corpus: combine document text and document variables
###################################################################################
# function: corpus
pd_corpus <- corpus(presdocuments, docid_field = "docid", text_field = "text")
pd_corpus
summary(pd_corpus, 10) # only show first 10 documents

?corpus # source can be character vector, data frame, kwic object, tm=created corpus
# view/extract the document text
# helper function: texts
texts(pd_corpus)[1] # first document

# add number of tokens and sentence length to initial data frame for later
presdocuments$nword <- ntoken(pd_corpus)
presdocuments$nsentence <- nsentence(pd_corpus)


###################################################################################
# 3. Work with a corpus 
###################################################################################
# a. Subset a corpus: select documents based on document variables
# function: corpus_subset
scrip_corpus <- corpus_subset(pd_corpus, type3 == "script")
scrip_corpus

# b. Reshape/change units of a corpus: use paragraphs as unit
# function: corpus_reshape
scrip_corpus_par <- corpus_reshape(scrip_corpus, to = "paragraphs")
scrip_corpus_par


###################################################################################
# 4. Operations on a corpus: kwic, complexity 
###################################################################################
# a. key words in context
# function: kwic
kwic(scrip_corpus, "win*")
kwic(scrip_corpus, "immig*", window = 3)

# b. lexical dispersion plot of key word use across documents
textplot_xray(kwic(scrip_corpus, "immig*"))

# compare use/dispersion of multiple key words within a document
textplot_xray(
  kwic(texts(pd_corpus)[1], "americ*"),
  kwic(texts(pd_corpus)[1], c("we", "i"))
)

# c. readability statistics
# function: textstat_readability
read <- textstat_readability(pd_corpus, measure = "Flesch.Kincaid")
presdocuments$readFK <- read$Flesch.Kincaid # add to initial data frame to visualize
# to generate measure directly in corpus
# docvars(pd_corpus, "readFK") <- textstat_readability(pd_corpus, measure = "Flesch.Kincaid")$Flesch.Kincaid
# summary(pd_corpus, 5)

# Plot
ggplot(presdocuments, aes(x = date, y = readFK)) + 
  geom_point(aes(color=type3), alpha=0.5, size=2) +
  geom_smooth(aes(color=type3)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) + 
  labs(title = "'Readability' of Presidential Documents",
       subtitle = "Trump Presidency",
       y = "Grade level", x = "Date") +
  scale_color_manual(values=c("blue3","turquoise","orange3"), name="Type") +
  theme(plot.title = element_text(face="bold", size=18, hjust=0),
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(), legend.position = c(0.9,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

# Which documents are the "simplest"?
presdocuments %>% 
  filter(readFK <= 4) %>% 
  select("title", "type3", "readFK")
# Retrieve the simplest unscripted document?
s <- presdocuments %>% 
  filter(type3 == "unscript") %>% 
  slice(which.min(readFK)) %>% 
  select("docid", "readFK", "title")
presdocuments$text[presdocuments$docid==s$docid]
# to retrieve the simplest unscripted document directly from the corpus
# texts(pd_corpus)[docvars(pd_corpus, "title") == s$title]


###################################################################################
# 5. Document feature matrix (dfm): bag-of-words, frequencies, clouds
###################################################################################
# a. create a document feature matrix from a corpus or a tokens object
# function: dfm
pd_dfm <- dfm(pd_corpus, remove_punct = TRUE, remove_numbers = TRUE,
              tolower = TRUE, remove = stopwords("english"),
              verbose = TRUE)
pd_dfm
# generates same dfm as: pd_dfm <- dfm(pd_tokens) 
#    on which we already removed punctuation, numbers, stopwords, and made lowercase
# additional arguments: stem, ngrams
#    and accepts additional arguments to tokens, i.e., 
#    remove_hyphens, remove_separators, remove_url, remove_twitter

# list most frequent words
topfeatures(pd_dfm, 100) 

# b. wordcloud of most frequent words
# function: texplot_wordcloud
textplot_wordcloud(pd_dfm)
# fancier wordcloud
pal1 <- brewer.pal(9, "Oranges") # define a color palette
textplot_wordcloud(pd_dfm, max_words = 200, color = pal1, rotation = 0.25) 

# c. plot of most frequent words
# function: textstat_frequency
pd_freq <- textstat_frequency(pd_dfm, n = 100)
ggplot(pd_freq, aes(x = reorder(feature, frequency), y = frequency)) + 
  geom_point() + labs(x = NULL, y = "Frequency") +
  theme_minimal() + coord_flip()


###################################################################################
# 6. Operations on a dfm: comparisons - comparison clouds, relative frequencies, 
#    keyness, similarity
###################################################################################
# a. comparison cloud
# compare documents (2 to 8) - 2017 and 2018 sotu
# function: textplot_wordcloud
corpus_subset(pd_corpus, X %in% c(93,940)) %>% 
  dfm(remove_punct = TRUE, remove_numbers = TRUE,
      tolower = TRUE, remove = stopwords("english")) %>% 
  textplot_wordcloud(comparison = TRUE, max_words = 150, 
                     color = c("orange", "blue"), labelsize = 1,
                     min_size = .3, max_size = 3)

# compare groups: groups arugment to dfm
dfm(pd_corpus, groups = "type3", remove_punct = TRUE, remove_numbers = TRUE,
    tolower = TRUE, remove = stopwords("english")) %>% 
  textplot_wordcloud(comparison = TRUE, max_words = 100,
                     color = c("orange", "turquoise", "blue3"),
                     min_size = .3, max_size = 3, labelsize = 1)

# b. relative frequencies by group
# function: textstat_frequency
# for relative frequency plots, (word count divided by the length of doc) 
#   weight the dfm
pd_dfm_prop <- dfm_weight(pd_dfm, scheme = "prop")
# calculate relative frequency by a document variable
pd_relfreq <- textstat_frequency(pd_dfm_prop, n = 20, groups = "type3")

ggplot(pd_relfreq, aes(x = nrow(pd_relfreq):1, y = frequency)) +
  geom_point() + facet_wrap(~ group, scales = "free") +
  scale_x_continuous(breaks = nrow(pd_relfreq):1,
                     labels = pd_relfreq$feature) +
  labs(x = NULL, y = "Relative frequency") +
  coord_flip() 

# c. keyness: differential association of keywords in a target and reference group
# function: textstat_keyness, textplot_keyness
pdtype_key <- corpus_subset(pd_corpus, type3 %in% c("script", "unscript")) %>% 
  dfm(groups = "type3", remove_punct = TRUE, remove_numbers = TRUE,
      tolower = TRUE, remove = stopwords("english")) %>% 
  textstat_keyness(target = "unscript")

textplot_keyness(pdtype_key)
  
# d. similarity
# function: textstat_simil
# for specific documents
# remove written documents and add stemming to dfm
pd_dfmstem <- dfm(corpus_subset(pd_corpus, type3 == "script"), 
                  remove_punct = TRUE, remove_numbers = TRUE,
                  tolower = TRUE, remove = stopwords("english"),
                  stem = TRUE, verbose = TRUE)

sim_sotu17 <- textstat_simil(pd_dfmstem, selection = "DCPD-201700150", 
                             margin = "documents", method = "cosine")
sim_sotu17
# plot cosine similarity 
sim_sotu_df <- as.data.frame(as.matrix(sim_sotu17)) # turn it into dataframe
sim_sotu_df$docid <- rownames(sim_sotu_df)
names(sim_sotu_df) <- c("sim", "docid")
# plot only those with similarity > 0.6 
sim_sotu_df %>% filter(sim > 0.6) %>% 
ggplot(aes(x = sim, y = reorder(docid, sim))) + 
  geom_point() +
  labs(title = "Similarity with 2017 State of the Union", 
       x = "Cosine similarity", y = "Document ID") +
  theme(axis.text.x = element_text(size=9))

# for all documents
# trim dfm (only words that occur at least three times in corpus and in at least three documents)
pd_dfmstemtrim <- dfm_trim(pd_dfmstem, min_count = 3, min_docfreq = 3)
# get distances on normalized dfm
pd_dist <- textstat_dist(dfm_weight(pd_dfmstemtrim, "prop"))
# hiearchical clustering of the distance object
pd_cluster <- hclust(pd_dist)
# label with document names
pd_cluster$labels <- docnames(pd_dfmstemtrim)
# plot as a dendrogram
plot(pd_cluster, xlab = "", main = "Euclidean Distance on Normalized Token Frequency",
     sub = "", cex = 0.5)


###################################################################################
# 7. More operations on a dfm: dictionaries, sentiment
###################################################################################
# a. apply dictionary, lexicon frequency
# function: dictionary

# dictionary for policy position
# download a Wordstat dictionary that contain political left-right ideology keywords (Laver and Garry 2000)
# download.file("https://raw.githubusercontent.com/quanteda/quanteda_tutorials/master/content/dictionary/laver-garry.cat", "laver_garry.cat")

# read it in
lgdict <- dictionary(file = "laver_garry.cat")
# apply dictionary
lg_dfm <- dfm(pd_corpus, dictionary = lgdict, 
              remove_punct = TRUE, tolower = TRUE)

# turn this into a dataframe, add to existing dataframe
lg_df <- as.data.frame(lg_dfm, row.names = lg_dfm@Dimnames$docs)

# add to iniital dataframe
presdocuments[,ncol(presdocuments)+1:21] <- lg_df[,1:21]
summary(presdocuments[,17:36])

# some manipulation to generate document scores
presdocuments <- presdocuments %>% 
  mutate(val_conserv = (VALUES.CONSERVATIVE - VALUES.LIBERAL)/(VALUES.CONSERVATIVE + VALUES.LIBERAL),
         law_conserv = (`LAW_AND_ORDER.LAW-CONSERVATIVE` - `LAW_AND_ORDER.LAW-LIBERAL`)/(`LAW_AND_ORDER.LAW-CONSERVATIVE` + `LAW_AND_ORDER.LAW-LIBERAL`),
         envir_anti = (`ENVIRONMENT.CON ENVIRONMENT` - `ENVIRONMENT.PRO ENVIRONMENT`)/(`ENVIRONMENT.CON ENVIRONMENT` + `ENVIRONMENT.PRO ENVIRONMENT`),
         state_anti = (`ECONOMY.-STATE-` - `ECONOMY.+STATE+`)/(`ECONOMY.-STATE-` + `ECONOMY.+STATE+`)) %>% 
  mutate(val_conserv = ifelse(is.na(val_conserv), 0, val_conserv),
         law_conserv = ifelse(is.na(law_conserv), 0, law_conserv),
         envir_anti = ifelse(is.na(envir_anti), 0, envir_anti),
         state_anti = ifelse(is.na(state_anti), 0, state_anti))
# examine scores by document type
presdocuments %>% select(type3, val_conserv:state_anti) %>% 
  group_by(type3) %>% summarize_all(mean)


###################################################################################
# 8. Yet more quanteda can do...
###################################################################################
# a. lexical diversity (ratio of unique types of tokens to number of tokens)
lexdiv <- textstat_lexdiv(pd_dfm, measure = "TTR")
presdocuments$lexdiv <- lexdiv$TTR # add to initial data frame to visualize

# Plot
ggplot(presdocuments, aes(x = date, y = lexdiv)) + 
  geom_point(aes(color=type3), alpha=0.5, size=2) +
  geom_smooth(aes(color=type3)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) + 
  labs(title = "'Lexical Diversity' of Presidential Documents",
       subtitle = "Trump Presidency",
       y = "Type/Token", x = "Date") +
  scale_color_manual(values=c("blue3","turquoise","orange3"), name="Type") +
  theme(plot.title = element_text(face="bold", size=16, hjust=0),
        axis.title = element_text(face="bold", size=14),
        panel.grid.minor = element_blank(), legend.position = c(0.9,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

# b. correspondence analysis and other scaling methods
# Run correspondence analysis on dfm
pd_ca <- textmodel_ca(pd_dfm)

# Plot estimated positions on one dimension
textplot_scale1d(pd_ca, margin = "documents")

# Get coordinates of first two dimensions
pdca_data <- data.frame(dim1 = coef(pd_ca)$coef_document, 
                      dim2 = coef(pd_ca, doc_dim = 2)$coef_document)
head(pdca_data)
# Add to initial dataframe
presdocuments[,ncol(presdocuments)+1:2] <- pdca_data[,1:2]
# Plot
ggplot(presdocuments, aes(x = dim1, y = dim2, color = type3)) + 
  geom_point(alpha = 0.5)

# What are the few that vary substantially on the second dimension?
pdca_dim2 <- pdca_data %>% filter(dim2 < -4 | dim2 > 2)
presdocuments %>% filter(docid %in% pdca_dim2$docid) %>% 
  select("docid", "title", "date")
# texts(pd_corpus)[docnames(pd_corpus) %in% pdca_dim2$docid]


###################################################################################
# things that didn't make sense with this corpus, but are cool
#   cluster analysis, feature co-occurence and semantic networks

# more complex things you can do starting with quanteda
#   collocation analysis (find n-grams, generate compound tokens)
#   feed a fcm into text2vec for word embeddings
#   feed a dfm into topicmodel or stm for topic modeling
###################################################################################

# Save the work
save.image("presdocdata.Rdata")
# load("presdocdata.Rdata")


###################################################################################
# string-of-words and collocation example
###################################################################################
# a. Tokenize a corpus: segment by word boundaries 
# function: tokens
pd_tokens <- tokens(pd_corpus) 
head(pd_tokens[[1]], 20) # first 20 tokens in 1st document

# b. remove punctuation, numbers, 
pd_tokens <- tokens(pd_corpus, remove_numbers = TRUE, remove_punct = TRUE)
head(pd_tokens[[1]], 20) 
# additional arguments: remove_hyphens, remove_separators [http://www.fileformat.info/info/unicode/category/index.htm]
#   remove_url [http(s)], remove_twitter [@, #]

# c. collocation analysis, finding multi-word expressions
# function: textstat_collocations
# first remove stopwords, but keep spaces to preserve non-adjacency
stopwords("english") # what are stopwords
pd_tokens <- tokens_remove(pd_tokens, stopwords("en"), padding = TRUE) 
head(pd_tokens[[1]], 20) 
# change all tokens to lower case
pd_tokens <- tokens_tolower(pd_tokens)
head(pd_tokens[[1]], 20) 
# generate collocations
pd_col <- textstat_collocations(pd_tokens, min_count = 10, tolower = FALSE)
head(pd_col, 50)

# d. retain important multi-word expressions
# function: tokens_compound
head(pd_col, 200)
pd_ctokens <- tokens_compound(pd_tokens, pd_col[c(1,3,5,7,12,30,37,38,42)])
head(pd_tokens[[3]],100) # before compounding
head(pd_ctokens[[3]],100) # after compounding

# function: token_ngrams generates all n-grams or skip-grams
# can call "kwic" on a tokens object as well

###################################################################################
# Sentiment dictionary example
###################################################################################
# dictionary for sentiment
# quanteda contains the Lexicoder Sentiment Dictionary 
#   created by Young and Soroka (2012), http://www.lexicoder.com/index.html
lengths(data_dictionary_LSD2015)
data_dictionary_LSD2015$negative
# but one could use other available dictionaries, or corpus-specific dictionaries

# apply dictionary to sentences
pd_sentences <- corpus_reshape(pd_corpus, to = "sentences")
lsd_dfm <- dfm(pd_sentences, dictionary = data_dictionary_LSD2015[1:2], 
               remove_punct = TRUE, tolower = TRUE)

# turn this into a dataframe, generate scores
lsd_df <- as.data.frame(lsd_dfm, row.names = lsd_dfm@Dimnames$docs)
lsd_df$words <- ntoken(pd_sentences)
lsd_df <- lsd_df %>% 
  mutate(tone = ((positive - negative)/words)*100)

# Which sentence is the most negative?
s <- lsd_df %>% 
  slice(which.min(tone))
s
# extract document.segment from corpus
texts(pd_sentences)[docnames(pd_sentences) == s$document ]



