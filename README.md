# Community Contentment and Well-being Analysis

## Overview
This project analyzes the factors affecting overall community contentment using data from various community areas. The analysis includes multiple linear regression models and diagnostic checks to evaluate relationships and meet model assumptions. Various approaches, including weighted least squares and robust standard error estimation, were explored to improve the model's reliability and address any violations of assumptions.

## Dataset
The dataset, `UKContentment`, includes the following variables:
- `Influence_Decisions`: Level of influence individuals have in decision-making.
- `Get_On_Well`: Measure of how well individuals in the community get along.
- `Belong`: Sense of belonging in the community.
- `Drug_Use_And_Selling`: Levels of drug use and selling in the community.
- `Area`: Categorical variable representing different community areas.
- `Overall`: Overall measure of community contentment.

## Key Steps in the Analysis

1. **Regression Analysis**
   - Developed an initial multiple linear regression model to predict `Overall` contentment based on other variables.
   - Used `summary()` to interpret coefficients, significance levels, and overall model performance.

2. **Outlier Detection**
   - Identified influential observations using Cook's Distance.
   - Observed that key outliers belonged to the London area but retained them due to their non-dominant influence on the model.

3. **Model Diagnostics**
   - Checked assumptions of linear regression:
     - **Linearity**: Verified through scatterplots.
     - **Normality**: Tested residuals using the Shapiro-Wilk and Kolmogorov-Smirnov tests.
     - **Equal Variance**: Used the Breusch-Pagan and Goldfeld-Quandt tests.
     - **Independence**: Performed Durbin-Watson and Breusch-Godfrey tests.
     - **Multicollinearity**: Assessed via Variance Inflation Factors (VIF).

4. **Improving the Model**
   - Addressed heteroscedasticity by calculating Weighted Least Squares (WLS).
   - Tested alternative transformations (log transformations on predictors and response variables).
   - Used robust standard error estimation to mitigate the impact of heteroscedasticity.

5. **Validation and Comparison**
   - Validated model performance with diagnostic plots and hypothesis testing.
   - Compared different regression approaches to identify the most reliable model.

## Key Findings
- Influential variables such as `Influence_Decisions` and `Get_On_Well` significantly affect overall community contentment.
- Heteroscedasticity was present but partially mitigated using WLS and robust standard errors.
- While transformations improved certain assumptions, heteroscedasticity remained in some models, requiring further exploration.
- Outliers were retained as they represented natural variations within the dataset.

## How to Run the Code
1. Install the required R packages:
   ```R
   install.packages("car")
   install.packages("lmtest")
   install.packages("skedastic")
   install.packages("sandwich")
   install.packages("dplyr")
   install.packages("outliers")
   ```

2. Load the dataset `UKContentment` and ensure the variables are structured as outlined above.

3. Run the code step-by-step to:
   - Develop initial regression models.
   - Check assumptions and diagnostics.
   - Explore weighted regression and alternative transformations.
   - Compare results and validate findings.

4. Modify variables in the regression formula if needed for specific comparisons or additional analyses.

## Note
- The results are specific to the dataset and may not generalize to other contexts.
- While transformations and weighted regression help address some issues, further investigation into data collection and alternative modeling approaches may provide additional insights.
