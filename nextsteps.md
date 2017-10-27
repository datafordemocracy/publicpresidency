# Proposed Next Steps

## Sources

### So far

* Newspaper articles (Michele; New York Times and Wall Street Journal)

### Potential sources to add

* Television news transcripts (e.g., Fox, CNN; looking into NewsBank access)
* Internet news sites (e.g., Politico, Breitbart, or something else); not sure how to acquire for past, but could set up something going forward?)
* Trump twitter feed (e.g., from [Trump Twitter Archive](http://www.trumptwitterarchive.com/))
* Formal presidential statements (e.g., [The Daily Compilation of Presidential Documents](https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD&browsePath=2017&isCollapsed=false&leafLevelBrowse=false&ycord=0); ideally with available metadata like subject codes and named entities)
* News outlet tweets (e.g., the [GWU Libaries collection](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/2FIFLH))

## Features

### So far

* Publication source
* Date
* Title
* Opinion or news item
* Length
* First 500 words
* Readability (or other measures of complexity)
* Polarity or tone (could be improved)
* Other affect (could be improved)
* Topics (output from LDA with k-75; could try structured topic model, something else)

### Potential new features

* Named entities
* Events (in the spirit of [Phoenix, Open Event Data Alliance](http://phoenixdata.org/), but for domestic/presidential)
* Policy issue (via dictionary? [Lexicoder](http://www.lexicoder.com/) has beta policy dictionary, based on [policy agendas project](http://www.comparativeagendas.net/))
* Moral foundations (Jessica, [dictionary here](http://moralfoundations.org/sites/default/files/files/downloads/moral%20foundations%20dictionary.dic))
* Empath in Python (Alicia, need clarification on what this would provide, [article here](https://hci.stanford.edu/publications/2016/ethan/empath-chi-2016.pdf))
* Latent Variable Analysis via Exploratory Graph Analysis (Jessica)

## Research Questions

* Divergence of features (frequency/attention, tone, topic, potential new features, distinguishing words from tf-idf) across sources -- what do we expect based on source? are expectations met? how divided are our info sources?
* Differences in divergence (e.g., frequency/attention, tone, potential new features) across topics or policy areas -- requires more features, but speaks to how some topics/issues may be more contested
* Frames around particular issues (e.g., focusing in on policy or topic, identify and classify dominant frames)
* With named entities/people, construction/representaton of Trump network across sources
* What about slicing articles differently -- e.g., extracting quotes and speakers -- who's quoted, what's the nature of quoted speech based on source/pub/etc.

## Other goals
 
* Help regular people attend to what's being said about Trump's presidency, without having to read lots of news via visual web representations

 

