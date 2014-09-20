library(plyr)
library(tidyr)
library(reshape2)

#include the file that downloads the data in case not found in the current working
#directory
source("get_HAR_data.R")

### read in the training data

# read the training file
train <- read.table("UCI HAR Dataset/train/X_train.txt")

# read the training labels
train.labels <- read.table("UCI HAR Dataset/train/y_train.txt")

# read the training subjects
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt")


### read in the test data


# read the test file
test <- read.table("UCI HAR Dataset/test/X_test.txt")

# read the training labels
test.labels <- read.table("UCI HAR Dataset/test/y_test.txt")

# read the training subjects
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt")

### Reading the features

# read in the features (skipe the first column as it is redundent)
features <- read.table("UCI HAR Dataset/features.txt", 
		       colClasses = c("NULL", "character"), 
		       col.names = c("NULL", "featureName"))


### merge both training and testing data


# merge the training and testing data
merged.data <- rbind(train, test)

# merge the training and testing labels
merged.labels <- rbind(train.labels, test.labels)

# merge the training and testing subjects
merged.subject <- rbind(subject.train, subject.test)
names(merged.subject) <- "subject"

# set the names of the merged data set to the actual feature names
names(merged.data) <- features$featureName

# select only columns with mean or stddev
selected.columns <- grep("mean\\()|std\\()", names(merged.data))

# only select columns corresponding to selected indices
merged.data <- merged.data[, selected.columns]

# replace the hiphens ('-') in the columns names with periods ('.')
names(merged.data) <- gsub("-", ".", names(merged.data))

# remove the brackets '()'
names(merged.data) <- gsub("\\(\\)", "", names(merged.data))

### add a new column representing the activity

# list of activities, their indices match the numbering in 'activity_labels.txt'
# NOTE: since there is only 6 activites, i chose to hard code them, if there were
# more than that, i would have read them and cleaned them from the .txt file
activities <- c("Walking", "WalkingUpStairs", "WalkingDownStairs", "Sitting", 
		"Standing", "Laying")

# since merged.labels values ranges from 1 .. 6 and we listed the activites
# in the same order in 'activity_labels.txt' we can easily get the activities
# names by using the values in merged.labels
merged.data$activity <- activities[merged.labels[[1]]]

# convert the activity column to factor
merged.data$activity <- as.factor(merged.data$activity)

# attach the subjects to the merged data
merged.data <- cbind(merged.data, merged.subject)

# convert the subject column to factor
merged.data$subject <- as.factor(merged.data$subject)

###Creating the tidy data : Step 5

# reshape the data with id variables of subject and activity
# the rest of the columns are measure variables
melted <- melt(merged.data, id.vars = c("subject", "activity"))

# use the plyr package to summarize and get the mean for each variable
almost.tidy <- ddply(melted, c("subject", "activity"), summarise, mean = mean(value))

# now tidy looks like this which is not quite tidy yet
#     subject          activity          mean
# 1         1            Laying -0.6815819785
# 2         1           Sitting -0.7250102567
# 3         1          Standing -0.7518868639
# 4         1           Walking -0.1932045725
# 5         1 WalkingDownStairs -0.1493580354
# 6         1   WalkingUpStairs -0.3153368084

#we need to 'spread' the activity i.e turn it into variable (column)
tidy <- spread(almost.tidy, activity, mean)

# write the output of the tidy data set to tidy.txt
write.table(tidy, "tidy.txt", row.names = FALSE)
