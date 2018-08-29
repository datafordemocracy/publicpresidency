# Acquiring New York Times articles about President Trump
We pulled the New York Times articls from LexisNexis Academic, licensed through the UVA Libary.^1

Using the "Advanced Options" for searching
* select The New York Times in the source field,
* enter the appropriate dates in the date fields (we've been capturing a month's worth of new articles at the end of each month), and
* in Build Your Own Segment Search, select "LEAD" and enter Trump as the term. 
Then search!

After articles are returned, turn Duplicate Options to "On - High similarity" and sort the results by date (from oldest to newest).

We can only save 500 articles at a time. Hit the Save button. In the Download Documents window
* change the format to "html",
* change Document View to "Full w/ Indexing",
* in Document Range choose "Select Items", and
* enter 1-500 (repeating for 501-1000, etc.).

Then hit the Download button and save the resulting file to the NYT folder in the project directory.

We repeated this process a second time to retrieve the article metadata. In the Download Documents window
* change the format to "Excel" (really a csv file),
* update the Document View to add SUBJECT and PERSON, and
* select the first 500 items in Document Range and save the file to the NYT directory (again, iterating as needed to get metadata for all articles).

And Bob's your uncle!

1. Accessed via Carnegie Mellon for March 2018-May 2018

## Last update: through 2018-07-31
