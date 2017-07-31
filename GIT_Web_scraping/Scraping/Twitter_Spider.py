from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import csv

driver = webdriver.Chrome()
driver.get("--Enter URL--") # specify the website to be scraped
name_of_governor='Name' # specify name to keep track of things.

csv_file = open('tweets.csv', 'w',newline = '',encoding="utf-8") # create a csv file to write the scraped data
writer = csv.writer(csv_file)
writer.writerow(['name','tweet_content'])

# this loop ensures that the code halts after scraping at least 1000 tweets
while True:
	elemsCount = driver.execute_script("return document.querySelectorAll('.stream-items > li.stream-item').length")
	if elemsCount<=1000: # you can scrape more/less tweets by changing this number
		driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
		time.sleep(4)
		print(elemsCount)
		try:
			WebDriverWait(driver, 20).until(
				lambda x: x.find_element_by_xpath(
					"//*[contains(@class,'stream-items')]/li[contains(@class,'stream-item')]["+str(elemsCount+1)+"]"))
		except:
			break
	else:
		break
		
# Find all the tweets using xpath
tweets = driver.find_elements_by_xpath('//ol[@class="stream-items js-navigable-stream"]/li')        

# Store tweet in tweets  in a dictionary
for tweet in tweets:
	# Initialize an empty dictionary for each tweet
	tweet_dict = {}
	# Use Xpath to locate the content
	tweet_content=tweet.find_element_by_xpath('.//p').text
	tweet_dict['name'] = name_of_governor	
	tweet_dict['tweet_content'] = tweet_content
	writer.writerow(tweet_dict.values())

csv_file.close()
driver.close()