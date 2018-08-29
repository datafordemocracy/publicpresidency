##############################################################
# MSNBC Transcripts
# Michele Claibourn
# Acquire data: Jan 20, 2017 through Nov 16, 2017
# Rachel Maddow, Last Word/O'Donnell, All In/Hayes
# Updated: through July 31, 2018
##############################################################

rm(list=ls())
library(dplyr)
library(rvest)
library(tm)
library(stringr)
library(quanteda)


#####################
# Rachel Maddow
#####################
setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/cablenews/")
# if (!file.exists("maddow")) {
#   dir.create("maddow")
# }
setwd("maddow") 

# Load the source pages
maddow <- NULL # create null data set
# for 2018, change year in path (initially 2017) to 2018
for (i in 1:12) { 
  source_page <- read_html(paste0("http://www.msnbc.com/transcripts/rachel-maddow-show/2018/", i))
  
  # Get URLs associated with each day's transcript text
  url1 <- source_page %>% 
    html_nodes(".transcript-item a") %>%  
    html_attr("href") %>% 
    xml2::url_absolute("http://www.msnbc.com/")
  head(url1)
  
  madd1 <- data.frame(url=url1, stringsAsFactors=FALSE)
  maddow <- rbind(maddow, madd1)
}

# Turn into a dataframe and extract date, show segment
maddow$show <- "maddow"
maddow$date <- str_extract(maddow$url, "[0-9]{4}-[0-9]{2}-[0-9]{2}")
maddow$date <- as.Date(maddow$date, "%Y-%m-%d")

# # On initial run: Keep only transcripts since January 20, 2017
# maddow <- maddow %>% filter(date > as.Date("2017-01-19"))
# # On January run: Keep only transcripts since initial download, November 17, 2017 to December 31, 2017
# maddow <- maddow %>% 
#   filter(date > as.Date("2017-11-16") & date < as.Date("2018-01-01"))
# On March run: Keep only transcripts since December 31, 2017 to February 28, 2018
# maddow <- maddow %>% 
#   filter(date > as.Date("2017-12-31") & date < as.Date("2018-03-01"))
# On June run: Keep only transcripts since February 28, 2018 to May 31, 2018
# maddow <- maddow %>% 
#   filter(date > as.Date("2018-02-28") & date < as.Date("2018-06-01"))
# On August run: Keep only transcripts since June 1, 2018 to July 31, 2018
maddow <- maddow %>% 
  filter(date > as.Date("2018-05-31") & date < as.Date("2018-08-01"))

# Loop through each link in data.frame (nrow(maddow)) and 
# a. grab the html (read_html()), isolating node with text (".pane-node-body .pane-content",
# b. extract the text (html_text),
# c. append appropriate party label-year to downloaded file (paste0)
# d. and send output to file (sink/cat)
for(i in seq(nrow(maddow))) {
  text <- read_html(maddow$url[i]) %>% # load the page
    html_nodes(".pane-node-body .pane-content") %>% # isolate the text
    html_text() # get the text
  
  filename <- paste0(maddow$date[i], ".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}


#####################
# Last Word with Lawrence O'Donnell
#####################
setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/cablenews/")
# if (!file.exists("lastword")) {
#   dir.create("lastword")
# }
setwd("lastword") 

# Load the source pages
lastword <- NULL # create null data set
# for 2018, change year in path (initially 2017) to 2018
for (i in 1:12) { 
  source_page <- read_html(paste0("http://www.msnbc.com/transcripts/the-last-word/2018/", i))
  
  # Get URLs associated with each day's transcript text
  url1 <- source_page %>% 
    html_nodes(".transcript-item a") %>%  
    html_attr("href") %>% 
    xml2::url_absolute("http://www.msnbc.com/")
  head(url1)
  
  last1 <- data.frame(url=url1, stringsAsFactors=FALSE)
  lastword <- rbind(lastword, last1)
}

# Turn into a dataframe and extract date, show segment
lastword$show <- "lastword"
lastword$date <- str_extract(lastword$url, "[0-9]{4}-[0-9]{2}-[0-9]{2}")
lastword$date <- as.Date(lastword$date, "%Y-%m-%d")

# # On initial run: Keep only transcripts since January 20, 2017
# lastword <- lastword %>% filter(date > as.Date("2017-01-19"))
# # On January run: Keep only transcripts since initial download, November 17, 2017 to December 31, 2017
# lastword <- lastword %>% 
#   filter(date > as.Date("2017-11-16") & date < as.Date("2018-01-01"))
# On March run: Keep only transcripts since December 31, 2017 to February 28, 2018
# lastword <- lastword %>% 
#   filter(date > as.Date("2017-12-31") & date < as.Date("2018-03-01"))
# On June run: Keep only transcripts since February 28, 2018 to May 31, 2018
# lastword <- lastword %>% 
#   filter(date > as.Date("2018-02-28") & date < as.Date("2018-06-01"))
# On August run: Keep only transcripts since June 1, 2018 to July 31, 2018
lastword <- lastword %>% 
  filter(date > as.Date("2018-05-31") & date < as.Date("2018-08-01"))

# Download transcripts as text files 
for(i in seq(nrow(lastword))) {
  text <- read_html(lastword$url[i]) %>% # load the page
    html_nodes(".pane-node-body .pane-content") %>% # isolate the text
    html_text() # get the text
  
  filename <- paste0(lastword$date[i], ".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}


#####################
# All In with Chris Hayes
#####################
setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/cablenews/")
# if (!file.exists("allin")) {
#   dir.create("allin")
# }
setwd("allin") 

# Load the source pages
allin <- NULL # create null data set
# for 2018, change year in path (initially 2017) to 2018
for (i in 1:12) { 
  source_page <- read_html(paste0("http://www.msnbc.com/transcripts/all-in/2018/", i))
  
  # Get URLs associated with each day's transcript text
  url1 <- source_page %>% 
    html_nodes(".transcript-item a") %>%  
    html_attr("href") %>% 
    xml2::url_absolute("http://www.msnbc.com/")
  head(url1)
  
  all1 <- data.frame(url=url1, stringsAsFactors=FALSE)
  allin <- rbind(allin, all1)
}

# Turn into a dataframe and extract date, show segment
allin$show <- "allin"
allin$date <- str_extract(allin$url, "[0-9]{4}-[0-9]{2}-[0-9]{2}")
allin$date <- as.Date(allin$date, "%Y-%m-%d")

# # On initial run: Keep only transcripts since January 20, 2017
# allin <- allin %>% filter(date > as.Date("2017-01-19"))
# # On January run: Keep only transcripts since initial download, November 17, 2017 to December 31, 2017
# allin <- allin %>% 
#   filter(date > as.Date("2017-11-16") & date < as.Date("2018-01-01"))
# On March run: Keep only transcripts since December 31, 2017 to February 28, 2018
# allin <- allin %>% 
#   filter(date > as.Date("2017-12-31") & date < as.Date("2018-03-01"))
# On June run: Keep only transcripts since February 28, 2018 to May 31, 2018
# allin <- allin %>% 
#   filter(date > as.Date("2018-02-28") & date < as.Date("2018-06-01"))
# On August run: Keep only transcripts since June 1, 2018 to July 31, 2018
allin <- allin %>% 
  filter(date > as.Date("2018-05-31") & date < as.Date("2018-08-01"))

# Download transcripts as text files 
for(i in seq(nrow(allin))) {
  text <- read_html(allin$url[i]) %>% # load the page
    html_nodes(".pane-node-body .pane-content") %>% # isolate the text
    html_text() # get the text
  
  filename <- paste0(allin$date[i], ".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}
