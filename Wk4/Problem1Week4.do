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

xtreg lWage `Covariates' m_* i.year, re vce(cluster id)
estimates store Mundlak

* Answer: True

/* QUESTION 16 */
estimates table RE FE Mundlak
