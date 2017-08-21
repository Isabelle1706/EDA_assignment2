## EDA assignment 2

## read in data using readRDS() function

unzip("~/R/coursera/SummarySCC_PM25.rds")
unzip("~/R/coursera/Source_Classification_Code.rds", "rb")

dir()

nei=readRDS("~/R/coursera/SummarySCC_PM25.rds")
scc=readRDS("~/R/coursera/Source_Classification_Code.rds")


head(nei)
head(scc)

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

