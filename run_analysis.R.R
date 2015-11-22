# Set the working directory to the root of the directory wheredata is present
setwd("~/UCI HAR Dataset/")

#read Test data
test = read.csv("test/X_test.txt", sep = "", header = FALSE)
test[, ncol(test) + 1] = read.csv("test/y_test.txt", sep = "", header = FALSE)
test[, ncol(test) + 1] = read.csv("test/subject_test.txt", sep = "", header = FALSE)

#read Train data
train = read.csv("train/X_train.txt", sep = "", header = FALSE)
train[, ncol(train) + 1] = read.csv("train/y_train.txt", sep = "", header = FALSE)
train[, ncol(train) + 1] = read.csv("train/subject_train.txt", sep = "", header = FALSE)

#read Features
features = read.csv("features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2]) 
features[,2] = gsub('-std', 'Std', features[,2]) 
features[,2] = gsub('[-()]', '', features[,2]) 

#read Activities
activities = read.csv("activity_labels.txt", sep="", header=FALSE)

#join Train and Test data sets
data = rbind(train, test)

#Pick columns we would want to experiment
colsWeWant = grep(".*Mean.*|.*Std.*", features[,2])
features <- features[colsWeWant,]

#Remove columns which we are not interrested in
colsWeWant <- c(colsWeWant, 562, 563)
data <- data[, colsWeWant]
colnames(data) <- c(features$V2, "activity", "subject")
colnames(data) <- tolower(colnames(data))


currentActivity <- 1
for(currentActivityLabel in activities$V2)
{
        data$activity <- gsub(currentActivity, currentActivityLabel, data$activity)
        currentActivity <- currentActivity + 1
}

data$activity <- as.factor(data$activity) 
data$subject <- as.factor(data$subject) 

tidydata = aggregate(data, by=list(activity = data$activity, subject=data$subject), mean)

tidydata[,90] = NULL 
tidydata[,89] = NULL 

write.table(tidydata, "tidy.txt", sep="\t") 

