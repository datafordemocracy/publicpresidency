###################################################################
# Media Coverage of Trump: NYT, WSJ, WP
# Sentiment (quanteda) 
# Michele Claibourn
# Created February 21, 2017
# Updated August 29, 2018 with newspapers through July 31, 2018
###################################################################

###################################################################
# Loading libraries, Setting directories, Loading data ----

## NOTE: Where data is pulled from and figures need to be changed - Aycan 

# Put sample articles as a text output to see bing, lexicoder positive/negative

# install.packages("tidytext")
# install.packages("sentimentr")

rm(list=ls())
library(tidyverse)
library(quanteda)
library(scales)
library(tidytext)
library(sentimentr)
library(ggplot2)

# Load the data and environment from complexityNews.R
setwd("~/Box Sync/")
load("workspaceR_newspaper/newspaperComplex.RData")

###################################################################

#qcorpus2a <- corpus_subset(qcorpus2, 1:ndoc(qcorpus2) %in% 0:1000)

###################################################################
# Sentiment Analysis, bing dictionary  ---- 

# Pull dictionaries from tidytext 
# (all are freely available online, and could be loaded as word vectors)
bing <- sentiments %>% filter(lexicon=="bing") 
table(bing$sentiment)
# sample(bing$word[bing$sentiment=="negative"], 10) # examples
# sample(bing$word[bing$sentiment=="positive"], 10) # examples


# Overall Tone/Polarity ##
sentDict <- dictionary(list(positive = bing$word[bing$sentiment=="positive"], negative = bing$word[bing$sentiment=="negative"]))
paperDFM <- dfm(qcorpus2, dictionary = sentDict) # apply dictionary
head(paperDFM,10)

# Turn this into a dataframe, create tone=positive-negative
#paperDFM@Dimnames shows dimensions of the corpus to access 
paperTone <- as.data.frame(paperDFM, row.names = paperDFM@Dimnames$docs)
paperTone$id <- row.names(paperTone) # put row names into column

paperTone <- paperTone %>% 
  mutate(tone = positive - negative)
summary(paperTone$tone)
ggplot(paperTone, aes(x=tone)) + geom_histogram(bins=50)
ggsave("newfiguresR/bingtonehist.png")

#qmeta2a <- qmeta2[1:1000,]

# Add to existing data frame
qmeta2[,ncol(qmeta2)+1:3] <- paperTone[,c(2,3,5)]
# And create new variables
qmeta2 <- qmeta2 %>% mutate(words = as.integer(length), 
                              perpos = (positive/words)*100, 
                              perneg = (negative/words)*100,
                              pertone = perpos - perneg)

# Plot!
# Create date breaks to get chosen tick marks on graph
date.vec <- seq(from=as.Date("2017-01-20"), to=as.Date("2018-09-07"), by="week") # update to Friday after last story

ggplot(qmeta2, aes(x=date, y=pertone)) + 
  geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2, alpha=.05) +
  geom_hline(yintercept=median(qmeta2$pertone), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  labs(title = "'Tone' of Trump Coverage - Bing", 
       subtitle = "New York Times, Washington Post, Wall Street Journal", 
       y = "Overall Tone\n(% positive words - % neg words)", 
       x = "Date of Article") +
  scale_color_manual(values=c("blue3","turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=14),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))
ggsave("newfiguresR/bingnewspapertone_naive.png")

summary(qmeta2$pertone)

# create a comparison dataframe to compare tone characteristics across dictionaries
comparison <- data.frame(qmeta2 %>% group_by(pub) %>% summarize(mean(pertone), 
                                                                 sd(pertone), min(pertone),max(pertone))) %>% 
  mutate(oped=0,
         dict="bing")

comparison <- comparison %>% 
  rename(meantone = "mean.pertone.",
         sdtone = "sd.pertone.",
         mintone= "min.pertone.",
         maxtone= "max.pertone.")


mintone <- qmeta2 %>% filter(pertone == min(pertone))
mintone[,c("heading", "pub", "date", "pertone")] # Identify article
qmeta2$leadline[qmeta2$heading==mintone$heading] # first 500 characters of article
# texts(qcorpus2)[docvars(qcorpus2, "heading")==mintone$heading]

mintone <- as.data.frame(list(dict="bing",type="min",mintone),stringsAsFactors = F)

maxtone <- qmeta2 %>% filter(pertone == max(pertone))
maxtone[,c("heading", "pub", "date", "pertone")]
qmeta2$leadline[qmeta2$heading==maxtone$heading]

maxtone <- as.data.frame(list(dict="bing",type="max",maxtone),stringsAsFactors = F)

# store min and max tone articles in toneart dataframe 
toneart <- rbind(mintone,maxtone)

# texts(qcorpus2)[docvars(qcorpus2, "heading")==maxtone$heading]

# Plot just opeds
ggplot(filter(qmeta2, oped==1), aes(x=date, y=pertone)) + 
  geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2, alpha=.15) +
  geom_hline(yintercept=median(qmeta2$pertone), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  labs(title = "'Tone' of Trump Op-Ed Coverage - Bing", 
       subtitle = "New York Times, Washington Post, Wall Street Journal", 
       y = "Overall Tone\n(% positive words - % neg words)", 
       x = "Date of Article") +
  scale_color_manual(values=c("blue3","turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=14),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))
ggsave("figuresR/bingopedtone_naive.png")

comped <- data.frame(qmeta2 %>% filter(oped==1) %>% group_by(pub) %>% 
  summarize(mean(pertone), sd(pertone), min(pertone), max(pertone))) %>%
  mutate(oped=1,
         dict="bing") %>% 
  rename(meantone="mean.pertone.",
         sdtone="sd.pertone.",
         mintone="min.pertone.",
         maxtone="max.pertone.")

comparison <- rbind(comparison, comped)


###################################################################
# Other Emotional Affect, nrc dictionary  ----
nrc <- sentiments %>% filter(lexicon=="nrc") 
table(nrc$sentiment)
sample(nrc$word[nrc$sentiment=="anger"], 10) # examples

affectDict <- dictionary(list(angerW=nrc$word[nrc$sentiment=="anger"], 
                              fearW=nrc$word[nrc$sentiment=="fear"],
                              anticipationW=nrc$word[nrc$sentiment=="anticipation"],
                              trustW=nrc$word[nrc$sentiment=="trust"]))
paperAffectDFM <- dfm(qcorpus2, dictionary = affectDict) # apply dictionary
head(paperAffectDFM,10)

# Turn this into a dataframe, add to existing dataframe
paperAffect <- as.data.frame(paperAffectDFM, row.names = paperAffectDFM@Dimnames$docs)
# Add to dataframe
qmeta2[,ncol(qmeta2)+1:4] <- paperAffect[,2:5]

qmeta2 <- qmeta2 %>% 
  mutate(anger=(angerW/words)*100,
         fear=(fearW/words)*100,
         anticipation=(anticipationW/words)*100,
         trust=(trustW/words)*100)

# Plot!
ggplot(qmeta2, aes(x=date, y=anger)) +
  geom_jitter(aes(color=pub), alpha=0.05, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$anger), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  labs(title = "Anger Affect in Trump Coverage", 
       subtitle = "New York Times, Washington Post, Wall Street Journal", 
       y = "Anger Affect", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=18, hjust=0),
        axis.title = element_text(face="bold", size=14),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))

checkanger <- qmeta2 %>% filter(anger == max(anger))
checkanger[,c("heading", "pub", "anger")]
qmeta2$leadline[qmeta2$heading==checkanger$heading]
# texts(qcorpus2)[docvars(qcorpus2, "heading")==checkanger$heading]

# Just op/eds again
ggplot(filter(qmeta2, oped==1), aes(x=date, y=anger)) +
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$anger), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  labs(title = "Anger Affect in Trump Op-Ed Coverage",        
       subtitle = "New York Times, Washington Post, Wall Street Journal", 
       y = "Anger Affect", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=14),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))

# Or plot all four affect variables
qmeta2long <- qmeta2 %>% 
  select(date, pub, anger, fear, anticipation, trust) %>% 
  gather(sentiment, value, -date, -pub)

ggplot(qmeta2long, aes(x=date, y=value)) +
  geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2, alpha=0.15) +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  labs(title = "'Affect' of Trump Coverage", 
       subtitle = "New York Times, Washington Post, Wall Street Journal", 
       y = "Percent of Affect Words", x = "Date of Article") +
  facet_wrap(~ sentiment, ncol=2, scales="free_y") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=18, hjust=0),
        axis.title = element_text(face="bold", size=16),
        strip.text = element_text(size=16),
        axis.text.x = element_text(angle=90),
        panel.grid.minor = element_blank(), legend.position = "bottom", legend.text=element_text(size=10))
ggsave("figuresR/newspaperaffect_naive.png")

checkfear <- qmeta2 %>% filter(fear==max(fear))
checkfear[,c("heading", "pub", "fear")]
qmeta2$leadline[qmeta2$heading==checkfear$heading]
# texts(qcorpus2)[docvars(qcorpus2, "heading")==checkfear$heading]


###################################################################
# Text polarity accounting for amplifiers/modifiers/qualifiers ----

# sentimentr operates on the sentence level
sentSent <- sentiment(qcorpus2$documents$texts) # apply sentiment function

# Use sentence-level sentiment to get average for story
articleSent <- sentSent %>% 
  group_by(element_id) %>% 
  summarize(avgSent = mean(sentiment), numSent = n(), numWords = sum(word_count))
qmeta2[,ncol(qmeta2)+1:3] <- articleSent[,2:4]

# Plot!
ggplot(qmeta2, aes(x=date, y=avgSent)) +
  geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2, alpha=.05) +
  geom_hline(yintercept=median(qmeta2$avgSent), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  labs(title = "Sentiment of Trump Coverage",
       subtitle = "New York Times, Washington Post, Wall Street Journal", 
       y = "Average Sentiment across Sentences", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=14),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))
ggsave("figuresR/newspapersentiment.png")

mintone <- qmeta2 %>% filter(avgSent == min(avgSent))
mintone[,c("heading", "pub", "date", "avgSent")] # Identify article
qcorpus2$documents$texts[docvars(qcorpus2, "heading")==mintone$heading]
# texts(qcorpus2)[docvars(qcorpus2, "heading")==mintone$heading]

maxtone <- qmeta2 %>% filter(avgSent == max(avgSent))
maxtone[,c("heading", "pub", "date", "avgSent")]
qcorpus2$documents$texts[docvars(qcorpus2, "heading")==maxtone$heading]
# texts(qcorpus2)[docvars(qcorpus2, "heading")==maxtone$heading]

# Just opeds again
ggplot(filter(qmeta2, oped==1), aes(x=date, y=avgSent)) +
  geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2, alpha=.15) +
  geom_hline(yintercept=median(qmeta2$avgSent), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  labs(title = "Sentiment of Trump Op-Ed Coverage",
       subtitle = "New York Times, Washington Post, Wall Street Journal", 
       y = "Average Sentiment across Sentences", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=14),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))

qmeta2 %>% filter(oped==1) %>% group_by(pub) %>% 
  summarize(mean(avgSent), sd(avgSent)) 

# Save
rm("mintone", "maxtone", "checkanger", "checkfear", "bing", "nrc", "paperAffect", "paperTone", "affectDict", "sentDict")
save.image("workspaceR/newspaperSentiment.RData")
# load("workspaceR/newspaperSentiment.RData")


###################################################################
## Lexicoder 
newslexi <- dfm(qcorpus2, dictionary = data_dictionary_LSD2015) 
head(newslexi,10)

### Not accounting for negations 
# Turn this into a dataframe, create tone=positive-negative
#paperDFM@Dimnames shows dimensions of the corpus to access 
lexiTone <- as.data.frame(newslexi, row.names = newslexi@Dimnames$docs)
lexiTone$id <- row.names(lexiTone) # put row names into column

lexiTone <- lexiTone %>% 
  mutate(ltone = positive - negative) %>% 
  rename(lpositive="positive",
         lnegative="negative")
summary(lexiTone$ltone)
ggplot(lexiTone, aes(x=ltone)) + geom_histogram(bins=50)
ggsave("newfiguresR/lexitonehist.png")

# Add to existing data frame

qmeta2[ ,ncol(qmeta2)+1:3] <- lexiTone[ ,c(2,3,7)]
# And create new variables
qmeta2 <- qmeta2 %>% mutate(lperpos = (lpositive/words)*100, 
                            lperneg = (lnegative/words)*100,
                            lpertone = lperpos - lperneg)

# Plot!
# Create date breaks to get chosen tick marks on graph
date.vec <- seq(from=as.Date("2017-01-20"), to=as.Date("2018-09-07"), by="week") # update to Friday after last story

ggplot(qmeta2, aes(x=date, y=lpertone)) + 
  geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2, alpha=.05) +
  geom_hline(yintercept=median(qmeta2$lpertone), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  labs(title = "'Tone' of Trump Coverage - Lexicode", 
       subtitle = "New York Times, Washington Post, Wall Street Journal", 
       y = "Overall Tone\n(% positive words - % neg words)", 
       x = "Date of Article") +
  scale_color_manual(values=c("blue3","turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=14),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))
ggsave("newfiguresR/lexnewspapertone_naive.png")

summary(qmeta2$lpertone)

# create a comparison dataframe to compare tone characteristics across dictionaries
lcomparison <- data.frame(qmeta2 %>% group_by(pub) %>% summarize(mean(lpertone), 
                                                                 sd(lpertone), min(lpertone),max(lpertone))) %>% 
  mutate(oped=0,
         dict="lexicode") %>% 
  rename(meantone = "mean.lpertone.",
         sdtone = "sd.lpertone.",
         mintone= "min.lpertone.",
         maxtone= "max.lpertone.")

comparison <- rbind(comparison,lcomparison)


lmintone <- qmeta2 %>% filter(lpertone == min(lpertone))
lmintone[,c("heading", "pub", "date", "lpertone")] # Identify article
qmeta2$leadline[qmeta2$heading==lmintone$heading] # first 500 characters of article
# texts(qcorpus2)[docvars(qcorpus2, "heading")==mintone$heading]

lmaxtone <- qmeta2 %>% filter(lpertone == max(lpertone))
lmaxtone[,c("heading", "pub", "date", "lpertone")]
qmeta2$leadline[qmeta2$heading==lmaxtone$heading]


# texts(qcorpus2)[docvars(qcorpus2, "heading")==maxtone$heading]

# Plot just opeds
ggplot(filter(qmeta2, oped==1), aes(x=date, y=pertone)) + 
  geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2, alpha=.15) +
  geom_hline(yintercept=median(qmeta2$pertone), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  labs(title = "'Tone' of Trump Op-Ed Coverage", 
       subtitle = "New York Times, Washington Post, Wall Street Journal", 
       y = "Overall Tone\n(% positive words - % neg words)", 
       x = "Date of Article") +
  scale_color_manual(values=c("blue3","turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=14),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))
ggsave("newfiguresR/lexopedtone_naive.png")

lcomped <- data.frame(qmeta2 %>% filter(oped==1) %>% group_by(pub) %>% 
                       summarize(mean(lpertone), sd(lpertone), min(lpertone), max(lpertone))) %>%
  mutate(oped=1,
         dict="lexicode") %>% 
  rename(meantone="mean.lpertone.",
         sdtone="sd.lpertone.",
         mintone="min.lpertone.",
         maxtone="max.lpertone.")

comparison <- rbind(comparison, lcomped)


# Also contains beta version of policy dictionary to identify attention 
# to policy areas