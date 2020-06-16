##1)Merges the training and the test sets to create one data set.

##1.1)Merges the training set
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
datatrain <- cbind(subjecttrain,ytrain,xtrain)

##1.2)Merges the test set
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
datatest <- cbind(subjecttest,ytest,xtest)

##1.3)Merges the training and test set to create only one data set(raw)
rawdata <- rbind(datatrain,datatest)

##2)Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("./UCI HAR Dataset/features.txt",stringsAsFactors = FALSE)[,2]
featureIndex <- grep("mean\\(\\)|std\\(\\)", features)
data <- rawdata[,c(1,2,featureIndex + 2)]
colnames(data) <- c("subject", "activity", features[featureIndex])

##3)Uses descriptive activity names to name the activities in the data set.
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
data$activity <- factor(data$activity, levels = activities[,1], labels = activities[,2])

##4)Appropriately labels the data set with descriptive variable names.
names(data) <- gsub("^t","Time",names(data))
names(data) <- gsub("^f","Frequency",names(data))
names(data) <- gsub("Acc","Accelerometer",names(data))
names(data) <- gsub("Gyro","Gyroscope",names(data))
names(data) <- gsub("Mag","Magnitude",names(data))
names(data) <- gsub("BodyBody","Body",names(data))
names(data) <- gsub("\\(\\)","",names(data))

##5)Create a second tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
tidydata <- data %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(tidydata, "./paolo_meandata.txt", row.names = FALSE)