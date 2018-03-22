## Related projects

### Profit-oriented 
* [Aylien's news api](https://aylien.com/news-api/), also [article](https://techcrunch.com/2016/04/07/aylien-launches-news-analysis-api-powered-by-its-deep-learning-tech/) about it; provides number of stories/day, number of negative and positive stories, and average polarity, wordcloud of stories, category of news (e.g., news, law/politics, finance, travel, sports, etc.) and article length; entities, example sentences, sentiment, related stories for individual stories;
* Alorithmia provides algorithms that could piece something like this together, [for example](https://blog.algorithmia.com/create-your-own-machine-learning-powered-rss/)
* Lexis-Nexis acquired Moreover who provided media monitoring and news aggregation, now [Newsdesk](https://www.lexisnexis.com/en-us/products/newsdesk.page); not sure what it provides
* [AlchemyAPI](https://github.com/AlchemyAPI) acquird by IBM; Alchemy DataNews is now [Watson Discovery News](https://www.ibm.com/watson/services/discovery-news/); given search term, returns top stories with links, entities (topics, people), sentiment (and sentient by source domain), anomalies (days with unusually high mentions), co-mentioned entities (and sentiment of co-mentions). Also IBM's Naturual Language Understanding, given demo text, it provides sentiment, emotions (joy,anger,disgust,sadness,fear), keywords, entities, concepts...

Methods are not open/transparent (proprietary), sources aren't known, content is not free...

### Academic- or public-oriented
* [Vanderbilt TV News archive](https://tvnews.vanderbilt.edu/): newscasts from ABC, CBS, NBC, CNN and Fox News; searchable database of abstracts at story level, but transcripts or story features not provided. Stories are manually abstracted (and segmented?).
* [Internet Archive's TV News archive](https://archive.org/details/tv): search closed-caption transcripts, shows/clips (and transcripts?) divided into 60 second segments; included sources are clearly identified. In February 2018, expressed interest in working with researchers interested in ["non-consumptive analysis of television at scale."](https://blog.archive.org/2018/02/22/expanding-the-television-archive/) -- a possibility?
* [GDELT Summary Television Explorer](https://api.gdeltproject.org/api/v2/summary/summary?DATASET=IATV&TYPE=SUMMARY&STARTDATETIME=&ENDDATETIME=): working with TV news archive. Returns summary of appearance of query term -- volume (based on 15 second blocks, percent of blocks in which search term appears), by station, wordcloud, and top clips. [`newsflash`](https://github.com/hrbrmstr/newsflash) is R package for interacting with IA/GDELT
* [GDELT (broadly)](https://www.gdeltproject.org/): "monitors the world's broadcast, print, and web news from nearly every corner of every country in over 100 languages" -- an expansion of global event data system (started with sample of Summary of World Broadcasts)
* [UCLA communication archive](https://tvnews.sscnet.ucla.edu/public/): can enter search term (and date), returns clips and ability to facet by network.
* [Red Hen Labs](https://sites.google.com/site/distributedlittleredhen/): uses UCLA archive, a little unclear what the focus is.
* [Newsreader](http://www.newsreader-project.eu/news-events/news/) project: also event data focused
