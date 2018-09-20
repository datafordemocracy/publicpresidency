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

## Presidential documents (presdoc)
* `pres_doc_fun.R`: contains functions used in `acquire_presdoc.R` 
  * `get_presdoc_data` grabs URLs and document info for each doc and adds to dataframe
  * `make_presdoc_data` extract doc id, title, type, and date from strings
  * `scrape_presdoc` downloads documents into directory as .txt files
* `acquire_presdoc.R`: collecs information on each presidential document and downloads text
  * calls `pres_doc_fun.R` as source
  * generates `pres_doc` dataframe with document information and adds documents to presdoc/docs directory
* `process_presdoc.R`: reads in Presidential Documents text files acquired in `acquire_presdoc.R` from presdocs/docs and loads `pres_doc` dataframe created in `acquire_presdoc.R`
  * Generates `presdocuments` dataframe with additional document information and text of document
  * Outputs `presdocuments.csv` from `presdocuments` dataframe to presdocs directory
* `analyze_presdoc.R`: begins to explore presidential documents
  * loads `presdocuemnts` dataframe created in `process_presdoc.R` (or loads `presdocuments.csv` also written out from `process_presdoc.R`)
  * creates a corpus object (`pd_corpus`) and adds extracted features to `presdocuments` dataframe

## Twitter
* `analyze_twitter.R`: reads in tweets (json files) exported from Trump Twitter Archive and saved in trumptwitter directory
  * creates `tw` dataframe with tweets and metadata
  * creates `twcorpus` as corpus object and adds extracted features to `tw` dataframe
