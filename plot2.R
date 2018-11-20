
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

#2
png(filename="plot2.png", width=480, height=480, units="px")
plot(data$datetime, data$Global_active_power, type="l",
     ylab="Global Active Power (kilowatts)", xlab="")
dev.off()

