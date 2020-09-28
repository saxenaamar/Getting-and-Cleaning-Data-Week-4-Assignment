
R version 4.0.2 (2020-06-22) -- "Taking Off Again"
Copyright (C) 2020 The R Foundation for Statistical Computing
Platform: x86_64-w64-mingw32/x64 (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> library(dplyr)

Attaching package: ‘dplyr’

The following objects are masked from ‘package:stats’:

    filter, lag

The following objects are masked from ‘package:base’:

    intersect, setdiff, setequal, union

> # read train data
> X_train <- read.table("./train/X_train.txt")
> Y_train <- read.table("./train/Y_train.txt")
> Sub_train <- read.table("./train/subject_train.txt")
> 
> # read test data
> X_test <- read.table("./test/X_test.txt")
> Y_test <- read.table("./test/Y_test.txt")
> Sub_test <- read.table("./test/subject_test.txt")
> 
> # read data description
> variable_names <- read.table("./features.txt")
> 
> # read activity labels
> activity_labels <- read.table("./activity_labels.txt")
> 
> # 1. Merges the training and the test sets to create one data set.
> X_total <- rbind(X_train, X_test)
> Y_total <- rbind(Y_train, Y_test)
> Sub_total <- rbind(Sub_train, Sub_test)
> 
> # 2. Extracts only the measurements on the mean and standard deviation for each measurement.
> selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
> X_total <- X_total[,selected_var[,1]]
> 
> # 3. Uses descriptive activity names to name the activities in the data set
> colnames(Y_total) <- "activity"
> Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))
> activitylabel <- Y_total[,-1]
> 
> # 4. Appropriately labels the data set with descriptive variable names.
> colnames(X_total) <- variable_names[selected_var[,1],2]
> 
> # 5. From the data set in step 4, creates a second, independent tidy data set with the average
> # of each variable for each activity and each subject.
> colnames(Sub_total) <- "subject"
> total <- cbind(X_total, activitylabel, Sub_total)
> total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
Warning messages:
1: `summarise_each_()` is deprecated as of dplyr 0.7.0.
Please use `across()` instead.
This warning is displayed once every 8 hours.
Call `lifecycle::last_warnings()` to see where this warning was generated. 
2: `funs()` is deprecated as of dplyr 0.8.0.
Please use a list of either functions or lambdas: 

  # Simple named list: 
  list(mean = mean, median = median)

  # Auto named with `tibble::lst()`: 
  tibble::lst(mean, median)

  # Using lambdas
  list(~ mean(., trim = .2), ~ median(., na.rm = TRUE))
This warning is displayed once every 8 hours.
Call `lifecycle::last_warnings()` to see where this warning was generated. 
> write.table(total_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)