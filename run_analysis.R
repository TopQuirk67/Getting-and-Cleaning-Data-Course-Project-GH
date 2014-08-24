#
# run_analysis.R
#
# Getting and cleaning data course project script
#
run_analysis <- function() {
## The following six lines have been commented out to avoid downloading the data
## more than once.  Download occured at 08:22pm EST on 8/19/14
#        if (!file.exists(".data")){dir.create(".data")}
#        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#        destfile <- ".data/HADataset.zip"
#        dlval<-download.file(fileUrl,destfile=destfile)
#        if (dlval!=0) {stop("Error on file download\n")}
#        dateDownloaded <- date()
#        unzip(destfile)
#        setwd("UCI HAR Dataset")
##
##
        # read and put in test activity names
        translate.activity <- read.table("activity_labels.txt",col.names=c("idx","activity label"))
        # setup read-in of features to data frame; we use read.fortran to read in only the 
        # mean and std columns we are interested in to eliminate later data processing to 
        # remove these columns
        features <- read.table("features.txt")
        features.meansindices <- grep("mean()",features[,2],fixed=TRUE)
        features.stdsindices  <- grep("std()",features[,2],fixed=TRUE)
        # merge mean and std indices to create FORTRAN read-in format string; get labels for frame
        features.allindices   <- sort(cbind(features.meansindices,features.stdsindices))
        feature.labels<-features[features.allindices,2]
        # Remove parentheses from labels and add more extensive descriptions to labels
        feature.labels<-gsub(pattern="mean()",replacement="mean",x=feature.labels,fixed=TRUE)
        feature.labels<-gsub(pattern="std()",replacement="std",x=feature.labels,fixed=TRUE)
        feature.labels<-gsub(pattern="tBodyAcc-",replacement="tBodyAcc_Time_Domain_Body_Vector_Linear_Acceleration_from_Accelerometer-",x=feature.labels,fixed=TRUE)
        feature.labels<-gsub(pattern="tGravityAcc-",replacement="tGravityAcc_Time_Domain_Gravity_Vector_Linear_Acceleration_from_Accelerometer-",x=feature.labels,fixed=TRUE)
        feature.labels<-gsub(pattern="tBodyAccJerk-",replacement="tBodyAccJerk_Time_Domain_Body_Vector_Linear_Jerk_from_Accelerometer-",x=feature.labels,fixed=TRUE)
        feature.labels<-gsub(pattern="tBodyGyro-",replacement="tBodyGyro_Time_Domain_Body_Vector_Angular_Acceleration_from_Gyroscope-",x=feature.labels,fixed=TRUE)
        feature.labels<-gsub(pattern="tBodyGyroJerk-",replacement="tBodyGyroJerk_Time_Domain_Body_Vector_Angular_Jerk_from_Gyroscope-",x=feature.labels,fixed=TRUE)
        feature.labels<-gsub(pattern="tBodyAccMag-",replacement="tBodyAccMag_Time_Domain_Body_Scalar_Linear_Acceleration_from_Accelerometer-",x=feature.labels,fixed=TRUE)
        feature.labels<-gsub(pattern="tGravityAccMag-",replacement="tGravityAccMag_Time_Domain_Gravity_Scalar_Linear_Acceleration_from_Accelerometer-",x=feature.labels,fixed=TRUE)
        feature.labels<-gsub(pattern="tBodyAccJerkMag-",replacement="tBodyAccJerkMag_Time_Domain_Body_Scalar_Linear_Jerk_from_Accelerometer-",x=feature.labels,fixed=TRUE)
        feature.labels<-gsub(pattern="tBodyGyroMag-",replacement="tBodyGyroMag_Time_Domain_Body_Scalar_Angular_Acceleration_from_Gyroscope-",x=feature.labels,fixed=TRUE)
        feature.labels<-gsub(pattern="tBodyGyroJerkMag-",replacement="tBodyGyroJerkMag_Time_Domain_Body_Scalar_Angular_Jerk_from_Gyroscope-",x=feature.labels,fixed=TRUE)
        feature.labels<-gsub(pattern="fBodyAcc-",replacement="fBodyAcc_Frequency_Domain_Body_Vector_Linear_Acceleration_from_Accelerometer-",x=feature.labels,fixed=TRUE)
        feature.labels<-gsub(pattern="fBodyAccJerk-",replacement="fBodyAccJerk_Frequency_Domain_Body_Vector_Linear_Jerk_from_Accelerometer-",x=feature.labels,fixed=TRUE)
        feature.labels<-gsub(pattern="fBodyGyro-",replacement="fBodyGyro_Frequency_Domain_Body_Vector_Angular_Acceleration_from_Gyroscope-",x=feature.labels,fixed=TRUE)
        feature.labels<-gsub(pattern="fBodyAccMag-",replacement="fBodyAccMag_Frequency_Domain_Body_Scalar_Linear_Acceleration_from_Accelerometer-",x=feature.labels,fixed=TRUE)
        feature.labels<-gsub(pattern="fBodyBodyAccJerkMag-",replacement="fBodyBodyAccJerkMag_Frequency_Domain_Body_Scalar_Linear_Jerk_from_Accelerometer-",x=feature.labels,fixed=TRUE)
        feature.labels<-gsub(pattern="fBodyBodyGyroMag-",replacement="fBodyBodyGyroMag_Frequency_Domain_Body_Scalar_Angular_Acceleration_from_Gyroscope-",x=feature.labels,fixed=TRUE)
        feature.labels<-gsub(pattern="fBodyBodyGyroJerkMag-",replacement="fBodyBodyGyroJerkMag_Frequency_Domain_Body_Scalar_Angular_Jerk_from_Gyroscope-",x=feature.labels,fixed=TRUE)
        if (diff(c(0,features.allindices))[1]==1) {
                fortran.format <- "F16"
        } else {
                fortran.format <- paste(as.character((diff(c(0,features.allindices))[1]-1)*16),"X",sep="")
        }
        for (i in diff(features.allindices)) {
                if (i==1) {
                        fortran.format <- c(fortran.format,"F16")
                } else {
                        fortran.format <- c(fortran.format,paste(as.character((i-1)*16),"X",sep=""),"F16")
                }                
        }
        # Read in the test data and merge
        test.subject  <- read.table("test/subject_test.txt",col.names="subject")
        test.activity <- read.table("test/y_test.txt",col.names="actidx")
        test.actlabel <- translate.activity[test.activity[,],][2]
        test.features <- read.fortran("test/X_test.txt",fortran.format,colClasses="numeric")
        names(test.features)<-as.character(feature.labels)
        group <- rep("test",each=dim(test.subject)[1])
        test.dataframe<-cbind(test.subject,test.activity,test.actlabel,group,test.features)
        # clear from space in RAM
        remove(test.features)
        # Read in the train data and merge
        train.subject  <- read.table("train/subject_train.txt",col.names="subject")
        train.activity <- read.table("train/y_train.txt",col.names="actidx")
        train.actlabel <- translate.activity[train.activity[,],][2]
        train.features<-read.fortran("train/X_train.txt",fortran.format,colClasses="numeric")
        names(train.features)<-as.character(feature.labels)
        group <- rep("train",each=dim(train.subject)[1])
        train.dataframe<-cbind(train.subject,train.activity,train.actlabel,group,train.features)
        # clear from space in RAM
        remove(train.features)
        all.dataframe<-rbind(test.dataframe,train.dataframe)
        # clear from space in RAM
        remove(test.dataframe)
        remove(train.dataframe)
        library(reshape2)
        allMelt <- melt(all.dataframe,id=c("subject","activity.label"), measure.vars=as.character(feature.labels))
        means.Melt <- dcast(allMelt, subject+activity.label ~ variable, mean)
        write.table(means.Melt, file="MeltedMeans.txt", sep=",", row.name=FALSE)
        return(means.Melt)
        # Example of how to read the Inertial Signals files; commented out as unnecessary
        # bb<-read.fwf("test/Inertial Signals/body_acc_z_test.txt",widths=rep(16,each=128))
