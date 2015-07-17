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

t<-filter(NEI, fips == "24510")
#get the row numbers we have "Onroad" as Data.Category. I Assume when Data.Category is "Onroad" is what neeed to fullfill "motor vehicle sources"
NEI1<-t[t$SCC %in% SCC[SCC$Data.Category=="Onroad","SCC"],]
p<-summarise(group_by(NEI1,year),total=sum(Emissions))

#open a png device
png("plot6.png", width=800, height=500)
barplot(p$total,names.arg=p$year,main = "Baltimore City, Maryland motor vehicle sources related, Yearly PM2.5 emitted,over time",xlab = "Year",ylab = "Emissions(Tons)")
dev.off()
