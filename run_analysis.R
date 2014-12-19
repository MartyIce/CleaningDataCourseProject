library(data.table)

mergeSets <- function(rootDir) {

  testSubject <- read.table(paste(rootDir, 'test/subject_test.txt', sep=''))
  testLabel <- read.table(paste(rootDir, 'test/y_test.txt', sep=''))
  test <- read.table(paste(rootDir, 'test/X_test.txt', sep=''))

  trainSubject <- read.table(paste(rootDir, 'train/subject_train.txt', sep=''))
  trainLabel <- read.table(paste(rootDir, 'train/y_train.txt', sep=''))
  train <- read.table(paste(rootDir, 'train/X_train.txt', sep=''))
  
  rbind(cbind(testSubject, testLabel, test), cbind(trainSubject, trainLabel, train))
}

getMeanAndStdIndices <- function(rootDir) {
  features <- read.table(paste(rootDir, 'features.txt', sep=''))
  means <- features[grep("mean()", features$V2, fixed=TRUE),]
  stds <- features[grep("std()", features$V2, fixed=TRUE),]
  relevantFeatures <- rbind(means, stds)
  relevantFeatures[,1] <- relevantFeatures[,1] + 2
  injected = data.frame(V1=c(1, 2), V2=c('Subject', 'ActivityId'))
  relevantFeatures <- rbind(injected, relevantFeatures)
}

agg <- function(ds) {
  dt <- data.table(ds)
  setkey(dt, Activity, Subject)
  sd.cols <- tail(colnames(ds), length(colnames(ds))-2)
  aggregated <- dt[, c(lapply(.SD,mean)), by = list(Activity, Subject), .SDcols = sd.cols]  
  aggregated
}

complete <- function(rootDir) {
  merged <- mergeSets(rootDir)
  indices <- getMeanAndStdIndices(rootDir)
  slimmed <- merged[,indices[,1]]
  colnames(slimmed) <- indices[,2]

  
  # apply activity labels
  features <- read.table(paste(rootDir, 'activity_labels.txt', sep=''))
  colnames(features)[2] = 'Activity'
  slimmed = merge(x=features, y=slimmed, by.x="V1", by.y="ActivityId")
  slimmed$V1 <- NULL  
  agged <- agg(slimmed);  
  agged
}

go <- function() {
  complete('')
}