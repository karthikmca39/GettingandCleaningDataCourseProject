# Getting and Cleaning Data Course Project README

by Miguell M


## Introduction

This README will explain the nature of the data cleaning assignment and the steps I took to clean and process the dataset and fulfill the assignment requirements.


## The Assignment

The assignment prompt is as follows from the Coursera website:

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.

2. Extracts only the measurements on the mean and standard deviation for each measurement.

3. Uses descriptive activity names to name the activities in the data set

4. Appropriately labels the data set with descriptive variable names.

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


The review criteria for the assignment is as follows from the Coursera website:

1. The submitted data set is tidy.

2. The Github repo contains the required scripts.

3. GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.

4. The README that explains the analysis files is clear and understandable.

5. The work submitted for this project is the work of the student who submitted it.


## The Dataset

The dataset for the assignment is UCI's Human Activity Recognition Using Smartphones Data Set from their Machine Learning Repository. It represents data collected from the accelerometer and gyroscope of a Samsung Galaxy SII as it is worn by test subjects performing a number of typical physical activities (standing, walking, laying, etc).

For more detail on the dataset, go to: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


## run_analysis.R

run_analysis.R is the only script I wrote, and has all the functions necessary to finish the assignment. Simply run:

```
main()
```

in the command line after sourcing the script, provided you have unzipped the UCI HAR Dataset directory in the same directory as run_analysis.R. The script will (should) proceed as expected, run through the steps of the assignment, produce a tidied dataset in the form of a CSV file, saved in the same working directory.
