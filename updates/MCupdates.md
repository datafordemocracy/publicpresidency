## 2018-09-14
* Update Twitter and Presidential documents through August 2018
* Update cable news through August 2018
* TODO: Update WP, NYT, wSJ through August 2018

## 2018-08-31
* Update WP, NYT, WSJ through July 2018
* Update Twitter and Presidential documents through July 2018
* Update cable news (cnn, msnbc, fox)
* Read in updated pres docs, tweets, and newspaper

## 2018-06-08
* Harrison updated NYT/WP through May
* Harrison updated MSNBC and CNN through May (error with TSR, only May; look into March/April)
* Updated WSJ through May
* Updated tweets through May
* Selected Buzzfeed, Breitbart as ideologically-leaning digital news sites to work on

## 2018-06-01
* Update presidential documents through April
* Update NYT and WP articles through April
* Update tweets through April
* Update WSJ through April

## 2018-05-24
* Met with Harrison to go over project, walk through some code, generate tasks

## 2018-04-20
* Created and delivered presentation on project: [https://datafordemocracy.github.io/engagingnews/](https://datafordemocracy.github.io/engagingnews/)

## 2018-04-13
* Created and delivered workshop on text analysis in R, using trump tweets as illustration; updated Trump tweets through March
* Created second illustration (didn't use) from presidential documents; updated presidential documents through February

## 2018-03-30
1. Read through Gautam's text.txt; emailed back with the following:

This is a great start! And this text may be a hard case, as it’s dominated by breaking news. By my count there are between 3-6 stories here
 
  * The starting story about the release of Trump’s 2005 1040 form
  * Possibly a transition when the discussion turns to collusion or influence of foreign powers
       ```
       <depthScore>0.6330848396493047</depthScore>
       <text>
       Is our president compromised by a hostile foreign power?  We know his election was affected by hostile foreign power.
       ```
  * Possibly a transition when we switch to Jim Acosta for the White House response
       ```
       <depthScore>0.1677275624925081</depthScore>
       <text>
       CNN Jim Acosta is back with new information from the White House.  Jim? JIM ACOSTA, CNN SENIOR POLITICAL HOUSE     CORRESPONDENT:  That&apos;s right, Anderson.
       ```
  * Possibly a transition when we go back to the panel, after Jim Acosta’s segment
       ```
       <depthScore>0.8021977228616285</depthScore>
       <text>
       However, if MSNBC has them, any number of people could have given it to MSNC
       ```
  * A definite transition when we switch to the healthcare bill
       ```
       <depthScore>0.7677569810464278</depthScore>
       <text>
       We&apos;ll be right back.(COMMERCIAL BREAK)[21:41:12] COOPER:  Well, the White House spent the day embracing parts of          the House Obamacare replacement bill, like in part of the assessment a bit from the Congressional Budget Office that          down playing outright dismissing another namely the estimated 24 million fewer people would be insured under the              legislation by 2026.Now, the reaction has been intense all day.
       ```
  * A definite transition when we switch to discussion the FBI investigation
       ```
       <depthScore>0.617851130197758</depthScore>
       <text>
       FBI coming out publicly.  We&apos;ll tell you about the next.(COMMERCIAL BREAK)[21:50:26] COOPER:  Well, the other            breaking story tonight involves the question of ties between the Trump campaign and Russia.
       ```
So three (trump tax return leak; health care bill; fbi investigation), and possibly more. The topictiling finds lots more (with a threshold of .6), about 25. While it finds at least 5 of these (and the switch to the white house response is a subjective judgement at best), there are plenty of larger depth scores for places that really don’t seem like transitions at all (e.g., the 8 segments with depth scores above .9).
 
I’m wondering (1) how much fine tuning is possible? I noticed the github site recommends 50/topics for alpha, but in the paper they seem to prefer something closer to 0.1. (2) If this is likely to work better on more straight shows and less well on shows with a panel of simultaneous speakers? Or maybe panel shows need a wider window parameter (though I may not be correctly understand just what the window parameter is doing).  What parameters did you use?

2. Read through more story segmentation papers (following citation trail of Riedl and Biemann 2012); added some to the folder (incorporating entity coherence with LDA, distance with LDA, speaker with LDA, word embeddings).

## 2018-03-23
* Updated newspaper analysis with content through February (updated tm.plugin.factiva and added new replacement function to fix regular expression)
* Read more on story/text segementation (articles in storysegmentation folder); focus on topictiling work
* Caliskan talk, and read [Science article](http://science.sciencemag.org/content/sci/356/6334/183.full.pdf) on word embedding association test; read more on word embeddings ([this series](http://ruder.io/word-embeddings-1/) was particularly helpful)
* Read Lowe article on text scaling

## 2018-03-16
* Updated trump tweets through Feb, presidential documents through January, CNN and MSNBC news transcripts through February
* Rewrote Fox news scraper -- webstie changed structure -- using RSelenium for interacting with web browser; updated Fox news transcripts through February
* Looked into [UCLA news archive](https://tvnews.sscnet.ucla.edu/public/), [Red Hen Labs](https://sites.google.com/site/distributedlittleredhen/) work, [newsreader work](http://www.newsreader-project.eu/news-events/news/)

## 2018-03-09
* Updated NYT, WP, WSJ content through February

## 2018-02-16
* Re-read Cohen
* Started marking up news segments in cable news transcripts -- managed to look through one transcript for Anderson Cooper, All In, Erin Burnett, The Five, Hannity, Last Word, Rachel Maddow, The Situation Room; didn't get to The Story -- a first attempt to understand if there are simpler ways of identifying separate "stories"
* Also downloaded (but haven't yet read) several papers on story segmentation in the news; added these to a subfolder in the cablenews folder (called "storysegmentation")

## 2018-02-09
* Revised acquire_presdoc.R, rewriting steps as functions (pres_doc_fun.R), adding documents through December, and saving document metadata (acquire_presdoc.RData). 

## 2018-02-02
* Selected some readings (Cohen 2008, Hall-Jamieson and Capella 2020), and checked out Berry 2014

## 2018-01-26
* Focused on eventnews

## 2018-01-12
* Downloaded WSJ, NYT, WP through December; re-ran scripts to incorporate December articles
* Added structured topic model to topicmodelNews.R (still running)
* Downloaded Trump tweets through December
* Updated acquire_presdoc.R to bring in documents through November (there's a time lag on this source)
* Updated acquire_cnn.R, acquire_msnbc.R, and acquire_fox.R to get transcripts through December (need to think more about the Fox transcripts)

## 2017-12-15
* Focused on eventnews

## 2017-12-08
* Downloaded WSJ through November; downloaded WP articles from January-November, this time capturing subject fields in metadata for later use; downloaded WP articles from January-November as new source
* Updated R script for newspapers to incoporate articles through November, keep new subject fields in metadata, and bring in newly added WP articles

## 2017-12-01
* Downloaded Trump tweets from Jan 20, 2017 to Nov 20, 2017 from [Trump Twitter Archive}(http://www.trumptwitterarchive.com/); added md file to document process
* Added brief R script to read the tweets in (read_twitter.R)
* Wrote script to acquire all documents from the complication of presidential documents (acquire_presdoc.R) from [GPO](https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD); it's crude -- I did it by month with the idea that I'd be updating monthly, but it needs improvement (e.g., write a function, automate the acquisition of the monthly source page, etc.)
* Added folder structure to codeR to organize newspaper, cable, twitter, and presidenetial document code

## 2017-11-24
* Scraped cable news transcripts for (top rated news shows):
  * CNN: Anderson Cooper 360, Erin Burnett Outfront, The Situation Room
  * MSNBC: Rachel Maddow, The Last Word/O'Donnell, All In/Hayes
  * FOX: The Five, Hannity, The Story/MacCallum (Carlson and Baier not available on Fox News site)

## 2017-11-17
* Talked to newsbank about access
* [Top cable news programs](http://www.adweek.com/tvnewser/the-top-cable-news-programs-of-may-2017/330624); scrape the key [Fox transcripts](http://www.foxnews.com/on-air/the-five/transcripts) and [CNN transcripts](http://www.cnn.com/TRANSCRIPTS/) directly?

## 2017-11-10
* Update publicpresidency repo with code through October
* Wrote first post about presidential news to webpage

## 2017-11-03
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
