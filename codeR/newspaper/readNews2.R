###################################################################
# Media Coverage of Trump
# Read, format newspaper articles
# NYT and WP from Lexis-Nexis; WSJ from Factiva
# Created February 1, 2017, Michele Claibourn
# Updated by Aycan Katitas to read only new articles
# Updated by mpc February 6, 2019 to accomodate nyt and wp from factiva
# Updated February 6 to read in through December 2018
####################################################################


####################################################################
# Loading libraries, Setting directories, Creating functions ----

# install.packages("tm")
# install.packages("tm.plugin.lexisnexis")
# install.packages("tm.plugin.factiva")
# install.packages("quanteda")

# To begin, create three folders -- nytread, wpread, wsjread --
#  these include the first set of downloaded articles.
# To save time when updating the corpus with new articles, 
#  the code creates news folders -- nytnew, wpnew, wsjnew --
#  where newly downloaded articles will be kept until added to the corpus.
# Saved R objects will be in a folder workspaceR_newspaper;
#  create this folder at the outset.
####################################################################


# Setup ----
rm(list=ls())
library(tm)
library(xml2) # instead of XML?
library(tm.plugin.factiva)
# library(tm.plugin.lexisnexis)
library(quanteda)
library(tidyverse)
library(rvest)

# Point to path for html files
# change to your own folder
setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/newspaper/")

# Adjust readFactivaHTML function (see readNewsError.R for background)
source("codeR/readFactivaHTML3.R") # change to your own folder
assignInNamespace("readFactivaHTML", readFactivaHTML3, ns="tm.plugin.factiva")

# Function to read factiva files and turn into a corpus
read_fvfiles <- function(x){
  source <- FactivaSource(x)
  Corpus(source)
}


### WALL STREET JOURNAL ###
# Read in WSJ articles, using tm.plugin and tm, and clean up ----
# Check if folder for read articles exists, and create if needed 
ifelse(!dir.exists("./wsjread"), dir.create("./wsjread"), FALSE) #change to your own folder

# List files in the new folder
wsjnewfolder <- list.files("./wsjnew") 

# Read article files
wsjfilesnew <- DirSource(directory="wsjnew/", pattern=".htm", recursive=TRUE) #change to your own folder
wsjcorpusnew <- lapply(wsjfilesnew$filelist, read_fvfiles) 
wsjcorpusnew <- do.call(c, wsjcorpusnew)

# Remove Factiva-added line from WSJ articles (discovered in later exploration): 
# "License this article from Dow Jones Reprint Service[http://www.djreprints.com/link/DJRFactiva.html?FACTIVA=wjco20170123000044]"
wsjcorpusnew <- tm_map(wsjcorpusnew, content_transformer(function(x) gsub("License this article from Dow Jones Reprint Service\\[[[:print:]]+\\]", "", x)))
# Replace U.S. with United States for later bigram analysis
wsjcorpusnew <- tm_map(wsjcorpusnew, content_transformer(function(x) gsub("U.S.", "United States", x)))
# Replace "---" with null (causes problems for readability in WSJ "roundup"-style pieces, where items are separated by ---)
wsjcorpusnew <- tm_map(wsjcorpusnew, content_transformer(function(x) gsub("---", "", x))) # change this to regexp?

# Combining new articles and previously read articles ----
# Load WSJ files
load("workspaceR_newspaper/wsj.Rdata") #change to your own folder
wsjcorpus <-  c(wsjcorpus, wsjcorpusnew)
save(wsjcorpus, file="workspaceR_newspaper/wsj.Rdata") #change to your own folder

# Move old files into new folder 
files <- list.files("./wsjnew") #change to your own folder

lapply(files, function(x){
  from <- paste("./wsjnew/", files,sep="") 
  to = paste("./wsjread/", files,sep="") 
  file.rename(from=from, to=to)
})
# Gives error if there's only 1 file, but moves files anyway


### NEW YORK TIMES ###
# Read in NYT articles, using tm.plugin and tm, and clean up ----
# Check folder for read articles exists, and create if needed
ifelse(!dir.exists("./nytread"), dir.create("./nytread"), FALSE) 

# List article files
nytnewfolder <- list.files("./nytnew") 

# Read article files
nytfilesnew <- DirSource(directory="nytnew/", pattern=".htm", recursive=TRUE) # change directory to your own folder
nytcorpusnew <- lapply(nytfilesnew$filelist, read_fvfiles) 
nytcorpusnew <- do.call(c, nytcorpusnew)

# Remove Factiva-added line from NYT articles (discovered in later exploration): 
# "License this article from Dow Jones Reprint Service[http://www.djreprints.com/link/DJRFactiva.html?FACTIVA=wjco20170123000044]"
nytcorpusnew <- tm_map(nytcorpusnew, content_transformer(function(x) gsub("License this article from Dow Jones Reprint Service\\[[[:print:]]+\\]", "", x)))
# Replace U.S. with United States for later bigram analysis
nytcorpusnew <- tm_map(nytcorpusnew, content_transformer(function(x) gsub("U.S.", "United States", x)))
# Replace "---" with null (causes problems for readability in WSJ "roundup"-style pieces, where items are separated by ---)
nytcorpusnew <- tm_map(nytcorpusnew, content_transformer(function(x) gsub("---", "", x))) # change this to regexp?

# In later exploration, found that NYT and WSJ use different abbreviation styles, 
# altered the most common ones in NYT to match WSJ
# f.b.i; c.i.a; e.p.a (appears mostly with periods (sometimes all caps) in NYT; usually all caps (sometimes with periods) in WSJ
# this code searches the corpus and replaces all appearances of F.B.I. with FBI 
nytcorpusnew <- tm_map(nytcorpusnew, content_transformer(function(x) gsub("F.B.I.", "FBI", x)))
nytcorpusnew <- tm_map(nytcorpusnew, content_transformer(function(x) gsub("C.I.A.", "CIA", x)))
nytcorpusnew <- tm_map(nytcorpusnew, content_transformer(function(x) gsub("E.P.A.", "EPA", x)))
nytcorpusnew <- tm_map(nytcorpusnew, content_transformer(function(x) gsub("U.S.", "United States", x)))
# Need to do something about this text -- appears frequently, and is pulled out as topic in later analysis...
# "Follow The New York Times Opinion section on Facebook and Twitter (@NYTopinion), and sign up for the Opinion Today newsletter."
nytcorpusnew <- tm_map(nytcorpusnew, content_transformer(function(x) gsub("Follow The New York Times Opinion section on Facebook and Twitter (@NYTopinion), and sign up for the Opinion Today newsletter.", "", x)))

# Combining new articles and previously read articles ----
load("workspaceR_newspaper/nyt.Rdata") 
nytcorpus <-  c(nytcorpus, nytcorpusnew)
save(nytcorpus, nytmeta, file="workspaceR_newspaper/nyt.Rdata")

# Move old files into new folder 
files <- list.files("./nytnew")

lapply(files, function(x){
  from <- paste("./nytnew/", files, sep="") 
  to = paste("./nytread/", files, sep="") 
  file.rename(from=from, to=to)
})
# Gives error if there's only 1 file, but moves files anyway


### WASHINGTON POST ###
# Read in WP articles, using tm.plugin and tm, and clean up ----
# Check folder for read articles exists, and create if needed
ifelse(!dir.exists("./wpread"), dir.create("./wpread"), FALSE) 

# List article files
wpnewfolder <- list.files("./wpnew") #change to your own folder

# Read article files
wpfilesnew <- DirSource(directory="wpnew/", pattern=".htm", recursive=TRUE) # change directory to your own folder
wpcorpusnew <- lapply(wpfilesnew$filelist, read_fvfiles) 
wpcorpusnew <- do.call(c, wpcorpusnew)

# In later exploration, found that WP and WSJ use different abbreviation styles, 
wpcorpusnew <- tm_map(wpcorpusnew, content_transformer(function(x) gsub("U.S.", "United States", x)))

# Combining new articles and previously read articles ----
# Load WP files
load("workspaceR_newspaper/wp.Rdata")
wpcorpus <-  c(wpcorpus, wpcorpusnew)
save(wpcorpus,wpmeta, file="workspaceR_newspaper/wp.Rdata") 

# Move old files into new folder 
files <- list.files("./wpnew") #change to your own folder

lapply(files, function(x){
  from <- paste("./wpnew/", files,sep="")  
  to = paste("./wpread/", files,sep="")  
  file.rename(from=from, to=to)
})
# Gives error if there's only 1 file, but moves files anyway


### CREATE CORPORA ###
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


# Turn NYT into quanteda and assign meta ----
qcorpus_nyt <- corpus(nytcorpus) # corpus is from quanteda, Corpus is from tm
summary(qcorpus_nyt, showmeta=TRUE)

# Assign document variables to corpus
docvars(qcorpus_nyt, "length") <- docvars(qcorpus_nyt, "wordcount")
docvars(qcorpus_nyt, "date") <- docvars(qcorpus_nyt, "datetimestamp")
docvars(qcorpus_nyt, "date") <- as.Date(docvars(qcorpus_nyt, "date"))
docvars(qcorpus_nyt, "pub") <- "NYT"
oped <- c("EDITORIALS & OPINIONS")
docvars(qcorpus_nyt, "oped") <- if_else(str_detect(docvars(qcorpus_nyt, "subject"), paste(oped, collapse = '|')), 1, 0)
docvars(qcorpus_nyt, "blog") <- if_else(str_detect(docvars(qcorpus_nyt, "type"), "Web Blog"), 1, 0)

# Remove several empty (or unused) metadata fields
docvars(qcorpus_nyt, c("description", "language", "edition", "section", "coverage", "company", "industry", "infocode", "infodesc", "wordcount", "publisher", "rights", "type")) <- NULL
summary(qcorpus_nyt, showmeta=TRUE)


# Turn WP into a quanteda corpus and assign metadata ----
qcorpus_wp <- corpus(wpcorpus) 
summary(qcorpus_wp, showmeta=TRUE)

# Assign document variables to corpus
docvars(qcorpus_wp, "length") <- docvars(qcorpus_wp, "wordcount")
docvars(qcorpus_wp, "date") <- docvars(qcorpus_wp, "datetimestamp")
docvars(qcorpus_wp, "date") <- as.Date(docvars(qcorpus_wp, "date"))
docvars(qcorpus_wp, "pub") <- "WP"
oped <- c("EDITORIALS & OPINIONS")
docvars(qcorpus_wp, "oped") <- if_else(str_detect(docvars(qcorpus_wp, "subject"), paste(oped, collapse = '|')), 1, 0)
docvars(qcorpus_wp, "blog") <- 0

# Remove several empty (or unused) metadata fields
docvars(qcorpus_wp, c("description", "language", "edition", "section", "coverage", "company", "industry", "infocode", "infodesc", "wordcount", "publisher", "rights", "type")) <- NULL
summary(qcorpus_wp, showmeta=TRUE)


### COMBINE AND SAVE CORPUS ### ----
qcorpus <- qcorpus_nyt + qcorpus_wp + qcorpus_wsj
qmeta <- docvars(qcorpus)

# add approx first two paragraphs as field in qmeta; probably a better way
# work on finding out a way to add first 4-5 sentences into leadlines section 
qmeta$leadlines <- str_sub(qcorpus$documents$texts, 1,500)

# Save data
save(qcorpus, qmeta, file="workspaceR_newspaper/newspaper.Rdata")
# load("workspaceR_newspaper/newspaper.Rdata")
