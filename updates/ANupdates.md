## 2017-10-20
* Taking Udemy course on Scrapy
  * Building a spider that will crawl digital native sites will likely be an involved task
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
