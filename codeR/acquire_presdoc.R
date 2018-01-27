#####################
# MSNBC Transcripts
# Michele Claibourn
# Acquire daily compilations of presidential documents
# By month: through November 2017
#####################

rm(list=ls())
library(dplyr)
library(rvest)
library(tm)
library(stringr)
library(quanteda)

setwd("~/Box Sync/mpc/dataForDemocracy/")

if (!file.exists("presdoc")) {
  dir.create("presdoc")
}
setwd("presdoc") 


## January
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F01&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=130")

# Get URLs associated with each text
url1 <- source_page %>% 
  html_nodes(".browse-download-links a") %>% 
  html_attr("href")
# a:nth-child(2) selects just .htm links, but has extra NA on end...
url2 <- url1[seq.int(2,length(url1),3)] # grab the .htm urls (every 3rd item in list, beginning with the 2nd)

# Get doc number, title, type, and date
doc1 <- source_page %>% 
  html_nodes("#browse-drilldown-mask span") %>% 
  html_text()
doc2 <- doc1[seq.int(1,length(doc1),2)]
type2 <- doc1[seq.int(2,length(doc1),2)]

# Combine `links` and `urls` into a data frame
presdocjan <- data.frame(link=url2, doc=doc2, info=type2, stringsAsFactors=FALSE)
# Extract doc id, title, address type, date
presdocjan$docid <- str_split_fixed(presdocjan$doc, " - ", n=2)[,1]
presdocjan$title <- str_split_fixed(presdocjan$doc, " - ", n=2)[,2]
presdocjan$type <- str_split_fixed(presdocjan$info, "\\.", n=2)[,1]
presdocjan$date <- str_split_fixed(presdocjan$info, "\\.", n=2)[,2]
presdocjan$date <- as.Date(presdocjan$date, " %A, %B %d, %Y.")

# Keep only transcripts since January 20, 2017 (and with no missing date)
presdocjan <- presdocjan %>% filter(date > as.Date("2017-01-19"))

# via https://www.govinfo.gov/link-docs/ could generate sequence of links; e.g., 
# https://www.govinfo.gov/link/cpd/2017?link-type=html&dcpdnumber=00010 
# on which to increment. But also want info from gpo page -- 

# Loop through each link in data.frame (nrow(presdocjan)) and 
# a. grab the html (read_html()), isolating node with text ("p",
# b. extract the text (html_text),
# c. append appropriate party label-year to downloaded file (paste0)
# d. and send output to file (sink/cat)
for(i in seq(nrow(presdocjan))) {
  text <- read_html(presdocjan$link[i]) %>% # load the page
    html_nodes("p") %>% # isolate the text
    html_text() # get the text
  
  filename <- paste0(presdocjan$docid[i], ".txt")
  sink(file = filename) %>% # open file to write 
    cat(text, sep="\n")  # put the contents of "text" in the file
  sink() # close the file
}


## February
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F02&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=0")

# Get URLs associated with each text
url1 <- source_page %>% 
  html_nodes(".browse-download-links a") %>% 
  html_attr("href")
# a:nth-child(2) selects just .htm links, but has extra NA on end...
url2 <- url1[seq.int(2,length(url1),3)]

# Get doc number, title, type, and date
doc1 <- source_page %>% 
  html_nodes("#browse-drilldown-mask span") %>% 
  html_text()
doc2 <- doc1[seq.int(1,length(doc1),2)]
type2 <- doc1[seq.int(2,length(doc1),2)]

# Combine `links` and `urls` into a data frame
presdocfeb <- data.frame(link=url2, doc=doc2, info=type2, stringsAsFactors=FALSE)
# Extract doc id, title, address type, date
presdocfeb$docid <- str_split_fixed(presdocfeb$doc, " - ", n=2)[,1]
presdocfeb$title <- str_split_fixed(presdocfeb$doc, " - ", n=2)[,2]
presdocfeb$type <- str_split_fixed(presdocfeb$info, "\\.", n=2)[,1]
presdocfeb$date <- str_split_fixed(presdocfeb$info, "\\.", n=2)[,2]
presdocfeb$date <- as.Date(presdocfeb$date, " %A, %B %d, %Y.")

# Loop through each link in data.frame (nrow(presdocfeb)) and grab text
for(i in seq(nrow(presdocfeb))) {
  text <- read_html(presdocfeb$link[i]) %>% 
    html_nodes("p") %>% 
    html_text() 
  
  filename <- paste0(presdocfeb$docid[i], ".txt")
  sink(file = filename) %>% 
    cat(text, sep = "\n")  
  sink() 
}


## March
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F03&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=152")

# Get URLs associated with each text
url1 <- source_page %>% 
  html_nodes(".browse-download-links a") %>% 
  html_attr("href")
# a:nth-child(2) selects just .htm links, but has extra NA on end...
url2 <- url1[seq.int(2,length(url1),3)]

# Get doc number, title, type, and date
doc1 <- source_page %>% 
  html_nodes("#browse-drilldown-mask span") %>% 
  html_text()
doc2 <- doc1[seq.int(1,length(doc1),2)]
type2 <- doc1[seq.int(2,length(doc1),2)]

# Combine `links` and `urls` into a data frame
presdocmar <- data.frame(link=url2, doc=doc2, info=type2, stringsAsFactors=FALSE)
# Extract doc id, title, address type, date
presdocmar$docid <- str_split_fixed(presdocmar$doc, " - ", n=2)[,1]
presdocmar$title <- str_split_fixed(presdocmar$doc, " - ", n=2)[,2]
presdocmar$type <- str_split_fixed(presdocmar$info, "\\.", n=2)[,1]
presdocmar$date <- str_split_fixed(presdocmar$info, "\\.", n=2)[,2]
presdocmar$date <- as.Date(presdocmar$date, " %A, %B %d, %Y.")

# Loop through each link in data.frame (nrow(presdocmar)) and grab text
for(i in seq(nrow(presdocmar))) {
  text <- read_html(presdocmar$link[i]) %>% 
    html_nodes("p") %>% 
    html_text() 
  
  filename <- paste0(presdocmar$docid[i], ".txt")
  sink(file = filename) %>% 
    cat(text, sep = "\n")  
  sink() 
}


## April
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F04&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=3094")

# Get URLs associated with each text
url1 <- source_page %>% 
  html_nodes(".browse-download-links a") %>% 
  html_attr("href")
# a:nth-child(2) selects just .htm links, but has extra NA on end...
url2 <- url1[seq.int(2,length(url1),3)]

# Get doc number, title, type, and date
doc1 <- source_page %>% 
  html_nodes("#browse-drilldown-mask span") %>% 
  html_text()
doc2 <- doc1[seq.int(1,length(doc1),2)]
type2 <- doc1[seq.int(2,length(doc1),2)]

# Combine `links` and `urls` into a data frame
presdocapr <- data.frame(link=url2, doc=doc2, info=type2, stringsAsFactors=FALSE)
# Extract doc id, title, address type, date
presdocapr$docid <- str_split_fixed(presdocapr$doc, " - ", n=2)[,1]
presdocapr$title <- str_split_fixed(presdocapr$doc, " - ", n=2)[,2]
presdocapr$type <- str_split_fixed(presdocapr$info, "\\.", n=2)[,1]
presdocapr$date <- str_split_fixed(presdocapr$info, "\\.", n=2)[,2]
presdocapr$date <- as.Date(presdocapr$date, " %A, %B %d, %Y.")

# Loop through each link in data.frame (nrow(presdocapr)) and grab text
for(i in seq(nrow(presdocapr))) {
  text <- read_html(presdocapr$link[i]) %>% 
    html_nodes("p") %>% 
    html_text() 
  
  filename <- paste0(presdocapr$docid[i], ".txt")
  sink(file = filename) %>% 
    cat(text, sep = "\n")  
  sink() 
}


## May
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F05&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=3770")

# Get URLs associated with each text
url1 <- source_page %>% 
  html_nodes(".browse-download-links a") %>% 
  html_attr("href")
# a:nth-child(2) selects just .htm links, but has extra NA on end...
url2 <- url1[seq.int(2,length(url1),3)]

# Get doc number, title, type, and date
doc1 <- source_page %>% 
  html_nodes("#browse-drilldown-mask span") %>% 
  html_text()
doc2 <- doc1[seq.int(1,length(doc1),2)]
type2 <- doc1[seq.int(2,length(doc1),2)]

# Combine `links` and `urls` into a data frame
presdocmay <- data.frame(link=url2, doc=doc2, info=type2, stringsAsFactors=FALSE)
# Extract doc id, title, address type, date
presdocmay$docid <- str_split_fixed(presdocmay$doc, " - ", n=2)[,1]
presdocmay$title <- str_split_fixed(presdocmay$doc, " - ", n=2)[,2]
presdocmay$type <- str_split_fixed(presdocmay$info, "\\.", n=2)[,1]
presdocmay$date <- str_split_fixed(presdocmay$info, "\\.", n=2)[,2]
presdocmay$date <- as.Date(presdocmay$date, " %A, %B %d, %Y.")

# Loop through each link in data.frame (nrow(presdocmay)) and grab text
for(i in seq(nrow(presdocmay))) {
  text <- read_html(presdocmay$link[i]) %>% 
    html_nodes("p") %>% 
    html_text() 
  
  filename <- paste0(presdocmay$docid[i], ".txt")
  sink(file = filename) %>% 
    cat(text, sep = "\n")  
  sink() 
}


## June
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F06&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=4549")

# Get URLs associated with each text
url1 <- source_page %>% 
  html_nodes(".browse-download-links a") %>% 
  html_attr("href")
# a:nth-child(2) selects just .htm links, but has extra NA on end...
url2 <- url1[seq.int(2,length(url1),3)]

# Get doc number, title, type, and date
doc1 <- source_page %>% 
  html_nodes("#browse-drilldown-mask span") %>% 
  html_text()
doc2 <- doc1[seq.int(1,length(doc1),2)]
type2 <- doc1[seq.int(2,length(doc1),2)]

# Combine `links` and `urls` into a data frame
presdocjun <- data.frame(link=url2, doc=doc2, info=type2, stringsAsFactors=FALSE)
# Extract doc id, title, address type, date
presdocjun$docid <- str_split_fixed(presdocjun$doc, " - ", n=2)[,1]
presdocjun$title <- str_split_fixed(presdocjun$doc, " - ", n=2)[,2]
presdocjun$type <- str_split_fixed(presdocjun$info, "\\.", n=2)[,1]
presdocjun$date <- str_split_fixed(presdocjun$info, "\\.", n=2)[,2]
presdocjun$date <- as.Date(presdocjun$date, " %A, %B %d, %Y.")

# Loop through each link in data.frame (nrow(presdocjun)) and grab text
for(i in seq(nrow(presdocjun))) {
  text <- read_html(presdocjun$link[i]) %>% 
    html_nodes("p") %>% 
    html_text() 
  
  filename <- paste0(presdocjun$docid[i], ".txt")
  sink(file = filename) %>% 
    cat(text, sep = "\n")  
  sink() 
}


## July
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F08&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=3338")

# Get URLs associated with each text
url1 <- source_page %>% 
  html_nodes(".browse-download-links a") %>% 
  html_attr("href")
# a:nth-child(2) selects just .htm links, but has extra NA on end...
url2 <- url1[seq.int(2,length(url1),3)]

# Get doc number, title, type, and date
doc1 <- source_page %>% 
  html_nodes("#browse-drilldown-mask span") %>% 
  html_text()
doc2 <- doc1[seq.int(1,length(doc1),2)]
type2 <- doc1[seq.int(2,length(doc1),2)]

# Combine `links` and `urls` into a data frame
presdocjul <- data.frame(link=url2, doc=doc2, info=type2, stringsAsFactors=FALSE)
# Extract doc id, title, address type, date
presdocjul$docid <- str_split_fixed(presdocjul$doc, " - ", n=2)[,1]
presdocjul$title <- str_split_fixed(presdocjul$doc, " - ", n=2)[,2]
presdocjul$type <- str_split_fixed(presdocjul$info, "\\.", n=2)[,1]
presdocjul$date <- str_split_fixed(presdocjul$info, "\\.", n=2)[,2]
presdocjul$date <- as.Date(presdocjul$date, " %A, %B %d, %Y.")

# Loop through each link in data.frame (nrow(presdocjul)) and grab text
for(i in seq(nrow(presdocjul))) {
  text <- read_html(presdocjul$link[i]) %>% 
    html_nodes("p") %>% 
    html_text() 
  
  filename <- paste0(presdocjul$docid[i], ".txt")
  sink(file = filename) %>% 
    cat(text, sep = "\n")  
  sink() 
}


## August
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F07&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=4106")

# Get URLs associated with each text
url1 <- source_page %>% 
  html_nodes(".browse-download-links a") %>% 
  html_attr("href")
# a:nth-child(2) selects just .htm links, but has extra NA on end...
url2 <- url1[seq.int(2,length(url1),3)]

# Get doc number, title, type, and date
doc1 <- source_page %>% 
  html_nodes("#browse-drilldown-mask span") %>% 
  html_text()
doc2 <- doc1[seq.int(1,length(doc1),2)]
type2 <- doc1[seq.int(2,length(doc1),2)]

# Combine `links` and `urls` into a data frame
presdocaug <- data.frame(link=url2, doc=doc2, info=type2, stringsAsFactors=FALSE)
# Extract doc id, title, address type, date
presdocaug$docid <- str_split_fixed(presdocaug$doc, " - ", n=2)[,1]
presdocaug$title <- str_split_fixed(presdocaug$doc, " - ", n=2)[,2]
presdocaug$type <- str_split_fixed(presdocaug$info, "\\.", n=2)[,1]
presdocaug$date <- str_split_fixed(presdocaug$info, "\\.", n=2)[,2]
presdocaug$date <- as.Date(presdocaug$date, " %A, %B %d, %Y.")

# Loop through each link in data.frame (nrow(presdocaug)) and grab text
for(i in seq(nrow(presdocaug))) {
  text <- read_html(presdocaug$link[i]) %>% 
    html_nodes("p") %>% 
    html_text() 
  
  filename <- paste0(presdocaug$docid[i], ".txt")
  sink(file = filename) %>% 
    cat(text, sep = "\n")  
  sink() 
}


## September
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F09&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=2659")

# Get URLs associated with each text
url1 <- source_page %>% 
  html_nodes(".browse-download-links a") %>% 
  html_attr("href")
# a:nth-child(2) selects just .htm links, but has extra NA on end...
url2 <- url1[seq.int(2,length(url1),3)]

# Get doc number, title, type, and date
doc1 <- source_page %>% 
  html_nodes("#browse-drilldown-mask span") %>% 
  html_text()
doc2 <- doc1[seq.int(1,length(doc1),2)]
type2 <- doc1[seq.int(2,length(doc1),2)]

# Combine `links` and `urls` into a data frame
presdocsep <- data.frame(link=url2, doc=doc2, info=type2, stringsAsFactors=FALSE)
# Extract doc id, title, address type, date
presdocsep$docid <- str_split_fixed(presdocsep$doc, " - ", n=2)[,1]
presdocsep$title <- str_split_fixed(presdocsep$doc, " - ", n=2)[,2]
presdocsep$type <- str_split_fixed(presdocsep$info, "\\.", n=2)[,1]
presdocsep$date <- str_split_fixed(presdocsep$info, "\\.", n=2)[,2]
presdocsep$date <- as.Date(presdocsep$date, " %A, %B %d, %Y.")

# Loop through each link in data.frame (nrow(presdocsep)) and grab text
for(i in seq(nrow(presdocsep))) {
  text <- read_html(presdocsep$link[i]) %>% 
    html_nodes("p") %>% 
    html_text() 
  
  filename <- paste0(presdocsep$docid[i], ".txt")
  sink(file = filename) %>% 
    cat(text, sep = "\n")  
  sink() 
}


## October
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F10&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=5032")

# Get URLs associated with each text
url1 <- source_page %>% 
  html_nodes(".browse-download-links a") %>% 
  html_attr("href")
# a:nth-child(2) selects just .htm links, but has extra NA on end...
url2 <- url1[seq.int(2,length(url1),3)]

# Get doc number, title, type, and date
doc1 <- source_page %>% 
  html_nodes("#browse-drilldown-mask span") %>% 
  html_text()
doc2 <- doc1[seq.int(1,length(doc1),2)]
type2 <- doc1[seq.int(2,length(doc1),2)]

# Combine `links` and `urls` into a data frame
presdococt <- data.frame(link=url2, doc=doc2, info=type2, stringsAsFactors=FALSE)
# Extract doc id, title, address type, date
presdococt$docid <- str_split_fixed(presdococt$doc, " - ", n=2)[,1]
presdococt$title <- str_split_fixed(presdococt$doc, " - ", n=2)[,2]
presdococt$type <- str_split_fixed(presdococt$info, "\\.", n=2)[,1]
presdococt$date <- str_split_fixed(presdococt$info, "\\.", n=2)[,2]
presdococt$date <- as.Date(presdococt$date, " %A, %B %d, %Y.")

# Loop through each link in data.frame (nrow(presdococt)) and grab text
for(i in seq(nrow(presdococt))) {
  text <- read_html(presdococt$link[i]) %>% 
    html_nodes("p") %>% 
    html_text() 
  
  filename <- paste0(presdococt$docid[i], ".txt")
  sink(file = filename) %>% 
    cat(text, sep = "\n")  
  sink() 
}


## November
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F11&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=239")

# Get URLs associated with each text
url1 <- source_page %>% 
  html_nodes(".browse-download-links a") %>% 
  html_attr("href")
# a:nth-child(2) selects just .htm links, but has extra NA on end...
url2 <- url1[seq.int(2,length(url1),3)]

# Get doc number, title, type, and date
doc1 <- source_page %>% 
  html_nodes("#browse-drilldown-mask span") %>% 
  html_text()
doc2 <- doc1[seq.int(1,length(doc1),2)] # doc number is first element
type2 <- doc1[seq.int(2,length(doc1),2)] # type is second element

# Combine `links` and `urls` into a data frame
presdocnov <- data.frame(link=url2, doc=doc2, info=type2, stringsAsFactors=FALSE)
# Extract doc id, title, address type, date
presdocnov$docid <- str_split_fixed(presdocnov$doc, " - ", n=2)[,1]
presdocnov$title <- str_split_fixed(presdocnov$doc, " - ", n=2)[,2]
presdocnov$type <- str_split_fixed(presdocnov$info, "\\.", n=2)[,1]
presdocnov$date <- str_split_fixed(presdocnov$info, "\\.", n=2)[,2]
presdocnov$date <- as.Date(presdocnov$date, " %A, %B %d, %Y.")

# Loop through each link in data.frame (nrow(presdocnov)) and grab text
for(i in seq(nrow(presdocnov))) {
  text <- read_html(presdocnov$link[i]) %>% 
    html_nodes("p") %>% 
    html_text() 
  
  filename <- paste0(presdocnov$docid[i], ".txt")
  sink(file = filename) %>% 
    cat(text, sep = "\n")  
  sink() 
}
