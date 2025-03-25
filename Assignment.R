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
http://127.0.0.1:29383/graphics/plot_zoom_png?width=722&height=809
#summarize data
summary(loan_data)

#determine loan status counts
summary(as.factor(loan_data$loan_status))

#import and read E1_ind.csv
E1_ind.csv <-read.csv('E1_ind.csv')$x

#partition dataset into training and testing subsets
loan_train = loan_data[E1_ind.csv,] 
loan_test = loan_data[-E1_ind.csv,]

#use Rpart to create decision tree
loan_status_class <- rpart(loan_status ~ gender + total_income + dti + credit_score + education + employment, method="class", data=loan_train, cp = 0.015)
rpart.plot(loan_status_class, tweak = 1.2)
rpart.plot(titanic_tree_class_cp, extra = 104, tweak = 1.2)
rpart.plot(titanic_tree_class_cp, extra = 1, tweak = 1.2)





# if you see this as the last line - this is the most up to date .R file