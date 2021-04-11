# iOS-TwitterTag
A 4th Year Project to query the Twitter API to retrieve user specified Twitter tag.

# Structure
To develop the application there were several core design requirements:
1. Prototype Cells - to display tweets with twitter tags
2. Table View - to store all the different cells queried
3. Image View - to look at the image with zoom funtionalities
4. MentionsTVC - to segue into imageView, hashtags, mentions, urls
5. Refresh & Startup - to get updated tweets from the underlying query
6. Text Highlighting - highlight texts depending on hashtag, url, and mentions

# Prototype Cells
I created a TweetTVCell class to store the data of a singular tweet. The tweet usually contains the Tweeter's screen name and profile image, the tweet text, and the date. Loading the images may take time, as a result a spinner is displayed to animate the loading of the profile image.

# Table View
The table view displays a set of TweetTVCells for each tweet corresponding to the Twitter Tag. 

# MentionsTVC (Table View Controller)
We can select a tweet from the table view above and arrive to the MentionsTVC. This view contains images, hashtags, urls, and mentions. When a user selects any of those items, the app will perform a segue to a different view. Selecting an image opens the ImageVC where users can zoom and explore the image. Selecting the hashtag will query the hashtag and retreive tweets for that hashtag, similarly for mentions. Selecting a URL will open the safari browser and search the given URL.

# Refresh & Startup
The refresh functionality asynchronously calls the TwitterRequest API to fetch the most recent tweets with a specific Twitter Tag. A swipe gesture is also enabled to call the refresh functionality. 
On startup, the refresh functionality is called and loads all the data to the table view.

# Text Highlighting
The tweet text was parsed into hashtags, urls, and mentions. I used NSRange to extract these pieces of information. They were then colored blue, red, and green respectively.
