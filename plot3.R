## EDA assignment 2

## read in data using readRDS() function

unzip("~/R/coursera/SummarySCC_PM25.rds")
unzip("~/R/coursera/Source_Classification_Code.rds", "rb")

dir()

nei=readRDS("~/R/coursera/SummarySCC_PM25.rds")
scc=readRDS("~/R/coursera/Source_Classification_Code.rds")


head(nei)
head(scc)

## plot 3--different type of sources emission changed over years for Baltimore City


# subset Baltimore City data

bal_data=subset(nei, fips=="24510")

# total emissions by year for Baltimore City

bal_data_total2=aggregate(bal_data$Emissions, by=list(bal_data$year, bal_data$type), FUN=sum)

# assign column names to bal_data_total2

colnames(bal_data_total2)=c("Year", "Type", "Emissions")

# line plot

library(ggplot2)

qplot(Year, Emissions, data=bal_data_total2, col=Type, geom="line",
      xlab="Year", ylab="Total Emissions (in tons)",
      main="Baltimore City PM2.5 Emissions by Year and Type")

# save the plot to png file

dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()

