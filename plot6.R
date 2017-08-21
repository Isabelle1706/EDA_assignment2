## EDA assignment 2

## read in data using readRDS() function

unzip("~/R/coursera/SummarySCC_PM25.rds")
unzip("~/R/coursera/Source_Classification_Code.rds", "rb")

dir()

nei=readRDS("~/R/coursera/SummarySCC_PM25.rds")
scc=readRDS("~/R/coursera/Source_Classification_Code.rds")


head(nei)
head(scc)

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

