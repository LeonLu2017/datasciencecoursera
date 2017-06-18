## The run_analysis.R script analyse data from experiments that have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. 
## Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. 
## Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 
## The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 
## The script will doing following tasks:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Set working directory
setwd("D:\\Liang\\Workspace\\DataScience\\C4")

# Check and Load library
if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")

# Load Activity labels, features as variables
activity_lables <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# 2. Set logical value on the mean and standard deviation for measurements.
extract_features <- grepl("mean|std", features)

# Load and process training data
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Assign features as column to X_train
names(X_train) = features

# 2. Extracts only the measurements on the mean and standard deviation for each measurement of X_train
x_train <- X_train[,extract_features]

# Assign column names to y_train
y_train[,2] = activity_lables[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Lable")
names(subject_train) = "subject"

# Generate train_data
train_data <- cbind(as.data.table(subject_train), y_train, x_train)

# Load and process test data
X_test <- read.table("./UCI HAR Dataset/train/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/train/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/train/subject_test.txt")

# Assign features as column to X_test
names(X_test) = features

# 2. Extracts only the measurements on the mean and standard deviation for each measurement of X_test
x_test <- X_test[,extract_features]

# Assign column names to y_test
y_test[,2] = activity_lables[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Lable")
names(subject_test) = "subject"

# Generate test_data
test_data <- cbind(as.data.table(subject_test), y_test, x_test)

# merge training and test data
data <- rbind(test_data, train_data)

# Set lable names
id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)

# Melt data
melt_data = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")

