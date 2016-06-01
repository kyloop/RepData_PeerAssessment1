##Reference on how to download the data source files
##download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip",destfile = "hw5o1.zip",method="curl")
##zipfile5o1="hw5o1.zip"
##unzip(zipfile5o1,exdir=getwd())

##Loading and preprocessing the data
data1 <- read.csv("activity.csv")

##Part 1: Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with 𝙽𝙰s)
library(ggplot2)
totalSteps <- tapply(data1$steps, data1$date, FUN=sum, na.rm=TRUE)  ##Calculate the total steps by date.
qplot(totalSteps, xlab = "Total Steps for each day",main = "Plot for Total Steps for each day")
mean(totalSteps,na.rm=TRUE) ## Finding the mean of Total Steps
median(totalSteps, na.rm = TRUE) ## Finding the median of Total Steps

##Part2: What is the average daily (Per day) activity pattern?
library(ggplot2)
library(plyr)
averageStep <- ddply(data1, c("interval"), summarise, mean = mean(steps,na.rm = TRUE))

colnames(averageStep)[2]<-"meanStep" ##Rename the Steps column

ggplot(data=averageStep, aes(x=interval, y=meanStep)) + 
        geom_line() +
        xlab("5-minute interval") +
        ylab("average number of steps taken")

## What is maximum number of steps?
averageStep[which.max(averageStep$meanStep),] ##Finding the max value of Steps

## Part3: Imputing missing values
missingSteps<-is.na(data1$steps)
sumssingSteps<-sum(missingSteps) ## counting how many input is missing
as.table(summary(is.na(data1))) ## Summarize as a table for missing values 
filledData<-data1 ## Create another data set for replacing the original data set
filledData$steps[which(is.na(filledData$steps))] <- tapply(filledData$steps, filledData$interval, mean, na.rm=T, simplify=TRUE ) ## subsitite the na with mean value
filledDataTotalSteps<-tapply(filledData$steps,filledData$date,FUN = sum)
##Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. 
qplot(filledDataTotalSteps,binwidth=500, xlab="Total Steps taken each day")
mean(filledDataTotalSteps)
median(filledDataTotalSteps)


## Part4:  differences in activity patterns between weekdays and weekends
##Function to distinguish the weekdays or weekend
functionofday <- function(date){
        c<-weekdays(date)
        if (c %in% c("Monday","Tuesday","Wednesday","Thursday","Friday")){
                return("Weekday")}
        else{ return ("Weekend")}
}
## Call the function: functionofday
filledData$DayofWeek <- sapply(as.Date(filledData$date), functionofday)

## Finding the average steps intervals and DayofWeek
averageStep2 <- ddply(filledData, c("interval","DayofWeek"), summarise, mean = mean(steps,na.rm = TRUE))
colnames(averageStep2)[3]<-"Steps"
ggplot(data=averageStep2, aes(x=interval, y=Steps)) + 
        geom_line() +
        facet_grid(DayofWeek ~ .) +   ## Split the plot in terms of Weekday and Weekend
        xlab("5-minute interval") +
        ylab("Average Steps")
