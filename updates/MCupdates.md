## 2018-01-26

* Estimated structural topic models (with source/party and days since event) on reddit-posted CVille event stories

## 2018-01-12

* Downloaded WSJ, NYT, WP through December; re-ran scripts to incorporate December articles
* Added structured topic model to topicmodelNews.R (still running)
* Downloaded Trump tweets through December
* Updated acquire_presdoc.R to bring in documents through November (there's a time lag on this source)
* Updated acquire_cnn.R, acquire_msnbc.R, and acquire_fox.R to get transcripts through December (need to think more about the Fox transcripts)

## 2017-12-15

* Purchased license to LIWC2015, read through documentation
* Worked on extracting the dictionaries from the jar file (frowned upon by the company) for use in [LIWCalike](https://github.com/kbenoit/LIWCalike) 
* Read Empath article and Moral Foundations chapter

## 2017-12-08

* Downloaded WSJ through November; downloaded WP articles from January-November, this time capturing subject fields in metadata for later use; downloaded WP articles from January-November as new source
* Updated R script for newspapers to incoporate articles through November, keep new subject fields in metadata, and bring in newly added WP articles

## 2017-12-01

* Downloaded Trump tweets from Jan 20, 2017 to Nov 20, 2017 from [Trump Twitter Archive}(http://www.trumptwitterarchive.com/); added md file to document process
* Added brief R script to read the tweets in (read_twitter.R)
* Wrote script to acquire all documents from the complication of presidential documents (acquire_presdoc.R) from [GPO](https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD); it's crude -- I did it by month with the idea that I'd be updating monthly, but it needs improvement (e.g., write a function, automate the acquisition of the monthly source page, etc.)
* Added folder structure to codeR to organize newspaper, cable, twitter, and presidenetial document code

## 2017-11-24
Scraped cable news transcripts for (top rated news shows):
* CNN: Anderson Cooper 360, Erin Burnett Outfront, The Situation Room
* MSNBC: Rachel Maddow, The Last Word/O'Donnell, All In/Hayes
* FOX: The Five, Hannity, The Story/MacCallum (Carlson and Baier not available on Fox News site)

## 2017-11-17

* Got Gautam's script working with Python 3
* Talked to newsbank about access
* [Top cable news programs](http://www.adweek.com/tvnewser/the-top-cable-news-programs-of-may-2017/330624); scrape the key [Fox transcripts](http://www.foxnews.com/on-air/the-five/transcripts) and [CNN transcripts](http://www.cnn.com/TRANSCRIPTS/) directly?

## 2017-11-10

* Review, play with Gautam's script
* Update publicpresidency repo with code through October
* Wrote first post about presidential news to webpage

## 2017-11-03

* Create repo - eventnews - for partisan news project
* Add/update readme, poke around on reddit, add resources_tasks 
* Download October articles from NYT and from WSJ
* Update news scripts to bring in October articles

## 2017-10-27

* Update topicmodelNews.R: [change ggjoy to ggridges](http://serialmentor.com/blog/2017/9/15/goodbye-joyplots), add topics to qmeta2
* Ran moral foundations script on newspaperTopicModel.RData
* Exploration of qmeta2

## 2017-10-20

* Started bibliography of relevant literature
* Updated GitHub with ideas to date
* Revised lab/project description and posted

## 2017-10-13

* Fixed code to work with updated quanteda package; gave up on bigrams/textstat_collocations for the moment
* Added oped as article variable
* Updated article downloads, made more systematic
* Read Pew report Alicia sent: [Covering President Trump in a Polarized Media Environment](http://www.journalism.org/2017/10/02/covering-president-trump-in-a-polarized-media-environment/)

## 2017-10-06

* Downloaded September news articles
* Talked with NewsBank about data mining license

## 2017-09-29

* Started named entity extraction; required updating Python and installing SpaCy

## 2017-09-22

* Updated debate analysis code for word frequency, key words in context; wrote post and published to blog
* Updated debate analysis code for structural topic model; wrote post and published to blog

## 2017-09-15

* Started working with blogdown in R to create datafordemocracy.github.io page
* Updated debate analysis code for tone and affect; wrote post and published to blog
* Updated debate analysis code for readability; wrote post and publlished to blog

## 2017-09-08

* Loaded R scripts to GitHub
* Loaded news articles to Box
* Downloaded August news articles
* Re-ran all analysis so for Jan-Aug
