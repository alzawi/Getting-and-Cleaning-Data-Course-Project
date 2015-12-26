#Getting and Cleaning Data Course Project


#Preparation phase
#Loading the required packages / setting and creating the working directory
library(dplyr)
library(plyr) 
library(data.table)  

setwd('c:\\Temp');

if(!file.exists("data")){
        file.create("data")
}
setwd('c:\\Temp\\data');

# 1. Merges the training and the test sets to create one data set.
# Training data set reading from "training" folder
x_train <- read.table("c:\\Temp\\data\\train\\X_train.txt")
y_train <- read.table("c:\\Temp\\data\\train\\y_train.txt")
subject_train <- read.table("c:\\Temp\\data\\train\\subject_train.txt")

# Testing data set reading from "testing" folder
x_test <- read.table("c:\\Temp\\data\\test\\X_test.txt")
y_test <- read.table("c:\\Temp\\data\\test\\y_test.txt")
subject_test <- read.table("c:\\Temp\\data\\test\\subject_test.txt")

# Merging phase 
# The (x,y, and subject) each in a specific data set merging
subject_data <- rbind(subject_train, subject_test)

x_data <- rbind(x_train, x_test)

y_data <- rbind(y_train, y_test)




#2. Extracts only the measurements on the mean and standard deviation for each measurement. 

features <- read.table("c:\\Temp\\data\\features.txt")

#mean_standard_features <- grepl("-(mean()|std())\\(\\)", features[,2])
mean_standard_features <- grep("-(mean()|std())\\(\\)", features[,2])

x_data <- x_data[, mean_standard_features]

names(x_data) <- features[mean_standard_features,2]

#3. Uses descriptive activity names to name the activities in the data set


activities <- read.table("c:\\Temp\\data\\activity_labels.txt")
y_data[,1] <- activities[y_data[,1],2]
names(y_data) <- "activity"

#4. Appropriately labels the data set with descriptive variable names. 
names(subject_data) <- "subject"
Data <- cbind(x_data, y_data, subject_data)

#x_data$activity<- y_data 
#x_data$subject <- subject_data
#Data<-x_data


#5. From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable for each activity and each subject.

average_activity_subject <- ddply(Data, .(subject, activity), summarize, sum = colMeans(Data[, 1:66]))

write.table(average_activity_subject, "average_activity_subject.txt", row.name=FALSE)
