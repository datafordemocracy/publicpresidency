# Acquring New York Times articles about President Trump
We pulled the New York Times articls from LexisNexis Academi, licensed through the UVA Libary.

Using the "Advanced Options" for searching, we
* select The New York Times in the source field,
* enter the appropriate dates in the date fields (we've been capturing a month's worth of new articles at the end of each month), and
* in Build Your Own Segment Search we select "LEAD" and enter Trump as the term. Then search!

After articles are returned, we turned Duplicate Options to "On - High similarity" and sorted the results by Duplicate.

We could only save 500 articles at a time. Hit the Save button. In the Download Documents window we
* changed the format to "html",
* changed Document View to "Full w/ Indexing",
* in Document Range chose "Select Items", and
* entered 1-500 (repeating for 501-1000, etc.).

Then hit the Download button and saved the resulting file to the NYT folder in the project directory.

We repeated this process as second time to retrieve the article metadata. In the Download Documents window, we
* changed the format to "Excel" (really a csv file),
* accepted the mandatory segments under Document View, and
* selected the first 500 items in Document Range and saved the file to the NYT directory (again, iterating as needed to get metadata for all articles).

And Bob's your uncle!
