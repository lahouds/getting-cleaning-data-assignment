# You should create one R script called run_analysis.R that does the following.
#   1. Merges the training and the test sets to create one data set.
#   2. Extracts only the measurements on the mean and standard deviation for each measurement.
#   3. Uses descriptive activity names to name the activities in the data set
#   4. Appropriately labels the data set with descriptive variable names.
#   5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## LOADING REQUIRED R LIBRARIES

library("data.table")
library(dplyr)
library(plyr)


## PREPARING DIFFERENT VARIABLES

## Extracting the activity labels from the file activity_labels.txt for future use
activity_labels <- read.csv("UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = " ", col.names = c("number","labels"))
activity_labels <- tolower(activity_labels$labels)
## Extracting the list of features
features <- read.csv("UCI HAR Dataset/features.txt", header = FALSE, sep = " ", col.names = c("number","labels"))

##################################
## IMPORTING THE TEST DATA SET
##################################

## Importing the test labels from the file y_test.txt
test_labels <- read.csv("UCI HAR Dataset/test/y_test.txt", header = FALSE, col.names = "labels")
## replacing the class labels (numbers from 1 to 6) to their activity names found in the file activity_labels.txt
for (i in 1:6) {
  test_labels$labels[which(test_labels$labels==as.character(i))] <- activity_labels[i]
}

## Importing the test subjects used for the measurement from the subject_test.txt file
## the column name is called "subject_id"
test_subject <- read.csv("UCI HAR Dataset/test/subject_test.txt", header = FALSE, col.names = "subject_id")

## Importing the test data set from X.test.txt
## naming the 561 columns with the features names
test_set <- data.table::fread('UCI HAR Dataset/test/X_test.txt', col.names = as.character(features$labels))
## Keepting only measurements on the mean and standard deviation using the grep funtion
test_set_subset <- subset(test_set, select = grep("mean|std", names(test_set), ignore.case = TRUE))

## Binding the all test data: 1/ sujects + 2/ labesl 3/ measurement set
test_tidy_data <- cbind(test_subject,test_labels,test_set_subset)


##################################
## IMPORTING THE TRAIN DATA SET
##################################

## Importing the labels from the file y_train.txt
train_labels <- read.csv("UCI HAR Dataset/train/y_train.txt", header = FALSE, col.names = "labels")
## replacing the labels code in numbers to the labels names found in the file activity_labels.txt
for (i in 1:6) {
  train_labels$labels[which(train_labels$labels==as.character(i))] <- activity_labels[i]
}

## Importing the subjects used for the measurement from the subject_train.txt file
train_subject <- read.csv("UCI HAR Dataset/train/subject_train.txt", header = FALSE, col.names = "subject_id")

## Importing the train data set from X_train.txt
## naming the 561 columns with the features names
train_set <- data.table::fread('UCI HAR Dataset/train/X_train.txt', col.names = as.character(features$labels))
## Keepting only measurements on the mean and standard deviation using the grep funtion
train_set_subset <- subset(train_set, select = grep("mean|std", names(train_set), ignore.case = TRUE))

## Binding the all train data: 1/ sujects + 2/ labesl 3/ measurement set
train_tidy_data <- cbind(train_subject,train_labels,train_set_subset)

###############################################
## PREPARING THE FINAL MERGED TIDY DATA
###############################################

## Merging the tidy train data set and the tidy test data set
merged_tidy_data <- rbind(train_tidy_data, test_tidy_data)
## Arranging the data set by subjec_id
arrange(merged_tidy_data,subject_id)

## Creating the merged tidy data file as all_tidy_data.txt
write.table(merged_tidy_data, file = "merged_tidy_data.txt", sep = " ", row.names = FALSE, col.names = FALSE)



