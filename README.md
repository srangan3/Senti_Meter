# Senti_Meter

A) Webscraping--<br />
Selenium codes are posted in the folder "Scraping". Note the following--<br />
1) If scraping 1000 tweets or more, run the script "Twitter_Spider.py"<br />

2) If there are less than 1000 tweets, scrape all available tweets using "Twitter_Spider_Less.py"<br />

B) Postprocessing--<br />
1) Sentiment Analysis for one person/state--Run the file "Sentiment_One_State.R". This program will perform a sentiment analysis of all tweets pertaining to one individual. <br />

2) Sentiment Analysis for all states--Run the file "Sentiment_Loop_All_States.R". This program will perform a sentiment analysis of all tweets pertaining to all individuals. It will return a csv file summarizing the sentiment score for all 50 states.  <br />

3) Data Visualization--run the script "Sentiment_Data_Vis.R" to generate visualizations--<br />
#A) sentiment visualization on US map <br />
#B) mean sentiment on US map <br />
#C) standard deviation of sentiment  on US map <br />
#D) Republican Governors versus Democratic Governors box plot <br />
#E) Check for normality <br />
#F) Male versus Female Governors box plot <br />
#G) State performance bar chart <br />
#H) Governor performance bar chart <br />
#I) Governor tweets bar chart <br />
#J) States tweets bar chart <br />
#K) Age versus Score Governors <br />
#L) Top ten and bottom ten Governors <br />
#M) Senti-Meter <br />
