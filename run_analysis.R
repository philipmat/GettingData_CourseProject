## A lot of the work in this project is similar to the clean-up performed in the *swirl* exercise
## on cleaning data using *tidyr*.
library(dplyr)
library(tidyr)

## First lets load the activities as there's not much to clean up there.
activities <- read.table('data/activity_labels.txt', sep = ' ', col.names = c('id', 'activityname'))
# print(activities)

## Features, aka what the measurements represent, have the same format, but the data will require
## a bit of post-processing to clean it up.

features <- read.table('data/features.txt', sep = ' ', col.names = c('id', 'feature'))
# print(features)
# head(features)

## Within the `r nrow(features)` rows, the `feature` column looks like a combination of three values: signal domain (time or frequency), signal (e.g. Body Acceleration, Gravity Acceleration), measurement type (mean, max, entropy), and direction, whether axis (X, Y, Z), or band (e.g 1-8, 9-16, etc).
## We'll split this column into those respective columns in two passes: first we split into `signal`, `type`, and `direction` as these use a non alpha-numeric character;
## then we extract the first character from `signal` into `domain` and the rest will remain in `signal`
# features <- features  %>%
#    mutate(longname=feature) %>%
#    separate(feature, into = c('signal', 'type', 'direction'), sep = '[^[:alnum:],]+') %>%
#    separate(signal, into = c('domain', 'signal'), sep = 1)
## features are now tidy
# head(features)

## Data-set specific preparation
## Now let's read the actual test data. The data seems to be fixed width,
## however, not all columns are of equals size: if columns that contain negative values
## are 1 character larger than columns that have only positive values.
## Calculating the precise widths for 561 columns could be tedious.
##
## Instead let's treat the file as if it's a space-separated value list.
## Initial attempts to read the file as is, shows us running into issues as some
## columns are separated by one space, others by two.
##
## So we'll *pre-process* the file, outside of this script, to replace all multiple spaces
## with single spaces, then proceed to read it as a space-separated table.

## Since the *test* and *train* datasets are similar, we'll create a function that is capable
## of reading either.
## *dataset_name* - either *test* or *train*
## *debug* - if true, it reads the small 10X_test.txt as a way to verify the entire code fast.
read_signals <- function(dataset_name, debug = FALSE) {
    folder <- paste('data', dataset_name, sep = '/')
    ## **subject_test.txt** - the id of the volunteer for which the data was collected.
    subjects_file <- paste(folder, '/subject_', dataset_name, '.txt', sep = '')

    ## **y_test.txt** - the activity performed for each of the rows in the **X_test.txt** file.
    activities_file <- paste(folder, '/y_', dataset_name, '.txt', sep = '')

    ## 10X_[test|train].txt is smaller file that allows for fast run through the entire code
    data_file_prefix <- '/X_'
    if (debug) {
        data_file_prefix <- '/10X_'
    }
    data_file <- paste(folder, data_file_prefix, dataset_name, '.txt', sep = '')

    ## There is one column only, and each row matches to one in **X_test.txt**.
    subjects <- read.table(subjects_file, col.names = c('id'))

    ## There is only one column and its values match against the **activities** dataset.
    activities <- read.table(activities_file, col.names = c('id'))

    data <- read.table(data_file, sep = ' ')
    if (debug) {
        ## since we're loading the entire subjects and activities dataset
        ## but a smaller data set, let's sample the same, reduced number
        ## of records.
        subids <- sample(unique(subjects$id), nrow(data), replace=T)
        actids <- sample(unique(activities$id), nrow(data), replace=T)
    } else {
        subids <- subjects$id
        actids <- activities$id
    }
    data <- data %>%
         ## First let's insert one column for each *subject*, *activity*.
         mutate(subjectid=subids, activityid=actids) %>%
         ## now let's gather all the measurements into a column
         gather(key=featureid, value=value, -subjectid, -activityid) %>%
         ## since we didn't supply column names, data.table creates
         ## it's own V1..V561 columns. extract the numeric part
         mutate(featureid=extract_numeric(featureid))

    return(data)
}

## load the two datasets
test_data <- read_signals('test')
train_data <- read_signals('train')

## Assignment Tasks
## Task 1 - Merge the training and the test sets to create one data set.
data <- bind_rows(test_data, train_data)

## Task 2 - Extract only the measurements on the mean and standard deviation for each measurement
## First we get the ids where the feature name contains either *mean* or *avg*.
ids_of_mean_and_average <- grep('(mean|avg)', features$feature)
mean_and_dev <- filter(data, featureid %in% ids_of_mean_and_average)

## Task 3 - Use descriptive activity names to name the activities in the data set.
## That means merging the activities dataset into the mean_and_dev dataset.
mean_and_dev <- merge(mean_and_dev, activities, by.x='activityid', by.y='id')
## And using the feature name for the feature
mean_and_dev <- merge(mean_and_dev, features, by.x='featureid', by.y='id')

### Task 4 - Appropriately label the data set with descriptive variable names.
## Already done in the previous steps
# head(mean_and_dev)

## Task 5 - From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy <- mean_and_dev %>%
     group_by(subjectid, activityname, feature) %>%
     summarize(average=mean(value))


## Write out the tidy data to submit for course analysis.
write.table(tidy, file='tidy_data.txt', row.names = F)



## Let's clean up after ourselves: remove the large dataset from memory
rm(activities, features, test_data, train_data, ids_of_mean_and_average, mean_and_dev, tidy)



