
library(ggplot2)



citibike_daily_weather=read.csv("citibike_daily_weather.csv")

sum(is.na(citibike_daily_weather))
citibike_daily_weather=na.omit(citibike_daily_weather)


train_ind=sample(1:nrow(citibike_daily_weather),0.7*nrow(citibike_daily_weather))
train=citibike_daily_weather[train_ind,c(2,5:14)]
test=citibike_daily_weather[-train_ind,c(2,5:14)]


test_y=test[,1]
test_x=test[,-1]
###################################
#######Linear Regression##########
###################################

linear_model=lm(RENT~.,data=train)
linear_pre_y=predict(linear_model,test_x)

MSE_linear=mean((linear_pre_y-test_y)^2,na.rm = TRUE)

p.step<-qplot((linear_pre_y), (test_y), xlab='Predicted RENT', 
              ylab='Actual RENT', main='Linear Regression')
p.step + annotate("text", x = 1.5, y = 7, label = paste('MSE:',MSE_linear))+geom_abline(slope=1, intercept=0)


# Model 2.Regression with Lasso


library(glmnet)
x_train_lasso=model.matrix(RENT~., train)[,1:(ncol(train)-1)]
y_train_lasso=train$RENT


x_test_lasso=model.matrix(RENT~.,test)[,1:(ncol(test)-1)]
y_test_lasso=test$RENT
grid=10^(-3:3)
#first run lasso on training set and pick the best lambda
cv.out=cv.glmnet(x_train_lasso,y_train_lasso,alpha=1,lambda = grid,nfolds = 5)

bestlam=cv.out$lambda.min

lasso_model=glmnet(x_train_lasso,y_train_lasso,alpha = 1,lambda = bestlam)
lasoo_pred_y=predict(lasso_model,x_test_lasso)

MSE_lasso=mean((lasoo_pred_y-y_test_lasso)^2,na.rm=TRUE)
#summary(lasso.mod)

coef(lasso_model)
p.lasso=qplot(as.numeric(lasoo_pred_y),y_test_lasso,xlab = 'Predicted next quarter Return',
              ylab = 'Actual next quarter Return', main = 'Regression with Lasso' )
p.lasso+annotate("text",x=1.5,y=8,label=paste('MSE:',MSE_lasso))+geom_abline(slope=1,intercept = 0)

MSE_lasso


###################################
#######Regression Tree##########
###################################



library(ISLR)
library(tree)
#set.seed(1)
tree_model=tree(RENT~.,data=train)
plot(tree_model)
text(tree_model,pretty=1)

tree_pred_y=predict(tree_model, test_x)

MSE_tree=mean((test_y-tree_pred_y)^2,na.rm=TRUE)


MSE_tree


##### CROSS VALIDATION #####
cv_model=cv.tree(tree_model)  
plot(cv_model$size,cv_model$dev,type='b')
bestSize=which.min(cv_model$dev)
print(bestSize)
# Prune Tree
prune.tree=prune.tree(tree_model,best=2)  
plot(prune.tree)
text(prune.tree,pretty=0)
pred.prune.tree = predict(prune.tree, newdata=test)
MSE_prune_tree=mean((test_y-pred.prune.tree)^2) 
MSE_prune_tree




###################################
#######Random Forest##########
###################################
library(randomForest)
library(e1071)
library(MASS)
library(caret)


RF_Model=randomForest(RENT~.,data = na.omit(train) ,importance=TRUE, na.rm = TRUE)

RF_Model
yhat_bag=predict(RF_Model,test_x)
MSE_RF=mean((yhat_bag-test_y)^2,na.rm=TRUE)


#running the result
MSE_RF

p.rf<-qplot((yhat_bag), (test_y), xlab='Predicted next quarter Return', 
            ylab='Actual next quarter Return', main='Random Forest')
p.rf + annotate("text", x = 1.5, y = 9, label = paste('MSE:',MSE_RF))+
  annotate("text", x = 1.5, y = 7, label = "")+
  geom_abline(slope=1, intercept=0)

plot(RF_Model, log="y")
varImpPlot(RF_Model,main='Random Forest Importance Table')
varImp(RF_Model)


# Model 5.GBM
#Generalized Boosted Regression Modeling
library(gbm)
gbm_model=gbm(RENT~.,data = train,dist="gaussian",n.tree = 400,shrinkage=0.1, cv.folds = 5)

best.iter <- gbm.perf(gbm_model,method="OOB")


gbm.perf(gbm_model,method="OOB")
print(best.iter)

best.iter <- gbm.perf(gbm_model,method="cv")
print(best.iter)
gbm.perf(gbm_model,method="cv")


sumary_GBM=summary(gbm_model)
sumary_GBM

gbm_pred_y = predict(gbm_model, test, n.tree = 400, type = 'response')
MSE_gbm=mean((gbm_pred_y-test_y)^2,na.rm=TRUE)
MSE_gbm

p.rf<-qplot((gbm_pred_y), (test_y), xlab='Predicted next quarter Return', 
            ylab='Actual next quarter Return', main='Generalized Boosted Regression')
p.rf + annotate("text", x = 1.5, y = 9, label = paste('MSE:',MSE_gbm))+
  annotate("text", x = 1.5, y = 7, label = "")+
  geom_abline(slope=1, intercept=0)



