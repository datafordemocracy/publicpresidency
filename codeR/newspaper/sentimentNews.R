###################################
# Media Coverage of Trump: NYT, WSJ
# Sentiment (quanteda) 
# Michele Claibourn
# February 21, 2017
# Updated January 9, 2017
##################################

#####################
# Loading libraries
# Setting directories
#####################
# install.packages("tidytext")

rm(list=ls())
library(dplyr)
library(tidyr)
library(ggplot2)
library(quanteda)
library(scales)
library(tidytext)

# Load the data and environment from exploreNews.R
setwd("~/Box Sync/mpc/dataForDemocracy/newspaper/")
load("workspaceR/newspaperExplore.RData")


####################
# Sentiment Analysis 
# via quanteda
####################
# Pull dictionaries from tidytext 
# (all are freely available online, and could be loaded as word vectors)
bing <- sentiments %>% filter(lexicon=="bing") 
table(bing$sentiment)
# sample(bing$word[bing$sentiment=="negative"], 10) # examples
# sample(bing$word[bing$sentiment=="positive"], 10) # examples


## Overall Tone/Polarity ##
sentDict <- dictionary(list(positive = bing$word[bing$sentiment=="positive"], negative = bing$word[bing$sentiment=="negative"]))
paperDFM <- dfm(qcorpus2, dictionary = sentDict) # apply dictionary
head(paperDFM,10)

# Turn this into a dataframe, create tone=positive-negative
paperTone <- as.data.frame(paperDFM, row.names = paperDFM@Dimnames$docs)
paperTone$id <- row.names(paperTone) # put row names into column

paperTone <- paperTone %>% 
  mutate(tone = positive - negative)
summary(paperTone$tone)
ggplot(paperTone, aes(x=tone)) + geom_histogram(bins=50)

# Add to existing data frame
qmeta2[,ncol(qmeta2)+1:3] <- paperTone[,c(1,2,4)]
# And create new variables
qmeta2 <- qmeta2 %>% mutate(words = as.integer(length), 
                              perpos = (positive/words)*100, 
                              perneg = (negative/words)*100,
                              pertone = perpos - perneg)

# Plot!
p <- ggplot(qmeta2, aes(x=date, y=pertone))
# Create date breaks to get chosen tick marks on graph
date.vec <- seq(from=as.Date("2017-01-20"), to=as.Date("2018-01-05"), by="week") # update to Friday after last story
p + geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2, alpha=.15) +
  geom_hline(yintercept=median(qmeta2$pertone), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("'Tone' of Newspaper Coverage of Trump") +
  labs(y = "Overall Tone (% of positive words - % of negative words)", x = "Date of Article") +
  scale_color_manual(values=c("blue3","turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))
ggsave("figuresR/newspapertone_naive.png")

summary(qmeta2$pertone)
qmeta2 %>% group_by(pub) %>% summarize(mean(pertone), sd(pertone)) 

mintone <- qmeta2 %>% filter(pertone == min(pertone))
mintone[,c("heading", "pub", "date", "pertone")] # Identify article
qmeta2$leadline[qmeta2$heading==mintone$heading] # first 500 characters of article
# texts(qcorpus2)[docvars(qcorpus2, "heading")==mintone$heading]

maxtone <- qmeta2 %>% filter(pertone == max(pertone))
maxtone[,c("heading", "pub", "date", "pertone")]
qmeta2$leadline[qmeta2$heading==maxtone$heading]
# texts(qcorpus2)[docvars(qcorpus2, "heading")==maxtone$heading]


# Plot just opeds
p <- ggplot(filter(qmeta2, oped==1), aes(x=date, y=pertone))
p + geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2, alpha=.15) +
  geom_hline(yintercept=median(qmeta2$pertone), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("'Tone' of Op/Ed Articles of Trump") +
  labs(y = "Overall Tone (% of positive words - % of negative words)", x = "Date of Article") +
  scale_color_manual(values=c("blue3","turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))

qmeta2 %>% filter(oped==1) %>% group_by(pub) %>% 
  summarize(mean(pertone), sd(pertone)) 

## Other Emotional Affect ##
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
qmeta2[,ncol(qmeta2)+1:4] <- paperAffect[,1:4]

qmeta2 <- qmeta2 %>% 
  mutate(anger=(angerW/words)*100,
         fear=(fearW/words)*100,
         anticipation=(anticipationW/words)*100,
         trust=(trustW/words)*100)

# Plot!
p <- ggplot(qmeta2, aes(x=date, y=anger))
p + geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$anger), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Anger Affect within Newspaper Coverage of Trump") +
  labs(y = "Anger Affect", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=18, hjust=0),
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))

checkanger <- qmeta2 %>% filter(anger == max(anger))
checkanger[,c("heading", "pub", "anger")]
qmeta2$leadline[qmeta2$heading==checkanger$heading]
# texts(qcorpus2)[docvars(qcorpus2, "heading")==checkanger$heading]

# Just op/eds again
p <- ggplot(filter(qmeta2, oped==1), aes(x=date, y=anger))
p + geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$anger), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Anger Affect within Op/Ed Articles of Trump") +
  labs(y = "Anger Affect", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))

# Or plot all four affect variables
qmeta2long <- qmeta2 %>% 
  select(date, pub, anger, fear, anticipation, trust) %>% 
  gather(sentiment, value, -date, -pub)

p <- ggplot(qmeta2long, aes(x=date, y=value)) 
p + geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2, alpha=0.15) +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("'Affect' of Newspaper Coverage of Trump") +
  labs(y = "Percent of Affect Words", x = "Date of Article") +
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


## Text polarity accounting for amplifiers/modifiers/qualifiers
# install.packages("sentimentr")
library(sentimentr)
# sentimentr operates on the sentence level
sentSent <- sentiment(qcorpus2$documents$texts) # apply sentiment function

# Use sentence-level sentiment to get average for story
articleSent <- sentSent %>% 
  group_by(element_id) %>% 
  summarize(avgSent = mean(sentiment), numSent = n(), numWords = sum(word_count))
qmeta2[,ncol(qmeta2)+1:3] <- articleSent[,2:4]

# Plot!
p <- ggplot(qmeta2, aes(x=date, y=avgSent))
p + geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2, alpha=.15) +
  geom_hline(yintercept=median(qmeta2$avgSent), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Sentiment of Newspaper Coverage of Trump") +
  labs(y = "Average Sentiment across Sentences", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=16),
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
p <- ggplot(filter(qmeta2, oped==1), aes(x=date, y=avgSent))
p + geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2, alpha=.15) +
  geom_hline(yintercept=median(qmeta2$avgSent), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Sentiment of Op/Ed Articles of Trump") +
  labs(y = "Average Sentiment across Sentences", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))

qmeta2 %>% filter(oped==1) %>% group_by(pub) %>% summarize(mean(avgSent), sd(avgSent)) 


# Sentiment trajectories
# sentSentNYT <- sentSent %>% filter(element_id<=length(qmeta2$pub[qmeta2$pub=="NYT"]))
# sentSentWSJ <- sentSent %>% filter(element_id>length(qmeta2$pub[qmeta2$pub=="NYT"]))

# sentiment trajectory of NYT articles (first 20)
# p <- ggplot(filter(sentSentNYT, element_id<21), aes(x=sentence_id, y=sentiment, group=element_id))
# p + geom_line(aes(color=element_id), alpha=0.5)

# p <- ggplot(filter(sentSentNYT, element_id<21), aes(x=sentence_id, y=sentiment))
# p + geom_line() + facet_wrap(~element_id)


## First three sentencences only (approximate the casual readers)
# sentSentNYT3 <- sentSent %>% filter(element_id<=length(qmeta2$pub[qmeta2$pub=="NYT"]) & sentence_id<4)
# sentSentWSJ3 <- sentSent %>% filter(element_id>length(qmeta2$pub[qmeta2$pub=="WSJ"]) & sentence_id<4)

## Initial sentiment trajectory of NYT
# p <- ggplot(sentSentNYT3, aes(x=sentence_id, y=sentiment, group=element_id))
# p + geom_line(aes(color=element_id), alpha=0.25)

## Initial sentiment trajectory of WSJ
# p <- ggplot(sentSentWSJ3, aes(x=sentence_id, y=sentiment, group=element_id))
# p + geom_line(aes(color=element_id), alpha=0.25)

# Save
rm("mintone", "maxtone", "checkanger", "checkfear", "bing", "nrc", "paperAffect", "paperTone", "affectDict", "sentDict")
save.image("workspaceR/newspaperSentiment.RData")
# load("workspaceR/newspaperSentiment.RData")


fakelies <- dictionary(list(lies=c("lie", "lied", "lies"), fake="fake"))
fakeliedfm  <- dfm(qcorpus2, dictionary=fakelies)
head(fakeliedfm,10)

# Turn this into a dataframe
paperfakelie <- as.data.frame(fakeliedfm, row.names = fakeliedfm@Dimnames$docs)
qmeta2[,ncol(qmeta2)+1:2] <- paperfakelie[,1:2]

# Group by week
library(lubridate)
byweek <- qmeta2 %>% 
  mutate(week=week(date)) %>% 
  group_by(week, pub) %>% 
  summarize(fake=sum(fake), lie=sum(lies))

# Plot!
p <- ggplot(byweek, aes(x=week, y=lie))
p + geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$anger), color="gray50") +
  geom_smooth(aes(color=pub)) +
  ggtitle("Mention of 'Lies' within Newspaper Coverage of Trump") +
  labs(y = "Anger Affect", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=18, hjust=0),
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))

p <- ggplot(byweek, aes(x=week, y=fake))
p + geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$anger), color="gray50") +
  geom_smooth(aes(color=pub)) +
  ggtitle("Mention of 'Fake' within Newspaper Coverage of Trump") +
  labs(y = "Anger Affect", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=18, hjust=0),
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))

## Next steps?
# Consider Lexicoder Sentiment Dictionary...http://www.lexicoder.com/
# Need to output the text of each article in the corpus to separate file in common folder (e.g., writeCorpus from tm)
# also contains beta version of policy dictionary to identify attention to policy areas