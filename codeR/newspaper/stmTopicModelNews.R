###################################
# Media Coverage of Trump: NYT, NYP
# Structural Topic Models: stm library
# Estimation and visualization
# Michele Claibourn
# January 2018
# Updated March 30, 2018 
###################################

#####################
# Loading libraries
# Setting directories
#####################
rm(list=ls())
library(tidyverse)
library(quanteda)
library(stm)

# Load the data and environment from topicmodelNews.R
setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/newspaper/")
load("workspaceR/newspaperTopicModel.RData")


####################
# STM Prep
####################
# add days since inauguration as variable
inaugdate <- as.Date("2017-01-20", format="%Y-%m-%d")
qmeta2$days <- difftime(qmeta2$date, inaugdate, units="days")
docvars(qcorpus2, "days") <- qmeta2$days

# create docvars and text to read into stm
paperDocVars <- docvars(qcorpus2)
paperOut <- convert(npdfmReduced, to = "stm", 
                    docvars = paperDocVars)


####################
# STM evaluation of k
####################
# searchK estimates topic exclusivity, coherence; model likelihood, residuals for each k
# t1 <- Sys.time()
# paperEval <- searchK(paperOut$documents, paperOut$vocab, K = seq(10,100,10), 
#                    prevalence = ~ as.factor(pub) + as.factor(month), 
#                    data = paperOut$meta, init.type = "Spectral")
# Sys.time() - t1 # ~ 6 hours
# plot(paperEval)


#########################
# STM Estimation
# Estimation, k=100
# using stm
#########################
## Estimate with k=100
paperFit100 <- stm(paperOut$documents, paperOut$vocab, K = 100,
                   prevalence = ~ as.factor(pub) + s(days), 
                   max.em.its = 100,
                   data = paperOut$meta, init.type = "Spectral")


#########################
# STM Exploration
# Estimation, k=100
#########################
# Topic quality
topicQuality(paperFit100, paperOut$documents)
# Topic prevalence
plot(paperFit100, type = "summary", labeltype="frex")
# Topic top words
labelTopics(paperFit100)
# Topic prevalence by covariates
paperEffect100 <- estimateEffect(1:100 ~ as.factor(pub) + s(days), 
                                 paperFit100, meta = paperOut$meta)
summary(paperEffect100, topics = 3)
# plot(paperEffect100, covariate = "pub", topics = 3, # xlim=c(-0.2, 0.5),
#      labeltype="custom", custom.labels=c("NYT", "WSJ", "WP"))
# plot(paperEffect100, covariate = "days", method = "continuous", topics = 3)


#########################
# STM Dynamic Visualization
# Estimation, k=100
#########################
# stmBrowser: https://github.com/mroberts/stmBrowser
# library(stmBrowser)
 
# stmBrowser(paperFit100, data=paperOut$meta, 
#            covariates=c("pub", "days"), text="heading", 
#            n=5000, labeltype="frex", directory=getwd())

# devtools::install_github("timelyportfolio/stmBrowser@htmlwidget")
# devtools::install_github("mroberts/stmBrowser",dependencies=TRUE)
library(stmBrowser)
library(htmlwidgets)

stmwidget <- stmBrowser_widget(mod = paperFit100, data = paperOut$meta, 
                               covariates = c("pub", "days"), text = "heading", 
                               n = length(paperOut$documents), labeltype = "frex", width = 8, height = 8) 

saveWidget(stmwidget, file = "stmwidget.html", selfcontained = FALSE, 
           title = "Trump Newspaper Coverage: Topics")

saveWidget(stmwidget, file = "stmwidget2.html", selfcontained = TRUE, 
           title = "Trump Newspaper Coverage: Topics")

## More Plots
paperTopics <- as.data.frame(paperFit100$theta)
paperTopics <- cbind(paperTopics, qmeta2) # UPDATE debates16

# Topic prevalance by publication
pubTopics <- paperTopics %>% 
  select(c(1:100,109)) %>% # all topics, pub
  group_by(pub) %>% 
  summarize_all(funs(sum))

# Topic prevalence by month
# topicsLong <- paperTopics %>% 
#   select(V1:V100, month, pub) %>% # haven't created month
#   gather(topic, value, -month, -pub)

# topicsLongGeneral <- topicsLong %>% filter(date>as.Date("2016-09-01"))
# p <- ggplot(topicsLongGeneral, aes(x=topic, y=value, fill=party))
# p + geom_bar(stat="identity") + facet_wrap(~date) + 
#   scale_fill_manual(values=c("blue3", "orange3"))


##  save
save.image("workspaceR/newspaperTopicModel2.RData")
# load("workspaceR/newspaperTopicModel2.RData")

## Next steps?
# Unsupervised clustering for exploration...