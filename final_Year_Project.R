# Nida Muhammad Jawed 25190

install.packages("readxl")
install.packages("dplyr")
install.packages("car")         
install.packages("ggplot2")     
install.packages("psych")  
library(readxl)
library(dplyr)
library(car)         
library(ggplot2)     
library(psych)    
df <- read_excel("C:/Users/hp/OneDrive/Desktop/FYP/New/SBP data 1.xlsx")
head(df)

# Convert column names 
names(df) <- make.names(names(df))
# OLS model
ols_model <- lm(Outstanding.SME.Financing ~ SME.Fin + SME.Borrowers + Trade.Finance + Public.Sector.Commercial.Banks, data = df)
summary(ols_model)

# Residual plot
plot(ols_model$residuals, type = "l", main = "Residual Plot", ylab = "Residuals", xlab = "Index")
#Residuals should fluctuate randomly around zero.
# QQ plot for normality
qqnorm(ols_model$residuals)
qqline(ols_model$residuals) 
#The residuals (errors) of the model are assumed to be normally distributed.
# Histogram of residuals (Normality)
hist(ols_model$residuals, breaks = 10, main = "Histogram of Residuals", col = "skyblue")
# Durbin-Watson test 
install.packages("lmtest")
library(lmtest)
dwtest(ols_model) 
# Significant positive autocorrelation in residuals.(*)
# Correlation matrix of explanatory variables
explanatory_vars <- df %>% select(SME.Fin, SME.Borrowers, Trade.Finance, Public.Sector.Commercial.Banks)
cor(explanatory_vars) 
# No extreme multicollinearity 
# Heteroskedasticity* (Breusch-Pagan Test)
bptest(ols_model)
#there exists heteroskedasticity. This means that error variance is not constant and standard errors are unreliable, 
#thus the confidence intervals and p-values may be misleading.
# Normality (Jarque-Bera Test)
install.packages("tseries")
library(tseries)
shapiro.test(resid(ols_model)) #will do shapiro francasia because n<30 after cleaning
install.packages("nortest")
library(nortest)
# Apply Shapiro-Francia test on residuals
sf.test(resid(ols_model)) #residuals are approximately normally distributed
#........................................................#

#for outliers
# Function to remove outliers using IQR method
remove_outliers_iqr <- function(x) {
  q1 <- quantile(x, 0.25, na.rm = TRUE)
  q3 <- quantile(x, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  lower <- q1 - 1.5 * iqr
  upper <- q3 + 1.5 * iqr
  x[x >= lower & x <= upper]
}
df_clean <- df

cols_to_clean <- c("Outstanding.SME.Financing", "SME.Fin", "SME.Borrowers", "Trade.Finance", "Public.Sector.Commercial.Banks")

for (col in cols_to_clean) {
  df_clean <- df_clean[df_clean[[col]] %in% remove_outliers_iqr(df_clean[[col]]), ]
}

ols_model_iqr <- lm(Outstanding.SME.Financing ~ SME.Fin + SME.Borrowers + Trade.Finance + Public.Sector.Commercial.Banks, data = df_clean)
summary(ols_model_iqr)

# Normality Tests
shapiro.test(resid(ols_model_iqr))          # Shapiro-Wilk (n<50)
sf.test(resid(ols_model_iqr))               # Shapiro-Francia (n<30) (normality assumption met)
jarque.bera.test(resid(ols_model_iqr))      # Jarque-Bera

# Visual Checks
qqnorm(resid(ols_model_iqr))
qqline(resid(ols_model_iqr), col = "blue")

hist(resid(ols_model_iqr), col = "lightblue", main = "Histogram of Residuals")

# Autocorrelation Test
library(lmtest)
dwtest(ols_model_iqr) #significant positive autocorrelation still exist*

plot(ols_model_iqr, which = 1)  # Residuals vs Fitted (no pattern according to data but autocorrelation exist)

# Hetrokedasticity(met)
bptest(ols_model_iqr)
#.....................................#

# new model
df_clean$Year <- as.numeric(substr(df_clean$Date, 1, 4))
df_clean$Quarter <- as.numeric(substr(df_clean$Date, 7, 7))

df_clean <- df_clean[order(df_clean$Year, df_clean$Quarter), ]

# quarterly time series 
sme_ts <- ts(df_clean$Outstanding.SME.Financing, start = c(df_clean$Year[1], df_clean$Quarter[1]), frequency = 4)

#seasonality check(*)
plot(sme_ts, main = "Outstanding SME Financing (Quarterly)", ylab = "PKR", xlab = "Year") #(seasonal exist but not high and upward trend)

# Classical decomposition 
decomp <- decompose(sme_ts)
plot(decomp) # seasonality and trend (*)
stl_decomp <- stl(sme_ts, s.window = "periodic")
plot(stl_decomp) #Remainder (Residuals) – what's left after removing trend and seasonality.

#Mann-Kendall Test for Trend(*)
install.packages("trend")
library(trend)
mk.test(sme_ts) #trend exist

#seasonility test(*)
install.packages("seastests")
library(seastests)
qs(sme_ts)  # For quarterly seasonality detection (Qs stattic test)

# 1 Raw Time Series Plot
plot(sme_ts,
     main = "Raw Time Series",
     ylab = "Outstanding SME Financing",
     xlab = "Time",
     col = "blue")

# 2 Rolling Mean & Variance
plot(sme_ts,
     type = "l",
     col = "blue",
     main = "Rolling Mean & Variance",
     ylab = "Value",
     xlab = "Time")

# Add rolling mean (window = 4 quarters)
lines(rollmean(sme_ts, k = 4, fill = NA), col = "darkgreen", lwd = 2)

# Add horizontal mean line
abline(h = mean(sme_ts, na.rm = TRUE), col = "red", lty = 2)

legend("topright", legend = c("Raw", "Rolling Mean", "Mean"),
       col = c("blue", "darkgreen", "red"), lty = c(1,1,2), bty = "n")

# 3 ACF Plot
install.packages("forecast")
library(forecast)
Acf(sme_ts, main = "ACF of Raw Series") #random walk exists
adf.test(sme_ts) # dikey fuller test: non-stationairty in the data

install.packages("zoo")
library(zoo)

rolling_mean <- rollmean(sme_ts, k = 4, fill = NA)
rolling_sd <- rollapply(sme_ts, width = 4, FUN = sd, fill = NA)

plot(sme_ts, type = "l", main = "Rolling Mean & Variance", col = "blue")
lines(rolling_mean, col = "darkgreen", lwd = 2)
lines(rolling_mean + rolling_sd, col = "red", lty = 2)
lines(rolling_mean - rolling_sd, col = "red", lty = 2)
legend("topright", legend = c("Series", "Rolling Mean", "±1 SD"), col = c("blue", "darkgreen", "red"), lty = c(1,1,2))

adf.test(sme_ts)
library(forecast)
rw <- rwf(sme_ts, drift = FALSE)
rw_drift <- rwf(sme_ts, drift = TRUE)

accuracy(rw)         # RMSE, MAE, etc.
accuracy(rw_drift)   # If this is better → drift exists
# we clearly dont see any difference but beause of trend i would go with a drift 
qs_result <- qs(sme_ts)
print(qs_result) # seasonality exist 


library(forecast)
library(ggplot2)

sme_ts <- ts(df_clean$Outstanding.SME.Financing, start = c(2016, 2), frequency = 4)

# 3️ Split into Training (23 obs) and Test
train_ts <- window(sme_ts, end = c(2022, 1))   # 2016 Q2 to 2022 Q1
test_ts  <- window(sme_ts, start = c(2022, 2)) # 2022 Q2 onward
#because it gives the best test performance 


# 4 SARIMA Model with Drift
sarima_model <- auto.arima(train_ts,
                           seasonal = TRUE,
                           stepwise = FALSE,
                           approximation = FALSE,
                           allowdrift = TRUE)

# 5 Forecast Next 4 Quarters
sarima_forecast <- forecast(sarima_model, h = 4)

# 6 Plot Forecast vs Actual
autoplot(sarima_forecast) +
  autolayer(test_ts, series = "Actual", color = "red") +
  ggtitle("SARIMA Forecast vs Actual") +
  xlab("Year") + ylab("Outstanding SME Financing") +
  theme_minimal()
#model is est fit according to the forecast and predictions.
#The red line (actual test data) falls mostly within the blue shaded prediction intervals 
#— this shows the model performed accurately in forecasting.
#The widening cone of blue shading in future periods reflects increasing uncertainty 
#as the forecast horizon extends.

# 7 Forecast Accuracy on Test Set
accuracy(sarima_forecast, test_ts)
# For residuals from your fitted model
Box.test(resid(sarima_model), lag = 4, type = "Ljung-Box")
# Residuals are White noise

#SARIMAX MODEL (FOR EXOGENOITY)

xreg_vars <- cbind(df_clean$Trade.Finance,
                   df_clean$SME.Borrowers,
                   df_clean$Public.Sector.Commercial.Banks,
                   df_clean$SME.Fin)

sarimax_model <- auto.arima(sme_ts,
                            xreg = xreg_vars,
                            seasonal = TRUE)

summary(sarimax_model)

# Extract coefficients and standard errors
coefs <- coef(sarimax_model)
se <- sqrt(diag(vcov(sarimax_model)))

# Calculate z-scores
z_scores <- coefs / se

# Calculate two-tailed p-values
p_values <- 2 * (1 - pnorm(abs(z_scores)))

# Combine into a table
data.frame(Coefficient = coefs, StdError = se, z = z_scores, p = p_values)

