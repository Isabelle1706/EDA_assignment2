## EDA assignment 2

## read in data using readRDS() function

unzip("~/R/coursera/SummarySCC_PM25.rds")
unzip("~/R/coursera/Source_Classification_Code.rds", "rb")

dir()

nei=readRDS("~/R/coursera/SummarySCC_PM25.rds")
scc=readRDS("~/R/coursera/Source_Classification_Code.rds")


head(nei)
head(scc)

## plot 2--total emissions decreased for Baltimore City, Maryland (fips="24510")

# subset Baltimore City data

bal_data=subset(nei, fips=="24510")

# total emissions by year for Baltimore City

bal_data_total=aggregate(bal_data$Emissions, by=list(bal_data$year), FUN=sum)

# assign column names to bal_data_total

colnames(bal_data_total)=c("Year", "Emissions")

# line plot

plot(bal_data_total, type="l", xlab="Year", ylab="Total Emissions by Year (in tons)",
     main="Baltimore City PM2.5 Emssions by Year", col="blue")

# save the line plot to png file

dev.copy(png, file="plot2.png", height=480, width=480)
dev.off()
