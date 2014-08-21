target.file <- "UCI HAR Dataset"
data.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# if the dataset is not in the working directory
if (!file.exists(file.path(getwd(), target.file))) {
	# download the original .rar file
	download.file(data.url, "./UCI HAR Dataset.rar")
	
	# extract it in the working directory
	unzip("UCI HAR Dataset.rar")
}