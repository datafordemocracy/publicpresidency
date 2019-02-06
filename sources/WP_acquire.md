# Acquiring Washington Post articles about President Trump
## Beginning November 2018
The Lexis Nexis platform switched to Nexis Uni, and the prior procedure no longer works (it looks like only 50 articles can be downloaded at a time, and not in html format). We switched to Factiva, using the same process as for the WSJ.

We pulled the Washington Post articles from Factiva, licensed through the UVA Libary.

We used the following for the search:
* In Source we selected "The Washington Post",
* in Dates we chose "Enter date range" and entered dates encompassing the fisrt and last day of each month,
* we set Duplicates to "Identical", and
* in the Free Text Search field we used "trump/F100/" to capture articles where the word trump appeared within the first 100 words.

Hit search to return results, and sort the results by date. In Factiva we can only download 100 articles at at time.^1 We
* checked the box at the top of the list to select the first 100 articles shown,
* go to Display Options on the right and choose "Full Article/Report plus Indexing",
* hit the save button, choosing "Article Format",
* right-clicked the resulting results to save in the WSJ project directory,
* then hit "Next 100" and repeated the process (after the first or second save, we had to prove we weren't a robot each time).

### Last update: through 2018-12-31

We pulled the Washington Post articls from LexisNexis Academic, licensed through the UVA Libary.^1

Using the "Advanced Options" for searching
* select Washingtonpost.com in the source field,
* enter the appropriate dates in the date fields (we've been capturing a month's worth of new articles at the end of each month), and
* in Build Your Own Segment Search select "LEAD" and enter Trump as the term. 
Then search!

After articles are returned, turn Duplicate Options to "On - High similarity" and sort the results by date (from oldest to newest).^2

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

1. Accessed via Carnegie Mellon for March 2018-May 2018
2. For October 2017, we sorted in reverse chronological order. The initial sort resulted in html files beginning with articles that were missing a headline; this appeared to cause a problem when reading the file into R, such that the text field was missing for all of these articles. Reversing the sort order appears to have resolved the problem.

### Last update: through 2018-10-31
