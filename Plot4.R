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

#get the row numbers we have "coal" in Short.Name. I Assume searhing Short.Name for "coal" is enogth to detect 'coal combustion-related sources '
i<-grep(pattern = "coal",x = SCC$Short.Name,ignore.case = TRUE )
c<-as.character(SCC$SCC[i]) #conver factor to charcter
NEI1<-NEI[NEI$SCC %in% c,] #build DF with only the wanted rows.
p<-summarise(group_by(NEI1,year),total=sum(Emissions))

#open a png device
png("plot4.png", width=650, height=500)
barplot(p$total/1000,names.arg=p$year,main = "Coal combustion-related, Yearly PM2.5 emitted,over time",xlab = "Year",ylab = "Emissions(Thouesnds of Tons)")
dev.off()
