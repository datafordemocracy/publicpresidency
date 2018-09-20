# What's here?

## Cable news (cablenews)
* `acquire_cnn.R`: scrapes transcripts of Anderson Cooper, Erin Burnnett, Wolf Blitzer/Situation Room using `rvest`
  * Generates: directories ac360, ebo, and tsr containing .txt files with each day's show transcripts
* `acquire_fox.R` (superseded): scrapes transcripts of The Five, Hannity, The Story for 2017 using `rvest`; webpages were updated in 2018 so this script no longer worked.
  * Generates: directories five, hannity, theStory containing .txt files with each day's show transcripts
* `acquire_fox_selenium.R`: scrapes transcripts of The Five, Hannity, The Story/MacCallum using `rselenium`
  * Generates: adds to existing directories five, hannity, theSotry 
* `acquire_msnbc.R`: scrapes transcripts of Rachel Maddow, Last Word, All In using `rvest`
  * Generates: directories maddow, lastword, allin containing .tx files of each day's show transcript

## Newspaper (newspaper)

## Presidential documents (presdoc)

## Twitter
