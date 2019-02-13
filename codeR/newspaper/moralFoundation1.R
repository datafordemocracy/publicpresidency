###################################################################
# Media Coverage of Trump: NYT, WSJ, WP
# Moral foundations 
# Jessiza Mazen
# Created March 20, 2018
# Updated (mpc) February 8, 2019 to include through December 2018
###################################################################

###################################################################
# Loading libraries, Setting directories, Loading data ----

rm(list=ls())
library(tidyverse)
library(scales)
library("quanteda.dictionaries")
library(gridExtra)

# Load the data and environment from sentimentNews.R
setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/newspaper/")
load("workspaceR_newspaper/newspaperSentiment.RData")


###################################################################

# Moral foundations analysis  ---- 
paper_mf <- dfm(qcorpus2, dictionary = data_dictionary_MFD) 
head(paper_mf,10)

# Turn this into a dataframe,  add to existing dataframe
paper_moral <- convert(paper_mf, to = "data.frame")
qmeta2 <- left_join(qmeta2, paper_moral, by = c("id" = "document"))

# And create new variables
qmeta2 <- qmeta2 %>% 
  mutate(care_virtue=(care.virtue/words)*100,
         care_vice=(care.vice/words)*100,
         fair_virtue=(fairness.virtue/words)*100,
         fair_vice=(fairness.vice/words)*100,
         loyal_virtue=(loyalty.virtue/words)*100,
         loyal_vice=(loyalty.vice/words)*100,
         auth_virtue=(authority.virtue/words)*100,
         auth_vice=(authority.vice/words)*100,
         sanc_virtue=(sanctity.virtue/words)*100,
         sanc_vice=(sanctity.vice/words)*100)

# Care-Harm
# Plot
ph1 <- ggplot(qmeta2, aes(x=date, y=care_virtue)) +
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$care_virtue), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Care MF: Trump Coverage") +
  labs(y = "Care Language", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=16, hjust=0),
        axis.title = element_text(face="bold", size=12),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

ph2 <- ggplot(qmeta2, aes(x=date, y=care_vice)) + 
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$care_vice), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Harm MF: Trump Coverage") +
  labs(y = "Harm Language", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=16, hjust=0),
        axis.title = element_text(face="bold", size=12),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

grid.arrange(ph1, ph2, nrow = 1)

# Just opeds
# Plot
phoped1 <- ggplot(filter(qmeta2, oped==1), aes(x=date, y=care_virtue)) +
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$care_virtue), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Care MF: Trump Op-Eds") +
  labs(y = "Care Language", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=16, hjust=0),
        axis.title = element_text(face="bold", size=12),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

phoped2 <- ggplot(filter(qmeta2, oped==1), aes(x=date, y=care_vice)) + 
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$care_vice), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Harm MF: Trump Op-Eds") +
  labs(y = "Harm Language", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=16, hjust=0),
        axis.title = element_text(face="bold", size=12),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

grid.arrange(phoped1, phoped2, nrow = 1)

# Ingroup/loyalty-Others/betrayal
pi1 <- ggplot(qmeta2, aes(x=date, y=loyal_virtue)) + 
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$loyal_virtue), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Loyalty-Virtue: Trump Coverage") +
  labs(y = "Loyalty-Virtue Language", x = "Date") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=16, hjust=0),
        axis.title = element_text(face="bold", size=12),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

pi2 <- ggplot(qmeta2, aes(x=date, y=loyal_vice)) + 
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$loyal_vice), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Loyalty-Vice MF: Trump Coverage") +
  labs(y = "Loyalty-Vice Language", x = "Date") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=16, hjust=0),
        axis.title = element_text(face="bold", size=12),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

grid.arrange(pi1, pi2, nrow = 1)

# OPEDS: Ingroup/loyalty-Others/betrayal
pioped1 <- ggplot(filter(qmeta2, oped==1), aes(x=date, y=loyal_virtue)) + 
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$loyal_virtue), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Loyalty-Virtue MF: Trump Op-Eds") +
  labs(y = "Loyalty-Vice Language", x = "Date") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=16, hjust=0),
        axis.title = element_text(face="bold", size=12),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

pioped2 <- ggplot(filter(qmeta2, oped==1), aes(x=date, y=loyal_vice)) + 
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$loyal_vice), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Loyalty-Vice MF: Trump Op-Eds") +
  labs(y = "Loyalty-Vice Language", x = "Date") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=16, hjust=0),
        axis.title = element_text(face="bold", size=12),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

grid.arrange(pioped1, pioped2, nrow = 1)


# Save
rm("paper_mf", "paper_moral", "ph1", "ph2", "phoped1", "phoped2", "pi1", "pi2", "pioped1", "pioped2")
save.image("workspaceR_newspaper/newspaperMoral.RData")
# load("workspaceR_newspaper/newspaperMoral.RData")




