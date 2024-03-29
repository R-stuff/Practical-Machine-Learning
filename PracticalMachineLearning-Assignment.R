# Practical machine learning - Peer Assessment

## Overview

#### This document is the final report of the Peer Assessment project from Coursera???s course Practical Machine Learning, as part of the Specialization in Data Science. It was built up in RStudio, using its knitr functions, meant to be published in html format. This analysis meant to be the basis for the course quiz and a prediction assignment writeup. The main goal of the project is to predict the manner in which 6 participants performed some exercise as described below. This is the ???classe??? variable in the training set. The machine learning algorithm described here is applied to the 20 test cases available in the test data and the predictions are submitted in appropriate format to the Course Project Prediction Quiz for automated grading.

## Background

#### Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement ??? a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, our goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. More information is available from the website here: http://web.archive.org/web/20161224072740/http:/groupware.les.inf.puc-rio.br/har (see the section on the Weight Lifting Exercise Dataset).

## Importing and Exploring the Dataset

#### The training data for this project are available here:
##### https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv

#### The test data are available here:
##### https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv

#### The data for this project come from this source:
##### http://web.archive.org/web/20161224072740/http:/groupware.les.inf.puc-rio.br/har


library(readr)
pml_testing <- read_csv("~/Downloads/pml-testing.csv", na=c("NA",""))
pml_training <- read_csv("~/Downloads/pml-training.csv", na=c("NA",""))


dim(pml_testing)
dim(pml_training)

str(pml_training, list.len = 20)
table(pml_training$classe)
prop.table(table(pml_training$classe))


## Cleaning the data 

#### Removing coloums with only NA

pml_training_mod <- pml_training[,!apply(pml_training,2,function(x) any(is.na(x)) )]
pml_testing_mod <- pml_testing[,!apply(pml_testing,2,function(x) any(is.na(x)) )]

#### We can see that coloums 1 to 6 do not have any usefull information for us to use and hence we delete the same
pml_training_mod <- pml_training_mod[,-c(1:7)]
pml_testing_mod <- pml_testing_mod[,-c(1:7)]

## Partitioning, Training and finding the accuracy of the data

#### Here we partition the training data to further into another set of training and validation set. This is done so as to keep the initial testing set exclusive to our final prediction without any biasing.
inTrain <- createDataPartition(pml_training_mod$classe, p = 0.6, list = FALSE)
training <- pml_training_mod[inTrain,]
validation <- pml_training_mod[-inTrain,]

#### We further train the model training set through the random forrest algorithm and predict its accuracy with respect to the validation set we created

modFit <- train(classe~., data = training, method = "rf")
modFit_pred <- predict(modFit, validation)
confusionMatrix(modFit_pred, validation$classe)
confusionMatrix(modFit_pred, validation$classe)$overall[1]

## Concluision

#### From the above results we can see that an accuracy of 99.06% is obtained with the out of sample error of 0.94%. An accuracy of 80% is usually considered optimum and hence we must understand that these results seem too optimistic and thus should also be tested and validated on another set of data for confirming our results. Since at this point we do not have any other data, we can proceed to the final predictions.

## Final Prediction

#### We can do the final prediction of the 'Classe' variable in the initial given testing dataset and test the results in the quiz section.

predict(modFit, pml_testing_mod)












