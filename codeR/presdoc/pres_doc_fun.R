###################################################################################
# PUBLIC PRESIDENCY PROJECT
# Acquire text files and metadata for compilation of presidential documents 
# Run once a month, to acquire data from prior month
# 1. get_presdoc_data: create data frame links to scrape, document info
# 2. make_presdoc_data: extract doc id, title, type, and date from newpresoc
# 3. scrape_presdoc: download the documents
# Michele Claibourn (mclaibourn@virginia.edu)
# February 2018, mpc
# Updated: April 4, 2018 
###################################################################################

# 1. get_presdoc_data: create data frame links to scrape, document info
# arguments: s

get_presdoc_data <- function(s) {
  # get URLs associated with each document
  url <- s %>% 
    html_nodes(".browse-download-links a") %>% 
    html_attr("href")
  url <- url[seq.int(2, length(url), 3)] # grab the .htm urls (every 3rd item in list, beginnign with 2nd)
  # get doc number, title, type, and date
  docinfo <- source_page %>% 
    html_nodes("#browse-drilldown-mask span") %>% 
    html_text()
  doc <- docinfo[seq.int(1, length(docinfo), 2)]
  info <- docinfo[seq.int(2, length(docinfo), 2)]
  #Combine into a data frame
  d <- data.frame(url=url, doc=doc, info=info, stringsAsFactors = FALSE)
}


# 2. make_presdoc_data: extract doc id, title, type, and date from newpresoc
# arguments: d

make_presdoc_data <- function(d){
  d <- d %>% 
    mutate(docid = str_split_fixed(doc,  " - ", n = 2)[,1],
           title = str_split_fixed(doc, " - ", n = 2)[,2],
           type = str_split_fixed(info, "\\.", n = 2)[,1],
           date = str_split_fixed(info, "\\.", n = 2)[,2],
           date = as.Date(date, " %A, %B %d, %Y.")) %>% 
    select(url, docid, title, type, date)
}


# 3. scrape_presdoc: download the documents
# arguments: d

scrape_presdoc <- function(d){
  for(i in seq(nrow(d))) {
    text <- read_html(d$url[i]) %>% # load the page
      html_nodes("p") %>% # isolate the text
      html_text() # get the text
    
    filename <- paste0(d$docid[i], ".txt")
    sink(file = filename) %>% # open file to write 
      cat(text, sep="\n")  # put the contents of "text" in the file
    sink() # close the file
  }
}
