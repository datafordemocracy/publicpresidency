###################################################################
# Media Coverage of Trump
# Read, format newspaper articles
# NYT and WP from Lexis-Nexis; WSJ from Factiva
# Michele Claibourn
# Created February 1, 2017
# Updated August 29, 2018 with newspapers through July 31, 2018
####################################################################


####################################################################
# Loading libraries, Setting directories, Creating functions ----

# install.packages("tm")
# install.packages("tm.plugin.lexisnexis")
# install.packages("tm.plugin.factiva")
# install.packages("quanteda")

# When you start collecting data, you'll need to create 3 folders - nytread, wpread, wsjread - these folders should include the first 
# article you download from these newspapers. In order to not waste time by generating all files again, the code creates a new folder
# where you should download your articles into after the initial creation of the quanteda corpuses.
# New folders are named - nytnew, wpnew, wsjnew
# You should also create a folder in the directory called workspaceR where we will store Rdata files for each news source

# Change the directories to your local folders wherever it says #change to your own folder

rm(list=ls())
library(tm)
library(xml2) # instead of XML?
library(tm.plugin.factiva)
library(tm.plugin.lexisnexis)
library(quanteda)
library(tidyverse)
library(rvest)
library(stringr)

# Point to path for html files
setwd("~/Box Sync")

# Adjust readFactivaHTML function (see readNewsError.R for background)
source("/Users/aycankatitas/publicpresidency/codeR/newspaper/readFactivaHTML3.R") #change to your own folder
assignInNamespace("readFactivaHTML", readFactivaHTML3, ns="tm.plugin.factiva")

# Function to read lexis-nexis article files and turn into a corpus
read_lnfiles <- function(x){
  source <- LexisNexisSource(x)
  Corpus(source)
}

# Function to read lexis-nexis meta files and turn into a dataframe
read_lnmeta <- function(x){
  read_csv(x)
}

# Function to read factiva files and turn into a corpus
read_fvfiles <- function(x){
  source <- FactivaSource(x)
  Corpus(source)
}


####################################################################

### NEW YORK TIMES
# Read in NYT articles, using tm.plugin and tm, and clean up ----

# Check if a new article folder exists, if not, create one 
ifelse(!dir.exists("./nytnew"), dir.create("./nytnew"), FALSE) 

# List article files
# Check if new folder has any files in it 
nytnewfolder <- list.files("./nytnew") #change to your own folder

# If new folder doesn't have any files, process the files for the first time - This step is to be followed when you first 
# start collecting articles from NYT
if(length(nytnewfolder)==0){
  
  # Read article files
  nytfiles <- DirSource(directory="nytread/", pattern=".html", recursive=TRUE) #change directory to your own folder
  nytcorpus <- lapply(nytfiles$filelist, read_lnfiles) 
  nytcorpus <- do.call(c, nytcorpus)
  
  # In later exploration, found that NYT and WSJ use different abbreviation styles, 
  # altered the most common ones in NYT to match WSJ
  # f.b.i; c.i.a; e.p.a (appears mostly with periods (sometimes all caps) in NYT; usually all caps (sometimes with periods) in WSJ
  # this code searches the corpus and replaces all appearances of F.B.I. with FBI 
  
  nytcorpus <- tm_map(nytcorpus, content_transformer(function(x) gsub("F.B.I.", "FBI", x)))
  nytcorpus <- tm_map(nytcorpus, content_transformer(function(x) gsub("C.I.A.", "CIA", x)))
  nytcorpus <- tm_map(nytcorpus, content_transformer(function(x) gsub("E.P.A.", "EPA", x)))
  nytcorpus <- tm_map(nytcorpus, content_transformer(function(x) gsub("U.S.", "United States", x)))
  
  # Need to do something about this text -- appears frequently, and is pulled out as topic in later analysis...
  # "Follow The New York Times Opinion section on Facebook and Twitter (@NYTopinion), and sign up for the Opinion Today newsletter."
  
  nytcorpus <- tm_map(nytcorpus, content_transformer(function(x) gsub("Follow The New York Times Opinion section on Facebook and Twitter (@NYTopinion), and sign up for the Opinion Today newsletter.", "", x)))
  
  # Read in NYT metadata, using readr, and clean up ----
  
  # List meta files
  nytmetafiles <- DirSource(directory="nytread/", pattern="CSV", recursive=TRUE) # change directory to your own folder
  length(nytmetafiles) == length(nytfiles) # test that meta and articles match
  
  # Read meta files
  nytmeta <- lapply(nytmetafiles$filelist, read_lnmeta) 
  nytmeta <- do.call(rbind, nytmeta)
  nrow(nytmeta) == length(nytcorpus) # test that meta and articles still match
  
  # Improve the metadata
  nytmeta$length <- as.integer(str_extract(nytmeta$LENGTH, "[0-9]{1,4}"))
  nytmeta$date <- as.Date(nytmeta$DATE, "%B %d, %Y")
  nytmeta$pub <- "NYT"
  nytmeta$oped <- if_else(str_detect(nytmeta$SECTION, "Editorial Desk"), 1, 0)
  nytmeta$blog <- if_else(str_detect(nytmeta$PUBLICATION, "Blogs"), 1, 0)
  nytmeta <- nytmeta %>% dplyr::select(byline = BYLINE, headline = HEADLINE, length, date, pub, oped, blog, subject = SUBJECT, person = PERSON)
  save(nytcorpus,nytmeta, file="workspaceR_newspaper/nyt.Rdata") #change to your own folder
} else { # If new folder has files in it - This means you already created an R data from old newspapers
  load("workspaceR_newspaper/nyt.Rdata") #change to your own folder
  
  # Add in new files from new folders 
  nytfilesnew <- DirSource(directory="nytnew/", pattern=".html", recursive=TRUE)#change directory to your own folder
  # Read article files
  nytcorpusnew <- lapply(nytfilesnew$filelist, read_lnfiles) 
  nytcorpusnew <- do.call(c, nytcorpusnew)
  
  #Repeat the same steps as before
  nytcorpusnew <- tm_map(nytcorpusnew, content_transformer(function(x) gsub("F.B.I.", "FBI", x)))
  nytcorpusnew <- tm_map(nytcorpusnew, content_transformer(function(x) gsub("C.I.A.", "CIA", x)))
  nytcorpusnew <- tm_map(nytcorpusnew, content_transformer(function(x) gsub("E.P.A.", "EPA", x)))
  nytcorpusnew <- tm_map(nytcorpusnew, content_transformer(function(x) gsub("U.S.", "United States", x)))
  
  nytcorpusnew <- tm_map(nytcorpusnew, content_transformer(function(x) gsub("Follow The New York Times Opinion section on Facebook and Twitter (@NYTopinion), and sign up for the Opinion Today newsletter.", "", x)))
  
  nytmetafilesnew <- DirSource(directory="nytnew/", pattern="CSV", recursive=TRUE)#change directory to your own folder
  length(nytmetafilesnew) == length(nytfilesnew) # test that meta and articles match
  
  # Read meta files
  nytmetanew <- lapply(nytmetafilesnew$filelist, read_lnmeta) 
  nytmetanew <- do.call(rbind, nytmetanew)
  nrow(nytmetanew) == length(nytcorpusnew) # test that meta and articles still match
  
  # Improve the metadata
  nytmetanew$length <- as.integer(str_extract(nytmetanew$LENGTH, "[0-9]{1,4}"))
  nytmetanew$date <- as.Date(nytmetanew$DATE, "%B %d, %Y")
  nytmetanew$pub <- "NYT"
  nytmetanew$oped <- if_else(str_detect(nytmetanew$SECTION, "Editorial Desk"), 1, 0)
  nytmetanew$blog <- if_else(str_detect(nytmetanew$PUBLICATION, "Blogs"), 1, 0)
  nytmetanew <- nytmetanew %>% dplyr::select(byline = BYLINE, headline = HEADLINE, length, date, pub, oped, blog, subject = SUBJECT, person = PERSON)
  
  # Combining old and new stuff
  
  ## Combine nytcorpuses together 
  nytcorpus <-  c(nytcorpus, nytcorpusnew)
  
  ## Combine metafiles together 
  
  nytmeta <- rbind(nytmeta,nytmetanew)
  save(nytcorpus,nytmeta, file="workspaceR_newspaper/nyt.Rdata")
}

## Move old files into new folder 

files <- list.files("./nytnew")

lapply(files, function(x){
  from <- paste("./nytnew/",files,sep="") #change to your own folder
  to = paste("./nytread/",files,sep="") #change to your own folder
  file.rename(from=from,to=to)
})


####################################################################
# Read in WP articles, using tm.plugin and tm, and clean up ----

# Check if a new files folder exists for WP, if not create one 
ifelse(!dir.exists("./wpnew"), dir.create("./wpnew"), FALSE) #change to your own folder

# List files in the new folder
wpnewfolder <- list.files("./wpnew") #change to your own folder

# If new folder is empty, process files in the original folder for WP - Steps are the same as NYT
if(length(wpnewfolder)==0){
  
  # List article files
  wpfiles <- DirSource(directory="wpread/", pattern=".html", recursive=TRUE)#change to your own folder
  
  # Read article files
  wpcorpus <- lapply(wpfiles$filelist, read_lnfiles) 
  wpcorpus <- do.call(c, wpcorpus)
  
  # In later exploration, found that WP and WSJ use different abbreviation styles, 
  wpcorpus <- tm_map(wpcorpus, content_transformer(function(x) gsub("U.S.", "United States", x)))
  
  ####################################################################
  # Read in WP metadata, using readr, and clean up ----
  
  # List meta files
  wpmetafiles <- DirSource(directory="wpread/", pattern="CSV", recursive=TRUE)#change to your own folder
  length(wpmetafiles) == length(wpfiles) # test that meta and articles match
  
  # Read meta files
  wpmeta <- lapply(wpmetafiles$filelist, read_lnmeta) 
  wpmeta <- do.call(rbind, wpmeta)
  nrow(wpmeta) == length(wpcorpus) # test that meta and articles still match
  
  # Improve the metadata
  wpmeta$length <- as.integer(str_extract(wpmeta$LENGTH, "[0-9]{1,4}"))
  wpmeta$date <- as.Date(wpmeta$DATE, "%B %d, %Y")
  wpmeta$pub <- "WP"
  wpmeta$oped <- if_else(str_detect(wpmeta$SECTION, "Editorial") | str_detect(wpmeta$SECTION, "Outlook"), 1, 0)
  wpmeta$blog <- 0
  wpmeta <- wpmeta %>% dplyr::select(byline = BYLINE, headline = HEADLINE, length, date, pub, oped, blog, subject = SUBJECT, person = PERSON)
  save(wpcorpus,wpmeta, file="workspaceR_newspaper/wp.Rdata") #change to your own folder
} else{
  # Load WP files
  load("workspaceR_newspaper/wp.Rdata")
  # Do the same steps as before for the new WP files
  # List article files
  wpfilesnew <- DirSource(directory="wpnew/", pattern=".html", recursive=TRUE) #change to your own folder
  
  # Read article files
  wpcorpusnew <- lapply(wpfilesnew$filelist, read_lnfiles) 
  wpcorpusnew <- do.call(c, wpcorpusnew)
  
  # In later exploration, found that WP and WSJ use different abbreviation styles, 
  wpcorpusnew <- tm_map(wpcorpusnew, content_transformer(function(x) gsub("U.S.", "United States", x)))
  
  # Do the same steps as before for the new WP meta files 
  
  # List meta files
  wpmetafilesnew <- DirSource(directory="wpnew/", pattern="CSV", recursive=TRUE) #changeto your own folder
  length(wpmetafilesnew) == length(wpfilesnew) # test that meta and articles match
  
  # Read meta files
  wpmetanew <- lapply(wpmetafilesnew$filelist, read_lnmeta) 
  wpmetanew <- do.call(rbind, wpmetanew)
  nrow(wpmetanew) == length(wpcorpusnew) # test that meta and articles still match
  
  # Improve the metadata
  wpmetanew$length <- as.integer(str_extract(wpmetanew$LENGTH, "[0-9]{1,4}"))
  wpmetanew$date <- as.Date(wpmetanew$DATE, "%B %d, %Y")
  wpmetanew$pub <- "WP"
  wpmetanew$oped <- if_else(str_detect(wpmetanew$SECTION, "Editorial") | str_detect(wpmetanew$SECTION, "Outlook"), 1, 0)
  wpmetanew$blog <- 0
  wpmetanew <- wpmetanew %>% dplyr::select(byline = BYLINE, headline = HEADLINE, length, date, pub, oped, blog, subject = SUBJECT, person = PERSON)
  
  # Combining old and new stuff
  ## Combine nytcorpuses together 
  wpcorpus <-  c(wpcorpus, wpcorpusnew)
  
  ## Combine metafiles together 
  
  wpmeta <- rbind(wpmeta,wpmetanew)
  save(wpcorpus,wpmeta, file="workspaceR_newspaper/wp.Rdata") #change to your own folder
}  
  

files <- list.files("./wpnew") #change to your own folder

lapply(files, function(x){
  from <- paste("./wpnew/",files,sep="") #change to your own folder
  to = paste("./wpread/",files,sep="") #change to your own folder
  file.rename(from=from,to=to)
})

# Gives error if there's only 1 file, but moves files anyway

####################################################################
# Read in WSJ articles, using tm.plugin and tm, and clean up ----

# Check if a new files folder exists for WSJ, if not create one 
ifelse(!dir.exists("./wsjnew"), dir.create("./wsjnew"), FALSE) #change to your own folder

# List files in the new folder
wsjnewfolder <- list.files("./wsjnew") #change to your own folder

# If new folder is empty, process files in the original folder for WP - Steps are the same as NYT
if(length(wsjnewfolder)==0){
  # List article files
  wsjfiles <- DirSource(directory="wsjread/", pattern=".htm", recursive=TRUE) #change to your own folder
  # Read article files
  wsjcorpus <- lapply(wsjfiles$filelist, read_fvfiles) 
  wsjcorpus <- do.call(c, wsjcorpus)
  
  # Remove Factiva-added line from WSJ articles (discovered in later exploration): 
  # "License this article from Dow Jones Reprint Service[http://www.djreprints.com/link/DJRFactiva.html?FACTIVA=wjco20170123000044]"
  wsjcorpus <- tm_map(wsjcorpus, content_transformer(function(x) gsub("License this article from Dow Jones Reprint Service\\[[[:print:]]+\\]", "", x)))
  
  # Replace U.S. with United States for later bigram analysis
  wsjcorpus <- tm_map(wsjcorpus, content_transformer(function(x) gsub("U.S.", "United States", x)))

  # Replace "---" with null (causes problems for readability in WSJ "roundup"-style pieces, where items are separated by ---)
  wsjcorpus <- tm_map(wsjcorpus, content_transformer(function(x) gsub("---", "", x))) # change this to regexp?
  save(wsjcorpus, file="workspaceR_newspaper/wsj.Rdata") #change to your own folder
} else{
  load("workspaceR_newspaper/wsj.Rdata") #change to your own folder
  wsjfilesnew <- DirSource(directory="wsjnew/", pattern=".htm", recursive=TRUE) #change to your own folder
  # Read article files
  wsjcorpusnew <- lapply(wsjfilesnew$filelist, read_fvfiles) 
  wsjcorpusnew <- do.call(c, wsjcorpusnew)
  
  # Remove Factiva-added line from WSJ articles (discovered in later exploration): 
  # "License this article from Dow Jones Reprint Service[http://www.djreprints.com/link/DJRFactiva.html?FACTIVA=wjco20170123000044]"
  wsjcorpusnew <- tm_map(wsjcorpusnew, content_transformer(function(x) gsub("License this article from Dow Jones Reprint Service\\[[[:print:]]+\\]", "", x)))
  
  # Replace U.S. with United States for later bigram analysis
  wsjcorpusnew <- tm_map(wsjcorpusnew, content_transformer(function(x) gsub("U.S.", "United States", x)))
  
  # Replace "---" with null (causes problems for readability in WSJ "roundup"-style pieces, where items are separated by ---)
  wsjcorpusnew <- tm_map(wsjcorpusnew, content_transformer(function(x) gsub("---", "", x))) # change this to regexp?
  
  # Combining old and new stuff
  ## Combine nytcorpuses together 
  wsjcorpus <-  c(wsjcorpus, wsjcorpusnew)
  
  save(wsjcorpus, file="workspaceR_newspaper/wsj.Rdata") #change to your own folder
}

files <- list.files("./wsjnew") #change to your own folder

lapply(files, function(x){
  from <- paste("./wsjnew/",files,sep="") #change to your own folder
  to = paste("./wsjread/",files,sep="") #change to your own folder 
  file.rename(from=from,to=to)
})




####################################################################
# Turn NYT into quanteda and assign meta 

qcorpus_nyt <- corpus(nytcorpus) # note corpus is from quanteda, Corpus is from tm
summary(qcorpus_nyt, showmeta=TRUE)

# Assign document variables to corpus
docvars(qcorpus_nyt, "author") <- nytmeta$byline
docvars(qcorpus_nyt, "length") <- nytmeta$length
docvars(qcorpus_nyt, "date") <- nytmeta$date
docvars(qcorpus_nyt, "pub") <- nytmeta$pub
docvars(qcorpus_nyt, "oped") <- nytmeta$oped
docvars(qcorpus_nyt, "blog") <- nytmeta$blog
docvars(qcorpus_nyt, "subject") <- nytmeta$subject

# Remove several empty metadata fields
docvars(qcorpus_nyt, c("description", "language", "intro", "section", "coverage", "company", "stocksymbol", "industry", "type", "wordcount", "rights")) <- NULL
summary(qcorpus_nyt, showmeta=TRUE)


####################################################################
# Turn WP into a quanteda corpus and assign metadata ----

qcorpus_wp <- corpus(wpcorpus) 
summary(qcorpus_wp, showmeta=TRUE)

# Assign document variables to corpus
docvars(qcorpus_wp, "author") <- wpmeta$byline
docvars(qcorpus_wp, "length") <- wpmeta$length
docvars(qcorpus_wp, "date") <- wpmeta$date
docvars(qcorpus_wp, "pub") <- wpmeta$pub
docvars(qcorpus_wp, "oped") <- wpmeta$oped
docvars(qcorpus_wp, "blog") <- wpmeta$blog
docvars(qcorpus_wp, "subject") <- wpmeta$subject

# Remove several empty metadata fields
docvars(qcorpus_wp, c("description", "language", "intro", "section", "coverage", "company", "stocksymbol", "industry", "type", "wordcount", "rights")) <- NULL
summary(qcorpus_wp, showmeta=TRUE)

####################################################################
# Turn WSJ into a quanteda corpus and assign metadata ----


qcorpus_wsj <- corpus(wsjcorpus) # note corpus is from quanteda, Corpus is from tm
summary(qcorpus_wsj, showmeta=TRUE)

# Assign document variables to corpus
docvars(qcorpus_wsj, "length") <- docvars(qcorpus_wsj, "wordcount")
docvars(qcorpus_wsj, "date") <- docvars(qcorpus_wsj, "datetimestamp")
docvars(qcorpus_wsj, "date") <- as.Date(docvars(qcorpus_wsj, "date"))
docvars(qcorpus_wsj, "pub") <- "WSJ"
oped <- c("Commentaries/Opinions", "Columns", "Editorials")
docvars(qcorpus_wsj, "oped") <- if_else(str_detect(docvars(qcorpus_wsj, "subject"), paste(oped, collapse = '|')), 1, 0)
docvars(qcorpus_wsj, "blog") <- 0

# Remove several empty (or unused) metadata fields
docvars(qcorpus_wsj, c("description", "language", "edition", "section", "coverage", "company", "industry", "infocode", "infodesc", "wordcount", "publisher", "rights")) <- NULL
summary(qcorpus_wsj, showmeta=TRUE)

## Save corpuses into Rdata

qcorpus <- qcorpus_nyt + qcorpus_wp + qcorpus_wsj

# If you'd like to view corpuses
#qcorpus
#summary(qcorpus)
qmeta <- docvars(qcorpus)

# add approx first two paragraphs as field in qmeta; probably a better way
# work on finding out a way to add first 4-5 sentences into leadlines section 
qmeta$leadlines <- str_sub(qcorpus$documents$texts, 1,500)

# Save data
save(nytcorpus, nytmeta, qcorpus_nyt, wsjcorpus, qcorpus_wsj, wpcorpus, wpmeta, qcorpus_wp, qcorpus, qmeta, file="workspaceR_newspaper/newspaper.Rdata")
#change to your own folder





