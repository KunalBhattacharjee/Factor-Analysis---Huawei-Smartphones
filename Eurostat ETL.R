#setting working directory

setwd("C:/Users/MOLAP/Desktop/Project Files/x17168198
- DWBI Project/Data Source")



#loading the required packages

require(lubridate)

require(eurostat)



#extracting the file

file<-get_eurostat("tin00083",type = 'label')



#selecting specific category

europa_raw<-subset(file,file$ind_type=='All Individuals')



#removing excess columns

europa_raw$indic_is<-NULL

europa_raw$ind_type<-NULL

europa_raw$unit<-NULL



#changing the column names and type

names(europa_raw)<-c("Country","Year","Usage")

europa_raw$Country<-as.character(europa_raw$Country)



#renaming some values in Country column

europa_raw$Country[europa_raw$Country=="European Union 
(current composition)"]<-"EU"

europa_raw$Country[europa_raw$Country=="Czechia"]<-"Czech Republic"

europa_raw$Country[europa_raw$Country=="Germany 
(until 1990 former territory of the FRG)"]<-"Germany"



#removing excess rows

europa_temp<-data.frame("Country"=c("Austria","Belgium","Bulgaria",

"Croatia","Cyprus","Czech Republic","Denmark","Estonia","Finland",
"France",
"Germany","Greece","Hungary","Ireland","Italy",
"Latvia",
"Lithuania","Luxembourg","Malta","Netherlands",
"Poland","Portugal",
"Romania","Slovakia","Slovenia",
"Spain","Sweden","United Kingdom","EU"))

europa_final<-merge(europa_raw,europa_temp,by="Country")

rm(europa_raw,europa_temp,file)



#extracting year from date

europa_final$Year<-year(europa_final$Year)



#replacing some NA values with 0

europa_final$Usage[is.na(europa_final$Usage)]<-0



#chaning usage into %

europa_final$Usage<-europa_final$Usage/100



#creating a composite key

europa_final$Key_Eurostat<-paste(europa_final$Year,
europa_final$Country,sep = '_')



#sorting the dataframe on the basis of Year column

europa<-europa_final[order(europa_final$Year),]



#writing back into csv

write.csv(europa,file = "Country Wise Yearly % of 
individuals using internet on mobile in Europe - Eurostat.csv",
row.names = FALSE)



#removing leftover objects

rm(europa_final,europa)