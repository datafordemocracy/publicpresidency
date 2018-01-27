#####################
# FOX Transcripts
# Michele Claibourn
# Acquire data: Jan 20, 2017 through Nov 16, 2017
# The Five, Hannity, The Story/MacCallum
# Updated through December 31, 2017
#####################

rm(list=ls())
library(dplyr)
library(rvest)
library(tm)
library(stringr)
library(quanteda)


#####################
# The Five
#####################
setwd("~/Box Sync/mpc/dataForDemocracy/cablenews/")

if (!file.exists("five")) {
  dir.create("five")
}
setwd("five") 

# Load the source pages
five <- NULL # create null data set

# for (i in 0:34) { # On initial run: manually searched for pages containing shows from jan 20 on; at that time (mid-November), had to seach through page 34
for (i in 0:4) { # On January run: searched for pages containing November 17 and on; had to search through page 4
    source_page <- read_html(paste0("http://www.foxnews.com/on-air/the-five/transcripts?page=", i, "&Submit=DISPLAY"))
  
  # Get URLs associated with each day's transcript text
  url1 <- source_page %>% 
    html_nodes("h2 a") %>%  
    html_attr("href") 
  head(url1)
  
  five1 <- data.frame(url=url1, stringsAsFactors=FALSE)
  five <- rbind(five, five1) # add next 10 to dataset
}

# Turn into a dataframe and extract date, show segment
five$show <- "theFive"
five$date <- str_extract(five$url, "[0-9]{4}/[0-9]{2}/[0-9]{2}")
five$date <- as.Date(five$date, "%Y/%m/%d")
five$seg <- ifelse(grepl("gutfeld", five$url), "gut", "five")

# # On initial run: Keep only transcripts since January 20, 2017
# five <- five %>% filter(date > as.Date("2017-01-19"))
# On January run: Keep only transcripts since initial download, November 17, 2017 to December 31, 2017
five <- five %>% 
  filter(date > as.Date("2017-11-16") & date < as.Date("2018-01-01"))

# Loop through each link in data.frame (nrow(five)) and 
# a. grab the html (read_html()), isolating node with text
#    in some cases, it's ".article-body", in some it's ".article-text";
# b. extract the text (html_text),
# c. append appropriate party label-year to downloaded file (paste0)
# d. and send output to file (sink/cat)
for(i in seq(nrow(five))) {
  
  if (length(read_html(five$url[i]) %>% html_nodes(".article-body")) >0 ) {
   text <- read_html(five$url[i]) %>% 
             html_nodes(".article-body") %>% 
             html_text() 
  }
   else {
      text <- read_html(five$url[i]) %>% 
        html_nodes(".article-text") %>% 
        html_text()
    }

  filename <- paste0(five$date[i], "-", five$seg[i],".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}


#####################
# Hannity
#####################
setwd("~/Box Sync/mpc/dataForDemocracy/cablenews/")

if (!file.exists("hannity")) {
  dir.create("hannity")
}
setwd("hannity") 

# Load the source pages
hann <- NULL # create null data set

# for (i in 0:19) { # On initial run: manually searched for pages containing shows from jan 20 on; at that time (mid-November), had to seach through page 19
for (i in 0:2) { # On January run: searched for pages containing November 17 and on; had to search through page 2
  source_page <- read_html(paste0("http://www.foxnews.com/on-air/hannity/transcripts?page=", i, "&Submit=DISPLAY"))
  
  # Get URLs associated with each day's transcript text
  url1 <- source_page %>% 
    html_nodes(".title a") %>%  
    html_attr("href") 
  head(url1)
  
  hann1 <- data.frame(url=url1, stringsAsFactors=FALSE)
  hann <- rbind(hann, hann1) # add next 10 to dataset
}

# Turn into a dataframe and extract date, show segment
hann$show <- "hannity"
hann$date <- str_extract(hann$url, "[0-9]{4}/[0-9]{2}/[0-9]{2}")
hann$date <- as.Date(hann$date, "%Y/%m/%d")

# # On initial run: Keep only transcripts since January 20, 2017
# hann <- hann %>% filter(date > as.Date("2017-01-19"))
# On January run: Keep only transcripts since initial download, November 17, 2017 to December 31, 2017
hann <- hann %>% 
  filter(date > as.Date("2017-11-16") & date < as.Date("2018-01-01"))

# Download transcripts as text files 
for(i in seq(nrow(hann))) {
  
  if (length(read_html(hann$url[i]) %>% html_nodes(".article-body")) >0 ) {
    text <- read_html(hann$url[i]) %>% 
      html_nodes(".article-body") %>% 
      html_text() 
  }
  else {
    text <- read_html(hann$url[i]) %>% 
      html_nodes(".article-text") %>% 
      html_text()
  }
  
  filename <- paste0(hann$date[i], ".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}


#####################
# Bret Baier 
# In mid-November, can only get last month so far, 10/16-11/17
# SKIP
#####################
setwd("~/Box Sync/mpc/dataForDemocracy/cablenews/")

if (!file.exists("baier")) {
  dir.create("baier")
}
setwd("baier") 

# Load the source page
source_page <- read_html("http://www.foxnews.com/on-air/special-report-bret-baier/transcripts")
# Get URLs associated with each day's transcript text
url1 <- source_page %>% 
  html_nodes("#block-special-report-transcripts-search-list a") %>%  
  html_attr("href") 
head(url1)

# Turn into a dataframe and extract date, show segment
baier <- data.frame(show="baier", urls=url1, stringsAsFactors=FALSE)
baier$date <- str_extract(baier$urls, "[0-9]{4}/[0-9]{2}/[0-9]{2}")
baier$date <- as.Date(baier$date, "%Y/%m/%d")

# Download transcripts as text files 
for(i in seq(nrow(baier))) {
  text <- read_html(baier$urls[i]) %>% # load the page
    html_nodes(".article-body") %>% # isolate the text
    html_text() # get the text
  
  filename <- paste0(baier$date[i], ".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}


#####################
# The Story
# Show began on May 1
# Need to figure out how to control webpage via script
# or skip
#####################
setwd("~/Box Sync/mpc/dataForDemocracy/cablenews/")

if (!file.exists("theStory")) {
  dir.create("theStory")
}
setwd("theStory") 

# Need to click show more 13 times: .js-load-more a)
# library(RSelenium)
# rD <- rsDriver()
# remDr <- rD$client
# remDr$open()
# remDr$navigate("http://www.foxnews.com/category/shows/the-story/transcript.html")
# webElem <- remDr$findElement(using = 'css selector',".js-load-more a")
# webElem$clickElement()
# remDr$close()

# Brute force it -- just this once
url1 <- c("http://www.foxnews.com/transcript/2017/05/01/rep-kinzinger-do-diplomacy-from-position-strength-anger-over-left-wing-activists-planned-commencement-speech.html", 
          "http://www.foxnews.com/transcript/2017/05/02/gingrich-hillary-clinton-cant-come-to-grips-with-reality.html", 
          "http://www.foxnews.com/transcript/2017/05/03/swalwell-comeys-answer-on-russa-should-be-wake-up-call.html",
          "http://www.foxnews.com/transcript/2017/05/04/rep-scalise-talks-whipping-votes-for-health-care-bill.html",
          "http://www.foxnews.com/transcript/2017/05/05/duffy-offers-advice-for-2018-midterms-talks-fate-ahca.html",
          "http://www.foxnews.com/transcript/2017/05/08/former-trump-staffers-speak-out-on-wh-agenda-sen-graham-cannot-allow-intel-to-be-politicized.html",
          "http://www.foxnews.com/transcript/2017/05/09/napolitano-many-fbi-agents-felt-demeaned-by-comeys-actions.html",
          "http://www.foxnews.com/transcript/2017/05/10/sen-lankford-let-career-prosecutors-finish-russia-probe-turley-white-house-created-credibility-problem.html",
          "http://www.foxnews.com/transcript/2017/05/11/ron-hosko-comey-firing-will-not-change-russia-investigation-lawyer-for-family-dead-penn-state-pledge-speaks-out.html",
          "http://www.foxnews.com/transcript/2017/05/12/henninger-comey-was-brought-down-by-clinton-method.html",
          "http://www.foxnews.com/transcript/2017/05/15/wh-emphatically-denies-report-trump-shared-intel-family-penn-state-hazing-victim-speaks-out.html",
          "http://www.foxnews.com/transcript/2017/05/16/rep-gowdy-need-to-see-entire-reported-comey-memo.html",
          "http://www.foxnews.com/transcript/2017/05/17/rep-desantis-special-counsel-not-necessary-but-may-be-better.html",
          "http://www.foxnews.com/transcript/2017/05/19/rove-wapo-story-overblown-nyt-story-much-bigger.html",
          "http://www.foxnews.com/transcript/2017/05/22/eyewitness-describes-massive-bang-at-ariana-grande-concert.html",
          "http://www.foxnews.com/transcript/2017/05/23/speaker-ryan-trumps-budget-is-keeping-his-promises.html",
          "http://www.foxnews.com/transcript/2017/05/24/rep-mccaul-on-manchester-attack-and-keeping-us-safe.html",
          "http://www.foxnews.com/transcript/2017/05/25/krauthammer-critical-element-missing-from-trump-nato-speech.html",
          "http://www.foxnews.com/transcript/2017/05/26/gen-keane-nato-leaders-not-taking-isis-threat-seriously-karl-rove-fact-checks-cbo-report.html",
          "http://www.foxnews.com/transcript/2017/05/29/fallout-from-trumps-america-first-doctrine-where-is-gop-with-trumps-top-agenda-items.html",
          "http://www.foxnews.com/transcript/2017/05/30/sen-lee-on-surveillance-tax-and-health-reform-new-book.html",
          "http://www.foxnews.com/transcript/2017/05/31/house-committee-issues-subpoenas-references-unmasking.html",
          "http://www.foxnews.com/transcript/2017/06/01/thiessen-us-reduced-emissions-faster-without-kyoto-treaty.html",
          "http://www.foxnews.com/transcript/2017/06/02/keane-john-kerry-brokered-lousy-deals-as-secretary-state.html",
          "http://www.foxnews.com/transcript/2017/06/05/rep-chaffetz-worry-comey-will-dodge-questions-epas-pruitt-trump-put-america-first.html",
          "http://www.foxnews.com/transcript/2017/06/06/rep-scalise-weve-all-seen-failures-obamacare.html",
          "http://www.foxnews.com/transcript/2017/06/07/sen-graham-on-comey-statement-pretty-good-day-for-trump-sec-ryan-zinke-on-trumps-push-to-overhaul-infrastructure.html",
          "http://www.foxnews.com/transcript/2017/06/08/conway-dc-dropped-everything-for-comey-trump-kept-working.html",
          "http://www.foxnews.com/transcript/2017/06/09/krauthammer-trump-faces-cover-up-without-crime.html",
          "http://www.foxnews.com/transcript/2017/06/12/napolitano-not-wise-for-sessions-to-publicly-testify-time-for-congress-to-investigate-lynch.html",
          "http://www.foxnews.com/transcript/2017/06/13/sen-coons-questions-if-sessions-violated-recusal-ken-starr-says-sessions-acquitted-himself-beautifully.html",
          "http://www.foxnews.com/transcript/2017/06/14/desantis-details-scene-scalise-shooting.html",
          "http://www.foxnews.com/transcript/2017/06/15/rep-williams-and-his-aide-share-their-survival-story-rep-martha-mcsally-speaks-out-after-receiving-threats.html",
          "http://www.foxnews.com/transcript/2017/06/16/rep-franks-solve-problems-with-ballots-not-bullets.html",
          "http://www.foxnews.com/transcript/2017/06/19/liberal-media-pile-on-scalise-gop-after-shooting-bossie-vs-harf-on-trump-investigation-confusion.html",
          "http://www.foxnews.com/transcript/2017/06/20/rnc-chair-ronna-romney-mcdaniel-on-georgia-special-election.html",
          "http://www.foxnews.com/transcript/2017/06/21/gowdy-on-jeh-johnson-testimony-loretta-lynch-controversy.html",
          "http://www.foxnews.com/transcript/2017/06/22/sen-cassidy-gop-health-care-bill-would-lower-premiums.html",
          "http://www.foxnews.com/transcript/2017/06/23/assessing-state-media-in-trump-era.html",
          "http://www.foxnews.com/transcript/2017/06/27/gov-scott-on-why-senate-healthcare-bill-needs-to-pass.html",
          "http://www.foxnews.com/transcript/2017/06/28/rand-paul-trump-and-reached-health-care-idea-breakthrough.html",
          "http://www.foxnews.com/transcript/2017/06/29/sen-orrin-hatch-calls-for-civility-on-capitol-hill.html",
          "http://www.foxnews.com/transcript/2017/06/30/rep-mark-meadows-on-separating-repeal-and-replace-bills.html",
          "http://www.foxnews.com/transcript/2017/07/03/obama-seeking-to-undermine-trump-ny-federal-prosecutor-joins-muellers-russia-probe.html",
          "http://www.foxnews.com/transcript/2017/07/04/grading-president-trumps-efforts-to-reform-health-care.html",
          "http://www.foxnews.com/transcript/2017/07/05/brit-hume-north-korea-holds-south-korea-hostage.html",
          "http://www.foxnews.com/transcript/2017/07/06/trump-meets-with-south-korea-and-japan-to-talk-north-korea.html",
          "http://www.foxnews.com/transcript/2017/07/07/krauthammer-explains-part-syria-plan-finds-troubling.html",
          "http://www.foxnews.com/transcript/2017/07/10/is-trump-teams-meeting-with-russian-lawyer-collusion.html",
          "http://www.foxnews.com/transcript/2017/07/11/gowdy-drip-drip-is-undermining-credibility-admin.html",
          "http://www.foxnews.com/transcript/2017/07/12/bill-browder-speaks-out-about-uncovering-russian-corruption.html",
          "http://www.foxnews.com/transcript/2017/07/14/maccallum-who-is-actually-tougher-on-russia.html",
          "http://www.foxnews.com/transcript/2017/07/14/gingrich-slams-idea-trump-jr-meeting-was-russian-set-up.html",
          "http://www.foxnews.com/transcript/2017/07/17/michael-caputo-on-his-house-intel-testimony-russia-hysteria.html",
          "http://www.foxnews.com/transcript/2017/07/18/sen-paul-republican-plan-kept-death-spiral-rep-swalwell-unmasking-scandal-is-false-alarm.html",
          "http://www.foxnews.com/transcript/2017/07/19/deputy-ag-rosenstein-on-firing-comey-and-appointment-mueller.html",
          "http://www.foxnews.com/transcript/2017/07/20/mark-fuhrman-oj-lied-to-parole-board-fix-was-in.html",
          "http://www.foxnews.com/transcript/2017/07/21/new-report-on-russia-drops-as-wh-tries-to-turn-page.html",
          "http://www.foxnews.com/transcript/2017/07/24/turley-muellers-appointment-was-mistake-gingrich-big-mistake-to-move-forward-without-sessions.html",
          "http://www.foxnews.com/transcript/2017/07/25/krauthammer-sessions-is-dead-man-walking.html",
          "http://www.foxnews.com/transcript/2017/07/26/brit-hume-warns-against-reading-trump-like-other-presidents.html",
          "http://www.foxnews.com/transcript/2017/07/27/wasserman-schultzs-primary-opponent-talks-it-aide-scandal.html",
          "http://www.foxnews.com/transcript/2017/07/28/kellyanne-conway-talks-white-house-shakeup-pecking-order.html",
          "http://www.foxnews.com/transcript/2017/07/31/sen-graham-to-president-trump-dont-let-us-quit-on-health-care.html",
          "http://www.foxnews.com/transcript/2017/08/01/karl-rove-optimistic-tax-reform-will-get-done-sen-rubios-message-for-venezuelan-people.html",
          "http://www.foxnews.com/transcript/2017/08/02/kris-kobach-immigration-policy-should-put-economy-first.html",
          "http://www.foxnews.com/transcript/2017/08/07/amb-nikki-haley-sanctions-are-gut-punch-to-north-korea.html",
          "http://www.foxnews.com/transcript/2017/08/08/sen-dan-sullivan-need-to-do-more-on-missile-defense.html",
          "http://www.foxnews.com/transcript/2017/08/09/nkorea-threatens-absolute-force-against-united-states.html",
          "http://www.foxnews.com/transcript/2017/08/10/digging-into-trumps-tough-talk-on-north-korea.html",
          "http://www.foxnews.com/transcript/2017/08/11/reporter-talks-south-koreas-reaction-to-escalated-rhetoric.html",
          "http://www.foxnews.com/transcript/2017/08/14/charlottesville-protester-trumps-words-too-little-too-late.html",
          "http://www.foxnews.com/transcript/2017/08/15/sarah-palin-slams-controversial-down-syndrome-policy.html",
          "http://www.foxnews.com/transcript/2017/08/16/acting-ice-chief-sanctuary-cities-put-politics-above-safety.html",
          "http://www.foxnews.com/transcript/2017/08/17/shaffer-must-study-terrorists-patterns-online.html",
          "http://www.foxnews.com/transcript/2017/08/18/breitbart-london-editor-bannons-pleased-to-be-back.html",
          "http://www.foxnews.com/transcript/2017/08/21/gen-keane-trump-moving-in-right-direction-in-afghanistan.html",
          "http://www.foxnews.com/transcript/2017/08/22/homeland-security-adviser-words-matter-and-walls-matter.html",
          "http://www.foxnews.com/transcript/2017/08/23/removal-confederate-statues-sparks-debate-in-kentucky.html",
          "http://www.foxnews.com/transcript/2017/08/24/turley-dont-remove-monuments-make-additions-to-them.html",
          "http://www.foxnews.com/transcript/2017/08/25/hurricane-harvey-stress-test-for-trump-administration.html",
          "http://www.foxnews.com/transcript/2017/08/28/secretary-zinke-on-texas-america-has-to-stand-together.html",
          "http://www.foxnews.com/transcript/2017/08/29/samaritans-purse-deploys-5-disaster-relief-units-to-texas.html",
          "http://www.foxnews.com/transcript/2017/08/30/brady-on-harvey-relief-now-is-not-time-for-political-debate.html",
          "http://www.foxnews.com/transcript/2017/08/31/texas-firefighter-organized-volunteers-to-save-hundreds.html",
          "http://www.foxnews.com/transcript/2017/09/01/flood-victim-advocates-keep-working-after-office-explodes.html",
          "http://www.foxnews.com/transcript/2017/09/04/texas-lieutenant-governor-on-latest-harvey-recovery-efforts.html",
          "http://www.foxnews.com/transcript/2017/09/06/gov-abbott-harvey-recovery-will-cost-far-more-than-katrina.html",
          "http://www.foxnews.com/transcript/2017/09/07/ryan-trump-wanted-to-clear-decks-focus-on-agenda.html",
          "http://www.foxnews.com/transcript/2017/09/08/gov-scott-to-south-fla-residents-evacuate-before-midnight.html",
          "http://www.foxnews.com/transcript/2017/09/11/american-stranded-in-st-thomas-shares-his-story.html",
          "http://www.foxnews.com/transcript/2017/09/12/fema-official-on-irma-recovery-this-is-massive-effort.html",
          "http://www.foxnews.com/transcript/2017/09/13/sen-graham-spearheading-new-obamacare-repeal-plan.html",
          "http://www.foxnews.com/transcript/2017/09/14/trump-supporters-divided-over-potential-daca-deal.html",
          "http://www.foxnews.com/transcript/2017/09/15/rep-king-trumps-heart-overruled-campaign-promises.html",
          "http://www.foxnews.com/transcript/2017/09/18/sen-paul-cant-be-in-favor-keeping-obamacare-spending.html",
          "http://www.foxnews.com/transcript/2017/09/19/lankford-russia-is-distraction-until-get-it-resolved.html",
          "http://www.foxnews.com/transcript/2017/09/20/keane-trump-putting-us-back-on-world-stage-as-leader.html",
          "http://www.foxnews.com/transcript/2017/09/21/kim-jong-un-calls-trump-deranged-in-provocative-warning.html",
          "http://www.foxnews.com/transcript/2017/09/22/bossie-mccain-solidifies-legacy-supporting-obamacare.html",
          "http://www.foxnews.com/transcript/2017/09/25/luther-strange-roy-moore-make-their-case-to-voters-in-alabama-senate-runoff.html",
          "http://www.foxnews.com/transcript/2017/09/26/exclusive-devos-on-restoring-due-process-rights-on-campus.html",
          "http://www.foxnews.com/transcript/2017/09/27/gingrich-gop-tax-plan-remarkable-achievement.html",
          "http://www.foxnews.com/transcript/2017/09/28/bannon-reportedly-takes-aim-at-gop-primaries-across-us.html",
          "http://www.foxnews.com/transcript/2017/09/29/rep-kinzinger-tom-price-had-become-massive-distraction.html",
          "http://www.foxnews.com/transcript/2017/10/02/big-kenny-on-las-vegas-victims-these-people-are-our-family.html",
          "http://www.foxnews.com/transcript/2017/10/03/scalise-on-vegas-shooting-his-view-second-amendment.html",
          "http://www.foxnews.com/transcript/2017/10/04/steve-scalise-joined-by-lawmakers-who-helped-save-his-life.html",
          "http://www.foxnews.com/transcript/2017/10/05/criminal-behavioral-experts-analyze-las-vegas-massacre.html",
          "http://www.foxnews.com/transcript/2017/10/06/tony-shaffer-reacts-to-uncovered-new-york-city-terror-plot.html",
          "http://www.foxnews.com/transcript/2017/10/09/rep-king-on-political-impact-trump-corker-feud.html",
          "http://www.foxnews.com/transcript/2017/10/10/blackburn-americans-joined-me-in-standing-up-to-twitter.html",
          "http://www.foxnews.com/transcript/2017/10/11/brit-hume-on-trumps-efforts-to-sell-tax-reform-plan.html",
          "http://www.foxnews.com/transcript/2017/10/12/tmz-weinsteins-contract-allowed-for-sexual-harassment.html",
          "http://www.foxnews.com/transcript/2017/10/13/veteran-wounded-by-iranian-bomb-talks-trumps-iran-decision.html",
          "http://www.foxnews.com/transcript/2017/10/16/kellyanne-conway-goal-is-to-move-forward-with-agenda.html",
          "http://www.foxnews.com/transcript/2017/10/17/new-questions-over-comeys-handling-clinton-probe.html",
          "http://www.foxnews.com/transcript/2017/10/18/jack-keane-what-happens-to-syria-after-clean-out-isis.html",
          "http://www.foxnews.com/transcript/2017/10/19/former-pence-press-secretary-talks-future-tax-reform.html",
          "http://www.foxnews.com/transcript/2017/10/20/rep-kinzinger-slams-rep-wilson-talks-niger-ambush-probe.html",
          "http://www.foxnews.com/transcript/2017/10/23/gold-star-wife-president-has-been-caring-to-me-my-family.html",
          "http://www.foxnews.com/transcript/2017/10/24/kelli-ward-need-new-gop-leadership.html",
          "http://www.foxnews.com/transcript/2017/10/25/rep-scalise-on-gop-tax-reform-goals-budget-vote.html",
          "http://www.foxnews.com/transcript/2017/10/26/rep-ron-desantis-on-fbis-uranium-one-informant.html",
          "http://www.foxnews.com/transcript/2017/10/27/conservative-publication-funded-research-on-trump.html",
          "http://www.foxnews.com/transcript/2017/10/30/david-bossie-on-special-counsels-bombshell-indictments.html",
          "http://www.foxnews.com/transcript/2017/10/31/bernard-kerik-nobody-should-be-surprised-by-nyc-attack.html",
          "http://www.foxnews.com/transcript/2017/11/01/rep-peter-king-wrong-to-call-nyc-attacker-lone-wolf.html",
          "http://www.foxnews.com/transcript/2017/11/02/shaffer-on-warning-signs-surrounding-nyc-terror-suspect.html",
          "http://www.foxnews.com/transcript/2017/11/03/lt-col-michael-waltz-devastated-by-bergdahl-sentencing.html",
          "http://www.foxnews.com/transcript/2017/11/06/holcombe-friend-on-losing-8-members-same-family.html",
          "http://www.foxnews.com/transcript/2017/11/07/corey-lewandowski-dont-know-carter-page.html",
          "http://www.foxnews.com/transcript/2017/11/08/marc-short-ed-gillespie-is-not-outsider-like-trump.html",
          "http://www.foxnews.com/transcript/2017/11/09/gary-cohn-white-house-happy-with-progress-on-tax-reform.html",
          "http://www.foxnews.com/transcript/2017/11/10/political-impact-anti-trump-dossier-raises-questions.html",
          "http://www.foxnews.com/transcript/2017/11/13/president-trump-vs-intelligence-community.html",
          "http://www.foxnews.com/transcript/2017/11/15/mick-mulvaney-responds-to-criticisms-gop-tax-plan.html",
          "http://www.foxnews.com/transcript/2017/11/16/rep-steve-scalise-on-resolve-in-congress-to-pass-tax-cuts.html",
          "http://www.foxnews.com/transcript/2017/11/17/former-clinton-aide-blasts-sen-gillibrand-as-hypocrite.html"
          )

# On January run:
url1 <- c("http://www.foxnews.com/transcript/2017/11/17/former-clinton-aide-blasts-sen-gillibrand-as-hypocrite.html",
          "http://www.foxnews.com/transcript/2017/11/20/what-will-it-take-for-economic-boom-in-2018.html",
          "http://www.foxnews.com/transcript/2017/11/21/turley-in-hollywood-and-dc-principle-is-matter-timing.html",
          "http://www.foxnews.com/transcript/2017/11/22/calls-increase-for-rep-john-conyers-resignation.html",
          "http://www.foxnews.com/transcript/2017/11/23/debating-turkey-day-politics.html",
          "http://www.foxnews.com/transcript/2017/11/24/pressure-mounts-to-unmask-capitol-hill-harassers.html",
          "http://www.foxnews.com/transcript/2017/11/27/sen-lankford-want-to-be-able-to-get-to-yes-on-tax-bill.html",
          "http://www.foxnews.com/transcript/2017/11/28/sen-daines-on-what-will-get-him-to-yes-on-tax-reform.html",
          "http://www.foxnews.com/transcript/2017/11/30/marc-thiessen-san-francisco-is-guilty-steinles-murder.html",
          "http://www.foxnews.com/transcript/2017/12/01/rep-steve-king-on-future-kates-law.html",
          "http://www.foxnews.com/transcript/2017/12/04/napolitano-on-bias-at-fbi-obstruction-justice-debate.html",
          "http://www.foxnews.com/transcript/2017/12/05/former-cia-analyst-russia-probe-is-democratic-trap.html",
          "http://www.foxnews.com/transcript/2017/12/06/nikki-haley-on-decision-to-move-us-embassy-to-jerusalem.html",
          "http://www.foxnews.com/transcript/2017/12/07/gohmert-talks-political-bias-allegations-against-fbi.html",
          "http://www.foxnews.com/transcript/2017/12/08/white-house-celebrating-good-economic-news.html",
          "http://www.foxnews.com/transcript/2017/12/11/moore-campaign-spokeswoman-talks-about-final-hours.html",
          "http://www.foxnews.com/transcript/2017/12/12/turley-on-benefits-and-drawbacks-special-counsels.html",
          "http://www.foxnews.com/transcript/2017/12/14/pollster-mueller-and-fbi-face-crisis-in-public-confidence.html",
          "http://www.foxnews.com/transcript/2017/12/15/former-fbi-official-comey-let-politics-creep-into-process.html",
          "http://www.foxnews.com/transcript/2017/12/18/trump-critic-explains-his-support-for-tax-reform.html",
          "http://www.foxnews.com/transcript/2017/12/19/scalise-tax-bill-is-big-step-to-get-economy-moving.html",
          "http://www.foxnews.com/transcript/2017/12/20/speaker-ryan-reflects-on-journey-to-passing-tax-reform.html",
          "http://www.foxnews.com/transcript/2017/12/21/dems-block-mcconnell-effort-to-shield-college-from-tax-hike.html",
          "http://www.foxnews.com/transcript/2017/12/22/story-looks-back-at-2017s-naughtiest-and-nicest.html",
          "http://www.foxnews.com/transcript/2017/12/26/report-nunes-prepping-report-on-corruption-at-fbi.html",
          "http://www.foxnews.com/transcript/2017/12/28/rep-black-on-leaving-key-budget-post-after-fruitful-year.html"
  )

# Turn into a dataframe and extract date, show segment
thestory <- data.frame(show="thestory", urls=url1, stringsAsFactors=FALSE)
thestory$date <- str_extract(thestory$urls, "[0-9]{4}/[0-9]{2}/[0-9]{2}")
thestory$date <- as.Date(thestory$date, "%Y/%m/%d")
# On initial run: thestory$date[53] <- as.Date("2017-07-13") # aired on different day



# Download transcripts as text files 
for(i in seq(nrow(thestory))) {
  
  if (length(read_html(thestory$url[i]) %>% html_nodes(".article-body")) >0 ) {
    text <- read_html(thestory$url[i]) %>% 
      html_nodes(".article-body") %>% 
      html_text() 
  }
  else {
    text <- read_html(thestory$url[i]) %>% 
      html_nodes(".article-text") %>% 
      html_text()
  }
  
  filename <- paste0(thestory$date[i], ".txt")
  sink(file = filename) %>% # open file to write 
    cat(text)  # put the contents of "text" in the file
  sink() # close the file
}