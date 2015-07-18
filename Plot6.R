library(dplyr)

# Download the files if its not there
if(!file.exists("data")) {
  dir.create("data")
  url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(url=url, destfile="data\\exdata-data-NEI_data.zip")
  unzip("data\\exdata-data-NEI_data.zip",exdir = "data")
}

NEI <- readRDS("data\\summarySCC_PM25.rds")
SCC <- readRDS("data\\Source_Classification_Code.rds")

t<-filter(NEI, fips == "24510" | fips == "06037" )
#get the row numbers we have "Onroad" as Data.Category. I Assume when Data.Category is "Onroad" is what neeed to fullfill "motor vehicle sources"
NEI1<-t[t$SCC %in% SCC[SCC$Data.Category=="Onroad","SCC"],]
p<-summarise(group_by(NEI1,year,fips ),total=sum(Emissions))
city_name<-sapply(p$fips,function(x) ifelse(x=="24510","Baltimore City","Los Angeles County"))
p<-cbind(p,city_name)

#open a png device
png("plot6.png", width=650, height=500)
qplot(year,total,data=p,facets = . ~ city_name, geom = c("point","smooth"),ylab ="Emissions(Tons)",main = "Yearly PM2.5 emitted, over time per City")
dev.off()
