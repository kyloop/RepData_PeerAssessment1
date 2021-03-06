# Reproducible Research: Peer Assessment 1


```r
knitr::opts_chunk$set(echo = TRUE)
```

## Loading and preprocessing the data

```r
data1 <- read.csv("activity.csv")
```

## What is mean total number of steps taken per day?

```r
library(ggplot2)
totalSteps <- tapply(data1$steps, data1$date, FUN=sum, na.rm=TRUE)  ##Calculate the total steps by date.
qplot(totalSteps,xlab = "Total Steps for each day",main = "Plot for Total Steps for each day")
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png)<!-- -->


```r
mean(totalSteps,na.rm=TRUE)
```

```
## [1] 9354.23
```

```r
median(totalSteps, na.rm = TRUE)
```

```
## [1] 10395
```

## What is the average daily activity pattern?

```r
library(ggplot2)
library(plyr)
averageStep <- ddply(data1, c("interval"), summarise, mean = mean(steps,na.rm = TRUE))
colnames(averageStep)[2]<-"meanStep" ##Rename the Steps column
ggplot(data=averageStep, aes(x=interval, y=meanStep)) + 
        geom_line() +
        xlab("5-minute interval") +
        ylab("average number of steps taken")
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

```r
## What is maximum number of steps?
averageStep[which.max(averageStep$meanStep),] ##Finding the max value of Steps
```

```
##     interval meanStep
## 104      835 206.1698
```

## Imputing missing values

```r
missingSteps<-is.na(data1$steps)
sumssingSteps<-sum(missingSteps) ## counting how many input is missing
as.table(summary(is.na(data1))) ## Summarize as a table for missing values 
```

```
##    steps            date          interval      
##  Mode :logical   Mode :logical   Mode :logical  
##  FALSE:15264     FALSE:17568     FALSE:17568    
##  TRUE :2304      NA's :0         NA's :0        
##  NA's :0
```

```r
filledData<-data1 ## Create another data set for replacing the original data set
filledData$steps[which(is.na(filledData$steps))] <- tapply(filledData$steps, filledData$interval, mean, na.rm=T, simplify=TRUE ) ## subsitite the na with mean value
filledDataTotalSteps<-tapply(filledData$steps,filledData$date,FUN = sum)
```

##Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. 

```r
qplot(filledDataTotalSteps,binwidth=500, xlab="Total Steps taken each day")
```

![](PA1_template_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

```r
mean(filledDataTotalSteps)
```

```
## [1] 10766.19
```

```r
median(filledDataTotalSteps)
```

```
## [1] 10766.19
```

## Are there differences in activity patterns between weekdays and weekends?
##Function to distinguish the weekdays or weekend

```r
functionofday <- function(date){
        c<-weekdays(date)
        if (c %in% c("Monday","Tuesday","Wednesday","Thursday","Friday")){
                return("Weekday")}
        else{ return ("Weekend")}
}
```

## Call the function: functionofday

```r
filledData$DayofWeek <- sapply(as.Date(filledData$date), functionofday)
```

## Finding the average steps intervals and DayofWeek

```r
averageStep2 <- ddply(filledData, c("interval","DayofWeek"), summarise, mean = mean(steps,na.rm = TRUE))
colnames(averageStep2)[3]<-"Steps"
ggplot(data=averageStep2, aes(x=interval, y=Steps)) + 
        geom_line() +
        facet_grid(DayofWeek ~ .) +   ## Split the plot in terms of Weekday and Weekend
        xlab("5-minute interval") +
        ylab("Average Steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png)<!-- -->
