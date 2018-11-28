##############################################################
# FOX Transcripts
# Michele Claibourn
# Acquire data: September 2018 through October 2018
# Using Selenium (instead of rvest)
# The Five, Hannity, The Story/MacCallum
# Beginning in October, the webpages changed
# Updated: November 27, 2018 to adapt to web changes
# Updated: through October 31, 2018; September has considerable missingness
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

# Find the Show More button and click it n times 
# 7 (on 11/27/18 to get back to 9/1/18)
webMore <- remDr$findElement(using = 'css', value = ".js-load-more a")
counter <- 0
while(counter<8){
  webMore$clickElement()
  Sys.sleep(2) # add time between clicks
  counter <- sum(counter, 1)
}

hlink <- read_html(remDr$getPageSource()[[1]])

# When done, run this to stop the docker container to avoid issues with blocked ports
system('docker stop $(docker ps -q)')

title <- hlink %>% 
  html_nodes(".title a") %>%  
  html_text()
head(title)
url <- hlink %>% 
  html_nodes(".title a") %>% 
  html_attr("href") %>% 
  xml2::url_absolute("https://www.foxnews.com/")
head(url)
days <- hlink %>% 
  html_nodes(".time") %>% 
  html_text()
head(days)
days <- days[-1] # remove first entry ".com"
lead <- hlink %>% 
  html_nodes(".dek") %>% 
  html_text()
head(lead) # not all articles have leads present

five_url <- data.frame(days = days, title = title, url = url, stringsAsFactors = FALSE)

five_url <- five_url %>% 
  filter(!str_detect(url, "opinion")) %>% # remove gutfeld commentaries
  filter(!str_detect(url, "gutfeld")) %>% 
  filter(!str_detect(url, "video")) %>%  # remove video links
  filter(str_detect(days, "October|September")) %>% # keep only september and october
  mutate(days = paste(days, "2018", sep = ",")) %>% 
  mutate(date = as.Date(days, "%B %d,%Y"))
# note that september is definitely incomplete (find another way to fill in?)

# Download transcripts as text files 
setwd("five") 

for(i in seq(nrow(five_url))) {
  text <- read_html(five_url$url[i]) %>% # load the page
    html_nodes(".article-body") %>% # isolate the text
    html_text() # get the text
  
  filename <- paste(five_url$date[i], i, "txt", sep=".")
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

# Find the Show More button and click it n times 
# 4 (on 11/27/18 to get back to september; only goes back to 9/25 then jumps to June 28, then June 21, 2017)
webMore <- remDr$findElement(using = 'css', value = ".js-load-more a")
counter <- 0
while(counter<4){
  webMore$clickElement()
  Sys.sleep(2)
  counter <- sum(counter, 1)
}

hlink <- read_html(remDr$getPageSource()[[1]])

# When done, run this to stop the docker container to avoid issues with blocked ports
system('docker stop $(docker ps -q)')

title <- hlink %>% 
  html_nodes(".title a") %>%  
  html_text()
head(title)
url <- hlink %>% 
  html_nodes(".title a") %>% 
  html_attr("href") %>% 
  xml2::url_absolute("https://www.foxnews.com/")
head(url)
days <- hlink %>% 
  html_nodes(".time") %>% 
  html_text()
head(days)
days <- days[-1] # remove first entry ".com"
lead <- hlink %>% 
  html_nodes(".dek") %>% 
  html_text()
head(lead) # not all articles have leads present

hannity_url <- data.frame(days = days, title = title, url = url, stringsAsFactors = FALSE)

hannity_url <- hannity_url %>% 
  filter(!str_detect(url, "opinion")) %>% # remove opinion commentaries
  filter(!str_detect(url, "video")) %>%  # remove video links
  filter(str_detect(days, "October|September")) %>% # keep only september and october
  mutate(days = paste(days, "2018", sep = ",")) %>% 
  mutate(date = as.Date(days, "%B %d,%Y"))
# note that september is definitely incomplete (find another way to fill in?)

# Download transcripts as text files 
setwd("hannity") 

for(i in seq(nrow(hannity_url))) {
  text <- read_html(hannity_url$url[i]) %>% # load the page
    html_nodes(".article-body") %>% # isolate the text
    html_text() # get the text
  
  filename <- paste(hannity_url$date[i], i, "txt", sep=".")
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

# Find the Show More button and click it n times 
# 3 (on 11/27/18 to get back to september)
webMore <- remDr$findElement(using = 'css', value = ".js-load-more a")
counter <- 0
while(counter<4){
  webMore$clickElement()
  Sys.sleep(2)
  counter <- sum(counter, 1)
}

hlink <- read_html(remDr$getPageSource()[[1]])

# When done, run this to stop the docker container to avoid issues with blocked ports
system('docker stop $(docker ps -q)')

title <- hlink %>% 
  html_nodes(".title a") %>%  
  html_text()
head(title)
url <- hlink %>% 
  html_nodes(".title a") %>% 
  html_attr("href") %>% 
  xml2::url_absolute("https://www.foxnews.com/")
head(url)
days <- hlink %>% 
  html_nodes(".time") %>% 
  html_text()
head(days)
days <- days[-1] # remove first entry ".com"
lead <- hlink %>% 
  html_nodes(".dek") %>% 
  html_text()
head(lead) # not all articles have leads present

story_url <- data.frame(days = days, title = title, url = url, stringsAsFactors = FALSE)

story_url <- story_url %>% 
  filter(!str_detect(url, "opinion")) %>% # remove opinion commentaries
  filter(!str_detect(url, "video")) %>%  # remove video links
  filter(str_detect(days, "October|September")) %>% # keep only september and october
  mutate(days = paste(days, "2018", sep = ",")) %>% 
  mutate(date = as.Date(days, "%B %d,%Y"))
# note that september is definitely incomplete (find another way to fill in?)

# Download transcripts as text files 
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
