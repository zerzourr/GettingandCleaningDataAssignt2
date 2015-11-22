library(car)
library(dplyr)
library(reshape2)

##Load X_train.txt and X_test.txt which are Training and Testing dataset respectively
Xtrain<-read.table("./UCI HAR Dataset/train/X_train.txt")
Xtest<-read.table("./UCI HAR Dataset/test/X_test.txt")

##Merge training and testing datasets
datasetmerged=rbind(Xtrain,Xtest)


##Load Y_train.txt and Y_test.txt which are Training and Testing labels
Ytrain<-read.table("./UCI HAR Dataset/train/Y_train.txt")
Ytest<-read.table("./UCI HAR Dataset/test/Y_test.txt")

##Merge training and testing labels
labelsmerged<-rbind(Ytrain,Ytest)

##Recode Labels numbers to descriptives names
Activity<-recode(labelsmerged[,1],"1='WALKING';2='WALKING_UPSTAIRS';3='WALKING_DOWNSTAIRS';4='SITTING';5='STANDING';6='LAYING'")

##get the colomn number containing the word mean in features.txt
features<-read.table("./UCI HAR Dataset/features.txt")
regexformean<-grep("(mean\\(\\)|std\\(\\)|mean\\(\\)-|std\\(\\)-)", features[,2], ignore.case = T)

##Extration of measurement on mean and standard deviation
dataextract<-datasetmerged[,regexformean]



##Merge the activity descriptive name with dataextraxt
dataextract<-cbind(Activity,dataextract)


##Get dataset column names and add activity at the begining of the vector
varnames<-grep("(mean\\(\\)|std\\(\\)|mean\\(\\)-|std\\(\\)-)", features[,2], ignore.case = T,value = "TRUE")
varnames<-c("Subject", "Activity",varnames)

##Load Y_train.txt and Y_test.txt which are Training and Testing labels
trainsubject<-read.table("./UCI HAR Dataset/train/subject_train.txt")
testsubject<-read.table("./UCI HAR Dataset/test/subject_test.txt")

##Merge training and testing subject data
subject<-rbind(trainsubject,testsubject)
colnames(subject)="Subject"

##Add subject to the data set
dataextract<-cbind(subject,dataextract)

##Labels data set with descriptive data names collected in varnames
colnames(dataextract)<-varnames

##Create Tidy data set with the average of each variable for each activity and each subject
##Get variable names for mean and standard deviation vairables from dataset 
varnames<-grep("(mean\\(\\)|std\\(\\)|mean\\(\\)-|std\\(\\)-)", features[,2], ignore.case = T,value = "TRUE")

## Melt data extraction 
tidydataset <- melt(dataextract, id=c("Subject","Activity"), measure.vars=varnames)

##Cast Melted dataset to obtain average for each varaiable for each activity and each subject 
casttidydataset <- dcast(tidydataset,Subject+Activity~variable,mean)

##Save tidy data set as tidydataset.txt file
write.table(casttidydataset, "tidydataset.txt",row.names =FALSE)




