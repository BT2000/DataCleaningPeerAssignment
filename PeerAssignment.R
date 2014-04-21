setwd("C:\\Users\\Brian\\Documents\\MOOCS\\Coursera\\Cleaning Data\\UCI HAR Dataset")
library(data.table)
## Read Lables
aLables <- fread("activity_labels.txt")
features <-fread("features.txt")
## Read Train Data
TrainSub <-fread("train/subject_train.txt")
TrainX <-read.table("train/X_train.txt")
TrainY <-fread("train/Y_train.txt")
## Set Train Data names
setnames(TrainSub,colnames(TrainSub),"Subject_ID")
setnames(TrainX,colnames(TrainX),features$V2)
setnames(TrainY,colnames(TrainY),"Activity_Code")
## Combine Train data sets
Train <-cbind(TrainSub,TrainY,TrainX)
## Add Column to note data source
Train$Source <- "Train"
## Read Test Data
TestSub <-fread("test/subject_test.txt")
TestX <-read.table("test/X_test.txt")
TestY <-fread("test/Y_test.txt")
## Set Test data columns names
setnames(TestSub,colnames(TestSub),"Subject_ID")
setnames(TestX,colnames(TestX),features$V2)
setnames(TestY,colnames(TestY),"Activity_Code")
## Combine Test data sets
Test <-cbind(TestSub,TestY,TestX)
## Add column to note data source
Test$Source <- "Test"
## Combine Both sets
CompleteSet <- rbind(Train,Test)
Activity <- CompleteSet[,aLables$V2[as.numeric(CompleteSet$Activity_Code)]]
CompleteSet <- cbind(Activity,CompleteSet)
## Find columns with mean and standard deviation
Mean_Std_Cols <- features[(grepl("mean",features$V2)|(grepl("std",features$V2)))]
colList <-as.vector(c("Activity","Subject_ID", "Activity_Code",Mean_Std_Cols$V2,"Source"))
ReducedSet <-subset(CompleteSet, select = colList)
GroupedSet <- aggregate(ReducedSet, list(ReducedSet$Subject_ID,ReducedSet$Activity),FUN=mean)