---
title: "Readme"
output: html_document
---

This document describes the processing of a raw dataset ollected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>   
The different steps to collect, and clean the data set are détailed. 
The raw data for this  project are available at the following adresse  as well as the readme file and the Codebook.

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> 


##Load car and dplyr library

```r
library(car)
library(dplyr)
library(reshape2)
```

#1. Merging of the the training and the test sets to create one data set

##Load X_train.txt and X_test.txt which are Training and Testing dataset respectively

```r
Xtrain<-read.table("./UCI HAR Dataset/train/X_train.txt")
Xtest<-read.table("./UCI HAR Dataset/test/X_test.txt")
```

##Merge training and testing datasets

```r
datasetmerged=rbind(Xtrain,Xtest)
```

##Load Y_train.txt and Y_test.txt which are Training and Testing labels

```r
Ytrain<-read.table("./UCI HAR Dataset/train/Y_train.txt")
Ytest<-read.table("./UCI HAR Dataset/test/Y_test.txt")
```

##Merge training and testing labels

```r
labelsmerged<-rbind(Ytrain,Ytest)
```

##Recode Labels numbers to descriptives names

```r
Activity<-recode(labelsmerged[,1],"1='WALKING';2='WALKING_UPSTAIRS';3='WALKING_DOWNSTAIRS';4='SITTING';5='STANDING';6='LAYING'")
```

# 2.Extraction of the measurements on the mean and standard deviation for each measurement

##get the colomn number containing the word mean in features.txt

```r
features<-read.table("./UCI HAR Dataset/features.txt")
regexformean<-grep("(mean\\(\\)|std\\(\\)|mean\\(\\)-|std\\(\\)-)", features[,2], ignore.case = T)
```

##Extration of measurement on mean and standard deviation

```r
dataextract<-datasetmerged[,regexformean]
```

#3. Uses descriptive activity names to name the activities in the data set

##Merge the activity descriptive name with dataextraxt

```r
dataextract<-cbind(Activity,dataextract)
```

#4. labels the data set with descriptive variable names

##Get dataset column names and add activity at the begining of the vector

```r
varnames<-grep("(mean\\(\\)|std\\(\\)|mean\\(\\)-|std\\(\\)-)", features[,2], ignore.case = T,value = "TRUE")
varnames<-c("Subject", "Activity",varnames)
```

#5. creates a second, independent tidy data set with the average of each variable for each activity and each subject

##Load Y_train.txt and Y_test.txt which are Training and Testing labels

```r
trainsubject<-read.table("./UCI HAR Dataset/train/subject_train.txt")

testsubject<-read.table("./UCI HAR Dataset/test/subject_test.txt")
```

##Merge training and testing subject data

```r
subject<-rbind(trainsubject,testsubject)
colnames(subject)="Subject"
```

##Add subject to the data set

```r
dataextract<-cbind(subject,dataextract)
```

##Labels data set with descriptive data names collected in varnames

```r
colnames(dataextract)<-varnames
```

##Create Tidy data set with the average of each variable for each activity and each subject

##Get variable names for mean and standard deviation vairables from dataset 

```r
varnames<-grep("(mean\\(\\)|std\\(\\)|mean\\(\\)-|std\\(\\)-)", features[,2], ignore.case = T,value = "TRUE")
```

## Melt data extraction

```r
tidydataset <- melt(dataextract, id=c("Subject","Activity"), measure.vars=varnames)
```

##Cast Melted dataset to obtain average for each varaiable for each activity and each subject

```r
casttidydataset <- dcast(tidydataset,Subject+Activity~variable,mean)
```

##Save tidy data set as tidydataset.txt file

```r
write.table(casttidydataset, "tidydataset.txt",row.names =FALSE)
```
