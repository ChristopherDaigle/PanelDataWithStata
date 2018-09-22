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

reg lwage `Covariates'

