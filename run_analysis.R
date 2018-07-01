# ------------------------------------------------------------------------------------------
#
#   Getting and Cleaning Data: Week 4 Course Project
#
#   by KARTHIK T
#
# ------------------------------------------------------------------------------------------

# The main function of the script. Simply call main, which will go through all the 
# steps of the course project (reading the files, merging data, filtering data, tidying data).
# Just run main() in the command line, provided you have the UCI HAR Dataset directory and the
# run_analysis.R script in the same working directory.
main <- function() {
    
    # Remove objects from the workspace and garbage collect. Not sure if this is necessary.
    # I read that having unused objects impacts performance, since R stores objects in 
    # memory. Anyways, moving on!
    rm(list = ls())
    gc()

    # Define the output TXT file, that the tidied dataset will be saved as.
    result_csv = "RESULT.txt"
    
    #
    #library(tidyverse)
    
    # Assuming you unzipped the ZIP file in the same working directory,
    # the dataset should all be contained in this directory.
    dataset_root_dir <- "UCI HAR Dataset"
    if (!dir.exists(dataset_root_dir)) {
        print("You should probably download the dataset first.")
        print("When you do, unzip it and put it in a working directory.")
        print("Make sure to put this script in the same directory!")
        stop(paste(dataset_root_dir, "directory not found in working directory.", sep = " "))
    }
    
    # Define the names of the useful files within the primary directory.
    # Namely, a file containing the activity that the y-data integers
    # correspond to, and a list of features that the x-data vectors (should)
    # correspond to.
    activity_labels_file <- "activity_labels.txt"
    features_file <- "features.txt"
    
    # Define the names of the training / testing subdirectory.
    training_dir <- "train"
    testing_dir <- "test"
    
    # Define the files within the training data subdirectory.
    # I guess we're ignoring the inertial signals folder.
    training_subject_file <- "subject_train.txt"
    training_Y_file <- "y_train.txt"
    training_X_file <- "X_train.txt"
    
    # Define the files within the test data subdirectory.
    # I guess we're ignoring the inertial signals folder.
    testing_subject_file <- "subject_test.txt"
    testing_Y_file <- "y_test.txt"
    testing_X_file <- "X_test.txt"
    
    # Read in the activity labels and features. They are initially read in as factors.
    activity_labels <- read.delim(file = paste(dataset_root_dir, activity_labels_file, sep = "/"), header = FALSE)
    features <- read.delim(file = paste(dataset_root_dir, features_file, sep = "/"), header = FALSE)
    
    # Read in the training data for X and Y. Also read in as factors.
    train_subjects <- read.delim(file = paste(dataset_root_dir, training_dir, training_subject_file, sep = "/"), header = FALSE)
    train_ydata <- read.delim(file = paste(dataset_root_dir, training_dir, training_Y_file, sep = "/"), header = FALSE)
    train_xdata <- read.delim(file = paste(dataset_root_dir, training_dir, training_X_file, sep = "/"), header = FALSE)
    
    # Read in the testing data for X and Y. Also read in as factors.
    # test_Y interestingly reads as a data frame, which is really convenient.
    test_subjects <- read.delim(file = paste(dataset_root_dir, testing_dir, testing_subject_file, sep = "/"), header = FALSE)
    test_ydata <- read.delim(file = paste(dataset_root_dir, testing_dir, testing_Y_file, sep = "/"), header = FALSE)
    test_xdata <- read.delim(file = paste(dataset_root_dir, testing_dir, testing_X_file, sep = "/"), header = FALSE)
    
    # Clean the activity labels. They should remain a factor, because they are categorical. Remove the old activity labels object.
    cleaned_activity_labels <- clean_activity_labels(activity_labels)
    rm(activity_labels)
    
    # Clean the features. They should be a vector of characters, not factors. Remove the old features object.
    cleaned_features <- clean_features(features)
    rm(features)
    
    # Call the merge_objects_to_dataset function, which merges the testing data set and other objects. Finally, remove the testing objects.
    test_dataset <- merge_objects_to_dataset(test_subjects, cleaned_activity_labels, cleaned_features, test_ydata, test_xdata)
    rm(test_subjects)
    rm(test_ydata)
    rm(test_xdata)
    
    # Call the merge_objects_to_dataset function, which merges the training data set and other objects. Finally, remove the training objects.
    train_dataset <- merge_objects_to_dataset(train_subjects, cleaned_activity_labels, cleaned_features, train_ydata, train_xdata)
    rm(train_subjects)
    rm(train_ydata)
    rm(train_xdata)
    
    # Merge the tidied testing and training dataset into one. They should have the same column names.
    # Use rbind to merge the testing and training dataset. STEP 1 done, woo!
    merged_dataset <- rbind(test_dataset, train_dataset)

    # Filter the newly merged dataset and extract only the mean and standard deviation for each measurement.
    # There isn't any more instructions, leaving the actual methodology up for interpretation, I guess.
    # I interepreted this as extracting columns with the words "mean" or "std" in their column names.
    # So much for STEP 2.
    filtered_dataset <- filter_dataset(merged_dataset)
    
    # Create a new dataset from the earlier merged & filtered dataset. This function finds the averages of all
    # measurements per subject and activity. This makes 180 rows (30 subjects x 6 activity categories),
    # and 88 columns (number of columns with "mean" or "std" in the column name). STEP 4 is done!
    tidied_dataset <- make_tidy_dataset(filtered_dataset)
    
    # Output the tidied dataset as a TXT file. STEP 5 is done!
    write.table(x = tidied_dataset, file = result_csv, row.names = FALSE)
}

# This function generates a tidied data frame given the vector of subjects (N rows),
# the activity labels, the vector features (561 long), the vector of "correct" activities (N rows),
# and the vector of feature measurements (N rows, 1 very long character vector that should be 561 measurements).
merge_objects_to_dataset <- function(subjects, activity_labels, features, ydata, xdata) {
    
    # Subject is imported as a data frame already, which is nice. We'll start with that.
    # Just add a helpful column name and we're done!
    names(subjects) <- "SUBJECT"
    
    # Next is the activity column. 
    # Replace the integer vector with a data frame, containing a character
    # vector that coincides with the activity factors.
    cleaned_ydata <- convert_activity_factors(ydata, activity_labels)
    
    # Simply rename the column of the y-dataset to something helpful.
    names(cleaned_ydata) <- "ACTIVITY"
    
    # Finally is the giant data frame of 561xN data frame.
    # Each "row" in the X data contains 561 values, separated by whitespace.
    # The data frame contains N rows (depending on whether we throw in the testing data or training data).
    split_xdata <- lapply(xdata[,], clean_xdata)
    
    # Convert the list of numeric vectors into a data frame.
    # Rows corresponds to one particular set of measurements. 
    # Columns correspond to the particular feature. 561 features. 
    cleaned_xdata <- data.frame(matrix(unlist(split_xdata), nrow = length(split_xdata), byrow = TRUE))
    
    # Set the column names of the features to be the character vector of features.
    # Should be 561 cleaned features, corresponds to 561 columns from the data frame above.
    names(cleaned_xdata) <- features
    
    # Column-bind the three data frames, starting with SUBJECT, followed by ACTIVITY, followed by features.
    # They all should have the same column length, so cbind just sticks them all together!
    # Return this.
    cbind(subjects, cleaned_ydata, cleaned_xdata)
}

# This function cleans the activity labels (mainly just removes the leading integers).
clean_activity_labels <- function(activity_labels) {
    
    # Simply removes the first three characters from each of the factors. For example:
    # "6 LAYING" -> "LAYING" -> returns(LAYING)
    as.factor(sapply(activity_labels, function(x) {substring(x, 3)}))
    
}

# This function cleans the features, which will make up (most of) the columns of our tidy data set.
clean_features <- function(features) {
    
    # Clean the features of the dataset, retrieved from the features file.
    # Simply splits the element of each feature by whitespace, then returns the second element.
    # Example: 1 tBodyAcc-mean()-X -> "1", "tBodyAcc-mean()-X" -> returns("tBodyAcc-mean()-X")
    sapply(features$V1, function(x) {strsplit(as.character(x), " ")[[1]][2]})
}

# This function converts the N rows of character vectors into N rows x 561 columns of measurements.
# xdata should have been saved as a CSV file but whatever. Returns a list of numeric vectors.
clean_xdata <- function(xdata) {
    
    # Remove leading and trailing whitespace. Convert to character to be able to split by whitespace.
    # Split the long character string by whitespace (there's one or two, so I used regex).
    # Convert the now-split values from character to numeric. Repeat for each row in xdata (used lapply).
    as.numeric(strsplit(trimws(as.character(xdata)), "\\s+")[[1]])
    
}

# This function replaces the integer vector of N-row of activities that coincide to the 561 values of xdata.
# Instead of integers, we're going to replace them with the more descriptive activity_labels.
convert_activity_factors <- function(ydata, activity_labels) {
    
    # Simply replace the integer with its corresponding activity label (1 -> WALKING, etc).
    # Save as a data frame that should be N rows long.
    as.data.frame(lapply(ydata, function(x) {activity_labels[x]}))
    
}

# This function extracts only the mean and standard deviation from the original dataset (but includes SUBJECT and ACTIVITY).
# The phrase "extracts only the mean and standard deviation" leaves a lot of room for interpretation. I took the most
# literal approach and retrieved only all columns containing "mean" or "std".
filter_dataset <- function(dataset) {
    
    #
    # Identify the column indexes of the original dataset whose names contain "mean" or "std".
    indexes <- grep("mean|std", as.character(lapply(names(dataset), tolower)))
    
    # Column bind the first two columns of the original dataset (containing SUBJECT and ACTIVITY),
    # and the dataset columns that contain either "mean" or "std" in their name.
    cbind(dataset[, 1:2], dataset[, indexes])
}

# This function creates a new, tidy dataset from the merged and filtered (by "mean" / "std") dataset (88 columns).
# The content of this dataset is the mean of all 88 measurements, per activity, per subject. 
# This result is a data frame that is 180 rows (6 activities x 30 subjects) by 88 columns.
make_tidy_dataset <- function(dataset) {
    
    # Create an initially empty data frame, with the same columns as the filtered data frame.
    tidied_dataset <- data.frame(matrix(ncol = ncol(dataset), nrow = 0))
    names(tidied_dataset) <- names(dataset)
    
    # Iterate through the 30 subjects and 6 activities (sorted).
    subjects <- sort(unique(dataset$SUBJECT))
    activities <- as.character(sort(unique(dataset$ACTIVITY)))
    
    # Iterate through the 30 subjects in order.
    for (subject in subjects) {
        
        # Iterate through the 6 activities in order.
        for (activity in activities) {
            
            # Subset the data to get only the measurements for the particular subject and activity.
            temp_dataset <- subset(dataset, SUBJECT == subject & ACTIVITY == activity)
            
            # Use colMeans to get the mean of all the columns. Be careful not to get the colMeans of
            # the SUBJECT and ACTIVITY column. Comes out as a data frame, which is convenient!
            means <- unname(colMeans(temp_dataset[, 3:ncol(temp_dataset)]))

            # Create a single row with the subject, activity, and the means data frame. 
            # We have to transpose the means to make it rowwise.
            temp_row <- data.frame(subject, activity, t(data.frame(means)))
            
            # Remove the row names of the temporary single row, and make the column names
            # identical to the tidied dataset.
            rownames(temp_row) <- c()
            temp_rowname <- names(dataset)
            temp_rowname[3:length(temp_rowname)] <- paste("MEAN_OF_", temp_rowname[3:length(temp_rowname)], sep = "")
            names(temp_row) <- temp_rowname
            
            # Append the new row to the tidied data frame per iteration.
            # Understandably, this is pretty inefficient doing things in nested for loops.
            # Anyone got a better idea?
            tidied_dataset <- rbind(tidied_dataset, temp_row)
        }
    }
    
    # Return the tidied dataset!
    tidied_dataset
}
