#setting working directory

setwd("C:\Users\MOLAP\Desktop\Project Files\x17168198 
- DWBI Project\Data Sources")



#loading the required packages

library(gtrendsR)

library(lubridate)



#definig the variables

location<-c("AT","BE","BG","HR","CY","CZ","DK","EE","FI","FR","DE",

"GR","HU","IE","IT","LV","LT","LU","MT","NL","PL","PT","RO","SK",

"SI","ES","SE","GB")

Country<-c("Austria","Belgium","Bulgaria","Croatia","Cyprus",

"Czech Republic","Denmark","Estonia","Finland","France","Germany",

"Greece","Hungary","Ireland","Italy","Latvia","Lithuania",

"Luxembourg","Malta","Netherlands","Poland","Portugal","Romania",

"Slovakia","Slovenia","Spain","Sweden","United Kingdom")

loop<-length(location)

results<-NULL



#getting search results for huawei

for (i in 1:loop) {

  trend_huawei<-gtrends(keyword = "huawei smartphone",
  geo = location[i],
  time = "2015-01-01 2018-11-20",
  gprop = c("web", "news", 
  "images", "froogle", "youtube"),
  category = 0,
  low_search_volume = TRUE)
  
  results<-rbind(results,data.frame(trend_huawei$interest_over_time)
  )

}

rm(trend_huawei,i)



#getting search results for iphone

for (i in 1:loop) {
  
  trend_iphone<-gtrends(keyword = "iphone", geo = location[i],

  time = "2015-01-01 2018-11-20", gprop = c("web", "news",

  "images", "froogle", "youtube"), category = 0,

  low_search_volume = TRUE)

  results<-rbind(results,data.frame(trend_iphone$interest_over_time)
  )

}

rm(trend_iphone,i)



#getting search results for samsung

for (i in 1:loop) {

  trend_samsung<-gtrends(keyword = "samsung smartphone", geo = location[i],
  time = "2015-01-01 2018-11-20",
  gprop = c("web", "news",
  "images", "froogle", "youtube"),
  category = 0,
  low_search_volume = TRUE)
  
  results<-rbind(results,data.frame(trend_samsung$interest_over_time)
  )

}

rm(trend_samsung,loop,i)



#renaming the columns

names(results)[2]<-'Hits'
names(results)[4]<-'location'



#extracting year, month and quarter from date field

results$date<-as.Date(results$date)

results$Year<-year(results$date)

results$Quarter<-quarter(results$date)

results$date<-NULL



#sorting the dataframe

results<-results[c(6,7,3,2,1,4,5)]



#removing some columns

results[8]<-NULL
results[8]<-NULL



#adding country column

test_df<-data.frame(location,Country)

results<-merge(results,test_df,by = "location")

rm(test_df,Country,location)

results$location<-NULL



#adding company column and changing into character type

keyword<-c("huawei smartphone","iphone","samsung smartphone")

Company<-c("Huawei","Apple","Samsung")

test_company<-data.frame(keyword,Company)

results<-merge(results,test_company,by="keyword")

rm(test_company)
results$keyword<-NULL

results$Company<-as.character(results$Company)



#modifying some coloumns

results$Quarter<-paste('Q',results$Quarter)

results$Quarter<-gsub(" ","",results$Quarter)



#sorting the columns order

results<-results[c(1,2,6,7,3)]



#aggregating the data frame

results<-aggregate(results,by=list(results$Year,
results$Quarter,results$Country,results$Company),FUN = 'mean')



#getting the final form

results$Year<-NULL

results$Quarter<-NULL

results$Country<-NULL

results$Company<-NULL

names(results)<-c("Year","Quarter","Country","Company","Hits")

results$Country<-as.character(results$Country)

results$Hits<-round(results$Hits,digits = 0)



#creating the linking keys to other data sources

results$Key_Statista<-paste(results$Year,results$Quarter,
results$Company,sep = '_')

results$Key_Eurostat<-paste(results$Year,results$Country,sep = '_')



#writing to a csv

write.csv(results,"Google Trends.csv",row.names = FALSE)



#removing leftover variables

rm(Company,keyword,Month,test_monthname,results)