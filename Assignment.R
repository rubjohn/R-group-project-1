# Members: Chris Best, Campbell Jones, William Singletary, Allana Green

#install recursive partitioning package
install.packages("rpart")
install.packages("rpart.plot")
install.packages("tidyverse")

library(rpart)
library(rpart.plot)
library(tidyverse)

#import loan information
loan_data <- read.csv("loan_application.csv")

#summarize data
summary(loan_data)

#determine loan status counts
summary(as.factor(loan_data$loan_status))











# if you see this as the last line - this is the most up to date .R file