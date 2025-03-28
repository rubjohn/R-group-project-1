# Members: Chris Best, Campbell Jones, William Singletary, Allana Green

#install recursive partitioning package
install.packages("rpart")
install.packages("rpart.plot")
install.packages("tidyverse")

#install forest packages
install.packages('caTools')
install.packages('randomForest')

library(rpart)
library(rpart.plot)
library(tidyverse)
# Loading forest package 
library(caTools) 
library(randomForest)

#----------------------------------------------------#

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


#adjust tweak for plot for better visualization and add title
rpart.plot(loan_status_class, main = "Loan Risk/Approval Determination", extra = 104, tweak = 1.1)

#compute impurity and adjusting extra argument
rpart.plot(loan_status_class, main = "Loan Risk/Approval Determination", extra = 1, tweak = 1.1)


#predict outcome based on testing subset and produce confusion matrix
loan_predict <- predict(loan_status_class, loan_test, type="class")
table(loan_predict, loan_test$loan_status)

#--------------------------------------------------------------------#

##create tree without credit score##

#use Rpart to create decision tree and plot
loan_status_class_no_credit <- rpart(loan_status ~ gender + total_income + dti + education + employment, method="class", data=loan_train, cp = 0.015)
rpart.plot(loan_status_class_no_credit, extra = 104, tweak = 1.2)

#predict outcome based on testing subset and produce confusion matrix
loan_predict_no_credit <- predict(loan_status_class_no_credit, loan_test, type="class")
table(loan_predict_no_credit, loan_test$loan_status)

#--------------------------------------------------------------------#

## iterate through loans and see if results differ in each tree ##
# Function to predict loan status using a tree model
predict_loan_status <- function(tree_model, record) {
  predict(tree_model, newdata = record, type = "class")
}

# Iterate through each row in the dataset
for (i in 1:nrow(loan_data)) {
  record <- loan_data[i, ]
  
  # Predict loan status with both trees
  prediction_with_credit_score <- predict_loan_status(loan_status_class, record)
  prediction_without_credit_score <- predict_loan_status(loan_status_class_no_credit, record)
  
  # Check if predictions differ
  if (prediction_with_credit_score != prediction_without_credit_score) {
    print(paste("Record ID:", loan_data$loan_id[i]))
    print("Record Details:")
    print(loan_data[i, ])
    print(paste("Prediction with credit score:", prediction_with_credit_score))
    print(paste("Prediction without credit score:", prediction_without_credit_score))
    break # Stop after finding the first different record
  }
}

#--------------------------------------------------------------------#

# omit empty records for random forest
loan_train_RF <- na.omit(loan_train)
loan_test_RF <- na.omit(loan_test)

# convert target variable to a factor for classification 
loan_train_RF$loan_status <- as.factor(loan_train_RF$loan_status)
loan_test_RF$loan_status <- as.factor(loan_test_RF$loan_status)

# run the random forest model
set.seed(2024) # for reproducibility
loan_RF <- randomForest(loan_status ~ gender + total_income + dti + education + employment + total_loan, data = loan_train_RF, ntree = 400, mtry = 3) 

# compute importance of the variables and compare with importance from tree without credit score
importance(loan_RF)
importance_no_credit <- loan_status_class_no_credit$variable.importance
print(importance_no_credit)

# plot OBD error
plot(loan_RF, main = "OOB Error Rate for Loan Random Forest")

<<<<<<< HEAD
# Predict class directly on the test set
loan_predict_RF_class <- predict(loan_RF, newdata = loan_test_RF, type = "class")

# Create and print the confusion matrix
cm_RF_class <- table(loan_predict_RF_class, loan_test_RF$loan_status)
print(cm_RF_class)

=======
>>>>>>> 5f969fa35f58ed1b226706e486eb7aeedeb23a16
# if you see this as the last line - this is the most up to date .R file
