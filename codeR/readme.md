# What's here?

## Cable news (cablenews)
* `acquire_cnn.R`: scrapes transcripts of Anderson Cooper, Erin Burnnett, Wolf Blitzer/Situation Room using `rvest`
  * Generates directories ac360, ebo, and tsr containing .txt files with each day's show transcripts
* `acquire_fox.R` (superseded): scrapes transcripts of The Five, Hannity, The Story for 2017 using `rvest`; webpages were updated in 2018 so this script no longer worked.
  * Generates directories five, hannity, theStory containing .txt files with each day's show transcripts
* `acquire_fox_selenium.R`: scrapes transcripts of The Five, Hannity, The Story/MacCallum using `rselenium`
  * Generates adds to existing directories five, hannity, theSotry 
* `acquire_msnbc.R`: scrapes transcripts of Rachel Maddow, Last Word, All In using `rvest`
  * Generates directories maddow, lastword, allin containing .tx files of each day's show transcript

## Newspaper (newspaper)
* `readNews.R`: reads in newspaper text files and metadatafiles acquired from Lexis-Nexis and Factiva and stored in newspaper/nyt2, wp, and wsj directories
  * calls `readFactivaHTML3.R` as source
  * generates several corpus objects -- `nytcorpus`, `wpcorpus`, and `wsjcorpus` are `tm` corpus objects, `qcorpus_nyt`, `qcorpus_wsj`, and `qcorpus_wp` or `quanteda` corpus objects, and `qcorpus` is the combined corpus for analysis
  * generates `qmeta` dataframe containing metadata for articles
  * saves everything in `newspaper.RData` image in workspaceR directory
* `readFactivaHTML3.R`: makes small change to `tm.factiva.plugin` code to address errors in reading in Factiva articles (extracted id was not unique), used in `readNews.R`
* `readNewsError.R`: troubleshooting of errors in reading in newspapers -- sorting lexis-nexis news by date before downloading solved one error, `readFactivaHTML3.R` solves the other
* `exploreNews.R`: begins to explore newspaper articles
  * loads `newspaper.RData` image created in `readNews.R`, subsets corpus and metadata to filter out short items, and saves `newspaperExplore.RData` in workspaceR
* `complexityNews.R`: calculates complexity/readability measures on articles and adds to metadata dataframe (`qmeta2`)
  * loads `newspaperExplore.RData` image created in `exploreNews.R`, adds measures, and saves `newspaperComplex.RData` image in workspaceR
* `sentimentNews.R`: calculates multiple sentiment/polarity/affect measures on articles and adds to metadata dataframe (`qmeta2`)
  * loads `newspaperComplex.RData` image created in `complexityNews.R`, adds measures, and saves `newspaperSentiment.RData` image in workspaceR
* `moralFoundation1.R`: calculates moral foundation measures on articles and adds to metadata dataframe (`qmeta2`)
  * loads `newspaperSentiment.RData` image created in `sentimentNews.R`, adds measures, and saves `newspaperMoral.RData` image
* `topicmodelNews.R`: calculates topic probabilities for articles and adds to metadata dataframe (`qmeta2`)
  * loads `newspaperMoral.RData` image created in `moralFoundation1.R`, adds measures, and saves `newspaperTopicModel.RData` image in workspaceR
  * outputs files for dynamic visualization to directory
* `topicmodelEvaluationNews.R`: evaluates range of K topics for topic models
* `stmTopicModelNews.R`: calculates structured topic probabilities (with source and month as covariates) for articles and adds to metadata dataframe (`qmeta2`)
  * loads `newspaperTopicModel.RData` created in `topicmodelNews.R`, adds measures, and saves `newspaperTopicModel2.RData' image in workspaceR
* `namedEntitiesNews.R`: not even close to done.... but intended to extract named entities from articles...

## Presidential documents (presdoc)
* `pres_doc_fun.R`: contains functions used in `acquire_presdoc.R` 
  * `get_presdoc_data` grabs URLs and document info for each doc and adds to dataframe
  * `make_presdoc_data` extract doc id, title, type, and date from strings
  * `scrape_presdoc` downloads documents into directory as .txt files
* `acquire_presdoc.R`: collects information on each presidential document and downloads text
  * calls `pres_doc_fun.R` as source
  * generates `pres_doc` dataframe with document information and saves in `acquire_presdoc.RData` image
  * writes documents as text files to presdoc/docs directory
* `process_presdoc.R`: reads in Presidential Documents text files acquired in `acquire_presdoc.R` from presdocs/docs and loads `acquire_presdoc.RData` image with `pres_doc` dataframe created in `acquire_presdoc.R`
  * Generates `presdocuments` dataframe with additional document information and text of document and saves in `process_presdoc.RData` image
  * Outputs `presdocuments.csv` from `presdocuments` dataframe to presdocs directory
* `analyze_presdoc.R`: begins to explore presidential documents
  * loads `process_presdoc.RData` image with `presdocuemnts` dataframe created in `process_presdoc.R` (or loads `presdocuments.csv` also written out from `process_presdoc.R`)
  * creates a corpus object (`pd_corpus`) and adds extracted features to `presdocuments` dataframe and saves in `presdocdata.Rdata` image

## Twitter
* `analyze_twitter.R`: reads in tweets (json files) exported from Trump Twitter Archive and saved in trumptwitter directory and begins to explore
  * creates `tw` dataframe with tweets and metadata
  * creates `twcorpus` as corpus object and adds extracted features to `tw` dataframe and saves in `trumptwitter.RData` image
