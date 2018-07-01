Getting and Cleaning Data Course Project CODEBOOK
by Miguell M

Introduction
This codebook describes the steps I took to manipulate the dataset in order to follow the assignment prompts. For more information on the assignment prompts, please read the README.

This codebook also attempts to describe the variables of the resulting tidied dataset.

The Methodology
Step 1: Merges the training and the test sets to create one data set.
For this step, I first read the activity labels, the features list, and the training / testing data from the dataset. It was important to understand where all the seemingly disparate data related to each other, and was probably the most difficult part of the first step.

The activity labels is a vector of 6 factors, where each integer is associated with a particular physical activity.

The features list is a vector of 516 characters, where each character vector refers to a particular parameter measurement of an activity. The features list becomes the "column names" of our giant dataset, along with the subject, and the activity.

The training / testing subject data contains a column of N integers from 1 ~ 30. Each integer corresponds to a particular test subject performing a particular activity. The subject data becomes a "column" of our giant dataset.

The training / testing Y data contains a column of N integers from 1 ~ 6. Each integer corresponds to a particular activity, which is associated with the activity labels factor. The Y data becomes a "column" of our giant dataset.

The training / testing X data is probably the most complicated, and contains a column of N characters. Each character vector is a giant long string of 516 numbers, normalized from [-1, 1], and separated by whitespace. If they were properly split, the X data would be N rows by 516 columns, where each column refers to the features list mentioned above. The X data makes the bulk of our giant dataset.

Seeing where the pieces fit together was proably the most difficult part. After that, it was a straightforward matter of combining the various features, subjects, activities, and X data for both the training and testing data. Finally, I merged the training and testing data together to make one giant data set.

Step 2: Extract only the measurements on the mean and standard deviation for each measurement.
For this step, I simply isolated all columns that had the words "mean" or "std" as part of their column names. I made sure to check the lowercase of the names, as some column names have "Mean", which would not match "mean" if I hadn't lowercased it prior to the search. The vagueness of this step lead me to take the straightforward approach that I did.

Step 3: Uses descriptive activity names to name the activities in the data set.
For this step, I simply used "activity_labels.txt" to get the activity names for a given row. I replaced all integers in the y_test.txt / y_train.txt with the associated activity label. I applied this to my merged dataset and named the column "ACTIVITY", so all succeeding datasets have the same column.

Step 4: Appropriately labels the data set with descriptive variable names.
For this step, I simply used "features.txt" to get the 561 feature names for the X_test.txt / X_train.txt columns. I applied this to my merged dataset, so all succeeding datasets have the same column names for the various measurements. I was hesitant to replace any characters because some column names used characters like commas as part of the column name (for example: fBodyAcc-bandsEnergy()-57,64), and replacing / removing the comma might impact the column names' meaning. All I did was prepend "MEAN_OF_" to the features to indicate that the values represented were aggregates from the earlier dataset.

Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
For this step, I first subsetted the filtered dataset such that I isolated all measurements for a given subject performing a given activity. I then used colMeans to get the means of all the measurements. I repeated this process for all subjects, and all activities. The end result is a dataset of 180 rows (30 subjects x 6 activities) and 88 columns (the number of columns with "mean" or "std" in their name).

The Variables (UCI HAR Dataset Codebook)
From the UCI HAR Dataset Codebook:

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ tGravityAcc-XYZ tBodyAccJerk-XYZ tBodyGyro-XYZ tBodyGyroJerk-XYZ tBodyAccMag tGravityAccMag tBodyAccJerkMag tBodyGyroMag tBodyGyroJerkMag fBodyAcc-XYZ fBodyAccJerk-XYZ fBodyGyro-XYZ fBodyAccMag fBodyAccJerkMag fBodyGyroMag fBodyGyroJerkMag

The set of variables that were estimated from these signals are:

mean(): Mean value std(): Standard deviation mad(): Median absolute deviation max(): Largest value in array min(): Smallest value in array sma(): Signal magnitude area energy(): Energy measure. Sum of the squares divided by the number of values. iqr(): Interquartile range entropy(): Signal entropy arCoeff(): Autorregresion coefficients with Burg order equal to 4 correlation(): correlation coefficient between two signals maxInds(): index of the frequency component with largest magnitude meanFreq(): Weighted average of the frequency components to obtain a mean frequency skewness(): skewness of the frequency domain signal kurtosis(): kurtosis of the frequency domain signal bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window. angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean tBodyAccMean tBodyAccJerkMean tBodyGyroMean tBodyGyroJerkMean

The Variables (Tidied Dataset)
The tidied dataset is an aggregate of the test and training dataset, filtered by columns with "mean" or "std". For every test subject (30 of them) and activities those subjects performed (6 different categories), the mean of the various features were calculated. The result is 180 rows (30 subjects x 6 activities), and 88 columns (the number of columns with "mean" or "std").

All features whose means were calculated were prepended with "MEAN_OF_". Since they are averages, their units are the units of their parent variables - so please refer to the above section.

SUBJECT: Integer, representing 1 of 30 test subjects.

ACTIVITY: Character, representing 1 of 6 different physical activities.

MEAN_OF_tBodyAcc-mean()-X

MEAN_OF_tBodyAcc-mean()-Y

MEAN_OF_tBodyAcc-mean()-Z

MEAN_OF_tBodyAcc-std()-X

MEAN_OF_tBodyAcc-std()-Y

MEAN_OF_tBodyAcc-std()-Z

MEAN_OF_tGravityAcc-mean()-X

MEAN_OF_tGravityAcc-mean()-Y

MEAN_OF_tGravityAcc-mean()-Z

MEAN_OF_tGravityAcc-std()-X

MEAN_OF_tGravityAcc-std()-Y

MEAN_OF_tGravityAcc-std()-Z

MEAN_OF_tBodyAccJerk-mean()-X

MEAN_OF_tBodyAccJerk-mean()-Y

MEAN_OF_tBodyAccJerk-mean()-Z

MEAN_OF_tBodyAccJerk-std()-X

MEAN_OF_tBodyAccJerk-std()-Y

MEAN_OF_tBodyAccJerk-std()-Z

MEAN_OF_tBodyGyro-mean()-X

MEAN_OF_tBodyGyro-mean()-Y

MEAN_OF_tBodyGyro-mean()-Z

MEAN_OF_tBodyGyro-std()-X

MEAN_OF_tBodyGyro-std()-Y

MEAN_OF_tBodyGyro-std()-Z

MEAN_OF_tBodyGyroJerk-mean()-X

MEAN_OF_tBodyGyroJerk-mean()-Y

MEAN_OF_tBodyGyroJerk-mean()-Z

MEAN_OF_tBodyGyroJerk-std()-X

MEAN_OF_tBodyGyroJerk-std()-Y

MEAN_OF_tBodyGyroJerk-std()-Z

MEAN_OF_tBodyAccMag-mean()

MEAN_OF_tBodyAccMag-std()

MEAN_OF_tGravityAccMag-mean()

MEAN_OF_tGravityAccMag-std()

MEAN_OF_tBodyAccJerkMag-mean()

MEAN_OF_tBodyAccJerkMag-std()

MEAN_OF_tBodyGyroMag-mean()

MEAN_OF_tBodyGyroMag-std()

MEAN_OF_tBodyGyroJerkMag-mean()

MEAN_OF_tBodyGyroJerkMag-std()

MEAN_OF_fBodyAcc-mean()-X

MEAN_OF_fBodyAcc-mean()-Y

MEAN_OF_fBodyAcc-mean()-Z

MEAN_OF_fBodyAcc-std()-X

MEAN_OF_fBodyAcc-std()-Y

MEAN_OF_fBodyAcc-std()-Z

MEAN_OF_fBodyAcc-meanFreq()-X

MEAN_OF_fBodyAcc-meanFreq()-Y

MEAN_OF_fBodyAcc-meanFreq()-Z

MEAN_OF_fBodyAccJerk-mean()-X

MEAN_OF_fBodyAccJerk-mean()-Y

MEAN_OF_fBodyAccJerk-mean()-Z

MEAN_OF_fBodyAccJerk-std()-X

MEAN_OF_fBodyAccJerk-std()-Y

MEAN_OF_fBodyAccJerk-std()-Z

MEAN_OF_fBodyAccJerk-meanFreq()-X

MEAN_OF_fBodyAccJerk-meanFreq()-Y

MEAN_OF_fBodyAccJerk-meanFreq()-Z

MEAN_OF_fBodyGyro-mean()-X

MEAN_OF_fBodyGyro-mean()-Y

MEAN_OF_fBodyGyro-mean()-Z

MEAN_OF_fBodyGyro-std()-X

MEAN_OF_fBodyGyro-std()-Y

MEAN_OF_fBodyGyro-std()-Z

MEAN_OF_fBodyGyro-meanFreq()-X

MEAN_OF_fBodyGyro-meanFreq()-Y

MEAN_OF_fBodyGyro-meanFreq()-Z

MEAN_OF_fBodyAccMag-mean()

MEAN_OF_fBodyAccMag-std()

MEAN_OF_fBodyAccMag-meanFreq()

MEAN_OF_fBodyBodyAccJerkMag-mean()

MEAN_OF_fBodyBodyAccJerkMag-std()

MEAN_OF_fBodyBodyAccJerkMag-meanFreq()

MEAN_OF_fBodyBodyGyroMag-mean()

MEAN_OF_fBodyBodyGyroMag-std()

MEAN_OF_fBodyBodyGyroMag-meanFreq()

MEAN_OF_fBodyBodyGyroJerkMag-mean()

MEAN_OF_fBodyBodyGyroJerkMag-std()

MEAN_OF_fBodyBodyGyroJerkMag-meanFreq()

MEAN_OF_angle(tBodyAccMean,gravity)

MEAN_OF_angle(tBodyAccJerkMean),gravityMean)

MEAN_OF_angle(tBodyGyroMean,gravityMean)

MEAN_OF_angle(tBodyGyroJerkMean,gravityMean)

MEAN_OF_angle(X,gravityMean)

MEAN_OF_angle(Y,gravityMean)

MEAN_OF_angle(Z,gravityMean)
