library(dplyr)
library(reshape)
path="C:/Users/Eric/Desktop/Learning/R/Getting and Cleaning Data/UCI HAR Dataset/"

#Create dataframe with subject and activity factors
#activity<-read.table("activity_labels.txt")
Xtest<-read.table("test/X_test.txt",header=TRUE)

colnames(Xtest)[]<-as.character(read.table("features.txt")[,2])
#get columns with mean and std
Xtest<-Xtest[,c(grep("mean",names(Xtest)),grep("std",names(Xtest)))]

#combine activities with subject
Xtest<-cbind(read.table("test/subject_test.txt",header=TRUE),read.table("test/y_test.txt",header=TRUE),Xtest)
#match activity labels with activity numbers
Xtest<-inner_join(read.table("activity_labels.txt"),Xtest,by=c("V1"="X5"))
Xtest<-select(Xtest,-V1)
names(Xtest)[1]<-"activity"
names(Xtest)[2]<-"subject"
Xtest$subject<-as.factor(Xtest$subject)
xmelt<-melt(Xtest)
xgroup<-group_by(xmelt,subject,activity,variable)
outputtest<-data.frame(summarize(xgroup,mean(value)))

###################################################################

#Create dataframe with subject and activity factors
#activity<-read.table("activity_labels.txt")
Xtrain<-read.table("train/X_train.txt",header=TRUE)

colnames(Xtrain)[]<-as.character(read.table("features.txt")[,2])
#get columns with mean and std
Xtrain<-Xtrain[,c(grep("mean",names(Xtrain)),grep("std",names(Xtrain)))]

#combine activities with subject
Xtrain<-cbind(read.table("train/subject_train.txt",header=TRUE),read.table("train/y_train.txt",header=TRUE),Xtrain)
#match activity labels with activity numbers
Xtrain<-inner_join(read.table("activity_labels.txt"),Xtrain,by=c("V1"="X5"))
Xtrain<-select(Xtrain,-V1)
names(Xtrain)[1]<-"activity"
names(Xtrain)[2]<-"subject"
Xtrain$subject<-as.factor(Xtrain$subject)
xmelt<-melt(Xtrain)
xgroup<-group_by(xmelt,subject,activity,variable)
outputtrain<-data.frame(summarize(xgroup,mean(value)))

####################################################################
output<-rbind(outputtrain,outputtest)
output$subject<-as.numeric(output$subject)
longoutput<-arrange(output,subject)
wideoutput<-cast(output,subject+activity~variable)

write.table(longoutput,"tidy.txt",row.names=FALSE)

####################################################################




