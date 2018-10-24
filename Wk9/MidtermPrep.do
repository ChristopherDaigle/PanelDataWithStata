/* Week 1 Day 1 */
clear all
sysuse auto
list make price mpg trunk headroom foreign in 1/10, noobs
list make price mpg trunk headroom foreign in 1/10
list make price mpg trunk headroom foreign, noobs
list make price mpg trunk headroom foreign
* browse

/* Week 2 Day 1 & 2 */
clear all
sysuse auto

* regress without robust standard errors
regress price mpg trunk headroom
* regress with robust standard errors
regress price mpg trunk headroom, robust

* cls clears the results window
cls
/* Getting started with panel/longitudinal data */
clear all
cd ~/Git/PanelDataWithStata/Wk2
use nlsy3.dta

describe
*browse
* We must set the data by the individuals and the year

xtset id year, yearly
* sort id year

xtsum tincome
* Understanding this: the first is the overall, it is self explanatort
* - I treat each data point as a single piece of data
* The second is between, variation between individuals, it's a cross sections
* of the variation between incomes
* Within is the measurement for each i over time

codebook married

notes: NLSY sample practiced in class on 09/05

/* USING ANOTHER DATA SET */
clear all
cls
use wide.dta

list, noobs

* Change wide format to long format
reshape long inc ue, i(id) j(year)
list, noobs

* Chris Daigle
* Practice Exercise
clear all
use ~/Git/PanelDataWithStata/Wk2/country_happiness.dta

/* Question 1 & 2 */
describe

/* Question 3 */
describe happins

/* Question 4 */
sort happins
list country_name happins in 15

/* Question 5 */
list country_name happins in 1
list country_name happins in 75

/* Question 6 */
*scalar UShap = happins if country_name == "United States"
count if happins > UShap & country_name == "United States"

/* Question 7 */
sum area, detail

/* Question 8 */
sum physicians, detail

/* Question 9 */
sum milspending
sum energyuse_pc

/* Question 10 */
corr happins gdp2002

/* Question 11 */
hist lifesat, bin(7)

/* Question 12 */
twoway scatter happins free_fr_corrupt, mlabel(country_name)
* graph save Graph "/Users/mbair/Git/PanelDataWithStata/Wk2/DaigleGraph.gph"

/* Question 13 */
* Nigeria


/* Week 3 */
*cls
/* Getting started with panel/longitudinal data */
clear all
cd ~/Git/PanelDataWithStata/Wk2
use nlsy3.dta

*xtset id year, yearly

xtreg lincome hgrade tenure age weeksue nevermarried unmarried black hispanic male, fe
clear all
use nlsy3.dta
reg lincome hgrade tenure age weeksue nevermarried unmarried black hispanic male, robust

/* Wrap lines without the view option */
xtreg lincome hgrade tenure age weeksue nevermarried ///
unmarried black hispanic male, fe

quietly reg lincome hgrade tenure age weeksue nevermarried ///
unmarried black hispanic male, robust

estimates store POLS

xtset id year, yearly
quietly xtreg lincome hgrade tenure age weeksue nevermarried ///
unmarried black hispanic male, re

estimates store RE

estimates table POLS RE, se p

* Macro
** Two kinds: Global and Local Macro
///LOCAL MACRO
cls
clear all
cd ~/Git/PanelDataWithStata/Wk2
use nlsy3.dta
*can be any name, doesnt need to be covariates
local Covariates hgrade tenure age weeksue nevermarried unmarried black hispanic male


quietly reg lincome `Covariates', robust
estimates store POLS

quietly xtreg lincome `Covariates', re
estimates store RE

estimates table POLS RE

/* Week 3 D2 */

cls
clear all
cd ~/Git/PanelDataWithStata/Wk2
use nlsy3.dta

local Covariates hgrade tenure age weeksue nevermarried unmarried black hispanic male

local Covariates_1 hgrade tenure age weeksue nevermarried unmarried black hispanic

* Linear regression for the male population only
quietly reg lincome `Covariates_1' if male == 1, robust
estimates store POLS_male

quietly reg lincome `Covariates_1' if male == 0, robust
estimates store POLS_female

estimates table POLS_male POLS_female, p se

local Covariates_2 hgrade tenure age weeksue nevermarried unmarried black

* Linear regression for the male and hispanic only
quietly reg lincome `Covariates_2' if male == 1 & hispanic == 1, robust
estimates store POLS_male_hisp
* Linear regression for the female and nonhispanic only
quietly reg lincome `Covariates_2' if male == 0 & hispanic == 0, robust
estimates store POLS_female_hisp

estimates table POLS_male POLS_male_hisp POLS_female POLS_female_hisp, p

* Estimate the RE effect model with covariates
xtreg lincome `Covariates', re
* Overall is like OLS R-squared
* Between R-2 is the variation over individuals 
* Within R-2 measure power of X on explaining Y over time dimensions
* Rho is the intrapanel correlation
estimates store RE

quietly reg lincome `Covariates', robust
estimates store POLS

estimates table POLS RE, se


/*
Christopher Daigle
Assignment 1 - Due Sep 28
*/
clear all
cd ~/Git/PanelDataWithStata/Wk4
use nls_woold_wide.dta

/* QUESTION 1 */
list, noobs

reshape long wage exper manuf inlf, i(id) j(year)

label variable year "year"
label variable wage "wage"
label variable exper "experience"
label variable inlf "in the labor force"

/* QUESTION 2 */
describe

xtset id year, yearly
xtsum
* The total number of observations including all time-series across all individuals is 3710, and the panel-data consists of 530 panels (individuals) with 7 time periods (except wage and manuf). The number of total variables is 8.
* Answers: 3710, 530, 7, 8

/* QUESTION 3 */
gen lWage = log(wage)

label variable lWage "log of wage"

xtsum
* The standard deviation of lwage across individuals is 0.4446347
* The 'between' standard deviation is what is desired.

/* QUESTION 4 */
gen exper2 = exper ^ 2

label variable exper2 "squared value of experience"

xtsum
* The within standard deviation of exper2 is 10.47248

/* QUESTION 5 */
xtsum

* The number of variables that have non-zero within standard deviations, and thus time-varying, is 6. Also, the number of the time-invariant variables within zero within standard deviations 2.
* Time-variant variables: wage, exper, manuf, inlf, lWage, exper2
* Time-invariant variables: educ, black

* Answers: 6, 2

/* QUESTION 6 */
local Covariates exper exper2 manuf black educ

reg lWage `Covariates' i.year, vce(cluster id)
estimates store POLS
* P-value for manuf is 0.056

* Answer: 0.056

/* QUESTION 7 */
predict hatlw

twoway scatter hatlw exper

/* QUESTION 8 */
xtreg lWage `Covariates' i.year, re
estimates store RE
gen reReg = e(sample)
* The standard error on exper is 0.0144

* Answer: 0.0144

/* QUESTION 9 */
xtreg lWage exper exper2 manuf i.year, fe
estimates store FE
* The estimated coefficient for exper2 is -0.0064 FE

* Answer: -0.0064

/* QUESTION 10 */
estimates table POLS RE FE
* The estimated coef for 'exper' is smaller in RE than in FE.
* reExper = 0.13 < 0.15 = feExper

* Answer: True

/* QUESTION 11 */
tabulate year, gen(iyear)
* The cumulative percentage of the observation in year 85 is 71.43.

* Answer: 71.43

/* QUESTION 12 */
reg D.(lWage exper exper2 manuf iyear*), vce(cluster id) nocons
estimates store FD
* The standard error for the coefficient of exper is 0.0190.

* Answer: 0.0190

/* QUESTION 13 */
estimates table FE FD
* The coef on manuf in FD is 0.0522, smaller than the coef in FE of 0.0587.

* Answer: smaller

/* QUESTION 14 */
hausman FE RE, sigmamore

* Fail to reject the null - the null holds that there is not a systemic difference
* based on the idiosyncratic error (alphi_{i}) being endogenous, P-value is 0.7426

* Answer: isnt, exogenous, 0.7426, cannot

/* QUESTION 15 */
local explain = "exper exper2 manuf iyear1 iyear2 iyear3 iyear4 iyear5 iyear6 iyear7"

foreach var of varlist `explain' {

bysort id: egen m_`var' = mean(`var') if reReg

}

reg lWage `Covariates' i.year m_* , cluster(id)
estimates store Mundlak

* Answer: True

/* QUESTION 16 */
estimates table RE FE Mundlak


clear 
cls
///////////////////////STATA EXERCISE on Sep 12th //////////////////////////////
///////////////////////////////////////////////////////////////////////////////

* Locate the folder of the data set  
clear all
cd ~/Git/PanelDataWithStata/Wk4

* Load the data set 

use nlsy3.dta

* Forming panel structure by individual (id) and time (year)
xtset id year, yearly 

local Covariates hgrade tenure age weeksue nevermarried unmarried black hispanic 
local Covariates_1 hgrade tenure age weeksue nevermarried unmarried black hispanic 
local Covariates_2 hgrade tenure age weeksue nevermarried unmarried black 

* Linear regression for the male population only 
quietly regress lincome `Covariates_1' if male == 1, robust 
estimates store POLS_male


* Linear regression for the male and hispanic population only 
local Covariates_2 hgrade tenure age weeksue nevermarried unmarried black 
regress lincome `Covariates_2' if male == 1 & hispanic == 1  , robust 
estimates store POLS_male_hispanic

* Linear regression for the female and hispanic population only 
quietly regress lincome `Covariates_1' if male == 0, robust 
estimates store POLS_female

* Linear regression for the female and hispanic population only 
quietly regress lincome `Covariates_1' if male == 0 & hispanic == 1, robust 
estimates store POLS_female_hispanic

* Compare the regression results for different set of (sub) samples 
estimates table POLS_male POLS_male_hispanic POLS_female POLS_female_hispanic

////////////////////////////////////////////////////////////////////////////
* Comparison between Pooled OLS and Random Effect Estimation 

quietly reg lincome `Covariates', robust
estimates store POLS_robust 

quietly xtreg lincome `Covariates', re 
estimates store RE

estimates table POLS_robust RE, se

///// Monte Carlo Simulation of R.E. model for Economic Panel Data
cls
clear all
set seed 333


program simulate_re, rclass

drop _all

// Specify the number of N (individuals) in panel data set - make a population of 500 members
set obs 500

// Set the index up to 500
generate id = _n

// Generate data set of income_{it} = education_{it} * 10 + alpha_{i} + e_{it}
// education_{it} ~ N(0,1), aplha_{i} ~ N(0,1), e_{it} ~ N(0,1) All follow a normal distribution

generate alpha = rnormal()
* Make 10 observations of each
expand 10
sort id
* assign each individual a time value
bysort id: generate time = _n

generate education = rnormal() // Generate education variable
generate e = rnormal() // Generate error of e
generate income = education * 10 + alpha + e // generate income variable

xtset id time

// Run a pooled OLS estimator for income on education
qui reg income education, cluster(id)
*estimates store POLS
return scalar beta_pols = _b[education]

// Run a Random Effect estimator for income on education
qui xtreg income education, re
*estimates store RE
return scalar beta_re = _b[education]

*estimates table POLS RE, se p

// Standard effect on RE is smaller than POLS and that indicates that the RE estimator is more efficient than POLS estimator
end

simulate_re
return list

* Simulate (or Run) 500 times
simulate beta_pols = r(beta_pols) beta_re = r(beta_re), reps(500): simulate_re

twoway kdensity beta_pols || kdensity beta_re


/* Week 3 */
*cls
/* Getting started with panel/longitudinal data */
clear all
cd ~/Git/PanelDataWithStata/Wk2
use nlsy3.dta

*xtset id year, yearly

xtreg lincome hgrade tenure age weeksue nevermarried unmarried black hispanic male, fe
clear all
use nlsy3.dta
reg lincome hgrade tenure age weeksue nevermarried unmarried black hispanic male, robust

/* Wrap lines without the view option */
xtreg lincome hgrade tenure age weeksue nevermarried ///
unmarried black hispanic male, fe

quietly reg lincome hgrade tenure age weeksue nevermarried ///
unmarried black hispanic male, robust

estimates store POLS

xtset id year, yearly
quietly xtreg lincome hgrade tenure age weeksue nevermarried ///
unmarried black hispanic male, re

estimates store RE

estimates table POLS RE, se p

* Macro
** Two kinds: Global and Local Macro
///LOCAL MACRO
cls
clear all
cd ~/Git/PanelDataWithStata/Wk2
use nlsy3.dta
*can be any name, doesnt need to be covariates
local Covariates hgrade tenure age weeksue nevermarried unmarried black hispanic male


quietly reg lincome `Covariates', robust
estimates store POLS

quietly xtreg lincome `Covariates', re
estimates store RE

estimates table POLS RE

/* Week 3 D2 */

cls
clear all
cd ~/Git/PanelDataWithStata/Wk2
use nlsy3.dta

local Covariates hgrade tenure age weeksue nevermarried unmarried black hispanic male

local Covariates_1 hgrade tenure age weeksue nevermarried unmarried black hispanic

* Linear regression for the male population only
quietly reg lincome `Covariates_1' if male == 1, robust
estimates store POLS_male

quietly reg lincome `Covariates_1' if male == 0, robust
estimates store POLS_female

estimates table POLS_male POLS_female, p se

local Covariates_2 hgrade tenure age weeksue nevermarried unmarried black

* Linear regression for the male and hispanic only
quietly reg lincome `Covariates_2' if male == 1 & hispanic == 1, robust
estimates store POLS_male_hisp
* Linear regression for the female and nonhispanic only
quietly reg lincome `Covariates_2' if male == 0 & hispanic == 0, robust
estimates store POLS_female_hisp

estimates table POLS_male POLS_male_hisp POLS_female POLS_female_hisp, p

* Estimate the RE effect model with covariates
xtreg lincome `Covariates', re
* Overall is like OLS R-squared
* Between R-2 is the variation over individuals 
* Within R-2 measure power of X on explaining Y over time dimensions
* Rho is the intrapanel correlation
estimates store RE

quietly reg lincome `Covariates', robust
estimates store POLS

estimates table POLS RE, se


/* WEEK 4 */
////////////////////////////////////////////////////////////////////////////
* Comparison between Pooled OLS and Random Effect Estimation 
* NOTE: the pooled OLS with robust standard error: Incorrect method because it assumes the data is independent within each panel (idiosyncratic error, alpha, is in each time period and doesnt change)

quietly reg lincome `Covariates', robust
estimates store POLS_robust 

quietly xtreg lincome `Covariates', re 
estimates store RE

estimates table POLS_robust RE, se

////////////////////////////////////////////////////////////////////////////
* Clustered standard error at individual cluster 
/*
quietly reg lincome `Covariates', cluster(id)
estimates store POLS_robust 

quietly xtreg lincome `Covariates', re 
estimates store RE

estimates table POLS_robust RE, se
*/

///// Monte Carlo Simulation of R.E. model for Economic Panel Data
cls
clear all
set seed 333

/*
program simulate_re, rclass

// Specify the number of N (individuals) in panel data set - make a population of 500 members
set obs 500

// Set the index up to 500
generate id = _n

// Generate data set of income_{it} = education_{it} * 10 + alpha_{i} + e_{it}
// education_{it} ~ N(0,1), aplha_{i} ~ N(0,1), e_{it} ~ N(0,1) All follow a normal distribution

generate alpha = rnormal()
* Make 10 observations of each
expand 10
sort id
* assign each individual a time value
bysort id: generate time = _n

generate education = rnormal() // Generate education variable
generate e = rnormal() // Generate error of e
generate income = education * 10 + alpha + e // generate income variable

xtset id time

// Run a pooled OLS estimator for income on education
reg income education, cluster(id)
estimates store POLS

// Run a Random Effect estimator for income on education
xtreg income education, re
estimates store RE

estimates table POLS RE, se p

// Standard effect on RE is smaller than POLS and that indicates that the RE estimator is more efficient than POLS estimator
end
*/

clear all
cls
cd ~/Git/PanelDataWithStata/Wk2
///////////////////////STATA EXERCISE on Sep 12th //////////////////////////////
///////////////////////////////////////////////////////////////////////////////
set matsize 5000
set maxvar 32767
* Locate the folder of the data set  

* Load the data set 
use nlsy3.dta

* Forming panel structure by individual (id) and time (year)
xtset id year, yearly 

* Both time-varying, time invariant characteristic covariates
local Covariates_all hgrade tenure age weeksue nevermarried unmarried black hispanic 

* Only time-varying covariates
local Covariates_tv hgrade tenure age weeksue

/*
* Run within-estimator for time-varying covariates assuming Homosked. time varying errors
xtreg lincome `Covariates_tv', fe

* Run within-estimator for time-varying covariates without assuming Homosked. time varying errors
xtreg lincome `Covariates_tv', fe cluster(id)
estimates store FE_cl

* Run fixed-effect estimator for time-varying covariates without assuming Homosked. time varying errors
reg lincome `Covariates_tv' i.(id), cluster(id)
*/

* Run within-estimator for time-varying covariates without assuming Homosked. time varying errors
quietly xtreg lincome `Covariates_tv' if male == 1 & hispanic == 1 & married == 1, fe cluster(id)
estimates store Within_Sub_Cl

* Run fixed-effect estimator for time-varying covariates without assuming Homosked. time varying errors
quietly reg lincome `Covariates_tv' i.(id) if male == 1 & hispanic == 1 & married == 1, cluster(id)
estimates store FE_Sub_Cl

* Run First-Difference estimator for time-varying covariates without assuming Homosked. time varying errors
reg D.(lincome `Covariates_tv') if male == 1 & hispanic == 1 & married == 1, cluster(id) nocons
estimates store FD_Sub_Cl

* Compare the results of all three estimators, but do not show the estimations for Dummies (Fixed effect terms)
estimates table Within_Sub_Cl FE_Sub_Cl FD_Sub_Cl, keep(hgrade) se


clear all 
cls
set matsize 5000
set maxvar 32767

///////////////////////STATA EXERCISE on Sep 26th //////////////////////////////
///////////////////////////////////////////////////////////////////////////////
* Locate the folder of the data set  
cd ~/Git/PanelDataWithStata/Wk2

* Load the data set 

*  cd P:\\Econ_Panel_Data
use nlsy3.dta

* Forming panel structure by individual (id) and time (year)
xtset id year, yearly 

* Both time-varying, time-invariant charatersitic covariates
local Covariates_all hgrade tenure age weeksue nevermarried unmarried black hispanic 

* Just time-varying covariates
local Covariates_tv hgrade tenure age weeksue nevermarried unmarried 

/////////////// For male and hispanic samples only ///////////////////////


* 1) Run Within-Estimator for time-varying covariates WITH 
* assuming Homoscedastic time-varying errors 
qui xtreg lincome `Covariates_tv' if male == 1 & hispanic == 1, fe
estimates store Within_Homo

* 2) Run Within-Estimator for time-varying covariates WITHOUT assuming 
* Homoscedastic time-varying errors 
qui xtreg lincome `Covariates_tv' if male == 1 & hispanic == 1, fe cluster(id)
estimates store Within_Hetero

* 3) Run Random-Effect Estimator for time-varying covariates WITHOUT 
* assuming Homoscedastic time-varying errors
qui xtreg lincome `Covariates_tv' if male == 1 & hispanic == 1, re cluster(id)
estimates store RE_Hetero

* 4) Run Fixed-Effect Estimator for time-varying covariates WITH 
* assuming Heteroscedastic time-varying errors 
qui reg lincome `Covariates_tv' i.(id) if male == 1 & hispanic == 1, cluster(id)
*  Interested in mathematical derivation
estimates store FE_Hetero

* 5) Run First-Differenced Estimator for time-varying covariates WITHOUT
* assuming Homoscedastic time-varying errors 
qui reg D.(lincome `Covariates_tv') if male == 1 & hispanic == 1, nocons cluster(id)
estimates store FD_Hetero

** Collect the results at the table 
estimates table RE_Hetero Within_Hetero FE_Hetero FD_Hetero, se drop(i.(id))

* 6) Run Fixed-Effect Estimator plus time dummies for time-varying covariates WITHOUT 
* assuming Homoscedastic time-varying errors 

qui reg lincome `Covariates_tv' i.(id) i.(year) if male == 1 & hispanic == 1, cluster(id)
* Diff-in-Diff regression
qui xtreg lincome `Covariates_tv' i.(year) if male == 1 & hispanic == 1, fe cluster(id)

* Run a Hausman test of checking assumption H_0: E[alpha | X] = 0 (RE)
qui xtreg lincome `Covariates_tv' if male == 1 & hispanic == 1, re
estimates store RE_Homo
* Hausman test only requires Homoscedastic assumption, so we should not have clustering
* option even though that's not correct ...
* Always perform Hausman Test with FE and RE result
hausman Within_Homo RE_Homo, sigmamore
* And the result says we reject/cannot reject the H_0
* If P-level is less than 5%, we must reject the null-hypothesis
* If P-level is greater than 5%, we fail to reject the null-hypothesis
* THIS RESULT SAYS WE MUST REJECT

* Since the data says random effect assumption is incorrect, we must fe/within/fd estimator

* Run a Mundlak Regression to check H_0: E[alpha | X] = 0
reg lincome `Covariates_tv', cluster(id)

local Covariatesm_tv hgradem tenurem agem weeksuem nevermarriedm unmarriedm

foreach var of varlist `Covariates_tv' {

bysort id: egen double `var'm = mean(`var')

}

* Run a Mundlak Regression
reg lincome `Covariates_tv' `Covariatesm_tv', cluster(id)
test `Covariatesm_tv'
* Reject if p-value is small, which it is


* Week 6

clear all
cd ~/Git/PanelDataWithStata/Wk2

/*
use nlsy3.dta

* Define Covariates macro using global variables
global Covariates hgrade tenure age weeksue nevermarried unmarried black hispanic

**** y_it = x_it * beta + alpha_i +e_it
xtset id year, yearly
* RE model: it is basically a Generalized Least Square (GLS) Estimator
xtreg lincome $Covariates, re  cluster(id)
estimates store RE_GLS

* RE model: can be thought as a Maximum Likelihood Estimator (MLE)
	* Assume e_it is normally distributed and independent over i and t
xtgee lincome $Covariates, family(Gaussian) link(identity) corr(exchangeable) vce(robust)
estimates store RE_GEE

* RE model: as a population average model
xtreg lincome $Covariates, pa robust
estimates store RE_PA

estimates table RE_GLS RE_GEE RE_PA

*/

clear all
webuse union

desc

* Ignoring a nonlinear feature of the model:
	* just stick with the linear RE-GLS estimation
xtreg union age grade i.not_smsa south##c.year, re cluster(id)
estimates store UNION_RE
predict Union_hat_RE

* Nonlinear panel model estimated by logistic regression
xtgee union age grade i.not_smsa south##c.year, family(binomial) link(logit) corr(exchangeable)
estimates store UNION_GEE
predict Union_hat_GEE

estimates table UNION_RE UNION_GEE


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

clear all /* clear the existing file or variable in the memory */
capture postclose temp
version 9.0

postfile temp beta_iv using iv_estimate, replace
/* declare the variable names (beta_iv) and the filenames (iv_estimate) of the 
	(new) Stata dataset where the results are to be stored */

/* Simple IV-model
	- IV: Z~N(0,1) which is exogenous
	- Endogenous variable X: X = pi * z (pi is something I can control/regressors)
	- y = beta_0 + beta_1 * X + (0.1*X + eps) (creates endogeneity)
*/

local pi = 0.03
/* If pi = 0 the IV is irrelevant */
	
forvalues i = 1(1)2000 { /* Perform the experiment 1000 times */
drop _all
quietly set obs 200 /* Set up the number of observations as 200 */

generate z = rnormal()

/* Generate the endogenous variable */
generate v_x = rnormal()
generate x = `pi' * z + v_x

generate eps = rnormal()
qui replace eps = 0.1*x + eps

/* Generate the ourcome variable from the structural relationship in line 12 */
generate y = 0 + 1*x + eps /* calibrate model with true value */

* IV regression y on x using z as instruments
quietly ivregress 2sls y (x = z)
post temp (_b[x]) /* Post beta_IV and its standard error (se) for my data*/
display "i = `i' "
}

clear
use iv_estimate /* my data contains the result from the computer
				experiments above*/
histogram beta_iv, normal title("sampling distribution of beta_iv when pi = 0.03")


/*
Chris Daigle
Panel Data
Homework 2
*/

clear all
cd ~/Git/PanelDataWithStata/Wk9
use handguns.dta

/* QUESTION 17 */
gen lVio = log(vio)
gen lMur = log(mur)
gen lRob = log(rob)

reg lVio shall, r
estimates store lnVio

reg lMur shall, r
estimates store lnMur

reg lRob shall, r
estimates store lnRob

estimates table lnVio lnMur lnRob, se
/*
-----------------------------------------------------
    Variable |   lnVio        lnMur        lnRob     
-------------+---------------------------------------
       shall | -.44296458   -.47337245    -.7733207  
             |  .04752832      .048536     .0692623  
       _cons |  6.1349189    1.8975555    4.8730511  
             |  .01930393    .02196062    .02790933  
-----------------------------------------------------
                                         legend: b/se
										 
Respective Rsq:  0.0866, 0.0834, 0.1208

*/

/* QUESTION 18 */
* Answer: significant

/* QUESTION 19 */
reg lVio shall incarc_rate density pop pm1029 avginc, r
estimates store lnVio

reg lMur shall incarc_rate density pop pm1029 avginc, r
estimates store lnMur

reg lRob shall incarc_rate density pop pm1029 avginc, r
estimates store lnRob

estimates table lnVio lnMur lnRob, se
/*
-----------------------------------------------------
    Variable |   lnVio        lnMur        lnRob     
-------------+---------------------------------------
       shall | -.35925366   -.30911962   -.55503445  
             |  .03286292    .03662355    .05004712  
 incarc_rate |  .00186639    .00259001    .00161762  
             |  .00017468    .00016334    .00020154  
     density |  .03108782     .0545724    .12351043  
             |  .01638982    .01389502    .01905669  
         pop |  .04150649     .0400305     .0775622  
             |  .00310188    .00343524    .00552946  
      pm1029 |  .03791489    .11586394    .07580153  
             |  .00987898    .01238357    .01393819  
      avginc |  .02096172   -.04588113    .06367331  
             |   .0056076    .00740598    .00786515  
       _cons |    4.58343   -.17472261    1.9435719  
             |  .22303226    .28610915    .31553183  
-----------------------------------------------------
                                         legend: b/se
Respective Rsq:  0.5459, 0.5541, 0.5593
*/

/* Question 20 */
* Answer: decrease

/* Question 21 */
xtset stateid year, yearly

* Specification 1:
qui reg lMur shall incarc_rate density pop pm1029 avginc, r
estimates store Spec1
* Specification 2:
qui xtreg lMur shall incarc_rate density pop pm1029 avginc, fe vce(cluster stateid)
estimates store Spec2
* Specification 3:
qui xtreg lMur shall incarc_rate density pop pm1029 avginc i.year, fe vce(cluster stateid)
estimates store Spec3

estimates table Spec1 Spec2 Spec3, se
/*
-----------------------------------------------------
    Variable |   Spec1        Spec2        Spec3     
-------------+---------------------------------------
       shall | -.30911962   -.04610303   -.01743589  
             |  .03662355    .03623838    .03889528  
 incarc_rate |  .00259001   -.00033284   -.00010785  
             |  .00016334    .00035835    .00035138  
     density |   .0545724   -.61839789   -.48305309  
             |  .01389502    .21332013    .21918708  
         pop |   .0400305   -.02737177   -.02918315  
             |  .00343524    .02123796    .02092665  
      pm1029 |  .11586394    .04050526    .07004333  
             |  .01238357    .02176583    .02728217  
      avginc | -.04588113     .0267969    .05791779  
             |  .00740598    .01391106    .01627748  
       _cons | -.17472261    1.1995378    .19588593  
             |  .28610915    .56174074    .54648631  
-----------------------------------------------------
                                         legend: b/se
*/

/* QUESTION 23-25 */

clear all 
use AKAM91.dta

/* QUESTION 23 */
global controls AGEQ AGEQSQ MARRIED ENOCENT ESOCENT MIDATL MT NEWENG SOATL WNOCENT WSOCENT SMSA YR20-YR29

ivregress 2sls LWKLYWGE $controls (EDUC = QTR*), robust
estimates store TSLS

/*
Instrumental variables (2SLS) regression          Number of obs   =     20,287
                                                  Wald chi2(22)   =    3598.99
                                                  Prob > chi2     =     0.0000
                                                  R-squared       =     0.1993
                                                  Root MSE        =     .62314

------------------------------------------------------------------------------
             |               Robust
    LWKLYWGE |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
        EDUC |   .0329078    .046503     0.71   0.479    -.0582365     .124052
        AGEQ |   .7281373   .2436568     2.99   0.003     .2505788    1.205696
      AGEQSQ |  -.0081057   .0026803    -3.02   0.002    -.0133591   -.0028524
     MARRIED |    .229956   .0202035    11.38   0.000     .1903579    .2695542
     ENOCENT |    .056168   .0457531     1.23   0.220    -.0335065    .1458426
     ESOCENT |  -.4385438   .1278192    -3.43   0.001    -.6890647   -.1880229
      MIDATL |  -.0046947   .0413368    -0.11   0.910    -.0857133    .0763239
          MT |  -.1597856    .044517    -3.59   0.000    -.2470373    -.072534
      NEWENG |   .0062602   .0497946     0.13   0.900    -.0913354    .1038559
       SOATL |  -.2850775   .1088158    -2.62   0.009    -.4983524   -.0718025
     WNOCENT |  -.1636264   .0470053    -3.48   0.000    -.2557551   -.0714977
     WSOCENT |  -.3442084   .1038618    -3.31   0.001    -.5477738    -.140643
        SMSA |  -.1707901   .0515439    -3.31   0.001    -.2718143   -.0697659
        YR20 |   .0107567    .200223     0.05   0.957    -.3816733    .4031867
        YR21 |  -.0438572   .1828945    -0.24   0.810    -.4023238    .3146094
        YR22 |  -.0940019   .1572613    -0.60   0.550    -.4022285    .2142246
        YR23 |  -.1375326   .1399172    -0.98   0.326    -.4117652       .1367
        YR24 |  -.1536809   .1237526    -1.24   0.214    -.3962316    .0888698
        YR25 |  -.1470972   .1023063    -1.44   0.150    -.3476139    .0534194
        YR26 |  -.1170838   .0828769    -1.41   0.158    -.2795195    .0453519
        YR27 |  -.0919283   .0552381    -1.66   0.096     -.200193    .0163364
        YR28 |  -.0454552   .0354541    -1.28   0.200    -.1149438    .0240335
        YR29 |          0  (omitted)
       _cons |  -11.80571   5.652482    -2.09   0.037    -22.88437   -.7270477
------------------------------------------------------------------------------
Instrumented:  EDUC
Instruments:   AGEQ AGEQSQ MARRIED ENOCENT ESOCENT MIDATL MT NEWENG SOATL
               WNOCENT WSOCENT SMSA YR20 YR21 YR22 YR23 YR24 YR25 YR26 YR27
               YR28 QTR1 QTR2 QTR120 QTR121 QTR122 QTR123 QTR124 QTR125
               QTR126 QTR127 QTR128 QTR220 QTR221 QTR222 QTR223 QTR224
               QTR225 QTR226 QTR227 QTR228 QTR320 QTR321 QTR322 QTR323
               QTR324 QTR325 QTR326 QTR328
*/

global iv QTR1 QTR2 QTR120 QTR121 QTR122 QTR123 QTR124 QTR125 QTR126 QTR127 QTR128 QTR220 QTR221 QTR222 QTR223 QTR224 QTR225 QTR226 QTR227 QTR228 QTR320 QTR321 QTR322 QTR323 QTR324 QTR325 QTR326 QTR328

/* QUESTION 24 */
estat first

regress EDUC $iv $controls, r
test $iv
* Check that the F-stat is about 0.54 like shown in the previous command (not p-value). This number is smaller than 10 which indicates an issue of weak IVs

/* QUESTION 25 */
estimates restore TSLS
estat overid
* From the result of overidentification test (J/Sargan Test), we read the p-value as 0.178 > 0.05 or 0.10 (size of the tests). So, I cannot reject the null hypothesis of exogenous and my data suggests that IVs are (endogenous or exogenous)

ereturn list
return list
scalar dOver = r(df) // Degrees of Over Identification

* Manually computing First-stage F-stat
predict ehatQtr, residual
regress ehatQtr $iv $controls, r

* F-test on IVs checking for validity
test $iv
* You should check the p-value of your F-stat. One issue is Stata report the degree of freedom of F (Chi-sq) dist. as 28, which is incorrect.

* Instead, ask Stata to compute the P-Value based on the correct DoF (27).
display Ftail(dOver, _N, r(F))


// Monte Carlo Simulation of Weak Identification in Linear IV model 

clear all

set seed 333 

global nobs = 100
global rep = 500
global endo = 0.5
global strong = 1
global weak = 0.005


program simulate_weak, rclass

/* x1 : Exogeneous regressor 
   x2  = 1 + x1 + `weak'*z1 + `weak'*z2 + v: Endogeneous regressor
   y   = 1 + x1 - x2 + e 
   Due to the endogeneity e and v are correlated where the value of correlation is
   set as `endo'.   */
   

/* x1 : Exogeneous regressor 
   x2  = 1 + x1 + `strong'*z1 + `strong'*z2 + v: Endogeneous regressor
   y   = 1 + x1 - x2 + e 
   Due to the endogeneity e and v are correlated where the value of correlation is
   set as `endo'.   */


   
end

* Simulate (or Run) the program $replication times 


kdensity b_2SLS_strong, name(Beta_hat_strong_iv) title(Beta_hat_strong_iv)
kdensity b_2SLS_weak if b_2SLS_weak >= -2.5 & b_2SLS_weak <= 1, name(Beta_hat_weak_iv) title(Beta_hat_weak_iv)


* Tyler Terbrusch
* Homework Assignment 2
* Do File - Questions 23-25: Analysis of AKAM91 Dataset
clear all 

use AKAM91.dta
**********

* Question 23: 2SLS Regression

* Creating global macro for control variables: AGEQ AGEQSQ MARRIED 
* Regional dummies: ENOCENT ESOCENT MIDATL MT NEWENG SOATL WNOCENT WSOCENT SMSA; 




**********

* Question 24: Assessing First Stage Regression Results
* 1) Shortcut: postcommand estat 


* 2) Manually compute First-stage F-statistics  
* Create macro for QTR IV's (34 IV's) (QTR* would not run for "test" command)


**********

* Question 25: Assessing Results of Instrumental Validity Test  
* Restore the IV-regress with robust standard errors 

* 1) Shortcut: postcommand estat  


* 2) Manually compute First-stage F-statistics  
* Run Regression of estimated error on IV's and exogenous variables



* F-test on IV's checking for Validity

