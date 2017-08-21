## EDA assignment 2

## read in data using readRDS() function

unzip("~/R/coursera/SummarySCC_PM25.rds")
unzip("~/R/coursera/Source_Classification_Code.rds", "rb")

dir()

nei=readRDS("~/R/coursera/SummarySCC_PM25.rds")
scc=readRDS("~/R/coursera/Source_Classification_Code.rds")


head(nei)
head(scc)

## plot 1

##  the total PM2.5 emission from all source for 1999, 2002, 2005, and 2008 using base plotting system

# total emission by yrea

totalbyyear=aggregate(nei$Emissions, by=list(nei$year), FUN=sum)

# assign column names to total.year

colnames(totalbyyear)=c("Year", "Emissions")


# barplot in base plotting system

barplot(totalbyyear$Emissions, names=totalbyyear$Year,
        xlab="Year", ylab="Total Emissions by Year (in tons)",
        main="Total PM2.5 Emissions by Year")
        

# save the bar chart to png format

dev.copy (png, file="plot1.png", height=480, width=480)
dev.off()
