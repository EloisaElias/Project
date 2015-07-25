==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================
The dataset was obtained from here:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones</a 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The dataset includes the following files:
=========================================

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

Additional information was provided in "inertial folders", but this data was excluded from the analysis, as only data regarding mean and std were required.

Method
================================================================
###This first process is repeated on both the 'train' and 'test' datasets.  
1.  These libraries are required

```r
library(dplyr)
library(reshape)
path="getwd()"
```
2.  Create dataframe with subject factors

```r
Xtest<-read.table("test/X_test.txt",header=TRUE)
```
3. get columns with mean and std

```r
colnames(Xtest)[]<-as.character(read.table("features.txt")[,2])
Xtest<-Xtest[,c(grep("mean",names(Xtest)),grep("std",names(Xtest)))]
```
4. combine activities with subject

```r
Xtest<-cbind(read.table("test/subject_test.txt",header=TRUE),read.table("test/y_test.txt",header=TRUE),Xtest)
```
5. match activity labels with activity numbers, rename columns

```r
Xtest<-inner_join(read.table("activity_labels.txt"),Xtest,by=c("V1"="X5"))
Xtest<-select(Xtest,-V1)
names(Xtest)[1]<-"activity"
names(Xtest)[2]<-"subject"
Xtest$subject<-as.factor(Xtest$subject)
```
6.  Convert to "long data"

```r
xmelt<-melt(Xtest)
```
7.  Perform aggregrate functions to calculate mean per subject-activity

```r
xgroup<-group_by(xmelt,subject,activity,variable)
outputtest<-data.frame(summarize(xgroup,mean(value)))
```
8.  Repeat above proccess for "train" data
9.  Bind results of train data and test data into one data frame

```r
output<-rbind(outputtrain,outputtest)
```
10.  Optionally can be cast back into wide data, sorted, and arranged

```r
output$subject<-as.numeric(output$subject)
longoutput<-arrange(output,subject)
wideoutput<-cast(output,subject+activity~variable)
```
11.  Create output file (long data)

```r
write.table(longoutput,"tidy.txt",row.names=FALSE)
```

