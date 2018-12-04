/*
Chris Daigle
Panel Data
Week 13
*/

clear all
cls

cd ~/Git/PanelDataWithStata/
use data/mus10data.dta 

keep if year02 == 1
// Simplify the data set with only year 2003. 
describe 
/*
noreast         byte    %8.0g                 = 1 if Northeast
midwest         byte    %8.0g                 = 1 if Midwest
south           byte    %8.0g                 = 1 if South

*/

global location i.noreast i.midwest i.south 
* We want to run Poisson regression of the number of doctor visits
* on the location (where one lives), health insurance status (private/public)
* chronical deases, gender, and income. 
regress docvis $location private chronic female income, robust 
estimates store OLS
poisson docvis $location private chronic female income, robust 
estimates store Poisson 
estimates table OLS Poisson 

* We want to compute the marignal effect of income on the number of
* doctor visit.
* For simplification, let's take out $location 
poisson docvis private chronic female income, robust 
* Compute the mean of covariates of private chronic female income 
qui sum private
scalar m_private = r(mean)

qui sum chronic
scalar m_chronic = r(mean)

qui sum female
scalar m_female = r(mean)

qui sum income
scalar m_income = r(mean)

scalar xb = _b[_cons] + _b[private] * m_private ///
+ _b[chronic] * m_chronic + _b[female] * m_female + _b[income] * m_income

scalar ME_income = exp(xb) * _b[income] 
display ME_income 

* Compute the same quantity using margins 
margins, dydx(income) atmean


/* We want to run Poisson regression of doctor visits on location, health 
insurance status (private/public), chronic diseases, gnder, and income. */
qui poisson docvis $location private chronic female income, r
estimate store Poisson
/* We want to compute the average marginal effect of moving location from 
northeast to south on doctor visits, and compare the result of Poisson model and 
OLS regression */
* 1. OLS Effect?
reg docvis $location private chronic female income, r
scalar OLS_loc = _b[1.south] - _b[1.noreast]

* 2. Poisson Effect?
estimates restore Poisson
* We are going to use the formula on page 13 of the lecture note
gen double xb1 = _b[_cons] + _b[private] * private ///
+ _b[chronic] * chronic + _b[female] * female + _b[income] * income

gen double ME_South = exp(xb1 + _b[1.south])
gen double ME_Noreast = exp(xb1 + _b[1.noreast])

gen double Diff_ME = ME_South - ME_Noreast
qui sum Diff_ME
scalar AME_loc = r(mean)
display "The effect of changing locations from Northeast to South on" ///
"doctor visits measured by OLS is " OLS_loc ", while the effect " ///
"measured by Poisson REgression is " AME_loc "."

************** Motivation of Random Effect logit/probit model ************
clear
use data/union.dta
xtset idcode year
describe
**** We want to figure out how likely a person belongs to a untion
* 1. When we not count on panel structure, a simple logistic regression
logit union age grade south black, vce(robust)

* 2. When we do not count on the non-linear structure
set matsize 11000
*reg union age grade south black i.idcode, vce(robust)

* 3. What about now combining 1 & 2?
*logit union age grade south black i.idcode, vce(robust)
* It is even more pressiong now, because non-linearity + idcode (dummies)

* 4. Solution: Random effect logit model
xtlogit union age grade south black, re vce(robust)

* 4. Solution: Randome effect probit model?
xtprobit union age grade south black, re vce(robust)
