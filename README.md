Getting-and-Cleaning-Data-Course-Project-GH
===========================================

This is Gareth Houk's Course Project Repository for the Coursera "Getting and Cleaning Data" Project

8/23/2014.

Course project specifies extracting summary data for a large smartphone dataset for 30 volunteers performing 6 activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).  The smartphone records accelerometer data. The output of run_analysis.R is a tidy dataset giving the mean of each of the 66 summary variables (see below) for each subject (30) and each activity (6).  This dataset therefore consists of 11,880 measurements.    

========
Data source reference: 
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

downloaded from: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
========

We assume that the dataset is in your working directory, i.e. that you are running RStudio from the "UCI HAR Dataset" directory as unzipped from the zip file.  The code run_analysis.R also contains a commented out section at the beginning which performs the data download, unzip, and set working directory; we don't want to do this every time, hence my commenting out this section of code.

I selected only the 33 mean() variables and the 33 paired std() variables.  Some other features have "mean" in the titles, but I chose not to extract these variables since: 1) they are fast fourier transform data and so the averaging is over the frequency range; 2) they are not paired with corresponding standard deviations.  I believe this is in consonance with the grading rubric statment: "Extracts only the measurements on the mean and standard deviation for each measurement."  

The code uses the grep() function to search for "mean()" and "std()" in features.txt to figure out which variables to extract.

As a result, the features of the original data set which we have extracted are shown below.  In this list, the integer is the index of the feature in the original data set, i.e. the column number in X_test or X_train corresponding to this feature.  The names describe the type of measurement performed, i.e. tBodyAcc-mean()-X describes a time series of acceleration for the body on the smartphone X axis, and is the mean of the measurement.  

These labels are used to create column headings for the intermediate data frame.

1 tBodyAcc-mean()-X
2 tBodyAcc-mean()-Y
3 tBodyAcc-mean()-Z
4 tBodyAcc-std()-X
5 tBodyAcc-std()-Y
6 tBodyAcc-std()-Z
41 tGravityAcc-mean()-X
42 tGravityAcc-mean()-Y
43 tGravityAcc-mean()-Z
44 tGravityAcc-std()-X
45 tGravityAcc-std()-Y
46 tGravityAcc-std()-Z
81 tBodyAccJerk-mean()-X
82 tBodyAccJerk-mean()-Y
83 tBodyAccJerk-mean()-Z
84 tBodyAccJerk-std()-X
85 tBodyAccJerk-std()-Y
86 tBodyAccJerk-std()-Z
121 tBodyGyro-mean()-X
122 tBodyGyro-mean()-Y
123 tBodyGyro-mean()-Z
124 tBodyGyro-std()-X
125 tBodyGyro-std()-Y
126 tBodyGyro-std()-Z
161 tBodyGyroJerk-mean()-X
162 tBodyGyroJerk-mean()-Y
163 tBodyGyroJerk-mean()-Z
164 tBodyGyroJerk-std()-X
165 tBodyGyroJerk-std()-Y
166 tBodyGyroJerk-std()-Z
201 tBodyAccMag-mean()
202 tBodyAccMag-std()
214 tGravityAccMag-mean()
215 tGravityAccMag-std()
227 tBodyAccJerkMag-mean()
228 tBodyAccJerkMag-std()
240 tBodyGyroMag-mean()
241 tBodyGyroMag-std()
253 tBodyGyroJerkMag-mean()
254 tBodyGyroJerkMag-std()
266 fBodyAcc-mean()-X
267 fBodyAcc-mean()-Y
268 fBodyAcc-mean()-Z
269 fBodyAcc-std()-X
270 fBodyAcc-std()-Y
271 fBodyAcc-std()-Z
345 fBodyAccJerk-mean()-X
346 fBodyAccJerk-mean()-Y
347 fBodyAccJerk-mean()-Z
348 fBodyAccJerk-std()-X
349 fBodyAccJerk-std()-Y
350 fBodyAccJerk-std()-Z
424 fBodyGyro-mean()-X
425 fBodyGyro-mean()-Y
426 fBodyGyro-mean()-Z
427 fBodyGyro-std()-X
428 fBodyGyro-std()-Y
429 fBodyGyro-std()-Z
503 fBodyAccMag-mean()
504 fBodyAccMag-std()
516 fBodyBodyAccJerkMag-mean()
517 fBodyBodyAccJerkMag-std()
529 fBodyBodyGyroMag-mean()
530 fBodyBodyGyroMag-std()
542 fBodyBodyGyroJerkMag-mean()
543 fBodyBodyGyroJerkMag-std()

name substitutions:

"tBodyAcc-"             "tBodyAcc_Time_Domain_Body_Vector_Linear_Acceleration_from_Accelerometer-"             cross mean(),std() cross X,Y,Z
"tGravityAcc-"          "tGravityAcc_Time_Domain_Gravity_Vector_Linear_Acceleration_from_Accelerometer-"       cross mean(),std() cross X,Y,Z
"tBodyAccJerk-"         "tBodyAccJerk_Time_Domain_Body_Vector_Linear_Jerk_from_Accelerometer-"                 cross mean(),std() cross X,Y,Z
"tBodyGyro-"            "tBodyGyro_Time_Domain_Body_Vector_Angular_Acceleration_from_Gyroscope-"               cross mean(),std() cross X,Y,Z
"tBodyGyroJerk-"        "tBodyGyroJerk_Time_Domain_Body_Vector_Angular_Jerk_from_Gyroscope-"                   cross mean(),std() cross X,Y,Z
"tBodyAccMag-"          "tBodyAccMag_Time_Domain_Body_Scalar_Linear_Acceleration_from_Accelerometer-"          cross mean(),std()
"tGravityAccMag-"       "tGravityAccMag_Time_Domain_Gravity_Scalar_Linear_Acceleration_from_Accelerometer-"    cross mean(),std()
"tBodyAccJerkMag-"      "tBodyAccJerkMag_Time_Domain_Body_Scalar_Linear_Jerk_from_Accelerometer-"              cross mean(),std()
"tBodyGyroMag-"         "tBodyGyroMag_Time_Domain_Body_Scalar_Angular_Acceleration_from_Gyroscope-"            cross mean(),std()
"tBodyGyroJerkMag-"     "tBodyGyroJerkMag_Time_Domain_Body_Scalar_Angular_Jerk_from_Gyroscope-"                cross mean(),std()
"fBodyAcc-"             "fBodyAcc_Frequency_Domain_Body_Vector_Linear_Acceleration_from_Accelerometer-"        cross mean(),std() cross X,Y,Z
"fBodyAccJerk-"         "fBodyAccJerk_Frequency_Domain_Body_Vector_Linear_Jerk_from_Accelerometer-"            cross mean(),std() cross X,Y,Z
"fBodyGyro-"            "fBodyGyro_Frequency_Domain_Body_Vector_Angular_Acceleration_from_Gyroscope-"          cross mean(),std() cross X,Y,Z
"fBodyAccMag-"          "fBodyAccMag_Frequency_Domain_Body_Scalar_Linear_Acceleration_from_Accelerometer-"     cross mean(),std()
"fBodyBodyAccJerkMag-"  "fBodyBodyAccJerkMag_Frequency_Domain_Body_Scalar_Linear_Jerk_from_Accelerometer-"     cross mean(),std()
"fBodyBodyGyroMag-"     "fBodyBodyGyroMag_Frequency_Domain_Body_Scalar_Angular_Acceleration_from_Gyroscope-"   cross mean(),std()
"fBodyBodyGyroJerkMag-" "fBodyBodyGyroJerkMag_Frequency_Domain_Body_Scalar_Angular_Jerk_from_Gyroscope-"       cross mean(),std()

The code run_analysis.R works to limit the memory needs of the analysis; it reads in only the numerical feature data it needs and neglects all the others.  It accomplishes this by using the read.fortran() function after constructing a fortran-style format statement which can skip over irrelevant data by assuming that each column is a 16 character fixed width and that the column numbers are given as above for the features of interest.  So we only read in and store the 66 columns of interest rather than all 561 columns.

The intermediate dataframe (all.dataframe) is constructed to store:

subject ("subject", 1-30) 
activity numerical index ("actidx", 1-6) 
activity label ("activity.label", WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING, extracted automatically from the file activity_labels.txt) 
group ("group", test or train)
and 66 the mean() and std() features listed in detail above.


