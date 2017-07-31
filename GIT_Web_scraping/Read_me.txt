A) Webscraping--
Selenium codes are posted in the folder "Scraping". Note the following--
1) If scraping 1000 tweets or more, run the script "Twitter_Spider.py"

2) If there are less than 1000 tweets, scrape all available tweets using "Twitter_Spider_Less.py"

B) Postprocessing--
1) Sentiment Analysis for one person/state--Run the file "Sentiment_One_State.R". This program will perform a sentiment analysis of all tweets pertaining to one individual. 

2) Sentiment Analysis for all states--Run the file "Sentiment_Loop_All_States.R". This program will perform a sentiment analysis of all tweets pertaining to all individuals. It will return a csv file summarizing the sentiment score for all 50 states.  

3) Data Visualization--run the script "Sentiment_Data_Vis.R" to generate visualizations--
#A) sentiment visualization on US map
#B) mean sentiment on US map
#C) standard deviation of sentiment  on US map
#D) Republican Governors versus Democratic Governors box plot
#E) Check for normality
#F) Male versus Female Governors box plot
#G) State performance bar chart
#H) Governor performance bar chart
#I) Governor tweets bar chart
#J) States tweets bar chart
#K) Age versus Score Governors
#L) Top ten and bottom ten Governors
#M) Senti-Meter
     