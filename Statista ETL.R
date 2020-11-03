#setting working directory

setwd("C:\Users\MOLAP\Desktop\Project Files\x17168198 - 
DWBI Project\Data Sources")



#loading xlsx package

library(xlsx)



#reading the .xlsx file

statista_raw<-read.xlsx("Quarterly Smartphone shipment share in 
Europe - Statista.xlsx",2,"Data",NULL,5,19,NULL,TRUE,TRUE)



#adding one column

QuarterYear<-c("Q1'2015","Q2'2015","Q3'2015","Q4'2015","Q1'2016",
"Q2'2016","Q3'2016","Q4'2016","Q1'2017","Q2'2017","Q3'2017",
"Q4'2017","Q1'2018","Q2'2018")

statista_raw<-cbind(statista_raw,QuarterYear)



#removing some columns

statista_raw$NA..1<-NULL

statista_raw$NA.<-NULL



#reordering the columns

statista_raw<-statista_raw[c(12,1,2,3,4,5,6,7,8,9,10,11)]



#renaming some columns

names(statista_raw)[8]<-"TCL"
names(statista_raw)[10]<-"Nokia"



#separating QuarterYear coulmn into Quarter and Year

statisa_temp<-tidyr::separate(statista_raw,QuarterYear,
c("Quarter","Year"),sep="'")

rm(statista_raw)



#changing columns into rows

statista_final<-reshape::melt(statisa_temp,id=c("Quarter","Year"))
rm(statisa_temp)



#renaming some columns

names(statista_final)[3]<-"Company"
names(statista_final)[4]<-"Shipment Share"



#changing some values in the data frame

statista_final$`Shipment Share`<-gsub('-',0,statista_final$`Shipment Share`)



#changing the Shipment share into %

statista_final$`Shipment Share`<-as.numeric(statista_final$`Shipment Share`)

new<- statista_final$`Shipment Share`/100

statista_final<- cbind(statista_final,new)

statista_final$`Shipment Share`<-NULL

names(statista_final)[4]<-'Shipment Share'



#creating a composite key

statista_final$Key_Statista<-paste(statista_final$Year,
statista_final$Quarter,statista_final$Company,sep = '_')



#saving data frame into a .csv file

write.csv(statista_final,file = "Quarterly Smartphone shipment 
share in Europe - Statista.csv",row.names = FALSE)



#removing all leftover objects
rm(new,QuarterYear,statista_final)

