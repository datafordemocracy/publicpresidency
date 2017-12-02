# Acquiring Washington Post articles about President Trump
We pulled the Washington Post articls from LexisNexis Academi, licensed through the UVA Libary.

Using the "Advanced Options" for searching, we
* select Washingtonpost.com in the source field,
* enter the appropriate dates in the date fields (we've been capturing a month's worth of new articles at the end of each month), and
* in Build Your Own Segment Search we select "LEAD" and enter Trump as the term. Then search!

After articles are returned, we turned Duplicate Options to "On - High similarity" and sorted the results by date.^1

We could only save 500 articles at a time. Hit the Save button. In the Download Documents window we
* changed the format to "html",
* changed Document View to "Full w/ Indexing",
* in Document Range chose "Select Items", and
* entered 1-500 (repeating for 501-1000, etc.).

Then hit the Download button and saved the resulting file to the WP folder in the project directory.

We repeated this process as second time to retrieve the article metadata. In the Download Documents window, we
* changed the format to "Excel" (really a csv file),
* under Document View, we modified the fields to include PERSON and SUBJECT, and
* selected the first 500 items in Document Range and saved the file to the WP directory (again, iterating as needed to get metadata for all articles).

^1 For October 2017, we sorted in reverse chronological order. The initial sort resulted in html files beginning with articles that were missing a headline; this appeared to cause a problem when reading the file into R, such that the text field was missing for all of these articles. Reversing the sort order appears to have resolved the problem.
