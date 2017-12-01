#####################
# CNN Transcripts
# Michele Claibourn
# Acquire data
# Anderson Cooper, Erin Burnnett, Wolf Blitzer/Situation Room
#####################

rm(list=ls())
library(dplyr)
library(rvest)
library(tm)
library(stringr)
library(quanteda)


#####################
# Anderson Cooper 360
#####################
setwd("~/Box Sync/mpc/dataForDemocracy/cablenews/")

if (!file.exists("ac360")) { # create folder if it doesn't exist
  dir.create("ac360")
}
setwd("ac360") # then set it as working directory

# Load the source page
source_page <- read_html("http://www.cnn.com/TRANSCRIPTS/acd.html")
# Get URLs associated with each day's transcript text
url1 <- source_page %>% 
  html_nodes(".cnnSectBulletItems a") %>%  
  html_attr("href") %>% 
xml2::url_absolute("http://www.cnn.com")
head(url1)

# Turn into a dataframe and extract date, show segment
cnnac360 <- data.frame(show="ac360", urls=url1, stringsAsFactors=FALSE)
cnnac360$date <- str_extract(cnnac360$urls, "[0-9]{4}/[0-9]{2}")
cnnac360$date <- as.Date(cnnac360$date, "%y%m/%d")
urllength <- str_length(cnnac360$urls)
cnnac360$seg <- str_sub(cnnac360$urls, urllength-6, urllength-5)
# Keep only transcripts since January 20, 2017
cnnac360 <- cnnac360 %>% filter(date > as.Date("2017-01-19"))

# Loop through each link in data.frame (nrow(cnnac360)) and 
# a. grab the html (read_html()), isolating node with text (":nth-child(8)",
# b. extract the text (html_text),
# c. append appropriate party label-year to downloaded file (paste0)
# d. and send output to file (sink/cat)
for(i in seq(nrow(cnnac360))) {
  text <- read_html(cnnac360$urls[i]) %>% # load the page
    html_nodes(":nth-child(8)") %>% # isolate the text
    html_text() # get the text
  
  filename <- paste0(cnnac360$date[i], "-", cnnac360$seg[i], ".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}

# http://www.cnn.com/TRANSCRIPTS/1704/18/acd.01.html is missing, code stops
cnnac360b <- cnnac360 %>% filter(date < as.Date("2017-04-18"))

for(i in seq(nrow(cnnac360b))) {
  text <- read_html(cnnac360b$urls[i]) %>% # load the page
    html_nodes(":nth-child(8)") %>% # isolate the text
    html_text() # get the text
  
  filename <- paste0(cnnac360b$date[i], "-", cnnac360b$seg[i], ".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}


#######################
# Erin Burnett Outfront
#######################
setwd("~/Box Sync/mpc/dataForDemocracy/cablenews/")

if (!file.exists("ebo")) {
  dir.create("ebo")
}
setwd("ebo") 

# Load the source page
source_page <- read_html("http://transcripts.cnn.com/TRANSCRIPTS/ebo.html")
# Get URLs associated with each day's transcript text
url1 <- source_page %>% 
  html_nodes(".cnnSectBulletItems a") %>%  
  html_attr("href") %>% 
  xml2::url_absolute("http://transcripts.cnn.com")
head(url1)

# Turn into a dataframe and extract date, show segment
ebo <- data.frame(show="ebo", urls=url1, stringsAsFactors=FALSE)
ebo$date <- str_extract(ebo$urls, "[0-9]{4}/[0-9]{2}")
ebo$date <- as.Date(ebo$date, "%y%m/%d")
urllength <- str_length(ebo$urls)
ebo$seg <- str_sub(ebo$urls, urllength-6, urllength-5)
# Keep only transcripts since January 20, 2017
ebo <- ebo %>% filter(date > as.Date("2017-01-19"))

# Download transcripts as text files 
for(i in seq(nrow(ebo))) {
  text <- read_html(ebo$urls[i]) %>% # load the page
    html_nodes(":nth-child(8)") %>% # isolate the text
    html_text() # get the text
  
  filename <- paste0(ebo$date[i], "-", ebo$seg[i], ".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}

# stopped on 10/10 - not sure why...
ebob <- ebo %>% filter(date < as.Date("2017-10-10"))

for(i in seq(nrow(ebob))) {
  text <- read_html(ebob$urls[i]) %>% # load the page
    html_nodes(":nth-child(8)") %>% # isolate the text
    html_text() # get the text
  
  filename <- paste0(ebob$date[i], "-", ebob$seg[i], ".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}

# stopped on 1/24 - not sure why...
eboc <- ebo %>% filter(date < as.Date("2017-1-24"))

for(i in seq(nrow(eboc))) {
  text <- read_html(eboc$urls[i]) %>% # load the page
    html_nodes(":nth-child(8)") %>% # isolate the text
    html_text() # get the text
  
  filename <- paste0(eboc$date[i], "-", eboc$seg[i], ".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}


#######################
# The Situation Room
#######################
setwd("~/Box Sync/mpc/dataForDemocracy/cablenews/")

if (!file.exists("tsr")) {
  dir.create("tsr")
}
setwd("tsr") 

# Load the source page
source_page <- read_html("http://transcripts.cnn.com/TRANSCRIPTS/sitroom.html")
# Get URLs associated with each day's transcript text
url1 <- source_page %>% 
  html_nodes(".cnnSectBulletItems a") %>%  
  html_attr("href") %>% 
  xml2::url_absolute("http://transcripts.cnn.com")
head(url1)

# Turn into a dataframe and extract date, show segment
tsr <- data.frame(show="tsr", urls=url1, stringsAsFactors=FALSE)
tsr$date <- str_extract(tsr$urls, "[0-9]{4}/[0-9]{2}")
tsr$date <- as.Date(tsr$date, "%y%m/%d")
urllength <- str_length(tsr$urls)
tsr$seg <- str_sub(tsr$urls, urllength-6, urllength-5)
# Keep only transcripts since January 20, 2017
tsr <- tsr %>% filter(date > as.Date("2017-01-19"))

# Download transcripts as text files 
for(i in seq(nrow(tsr))) {
  text <- read_html(tsr$urls[i]) %>% # load the page
    html_nodes(":nth-child(8)") %>% # isolate the text
    html_text() # get the text
  
  filename <- paste0(tsr$date[i], "-", tsr$seg[i], ".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}
