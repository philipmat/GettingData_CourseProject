### Data Science Coursera: Getting and Cleaning Data
### Course Project
### Date: 10-25-2014

## 0.Read in all relevant datasets into R
trainData <- read.table("./data/train/X_train.txt", sep="")
trainAct <- read.table("./data/train/y_train.txt", sep="")
trainSub <- read.table("./data/train/subject_train.txt", sep="")
testData <- read.table("./data/test/X_test.txt", sep="")
testAct <- read.table("./data/test/y_test.txt", sep="")
testSub <- read.table("./data/test/subject_test.txt", sep="")
features <- read.table("./data/features.txt", sep="")
activity <- read.table("./data/activity_labels.txt", sep="")

## 1.Merge the training and the test sets to create one data set
colnames(trainData) <- as.character(features$V2)    # replace generic col names with feature names
colnames(testData) <- as.character(features$V2)     # replace generic col names with feature names
colnames(trainAct) <- "ActivityLabel"               # replace generic col name with descriptive
colnames(testAct) <- "ActivityLabel"                # replace generic col name with descriptive
colnames(trainSub) <- "SubjectIdentifier"           # replace generic col name with descriptive
colnames(testSub) <- "SubjectIdentifier"            # replace generic col name with descriptive

trainData2 <- cbind(trainAct, trainSub)         # add training subject data to activity data column
trainData2 <- cbind(trainData2, trainData)      # add training data to previous data, merging all training data
testData2 <- cbind(testAct, testSub)            # add test subject data to activity data column
testData2 <- cbind(testData2, testData)         # add test data to previous data, merging all testing data

mergedData <- rbind(trainData2, testData2)      # combine all rows from training and test data

## 2.Extract only measurements on the mean and standard deviation for each measurement
#sum( grepl( "mean[(][])]", colnames(mergedData) ) )  # total = 33
#sum( grepl( "std[(][])]", colnames(mergedData) ) )   # total = 33

extractData <- data.frame( mergedData$ActivityLabel )
extractData <- cbind( extractData, mergedData$SubjectIdentifier )
extractData <- cbind( extractData, mergedData[, grepl( "mean[(][)]", colnames(mergedData) )] )
extractData <- cbind( extractData, mergedData[, grepl( "std[(][)]", colnames(mergedData) )] )

## 3.Use descriptive activity names to name the activities in data set
activityName <- as.character(activity$V2)                       # character vector with descriptive activity names
extractDataActivity <- extractData$mergedData.ActivityLabel     # column of activity numbers

for( idx in seq_along(extractDataActivity) ) {
    extractData$mergedData.ActivityLabel[idx] <- activityName[extractDataActivity[idx]]  # overwrite number with activity name
}

## 4.Appropriately label data set with descriptive variable names
columnNames <- colnames(extractData)                                # temp vector that holds all column names, will update these names
columnNames <- tolower(columnNames)                                 # Convert names to lower case
columnNames <- gsub("-", "", columnNames)                           # Replace dash "-" char with <no space>.
columnNames <- gsub("acc", "accelerometer", columnNames)            # Replace "Acc" with "accelerometer".
columnNames <- gsub("gyro", "gyroscope", columnNames)               # Replace "Gyro" with "gyroscope".
columnNames <- gsub("mag", "magnitude", columnNames)                # Replace "Mag" with "magnitude".
columnNames <- gsub("mean[(][)]", "meanvalue", columnNames)         # Replace "mean()" with "meanvalue".
columnNames <- gsub("std[(][)]", "standarddeviation", columnNames)  # Replace "std()" with "standarddeviation".
columnNames <- gsub("^t", "time", columnNames)                      # Replace "t" when first letter of name with "time".
columnNames <- gsub("^f", "frequencydomainsignal", columnNames)     # Replace "f" when first letter of name with "frequencydomainsignal".
columnNames <- gsub("mergeddata.activitylabel", "activityname", columnNames) # Replace "mergedData.ActivityLabel" with "activityname".
columnNames <- gsub("mergeddata.subjectidentifier", "subjectidentifier", columnNames) # 11) Replace "mergedData.SubjectIdentifier" with "subjectidentifier".

colnames(extractData) <- columnNames        # overwrite data frame with new descriptive variable (column) names

## 5.Create a new independent tidy dataset with average of each variable for each activity and each subject
if("reshape2" %in% rownames( installed.packages() ) == FALSE) {     # install reshape2 package for reshaping into tidy data
    install.packages("reshape2")
}
library(reshape2)

meltedData <- melt( extractData, id=colnames(extractData)[1:2], measure.vars=colnames(extractData)[3:68] ) # melt data by id = activity and subject
avgTidyData <- dcast(meltedData, activityname + subjectidentifier ~ variable, mean)    # mean value of each variable for each activity name and subject identifier

## 6.Write tidy data to txt file
write.table(avgTidyData, file="./tidyData_AvgMeasuresByActivityAndSubject.txt", row.name=FALSE)
#verify_tidydata <- read.table("./tidyData_AvgMeasurementsByActivityAndSubject.txt", sep="", header=TRUE)  # test only: check tidy data txt file by reading it back into R
