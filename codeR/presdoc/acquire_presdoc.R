###################################################################################
# PUBLIC PRESIDENCY PROJECT
# Download daily compilations of prsidential documents (each month)
# Calls function in pres_doc_fun.R
# Initial: January 2017...
# Most recent: October 2018
# Michele Claibourn (mclaibourn@virginia.edu)
# Created: July 2017, mpc
# Updated: November 24, 2018
###################################################################################

rm(list=ls())
library(dplyr)
library(rvest)
library(tm)
library(stringr)
library(quanteda)

setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/presdoc")
source("codeR/pres_doc_fun.R")


# # Initoial document scraping ----
# # January 2017
# source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F01&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=130")
# 
# # Get links, made document data set
# newpres <- get_presdoc_data(source_page)
# newpres <- make_presdoc_data(newpres)
# summary(newpres$date) # check
# 
# # This month only - keep transcripts since January 20, 2017 (and with no missing date)
# newpres <- newpres %>% filter(date > as.Date("2017-01-19"))
# 
# # Download texts to subfolder
# setwd("docs/") 
# scrape_presdoc(newpres)
# setwd("../")
# 
# presdoc <- newpres
# 
# rm(newpres, source_page)
# save.image("acquire_presdoc.RData")


# Monthly update, update with source page for current month ----
# October 2018 ----
load("workspaceR_presdoc/acquire_presdoc.Rdata")
source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2018%2F10&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=204")

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
save.image("workspaceR_presdoc/acquire_presdoc.RData")


# Prior months' source page ----
# February 2017: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F02&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=0")
# March 2017: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F03&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=152")
# April 2017: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F04&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=3094")
# May 2017: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F05&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=3770")
# June 2017: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F06&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=4549")
# July 2017: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F07&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=4705")
# August 2017: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F08&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=3491")
# September 2017: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F09&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=2659")
# October 2017: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F10&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=5032")
# November 2017: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F11&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=239")
# December 2017: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017%2F12&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=2699")
# January 2018: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2018%2F01&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=121")
# Februrary 2018: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2018%2F02&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=152")
# March 2018: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2018%2F03&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=238")
# April 2018: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2018%2F04&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=238")
# May 2018: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2018%2F05&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=0")
# June 2018: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2018%2F06&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=0")
# July 2018: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2018%2F07&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=72")
# August 2018: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2018%2F08&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=356")
# September 208: source_page <- read_html("https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2018%2F09&isCollapsed=false&leafLevelBrowse=false&isDocumentResults=true&ycord=273")
# # two documents don't contain "type" so date field is off (put into "type")
# # newpres <- newpres %>% mutate(date2 = ifelse(is.na(date), as.Date(type, " %A, %B %d, %Y"), date))
# # newpres <- newpres %>% mutate(type = ifelse(docid == "DCPD-201800582 ", "Letters and Messages", type),
# #                               type = ifelse(docid == "DCPD-201800585 ", "Communications to Congress", type))
# # newpres <- newpres %>% mutate(date = as.Date(date2, origin = "1970-01-01")) %>% 
# #   select(-date2)


# NOTES
# via https://www.govinfo.gov/link-docs/ could generate sequence of links; e.g., 
# https://www.govinfo.gov/link/cpd/2017?link-type=html&dcpdnumber=00010 
# on which to increment. But also want info from gpo page -- 
