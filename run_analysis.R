# data.table library is used in agg function below
library(data.table)

# this function will merge the test and training data contained in directory represented by rootDir parameter
mergeSets <- function(rootDir) {

  # load test data
  testSubject <- read.table(paste(rootDir, 'test/subject_test.txt', sep=''))
  testLabel <- read.table(paste(rootDir, 'test/y_test.txt', sep=''))
  test <- read.table(paste(rootDir, 'test/X_test.txt', sep=''))

# load training data
  trainSubject <- read.table(paste(rootDir, 'train/subject_train.txt', sep=''))
  trainLabel <- read.table(paste(rootDir, 'train/y_train.txt', sep=''))
  train <- read.table(paste(rootDir, 'train/X_train.txt', sep=''))
  
  # merge
  rbind(cbind(testSubject, testLabel, test), cbind(trainSubject, trainLabel, train))
}

# this function will retrieve the column indices for anything with "mean()" or "std()" in the title
getMeanAndStdIndices <- function(rootDir) {

  # read features file, use grep to obtain relevant columns
  features <- read.table(paste(rootDir, 'features.txt', sep=''))
  means <- features[grep("mean()", features$V2, fixed=TRUE),]
  stds <- features[grep("std()", features$V2, fixed=TRUE),]
  relevantFeatures <- rbind(means, stds)

  # inject Subject and ActivityId column names
  relevantFeatures[,1] <- relevantFeatures[,1] + 2
  injected = data.frame(V1=c(1, 2), V2=c('Subject', 'ActivityId'))
  relevantFeatures <- rbind(injected, relevantFeatures)
}

# this function takes a data.frame, turns it into a data.table, and aggregates over Activity and Subject columns
agg <- function(df) {

  # convert to data.table
  dt <- data.table(df)

  # aggregate
  setkey(dt, Activity, Subject)
  sd.cols <- tail(colnames(df), length(colnames(df))-2)
  aggregated <- dt[, c(lapply(.SD,mean)), by = list(Activity, Subject), .SDcols = sd.cols]  

  # return aggregated data
  aggregated
}

# this function will create and return the aggregated data table, based on the data located in the rootDir parameter
complete <- function(rootDir) {

  # merge training and test data
  merged <- mergeSets(rootDir)

  # grab the indices of the columns containing "mean" and "std" data
  indices <- getMeanAndStdIndices(rootDir)

  # take a subset of our test data only containing "mean" and "std" data
  slimmed <- merged[,indices[,1]]

  # grab the column names of our slimmed tes data
  colnames(slimmed) <- indices[,2]

  # apply activity labels
  features <- read.table(paste(rootDir, 'activity_labels.txt', sep=''))

  # manually set the "Activity" column name
  colnames(features)[2] = 'Activity'

  # merge our data with the activity labels
  slimmed = merge(x=features, y=slimmed, by.x="V1", by.y="ActivityId")

  # drop unneeded column
  slimmed$V1 <- NULL  

  # aggregate over activity and subject
  agged <- agg(slimmed);  

  # return aggregated data
  agged
}

# main function, this will invoke "complete" for the current working directory
go <- function() {
  complete('')
}