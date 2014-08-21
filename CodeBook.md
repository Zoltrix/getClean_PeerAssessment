---
title: "CodeBook"
author: "Haron Shihab"
date: "Wednesday, August 20, 2014"
---

The data that this code book describes is a transformation of  the `Human Activity Recognition Using  Smartphones Dataset Version 1.0`, this document also includes 
various transformations made on the data to make it in a clean form and easier to use.

###About the HAR Data
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data


###Download the data
Download the original project data from here [UCI HAR Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

It is highly recommended to download the data first before reading further in this 
codebook, as the read me file in the original project data gives a nice description
of the project and will make it easier to the reader of this codebook to understand
the various transformations made on the data.


###Merging Training and Test data
Here is a figure showing how the training and test data are to be merged together
![Image Merged data frame](dataframe.png "data frame.png")

To merge, first we read in the Training data, training labels and training subjects:

```r
# read the training file
train <- read.table("UCI HAR Dataset/train/X_train.txt")

# read the training labels
train.labels <- read.table("UCI HAR Dataset/train/y_train.txt")

# read the training subjects
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt")
```

next we read the test data:

```r
# read the test file
test <- read.table("UCI HAR Dataset/test/X_test.txt")

# read the training labels
test.labels <- read.table("UCI HAR Dataset/test/y_test.txt")

# read the training subjects
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt")
```

read the features:

```r
# read in the features (skipe the first column as it is redundent)
features <- read.table("UCI HAR Dataset/features.txt", 
		       colClasses = c("NULL", "character"), 
		       col.names = c("NULL", "featureName"))
```

do the merge:

```r
# merge the training and testing data
merged.data <- rbind(train, test)

# merge the training and testing labels
merged.labels <- rbind(train.labels, test.labels)

# merge the training and testing subjects
merged.subject <- rbind(subject.train, subject.test)

# name the variable "subject"
names(merged.subject) <- "subject"

# set the names of the merged data set to the actual feature names
names(merged.data) <- features$featureName
```

Now the training and test data are merged into `merged.data`, `merged.labels`
and `merged.subject`. The next step is to put these 3 variables into 1 tidy data set
with appropriate variable names

###Variables of interest in the Original dataset
For the purpose of this course project, we are only interested in features that
were summarized by either the `mean` or the `std` (standard deviation) functions

Here is a complete list of these variables (check `features.txt` in the UCI HAR Dataset to see the whole list of features):

```
##  [1] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"          
##  [3] "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"           
##  [5] "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"           
##  [7] "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"       
##  [9] "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"        
## [11] "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"        
## [13] "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"      
## [15] "tBodyAccJerk-mean()-Z"       "tBodyAccJerk-std()-X"       
## [17] "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"       
## [19] "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"         
## [21] "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"          
## [23] "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"          
## [25] "tBodyGyroJerk-mean()-X"      "tBodyGyroJerk-mean()-Y"     
## [27] "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-X"      
## [29] "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"      
## [31] "tBodyAccMag-mean()"          "tBodyAccMag-std()"          
## [33] "tGravityAccMag-mean()"       "tGravityAccMag-std()"       
## [35] "tBodyAccJerkMag-mean()"      "tBodyAccJerkMag-std()"      
## [37] "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"         
## [39] "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"     
## [41] "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"          
## [43] "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"           
## [45] "fBodyAcc-std()-Y"            "fBodyAcc-std()-Z"           
## [47] "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"      
## [49] "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"       
## [51] "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"       
## [53] "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"         
## [55] "fBodyGyro-mean()-Z"          "fBodyGyro-std()-X"          
## [57] "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"          
## [59] "fBodyAccMag-mean()"          "fBodyAccMag-std()"          
## [61] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"  
## [63] "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"     
## [65] "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()"
```


###Cleaning the merged dataset
Now we have to clip the original data set and remove the unwanted variables
and keep the variables we are interested in

```r
# find column indices where mean() or std() occured
selected.columns <- grep("mean\\()|std\\()", names(merged.data))

# only select columns corresponding to selected indices
merged.data <- merged.data[, selected.columns]
```

###Adding extra variables
Add some extra variables to the merged data frame which represents the `subject`
and the `activity` labels

####Activity labels
Activity labels are transformed from ALL_CAPITAL to camelCase for better readabilty

```r
# list of activities, their indices match the numbering in 'activity_labels.txt'
activities <- c("Walking", "WalkingUpStairs", "WalkingDownStairs", "Sitting", 
		"Standing", "Laying")
```

Add the activity variable to the merged data frame:

```r
# since merged.labels values ranges from 1 .. 6 and we listed the activites
# in the same order in 'activity_labels.txt' we can easily get the activities
# names by using the values in merged.labels
merged.data$activity <- activities[merged.labels[[1]]]

# convert the activity column to factor
merged.data$activity <- as.factor(merged.data$activity)
```

Add the subject variable to the merged data frame:

```r
# attach the subjects to the merged data
merged.data <- cbind(merged.data, merged.subject)

# convert the subject column to factor
merged.data$subject <- as.factor(merged.data$subject)
```

Now the merged data is complete, it is now a tidy data frame with data from
training and testing merged together along with the activites and subjects.

###Cleaning the variable names
Since we are using R, having '()' and '-' in the variable name is not legal,
so i removed the brackets '()' and replaced hiphens '-' with periods '.'


```r
# replace the hiphens ('-') in the columns names with periods ('.')
names(merged.data) <- gsub("-", ".", names(merged.data))

# remove the brackets '()'
names(merged.data) <- gsub("\\(\\)", "", names(merged.data))
```

Now the cleaned and usable R Variable names are formatted as:
feature.summaryStat.Axis

(Note that the Axis maybe absent in some features as they do not need to be 
measured against any axis)

**Hint**: *I saw that this transformation of the variable names is nice, as it does not diverge too much from the original naming of the features yet keeps the variable name readable and legal in R*

Here is a list of cleaned variable names:

```
##  [1] "tBodyAcc.mean.X"           "tBodyAcc.mean.Y"          
##  [3] "tBodyAcc.mean.Z"           "tBodyAcc.std.X"           
##  [5] "tBodyAcc.std.Y"            "tBodyAcc.std.Z"           
##  [7] "tGravityAcc.mean.X"        "tGravityAcc.mean.Y"       
##  [9] "tGravityAcc.mean.Z"        "tGravityAcc.std.X"        
## [11] "tGravityAcc.std.Y"         "tGravityAcc.std.Z"        
## [13] "tBodyAccJerk.mean.X"       "tBodyAccJerk.mean.Y"      
## [15] "tBodyAccJerk.mean.Z"       "tBodyAccJerk.std.X"       
## [17] "tBodyAccJerk.std.Y"        "tBodyAccJerk.std.Z"       
## [19] "tBodyGyro.mean.X"          "tBodyGyro.mean.Y"         
## [21] "tBodyGyro.mean.Z"          "tBodyGyro.std.X"          
## [23] "tBodyGyro.std.Y"           "tBodyGyro.std.Z"          
## [25] "tBodyGyroJerk.mean.X"      "tBodyGyroJerk.mean.Y"     
## [27] "tBodyGyroJerk.mean.Z"      "tBodyGyroJerk.std.X"      
## [29] "tBodyGyroJerk.std.Y"       "tBodyGyroJerk.std.Z"      
## [31] "tBodyAccMag.mean"          "tBodyAccMag.std"          
## [33] "tGravityAccMag.mean"       "tGravityAccMag.std"       
## [35] "tBodyAccJerkMag.mean"      "tBodyAccJerkMag.std"      
## [37] "tBodyGyroMag.mean"         "tBodyGyroMag.std"         
## [39] "tBodyGyroJerkMag.mean"     "tBodyGyroJerkMag.std"     
## [41] "fBodyAcc.mean.X"           "fBodyAcc.mean.Y"          
## [43] "fBodyAcc.mean.Z"           "fBodyAcc.std.X"           
## [45] "fBodyAcc.std.Y"            "fBodyAcc.std.Z"           
## [47] "fBodyAccJerk.mean.X"       "fBodyAccJerk.mean.Y"      
## [49] "fBodyAccJerk.mean.Z"       "fBodyAccJerk.std.X"       
## [51] "fBodyAccJerk.std.Y"        "fBodyAccJerk.std.Z"       
## [53] "fBodyGyro.mean.X"          "fBodyGyro.mean.Y"         
## [55] "fBodyGyro.mean.Z"          "fBodyGyro.std.X"          
## [57] "fBodyGyro.std.Y"           "fBodyGyro.std.Z"          
## [59] "fBodyAccMag.mean"          "fBodyAccMag.std"          
## [61] "fBodyBodyAccJerkMag.mean"  "fBodyBodyAccJerkMag.std"  
## [63] "fBodyBodyGyroMag.mean"     "fBodyBodyGyroMag.std"     
## [65] "fBodyBodyGyroJerkMag.mean" "fBodyBodyGyroJerkMag.std" 
## [67] "activity"                  "subject"
```


####Extra info about the cleaned data
*Merged data frame size is now 10299x68, (original was 7352x561 for the training set
and 2947x561 for the test set)

*All values range from [-1, 1]
