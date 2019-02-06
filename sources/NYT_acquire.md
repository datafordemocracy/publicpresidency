# Acquiring New York Times articles about President Trump
## Beginning November 2018
The Lexis Nexis platform switched to Nexis Uni, and the prior procedure no longer works (it looks like only 50 articles can be downloaded at a time, and not in html format). We switched to Factiva, using the same process as for the WSJ

We pulled the New York Times articles from Factiva, licensed through the UVA Libary.

We used the following for the search:
* In Source we selected "The New York Times",
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

## January 2017 through October 2018
We pulled the New York Times articls from LexisNexis Academic, licensed through the UVA Libary.^1

Using the "Advanced Options" for searching
* select The New York Times in the source field,
* enter the appropriate dates in the date fields (we've been capturing a month's worth of new articles at the end of each month), and
* in Build Your Own Segment Search, select "LEAD" and enter Trump as the term. 
Then search!

After articles are returned, turn Duplicate Options to "On - High similarity" and sort the results by date (from oldest to newest).^2

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
2. April 2018 threw errors when reading in due to a April 9 article ("Teaching Activities for: 'Trump Vows Big Price" for Syria Attack"), the text of which said it could not be formatted for output by LN; we deleted the record from the html and csv files.

### Last update: through 2018-10-31

Note: if errors are encountered when reading into R, look for a format delivery message (e.g., format prevented delivery of article) and delete that record (in both html and csv)
