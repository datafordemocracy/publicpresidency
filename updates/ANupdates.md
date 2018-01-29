## 2018-02-02
* Reviewed LIWC vars
* Reviewed communication journals for fit

## 2018-01-26
* Reviewed journals
* Viz of LIWC vars for reddit data

## 2017-12-14
* Reviewed and summarized LIWC

## 2017-12-08
* Added LIWC and Empath scores on reddit news articles
  * News articles are currently not in utf-8, so there are character encoding issues


## 2017-11-17
* Potential way to scrape digital news sites: https://github.com/codelucas/newspaper
* Is the Bing API helpful? https://azure.microsoft.com/en-us/services/cognitive-services/bing-news-search-api/
* 6% of online users are reddit users http://www.pewinternet.org/2013/07/03/6-of-online-adults-are-reddit-users/

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
* Souneil Park, Minsam Ko, Jungwoo Kim, Ying Liu, and Junehwa Song. 2011. The politics of comments: predicting political orientation of news stories with commenters' sentiment patterns. In Proceedings of the ACM 2011 conference on Computer supported cooperative work (CSCW '11). ACM, New York, NY, USA, 113-122. DOI: https://doi.org/10.1145/1958824.1958842
  * Discusses how political, ideological slant turns journalism into subjective propaganda
    * political views conflict in coverage of contentious political issues
    * this increases polarization, misunderstanding, and significantly impacts elections
  * Difficult for ordinary readers to identify and critically analyze the political views for a large number of news articles
  * Difficult to interpret political orientation from computational analysis of news text and point to two studies that attempted to use text and metadata (references 8 and 12)
  * Built a classifier to classify political orientation of the news articles by commenters’ sentiment patterns towards the articles
    * class = conservative, liberal, or vague
    * predictors for comments = positive, negative, or vague
    * final accuracy = 80%
    * compared to a classifier using tf-idf of news articles themselves (although I don’t see the results of this)
* Jisun An, Daniele Quercia, and Jon Crowcroft. 2013. Fragmented social media: a look into selective exposure to political news. In Proceedings of the 22nd International Conference on World Wide Web (WWW '13 Companion). ACM, New York, NY, USA, 51-52. DOI: http://dx.doi.org/10.1145/2487788.2487807
  * Provide evidence for the hypothesis that people predominantly seek out political information confirming their beliefs and avoid challenging information
  * References two CHI papers (references 4 and 5) that focus on encouraging politically diverse news consumption
  * Building tools to counter partisanship on social media would require the ability to identify partisan users first
  * Used 62k news articles from 37 US news sties shared by 12.5k Facebook users
  * Classified if a news article contained political content using the Alchemy API
    * Given a URL, Alchemy extracts the associated text and returns featured words, the main topic (e.g., Culture/Politics), and a confidence value for the categorization
  * Used www.left-right.us to classify if the 37 news sites are right, center, or left
  * Measured selective exposure of FB users using “net partisan skew” = ln(no of conservative news + 1) – ln(no of liberal news + 1)
  * Users self-defined themselves in a political leaning and took a personality trait survey
  * Used number of FB friends, number of postings, number of likes, age, sex, size of city, and five personality traits to predict political partisianship
  * Claim to be first study to unobtrusively measure selective exposure of online news consumption
  * Found that selective exposure exists, but difficult to predict political partisanship (claim most research has focused on predicting political leaning)

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

## 2017-10-20
* Taking Udemy course on Scrapy (can we crawl digital native sites)
* Compared metadata for WSJ vs. NYT
  * WSJ meta includes subject (e.g. health policy, domestic politics, elections, civil unrest, corporate, agriculture)
  * NYT meta does not include similar field
* Link to Pew study for media coverage of early Trump presidency
  * http://www.pewresearch.org/fact-tank/2017/10/04/early-coverage-of-the-trump-presidency-rarely-included-citizen-voices/
