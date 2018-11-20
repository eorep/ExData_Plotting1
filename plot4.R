
library(dplyr)

########################################################################
# Reading the data: Getting only 2 days of data from source file.

# capture the header of the source file to add it to our dataframe.
header <- read.table("household_power_consumption.txt", sep=";", nrows = 1, header=T)

# reading the records for Feb 1 and Feb 2, 2007 only, 2880 records represent 60 minutes * 24 hours * 2 days.
data <- read.table("household_power_consumption.txt", sep=";", nrows = 2880, header=F,
            skip=grep('1/2/2007',
                readLines("household_power_consumption.txt"))[1]-1)

# adding the header captured in the first read.table call.
colnames(data) <- colnames(header)

# adding a datetime field
data <- mutate(data, datetime = paste(Date, Time))
data$datetime <- strptime(data$datetime, format="%d/%m/%Y %H:%M:%S")

########################################################################
# Creating the plot as PNG file.

#4
png(filename="plot4.png", width=480, height=480, units="px")

par(mfrow=c(2,2), mar=c(4,4,2,1))

plot(data$datetime, data$Global_active_power, type="l",
     ylab="Global Active Power", xlab="", cex.lab=1)
plot(data$datetime, data$Voltage, type="l",
     ylab="Voltage", xlab="datetime")

plot(data$datetime, data$Sub_metering_1 , type="n", 
     ylab='Energy sub metering', xlab='')
points(data$datetime, data$Sub_metering_1, col='black', type="l")
points(data$datetime, data$Sub_metering_2, col='red', type="l")
points(data$datetime, data$Sub_metering_3, col='blue', type="l")
legend('topright', lty=1, col=c('black', 'red', 'blue'), 
       legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
       cex = 1, text.font=1, bty="n")

plot(data$datetime, data$Global_reactive_power, type="l",
     ylab="Global_reactive_power", xlab="datetime")

dev.off()
