###################################################################################
# PUBLIC PRESIDENCY PROJECT
# Download daily compilations of prsidential documents (each month)
# Calls function in pres_doc_fun.R
# 1. January 2017...
# 20. August 2018
# Michele Claibourn (mclaibourn@virginia.edu)
# Created: July 2017, mpc
# Updated: September 10, 2018
###################################################################################

rm(list=ls())
library(dplyr)
library(rvest)
library(tm)
library(stringr)
library(quanteda)

setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/presdoc")
source("codeR/pres_doc_fun.R")


#################
# 1. January 2017
#################
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F01&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=130")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# This month only - keep transcripts since January 20, 2017 (and with no missing date)
newpres <- newpres %>% filter(date > as.Date("2017-01-19"))

# Download texts to subfolder
setwd("docs/") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- newpres

rm(newpres, source_page)
save.image("acquire_presdoc.RData")


##################
# 2. February 2017
##################
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F02&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=0")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs/") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")


################
# 3. March 2017
################
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F03&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=152")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs/") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")


################
# 4. April 2017
################
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F04&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=3094")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")


################
# 5. May 2017
################
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F05&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=3770")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")


################
# 6. June 2017
################
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F06&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=4549")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")


################
# 7. July 2017
################
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F07&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=4705")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")


################
# 8. August 2017
################
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F08&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=3491")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")


###################
# 9. September 2017
###################
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F09&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=2659")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")


##################
# 10. October 2017
##################
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F10&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=5032")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")


###################
# 11. November 2017
###################
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F11&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=239")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")


###################
# 12. December 2017
###################
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F12&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=2699")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")


##################
# 13. January 2018
##################
load("acquire_presdoc.Rdata")
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2018%2F01&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=121")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")


##################
# 14. Februrary 2018
##################
load("acquire_presdoc.Rdata")
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2018%2F02&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=152")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")


##################
# 15. March 2018
##################
load("acquire_presdoc.Rdata")
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2018%2F03&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=238")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")


##################
# 16. April 2018
##################
load("acquire_presdoc.Rdata")
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2018%2F04&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=238")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")

##################
# 17. May 2018
##################
load("acquire_presdoc.Rdata")
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2018%2F05&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=0")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")


##################
# 18. June 2018
##################
load("acquire_presdoc.Rdata")
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2018%2F06&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=0")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")

##################
# 19. July 2018
##################
load("acquire_presdoc.Rdata")
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2018%2F07&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=72")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")


##################
# 20. August 2018
##################
load("acquire_presdoc.Rdata")
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2018%2F08&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=280")

# Get links, made document data set
newpres <- get_presdoc_data(source_page)
newpres <- make_presdoc_data(newpres)
summary(newpres$date) # check

# Download texts to subfolder
setwd("docs") 
scrape_presdoc(newpres)
setwd("../")

presdoc <- rbind(presdoc, newpres)

rm(newpres, source_page)
save.image("acquire_presdoc.RData")

# NOTES
# via https://www.govinfo.gov/link-docs/ could generate sequence of links; e.g., 
# https://www.govinfo.gov/link/cpd/2017?link-type=html&dcpdnumber=00010 
# on which to increment. But also want info from gpo page -- 
