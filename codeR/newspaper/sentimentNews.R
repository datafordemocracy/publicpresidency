###################################################################
# Media Coverage of Trump: NYT, WSJ, WP
# Sentiment (quanteda) 
# Michele Claibourn
# Created February 21, 2017
# Updated February 6, 2019 to include through December 2018
###################################################################

###################################################################
# Loading libraries, Setting directories, Loading data ----

# install.packages("sentimentr")
# install.packages("devtools")
# library(devtools)
# install_github("kbenoit/quanteda.dictionaries")

rm(list=ls())
library(tidyverse)
library(quanteda)
library(scales)
library(sentimentr)
library("quanteda.dictionaries")

# Load the data and environment from complexityNews.R
setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/newspaper/")
load("workspaceR_newspaper/newspaperComplex.RData")


###################################################################
# Sentiment Analysis, bing dictionary  ---- 

# Overall Tone/Polarity
paper_huliu <- dfm(qcorpus2, dictionary = data_dictionary_HuLiu) 
head(paper_huliu,10)

# Turn this into a dataframe, create tone=positive-negative
paper_tone <- convert(paper_huliu, to = "data.frame")

paper_tone <- paper_tone %>% 
  mutate(tone_bing = positive - negative) %>% 
  rname(positive_bing = positive, negative_bing = negative)

# Add to existing data frame
qmeta2 <- left_join(qmeta2, paper_tone, by = c("id" = "document"))

# And create new variables
qmeta2 <- qmeta2 %>% mutate(words = as.integer(length), 
                              perpos = (positive/words)*100, 
                              perneg = (negative/words)*100,
                              pertone = perpos - perneg)

# Plot!
# Create date breaks to get chosen tick marks on graph
ggplot(qmeta2, aes(x=date, y=pertone)) + 
  geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2, alpha=.05) +
  geom_hline(yintercept=median(qmeta2$pertone), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  labs(title = "'Tone' of Trump Coverage", 
       subtitle = "New York Times, Washington Post, Wall Street Journal", 
       y = "Overall Tone\n(% pos words - % neg words)", 
       x = "Date of Article") +
  scale_color_manual(values=c("blue3","turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=14),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))
ggsave("figuresR/newspapertone_naive.png")

summary(qmeta2$pertone)
qmeta2 %>% group_by(pub) %>% 
  summarize(mean(pertone), sd(pertone), min(tone), max(tone)) 

mintone <- qmeta2 %>% filter(pertone == min(pertone))
mintone[,c("heading", "pub", "date", "pertone")] # Identify article
qmeta2$leadline[qmeta2$heading==mintone$heading] # first 500 characters of article
# texts(qcorpus2)[docvars(qcorpus2, "heading")==mintone$heading]

maxtone <- qmeta2 %>% filter(pertone == max(pertone))
maxtone[,c("heading", "pub", "date", "pertone")]
qmeta2$leadline[qmeta2$heading==maxtone$heading]
# texts(qcorpus2)[docvars(qcorpus2, "heading")==maxtone$heading]

# Plot just opeds
ggplot(filter(qmeta2, oped==1), aes(x=date, y=pertone)) + 
  geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2, alpha=.15) +
  geom_hline(yintercept=median(qmeta2$pertone), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  labs(title = "'Tone' of Trump Op-Ed Coverage", 
       subtitle = "New York Times, Washington Post, Wall Street Journal", 
       y = "Overall Tone\n(% pos words - % neg words)", 
       x = "Date of Article") +
  scale_color_manual(values=c("blue3","turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=14),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))
ggsave("figuresR/opedtone_naive.png")

qmeta2 %>% filter(oped==1) %>% group_by(pub) %>% 
  summarize(mean(pertone), sd(pertone)) 

# create a comparison dataframe to compare tone characteristics across dictionaries
comparison <- data.frame(qmeta2 %>% group_by(pub) %>% 
                           summarize(mean(pertone), sd(pertone), 
                                     min(pertone),max(pertone))) %>% 
  mutate(oped=0, dict="bing")

comparison <- comparison %>% 
  rename(meantone = "mean.pertone.",
         sdtone = "sd.pertone.",
         mintone= "min.pertone.",
         maxtone= "max.pertone.")

comped <- data.frame(qmeta2 %>% 
                       filter(oped==1) %>% 
                       group_by(pub) %>% 
                       summarize(mean(pertone), sd(pertone), 
                                 min(pertone), max(pertone))) %>%
  mutate(oped=1, dict="bing") %>% 
  rename(meantone="mean.pertone.",
         sdtone="sd.pertone.",
         mintone="min.pertone.",
         maxtone="max.pertone.")

comparison <- rbind(comparison, comped)


###################################################################
# Other Emotional Affect, nrc dictionary  ----

paper_nrc <- dfm(qcorpus2, dictionary = data_dictionary_NRC) 
head(paper_nrc,10)

# Turn this into a dataframe, create tone=positive-negative
paper_affect <- convert(paper_nrc, to = "data.frame")
paper_affect <- paper_affect %>% 
  rename(negative_nrc = negative, positive_nrc = positive)

# Add to dataframe
qmeta2 <- left_join(qmeta2, paper_affect, by = c("id" = "document"))

qmeta2 <- qmeta2 %>% 
  mutate(peranger=(anger/words)*100,
         perfear=(fear/words)*100,
         perdisgust=(disgust/words)*100,
         persadness=(sadness/words)*100,
         peranticipation=(anticipation/words)*100,
         perjoy=(joy/words)*100,
         persurprise=(surprise/words)*100,
         pertrust=(trust/words)*100)

# Plot!
ggplot(qmeta2, aes(x=date, y=peranger)) +
  geom_jitter(aes(color=pub), alpha=0.05, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$peranger), color="gray50") +
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

checkanger <- qmeta2 %>% filter(peranger == max(peranger))
checkanger[,c("heading", "pub", "anger")]
qmeta2$leadline[qmeta2$heading==checkanger$heading]
# texts(qcorpus2)[docvars(qcorpus2, "heading")==checkanger$heading]

# Just op/eds again
ggplot(filter(qmeta2, oped==1), aes(x=date, y=peranger)) +
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$peranger), color="gray50") +
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

# Or plot all eight affect variables
qmeta2long <- qmeta2 %>% 
  select(date, pub, peranger, perfear, perdisgust, persadness, peranticipation, perjoy, persurprise, pertrust) %>% 
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

checkfear <- qmeta2 %>% filter(perfear==max(perfear))
checkfear[,c("heading", "pub", "fear")]
qmeta2$leadline[qmeta2$heading==checkfear$heading]
# texts(qcorpus2)[docvars(qcorpus2, "heading")==checkfear$heading]


###################################################################
## Lexicoder 
paper_lex <- dfm(qcorpus2, dictionary = data_dictionary_LSD2015) 
head(paper_lex,10)
## Not accounting for negations 

# Turn this into a dataframe, create tone=positive-negative
paper_pole <- convert(paper_lex, to = "data.frame")
paper_pole <- paper_pole %>% 
  rename(negative_lsd = negative, positive_lsd = positive) %>% 
  mutate(tone_lsd = positive_lsd - negative_lsd) %>% 
  select(document, negative_lsd, positive_lsd, tone_lsd)

# Add to dataframe
qmeta2 <- left_join(qmeta2, paper_pole, by = c("id" = "document"))

# And create new variables
qmeta2 <- qmeta2 %>% 
  mutate(lperpos = (positive_lsd/words)*100, 
         lperneg = (negative_lsd/words)*100,
         lpertone = lperpos - lperneg)

# Plot!
# Create date breaks to get chosen tick marks on graph
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
ggsave("figuresR/newspapertone_lsd.png")

summary(qmeta2$lpertone)

# create a comparison dataframe to compare tone characteristics across dictionaries
lcomparison <- data.frame(qmeta2 %>% 
                            group_by(pub) %>% 
                            summarize(mean(lpertone), 
                                      sd(lpertone), 
                                      min(lpertone),
                                      max(lpertone))) %>% 
  mutate(oped=0, dict="lexicode") %>% 
  rename(meantone = "mean.lpertone.",
         sdtone = "sd.lpertone.",
         mintone= "min.lpertone.",
         maxtone= "max.lpertone.")

comparison <- rbind(comparison,lcomparison)


lmintone <- qmeta2 %>% filter(lpertone == min(lpertone))
lmintone[,c("heading", "pub", "date", "lpertone")] # Identify article
qmeta2$leadline[qmeta2$heading==lmintone$heading] # first 500 characters of article

lmaxtone <- qmeta2 %>% filter(lpertone == max(lpertone))
lmaxtone[,c("heading", "pub", "date", "lpertone")]
qmeta2$leadline[qmeta2$heading==lmaxtone$heading]

# Plot just opeds
ggplot(filter(qmeta2, oped==1), aes(x=date, y=lpertone)) + 
  geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2, alpha=.15) +
  geom_hline(yintercept=median(qmeta2$lpertone), color="gray50") +
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
ggsave("figuresR/opedtone_lsd.png")

lcomped <- data.frame(qmeta2 %>% 
                        filter(oped==1) %>% 
                        group_by(pub) %>% 
                        summarize(mean(lpertone), 
                                  sd(lpertone), 
                                  min(lpertone), 
                                  max(lpertone))) %>%
  mutate(oped=1,
         dict="lexicode") %>% 
  rename(meantone="mean.lpertone.",
         sdtone="sd.lpertone.",
         mintone="min.lpertone.",
         maxtone="max.lpertone.")

comparison <- rbind(comparison, lcomped)

ggplot(comparison, aes(y = meantone, x = pub)) + 
  geom_col() + facet_wrap(~ dict)

# Also contains beta version of policy dictionary to identify attention 
# to policy areas


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
rm("mintone", "maxtone", "checkanger", "checkfear", "paper_affect", "paper_tone", "paper_pole", "paper_lex", "paper_nrc", "paper_huliu")
rm("lmintone", "lmaxtone", "sentSent", "articleSent", "lcomped", "comped", "lcomparison")
save.image("workspaceR_newspaper/newspaperSentiment.RData")
# load("workspaceR_newspaper/newspaperSentiment.RData")
