clear all
cd ~/Git/PanelDataWithStata/data
use crime, clear

describe

********* Practie for IV-Methods using 2SLS or IV Estimators
****** Model: Crime = beta0+ beta1*Policepc + beta2*LEgalwage + epsilon

reg crime policepc legalwage, robust
estimates store OLS

* OLS estimator policpc is -0.4203287 which means if policepc is increased by one unit, then
* we can find co-movement of crime index decreased by 0.42. But this number does not really
* mean hiring on more policman (per thousand) will only decrease the crime index by 0.42

*
* How can we identify the causal effect of policepc on crime?
* IV Method: 2SLS using IV = (arrestp, legalwage)

* First stage Regression
reg policepc arrestp legalwage, robust
predict policepcHat

* Second Stage Regression
reg crime policepcHat legalwage, robust
estimates store TwoSLS_arrest

estimates table OLS TwoSLS_arrest
* After we compate the OLS and 2SLS, we conclude that the true causal effect is
* -1.04 which is more than twice the OLS estimate in absolute value.

ivregress 2sls crime legalwage (policepc = arrestp), robust
estimates store IV_arrest

estimates table OLS IV_arrest

*** Repear the exercises above usign a different IV
*** 1) convictp and
*** 2) (arrestp, convictp)
*** And compate the results (for policepc) with OLS
