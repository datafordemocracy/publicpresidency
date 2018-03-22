#######################################
# Michele Claibourn
# October 7, 2017
######################################

# code run at the end of readNews.R to troubleshoot error
library(tidyr)
# 1. LexisNexis news error for NYT
qcorpus_nyt <- corpus(nytcorpus) 
## Error in data.frame(text = texts, stringsAsFactors = FALSE, row.names = names_tmCorpus(x)) : 
##   duplicate row.names: TheNewYo2017032980, TheNewYo2017032981, ...
corpusid <- data.frame(meta(nytcorpus, "id"), stringsAsFactors=FALSE)
corpusid <- gather(corpusid, name, id)

corpushead <- data.frame(meta(nytcorpus, "heading"), stringsAsFactors=FALSE)
corpushead <- gather(corpushead, name2, head)

corpusname <- cbind(corpusid, corpushead)
corpusname <- arrange(corpusname, id)
corpusname$dup <- duplicated(corpusname$id)
# They aren't the same article; why are they given the same rowname?

# Articles from same date were in different html files; the document ID is the 
# source name, date, and a counter -- but the counting began again with each new
# html file. So downloaded the NYT articles again, this time sorting them in
# chronological order, so that articles from the same date are generally in the
# same file. This seems to have resolved the problem of duplicate ID values.


# 2. LexisNexis news error for WP
qcorpus_wp <- corpus(wpcorpus)
## Error in data.frame(text = texts, stringsAsFactors = FALSE, row.names = names_tmCorpus(x)) : 
##     duplicate row.names: TheWashin20170503208, TheWashin20170503209, TheWashin20170503210, The ...
corpusid <- data.frame(meta(wpcorpus, "id"), stringsAsFactors=FALSE)
corpusid <- gather(corpusid, name, id)

corpushead <- data.frame(meta(wpcorpus, "heading"), stringsAsFactors=FALSE)
corpushead <- gather(corpushead, name2, head)

corpusname <- cbind(corpusid, corpushead)
corpusname <- arrange(corpusname, id)
corpusname$dup <- duplicated(corpusname$id)
# duplicates are May 1-3... try downloading just May again...


# 3. Factiva news error
qcorpus_wsj <- corpus(wsjcorpus) 
## Error in data.frame(text = texts, stringsAsFactors = FALSE, row.names = names_tmCorpus(x)) : 
##   duplicate row.names: J-170120-e, J-170120-e
corpusid <- data.frame(meta(wsjcorpus, "id"), stringsAsFactors=FALSE)
corpusid <- gather(corpusid, name, id)

corpushead <- data.frame(meta(wsjcorpus, "heading"), stringsAsFactors=FALSE)
corpushead <- gather(corpushead, name2, head)

corpusname <- cbind(corpusid, corpushead)
corpusname <- arrange(corpusname, id)
corpusname$dup <- duplicated(corpusname$id)
# They aren't the same article; why are they given the same rowname?

# Article IDs were assigned by extracting values from the AN field. The regular 
# expression reading in the document id was reading in too few values, so not unique.
# Added readFactivaHTML2.R (adjusting the regexec slightly, add + at end) and use assignInNameSpace 
# to call the adjusted function.