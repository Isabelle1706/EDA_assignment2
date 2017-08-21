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

# assign column names to totalbyyear

colnames(totalbyyear)=c("Year", "Emissions")


# barplot in base plotting system

barplot(totalbyyear$Emissions, names=totalbyyear$Year,
        xlab="Year", ylab="Total Emissions by Year (in tons)",
        main="Total PM2.5 Emissions by Year")
        

# save the bar chart to png format

dev.copy (png, file="plot1.png", height=480, width=480)
dev.off()


## plot 2--total emissions decreased for Baltimore City, Maryland (fips="24510")

# subset Baltimore City data

bal_data=subset(nei, fips=="24510")

# total emissions by year for Baltimore City

bal_data_total=aggregate(bal_data$Emissions, by=list(bal_data$year), FUN=sum)

# assign column names to bal_data_total

colnames(bal_data_total)=c("Year", "Emissions")

# Bar plot

barplot(bal_data_total$Emissions, names=bal_data_total$Year,
     xlab="Year", ylab="Total Emissions by Year (in tons)",
     main="Baltimore City PM2.5 Emssions by Year", col="green")

# save the line plot to png file

dev.copy(png, file="plot2_updated.png", height=480, width=480)
dev.off()


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

## plot 4--emissions from coal combustion-related source changed over years

head(nei)
head(scc)

summary(scc$Data.Category)
summary(scc$Short.Name)
summary(scc$EI.Sector)
summary(scc$SCC.Level.One)

# get all Coal combustion-related source from scc

coalmatches=grepl("Coal", scc$Short.Name, ignore.case=T)

scc1=scc[coalmatches,]

# merge nei and scc1

merge_data=merge(nei, scc1, by="SCC")

coal_total_year=aggregate(Emissions~year, merge_data, sum)

# plot

g=ggplot(coal_total_year, aes(factor(year), Emissions))

g=g+geom_bar(stat="identity", fill="#FF6666") +

  xlab("Year") +
  ylab("Total Emissions (in tons)") +
  ggtitle ("Total PM2.5 Emissions from Coal-related Source by Year")

print(g)

# save the plot to png file

dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()


## plot 5-- Emissions from motor vehicle source in Baltimore City changed over time


summary(scc$EI.Sector)

# using scc$EI.Sector searching for Vechicles which includes on-road diesel/gasoline heavy duty/light
# duty vechicles, I am not sure about whether this is the right way to identity emissions from motor 
#vechicle source

# some people use nei$type=="ON-ROAD", I am not sure this is the right way to 
# identity emissions from motor vechicle neither.


# get motor vehicles related records from scc

motormatches=grepl("Vehicles", scc$EI.Sector, ignore.case=T)

scc2=scc[motormatches,]

# subset Baltimore City data

bal_data=subset(nei, fips=="24510")

# merge bal_data and scc2

bal_merge_data=merge(bal_data, scc2, by="SCC")

bal_motor_year=aggregate(Emissions~year, bal_merge_data, sum)

# plot

g=ggplot(bal_motor_year, aes(factor(year), Emissions))

g=g+geom_bar(stat="identity") +
        
        xlab("Year") +
        ylab("Total Emissions (in tons)") +
        ggtitle ("Total PM2.5 Emissions from Motor Vehicles Source in Baltimore City")

print(g)

# save the plot to png file

dev.copy(png, file="plot5.png", height=480, width=480)
dev.off()

## plot 6--compare emissions from motor vehicle sources in Baltimore City to Los Angeles County

# using scc$EI.Sector searching for Vechicles which includes on-road diesel/gasoline heavy duty/light
# duty vechicles, I am not sure about whether this is the right way to identity emissions from motor 
#vechicle source

# some people use nei$type=="ON-ROAD", I am not sure this is the right way to 
# identity emissions from motor vechicle neither.


# get motor vehicles related records from scc

motormatches=grepl("Vehicles", scc$EI.Sector, ignore.case=T)

scc2=scc[motormatches,]

# subset Baltimore City and Los Angeles County data 

two_areas=subset(nei, fips=="24510"| fips=="06037")

# merge two_areas and scc2

merge_data_2=merge(two_areas, scc2, by="SCC")

# plot

motor_year_2=aggregate(Emissions~year + fips, merge_data_2, sum)

motor_year_2$Area_name[motor_year_2$fips=="24510"]="Baltimore, MD"
motor_year_2$Area_name[motor_year_2$fips=="06037"]="Los Angeles, CA"

library(ggplot2)

qplot(year, Emissions, data=motor_year_2, col=Area_name, facets=.~Area_name, geom=c("point", "line"),
      xlab="Year", ylab="Total PM2.5 Emissions (in tons)",
      main="Emissions from Motor Vehicles in Baltimore, MD vs Los Angles, CA")

# save the plot to png file

dev.copy(png, file="plot6.png", height=480, width=1056)
dev.off()


