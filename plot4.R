## EDA assignment 2

## read in data using readRDS() function

unzip("~/R/coursera/SummarySCC_PM25.rds")
unzip("~/R/coursera/Source_Classification_Code.rds", "rb")

dir()

nei=readRDS("~/R/coursera/SummarySCC_PM25.rds")
scc=readRDS("~/R/coursera/Source_Classification_Code.rds")


head(nei)
head(scc)

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
