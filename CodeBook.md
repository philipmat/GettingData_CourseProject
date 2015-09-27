---
title: "Getting and Cleaning Data - Course Project"
author: "Philip Mateescu"
date: "September 23, 2015"
output: html_document
---

# Codebook
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.
The goal is to prepare tidy data that can be used for later analysis.

# Data Origin

The data for the source comes from an experiment carried out with a group of 30 volunteers.

Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 
the study captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 

The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

 A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

# Data Set

For this project, with inspiration from the *swirl* excercises on working with *tidyr*, I have chosed a vertical dataset version. 

Due to the number of measurements performed, I believe this solution is move capable of answering 
research questions such as "what's the average mean of jerk in time-domain" 
or "how does the gyroscope measurements compare across the three axis".

## Procedure

The `run_analysis.R` script produces a file called `tidy_data.txt`, which can be easily 
read with `read.table('tidy_data.txt', header=TRUE)`.

## Variable Description

The columns of the dataset hold a measurement for each one of the following variables:

- **subjectid** - the unique identifier of the volunteer;
- **activity.name** - the name of one of the 6 activities performed by each volunteer;
- **measurement.type** - the type of measurement performed by the the sensor. See below for the range of values;
- **measurement.average** - the 

## Data Description

### activity.name
This variable consists of one of:
- **Laying** - the subject was laying
- **Sitting** - the subject was sitting
- **Standing** - the subject was standing
- **Walking** - the subject was walking on a plane field
- **Walking upstairs** - the subject was climbing up the stairs
- **Walking downstairs** - the subject was  climbing down the stairs

### measurement.type

This variable contains one of 66 possible values:
- fBodyAcc.mean.X
- fBodyAcc.mean.Y
- fBodyAcc.mean.Z
- fBodyAcc.std.X
- fBodyAcc.std.Y
- fBodyAcc.std.Z
- fBodyAccJerk.mean.X
- fBodyAccJerk.mean.Y
- fBodyAccJerk.mean.Z
- fBodyAccJerk.std.X
- fBodyAccJerk.std.Y
- fBodyAccJerk.std.Z
- fBodyAccMag.mean
- fBodyAccMag.std
- fBodyBodyAccJerkMag.mean
- fBodyBodyAccJerkMag.std
- fBodyBodyGyroJerkMag.mean
- fBodyBodyGyroJerkMag.std
- fBodyBodyGyroMag.mean
- fBodyBodyGyroMag.std
- fBodyGyro.mean.X
- fBodyGyro.mean.Y
- fBodyGyro.mean.Z
- fBodyGyro.std.X
- fBodyGyro.std.Y
- fBodyGyro.std.Z
- tBodyAcc.mean.X
- tBodyAcc.mean.Y
- tBodyAcc.mean.Z
- tBodyAcc.std.X
- tBodyAcc.std.Y
- tBodyAcc.std.Z
- tBodyAccJerk.mean.X
- tBodyAccJerk.mean.Y
- tBodyAccJerk.mean.Z
- tBodyAccJerk.std.X
- tBodyAccJerk.std.Y
- tBodyAccJerk.std.Z
- tBodyAccJerkMag.mean
- tBodyAccJerkMag.std
- tBodyAccMag.mean
- tBodyAccMag.std
- tBodyGyro.mean.X
- tBodyGyro.mean.Y
- tBodyGyro.mean.Z
- tBodyGyro.std.X
- tBodyGyro.std.Y
- tBodyGyro.std.Z
- tBodyGyroJerk.mean.X
- tBodyGyroJerk.mean.Y
- tBodyGyroJerk.mean.Z
- tBodyGyroJerk.std.X
- tBodyGyroJerk.std.Y
- tBodyGyroJerk.std.Z
- tBodyGyroJerkMag.mean
- tBodyGyroJerkMag.std
- tBodyGyroMag.mean
- tBodyGyroMag.std
- tGravityAcc.mean.X
- tGravityAcc.mean.Y
- tGravityAcc.mean.Z
- tGravityAcc.std.X
- tGravityAcc.std.Y
- tGravityAcc.std.Z
- tGravityAccMag.mean
- tGravityAccMag.std


### measurement.average

All values are in the *(-1, 1)* range and represent the *mean* values of the 
original measurements for each one of the subjects/activities/measurements types.

- For Acceleration (*Acc*), the unit of measure is **m/s^2**;
- For Jerk (*Jerk*), the unit of measure is **m/s^3*;
- For Gyroscope, the unit of measure is **m/s**, representing angular velocity;


## Transformations

The original data has been merged into a singly dataset. 
The features have been read from the *features.txt* file and have been processed to remove 
the `()` indicating a function has been applied and the dashes have been replaced by period 
(to make it easier to possibly turn them into R factors for a transformed dataset).

The name of the activities have been read from *activity_labels.txt* and transform from
all-uppercase into easier to read capitalized words.

Finally, as per project requests, only the columns above have been extracted and the 
**mean** and **std** (standard deviation) measurements from the original dataset 
have been averaged into a single variable by subject, activity, and measurement type.


