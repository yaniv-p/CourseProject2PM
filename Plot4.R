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
NEI<-merge(NEI,SCC)

#open a png device
png("plot4.png", width=800, height=500)

filter(SCC, grepl(" Coal ",Short.Name))$Short.Name
p<-summarise(group_by(t,year,type),total=sum(Emissions))
qplot(year,total,data=p,facets = . ~ type, geom = c("point","smooth"),method="lm",ylab ="Emissions(Tons)",main = "Baltimore City, Maryland PM2.5 emitted, over time per Type")
dev.off()
