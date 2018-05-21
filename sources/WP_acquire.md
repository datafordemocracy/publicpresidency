# Acquiring Washington Post articles about President Trump
We pulled the Washington Post articls from LexisNexis Academic, licensed through the UVA Libary.

Using the "Advanced Options" for searching
* select Washingtonpost.com in the source field,
* enter the appropriate dates in the date fields (we've been capturing a month's worth of new articles at the end of each month), and
* in Build Your Own Segment Search select "LEAD" and enter Trump as the term. 
Then search!

After articles are returned, turn Duplicate Options to "On - High similarity" and sort the results by date (from oldest to newest).^1

We can only save 500 articles at a time. Hit the Save button. In the Download Documents window
* change the format to "html",
* change Document View to "Full w/ Indexing",
* in Document Range choose "Select Items", and
* enter 1-500 (repeating for 501-1000, etc.).

Then hit the Download button and save the resulting file to the WP folder in the project directory.

We repeated this process as second time to retrieve the article metadata. In the Download Documents window
* change the format to "Excel" (really a csv file),
* under Document View, modify the fields to include PERSON and SUBJECT, and
* select the first 500 items in Document Range and save the file to the WP directory (again, iterating as needed to get metadata for all articles).

^1 For October 2017, we sorted in reverse chronological order. The initial sort resulted in html files beginning with articles that were missing a headline; this appeared to cause a problem when reading the file into R, such that the text field was missing for all of these articles. Reversing the sort order appears to have resolved the problem.
