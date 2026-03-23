# The Impact of SME Financing Structure and Credit Composition on SME Growth - A Quarterly Macroeconomic Analysis of Pakistan’s SME Sector 

## Project Overview

This project analyzes the impact of SME financing structure on economic growth using quarterly macroeconomic data (2016–2024).

Using advanced time series models (SARIMA & SARIMAX), the study evaluates how different credit channels — including trade finance, public sector lending, and borrower base — influence SME growth.

Goal: Identify which financing mechanisms actually drive SME growth and provide data-driven insights for financial decision-making.

## Business Problem

Small and Medium Enterprises (SMEs) are critical for economic development, yet they face limited access to structured financing.

While prior research highlights barriers, there is limited empirical evidence on:

How credit composition affects growth
Which financing channels are most effective

This project bridges that gap using macroeconomic time series analysis.

## Dataset
This project uses secondary data obtained from the official website of the State Bank of Pakistan (SBP).
### Source:
https://www.sbp.org.pk/departments/ihfd-qdr-FReview.htm

The dataset is derived from SBP’s *Quarterly SME Finance Review*, which provides detailed macroeconomic statistics on SME financing, including trade finance, bank lending, and credit composition trends across Pakistan. :contentReference[oaicite:1]{index=1}

All data has been extracted, cleaned, and transformed for research and analytical purposes.
Frequency: Quarterly
Period: 2016 – 2024
Type: Macroeconomic SME financing data
### Key Variables:
Outstanding SME Financing (Target Variable)
Trade Finance
SME Borrowers
Public Sector Commercial Banks
SME Financing (% of Private Sector Credit)
Note: This project is for academic and analytical purposes only. All data rights belong to the State Bank of Pakistan.

## Tech Stack
R
forecast
tseries
ggplot2
dplyr
lmtest
Excel (data source)

## Methodology
### 1. Data Preparation
Cleaned and standardized dataset
Removed outliers using IQR method
Checked multicollinearity using correlation matrix

### 2. Baseline Modeling (OLS)
Built regression model to understand relationships
Conducted diagnostic tests:
Durbin-Watson → autocorrelation detected
Breusch-Pagan → heteroskedasticity present
Shapiro-Francia → normality satisfied

Insight:
Traditional regression assumptions violated → moved to time series models

### 3. Time Series Analysis
Identified:
Non-stationarity (ADF test)
Trend & seasonality (STL decomposition)
Random walk behavior

### 4. Modeling Approach
#### * SARIMA
Captured trend + seasonality
Included drift to account for long-term movement
#### * SARIMAX
Incorporated exogenous variables:
Trade Finance
SME Borrowers
Public Sector Lending
SME Financing Share

## 5. Model Evaluation
MAPE < 5%
MASE < 0.5
Theil’s U = 0.29

# * Forecast closely matched actual values
# * Residuals confirmed as white noise

## Key Insights
### Strong Positive Drivers:
Trade Finance
Public Sector Commercial Banks
SME Financing Share (strongest impact)
### Not Significant:
Number of SME Borrowers

## Key Takeaway
Increasing access to financing alone is not enough — structured and targeted credit allocation drives SME growth.

## Business Impact

This project provides actionable insights for:

1. Financial institutions optimizing SME lending
2. Policymakers designing credit programs
3. Improving financial inclusion strategies

## Visual Output
SARIMA Forecast vs Actual

(Recommended to view in project visuals)

* Forecast aligns closely with actual values
* Prediction intervals capture uncertainty effectively
* Model successfully captures trend and seasonality

## Key Contributions
1. End-to-end time series analysis on real-world data
2. Transition from regression → time series modeling
3. Integration of macroeconomic insights with statistical modeling
4. Business-oriented interpretation of results
   
## Future Improvements
1. Incorporate firm-level SME data
2. Include informal financing channels
3. Enhance model with additional macroeconomic variables

## Author

Nida Muhammad Umer
Aspiring Data Analyst | Economics & Mathematics
