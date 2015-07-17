library(dplyr)

# Download the files if its not there
if(!file.exists("data")) {
  dir.create("data")
  url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(url=url, destfile="data\\exdata-data-NEI_data.zip")
  unzip("data\\exdata-data-NEI_data.zip",exdir = "data")
}

NEI <- readRDS("data\\summarySCC_PM25.rds")

t<-filter(NEI, fips == "24510")
p<-summarise(group_by(t,year),total=sum(Emissions))

#open a png device
png("plot2.png", width=480, height=480)
barplot(p$total,names.arg=p$year,,main = "Baltimore City, Maryland, Yearly PM2.5 emitted, over time",xlab = "Year",ylab = "Emissions(Tons)")
dev.off()
