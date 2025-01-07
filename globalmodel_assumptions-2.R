library(car)
library(lmtest)
library(skedastic)
library(sandwich)
library(dplyr)
library(outliers)

content <-UKContentment [, c("Influence_Decisions", "Get_On_Well", "Belong", "Drug_Use_And_Selling", "Area", "Overall")]
content$Area <- as.factor(content$Area)

# feel free to remove variables to compare 
reg1 <- lm(Overall~ Influence_Decisions + Get_On_Well + Belong + Drug_Use_And_Selling + Area, data=content)
summary(reg1)

# Create a 2x2 grid of scatterplots
par(mfrow = c(2, 2))

#CHECK FOR OUTLIERS IN REG1:
plot(reg1)

cd <- cooks.distance(reg1)
inflob <- cd[(cd > (3 * mean(cd, na.rm = TRUE)))]
titlesio <- names(inflob)
inflob
#The findings on outliers determine that the majority come from London area, with all 3 most prominent
#pertaining to London (30, 33 and 25)

noutl <- content[names_of_influential,]
content_no_outliers <- content %>% anti_join(noutl)

reg1_no_outliers <- lm(Overall~ Influence_Decisions + Get_On_Well + Belong + Drug_Use_And_Selling + Area, data=content_no_outliers)
summary(reg1_no_outliers)
plot(reg1_no_outliers)
#While the regression model becomes stronger, we have no reason to drop the natural outliers that the data has. Therefore, it is unrecommended to get rid of it

#ASSUMPTIONS FOR REG1:

#1 - LINEARITY 
plot(reg1)

#2 - NORMALITY
plot(reg1)

residuals <- resid(reg1)
hist(residuals)

shapiro.test(residuals)
ks.test(residuals, "pnorm")

#3 - EQUAL VARIANCE
plot(reg1)

gqtest(reg1, order.by=~content$Influence_Decisions+content$Get_On_Well+content$Belong+content$Drug_Use_And_Selling, data=content)
bptest(reg1)
#There is heteroscedascity present in the normal model 

hist(residuals)
#Histogram does not seem that skewed, but the tests are concerning

#4 - INDEPENDENT OBSERVATIONS
durbinWatsonTest(reg1)
dwtest(reg1)

bgtest(Overall~ Influence_Decisions + Get_On_Well + Belong + Drug_Use_And_Selling + Area, data=content)

cor(content [, c("Influence_Decisions", "Get_On_Well", "Belong", "Drug_Use_And_Selling")])
#The observations are independent

#5 - MULTICOLLINEARITY  
#Variance Inflation Factor (VIF) is a measure used to detect multicollinearity in a multiple linear regression model.
vif(reg1)

#TO MITIGATE SOME OF THE FAILED ASSUMPTIONS, WE CALCULATE THE WEIGHTED LEAST SQUARE ERRORS:
#Get weighted residuals
resid(reg1)
fitted(reg1)
wt <- 1 / lm(abs(reg1$residuals) ~ reg1$fitted.values)$fitted.values^2
newmod <- lm(Overall~ Influence_Decisions + Get_On_Well + Belong + Drug_Use_And_Selling + Area, data=content, weights=wt)

summary(newmod)
plot(newmod)

#OUTLIERS FOR NEWMOD:

newcd <- cooks.distance(newmod)
newinflob <- newcd[(newcd > (3 * mean(newcd, na.rm = TRUE)))]
newtitlesio <- names(newinflob)
newinflob

plot(cooks.distance(newmod),ylab="Cook's Distance")
plot(newmod)
#From the plots, we can see that, while there are outliers present, none of them seem to be present outside Cook's distance cut-off, which makes them sufficiently non-influential to be left in. 

#ASSUMPTIONS FOR NEWMOD: 

#1 - LINEARITY
plot(newmod)

#2 - NORMALITY
plot(newmod)
renewmod <- resid(newmod)
hist(renewmod, main = "Histogram for the residuals of the New Model", xlab = "Residuals")

shapiro.test(renewmod)
ks.test(renewmod, "pnorm")

#3 - EQUAL VARIANCE
bptest(newmod)
gqtest(newmod, order.by=~content$Influence_Decisions+content$Get_On_Well+content$Belong+content$Drug_Use_And_Selling, data=content)

#install.packages("skedastic")
goldfeld_quandt(newmod, deflator = "Influence_decisions")
#While the Goldfeld-Quandt test still is not passed, the Breusch-Pagan test gives just about the ability to not reject the null hypothesis

#4 - INDEPENDENT OBSERVATIONS
durbinWatsonTest(newmod)
dwtest(newmod)

#5 - MULTICOLLINEARITY 
vif(newmod)

#ALTERNATIVE SOLUTIONS CONSIDERED TO WORK AROUND FAILED ASSUMPTIONS:

#Try and perform a log transformation on the predictors
logmod<-lm(Overall~ I(log(Influence_Decisions)) + I(log(Get_On_Well)) + I(log(Belong)) + I(log(Drug_Use_And_Selling)) + Area, data=content)
summary(logmod)

plot(logmod)

bptest(logmod)
gqtest(logmod, order.by=~content$Influence_Decisions+content$Get_On_Well+content$Belong+content$Drug_Use_And_Selling, data=content, fraction=70)
#There is still heteroscedascity in the log model

#Try and perform a log transformation on the Overall
logmodov<-lm(I(log(Overall))~ Influence_Decisions + Get_On_Well + Belong + Drug_Use_And_Selling + Area, data=content)
summary(logmodov)

plot(logmodov)

bptest(logmodov)
gqtest(logmodov, order.by=~content$Influence_Decisions+content$Get_On_Well+content$Belong+content$Drug_Use_And_Selling, data=content, fraction=70)
#There is still heteroscedascity in the log model

#Try and perform a log transformation on both sides
logmodall<-lm(I(log(Overall))~ I(log(Influence_Decisions)) + I(log(Get_On_Well)) + I(log(Belong)) + I(log(Drug_Use_And_Selling)) + Area, data=content)
summary(logmodall)

plot(logmodall)

bptest(logmodall)
gqtest(logmodall, order.by=~content$Influence_Decisions+content$Get_On_Well+content$Belong+content$Drug_Use_And_Selling, data=content, fraction=70)
#There is still heteroscedascity in the log model

#Perform Robust standard errors
#install.packages("sandwich")

summary(reg1)
model_robust <- coeftest(reg1, vcov=vcovHC(reg1, type="HC0"))

summary(model_robust)
plot(model_robust)
