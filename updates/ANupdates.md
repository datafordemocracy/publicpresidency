## 2017-10-20
* Taking Udemy course on Scrapy (can we crawl digital native sites)
* Compared metadata for WSJ vs. NYT
  * WSJ meta includes subject (e.g. health policy, domestic politics, elections, civil unrest, corporate, agriculture)
  * NYT meta does not include similar field
* Link to Pew study for media coverage of early Trump presidency
  * http://www.pewresearch.org/fact-tank/2017/10/04/early-coverage-of-the-trump-presidency-rarely-included-citizen-voices/

## 2017-10-27
* Reviewed Empath
  * https://github.com/Ejhfast/empath-client
  * Empath has high correlation with LIWC (r = 0.8-0.9) depending on training corpus
  * Contains ~200 categories (e.g., dominant personality, government, social media, health, journalism, optimism, violence; can share list)
  * Provides word count and normalized word count per category
  * Living lexicon trained on modern text
  * Uses a VSM to determine similarity of words
  * Categories are determined by ConceptNet
  * Can use it's 200 categories (already generated and crowd sourced for validation), generate your own categories using seed terms (e.g. bleed & punch generate violence), and request Empath to validate them by crowd sourcing
* Consider hierarchical topic modeling?

## 2017-11-03
* Downloaded and reviewed comScore's "Cross Platform Future in Focus for U.S. 2017" report
  * We can use comScore to determine how many people are using the news media sites
  * http://www.comscore.com/Insights/Rankings
* r/politics only allows posts of articles that deal explicitly with American politics, published in last 31 days, must be an original source, and in English
  * People are allowed to comment though.
  * Community decides through upvoting/downvoting (see overall score) what is quality source of information regardless of political ideaology (i.e., you are asked to set your personal bias aside when judging the quality of a source). Those with higher scores indicate higher quality according to this community.
  * Scraping links for Trump and Charlottesville.
  * ICWSM is interested in credibility of online content, how people judge quality, social engagement, group behavior, and digital humanities [they have published articles related to politics in past])
* r/PoliticalDiscussion is reserved for political discussion.
* Scrapy. It is not possible to create a generic scraper that can handle multiple websites since every website is structured differently.  We likely need to select one from each side.
