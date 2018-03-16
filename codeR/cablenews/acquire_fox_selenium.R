##############################################################
# FOX Transcripts
# Michele Claibourn
# Acquire data: Jan 20, 2017 through February 28, 2018
# Using Selenium (instead of rvest)
# The Five, Hannity, The Story/MacCallum
##############################################################

rm(list=ls())
# install.packages("RSelenium")
library(RSelenium)
library(tidyverse)
library(stringr)
library(rvest)

setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/cablenews/")


#####################
# The Five
#####################
system('docker run -d -p 4445:4444 selenium/standalone-chrome') # start a server
remDr <- remoteDriver(remoteServerAddr = "localhost", 
                      port = 4445L, browserName = "chrome") # connect to running server
remDr$open(silent = TRUE) # open connections
remDr$navigate("http://www.foxnews.com/category/shows/the-five/transcript.html") # navigate to url
remDr$getTitle() # check

# Find the Show More button and click it 7 times (on 3/14/18 to get back to 1/1/18)
webMore <- remDr$findElement(using = 'css', value = ".button.load-more.js-load-more")
counter <- 0
while(counter<8){
  webMore$clickElement()
  Sys.sleep(1) # add time between clicks
  counter <- sum(counter, 1)
}

# Find the list of articles
webElem <- remDr$findElement(using = 'css', value = ".js-infinite-list.content.article-list")
five_titles <- webElem$getElementText() # return article headline
five_html <- webElem$getElementAttribute("outerHTML") # return html to scrape for href

# When done, run this to stop the docker container to avoid issues with blocked ports
system('docker stop $(docker ps -q)')

# create data frame from titles
five_titles_split <- str_split(five_titles, "TRANSCRIPT")
five_titles_split <- five_titles_split[[1]][-1] # get rid of first empty element
five_titles_split <- as.data.frame(five_titles_split) # turn into dataframe
five_titles_split <- five_titles_split %>%  # split elements from title
  separate(five_titles_split, into = c("days", "title", "lead"), sep = "\\n")

# extract urls from five_html, create dataframe, format url, add date
href <- "href=.+\\.html"
five_url <- str_extract_all(five_html, href) # extract urls
five_url <- as.data.frame(five_url, stringsAsFactors = FALSE) # turn into dataframe
names(five_url) <- "url" # rename column

five_url <- five_url %>% 
  filter(!str_detect(url, "category")) %>% # remove non-transcript urls
  filter(!str_detect(url, "gutfeld")) %>%  # remove gutfeld commentaries
  group_by(url) %>% 
  slice(1) %>% # retain one of repeated urls
  ungroup() %>% 
  mutate(url = str_replace(url, "href=\"", "")) %>% # remove href=
  mutate(url = paste("http://www.foxnews.com", url, sep="")) %>% # add base to url
  mutate(date = str_extract(url, "[0-9]{4}/[0-9]{2}/[0-9]{2}")) %>% # extract date from url
  mutate(date = as.Date(date, "%Y/%m/%d")) %>% # format date
  arrange(desc(date))

five_url <- cbind(five_url, five_titles_split)
five_url <- five_url %>% 
  filter(date > as.Date("2017-12-31"))

# Download transcripts as text files 
setwd("five") 

for(i in seq(nrow(five_url))) {
  text <- read_html(five_url$url[i]) %>% # load the page
    html_nodes(".article-body") %>% # isolate the text
    html_text() # get the text
  
  filename <- paste0(five_url$date[i], ".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}
setwd("../")


#####################
# Hannity
#####################
system('docker run -d -p 4445:4444 selenium/standalone-chrome') # start a server
remDr <- remoteDriver(remoteServerAddr = "localhost", 
                      port = 4445L, browserName = "chrome") # connect to running server
remDr$open(silent = TRUE) # open connections
remDr$navigate("http://www.foxnews.com/category/shows/hannity/transcript.html") # navigate to url
remDr$getTitle() # check

# Find the Show More button and click it 4 times (on 3/14/18 to get back to 1/1/18)
webMore <- remDr$findElement(using = 'css', value = ".button.load-more.js-load-more")
counter <- 0
while(counter<4){
  webMore$clickElement()
  Sys.sleep(1)
  counter <- sum(counter, 1)
}

# Find the list of articles
webElem <- remDr$findElement(using = 'css', value = ".js-infinite-list.content.article-list")
hannity_titles <- webElem$getElementText() # return article headline
hannity_html <- webElem$getElementAttribute("outerHTML") # return html to scrape for href

# When done, run this to stop the docker container to avoid issues with blocked ports
system('docker stop $(docker ps -q)')

# create data frame from titles
hannity_titles_split <- str_split(hannity_titles, "TRANSCRIPT")
hannity_titles_split <- hannity_titles_split[[1]][-1] # get rid of first empty element
hannity_titles_split <- as.data.frame(hannity_titles_split, stringsAsFactors = FALSE) # turn into dataframe
hannity_titles_split <- hannity_titles_split %>%  # split elements from title
  separate(hannity_titles_split, into = c("days", "title", "lead"), sep = "\\n")

# extract urls from five_html, create dataframe, format url, add date
href <- "href=.+\\.html"
hannity_url <- str_extract_all(hannity_html, href) # extract urls
hannity_url <- as.data.frame(hannity_url, stringsAsFactors = FALSE) # turn into dataframe
names(hannity_url) <- "url" # rename column

hannity_url <- hannity_url %>% 
  filter(!str_detect(url, "foxnews")) %>% # remove non-transcript urls
  group_by(url) %>% 
  slice(1) %>% # retain one of repeated urls
  ungroup() %>% 
  mutate(url = str_replace(url, "href=\"", "")) %>% # remove href=
  mutate(url = paste("http://www.foxnews.com", url, sep="")) %>% # add base to url
  mutate(date = str_extract(url, "[0-9]{4}/[0-9]{2}/[0-9]{2}")) %>% # extract date from url
  mutate(date = as.Date(date, "%Y/%m/%d")) %>% # format date
  arrange(desc(date))

hannity_url <- cbind(hannity_url, hannity_titles_split)
hannity_url <- hannity_url %>% 
  filter(date > as.Date("2017-12-31"))

# Download transcripts as text files 
setwd("hannity") 

for(i in seq(nrow(hannity_url))) {
  text <- read_html(hannity_url$url[i]) %>% # load the page
    html_nodes(".article-body") %>% # isolate the text
    html_text() # get the text
  
  filename <- paste0(hannity_url$date[i], ".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}
setwd("../")


#####################
# The Story
# Show began on May 1
#####################
system('docker run -d -p 4445:4444 selenium/standalone-chrome') # start a server
remDr <- remoteDriver(remoteServerAddr = "localhost", 
                      port = 4445L, browserName = "chrome") # connect to running server
remDr$open(silent = TRUE) # open connections
remDr$navigate("http://www.foxnews.com/category/shows/the-story/transcript.html") # navigate to url
remDr$getTitle() # check

# Find the Show More button and click it 20 times (on 3/14/18 to get back 5/1/2017)
webMore <- remDr$findElement(using = 'css', value = ".button.load-more.js-load-more")
counter <- 0
while(counter<20){
  webMore$clickElement()
  Sys.sleep(2)
  counter <- sum(counter, 1)
}

# Find the list of articles
webElem <- remDr$findElement(using = 'css', value = ".js-infinite-list.content.article-list")
story_titles <- webElem$getElementText() # return article headline
story_html <- webElem$getElementAttribute("outerHTML") # return html to scrape for href

# When done, run this to stop the docker container to avoid issues with blocked ports
system('docker stop $(docker ps -q)')

# create data frame from titles
story_titles_split <- str_split(story_titles, "TRANSCRIPT")
story_titles_split <- story_titles_split[[1]][-1] # get rid of first empty element
story_titles_split <- as.data.frame(story_titles_split, stringsAsFactors = FALSE) # turn into dataframe
story_titles_split <- story_titles_split %>%  # split elements from title
  separate(story_titles_split, into = c("days", "title", "lead"), sep = "\\n")

# extract urls from five_html, create dataframe, format url, add date
href <- "href=.+\\.html"
story_url <- str_extract_all(story_html, href) # extract urls
story_url <- as.data.frame(story_url, stringsAsFactors = FALSE) # turn into dataframe
names(story_url) <- "url" # rename column

story_url <- story_url %>% 
  group_by(url) %>% 
  slice(1) %>% # retain one of repeated urls
  ungroup() %>% 
  mutate(url = str_replace(url, "href=\"", "")) %>% # remove href=
  mutate(url = paste("http://www.foxnews.com", url, sep="")) %>% # add base to url
  mutate(date = str_extract(url, "[0-9]{4}/[0-9]{2}/[0-9]{2}")) %>% # extract date from url
  mutate(date = as.Date(date, "%Y/%m/%d")) %>% # format date
  arrange(desc(date))
story_url <- story_url[1:210,] # stray row at end

story_url <- cbind(story_url, story_titles_split)

# Download transcripts as text files 
if (!file.exists("theStory")) {
  dir.create("theStory")
  }
setwd("theStory") 

for(i in seq(nrow(story_url))) {
  text <- read_html(story_url$url[i]) %>% # load the page
    html_nodes(".article-body") %>% # isolate the text
    html_text() # get the text
  
  filename <- paste0(story_url$date[i], ".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}
setwd("../")


save.image("foxurls.RData")
