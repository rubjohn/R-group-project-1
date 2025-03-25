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

#import and read E1_ind.csv
E1_ind.csv <-read.csv('E1_ind.csv')$x

#partition dataset into training and testing subsets
loan_train = loan_data[E1_ind.csv,] 
loan_test = loan_data[-E1_ind.csv,]

#use Rpart to create decision tree and plot
loan_status_class <- rpart(loan_status ~ gender + total_income + dti + credit_score + education + employment, method="class", data=loan_train, cp = 0.015)
rpart.plot(loan_status_class, extra = 104, tweak = 1.2)

#create a deliberate error to debug with GenAI (comment out of code after completion)
#loan_status_class_error <- rpart(loan_status ~ gender + total_income + dti + cr3dit_score + education + employment, method="class", data=loan_train, cp = 0.015)


#Examine importance of predictor variables
importance <- loan_status_class$variable.importance
print(importance)


#adjust tweak for plot
rpart.plot(loan_status_class, extra = 104, tweak = 1.3)
# if you see this as the last line - this is the most up to date .R file