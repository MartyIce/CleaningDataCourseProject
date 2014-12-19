CleaningDataCourseProject
=========================

The run_analysis.R script will build the dataset requested by the Cleaning Data Course Project assignment:

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

1) Merges the training and the test sets to create one data set.
2) Extracts only the measurements on the mean and standard deviation for each measurement. 
3) Uses descriptive activity names to name the activities in the data set
4) Appropriately labels the data set with descriptive variable names. 
5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

It can be executed by invoking the "go()" function with the "UCI HAR Dataset" directory set as the working directory.  If a different directory is currently the working directory, then the "complete(rootDir)" function can be used.