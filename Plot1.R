library(dplyr)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
t1<-merge(NEI,SCC)

#open a png device
png("plot1.png", width=480, height=480)

p1<-summarise(group_by(t1,year),total=sum(Emissions))
plot(p1$year,p1$total,type = 'b',main = "PM2.5 emitted, in tons over time",xlab = "Year",ylab = "Emissions")
dev.off()
