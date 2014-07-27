library(plyr)

# read in features.txt and activity_labels.txt
features <- read.table("./features.txt")
actLabels <- read.table("./activity_labels.txt")
colnames(actLabels) <- c("Label", "Activity")
# read in test data set
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
test <- cbind(y_test, X_test)
# read in training data set
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
train <- cbind(y_train, X_train)
# read in subjects
subject_test <- read.table("./test/subject_test.txt")
subject_train <- read.table("./train//subject_train.txt")
# add subjects column to data sets
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
# combine two data sets into one
data <- rbind(train, test)
# add feature names
names <- c("Subject", "Label", as.vector(features$V2))
colnames(data) <- names
# subset data to include only mean and std of measurements
sub <- data[, c(1, 2, grep("mean", colnames(data)), grep("std", colnames(data)))]
# a new tidy data set with the average of each variable for each activity and each subject
result <- ddply(sub, .(Subject, Label), numcolwise(mean))
# use descriptive activity names to name the activities in the data set
result <- merge(result, actLabels)
result <- arrange(result, Subject, Activity)
# add appropriate labels to the data set with descriptive variable names.
result <- cbind(Subject = result$Subject, Activity = result$Activity, result[c(3:81)])
colnames(result)[3:81] <- paste("Average-", colnames(result)[3:81], sep = "")
# write a new file
write.table(result, file = "./tidy.txt")


