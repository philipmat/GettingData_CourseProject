---
title: "Getting and Cleaning Data - Course Project"
author: "Philip Mateescu"
date: "September 23, 2015"
output: html_document
---

This repo contains the work for the *Getting And Cleaning Data* Coursera course.

It contains the following files of interest:

- *run_analysis.R* - the script that produces the required data when run against the UCI Smartphone data set.
- *tidy_data.txt* - the output of the *run_analysis.R* script. Running the script again will overwrite this file.
- *CodeBook.md* - the code book for the project, it contains information about the content of the *tidy_data.txt* file.

## Running

To run the script, first download the data for the project:  
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

And then unzip it in a folder called **data** in the same folder as the *run_analysis.R* script.

Then source the script and after a few seconds (or more, depending on your hardware) the *tidy_data.txt*
should be produced.

## Worth mentioning

Dear reader, I mean *evaluator* - the *README.Rmd* and *README.html* files might also be of interest. 
I love [RMarkdown]() and instead of commenting out my code - which I do; religiously - I prefer to 
include such R notebooks with my scripts as they often provide a more pleasant experience to
the tersness of code and comments. 

The *README.html* file, which you [can see displayed fully here](), is a window into how I've approached 
this assignment and the natural steps taken to produce the clean data.