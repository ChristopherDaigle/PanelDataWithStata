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

*** Repeat the exercises above usign a different IV
*** 1) convictp and
*** 2) (arrestp, convictp)
*** And compate the results (for policepc) with OLS

* 1
* Manual
qui reg policepc convictp legalwage, robust
predict policepcHat1

qui reg crime policepcHat1 legalwage, robust
estimates store TSLSConvict
* Stata-tic
qui ivregress 2sls crime legalwage (policepc = convictp), robust
estimate store IVConvict

* 2
local Instruments arrestp convictp
* Manual
qui reg policepc `Instruments' legalwage, robust
predict policepcHat2

qui reg crime policepcHat2 legalwage, robust
estimates store TSLSArrestConvict
* Stata-tic
qui ivregress 2sls crime legalwage (policepc = `Instruments'), robust
estimates store IVArrestConvict

estimates table TSLSConvict IVConvict
estimates table TSLSArrestConvict IVArrestConvict

*
******* Test the validity of IVs *****
* 1) when we use only convict
estimates restore IVConvict
// Estimate the error of outcome variable from IV Regression
predict eHatConvict, residuals
// Run the regression on page 38 i nthe notes ('Testing for validity of IV')
reg eHatConvict convictp legalwage, robust

* 2) when we ue both arrest and convict
estimates restore IVArrestConvict
predict eHatArrestConvict, residuals
reg eHatArrestConvict arrestp convictp legalwage, robust
test arrestp convictp

* In practice what you can do:
ivregress gmm crime legalwage (policepc = `Instruments'), robust
estat overid
* and check its p-values
* Can't reject the nullhypothesis that
* The p-value of this J-test(Sargan) test is reported as around 24%, so we fail
* to reject the null hypothesis of our IVs being valid (exogenous)
* 'Null hypothesis is that the IVs are valid'
*
* Check the concept on page 36 - 40 in the lecture notes


* Next Day

