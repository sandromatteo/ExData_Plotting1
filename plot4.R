rm(list=ls())

### set the Directory to read the file "household_power_consumption.txt"

setwd("~/Documents/MOOC/Coursera/Exploritory Data analysis/Project1")

### import the file in variable "data", it is a little bit faster that read.csv

# if not istalled:
#install.packages("sqldf")

library(sqldf)
f <- file("household_power_consumption.txt")
data<- sqldf("select * from f", dbname = tempfile(), file.format = list(header = T, row.names = F, sep=";"))


### filter only the data between "2007/02/01" and "2007/02/02"

data1<- data[data[,1] %in% c("1/2/2007","2/2/2007"),]

### change the format of the Date

data1[,1]<- as.Date(data1[,1], format="%d/%m/%Y")

### merge date and time in one col and give the right format
mydata<- data1[,2:9]
mydata[,1]<-as.data.frame(strptime(paste(data1[,1],data1[,2],sep=" "),format="%Y-%m-%d %H:%M:%S"))

### assign a new column name to the first col in the data frame
colnames(mydata)[1] <- "Data_Time"
str(mydata)

# plot4

png(file = "plot4.png",width = 480, height = 480)
par(mfrow=c(2,2), mar=c(4,4,4,1))
#plot up-left
plot(mydata$Data_Time,mydata$Global_active_power, type="l",xlab=" ",ylab="Global Active Power")
#plot up-right
plot(mydata$Data_Time,mydata$Voltage, type="l",xlab="datetime",ylab="Voltage")
#plot down-left
with(mydata, plot(Data_Time,Sub_metering_1, type="n",xlab=" ",ylab="Energy sub metering"))
with(mydata, lines(Data_Time,Sub_metering_1,col="black"))
with(mydata, lines(Data_Time,Sub_metering_2,col="red"))
with(mydata, lines(Data_Time,Sub_metering_3,col="blue"))
legend("topright",lty=1,bty="n",col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
#plot down-right
plot(mydata$Data_Time,mydata$Global_reactive_power, type="l",xlab="datetime",ylab="Global_reactive_power")
dev.off()
