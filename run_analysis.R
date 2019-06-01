filename <- "Coursera_DS3_Final.zip";

if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip";
  download.file(fileURL, filename, method="curl");
} 

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename);
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"));
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"));
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject");
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions);
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code");
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject");
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions);
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

X <- rbind(x_train, x_test);
Y <- rbind(y_train, y_test);

Subject <- rbind(subject_test, subject_train);

Merged_Dataset <- cbind(Subject, Y, X);
extractMeanSD <- Merged_Dataset %>% select(Subject, code, contains("mean"), contains("std"));

extractMeanSD$code <- activities[extractMeanSD$code, 2];

names(extractMeanSD)<-gsub("-mean()", "Mean", names(extractMeanSD), ignore.case = TRUE);
names(extractMeanSD)<-gsub("-std()", "STD", names(extractMeanSD), ignore.case = TRUE);
names(extractMeanSD)<-gsub("-freq()", "Frequency", names(extractMeanSD), ignore.case = TRUE);
names(extractMeanSD)<-gsub("angle", "Angle", names(extractMeanSD));
names(extractMeanSD)<-gsub("gravity", "Gravity", names(extractMeanSD));

names(extractMeanSD)<-gsub("Acc", "Accelerometer", names(extractMeanSD));
names(extractMeanSD)<-gsub("Gyro", "Gyroscope", names(extractMeanSD));
names(extractMeanSD)<-gsub("BodyBody", "Body", names(extractMeanSD));
names(extractMeanSD)<-gsub("Mag", "Magnitude", names(extractMeanSD));
names(extractMeanSD)<-gsub("^t", "Time", names(extractMeanSD));
names(extractMeanSD)<-gsub("^f", "Frequency", names(extractMeanSD));
names(extractMeanSD)<-gsub("tBody", "TimeBody", names(extractMeanSD));
names(extractMeanSD)[2] = "activity";

FinalData <- extractMeanSD %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)

