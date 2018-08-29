###################################################################################
# PUBLIC PRESIDENCY PROJECT
# Read in Presidential Documents, acquired in acquire_presdoc.R
# 1. Read in documents, capture document metadata, write metadata and text to file
# 2. Join dataframe to metadata dataframe from acquire_presdoc.R
# 3. Save data and output csv file
# Michele Claibourn (mclaibourn@virginia.edu)
# April 3, 2018, mpc
# Updated: August 29, 2018  (documents through July 31, 2018)
###################################################################################

# devtools::install_github("kbenoit/readtext")
rm(list=ls())
library(quanteda)
library(readtext) 
library(stringr)
library(tidyverse)

setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/presdoc/docs/") # location of txt files

###################################################################################
# 1. Read in documents, capture document metadata, write metadata and text to file
###################################################################################
docfiles <- list.files(pattern="txt") # generate list of presidential document files

# Function to read documents, extract metadata, and write to dataframe
readpresdoc <- function(x){
  doc <- readtext(x) # read in files
  split <- unlist(str_split(doc, "\n")) # split by paragraph, into vector
  admin <- split[2]   
  title <- split[3]   
  date <- split[4]    
  note <- str_subset(split, "NOTE:") 
  note <- ifelse(length(note)==0, NA, note)
  category <- str_subset(split, "Categories:") 
  category <- ifelse(length(category)==0, NA, category) # if empty, set to NA
  location <- str_subset(split, "Locations:")
  location <- ifelse(length(location)==0, NA, location)
  names <- str_subset(split, "Names:")
  names <- ifelse(length(names)==0, NA, names)
  subject <- str_subset(split, "Subjects:")
  subject <- ifelse(length(subject)==0, NA, subject)
  docid <- str_subset(split, "DCPD Number:")
  last1 <- str_which(split, "DONALD J. TRUMP") # document text ends here...
  last2 <- str_which(split, "NOTE:")           # or here...
  last3 <- str_which(split, "Categories:")     # or here...
  last <- ifelse(length(last1)>0, last1, ifelse(length(last2)>0, last2, last3)) # whichever appears first
  text <- str_c(split[6:last-1], collapse = "\n\n") # extract document text/speech
  d <- data.frame(admin = admin, title2 = title, date2 = date, notes = str_replace(note, "NOTE:", ""), 
                  categories = str_replace(category, "Categories:", ""), locations = str_replace(location, "Locations:", ""),
                  names = str_replace(names, "Names:", ""), subjects = str_replace(subject, "Subjects:", ""), 
                  docid = str_replace(docid, "DCPD Number:", ""), text = text, stringsAsFactors = FALSE)
}

presdoctext <- purrr::map_df(docfiles, readpresdoc) 

# some DCPD Numbers don't contain a line break, so weren't split
# the docid field has full content of preceding field (e.g., Subjects)
presdoctext$docid <- str_extract(presdoctext$docid, "DCPD[0-9]+")

# doc 552 still wrong; full docid not available in textfile.
# fill in manually for the moment and come back to this later.
presdoctext$docid[552] <- "DCPD201700609"


###################################################################################
# 2. Join dataframe to metadata dataframe from acquire_presdoc.R
###################################################################################
setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/presdoc")
load("acquire_presdoc.RData")

# make docid in presdocuments match docid in presdoc (and drop admin, url)
presdoctext <- presdoctext %>% select(-admin) %>% 
  mutate(docid = str_replace(docid, "DCPD", "DCPD-"))

presdoc <- presdoc %>% select(-url) %>% 
  mutate(docid = str_trim(docid, side = "both"))

# join selected parts of each
presdocuments <- left_join(presdoctext, presdoc, by ="docid")


###################################################################################
# 3. Save data and write out csv file
###################################################################################
# save data
rm(presdoc, presdoctext)
save.image("process_presdoc.RData")

# write csv file to share
write.csv(presdocuments, file = "presdocuments.csv")
