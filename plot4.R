##----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------##
## File Name: Plot4.R - 
## Dev Date: 08/Jul/2017
## 1. The script download “Individual household electric power consumption Data Set” file from UC Irvine Machine Learning Repository, and unzip it to household_power_consumption.txt
## 2. The file has 9 variables
##    Date: Date in format dd/mm/yyyy
##    Time: time in format hh:mm:ss
##    Global_active_power: household global minute-averaged active power (in kilowatt)
##    Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
##    Voltage: minute-averaged voltage (in volt)
##    Global_intensity: household global minute-averaged current intensity (in ampere)
##    Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered).
##    Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
##    Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.
## 3. The plot only analyse the data with dates 2007-02-01 and 2007-02-02
## 4. The plot will output to plot4.png file with a width of 480 pixels and a height of 480 pixels with 2 rows and 2 columns
##------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------##
# Start main program

# Set working directory
setwd("~")
# Download data for internet and load it into elec_power_consumption variable
if ( !file.exists("household_power_consumption.txt"))
{
  file_url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(file_url, destfile="household_power_consumption.zip")
  unz("household_power_consumption.zip", "household_power_consumption.txt")
}

elec_power_consumption <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", na.strings = "?")

# Only analyse data on 1/2/2007 and 2/2/2007
elec_power_consumption_feb <- elec_power_consumption[as.character(elec_power_consumption$Date) %in% c("1/2/2007", "2/2/2007"), ]

elec_power_consumption_feb$Datetime <- strptime(paste(elec_power_consumption_feb$Date, elec_power_consumption_feb$Time), format = "%d/%m/%Y %H:%M:%S")

# Only png plot device
png("plot4.png", width = 480, height = 480, units = "px")

# set par
par(mfrow = c(2,2))

# First plot GLobal Active Power
plot(elec_power_consumption_feb$Datetime, as.numeric(elec_power_consumption_feb$Global_active_power), type = "l", main = "", xlab = "", ylab = "Global Active Power (kilowatts)")

# The second plot on Voltage
plot(elec_power_consumption_feb$Datetime, as.numeric(elec_power_consumption_feb$Voltage), type = "l", main = "", xlab = "datetime", ylab = "Voltage")

# Generate the third plot on sub_metering
plot(elec_power_consumption_feb$Datetime, elec_power_consumption_feb$Sub_metering_1, type = "l", main = "", xlab = "", ylab = "Energy sub metering", col="grey")
lines(elec_power_consumption_feb$Datetime, as.numeric(elec_power_consumption_feb$Sub_metering_2), type = "l", col="red")
lines(elec_power_consumption_feb$Datetime, as.numeric(elec_power_consumption_feb$Sub_metering_3), type = "l", col="blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("grey", "red", "blue"), lwd = "1", bty = "n")

# The fourth plot on Global reactive power
plot(elec_power_consumption_feb$Datetime, as.numeric(elec_power_consumption_feb$Global_reactive_power), type = "l", main = "", xlab = "datetime", ylab = "Global_reactive_power")

# Close device
dev.off()
cat("plot4.png has been saved in", getwd())