rm(list=ls())
setwd('--Set path--') # set the right path
cat('\014')

library(dplyr)
library(googleVis)
library(ggplot2)
library(car)

# Score Analysis
score_analysis <- read.csv('mean_senti.csv')
head(score_analysis)

#A) sentiment visualization on US map
# red and blue states
red_blue_governor <- gvisGeoChart(score_analysis, "State", "Party",
                            options=list(region="US", 
                                         displayMode="regions", 
                                         resolution="provinces",
                                         colors="['blue','black','red']",
                                         width=600, height=400))
plot(red_blue_governor)


#B) mean sentiment on US map
mean_governor <- gvisGeoChart(score_analysis, "State", "Mean_Sentiment_Score",
                              options=list(region="US", 
                                           displayMode="regions", 
                                           resolution="provinces",
                                           colors="['#780000', '#e71c1c', '#f9e407','#34f907','#0f5100']",
                                           width=600, height=400))
plot(mean_governor)

#C) standard deviation of sentiment  on US map
sd_governor <- gvisGeoChart(score_analysis, "State", "sd_Sentiment_Score",
                            options=list(region="US", 
                                         displayMode="regions", 
                                         resolution="provinces",
                                         colors="['#0f5100','#34f907','#f9e407','#e71c1c','#780000']",
                                         width=600, height=400))
plot(sd_governor)

#D) Republican Governors versus Democratic Governors box plot
df=score_analysis %>% group_by(.,Party)
g <- ggplot(df, aes(x=reorder(Party,Mean_Sentiment_Score),y=Mean_Sentiment_Score))
g + geom_boxplot(aes(fill=Party), alpha=0.6)+
  labs(title=sprintf("Box plot",face="bold"),x="Party", y="Mean Sentiment Score")+
                          theme(axis.text=element_text(size=13),legend.text=element_text(size=14),
                         axis.title=element_text(size=14,face="bold"),plot.title = element_text(hjust = 0.5))+
  scale_fill_manual(values=c("blue", "black", "red"))

#E) Check for normality
qqnorm(df$Mean_Sentiment_Score[df$Party=='Republican']) 
qqline(df$Mean_Sentiment_Score[df$Party=='Republican']) 
shapiro.test(df$Mean_Sentiment_Score[df$Party=='Republican'])

# Republican Governors versus Democratic Governors box plot
qqnorm(df$Mean_Sentiment_Score[df$Party=='Democratic']) 
qqline(df$Mean_Sentiment_Score[df$Party=='Democratic']) 
shapiro.test(df$Mean_Sentiment_Score[df$Party=='Democratic'])


#F) Male versus Female Governors box plot
df=score_analysis %>% group_by(.,Gender)
g <- ggplot(df, aes(x=reorder(Gender,Mean_Sentiment_Score),y=Mean_Sentiment_Score))
g + geom_boxplot(aes(fill=Gender), alpha=0.6)+
  labs(title=sprintf("Box plot",face="bold"),x="Gender", y="Mean Sentiment Score")+
  theme(axis.text=element_text(size=13),legend.text=element_text(size=14),plot.title = element_text(hjust = 0.5),
        axis.title=element_text(size=14,face="bold"))+
  scale_fill_manual(values=c("red", "blue"))

#G) State performance bar chart
df=score_analysis %>% group_by(.,State)
g <- ggplot(df, aes(x=reorder(State,Mean_Sentiment_Score),y=Mean_Sentiment_Score))
g + geom_bar(aes(fill=Party), alpha=0.6,stat="identity",position = position_stack(reverse = TRUE))+coord_flip()+
  labs(title=sprintf("Bar plot",face="bold"),x="State", y="Mean Sentiment Score")+
  theme(axis.text=element_text(size=13),legend.text=element_text(size=14),plot.title = element_text(hjust = 0.5),
        axis.title=element_text(size=14,face="bold"))+
  scale_fill_manual(values=c("red", "blue"))+theme(axis.text.x = element_text(vjust = 0.5, hjust=0.5))+
  scale_fill_manual(values=c("blue", "black", "red"))

#H) Governor performance bar chart
df=score_analysis %>% group_by(.,Governor)
g <- ggplot(df, aes(x=reorder(Governor,Mean_Sentiment_Score),y=Mean_Sentiment_Score))
g + geom_bar(aes(fill=Party), alpha=0.6,stat="identity",position = position_stack(reverse = TRUE))+coord_flip()+
  labs(title=sprintf("Bar plot",face="bold"),x="Governor", y="Mean Sentiment Score")+
  theme(axis.text=element_text(size=13),legend.text=element_text(size=14),plot.title = element_text(hjust = 0.5),
        axis.title=element_text(size=14,face="bold"))+
  scale_fill_manual(values=c("red", "blue"))+theme(axis.text.x = element_text(vjust = 0.5, hjust=0.5))+
  scale_fill_manual(values=c("blue", "black", "red"))


#I) Governor tweets bar chart
df=score_analysis %>% group_by(.,Tweets_Scraped)
g <- ggplot(df, aes(x=reorder(Governor, Tweets_Scraped),y=Tweets_Scraped))
g + geom_bar(aes(fill=Party), alpha=0.6,stat="identity",position = position_stack(reverse = TRUE))+coord_flip()+
  labs(title=sprintf("Bar plot",face="bold"),x="Governor", y="Tweets Scraped")+
  theme(axis.text=element_text(size=13),legend.text=element_text(size=14),plot.title = element_text(hjust = 0.5),
        axis.title=element_text(size=14,face="bold"))+
  scale_fill_manual(values=c("red", "blue"))+theme(axis.text.x = element_text(vjust = 0.5, hjust=0.5))+
  scale_fill_manual(values=c("blue", "black", "red"))

#J) States tweets bar chart
df=score_analysis %>% group_by(.,Tweets_Scraped)
g <- ggplot(df, aes(x=reorder(State, Tweets_Scraped),y=Tweets_Scraped))
g + geom_bar(aes(fill=Party), alpha=0.6,stat="identity",position = position_stack(reverse = TRUE))+coord_flip()+
  labs(title=sprintf("Bar plot",face="bold"),x="State", y="Tweets Scraped")+
  theme(axis.text=element_text(size=13),legend.text=element_text(size=14),plot.title = element_text(hjust = 0.5),
        axis.title=element_text(size=14,face="bold"))+
  scale_fill_manual(values=c("red", "blue"))+theme(axis.text.x = element_text(vjust = 0.5, hjust=0.5))+
  scale_fill_manual(values=c("blue", "black", "red"))

#K) Age versus Score Governors
score_analysis1=score_analysis %>% group_by(.,Party,Gender)
g=ggplot(score_analysis1, aes(x=Age, 
                 y=Mean_Sentiment_Score)) 
  g+geom_point(aes(colour = Party, 
                 shape=Gender)) +scale_colour_manual(values=c("blue", "black", "red"))+geom_smooth()+
labs(title=sprintf("Scatter plot",face="bold"),x="Age", y="Mean Sentiment Score")+
  theme(axis.text=element_text(size=14),legend.text=element_text(size=14),plot.title = element_text(hjust = 0.5),axis.title=element_text(size=14,face="bold"))

#L) Top ten and bottom ten Governors
bot_10=score_analysis %>% arrange(.,Mean_Sentiment_Score) %>% head(10)
top_10=score_analysis %>% arrange(.,desc(Mean_Sentiment_Score)) %>% head(10)

#M) Senti-Meter

temp2=rbind(score_analysis %>% arrange(.,desc(Mean_Sentiment_Score)) %>% head(5), score_analysis %>% arrange(.,Mean_Sentiment_Score) %>% head(5))  
Governor_Popularity=temp2 %>% transmute(.,State,Mean_Sentiment_Score)
colnames(Governor_Popularity)=c('State', 'Sentiment')
a=Governor_Popularity$Sentiment
Gauge <-  gvisGauge(Governor_Popularity, 
                    options=list(min=min(a), max=max(a), greenFrom=(2/3)*max(a),
                                 greenTo=max(a), yellowFrom=(1/3)*min(a), yellowTo=(2/3)*max(a),
                                 redFrom=min(a), redTo=(1/3)*min(a), width=500, height=300,vAxes="[{title:'val1'}, {title:'val2'}]"))
plot(Gauge)