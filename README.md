Getting and cleaning data course project readme 
=======================

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

This course project works on the (HAR) `Human Activity Recognition Using Smartphones Dataset Version 1.0`, it is highly recommended to download the data set from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
and read the readme file to get familiar with the dataset to be able to understand the transformations and analysis code included in this repo

FILES IN THIS REPO:

1. run_analysis.R: This R file contains the code that merges, cleans up the HAR data set and creates a tidy data set usable in analysis
2. CodeBook.md: A codebook for explaining how the cleaning process was done, what are the variables that we focused on and how did we transform them
3. tidy.txt: An independent tidy data set showing the mean of each variable for each subject and activity
4. README.md: A read me file
5. get_HAR_data.R: Another R file for downloading the data if not already found in the working directory
