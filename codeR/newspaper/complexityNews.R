###################################################################
# Media Coverage of Trump: NYT, WSJ, WP
# Readability/complexity of news 
# Michele Claibourn
# Creaed February 21, 2017
# Updated August 29, 2018 with newspapers through July 31, 2018
###################################################################


###################################################################
# Loading libraries, Setting directories, Loading data ----

rm(list=ls())
library(tidyverse)
library(quanteda)
library(scales)
library(RColorBrewer)

# Load the data and environment from readNews.R
setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/newspaper/")
load("workspaceR/newspaperExplore.RData")


###################################################################
# Readability/Complexity Analysis of news articles --- 
fk <- textstat_readability(qcorpus2, measure = "Flesch.Kincaid")
qmeta2$readability <- fk$Flesch.Kincaid 

# Plot
qmeta2 %>% filter(readability<100) %>% 
  ggplot(aes(x = date, y = readability)) + 
  geom_jitter(aes(color=pub), alpha=0.05, width=0.25, height=0.0, size=2) +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) + 
  ggtitle("'Readability' of Newspaper Coverage of Trump") +
  labs(y = "Readability (grade level)", x = "Date of Article") +
  scale_color_manual(values=c("blue3","turquoise","orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=18, hjust=0),
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))
ggsave("figuresR/newspaperreadability.png")

qmeta2 %>% filter(readability<100) %>% 
  group_by(pub) %>% summarize(mean(readability)) 

# What are the "complex" and "simple" articles?
mincomplex <- qmeta2 %>% filter(readability <= 6)
mincomplex[,c("heading", "pub", "date", "readability")] 
# Many quizzes and transcripts of speeches/interviews

maxcomplex <- qmeta2 %>% filter(readability >= 20)
maxcomplex[,c("heading", "pub", "date", "readability")] # Identify article
# Many "at a glance" collections, aggregated news summaries

# Save
rm("fk", "mincomplex", "maxcomplex")
save.image("workspaceR/newspaperComplex.RData")
# load("workspaceR/newspaperComplex.RData")