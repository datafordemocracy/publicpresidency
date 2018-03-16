##############################################################
# FOX Transcripts
# Michele Claibourn
# Acquire data: Jan 20, 2017 through Nov 16, 2017
# The Five, Hannity, (The Story/MacCallum)
# Updated through December 31, 2017
##############################################################

rm(list=ls())
library(dplyr)
library(rvest)
library(tm)
library(stringr)
library(quanteda)


#####################
# The Five
#####################
setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/cablenews/")
# if (!file.exists("five")) {
#   dir.create("five")
# }
setwd("five") 

# Load the source pages
five <- NULL # create null data set

# for (i in 0:34) { # On initial run: manually searched for pages containing shows from jan 20 on; at that time (mid-November), had to seach through page 34
for (i in 0:4) { # On January run: searched for pages containing November 17 and on; had to search through page 4
      source_page <- read_html(paste0("http://www.foxnews.com/on-air/the-five/transcripts?page=", i, "&Submit=DISPLAY"))
  
  # Get URLs associated with each day's transcript text
  url1 <- source_page %>% 
    html_nodes("h2 a") %>%  
    html_attr("href") 
  head(url1)
  
  five1 <- data.frame(url=url1, stringsAsFactors=FALSE)
  five <- rbind(five, five1) # add next 10 to dataset
}

# Turn into a dataframe and extract date, show segment
five$show <- "theFive"
five$date <- str_extract(five$url, "[0-9]{4}/[0-9]{2}/[0-9]{2}")
five$date <- as.Date(five$date, "%Y/%m/%d")
five$seg <- ifelse(grepl("gutfeld", five$url), "gut", "five")

# # On initial run: Keep only transcripts since January 20, 2017
# five <- five %>% filter(date > as.Date("2017-01-19"))
# On January run: Keep only transcripts since initial download, November 17, 2017 to December 31, 2017
five <- five %>% 
  filter(date > as.Date("2017-11-16") & date < as.Date("2018-01-01"))

# Loop through each link in data.frame (nrow(five)) and 
# a. grab the html (read_html()), isolating node with text
#    in some cases, it's ".article-body", in some it's ".article-text";
# b. extract the text (html_text),
# c. and send output to file (sink/cat)
for(i in seq(nrow(five))) {
  
  if (length(read_html(five$url[i]) %>% html_nodes(".article-body")) >0 ) {
   text <- read_html(five$url[i]) %>% 
             html_nodes(".article-body") %>% 
             html_text() 
  }
   else {
      text <- read_html(five$url[i]) %>% 
        html_nodes(".article-text") %>% 
        html_text()
    }

  filename <- paste0(five$date[i], "-", five$seg[i],".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}


#####################
# Hannity
#####################
setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/cablenews/")
# if (!file.exists("hannity")) {
#   dir.create("hannity")
# }
setwd("hannity") 

# Load the source pages
hann <- NULL # create null data set

# for (i in 0:19) { # On initial run: manually searched for pages containing shows from jan 20 on; at that time (mid-November), had to seach through page 19
for (i in 0:2) { # On January run: searched for pages containing November 17 and on; had to search through page 2
  source_page <- read_html(paste0("http://www.foxnews.com/on-air/hannity/transcripts?page=", i, "&Submit=DISPLAY"))
  
  # Get URLs associated with each day's transcript text
  url1 <- source_page %>% 
    html_nodes(".title a") %>%  
    html_attr("href") 
  head(url1)
  
  hann1 <- data.frame(url=url1, stringsAsFactors=FALSE)
  hann <- rbind(hann, hann1) # add next 10 to dataset
}

# Turn into a dataframe and extract date, show segment
hann$show <- "hannity"
hann$date <- str_extract(hann$url, "[0-9]{4}/[0-9]{2}/[0-9]{2}")
hann$date <- as.Date(hann$date, "%Y/%m/%d")

# # On initial run: Keep only transcripts since January 20, 2017
# hann <- hann %>% filter(date > as.Date("2017-01-19"))
# On January run: Keep only transcripts since initial download, November 17, 2017 to December 31, 2017
hann <- hann %>% 
  filter(date > as.Date("2017-11-16") & date < as.Date("2018-01-01"))

# Download transcripts as text files 
for(i in seq(nrow(hann))) {
  
  if (length(read_html(hann$url[i]) %>% html_nodes(".article-body")) >0 ) {
    text <- read_html(hann$url[i]) %>% 
      html_nodes(".article-body") %>% 
      html_text() 
  }
  else {
    text <- read_html(hann$url[i]) %>% 
      html_nodes(".article-text") %>% 
      html_text()
  }
  
  filename <- paste0(hann$date[i], ".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}


#####################
# Bret Baier 
# In mid-November, can only get last month so far, 10/16-11/17
# SKIP
#####################
setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/cablenews/")
# if (!file.exists("baier")) {
#   dir.create("baier")
# }
setwd("baier") 

# Load the source page
source_page <- read_html("http://www.foxnews.com/on-air/special-report-bret-baier/transcripts")
# Get URLs associated with each day's transcript text
url1 <- source_page %>% 
  html_nodes("#block-special-report-transcripts-search-list a") %>%  
  html_attr("href") 
head(url1)

# Turn into a dataframe and extract date, show segment
baier <- data.frame(show="baier", urls=url1, stringsAsFactors=FALSE)
baier$date <- str_extract(baier$urls, "[0-9]{4}/[0-9]{2}/[0-9]{2}")
baier$date <- as.Date(baier$date, "%Y/%m/%d")

# Download transcripts as text files 
for(i in seq(nrow(baier))) {
  text <- read_html(baier$urls[i]) %>% # load the page
    html_nodes(".article-body") %>% # isolate the text
    html_text() # get the text
  
  filename <- paste0(baier$date[i], ".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}


#####################
# The Story
# Show began on May 1
# Need to figure out how to control webpage via script
# or skip
#####################
setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/cablenews/")
# if (!file.exists("theStory")) {
#   dir.create("theStory")
# }
setwd("theStory") 

# Need to click show more button to display past most recent 10 stories: .js-load-more a)
# see acquire_fox_selenium.R
